import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    // عرض رسالة الخطأ إذا وجدت
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
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
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(productsControllerProvider.notifier).loadProducts(),
        child: isLoading && products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : products.isEmpty
            ? _buildEmptyState(context)
            : _buildProductsList(context, products),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/products/add'),
        icon: const Icon(Icons.add),
        label: const Text('إضافة منتج'),
      ),
    );
  }

  /// عرض حالة فارغة
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 100,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                'لا توجد منتجات',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'ابدأ بإضافة منتجك الأول',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.push('/products/add'),
                icon: const Icon(Icons.add),
                label: const Text('إضافة منتج'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// عرض قائمة المنتجات
  Widget _buildProductsList(BuildContext context, List products) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: product.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.imageUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.inventory_2, color: Colors.blue[700]),
                  ),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${product.price.toStringAsFixed(2)} ر.س'),
                Text(
                  'المخزون: ${product.stock}',
                  style: TextStyle(
                    color: product.stock > 0 ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              product.isActive ? Icons.check_circle : Icons.visibility_off,
              color: product.isActive ? Colors.green : Colors.grey,
            ),
            onTap: () => context.push('/products/${product.id}'),
          ),
        );
      },
    );
  }
}
