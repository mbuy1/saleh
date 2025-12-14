import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/customer_repository.dart';

/// حالة صفحة تفاصيل المتجر
class StoreDetailsState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? store;
  final List<Map<String, dynamic>> products;
  final bool hasMoreProducts;
  final int currentPage;

  const StoreDetailsState({
    this.isLoading = false,
    this.error,
    this.store,
    this.products = const [],
    this.hasMoreProducts = true,
    this.currentPage = 1,
  });

  StoreDetailsState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? store,
    List<Map<String, dynamic>>? products,
    bool? hasMoreProducts,
    int? currentPage,
  }) {
    return StoreDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      store: store ?? this.store,
      products: products ?? this.products,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Controller لصفحة تفاصيل المتجر
class StoreDetailsController extends StateNotifier<StoreDetailsState> {
  final CustomerRepository _repository;
  final String storeId;

  StoreDetailsController(this._repository, this.storeId)
    : super(const StoreDetailsState());

  Future<void> loadStoreDetails() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final store = await _repository.getStoreDetails(storeId);
      final productsResponse = await _repository.getStoreProducts(storeId);

      state = state.copyWith(
        isLoading: false,
        store: store,
        products: List<Map<String, dynamic>>.from(
          productsResponse['products'] ?? [],
        ),
        hasMoreProducts: productsResponse['hasMore'] ?? false,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMoreProducts() async {
    if (state.isLoading || !state.hasMoreProducts) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.getStoreProducts(
        storeId,
        page: nextPage,
      );

      final newProducts = List<Map<String, dynamic>>.from(
        response['products'] ?? [],
      );

      state = state.copyWith(
        isLoading: false,
        products: [...state.products, ...newProducts],
        hasMoreProducts: response['hasMore'] ?? false,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    state = const StoreDetailsState();
    await loadStoreDetails();
  }
}

/// Provider لـ StoreDetailsController
final storeDetailsControllerProvider =
    StateNotifierProvider.family<
      StoreDetailsController,
      StoreDetailsState,
      String
    >((ref, storeId) {
      final repository = ref.watch(customerRepositoryProvider);
      return StoreDetailsController(repository, storeId);
    });

/// صفحة تفاصيل المتجر
class StoreDetailsScreen extends ConsumerStatefulWidget {
  final String storeId;

  const StoreDetailsScreen({super.key, required this.storeId});

  @override
  ConsumerState<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends ConsumerState<StoreDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(storeDetailsControllerProvider(widget.storeId).notifier)
          .loadStoreDetails();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(storeDetailsControllerProvider(widget.storeId).notifier)
          .loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeDetailsControllerProvider(widget.storeId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(storeDetailsControllerProvider(widget.storeId).notifier)
            .refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar with Store Cover
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
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
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.share),
                  ),
                  onPressed: () {
                    // TODO: Share store
                  },
                ),
                IconButton(
                  onPressed: () => context.push('/profile'),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person_outline),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: state.store != null
                    ? _buildStoreCover(state.store!)
                    : Container(color: AppTheme.primaryColor),
              ),
            ),

            // Store Info
            if (state.store != null) ...[
              SliverToBoxAdapter(child: _buildStoreInfo(state.store!)),
            ],

            // Products Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'المنتجات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${state.products.length} منتج',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            // Products Grid
            if (state.isLoading && state.products.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildProductSkeleton(),
                    childCount: 6,
                  ),
                ),
              )
            else if (state.products.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد منتجات',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= state.products.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _buildProductCard(state.products[index]);
                    },
                    childCount:
                        state.products.length + (state.hasMoreProducts ? 1 : 0),
                  ),
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCover(Map<String, dynamic> store) {
    final coverUrl = store['cover_url']?.toString();
    final logoUrl = store['logo_url']?.toString();

    return Stack(
      fit: StackFit.expand,
      children: [
        // Cover Image
        if (coverUrl != null && coverUrl.isNotEmpty)
          Image.network(
            coverUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: AppTheme.primaryColor),
          )
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Store Logo and Name at bottom
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: logoUrl != null && logoUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          logoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.store,
                                color: AppTheme.primaryColor,
                              ),
                        ),
                      )
                    : const Icon(Icons.store, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store['name']?.toString() ?? 'متجر',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (store['city'] != null)
                      Text(
                        store['city'].toString(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoreInfo(Map<String, dynamic> store) {
    final description = store['description']?.toString();
    final isVerified = store['is_verified'] == true;
    final productsCount = store['products_count'] ?? 0;
    final rating = store['rating']?.toString() ?? '0.0';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icons.inventory_2_outlined,
                '$productsCount',
                'منتج',
              ),
              _buildStatItem(Icons.star, rating, 'تقييم'),
              if (isVerified) _buildStatItem(Icons.verified, 'موثق', 'المتجر'),
            ],
          ),
          if (description != null && description.isNotEmpty) ...[
            const Divider(height: 24),
            const Text(
              'عن المتجر',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
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
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14, width: 80, color: Colors.grey[200]),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 50, color: Colors.grey[200]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final name = product['name']?.toString() ?? 'منتج';
    final price = product['price']?.toString() ?? '0';
    final imageUrl =
        product['main_image_url']?.toString() ??
        product['image_url']?.toString();

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
          // TODO: Navigate to product details
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
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
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  color: AppTheme.primaryColor,
                                  size: 40,
                                ),
                              ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: AppTheme.primaryColor,
                          size: 40,
                        ),
                      ),
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '$price ر.س',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
