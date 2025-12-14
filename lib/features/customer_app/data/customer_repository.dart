import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

/// Customer Repository - API calls for Customer App
/// All requests go through Cloudflare Worker only
///
/// المسارات:
/// - /public/... للطلبات العامة (بدون auth)
/// - /secure/... للطلبات المحمية (تحتاج auth)
/// - /categories للفئات
class CustomerRepository {
  final ApiService _apiService;

  CustomerRepository(this._apiService);

  // ==========================================================================
  // Products
  // ==========================================================================

  /// جلب جميع المنتجات المتاحة للعملاء
  Future<List<Map<String, dynamic>>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? storeId,
    String? search,
    String? sortBy,
    bool desc = true,
  }) async {
    try {
      final offset = (page - 1) * limit;
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (storeId != null) queryParams['store_id'] = storeId;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      queryParams['desc'] = desc.toString();

      final response = await _apiService.get(
        '/public/products',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      }
      throw Exception('فشل في جلب المنتجات: ${response.statusCode}');
    } catch (e) {
      throw Exception('خطأ في جلب المنتجات: $e');
    }
  }

  /// جلب تفاصيل منتج واحد
  Future<Map<String, dynamic>?> getProductDetails(String productId) async {
    try {
      final response = await _apiService.get('/public/products/$productId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في جلب تفاصيل المنتج: $e');
    }
  }

  // ==========================================================================
  // Stores
  // ==========================================================================

  /// جلب جميع المتاجر
  Future<List<Map<String, dynamic>>> getStores({
    int page = 1,
    int limit = 20,
    String? city,
    bool? isVerified,
    bool? isBoosted,
    String? sortBy,
    bool desc = true,
  }) async {
    try {
      final offset = (page - 1) * limit;
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (city != null) queryParams['city'] = city;
      if (isVerified == true) queryParams['is_verified'] = 'true';
      if (isBoosted == true) queryParams['is_boosted'] = 'true';
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      queryParams['desc'] = desc.toString();

      final response = await _apiService.get(
        '/public/stores',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      }
      throw Exception('فشل في جلب المتاجر: ${response.statusCode}');
    } catch (e) {
      throw Exception('خطأ في جلب المتاجر: $e');
    }
  }

  /// جلب تفاصيل متجر واحد
  Future<Map<String, dynamic>?> getStoreDetails(String storeId) async {
    try {
      final response = await _apiService.get('/public/stores/$storeId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في جلب تفاصيل المتجر: $e');
    }
  }

  /// جلب منتجات متجر معين مع pagination
  Future<Map<String, dynamic>> getStoreProducts(
    String storeId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final products = await getProducts(
        storeId: storeId,
        page: page,
        limit: limit,
      );
      return {'products': products, 'hasMore': products.length >= limit};
    } catch (e) {
      throw Exception('خطأ في جلب منتجات المتجر: $e');
    }
  }

  // ==========================================================================
  // Categories
  // ==========================================================================

  /// جلب جميع الفئات
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _apiService.get('/categories');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // الـ endpoint يرجع: { ok: true, categories: [...] }
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
        if (data['categories'] != null) {
          return List<Map<String, dynamic>>.from(data['categories']);
        }
        if (data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      }
      throw Exception('فشل في جلب الفئات: ${response.statusCode}');
    } catch (e) {
      throw Exception('خطأ في جلب الفئات: $e');
    }
  }

  // ==========================================================================
  // Cart - يحتاج Auth
  // ==========================================================================

  /// جلب سلة المشتريات
  Future<List<Map<String, dynamic>>> getCart() async {
    try {
      final response = await _apiService.get('/secure/cart');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
        if (data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      }
      return [];
    } catch (e) {
      throw Exception('خطأ في جلب السلة: $e');
    }
  }

  /// إضافة منتج للسلة
  Future<bool> addToCart({required String productId, int quantity = 1}) async {
    try {
      final response = await _apiService.post(
        '/secure/cart',
        body: {'product_id': productId, 'quantity': quantity},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('خطأ في إضافة المنتج للسلة: $e');
    }
  }

  /// تحديث كمية منتج في السلة
  Future<bool> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await _apiService.put(
        '/secure/cart/$itemId',
        body: {'quantity': quantity},
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('خطأ في تحديث السلة: $e');
    }
  }

  /// حذف منتج من السلة
  Future<bool> removeFromCart(String itemId) async {
    try {
      final response = await _apiService.delete('/secure/cart/$itemId');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('خطأ في حذف المنتج من السلة: $e');
    }
  }

  /// تفريغ السلة
  Future<bool> clearCart() async {
    try {
      final response = await _apiService.delete('/secure/cart');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('خطأ في تفريغ السلة: $e');
    }
  }

  // ==========================================================================
  // Orders - يحتاج Auth
  // ==========================================================================

  /// جلب طلبات العميل
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await _apiService.get('/secure/orders');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
        if (data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      }
      throw Exception('فشل في جلب الطلبات');
    } catch (e) {
      throw Exception('خطأ في جلب الطلبات: $e');
    }
  }

  /// إنشاء طلب جديد من السلة
  Future<Map<String, dynamic>?> createOrderFromCart({
    required Map<String, dynamic> shippingAddress,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/secure/orders/create-from-cart',
        body: {
          'shipping_address': shippingAddress,
          if (notes != null) 'notes': notes,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data'] ?? data;
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في إنشاء الطلب: $e');
    }
  }

  /// جلب تفاصيل طلب
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      final response = await _apiService.get('/secure/orders/$orderId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? data;
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في جلب تفاصيل الطلب: $e');
    }
  }

  // ==========================================================================
  // Home Data - الصفحة الرئيسية
  // ==========================================================================

  /// جلب بيانات الصفحة الرئيسية (منتجات مميزة + فئات + بانرات)
  Future<Map<String, dynamic>> getHomeData() async {
    try {
      // جلب كل البيانات بالتوازي
      final results = await Future.wait([
        getProducts(
          limit: 10,
          sortBy: 'created_at',
          desc: true,
        ), // أحدث المنتجات
        getProducts(limit: 10), // منتجات مميزة
        getCategories(),
        getStores(limit: 5, isVerified: true), // متاجر موثقة
      ]);

      return {
        'recentProducts': results[0],
        'featuredProducts': results[1],
        'categories': results[2],
        'topStores': results[3],
      };
    } catch (e) {
      throw Exception('خطأ في جلب بيانات الصفحة الرئيسية: $e');
    }
  }
}

/// Provider for CustomerRepository
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CustomerRepository(apiService);
});
