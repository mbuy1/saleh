import 'package:flutter/foundation.dart';
import '../../../../core/supabase_client.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/store_model.dart';

/// خدمة الصفحة الرئيسية - جلب البيانات من Supabase
class HomeService {
  /// جلب المنتجات المميزة (Best Offers)
  static Future<List<ProductModel>> getFeaturedProducts({
    int limit = 10,
  }) async {
    try {
      final response = await supabaseClient
          .from('products')
          .select('''
            *,
            stores!inner(name),
            categories(name)
          ''')
          .eq('is_active', true)
          .not('discount_price', 'is', null)
          .gt('stock_quantity', 0)
          .order('created_at', ascending: false)
          .limit(limit);

      debugPrint('✅ تم جلب ${(response as List).length} منتج مميز');

      return (response as List).map((json) {
        // دمج بيانات المتجر والفئة
        final productJson = Map<String, dynamic>.from(json);
        if (json['stores'] != null) {
          productJson['store_name'] = json['stores']['name'];
        }
        if (json['categories'] != null) {
          productJson['category_name'] = json['categories']['name'];
        }
        return ProductModel.fromJson(productJson);
      }).toList();
    } catch (e) {
      debugPrint('❌ خطأ في جلب المنتجات المميزة: $e');
      return [];
    }
  }

  /// جلب المنتجات الجديدة (New Arrivals)
  static Future<List<ProductModel>> getNewArrivals({int limit = 10}) async {
    try {
      final response = await supabaseClient
          .from('products')
          .select('''
            *,
            stores!inner(name),
            categories(name)
          ''')
          .eq('is_active', true)
          .gt('stock_quantity', 0)
          .order('created_at', ascending: false)
          .limit(limit);

      debugPrint('✅ تم جلب ${(response as List).length} منتج جديد');

      return (response as List).map((json) {
        final productJson = Map<String, dynamic>.from(json);
        if (json['stores'] != null) {
          productJson['store_name'] = json['stores']['name'];
        }
        if (json['categories'] != null) {
          productJson['category_name'] = json['categories']['name'];
        }
        return ProductModel.fromJson(productJson);
      }).toList();
    } catch (e) {
      debugPrint('❌ خطأ في جلب المنتجات الجديدة: $e');
      return [];
    }
  }

  /// جلب المنتجات الأكثر مبيعاً (Best Sellers)
  static Future<List<ProductModel>> getBestSellers({int limit = 10}) async {
    try {
      // يمكن تحسينها لاحقاً بناءً على عدد الطلبات
      final response = await supabaseClient
          .from('products')
          .select('''
            *,
            stores!inner(name),
            categories(name)
          ''')
          .eq('is_active', true)
          .gt('stock_quantity', 0)
          .order('rating', ascending: false)
          .limit(limit);

      debugPrint('✅ تم جلب ${(response as List).length} منتج الأكثر مبيعاً');

      return (response as List).map((json) {
        final productJson = Map<String, dynamic>.from(json);
        if (json['stores'] != null) {
          productJson['store_name'] = json['stores']['name'];
        }
        if (json['categories'] != null) {
          productJson['category_name'] = json['categories']['name'];
        }
        return ProductModel.fromJson(productJson);
      }).toList();
    } catch (e) {
      debugPrint('❌ خطأ في جلب المنتجات الأكثر مبيعاً: $e');
      return [];
    }
  }

  /// جلب الفئات الرئيسية
  static Future<List<CategoryModel>> getMainCategories({int limit = 20}) async {
    try {
      final response = await supabaseClient
          .from('categories')
          .select('*, products!inner(count)')
          .eq('is_active', true)
          .order('display_order', ascending: true)
          .limit(limit);

      debugPrint('✅ تم جلب ${(response as List).length} فئة');

      return (response as List).map((json) {
        return CategoryModel.fromJson(json);
      }).toList();
    } catch (e) {
      debugPrint('❌ خطأ في جلب الفئات: $e');
      return [];
    }
  }

  /// جلب المتاجر المميزة
  static Future<List<StoreModel>> getFeaturedStores({int limit = 10}) async {
    try {
      final response = await supabaseClient
          .from('stores')
          .select('*, products(count)')
          .eq('is_active', true)
          .order('rating', ascending: false)
          .limit(limit);

      debugPrint('✅ تم جلب ${(response as List).length} متجر مميز');

      return (response as List).map((json) {
        return StoreModel.fromJson(json);
      }).toList();
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
