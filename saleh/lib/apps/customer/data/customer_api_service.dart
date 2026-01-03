/// Customer API Service - خدمة API للعميل
///
/// Handles all API communication for the customer app

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// API Response wrapper
class ApiResponse<T> {
  final bool ok;
  final T? data;
  final String? error;
  final String? message;
  final Map<String, dynamic>? pagination;

  ApiResponse({
    required this.ok,
    this.data,
    this.error,
    this.message,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? parser,
  ) {
    return ApiResponse(
      ok: json['ok'] ?? false,
      data: parser != null && json['data'] != null
          ? parser(json['data'])
          : json['data'],
      error: json['error'],
      message: json['message'],
      pagination: json['pagination'],
    );
  }

  factory ApiResponse.success(T data) {
    return ApiResponse(ok: true, data: data);
  }

  factory ApiResponse.failure(String error, [String? message]) {
    return ApiResponse(ok: false, error: error, message: message);
  }
}

/// Customer API Service
class CustomerApiService {
  final String baseUrl;
  String? _authToken;

  CustomerApiService({
    this.baseUrl = 'https://api.mbuy.pro', // أو http://localhost:8787 للتطوير
  });

  /// Set authentication token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Get default headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // =====================================================
  // PRODUCTS & SEARCH
  // =====================================================

  /// Search products
  Future<ApiResponse<List<Product>>> searchProducts({
    required String query,
    String? categoryId,
    String? storeId,
    double? minPrice,
    double? maxPrice,
    String sortBy = 'relevance',
    bool? inStock,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
        'sort_by': sortBy,
      };

      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (storeId != null) queryParams['store_id'] = storeId;
      if (minPrice != null) queryParams['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
      if (inStock != null) queryParams['in_stock'] = inStock.toString();

      final uri = Uri.parse(
        '$baseUrl/api/public/search/products',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data.map((e) => Product.fromJson(e)).toList();
        }
        return <Product>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get public products list
  Future<ApiResponse<List<Product>>> getProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (categoryId != null) queryParams['category_id'] = categoryId;

      final uri = Uri.parse(
        '$baseUrl/api/public/products',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data.map((e) => Product.fromJson(e)).toList();
        }
        return <Product>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get single product
  Future<ApiResponse<Product>> getProduct(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/public/products/$productId'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => Product.fromJson(data));
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get search suggestions
  Future<ApiResponse<List<String>>> getSearchSuggestions(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/public/search/suggestions?q=$query'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data
              .map((e) => e['text']?.toString() ?? e.toString())
              .toList();
        }
        return <String>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get trending searches
  Future<ApiResponse<List<String>>> getTrendingSearches() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/public/search/trending'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data
              .map((e) => e['query']?.toString() ?? e.toString())
              .toList();
        }
        return <String>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  // =====================================================
  // CATEGORIES
  // =====================================================

  /// Get all categories
  Future<ApiResponse<List<Category>>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/public/categories/all'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data.map((e) => Category.fromJson(e)).toList();
        }
        return <Category>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get products by category
  Future<ApiResponse<List<Product>>> getProductsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/public/categories/$categoryId/products?page=$page&limit=$limit',
        ),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data.map((e) => Product.fromJson(e)).toList();
        }
        return <Product>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  // =====================================================
  // STORES
  // =====================================================

  /// Search stores
  Future<ApiResponse<List<Store>>> searchStores({
    required String query,
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (category != null) queryParams['category'] = category;

      final uri = Uri.parse(
        '$baseUrl/api/public/search/stores',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data.map((e) => Store.fromJson(e)).toList();
        }
        return <Store>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  // =====================================================
  // CART (Requires Auth)
  // =====================================================

  /// Get cart
  Future<ApiResponse<Cart>> getCart() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/customer/cart'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => Cart.fromJson(data));
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Add item to cart
  Future<ApiResponse<CartItem>> addToCart({
    required String productId,
    int quantity = 1,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/customer/cart'),
        headers: _headers,
        body: jsonEncode({'product_id': productId, 'quantity': quantity}),
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => CartItem.fromJson(data));
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Update cart item quantity
  Future<ApiResponse<CartItem>> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/customer/cart/$itemId'),
        headers: _headers,
        body: jsonEncode({'quantity': quantity}),
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => CartItem.fromJson(data));
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Remove item from cart
  Future<ApiResponse<void>> removeFromCart(String itemId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/customer/cart/$itemId'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, null);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Clear cart
  Future<ApiResponse<void>> clearCart() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/customer/cart'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, null);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get cart items count
  Future<ApiResponse<int>> getCartCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/customer/cart/count'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => data['count'] ?? 0);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  // =====================================================
  // FAVORITES (Requires Auth)
  // =====================================================

  /// Get favorites
  Future<ApiResponse<List<Product>>> getFavorites({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/customer/favorites?page=$page&limit=$limit'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data.map((e) {
            // Extract product from favorite record
            final product = e['products'] ?? e['product'] ?? e;
            return Product.fromJson(product);
          }).toList();
        }
        return <Product>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Add to favorites
  Future<ApiResponse<void>> addToFavorites(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/customer/favorites'),
        headers: _headers,
        body: jsonEncode({'product_id': productId}),
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, null);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Remove from favorites
  Future<ApiResponse<void>> removeFromFavorites(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/customer/favorites/$productId'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, null);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Toggle favorite
  Future<ApiResponse<bool>> toggleFavorite(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/customer/favorites/toggle'),
        headers: _headers,
        body: jsonEncode({'product_id': productId}),
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => data['is_favorite'] ?? false);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Check if product is in favorites
  Future<ApiResponse<bool>> checkFavorite(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/customer/favorites/check/$productId'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => data['is_favorite'] ?? false);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get favorites count
  Future<ApiResponse<int>> getFavoritesCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/customer/favorites/count'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => data['count'] ?? 0);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  // =====================================================
  // CHECKOUT & ORDERS (Requires Auth)
  // =====================================================

  /// Validate checkout
  Future<ApiResponse<Map<String, dynamic>>> validateCheckout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/customer/checkout/validate'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => data as Map<String, dynamic>);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Create order
  Future<ApiResponse<Map<String, dynamic>>> createOrder({
    required ShippingAddress shippingAddress,
    String paymentMethod = 'cash',
    String? notes,
    String? couponCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/customer/checkout'),
        headers: _headers,
        body: jsonEncode({
          'shipping_address': shippingAddress.toJson(),
          'payment_method': paymentMethod,
          'notes': notes,
          'coupon_code': couponCode,
        }),
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => data as Map<String, dynamic>);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get orders
  Future<ApiResponse<List<Order>>> getOrders({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (status != null) queryParams['status'] = status;

      final uri = Uri.parse(
        '$baseUrl/api/customer/checkout/orders',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data.map((e) => Order.fromJson(e)).toList();
        }
        return <Order>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get order details
  Future<ApiResponse<Order>> getOrder(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/customer/checkout/orders/$orderId'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) => Order.fromJson(data));
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Cancel order
  Future<ApiResponse<void>> cancelOrder(String orderId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/customer/checkout/orders/$orderId/cancel'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, null);
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }

  /// Get saved addresses
  Future<ApiResponse<List<ShippingAddress>>> getAddresses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/customer/addresses'),
        headers: _headers,
      );
      final json = jsonDecode(response.body);

      return ApiResponse.fromJson(json, (data) {
        if (data is List) {
          return data.map((e) => ShippingAddress.fromJson(e)).toList();
        }
        return <ShippingAddress>[];
      });
    } catch (e) {
      return ApiResponse.failure('NETWORK_ERROR', e.toString());
    }
  }
}
