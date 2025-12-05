import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/store_model.dart';

/// خدمة صفحة Explore - البحث والاستكشاف (عبر Worker API)
class ExploreService {
  /// البحث في المنتجات
  static Future<List<ProductModel>> searchProducts(
    String query, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      if (query.trim().isEmpty) {
        return getAllProducts(limit: limit, offset: offset);
      }

      // استخدام Worker API للبحث
      final response = await ApiService.getProducts(
        limit: limit,
        offset: offset,
        status: 'active',
      );

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final productsList = (data is List) ? data : [];
        final products = productsList
            .where((json) {
              final name = json['name']?.toString().toLowerCase() ?? '';
              final desc = json['description']?.toString().toLowerCase() ?? '';
              final searchQuery = query.toLowerCase();
              return name.contains(searchQuery) || desc.contains(searchQuery);
            })
            .map((json) {
              final productJson = Map<String, dynamic>.from(json);
              if (json['stores'] != null) {
                productJson['store_name'] = json['stores']['name'];
              }
              if (json['categories'] != null) {
                productJson['category_name'] = json['categories']['name'];
              }
              return ProductModel.fromJson(productJson);
            })
            .toList();

        debugPrint('✅ تم العثور على ${products.length} منتج');
        return products;
      }

      return [];
    } catch (e) {
      debugPrint('❌ خطأ في البحث: $e');
      return [];
    }
  }

  /// جلب جميع المنتجات
  static Future<List<ProductModel>> getAllProducts({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      // استخدام Worker API
      final response = await ApiService.getProducts(
        limit: limit,
        offset: offset,
        status: 'active',
      );

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final dataList = (data is List) ? data : [];
        final products = dataList.map((json) {
          final productJson = Map<String, dynamic>.from(json);
          if (json['stores'] != null) {
            productJson['store_name'] = json['stores']['name'];
          }
          if (json['categories'] != null) {
            productJson['category_name'] = json['categories']['name'];
          }
          return ProductModel.fromJson(productJson);
        }).toList();

        debugPrint('✅ تم جلب ${products.length} منتج');
        return products;
      }

      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب المنتجات: $e');
      return [];
    }
  }

  /// جلب المنتجات حسب الفئة
  static Future<List<ProductModel>> getProductsByCategory(
    String categoryId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      // استخدام Worker API مع فلتر الفئة
      final response = await ApiService.getCategoryProducts(
        categoryId,
        limit: limit,
        offset: offset,
      );

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final dataList = (data is List) ? data : [];
        final products = dataList.map((json) {
          final productJson = Map<String, dynamic>.from(json);
          if (json['stores'] != null) {
            productJson['store_name'] = json['stores']['name'];
          }
          if (json['categories'] != null) {
            productJson['category_name'] = json['categories']['name'];
          }
          return ProductModel.fromJson(productJson);
        }).toList();

        debugPrint('✅ تم جلب ${products.length} منتج من الفئة');
        return products;
      }

      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب منتجات الفئة: $e');
      return [];
    }
  }

  /// جلب المنتجات حسب المتجر
  static Future<List<ProductModel>> getProductsByStore(
    String storeId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      // استخدام Worker API مع فلتر المتجر
      final response = await ApiService.getStoreProducts(
        storeId,
        limit: limit,
        offset: offset,
      );

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final dataList = (data is List) ? data : [];
        final products = dataList.map((json) {
          final productJson = Map<String, dynamic>.from(json);
          if (json['stores'] != null) {
            productJson['store_name'] = json['stores']['name'];
          }
          if (json['categories'] != null) {
            productJson['category_name'] = json['categories']['name'];
          }
          return ProductModel.fromJson(productJson);
        }).toList();

        debugPrint('✅ تم جلب ${products.length} منتج من المتجر');
        return products;
      }

      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب منتجات المتجر: $e');
      return [];
    }
  }

  /// جلب جميع الفئات
  static Future<List<CategoryModel>> getAllCategories() async {
    try {
      // استخدام Worker API
      final response = await ApiService.getCategories();

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final dataList = (data is List) ? data : [];
        final categories = dataList.map((json) {
          return CategoryModel.fromJson(json as Map<String, dynamic>);
        }).toList();

        debugPrint('✅ تم جلب ${categories.length} فئة');
        return categories;
      }

      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب الفئات: $e');
      return [];
    }
  }

  /// جلب جميع المتاجر
  static Future<List<StoreModel>> getAllStores() async {
    try {
      // استخدام Worker API
      final response = await ApiService.getStores();

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final dataList = (data is List) ? data : [];
        final stores = dataList.map((json) {
          return StoreModel.fromJson(json as Map<String, dynamic>);
        }).toList();

        debugPrint('✅ تم جلب ${stores.length} متجر');
        return stores;
      }

      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب المتاجر: $e');
      return [];
    }
  }

  /// فلترة المنتجات حسب نطاق السعر
  static Future<List<ProductModel>> filterByPriceRange(
    double minPrice,
    double maxPrice, {
    int limit = 50,
  }) async {
    try {
      // استخدام Worker API وفلترة محلياً
      final response = await ApiService.getProducts(
        limit: limit * 2, // جلب المزيد للفلترة
        status: 'active',
      );

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final dataList = (data is List) ? data : [];
        final products = dataList
            .where((json) {
              final price = (json['price'] as num?)?.toDouble() ?? 0.0;
              return price >= minPrice && price <= maxPrice;
            })
            .take(limit)
            .map((json) {
              final productJson = Map<String, dynamic>.from(json);
              if (json['stores'] != null) {
                productJson['store_name'] = json['stores']['name'];
              }
              if (json['categories'] != null) {
                productJson['category_name'] = json['categories']['name'];
              }
              return ProductModel.fromJson(productJson);
            })
            .toList();

        debugPrint('✅ تم فلترة ${products.length} منتج');
        return products;
      }

      return [];
    } catch (e) {
      debugPrint('❌ خطأ في فلترة المنتجات: $e');
      return [];
    }
  }

  /// Get explore videos (placeholder for video feature)
  /// Returns empty list - repository will use DummyData as fallback
  static Future<List<dynamic>> getExploreVideos({
    String? filter,
    int? page,
    int? pageSize,
  }) async {
    // Return empty list - repository will use DummyData
    return [];
  }

  /// Get video by ID (placeholder for video feature)
  /// Returns null - repository will use DummyData as fallback
  static Future<dynamic> getVideoById(String videoId) async {
    // Return null - repository will use DummyData
    return null;
  }

  /// Get videos by product (placeholder for video feature)
  /// Returns empty list - repository will use DummyData as fallback
  static Future<List<dynamic>> getVideosByProduct(String productId) async {
    // Return empty list - repository will use DummyData
    return [];
  }
}
