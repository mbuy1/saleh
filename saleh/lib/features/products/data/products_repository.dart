import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_config.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_token_storage.dart';
import '../domain/models/product.dart';

/// Products Repository (Worker v2.0)
/// يتعامل مع جميع عمليات API الخاصة بالمنتجات
class ProductsRepository {
  final ApiService _apiService;
  final AuthTokenStorage _tokenStorage;

  ProductsRepository(this._apiService, this._tokenStorage);

  /// جلب جميع منتجات التاجر
  /// المسار: GET /api/merchant/products
  ///
  /// إذا لم يوجد متجر أو منتجات، يرجع قائمة فارغة بدلاً من Exception
  Future<List<Product>> getMerchantProducts() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final response = await _apiService.get(
        AppConfig.merchantProductsEndpoint,
        headers: {'Authorization': 'Bearer $token'},
      );

      // إذا 404، يعني لا يوجد متجر أو منتجات - نرجع قائمة فارغة
      if (response.statusCode == 404) {
        return [];
      }

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          debugPrint(
            '🔍 [getMerchantProducts] Response data: ${jsonEncode(data)}',
          );

          if (data['success'] == true) {
            final List productsList = data['data'] ?? [];

            debugPrint(
              '🔍 [getMerchantProducts] Products count: ${productsList.length}',
            );
            if (productsList.isNotEmpty) {
              debugPrint(
                '🔍 [getMerchantProducts] First product keys: ${(productsList[0] as Map).keys.toList()}',
              );
              debugPrint(
                '🔍 [getMerchantProducts] First product: ${jsonEncode(productsList[0])}',
              );
            }

            return productsList.map((json) => Product.fromJson(json)).toList();
          } else {
            // Worker returned success:false - treat as empty for now
            debugPrint(
              '⚠️ [getMerchantProducts] Worker returned success:false',
            );
            return [];
          }
        } catch (parseError) {
          // JSON parse error - return empty list
          debugPrint('❌ [getMerchantProducts] Parse error: $parseError');
          return [];
        }
      }

      // أي حالة أخرى (500, 401, etc) - نرجع قائمة فارغة بدلاً من كراش
      return [];
    } catch (e) {
      if (e.toString().contains('لا يوجد رمز وصول')) {
        rethrow;
      }
      // أي خطأ آخر - نرجع قائمة فارغة
      return [];
    }
  }

  /// طلب روابط رفع الوسائط من Worker
  /// المسار: POST /api/merchant/media/upload-urls
  Future<List<Map<String, dynamic>>> getUploadUrls({
    required List<Map<String, String>> files,
  }) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final body = {'files': files};

      final response = await _apiService.post(
        '/api/merchant/media/upload-urls',
        body: body,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['uploadUrls'] != null) {
          return List<Map<String, dynamic>>.from(data['uploadUrls']);
        }
        throw Exception('Upload URLs response missing data: ${response.body}');
      }

      throw Exception(
        'فشل الحصول على روابط الرفع: ${response.statusCode} - ${response.body}',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في طلب روابط الرفع: $e');
    }
  }

  /// إضافة منتج جديد
  /// المسار: POST /api/merchant/products
  Future<Product> createProduct({
    required String name,
    required double price,
    required int stock,
    String? description,
    String? imageUrl,
    String? categoryId,
    List<Map<String, dynamic>>? media,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final body = {
        'name': name,
        'price': price,
        'stock': stock,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
        if (categoryId != null && categoryId.isNotEmpty)
          'category_id': categoryId,
        if (media != null && media.isNotEmpty) 'media': media,
        if (extraData != null) 'extra_data': extraData,
        'is_active': true,
      };

      final response = await _apiService.post(
        AppConfig.merchantProductsEndpoint,
        body: body,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);

          if (data['success'] == true && data['data'] != null) {
            // DEBUG: Print server debug info
            if (data['debug'] != null) {
              debugPrint(
                '🔍 [CreateProduct] Server Debug Info: ${jsonEncode(data['debug'])}',
              );
            }
            return Product.fromJson(data['data']);
          } else {
            final errorMsg =
                data['message'] ??
                data['error'] ??
                data['detail'] ??
                'فشل إضافة المنتج';
            throw Exception(errorMsg);
          }
        } catch (e) {
          if (e is Exception) rethrow;
          throw Exception('فشل معالجة استجابة الخادم');
        }
      } else {
        // حاول قراءة رسالة الخطأ من الاستجابة
        try {
          final data = jsonDecode(response.body);
          final errorMsg =
              data['message'] ??
              data['error'] ??
              data['detail'] ??
              'فشل إضافة المنتج (رمز ${response.statusCode})';
          throw Exception(errorMsg);
        } catch (e) {
          if (e is Exception) rethrow;
          throw Exception('فشل إضافة المنتج (رمز ${response.statusCode})');
        }
      }
    } catch (e) {
      if (e.toString().contains('لا يوجد رمز وصول')) {
        rethrow;
      }
      if (e is Exception) {
        rethrow;
      }
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  /// تحديث منتج موجود
  Future<Product> updateProduct({
    required String productId,
    String? name,
    double? price,
    int? stock,
    String? description,
    String? imageUrl,
    String? categoryId,
    bool? isActive,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (price != null) body['price'] = price;
      if (stock != null) body['stock'] = stock;
      if (description != null) body['description'] = description;
      if (imageUrl != null) body['image_url'] = imageUrl;
      if (categoryId != null) body['category_id'] = categoryId;
      if (isActive != null) body['is_active'] = isActive;
      if (extraData != null) body['extra_data'] = extraData;

      final response = await _apiService.put(
        '${AppConfig.merchantProductsEndpoint}/$productId',
        body: body,
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return Product.fromJson(data['data']);
      } else {
        throw Exception(data['error'] ?? 'فشل تحديث المنتج');
      }
    } catch (e) {
      throw Exception('خطأ في تحديث المنتج: $e');
    }
  }

  /// حذف منتج
  Future<void> deleteProduct(String productId) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final response = await _apiService.delete(
        '${AppConfig.merchantProductsEndpoint}/$productId',
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (data['success'] != true) {
        throw Exception(data['error'] ?? 'فشل حذف المنتج');
      }
    } catch (e) {
      throw Exception('خطأ في حذف المنتج: $e');
    }
  }

  /// جلب كتالوج منتجات الدروب شوبينق المتاحة للموزعين
  /// المسار: GET /api/dropshipping/catalog
  /// يرجع قائمة المنتجات المتاحة من الموردين
  Future<List<Map<String, dynamic>>> getDropshippingProducts() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final response = await _apiService.get(
        '/api/dropshipping/catalog',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List productsList = data['data'] as List;
          return productsList
              .map((json) => json as Map<String, dynamic>)
              .toList();
        }
      }

      // أي حالة أخرى ترجع قائمة فارغة
      return [];
    } catch (e) {
      debugPrint('⚠️ [getDropshippingProducts] Error: $e');
      return [];
    }
  }

  /// جلب قوائم الموزع (المنتجات التي أضافها من الكتالوج)
  /// المسار: GET /api/dropshipping/reseller/listings
  Future<List<Map<String, dynamic>>> getResellerListings() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final response = await _apiService.get(
        '/api/dropshipping/reseller/listings',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List listings = data['data'] as List;
          return listings.map((json) => json as Map<String, dynamic>).toList();
        }
      }

      return [];
    } catch (e) {
      debugPrint('⚠️ [getResellerListings] Error: $e');
      return [];
    }
  }

  /// إضافة منتج من الكتالوج إلى قائمة الموزع
  /// المسار: POST /api/dropshipping/reseller/listings
  Future<Map<String, dynamic>?> createResellerListing({
    required String dropshipProductId,
    required double sellingPrice,
    String? customName,
    String? customDescription,
  }) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final response = await _apiService.post(
        '/api/dropshipping/reseller/listings',
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'dropship_product_id': dropshipProductId,
          'selling_price': sellingPrice,
          if (customName != null) 'custom_name': customName,
          if (customDescription != null)
            'custom_description': customDescription,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      }

      throw Exception(data['error'] ?? 'فشل إضافة المنتج');
    } catch (e) {
      debugPrint('⚠️ [createResellerListing] Error: $e');
      rethrow;
    }
  }
}

/// Riverpod Provider for ProductsRepository
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final tokenStorage = ref.watch(authTokenStorageProvider);
  return ProductsRepository(apiService, tokenStorage);
});
