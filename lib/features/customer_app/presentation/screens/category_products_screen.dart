import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/customer_providers.dart';
import '../../data/customer_repository.dart';

/// حالة صفحة منتجات الفئة
class CategoryProductsState {
  final bool isLoading;
  final List<Map<String, dynamic>> products;
  final String? error;
  final int page;
  final bool hasMore;

  const CategoryProductsState({
    this.isLoading = false,
    this.products = const [],
    this.error,
    this.page = 1,
    this.hasMore = true,
  });

  CategoryProductsState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? products,
    String? error,
    int? page,
    bool? hasMore,
  }) {
    return CategoryProductsState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Controller لمنتجات الفئة
class CategoryProductsController extends StateNotifier<CategoryProductsState> {
  final CustomerRepository _repository;
  final String categoryId;

  CategoryProductsController(this._repository, this.categoryId)
    : super(const CategoryProductsState());

  Future<void> loadProducts({bool refresh = false}) async {
    if (state.isLoading || (!state.hasMore && !refresh)) return;

    final page = refresh ? 1 : state.page;
    state = state.copyWith(
      isLoading: true,
      error: null,
      products: refresh ? [] : state.products,
    );

    try {
      final products = await _repository.getProducts(
        page: page,
        limit: 20,
        categoryId: categoryId,
      );

      state = state.copyWith(
        isLoading: false,
        products: refresh ? products : [...state.products, ...products],
        page: page + 1,
        hasMore: products.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => loadProducts(refresh: true);
}

/// Provider لـ CategoryProductsController
final categoryProductsControllerProvider =
    StateNotifierProvider.family<
      CategoryProductsController,
      CategoryProductsState,
      String
    >((ref, categoryId) {
      final repository = ref.watch(customerRepositoryProvider);
      return CategoryProductsController(repository, categoryId);
    });

/// صفحة منتجات الفئة
class CategoryProductsScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState
    extends ConsumerState<CategoryProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(categoryProductsControllerProvider(widget.categoryId).notifier)
          .loadProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(categoryProductsControllerProvider(widget.categoryId).notifier)
          .loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      categoryProductsControllerProvider(widget.categoryId),
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(
              categoryProductsControllerProvider(widget.categoryId).notifier,
            )
            .refresh(),
        child: _buildContent(state),
      ),
    );
  }

  Widget _buildContent(CategoryProductsState state) {
    if (state.isLoading && state.products.isEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => _buildProductSkeleton(),
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'لا توجد منتجات في هذه الفئة',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('رجوع'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: state.products.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildProductCard(state.products[index]);
      },
    );
  }

  Widget _buildProductSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 100, color: Colors.grey[200]),
                const SizedBox(height: 8),
                Container(height: 14, width: 60, color: Colors.grey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final name = product['name']?.toString() ?? 'منتج';
    final price = (product['price'] ?? 0).toDouble();
    final imageUrl =
        product['main_image_url']?.toString() ??
        product['image_url']?.toString();
    final storeName = product['stores']?['name']?.toString() ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          final productId = product['id']?.toString();
          if (productId != null) {
            context.push('/product/$productId');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      ),
              ),
            ),
            // معلومات المنتج
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (storeName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        storeName,
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '${price.toStringAsFixed(0)} ر.س',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            final productId = product['id']?.toString();
                            if (productId != null) {
                              ref
                                  .read(cartControllerProvider.notifier)
                                  .addToCart(productId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تمت الإضافة للسلة'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
