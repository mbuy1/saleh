import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/skeleton_loading.dart';
import '../../../products/data/products_controller.dart';
import 'product_settings_view.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   صفحة المنتجات - التصميم مثبت ومعتمد                                    ║
// ║   تاريخ التثبيت: 14 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   العناصر المثبتة:                                                        ║
// ║   • تبويبات: منتجاتي، دروب شوبينق، إعدادات المنتجات                       ║
// ║   • عرض المنتجات بشكل قائمة وشبكة                                       ║
// ║   • أزرار التصفية والبحث                                                  ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل التصميم إلا بطلب صريح وواضح من المالك                     ║
// ║   ⛔ DO NOT MODIFY design without EXPLICIT owner request                  ║
// ║                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// شاشة المنتجات - Products Tab
/// تعرض قائمة المنتجات الخاصة بالتاجر
///
/// 🔒 LOCKED DESIGN - تصميم مثبت
/// Last updated: 2025-12-14
class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsControllerProvider);
    final products = productsState.products;
    final isLoading = productsState.isLoading;
    final errorMessage = productsState.errorMessage;

    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusS,
            ),
            action: SnackBarAction(
              label: 'إعادة المحاولة',
              textColor: Colors.white,
              onPressed: () {
                ref.read(productsControllerProvider.notifier).loadProducts();
              },
            ),
          ),
        );
        ref.read(productsControllerProvider.notifier).clearError();
      });
    }

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceColor,
          foregroundColor: AppTheme.textPrimaryColor,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'المنتجات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: AppTheme.primaryColor,
            size: AppDimensions.iconM,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                size: AppDimensions.iconM,
                color: AppTheme.primaryColor,
              ),
              onPressed: () {
                _showSearchDialog(context);
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppTheme.primaryColor,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondaryColor,
            tabs: [
              Tab(text: 'المنتجات'),
              Tab(text: 'إعدادات المنتجات'),
              Tab(text: 'المخزون'),
              Tab(text: 'دروب شوبينق'),
              Tab(text: 'السجلات'),
              Tab(text: 'المحذوفات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. المنتجات
            RefreshIndicator(
              onRefresh: () =>
                  ref.read(productsControllerProvider.notifier).loadProducts(),
              color: AppTheme.accentColor,
              child: isLoading && products.isEmpty
                  ? const SkeletonProductsGrid()
                  : products.isEmpty
                  ? _buildEmptyState(context)
                  : _buildProductsList(context, ref, products),
            ),
            // 2. إعدادات المنتجات
            const ProductSettingsView(),
            // 3. المخزون - صفحة انتقال سريع
            _buildQuickAccessPage(
              context,
              title: 'إدارة المخزون',
              subtitle: 'تابع مخزونك، عدّل الكميات، وتلقَّ تنبيهات النقص',
              icon: Icons.inventory_2_outlined,
              buttonText: 'فتح إدارة المخزون',
              onPressed: () => context.push('/dashboard/inventory'),
            ),
            // 4. دروب شوبينق
            _buildPlaceholderPage('دروب شوبينق'),
            // 5. السجلات - صفحة انتقال سريع
            _buildQuickAccessPage(
              context,
              title: 'سجلات النظام',
              subtitle: 'سجلات المنتجات والمخزون وجميع العمليات',
              icon: Icons.history_outlined,
              buttonText: 'فتح السجلات',
              onPressed: () => context.push('/dashboard/audit-logs'),
            ),
            // 6. المحذوفات
            _buildPlaceholderPage('المنتجات المحذوفة'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showProductTypeSelection(context),
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.white,
          elevation: 4,
          icon: const Icon(Icons.add, size: AppDimensions.iconM),
          label: const Text(
            'إضافة منتج',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontBody,
            ),
          ),
        ),
      ),
    );
  }

  void _showProductTypeSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'اختر نوع المنتج',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProductTypeOption(
                    context,
                    'منتج ملموس',
                    Icons.inventory_2,
                  ),
                  _buildProductTypeOption(
                    context,
                    'خدمة حسب الطلب',
                    Icons.design_services,
                  ),
                  _buildProductTypeOption(
                    context,
                    'أكل ومشروبات',
                    Icons.restaurant,
                  ),
                  _buildProductTypeOption(
                    context,
                    'منتج رقمي',
                    Icons.cloud_download,
                  ),
                  _buildProductTypeOption(
                    context,
                    'مجموعة منتجات',
                    Icons.layers,
                  ),
                  _buildProductTypeOption(
                    context,
                    'حجوزات',
                    Icons.calendar_month,
                  ),
                  _buildProductTypeOption(
                    context,
                    'دروب شوبينق',
                    Icons.import_export,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductTypeOption(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        context.push('/dashboard/products/add', extra: {'productType': title});
      },
    );
  }

  Widget _buildPlaceholderPage(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.construction,
            size: 64,
            color: AppTheme.textHintColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'هذه الصفحة قيد التطوير',
            style: TextStyle(color: AppTheme.textHintColor),
          ),
        ],
      ),
    );
  }

  /// صفحة انتقال سريع للشاشات المعقدة
  Widget _buildQuickAccessPage(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.open_in_new),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppDimensions.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppDimensions.avatarProfile,
              height: AppDimensions.avatarProfile,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: AppDimensions.iconDisplay,
                color: AppTheme.primaryColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            Text(
              'لا توجد منتجات',
              style: TextStyle(
                fontSize: AppDimensions.fontDisplay3,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              'ابدأ بإضافة منتجك الأول',
              style: TextStyle(
                fontSize: AppDimensions.fontBody,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            SizedBox(
              height: AppDimensions.buttonHeightL,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/dashboard/products/add'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing24,
                  ),
                ),
                icon: const Icon(Icons.add, size: AppDimensions.iconS),
                label: const Text(
                  'إضافة منتج',
                  style: TextStyle(
                    fontSize: AppDimensions.fontBody,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(
    BuildContext context,
    WidgetRef ref,
    List products,
  ) {
    return ListView.builder(
      padding: AppDimensions.screenPadding,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: AppDimensions.borderRadiusM,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: AppDimensions.borderRadiusM,
            child: InkWell(
              onTap: () => context.push('/dashboard/products/${product.id}'),
              borderRadius: AppDimensions.borderRadiusM,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                child: Row(
                  children: [
                    // Product Image
                    _buildProductImage(product),
                    const SizedBox(width: AppDimensions.spacing12),
                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimensions.fontBody,
                              color: AppTheme.textPrimaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppDimensions.spacing4),
                          Text(
                            '${product.price.toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontSize: AppDimensions.fontTitle,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentColor,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing4),
                          _buildStockBadge(product.stock),
                        ],
                      ),
                    ),
                    // Status Icon & Actions
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: AppDimensions.avatarS,
                          height: AppDimensions.avatarS,
                          decoration: BoxDecoration(
                            color: product.isActive
                                ? AppTheme.successColor.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            product.isActive
                                ? Icons.check_circle
                                : Icons.visibility_off,
                            color: product.isActive
                                ? AppTheme.successColor
                                : AppTheme.textHintColor,
                            size: AppDimensions.iconS,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: AppTheme.textSecondaryColor,
                          ),
                          onSelected: (value) =>
                              _handleMenuAction(context, ref, value, product),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                _buildMenuItem(
                                  'edit',
                                  Icons.edit,
                                  'تعديل معلومات المنتج',
                                ),
                                _buildMenuItem(
                                  'duplicate',
                                  Icons.copy,
                                  'تكرار المنتج',
                                ),
                                _buildMenuItem(
                                  'edit_stock',
                                  Icons.inventory,
                                  'تعديل المخزون',
                                ),
                                _buildMenuItem(
                                  'hide',
                                  Icons.visibility_off,
                                  'إخفاء المنتج',
                                ),
                                _buildMenuItem(
                                  'share',
                                  Icons.share,
                                  'مشاركة المنتج',
                                ),
                                _buildMenuItem(
                                  'copy_link',
                                  Icons.link,
                                  'نسخ رابط المنتج',
                                ),
                                _buildMenuItem(
                                  'marketing',
                                  Icons.campaign,
                                  'أدوات التسويق',
                                ),
                                const PopupMenuDivider(),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: AppTheme.errorColor,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'حذف المنتج',
                                        style: TextStyle(
                                          color: AppTheme.errorColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String text,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textPrimaryColor),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String value,
    dynamic product,
  ) {
    switch (value) {
      case 'edit':
        // TODO: Implement Edit
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('سيتم تفعيل التعديل قريباً')),
        );
        break;
      case 'duplicate':
        _duplicateProduct(context, ref, product);
        break;
      case 'edit_stock':
        _showEditStockDialog(context, ref, product);
        break;
      case 'hide':
        _hideProduct(context, ref, product);
        break;
      case 'share':
        _shareProduct(context, product);
        break;
      case 'copy_link':
        _copyProductLink(context, product);
        break;
      case 'marketing':
        _showMarketingTools(context, product);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref, product);
        break;
    }
  }

  void _duplicateProduct(BuildContext context, WidgetRef ref, dynamic product) {
    // Copy all data except ID
    // Images, Video, Properties are copied by default (included in media and extraData)
    ref
        .read(productsControllerProvider.notifier)
        .addProduct(
          name: '${product.name} (نسخة)',
          price: product.price,
          stock: product.stock,
          description: product.description,
          imageUrl: product.imageUrl,
          categoryId: product.categoryId,
          media: product.media
              .map<Map<String, dynamic>>(
                (m) => {
                  'media_type': m.mediaType,
                  'url': m.url,
                  'sort_order': m.sortOrder,
                  'is_main': m.isMain,
                },
              )
              .toList(),
          extraData: product.extraData,
        );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تكرار المنتج بنجاح')));
  }

  void _hideProduct(BuildContext context, WidgetRef ref, dynamic product) {
    // Soft hide
    ref
        .read(productsControllerProvider.notifier)
        .updateProduct(productId: product.id, isActive: false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم إخفاء المنتج')));
  }

  void _shareProduct(BuildContext context, dynamic product) {
    // Share public link
    // For now, copy to clipboard and show message
    _copyProductLink(context, product);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم نسخ رابط المشاركة')));
  }

  void _copyProductLink(BuildContext context, dynamic product) {
    final link = 'https://mbuy.sa/products/${product.id}'; // Example link
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم نسخ الرابط')));
  }

  void _showMarketingTools(BuildContext context, dynamic product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أدوات التسويق',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildMarketingOption(context, 'تثبيت المنتج', Icons.push_pin),
              _buildMarketingOption(
                context,
                'دعم ظهور المنتج',
                Icons.trending_up,
              ),
              _buildMarketingOption(context, 'دعم ظهور المتجر', Icons.store),
              _buildMarketingOption(context, 'تثبيت المتجر', Icons.star),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarketingOption(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.primaryColor),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Show duration slider
            Navigator.pop(context);
            _showDurationSlider(context, title);
          },
        ),
        const Divider(),
      ],
    );
  }

  void _showDurationSlider(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        double duration = 1;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$title - المدة: ${duration.round()} يوم',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: duration,
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: duration.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        duration = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم تفعيل $title لمدة ${duration.round()} يوم',
                          ),
                        ),
                      );
                    },
                    child: const Text('تأكيد'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditStockDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic product,
  ) {
    final controller = TextEditingController(text: product.stock.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل المخزون'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'الكمية'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final newStock = int.tryParse(controller.text);
              if (newStock != null) {
                ref
                    .read(productsControllerProvider.notifier)
                    .updateProduct(productId: product.id, stock: newStock);
                Navigator.pop(context);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    dynamic product,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: Text('هل أنت متأكد من حذف "${product.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(productsControllerProvider.notifier)
                  .deleteProduct(product.id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(dynamic product) {
    final hasVideo = product.videoUrl != null;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: AppDimensions.borderRadiusS,
          child: product.imageUrl != null
              ? Image.network(
                  product.imageUrl!,
                  width: AppDimensions.thumbnailL,
                  height: AppDimensions.thumbnailL,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                )
              : _buildPlaceholderImage(),
        ),
        if (hasVideo)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: AppDimensions.iconM,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: AppDimensions.thumbnailL,
      height: AppDimensions.thumbnailL,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.08),
        borderRadius: AppDimensions.borderRadiusS,
      ),
      child: Icon(
        Icons.inventory_2,
        color: AppTheme.primaryColor.withValues(alpha: 0.4),
        size: AppDimensions.iconXL,
      ),
    );
  }

  Widget _buildStockBadge(int stock) {
    final isInStock = stock > 0;
    final isLowStock = stock > 0 && stock <= 10;

    Color bgColor;
    Color textColor;
    String text;

    if (!isInStock) {
      bgColor = AppTheme.errorColor.withValues(alpha: 0.1);
      textColor = AppTheme.errorColor;
      text = 'نفذ المخزون';
    } else if (isLowStock) {
      bgColor = AppTheme.warningColor.withValues(alpha: 0.1);
      textColor = AppTheme.warningColor;
      text = 'المخزون: $stock (منخفض)';
    } else {
      bgColor = AppTheme.successColor.withValues(alpha: 0.1);
      textColor = AppTheme.successColor;
      text = 'المخزون: $stock';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing8,
        vertical: AppDimensions.spacing4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppDimensions.borderRadiusXS,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppDimensions.fontLabel,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusM,
          ),
          title: const Text('البحث عن منتج', textAlign: TextAlign.center),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'اكتب اسم المنتج...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusS,
              ),
            ),
            onSubmitted: (value) {
              Navigator.pop(context);
              if (value.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('البحث عن: $value'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }
}
