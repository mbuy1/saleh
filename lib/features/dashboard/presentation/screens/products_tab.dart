import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
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
/// تصميم جديد مطابق لصفحة اختصاراتي
class ProductsTab extends ConsumerStatefulWidget {
  const ProductsTab({super.key});

  @override
  ConsumerState<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<ProductsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header مخصص مثل اختصاراتي
            _buildHeader(context),
            // شريط البحث
            _buildSearchBar(),
            // التبويبات
            _buildTabs(),
            // المحتوى
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 1. المنتجات
                  RefreshIndicator(
                    onRefresh: () => ref
                        .read(productsControllerProvider.notifier)
                        .loadProducts(),
                    color: AppTheme.accentColor,
                    child: isLoading && products.isEmpty
                        ? const SkeletonProductsGrid()
                        : products.isEmpty
                        ? _buildEmptyState(context)
                        : _buildProductsList(
                            context,
                            ref,
                            _filterProducts(products),
                          ),
                  ),
                  // 2. إعدادات المنتجات
                  const ProductSettingsView(),
                  // 3. المخزون
                  _buildQuickAccessPage(
                    context,
                    title: 'إدارة المخزون',
                    subtitle: 'تابع مخزونك، عدّل الكميات، وتلقَّ تنبيهات النقص',
                    icon: Icons.inventory_2_outlined,
                    buttonText: 'فتح إدارة المخزون',
                    onPressed: () => context.push('/dashboard/inventory'),
                  ),
                  // 4. السجلات
                  _buildQuickAccessPage(
                    context,
                    title: 'سجلات النظام',
                    subtitle: 'سجلات المنتجات والمخزون وجميع العمليات',
                    icon: Icons.history_outlined,
                    buttonText: 'فتح السجلات',
                    onPressed: () => context.push('/dashboard/audit-logs'),
                  ),
                  // 5. المحذوفات
                  _buildDeletedProductsTab(),
                ],
              ),
            ),
          ],
        ),
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
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
          const Text(
            'المنتجات',
            style: TextStyle(
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
          decoration: InputDecoration(
            hintText: 'البحث في المنتجات...',
            hintStyle: TextStyle(color: AppTheme.textHintColor),
            prefixIcon: Icon(Icons.search, color: AppTheme.textHintColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.spacing12),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppTheme.primaryColor,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.textSecondaryColor,
        tabs: const [
          Tab(text: 'المنتجات'),
          Tab(text: 'إعدادات المنتجات'),
          Tab(text: 'المخزون'),
          Tab(text: 'السجلات'),
          Tab(text: 'المحذوفات'),
        ],
      ),
    );
  }

  List<dynamic> _filterProducts(List<dynamic> products) {
    if (_searchQuery.isEmpty) return products;
    return products
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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

  /// تبويب المنتجات المحذوفة
  Widget _buildDeletedProductsTab() {
    // قائمة محاكاة للمنتجات المحذوفة
    final deletedProducts = <Map<String, dynamic>>[];

    if (deletedProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppIcons.delete,
                width: 64,
                height: 64,
                colorFilter: ColorFilter.mode(
                  AppTheme.errorColor.withValues(alpha: 0.5),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد منتجات محذوفة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'المنتجات المحذوفة ستظهر هنا\nيمكنك استعادتها خلال 30 يوم',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: AppDimensions.fontBody,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: AppDimensions.paddingM,
              margin: AppDimensions.paddingHorizontalL,
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusM,
                border: Border.all(
                  color: AppTheme.infoColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.info,
                    width: AppDimensions.iconS,
                    height: AppDimensions.iconS,
                    colorFilter: const ColorFilter.mode(
                      AppTheme.infoColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'المنتجات المحذوفة تُحذف نهائياً بعد 30 يوم',
                      style: TextStyle(
                        color: AppTheme.infoColor,
                        fontSize: AppDimensions.fontBody2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: deletedProducts.length,
      itemBuilder: (context, index) {
        final product = deletedProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Icon(Icons.image, color: Colors.grey[400]),
            ),
            title: Text(product['name'] ?? ''),
            subtitle: Text('محذوف منذ ${product['deletedAt'] ?? ''}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.restore, color: AppTheme.successColor),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم استعادة المنتج'),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                  },
                  tooltip: 'استعادة',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: AppTheme.errorColor,
                  ),
                  onPressed: () {
                    _showPermanentDeleteConfirmation(
                      context,
                      product['name'] ?? '',
                    );
                  },
                  tooltip: 'حذف نهائي',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPermanentDeleteConfirmation(
    BuildContext context,
    String productName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف نهائي'),
        content: Text(
          'هل أنت متأكد من حذف "$productName" نهائياً؟\nلا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم الحذف نهائياً'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text(
              'حذف نهائي',
              style: TextStyle(color: Colors.white),
            ),
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
        // التنقل لصفحة تعديل المنتج
        context.push('/dashboard/products/${product.id}');
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
}
