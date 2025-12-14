import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'customer_repository.dart';

// ==========================================================================
// Products Providers
// ==========================================================================

/// حالة المنتجات
class ProductsState {
  final List<Map<String, dynamic>> products;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  ProductsState copyWith({
    List<Map<String, dynamic>>? products,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// متحكم المنتجات
class ProductsController extends StateNotifier<ProductsState> {
  final CustomerRepository _repository;
  String? _categoryId;
  String? _storeId;

  ProductsController(this._repository) : super(const ProductsState());

  /// تحميل المنتجات
  Future<void> loadProducts({
    String? categoryId,
    String? storeId,
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    _categoryId = categoryId;
    _storeId = storeId;

    if (refresh) {
      state = const ProductsState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final products = await _repository.getProducts(
        page: 1,
        categoryId: categoryId,
        storeId: storeId,
      );

      state = state.copyWith(
        products: products,
        isLoading: false,
        hasMore: products.length >= 20,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// تحميل المزيد من المنتجات
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;
      final newProducts = await _repository.getProducts(
        page: nextPage,
        categoryId: _categoryId,
        storeId: _storeId,
      );

      state = state.copyWith(
        products: [...state.products, ...newProducts],
        isLoading: false,
        hasMore: newProducts.length >= 20,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// تحديث
  Future<void> refresh() =>
      loadProducts(categoryId: _categoryId, storeId: _storeId, refresh: true);
}

/// Provider للمنتجات
final productsControllerProvider =
    StateNotifierProvider<ProductsController, ProductsState>((ref) {
      final repository = ref.watch(customerRepositoryProvider);
      return ProductsController(repository);
    });

// ==========================================================================
// Stores Providers
// ==========================================================================

/// حالة المتاجر
class StoresState {
  final List<Map<String, dynamic>> stores;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const StoresState({
    this.stores = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  StoresState copyWith({
    List<Map<String, dynamic>>? stores,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return StoresState(
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// متحكم المتاجر
class StoresController extends StateNotifier<StoresState> {
  final CustomerRepository _repository;

  StoresController(this._repository) : super(const StoresState());

  /// تحميل المتاجر
  Future<void> loadStores({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = const StoresState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final stores = await _repository.getStores(page: 1);

      state = state.copyWith(
        stores: stores,
        isLoading: false,
        hasMore: stores.length >= 20,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// تحميل المزيد
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;
      final newStores = await _repository.getStores(page: nextPage);

      state = state.copyWith(
        stores: [...state.stores, ...newStores],
        isLoading: false,
        hasMore: newStores.length >= 20,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// تحديث
  Future<void> refresh() => loadStores(refresh: true);
}

/// Provider للمتاجر
final storesControllerProvider =
    StateNotifierProvider<StoresController, StoresState>((ref) {
      final repository = ref.watch(customerRepositoryProvider);
      return StoresController(repository);
    });

// ==========================================================================
// Categories Providers
// ==========================================================================

/// حالة الفئات
class CategoriesState {
  final List<Map<String, dynamic>> categories;
  final bool isLoading;
  final String? error;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoriesState copyWith({
    List<Map<String, dynamic>>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// متحكم الفئات
class CategoriesController extends StateNotifier<CategoriesState> {
  final CustomerRepository _repository;

  CategoriesController(this._repository) : super(const CategoriesState());

  /// تحميل الفئات
  Future<void> loadCategories() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final categories = await _repository.getCategories();
      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// تحديث
  Future<void> refresh() async {
    state = const CategoriesState(isLoading: true);
    await loadCategories();
  }
}

/// Provider للفئات
final categoriesControllerProvider =
    StateNotifierProvider<CategoriesController, CategoriesState>((ref) {
      final repository = ref.watch(customerRepositoryProvider);
      return CategoriesController(repository);
    });

// ==========================================================================
// Cart Providers
// ==========================================================================

/// عنصر سلة مع تفاصيل المنتج
class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String? storeName;

  const CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.storeName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['products'] as Map<String, dynamic>?;
    return CartItem(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: product?['name'] ?? 'منتج',
      price: (product?['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      imageUrl: product?['main_image_url'] ?? product?['image_url'],
      storeName: product?['stores']?['name'],
    );
  }

  double get total => price * quantity;
}

/// حالة السلة
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  const CartState({this.items = const [], this.isLoading = false, this.error});

  CartState copyWith({List<CartItem>? items, bool? isLoading, String? error}) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get shipping => items.isEmpty ? 0 : 15.0;
  double get total => subtotal + shipping;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

/// متحكم السلة
class CartController extends StateNotifier<CartState> {
  final CustomerRepository _repository;

  CartController(this._repository) : super(const CartState());

  /// تحميل السلة
  Future<void> loadCart() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final cartData = await _repository.getCart();
      final items = cartData.map((item) => CartItem.fromJson(item)).toList();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// إضافة منتج للسلة
  Future<bool> addToCart(String productId, {int quantity = 1}) async {
    try {
      final success = await _repository.addToCart(
        productId: productId,
        quantity: quantity,
      );
      if (success) await loadCart();
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// تحديث كمية
  Future<bool> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) return removeItem(itemId);

    try {
      final success = await _repository.updateCartItem(
        itemId: itemId,
        quantity: quantity,
      );
      if (success) await loadCart();
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// حذف عنصر
  Future<bool> removeItem(String itemId) async {
    try {
      final success = await _repository.removeFromCart(itemId);
      if (success) await loadCart();
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// تفريغ السلة
  Future<bool> clearCart() async {
    try {
      final success = await _repository.clearCart();
      if (success) {
        state = state.copyWith(items: []);
      }
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// Provider للسلة
final cartControllerProvider = StateNotifierProvider<CartController, CartState>(
  (ref) {
    final repository = ref.watch(customerRepositoryProvider);
    return CartController(repository);
  },
);

// ==========================================================================
// Home Data Provider
// ==========================================================================

/// حالة الصفحة الرئيسية
class HomeState {
  final List<Map<String, dynamic>> recentProducts;
  final List<Map<String, dynamic>> featuredProducts;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> topStores;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.recentProducts = const [],
    this.featuredProducts = const [],
    this.categories = const [],
    this.topStores = const [],
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<Map<String, dynamic>>? recentProducts,
    List<Map<String, dynamic>>? featuredProducts,
    List<Map<String, dynamic>>? categories,
    List<Map<String, dynamic>>? topStores,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      recentProducts: recentProducts ?? this.recentProducts,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      categories: categories ?? this.categories,
      topStores: topStores ?? this.topStores,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// متحكم الصفحة الرئيسية
class HomeController extends StateNotifier<HomeState> {
  final CustomerRepository _repository;

  HomeController(this._repository) : super(const HomeState());

  /// تحميل بيانات الصفحة الرئيسية
  Future<void> loadHomeData() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _repository.getHomeData();
      state = state.copyWith(
        recentProducts: List<Map<String, dynamic>>.from(
          data['recentProducts'] ?? [],
        ),
        featuredProducts: List<Map<String, dynamic>>.from(
          data['featuredProducts'] ?? [],
        ),
        categories: List<Map<String, dynamic>>.from(data['categories'] ?? []),
        topStores: List<Map<String, dynamic>>.from(data['topStores'] ?? []),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// تحديث
  Future<void> refresh() async {
    state = const HomeState(isLoading: true);
    await loadHomeData();
  }
}

/// Provider للصفحة الرئيسية
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    final repository = ref.watch(customerRepositoryProvider);
    return HomeController(repository);
  },
);
