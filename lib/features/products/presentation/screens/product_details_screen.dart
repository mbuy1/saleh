import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimensions.iconS,
                color: AppTheme.primaryColor,
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
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimensions.iconS,
                color: AppTheme.primaryColor,
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
                child: Icon(
                  Icons.edit,
                  size: AppDimensions.iconS,
                  color: AppTheme.infoColor,
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
                child: Icon(
                  Icons.delete,
                  size: AppDimensions.iconS,
                  color: AppTheme.errorColor,
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
                      const Icon(
                        Icons.monetization_on,
                        color: AppTheme.successColor,
                        size: AppDimensions.iconL,
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
                      Icon(
                        Icons.inventory,
                        color: product.stock > 0
                            ? AppTheme.infoColor
                            : AppTheme.errorColor,
                        size: AppDimensions.iconL,
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
                Icon(
                  product.isActive ? Icons.check_circle : Icons.visibility_off,
                  color: product.isActive
                      ? AppTheme.successColor
                      : AppTheme.textHintColor,
                  size: AppDimensions.iconM,
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
            prefixIcon: const Icon(
              Icons.inventory_2,
              color: AppTheme.textSecondaryColor,
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
            prefixIcon: const Icon(
              Icons.description,
              color: AppTheme.textSecondaryColor,
            ),
            maxLines: 3,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimensions.spacing16),

          // السعر
          MbuyInputField(
            controller: _priceController,
            label: 'السعر (ر.س) *',
            prefixIcon: const Icon(
              Icons.monetization_on,
              color: AppTheme.textSecondaryColor,
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
            prefixIcon: const Icon(
              Icons.inventory,
              color: AppTheme.textSecondaryColor,
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
            prefixIcon: const Icon(
              Icons.image,
              color: AppTheme.textSecondaryColor,
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
                  label: 'إلغاء',
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
                  label: _isSubmitting ? 'جاري الحفظ...' : 'حفظ التعديلات',
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
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: const Icon(
          Icons.image_not_supported,
          size: AppDimensions.iconDisplay,
          color: AppTheme.textHintColor,
        ),
      );
    }

    return Column(
      children: [
        // معرض الصور القابل للتمرير
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalItems,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              // إذا كان الفيديو وهو في النهاية
              if (hasVideo && index == allImages.length) {
                return _buildVideoPlayer();
              }
              // الصور
              return GestureDetector(
                onTap: () => _showFullScreenImage(context, allImages[index]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  child: Image.network(
                    allImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.surfaceColor,
                        child: const Icon(
                          Icons.broken_image,
                          size: AppDimensions.iconDisplay,
                          color: AppTheme.textHintColor,
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
                      ? const Icon(
                          Icons.play_arrow,
                          size: 6,
                          color: Colors.white,
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
        children: [
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
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
              child: Icon(
                _videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// عرض الصورة بالحجم الكامل
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
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
          ),
        ),
      ),
    );
  }
}
