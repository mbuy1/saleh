import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/customer_repository.dart';
import '../../data/customer_providers.dart';

/// حالة صفحة تفاصيل المنتج
class ProductDetailsState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? product;
  final int quantity;

  const ProductDetailsState({
    this.isLoading = false,
    this.error,
    this.product,
    this.quantity = 1,
  });

  ProductDetailsState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? product,
    int? quantity,
  }) {
    return ProductDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Controller لصفحة تفاصيل المنتج
class ProductDetailsController extends StateNotifier<ProductDetailsState> {
  final CustomerRepository _repository;
  final String productId;

  ProductDetailsController(this._repository, this.productId)
    : super(const ProductDetailsState());

  Future<void> loadProduct() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final product = await _repository.getProductDetails(productId);
      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void incrementQuantity() {
    final stock = state.product?['stock'] ?? 0;
    if (state.quantity < stock) {
      state = state.copyWith(quantity: state.quantity + 1);
    }
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      state = state.copyWith(quantity: state.quantity - 1);
    }
  }
}

/// Provider لـ ProductDetailsController
final productDetailsControllerProvider =
    StateNotifierProvider.family<
      ProductDetailsController,
      ProductDetailsState,
      String
    >((ref, productId) {
      final repository = ref.watch(customerRepositoryProvider);
      return ProductDetailsController(repository, productId);
    });

/// صفحة تفاصيل المنتج
class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productDetailsControllerProvider(widget.productId).notifier)
          .loadProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailsControllerProvider(widget.productId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.product == null
          ? _buildError()
          : _buildContent(state),
      bottomNavigationBar: state.product != null
          ? _buildBottomBar(state)
          : null,
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('لم يتم العثور على المنتج'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('رجوع'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ProductDetailsState state) {
    final product = state.product!;
    final imageUrl =
        product['main_image_url']?.toString() ??
        product['image_url']?.toString();
    final name = product['name']?.toString() ?? 'منتج';
    final description = product['description']?.toString() ?? '';
    final price = (product['price'] ?? 0).toDouble();
    final comparePrice = product['compare_at_price'] != null
        ? (product['compare_at_price'] as num).toDouble()
        : null;
    final stock = product['stock'] ?? 0;
    final storeName = product['stores']?['name']?.toString() ?? 'متجر';
    final categoryName = product['categories']?['name']?.toString();

    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.primaryColor,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back),
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.favorite_border),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                // TODO: Add to favorites
              },
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.share),
              ),
              onPressed: () {
                // TODO: Share product
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Colors.grey[100],
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    ),
            ),
          ),
        ),

        // Product Info
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Store
                Row(
                  children: [
                    if (categoryName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Icon(Icons.store, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      storeName,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Price
                Row(
                  children: [
                    Text(
                      '${price.toStringAsFixed(2)} ر.س',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    if (comparePrice != null && comparePrice > price) ...[
                      const SizedBox(width: 12),
                      Text(
                        '${comparePrice.toStringAsFixed(2)} ر.س',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${(((comparePrice - price) / comparePrice) * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),

                // Stock
                Row(
                  children: [
                    Icon(
                      stock > 0
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      size: 16,
                      color: stock > 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      stock > 0 ? 'متوفر ($stock قطعة)' : 'غير متوفر',
                      style: TextStyle(
                        color: stock > 0 ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32),

                // Description
                if (description.isNotEmpty) ...[
                  const Text(
                    'وصف المنتج',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Quantity Selector
                const Text(
                  'الكمية',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQuantityButton(
                      Icons.remove,
                      () => ref
                          .read(
                            productDetailsControllerProvider(
                              widget.productId,
                            ).notifier,
                          )
                          .decrementQuantity(),
                    ),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        '${state.quantity}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      Icons.add,
                      () => ref
                          .read(
                            productDetailsControllerProvider(
                              widget.productId,
                            ).notifier,
                          )
                          .incrementQuantity(),
                    ),
                  ],
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }

  Widget _buildBottomBar(ProductDetailsState state) {
    final product = state.product!;
    final price = (product['price'] ?? 0).toDouble();
    final stock = product['stock'] ?? 0;
    final total = price * state.quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Total Price
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإجمالي',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  '${total.toStringAsFixed(2)} ر.س',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Add to Cart Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: stock > 0
                    ? () async {
                        HapticFeedback.mediumImpact();
                        final success = await ref
                            .read(cartControllerProvider.notifier)
                            .addToCart(
                              widget.productId,
                              quantity: state.quantity,
                            );
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تمت الإضافة إلى السلة'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text(
                  'أضف للسلة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
