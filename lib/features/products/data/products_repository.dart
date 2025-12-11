import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_token_storage.dart';
import '../domain/models/product.dart';

/// Products Repository
/// يتعامل مع جميع عمليات API الخاصة بالمنتجات
class ProductsRepository {
  final ApiService _apiService;
  final AuthTokenStorage _tokenStorage;

  ProductsRepository(this._apiService, this._tokenStorage);

  /// جلب جميع منتجات التاجر
  /// المسار: GET /secure/merchant/products
  /// Worker يستدعي Edge Function: merchant_products
  ///
  /// إذا لم يوجد متجر أو منتجات، يرجع قائمة فارغة بدلاً من Exception
  Future<List<Product>> getMerchantProducts() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('لا يوجد رمز وصول - يجب تسجيل الدخول');
      }

      final response = await _apiService.get(
        '/secure/merchant/products',
        headers: {'Authorization': 'Bearer $token'},
      );

      // إذا 404، يعني لا يوجد متجر أو منتجات - نرجع قائمة فارغة
      if (response.statusCode == 404) {
        return [];
      }

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          if (data['ok'] == true) {
            final List productsList = data['data'] ?? [];
            return productsList.map((json) => Product.fromJson(json)).toList();
          } else {
            // Worker returned ok:false - treat as empty for now
            return [];
          }
        } catch (parseError) {
          // JSON parse error - return empty list
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
  /// المسار: POST /secure/media/upload-urls
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
        '/secure/media/upload-urls',
        body: body,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['uploadUrls'] != null) {
          return List<Map<String, dynamic>>.from(data['uploadUrls']);
        }
      }

      throw Exception('فشل الحصول على روابط الرفع');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في طلب روابط الرفع: $e');
    }
  }

  /// إضافة منتج جديد
  /// المسار: POST /secure/products
  /// Worker يستدعي Edge Function: product_create
  Future<Product> createProduct({
    required String name,
    required double price,
    required int stock,
    String? description,
    String? imageUrl,
    String? categoryId,
    List<Map<String, dynamic>>? media,
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
        'is_active': true,
      };

      final response = await _apiService.post(
        '/secure/products',
        body: body,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);

          if (data['ok'] == true && data['data'] != null) {
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

      final response = await _apiService.put(
        '/secure/products/$productId',
        body: body,
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (data['ok'] == true) {
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
        '/secure/products/$productId',
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (data['ok'] != true) {
        throw Exception(data['error'] ?? 'فشل حذف المنتج');
      }
    } catch (e) {
      throw Exception('خطأ في حذف المنتج: $e');
    }
  }
}

/// Riverpod Provider for ProductsRepository
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final tokenStorage = ref.watch(authTokenStorageProvider);
  return ProductsRepository(apiService, tokenStorage);
});
