import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/store_model.dart';

/// خدمة الصفحة الرئيسية - جلب البيانات من Worker API
class HomeService {
  /// جلب المنتجات المميزة (Best Offers)
  static Future<List<ProductModel>> getFeaturedProducts({
    int limit = 10,
  }) async {
    try {
      final response = await ApiService.getFeaturedProducts(limit: limit);

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final products = (data is List) ? data : [];
        debugPrint('✅ تم جلب ${products.length} منتج مميز');

        return products.map((json) {
          final productJson = Map<String, dynamic>.from(json);
          if (json['stores'] != null) {
            productJson['store_name'] = json['stores']['name'];
          }
          if (json['categories'] != null) {
            productJson['category_name'] = json['categories']['name'];
          }
          return ProductModel.fromJson(productJson);
        }).toList();
      }

      debugPrint('⚠️ لا توجد منتجات مميزة: ${response['error'] ?? 'Unknown'}');
      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب المنتجات المميزة: $e');
      return [];
    }
  }

  /// جلب المنتجات الجديدة (New Arrivals)
  static Future<List<ProductModel>> getNewArrivals({int limit = 10}) async {
    try {
      final response = await ApiService.getNewArrivals(limit: limit);

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final products = (data is List) ? data : [];
        debugPrint('✅ تم جلب ${products.length} منتج جديد');

        return products.map((json) {
          final productJson = Map<String, dynamic>.from(json);
          if (json['stores'] != null) {
            productJson['store_name'] = json['stores']['name'];
          }
          if (json['categories'] != null) {
            productJson['category_name'] = json['categories']['name'];
          }
          return ProductModel.fromJson(productJson);
        }).toList();
      }

      debugPrint('⚠️ لا توجد منتجات جديدة: ${response['error'] ?? 'Unknown'}');
      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب المنتجات الجديدة: $e');
      return [];
    }
  }

  /// جلب المنتجات الأكثر مبيعاً (Best Sellers)
  static Future<List<ProductModel>> getBestSellers({int limit = 10}) async {
    try {
      final response = await ApiService.getBestSellers(limit: limit);

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final products = (data is List) ? data : [];
        debugPrint('✅ تم جلب ${products.length} منتج الأكثر مبيعاً');

        return products.map((json) {
          final productJson = Map<String, dynamic>.from(json);
          if (json['stores'] != null) {
            productJson['store_name'] = json['stores']['name'];
          }
          if (json['categories'] != null) {
            productJson['category_name'] = json['categories']['name'];
          }
          return ProductModel.fromJson(productJson);
        }).toList();
      }

      debugPrint('⚠️ لا توجد منتجات: ${response['error'] ?? 'Unknown'}');
      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب المنتجات الأكثر مبيعاً: $e');
      return [];
    }
  }

  /// جلب الفئات الرئيسية
  static Future<List<CategoryModel>> getMainCategories({int limit = 20}) async {
    try {
      final response = await ApiService.getCategories();

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final dataList = (data is List) ? data : [];
        final categories = dataList.take(limit).toList();
        debugPrint('✅ تم جلب ${categories.length} فئة');

        return categories.map((json) {
          return CategoryModel.fromJson(json);
        }).toList();
      }

      debugPrint('⚠️ لا توجد فئات: ${response['error'] ?? 'Unknown'}');
      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب الفئات: $e');
      return [];
    }
  }

  /// جلب المتاجر المميزة
  static Future<List<StoreModel>> getFeaturedStores({int limit = 10}) async {
    try {
      final response = await ApiService.getStores(
        limit: limit,
        sortBy: 'rating',
        descending: true,
      );

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final stores = (data is List) ? data : [];
        debugPrint('✅ تم جلب ${stores.length} متجر مميز');

        return stores.map((json) {
          return StoreModel.fromJson(json);
        }).toList();
      }

      debugPrint('⚠️ لا توجد متاجر: ${response['error'] ?? 'Unknown'}');
      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب المتاجر المميزة: $e');
      return [];
    }
  }

  /// جلب بيانات الصفحة الرئيسية دفعة واحدة
  static Future<Map<String, dynamic>> getHomeData() async {
    try {
      debugPrint('🔄 جاري جلب بيانات الصفحة الرئيسية...');

      final results = await Future.wait([
        getFeaturedProducts(limit: 10),
        getNewArrivals(limit: 10),
        getBestSellers(limit: 10),
        getMainCategories(limit: 8),
        getFeaturedStores(limit: 5),
      ]);

      debugPrint('✅ تم جلب جميع بيانات الصفحة الرئيسية بنجاح');

      return {
        'featuredProducts': results[0],
        'newArrivals': results[1],
        'bestSellers': results[2],
        'categories': results[3],
        'featuredStores': results[4],
      };
    } catch (e) {
      debugPrint('❌ خطأ في جلب بيانات الصفحة الرئيسية: $e');
      return {
        'featuredProducts': <ProductModel>[],
        'newArrivals': <ProductModel>[],
        'bestSellers': <ProductModel>[],
        'categories': <CategoryModel>[],
        'featuredStores': <StoreModel>[],
      };
    }
  }
}
