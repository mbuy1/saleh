import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../../shared/widgets/exports.dart';
import '../../data/products_controller.dart';
import '../../domain/models/product.dart';

/// شاشة تفاصيل المنتج مع إمكانية التعديل والحذف
class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  bool _isEditing = false;
  bool _isSubmitting = false;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController;

  Product? _currentProduct;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideo(String videoUrl) {
    debugPrint('🎥 [VIDEO] Initializing video: $videoUrl');

    if (_videoController != null) {
      debugPrint('🎥 [VIDEO] Video already initialized');
      return;
    }

    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize()
            .then((_) {
              debugPrint('🎥 [VIDEO] Video initialized successfully');
              if (mounted) {
                setState(() => _isVideoInitialized = true);
              }
            })
            .catchError((error) {
              debugPrint('❌ [VIDEO] Error initializing: $error');
            });
    } catch (e) {
      debugPrint('❌ [VIDEO] Exception: $e');
    }
  }

  @override
  void deactivate() {
    // إيقاف الفيديو عند مغادرة الصفحة
    if (_videoController != null && _videoController!.value.isPlaying) {
      _videoController!.pause();
    }
    super.deactivate();
  }

  void _initializeControllers(Product product) {
    if (_currentProduct?.id != product.id) {
      _currentProduct = product;
      _nameController.text = product.name;
      _descriptionController.text = product.description ?? '';
      _priceController.text = product.price.toStringAsFixed(2);
      _stockController.text = product.stock.toString();
      _imageUrlController.text = product.imageUrl ?? '';
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await ref
          .read(productsControllerProvider.notifier)
          .updateProduct(
            productId: widget.productId,
            name: _nameController.text.trim(),
            price: double.parse(_priceController.text),
            stock: int.parse(_stockController.text),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            imageUrl: _imageUrlController.text.trim().isEmpty
                ? null
                : _imageUrlController.text.trim(),
          );

      if (!mounted) return;

      if (success) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errorMessage =
            ref.read(productsControllerProvider).errorMessage ??
            'فشل تحديث المنتج';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _deleteProduct() async {
    // تأكيد الحذف
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: const Text(
          'هل أنت متأكد من حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);

    try {
      final success = await ref
          .read(productsControllerProvider.notifier)
          .deleteProduct(widget.productId);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // العودة إلى قائمة المنتجات
      } else {
        final errorMessage =
            ref.read(productsControllerProvider).errorMessage ??
            'فشل حذف المنتج';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsControllerProvider);

    debugPrint('📦 [ProductDetails] Looking for product: ${widget.productId}');
    debugPrint(
      '📦 [ProductDetails] Total products in state: ${productsState.products.length}',
    );

    final product = productsState.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => Product(
        id: widget.productId,
        name: 'غير موجود',
        price: 0,
        stock: 0,
        storeId: '',
      ),
    );

    debugPrint('📦 [ProductDetails] Found product: ${product.name}');
    debugPrint('📦 [ProductDetails] imageUrl: ${product.imageUrl}');
    debugPrint('📦 [ProductDetails] media count: ${product.media.length}');
    debugPrint('📦 [ProductDetails] imageUrls: ${product.imageUrls}');
    debugPrint('📦 [ProductDetails] videoUrl: ${product.videoUrl}');

    if (product.name == 'غير موجود') {
      return MbuyScaffold(
        showAppBar: false,
        body: SafeArea(
          child: Column(
            children: [
              _buildSubPageHeader(context, 'المنتج غير موجود'),
              const Expanded(
                child: MbuyEmptyState(
                  icon: Icons.error_outline,
                  title: 'المنتج غير موجود',
                  subtitle: 'لم يتم العثور على المنتج',
                ),
              ),
            ],
          ),
        ),
      );
    }

    _initializeControllers(product);

    return MbuyScaffold(
      showAppBar: false,
      body: SafeArea(
        child: Column(
          children: [
            _buildSubPageHeaderWithActions(
              context,
              _isEditing ? 'تعديل المنتج' : 'تفاصيل المنتج',
              _isEditing,
            ),
            Expanded(
              child: _isEditing
                  ? _buildEditForm(product)
                  : _buildDetailsView(product),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubPageHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: SvgPicture.asset(
                AppIcons.arrowBack,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          const SizedBox(width: AppDimensions.iconM + AppDimensions.spacing16),
        ],
      ),
    );
  }

  Widget _buildSubPageHeaderWithActions(
    BuildContext context,
    String title,
    bool isEditing,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: SvgPicture.asset(
                AppIcons.arrowBack,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          if (!isEditing) ...[
            GestureDetector(
              onTap: () => setState(() => _isEditing = true),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacing8),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withValues(alpha: 0.1),
                  borderRadius: AppDimensions.borderRadiusS,
                ),
                child: SvgPicture.asset(
                  AppIcons.edit,
                  width: AppDimensions.iconS,
                  height: AppDimensions.iconS,
                  colorFilter: const ColorFilter.mode(
                    AppTheme.infoColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            GestureDetector(
              onTap: _deleteProduct,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacing8),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: AppDimensions.borderRadiusS,
                ),
                child: SvgPicture.asset(
                  AppIcons.delete,
                  width: AppDimensions.iconS,
                  height: AppDimensions.iconS,
                  colorFilter: const ColorFilter.mode(
                    AppTheme.errorColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ] else
            const SizedBox(
              width: AppDimensions.iconM + AppDimensions.spacing16,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsView(Product product) {
    // تهيئة الفيديو إذا وجد
    if (product.videoUrl != null && product.videoUrl!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeVideo(product.videoUrl!);
      });
    }

    return SingleChildScrollView(
      padding: AppDimensions.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معرض الصور والفيديو
          _buildMediaGallery(product),
          const SizedBox(height: AppDimensions.spacing24),

          // اسم المنتج
          Text(
            product.name,
            style: const TextStyle(
              fontSize: AppDimensions.fontH2,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),

          // السعر والمخزون
          Row(
            children: [
              Expanded(
                child: MbuyCard(
                  padding: const EdgeInsets.all(AppDimensions.spacing16),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppIcons.monetization,
                        width: AppDimensions.iconL,
                        height: AppDimensions.iconL,
                        colorFilter: const ColorFilter.mode(
                          AppTheme.successColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Text(
                        '${product.price.toStringAsFixed(2)} ر.س',
                        style: const TextStyle(
                          fontSize: AppDimensions.fontH3,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const Text(
                        'السعر',
                        style: TextStyle(
                          fontSize: AppDimensions.fontBody2,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: MbuyCard(
                  padding: const EdgeInsets.all(AppDimensions.spacing16),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppIcons.inventory,
                        width: AppDimensions.iconL,
                        height: AppDimensions.iconL,
                        colorFilter: ColorFilter.mode(
                          product.stock > 0
                              ? AppTheme.infoColor
                              : AppTheme.errorColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Text(
                        product.stock.toString(),
                        style: const TextStyle(
                          fontSize: AppDimensions.fontH3,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const Text(
                        'المخزون',
                        style: TextStyle(
                          fontSize: AppDimensions.fontBody2,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),

          // الحالة
          MbuyCard(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            child: Row(
              children: [
                SvgPicture.asset(
                  product.isActive
                      ? AppIcons.checkCircle
                      : AppIcons.visibilityOff,
                  width: AppDimensions.iconM,
                  height: AppDimensions.iconM,
                  colorFilter: ColorFilter.mode(
                    product.isActive
                        ? AppTheme.successColor
                        : AppTheme.textHintColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.isActive ? 'نشط' : 'غير نشط',
                        style: const TextStyle(
                          fontSize: AppDimensions.fontBody,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const Text(
                        'حالة المنتج',
                        style: TextStyle(
                          fontSize: AppDimensions.fontCaption,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),

          // الوصف
          if (product.description != null && product.description!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MbuySectionTitle(title: 'الوصف'),
                const SizedBox(height: AppDimensions.spacing8),
                MbuyCard(
                  padding: const EdgeInsets.all(AppDimensions.spacing16),
                  child: Text(
                    product.description!,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontBody,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEditForm(Product product) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: AppDimensions.screenPadding,
        children: [
          // اسم المنتج
          MbuyInputField(
            controller: _nameController,
            label: 'اسم المنتج *',
            prefixIcon: SvgPicture.asset(
              AppIcons.inventory2,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppTheme.textSecondaryColor,
                BlendMode.srcIn,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'الرجاء إدخال اسم المنتج';
              }
              if (value.trim().length < 3) {
                return 'يجب أن يكون الاسم 3 أحرف على الأقل';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimensions.spacing16),

          // الوصف
          MbuyInputField(
            controller: _descriptionController,
            label: 'الوصف',
            prefixIcon: SvgPicture.asset(
              AppIcons.description,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppTheme.textSecondaryColor,
                BlendMode.srcIn,
              ),
            ),
            maxLines: 3,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimensions.spacing16),

          // السعر
          MbuyInputField(
            controller: _priceController,
            label: 'السعر (ر.س) *',
            prefixIcon: SvgPicture.asset(
              AppIcons.monetization,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppTheme.textSecondaryColor,
                BlendMode.srcIn,
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'الرجاء إدخال السعر';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'يجب أن يكون السعر أكبر من 0';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimensions.spacing16),

          // المخزون
          MbuyInputField(
            controller: _stockController,
            label: 'المخزون *',
            prefixIcon: SvgPicture.asset(
              AppIcons.inventory,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppTheme.textSecondaryColor,
                BlendMode.srcIn,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'الرجاء إدخال كمية المخزون';
              }
              final stock = int.tryParse(value);
              if (stock == null || stock < 0) {
                return 'يجب أن يكون المخزون 0 أو أكبر';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimensions.spacing16),

          // رابط الصورة
          MbuyInputField(
            controller: _imageUrlController,
            label: 'رابط الصورة',
            prefixIcon: SvgPicture.asset(
              AppIcons.image,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppTheme.textSecondaryColor,
                BlendMode.srcIn,
              ),
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppDimensions.spacing24),

          // أزرار الإجراءات
          Row(
            children: [
              Expanded(
                child: MbuyButton(
                  text: 'إلغاء',
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          setState(() => _isEditing = false);
                          _initializeControllers(product);
                        },
                  type: MbuyButtonType.secondary,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing16),
              Expanded(
                flex: 2,
                child: MbuyButton(
                  text: _isSubmitting ? 'جاري الحفظ...' : 'حفظ التعديلات',
                  onPressed: _isSubmitting ? null : _updateProduct,
                  isLoading: _isSubmitting,
                  icon: Icons.save,
                  type: MbuyButtonType.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// معرض الصور والفيديو
  Widget _buildMediaGallery(Product product) {
    final allImages = product.imageUrls;
    final videoUrl = product.videoUrl;
    final hasVideo = videoUrl != null && videoUrl.isNotEmpty;
    final totalItems = allImages.length + (hasVideo ? 1 : 0);

    // Debug logging
    debugPrint('🖼️ [MediaGallery] Product: ${product.name}');
    debugPrint('🖼️ [MediaGallery] imageUrl: ${product.imageUrl}');
    debugPrint('🖼️ [MediaGallery] media count: ${product.media.length}');
    debugPrint('🖼️ [MediaGallery] allImages: $allImages');
    debugPrint('🖼️ [MediaGallery] videoUrl: $videoUrl');
    debugPrint('🖼️ [MediaGallery] hasVideo: $hasVideo');
    debugPrint('🖼️ [MediaGallery] totalItems: $totalItems');

    if (totalItems == 0) {
      // لا توجد وسائط - عرض placeholder
      return Container(
        height: 350, // زيادة الارتفاع ليكون مربعاً أكثر
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: SvgPicture.asset(
          AppIcons.imageNotSupported,
          width: AppDimensions.iconDisplay,
          height: AppDimensions.iconDisplay,
          colorFilter: const ColorFilter.mode(
            AppTheme.textHintColor,
            BlendMode.srcIn,
          ),
        ),
      );
    }

    return Column(
      children: [
        // معرض الصور القابل للتمرير
        AspectRatio(
          aspectRatio: 1.0, // جعل الحاوية مربعة بالكامل
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalItems,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              // إذا كان الفيديو وهو في النهاية
              if (hasVideo && index == allImages.length) {
                return GestureDetector(
                  behavior:
                      HitTestBehavior.opaque, // جعل المنطقة كاملة قابلة للنقر
                  onTap: () => _showFullScreenGallery(
                    context,
                    allImages,
                    index,
                    videoUrl: videoUrl,
                  ),
                  child: _buildVideoPlayer(),
                );
              }
              // الصور
              return GestureDetector(
                behavior:
                    HitTestBehavior.opaque, // جعل المنطقة كاملة قابلة للنقر
                onTap: () => _showFullScreenGallery(
                  context,
                  allImages,
                  index,
                  videoUrl: hasVideo ? videoUrl : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  child: Image.network(
                    allImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.surfaceColor,
                        child: SvgPicture.asset(
                          AppIcons.brokenImage,
                          width: AppDimensions.iconDisplay,
                          height: AppDimensions.iconDisplay,
                          colorFilter: const ColorFilter.mode(
                            AppTheme.textHintColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        // مؤشرات الصور
        if (totalItems > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalItems, (index) {
              final isVideo = hasVideo && index == allImages.length;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentImageIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? AppTheme.primaryColor
                        : AppTheme.textHintColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: isVideo && _currentImageIndex == index
                      ? SvgPicture.asset(
                          AppIcons.playArrow,
                          width: 6,
                          height: 6,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )
                      : null,
                ),
              );
            }),
          ),
        // عداد الصور
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          hasVideo && _currentImageIndex == allImages.length
              ? 'فيديو'
              : 'صورة ${_currentImageIndex + 1} من ${allImages.length}${hasVideo ? " + فيديو" : ""}',
          style: const TextStyle(
            fontSize: AppDimensions.fontCaption,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  /// مشغل الفيديو
  Widget _buildVideoPlayer() {
    if (!_isVideoInitialized || _videoController == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand, // ملء الحاوية بالكامل
        children: [
          FittedBox(
            fit: BoxFit.cover, // تغطية المساحة بالكامل (مثل الصور)
            child: SizedBox(
              width: _videoController!.value.size.width,
              height: _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          ),
          // زر التشغيل/الإيقاف
          GestureDetector(
            onTap: () {
              setState(() {
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                _videoController!.value.isPlaying
                    ? AppIcons.pause
                    : AppIcons.playArrow,
                width: 40,
                height: 40,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          // زر ملء الشاشة
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                final allImages = widget.productId.isNotEmpty
                    ? ref
                          .read(productsControllerProvider)
                          .products
                          .firstWhere((p) => p.id == widget.productId)
                          .imageUrls
                    : <String>[];
                final videoUrl = ref
                    .read(productsControllerProvider)
                    .products
                    .firstWhere((p) => p.id == widget.productId)
                    .videoUrl;
                _showFullScreenGallery(
                  context,
                  allImages,
                  allImages.length,
                  videoUrl: videoUrl,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.fullscreen,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// عرض معرض الصور والفيديو بالحجم الكامل
  void _showFullScreenGallery(
    BuildContext context,
    List<String> images,
    int initialIndex, {
    String? videoUrl,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenGalleryPage(
          images: images,
          initialIndex: initialIndex,
          videoUrl: videoUrl,
        ),
      ),
    );
  }
}

class _FullScreenGalleryPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String? videoUrl;

  const _FullScreenGalleryPage({
    required this.images,
    required this.initialIndex,
    this.videoUrl,
  });

  @override
  State<_FullScreenGalleryPage> createState() => _FullScreenGalleryPageState();
}

class _FullScreenGalleryPageState extends State<_FullScreenGalleryPage> {
  late PageController _pageController;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    if (widget.videoUrl != null) {
      _initializeVideo();
    }
  }

  void _initializeVideo() {
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
          ..initialize().then((_) {
            if (mounted) {
              setState(() => _isVideoInitialized = true);
              // إذا بدأنا بالفيديو، نشغله
              if (widget.initialIndex == widget.images.length) {
                // _videoController!.play(); // اختياري: التشغيل التلقائي
              }
            }
          });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    // إيقاف الفيديو إذا انتقلنا بعيداً عنه
    if (widget.videoUrl != null &&
        index != widget.images.length &&
        _videoController != null &&
        _videoController!.value.isPlaying) {
      _videoController!.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.images.length + (widget.videoUrl != null ? 1 : 0);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _showControls
          ? AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            )
          : null,
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        behavior: HitTestBehavior.opaque,
        child: PageView.builder(
          itemCount: totalItems,
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            // عرض الفيديو
            if (widget.videoUrl != null && index == widget.images.length) {
              return _buildVideoPage();
            }

            // عرض الصور
            return Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 100,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoPage() {
    if (!_isVideoInitialized || _videoController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // الفيديو يملأ الشاشة مع الحفاظ على النسبة
        Center(
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        ),
        // أزرار التحكم
        if (_showControls)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: IconButton(
                iconSize: 64,
                icon: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                  });
                },
              ),
            ),
          ),
      ],
    );
  }
}
