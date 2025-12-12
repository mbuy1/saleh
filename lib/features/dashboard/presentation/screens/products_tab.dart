import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../products/data/products_controller.dart';

/// شاشة المنتجات - Products Tab
/// تعرض قائمة المنتجات الخاصة بالتاجر
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

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'المنتجات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.fontHeadline,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: AppDimensions.iconM),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(productsControllerProvider.notifier).loadProducts(),
        color: AppTheme.accentColor,
        child: isLoading && products.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.accentColor),
              )
            : products.isEmpty
            ? _buildEmptyState(context)
            : _buildProductsList(context, products),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/dashboard/products/add'),
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

  Widget _buildProductsList(BuildContext context, List products) {
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
                    // Status Icon
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImage(dynamic product) {
    return ClipRRect(
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
