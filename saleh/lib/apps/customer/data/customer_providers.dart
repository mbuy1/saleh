/// Customer Providers - مزودي البيانات للعميل
///
/// Riverpod providers for the customer app

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:state_notifier/state_notifier.dart';
import '../models/models.dart';
import 'customer_api_service.dart';

// =====================================================
// API Service Provider
// =====================================================

/// Provider for the API service
final customerApiProvider = Provider<CustomerApiService>((ref) {
  final api = CustomerApiService(
    baseUrl: 'https://api.mbuy.pro', // TODO: استخدام environment variable
  );

  // TODO: Set auth token from auth state
  // final authState = ref.watch(authStateProvider);
  // if (authState.isAuthenticated) {
  //   api.setAuthToken(authState.token);
  // }

  return api;
});

// =====================================================
// PRODUCTS PROVIDERS
// =====================================================

/// Products list state
class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final int page;
  final bool hasMore;

  ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.page = 1,
    this.hasMore = true,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    int? page,
    bool? hasMore,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Products notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final CustomerApiService _api;
  final String? _categoryId;

  ProductsNotifier(this._api, this._categoryId) : super(ProductsState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final response = await _api.getProducts(
      categoryId: _categoryId,
      page: 1,
      limit: 20,
    );

    if (response.ok && response.data != null) {
      state = state.copyWith(
        products: response.data!,
        isLoading: false,
        page: 1,
        hasMore: response.data!.length >= 20,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.message ?? response.error,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final response = await _api.getProducts(
      categoryId: _categoryId,
      page: state.page + 1,
      limit: 20,
    );

    if (response.ok && response.data != null) {
      state = state.copyWith(
        products: [...state.products, ...response.data!],
        isLoading: false,
        page: state.page + 1,
        hasMore: response.data!.length >= 20,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    state = ProductsState();
    await loadProducts();
  }
}

/// Provider for products list
final productsProvider =
    StateNotifierProvider.family<ProductsNotifier, ProductsState, String?>(
      (ref, categoryId) =>
          ProductsNotifier(ref.watch(customerApiProvider), categoryId),
    );

/// Provider for single product
final productProvider = FutureProvider.family<Product?, String>((
  ref,
  productId,
) async {
  final api = ref.watch(customerApiProvider);
  final response = await api.getProduct(productId);
  return response.ok ? response.data : null;
});

// =====================================================
// CATEGORIES PROVIDERS
// =====================================================

/// Provider for categories list
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final api = ref.watch(customerApiProvider);
  final response = await api.getCategories();
  return response.ok ? response.data ?? [] : [];
});

// =====================================================
// SEARCH PROVIDERS
// =====================================================

/// Search state
class SearchState {
  final String query;
  final List<Product> results;
  final List<String> suggestions;
  final bool isLoading;
  final String? error;

  SearchState({
    this.query = '',
    this.results = const [],
    this.suggestions = const [],
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<Product>? results,
    List<String>? suggestions,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Search notifier
class SearchNotifier extends StateNotifier<SearchState> {
  final CustomerApiService _api;

  SearchNotifier(this._api) : super(SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = SearchState();
      return;
    }

    state = state.copyWith(query: query, isLoading: true, error: null);

    final response = await _api.searchProducts(query: query);

    if (response.ok && response.data != null) {
      state = state.copyWith(results: response.data!, isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.message ?? response.error,
      );
    }
  }

  Future<void> loadSuggestions(String query) async {
    if (query.length < 2) {
      state = state.copyWith(suggestions: []);
      return;
    }

    final response = await _api.getSearchSuggestions(query);

    if (response.ok && response.data != null) {
      state = state.copyWith(suggestions: response.data!);
    }
  }

  void clear() {
    state = SearchState();
  }
}

/// Provider for search
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(ref.watch(customerApiProvider)),
);

/// Provider for trending searches
final trendingSearchesProvider = FutureProvider<List<String>>((ref) async {
  final api = ref.watch(customerApiProvider);
  final response = await api.getTrendingSearches();
  return response.ok ? response.data ?? [] : [];
});

// =====================================================
// CART PROVIDERS
// =====================================================

/// Cart state
class CartState {
  final Cart? cart;
  final bool isLoading;
  final String? error;
  final bool isUpdating;

  CartState({
    this.cart,
    this.isLoading = false,
    this.error,
    this.isUpdating = false,
  });

  CartState copyWith({
    Cart? cart,
    bool? isLoading,
    String? error,
    bool? isUpdating,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  int get itemsCount => cart?.totalItems ?? 0;
  double get subtotal => cart?.subtotal ?? 0;
  bool get isEmpty => cart?.isEmpty ?? true;
}

/// Cart notifier
class CartNotifier extends StateNotifier<CartState> {
  final CustomerApiService _api;

  CartNotifier(this._api) : super(CartState());

  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _api.getCart();

    if (response.ok && response.data != null) {
      state = state.copyWith(cart: response.data!, isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.message ?? response.error,
      );
    }
  }

  Future<bool> addToCart(String productId, {int quantity = 1}) async {
    state = state.copyWith(isUpdating: true, error: null);

    final response = await _api.addToCart(
      productId: productId,
      quantity: quantity,
    );

    if (response.ok) {
      await loadCart(); // Reload cart
      return true;
    } else {
      state = state.copyWith(
        isUpdating: false,
        error: response.message ?? response.error,
      );
      return false;
    }
  }

  Future<bool> updateQuantity(String itemId, int quantity) async {
    state = state.copyWith(isUpdating: true, error: null);

    final response = await _api.updateCartItem(
      itemId: itemId,
      quantity: quantity,
    );

    if (response.ok) {
      await loadCart();
      return true;
    } else {
      state = state.copyWith(
        isUpdating: false,
        error: response.message ?? response.error,
      );
      return false;
    }
  }

  Future<bool> removeItem(String itemId) async {
    state = state.copyWith(isUpdating: true, error: null);

    final response = await _api.removeFromCart(itemId);

    if (response.ok) {
      await loadCart();
      return true;
    } else {
      state = state.copyWith(
        isUpdating: false,
        error: response.message ?? response.error,
      );
      return false;
    }
  }

  Future<bool> clearCart() async {
    state = state.copyWith(isUpdating: true, error: null);

    final response = await _api.clearCart();

    if (response.ok) {
      state = state.copyWith(cart: null, isUpdating: false);
      return true;
    } else {
      state = state.copyWith(
        isUpdating: false,
        error: response.message ?? response.error,
      );
      return false;
    }
  }

  /// Alias for addToCart for backward compatibility
  Future<bool> addItem(String productId, int quantity) async {
    return addToCart(productId, quantity: quantity);
  }
}

/// Provider for cart
final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(ref.watch(customerApiProvider)),
);

/// Provider for cart count (lightweight)
final cartCountProvider = FutureProvider<int>((ref) async {
  final api = ref.watch(customerApiProvider);
  final response = await api.getCartCount();
  return response.ok ? response.data ?? 0 : 0;
});

// =====================================================
// FAVORITES PROVIDERS
// =====================================================

/// Favorites state
class FavoritesState {
  final List<Product> favorites;
  final Set<String> favoriteIds;
  final bool isLoading;
  final String? error;

  FavoritesState({
    this.favorites = const [],
    this.favoriteIds = const {},
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<Product>? favorites,
    Set<String>? favoriteIds,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool isFavorite(String productId) => favoriteIds.contains(productId);
}

/// Favorites notifier
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final CustomerApiService _api;

  FavoritesNotifier(this._api) : super(FavoritesState());

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _api.getFavorites();

    if (response.ok && response.data != null) {
      final ids = response.data!.map((p) => p.id).toSet();
      state = state.copyWith(
        favorites: response.data!,
        favoriteIds: ids,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.message ?? response.error,
      );
    }
  }

  Future<bool> toggleFavorite(String productId) async {
    final response = await _api.toggleFavorite(productId);

    if (response.ok && response.data != null) {
      final isFavorite = response.data!;
      final newIds = Set<String>.from(state.favoriteIds);

      if (isFavorite) {
        newIds.add(productId);
      } else {
        newIds.remove(productId);
      }

      state = state.copyWith(favoriteIds: newIds);

      // Reload full list if needed
      await loadFavorites();
      return true;
    }
    return false;
  }

  Future<bool> addToFavorites(String productId) async {
    final response = await _api.addToFavorites(productId);

    if (response.ok) {
      final newIds = Set<String>.from(state.favoriteIds)..add(productId);
      state = state.copyWith(favoriteIds: newIds);
      await loadFavorites();
      return true;
    }
    return false;
  }

  Future<bool> removeFromFavorites(String productId) async {
    final response = await _api.removeFromFavorites(productId);

    if (response.ok) {
      final newIds = Set<String>.from(state.favoriteIds)..remove(productId);
      final newList = state.favorites.where((p) => p.id != productId).toList();
      state = state.copyWith(favoriteIds: newIds, favorites: newList);
      return true;
    }
    return false;
  }

  Future<void> clearFavorites() async {
    // Clear all favorites one by one
    final ids = List<String>.from(state.favoriteIds);
    for (final id in ids) {
      await removeFromFavorites(id);
    }
    state = FavoritesState();
  }
}

/// Provider for favorites
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>(
      (ref) => FavoritesNotifier(ref.watch(customerApiProvider)),
    );

/// Provider for checking if a product is favorite
final isFavoriteProvider = Provider.family<bool, String>((ref, productId) {
  final favoritesState = ref.watch(favoritesProvider);
  return favoritesState.isFavorite(productId);
});

// =====================================================
// ORDERS PROVIDERS
// =====================================================

/// Orders state
class OrdersState {
  final List<Order> orders;
  final bool isLoading;
  final String? error;
  final int page;
  final bool hasMore;
  final String? statusFilter;

  OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
    this.page = 1,
    this.hasMore = true,
    this.statusFilter,
  });

  OrdersState copyWith({
    List<Order>? orders,
    bool? isLoading,
    String? error,
    int? page,
    bool? hasMore,
    String? statusFilter,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

/// Orders notifier
class OrdersNotifier extends StateNotifier<OrdersState> {
  final CustomerApiService _api;

  OrdersNotifier(this._api) : super(OrdersState());

  Future<void> loadOrders({String? status}) async {
    state = state.copyWith(isLoading: true, error: null, statusFilter: status);

    final response = await _api.getOrders(status: status, page: 1, limit: 20);

    if (response.ok && response.data != null) {
      state = state.copyWith(
        orders: response.data!,
        isLoading: false,
        page: 1,
        hasMore: response.data!.length >= 20,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.message ?? response.error,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final response = await _api.getOrders(
      status: state.statusFilter,
      page: state.page + 1,
      limit: 20,
    );

    if (response.ok && response.data != null) {
      state = state.copyWith(
        orders: [...state.orders, ...response.data!],
        isLoading: false,
        page: state.page + 1,
        hasMore: response.data!.length >= 20,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    final response = await _api.cancelOrder(orderId);

    if (response.ok) {
      // Update local state
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(status: OrderStatus.cancelled);
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
      return true;
    }
    return false;
  }

  Future<void> refresh() async {
    state = OrdersState(statusFilter: state.statusFilter);
    await loadOrders(status: state.statusFilter);
  }
}

/// Provider for orders
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>(
  (ref) => OrdersNotifier(ref.watch(customerApiProvider)),
);

/// Provider for single order
final orderProvider = FutureProvider.family<Order?, String>((
  ref,
  orderId,
) async {
  final api = ref.watch(customerApiProvider);
  final response = await api.getOrder(orderId);
  return response.ok ? response.data : null;
});

// =====================================================
// CHECKOUT PROVIDERS
// =====================================================

/// Checkout state
class CheckoutState {
  final bool isValidating;
  final bool isPlacingOrder;
  final bool isLoading;
  final Map<String, dynamic>? validationResult;
  final ShippingAddress? selectedAddress;
  final List<ShippingAddress> addresses;
  final String paymentMethod;
  final String? error;
  final Map<String, dynamic>? orderResult;

  CheckoutState({
    this.isValidating = false,
    this.isPlacingOrder = false,
    this.isLoading = false,
    this.validationResult,
    this.selectedAddress,
    this.addresses = const [],
    this.paymentMethod = 'cash',
    this.error,
    this.orderResult,
  });

  CheckoutState copyWith({
    bool? isValidating,
    bool? isPlacingOrder,
    bool? isLoading,
    Map<String, dynamic>? validationResult,
    ShippingAddress? selectedAddress,
    List<ShippingAddress>? addresses,
    String? paymentMethod,
    String? error,
    Map<String, dynamic>? orderResult,
  }) {
    return CheckoutState(
      isValidating: isValidating ?? this.isValidating,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      isLoading: isLoading ?? this.isLoading,
      validationResult: validationResult ?? this.validationResult,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      addresses: addresses ?? this.addresses,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      error: error,
      orderResult: orderResult ?? this.orderResult,
    );
  }

  bool get isValid => validationResult?['is_valid'] ?? false;
  List<dynamic> get validationErrors =>
      validationResult?['validation_errors'] ?? [];
}

/// Checkout notifier
class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final CustomerApiService _api;

  CheckoutNotifier(this._api) : super(CheckoutState());

  Future<void> loadAddresses() async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _api.getAddresses();

    if (response.ok && response.data != null) {
      state = state.copyWith(addresses: response.data!, isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.message ?? response.error,
      );
    }
  }

  Future<bool> validateCheckout() async {
    state = state.copyWith(isValidating: true, error: null);

    final response = await _api.validateCheckout();

    if (response.ok && response.data != null) {
      state = state.copyWith(
        isValidating: false,
        validationResult: response.data!,
      );
      return response.data!['is_valid'] ?? false;
    } else {
      state = state.copyWith(
        isValidating: false,
        error: response.message ?? response.error,
      );
      return false;
    }
  }

  void setAddress(ShippingAddress address) {
    state = state.copyWith(selectedAddress: address);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<String?> placeOrder({
    required String? addressId,
    required String paymentMethod,
    String? notes,
    String? couponCode,
  }) async {
    // Find the address by ID
    final address = state.addresses.firstWhere(
      (a) => a.id == addressId,
      orElse: () => state.addresses.first,
    );

    state = state.copyWith(
      isPlacingOrder: true,
      error: null,
      selectedAddress: address,
      paymentMethod: paymentMethod,
    );

    final response = await _api.createOrder(
      shippingAddress: address,
      paymentMethod: paymentMethod,
      notes: notes,
      couponCode: couponCode,
    );

    if (response.ok && response.data != null) {
      state = state.copyWith(
        isPlacingOrder: false,
        orderResult: response.data!,
      );
      return response.data!['order_number'] as String?;
    } else {
      state = state.copyWith(
        isPlacingOrder: false,
        error: response.message ?? response.error,
      );
      return null;
    }
  }

  void reset() {
    state = CheckoutState();
  }
}

/// Provider for checkout
final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>(
  (ref) => CheckoutNotifier(ref.watch(customerApiProvider)),
);

/// Provider for saved addresses
final addressesProvider = FutureProvider<List<ShippingAddress>>((ref) async {
  final api = ref.watch(customerApiProvider);
  final response = await api.getAddresses();
  return response.ok ? response.data ?? [] : [];
});
