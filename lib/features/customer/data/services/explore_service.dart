import 'package:flutter/foundation.dart';
import '../../../../core/supabase_client.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/store_model.dart';

/// خدمة صفحة Explore - البحث والاستكشاف
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

      final response = await supabaseClient
          .from('products')
          .select('''
            *,
            stores!inner(name),
            categories(name)
          ''')
          .eq('is_active', true)
          .gt('stock_quantity', 0)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      debugPrint('✅ تم العثور على ${(response as List).length} منتج');

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
          .range(offset, offset + limit - 1);

      debugPrint('✅ تم جلب ${(response as List).length} منتج');

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
      final response = await supabaseClient
          .from('products')
          .select('''
            *,
            stores!inner(name),
            categories!inner(name)
          ''')
          .eq('is_active', true)
          .eq('category_id', categoryId)
          .gt('stock_quantity', 0)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      debugPrint('✅ تم جلب ${(response as List).length} منتج من الفئة');

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
      final response = await supabaseClient
          .from('products')
          .select('''
            *,
            stores!inner(name),
            categories(name)
          ''')
          .eq('is_active', true)
          .eq('store_id', storeId)
          .gt('stock_quantity', 0)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      debugPrint('✅ تم جلب ${(response as List).length} منتج من المتجر');

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
      debugPrint('❌ خطأ في جلب منتجات المتجر: $e');
      return [];
    }
  }

  /// جلب جميع الفئات
  static Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await supabaseClient
          .from('categories')
          .select('*')
          .eq('is_active', true)
          .order('display_order', ascending: true);

      debugPrint('✅ تم جلب ${(response as List).length} فئة');

      return (response as List).map((json) {
        return CategoryModel.fromJson(json);
      }).toList();
    } catch (e) {
      debugPrint('❌ خطأ في جلب الفئات: $e');
      return [];
    }
  }

  /// جلب جميع المتاجر
  static Future<List<StoreModel>> getAllStores() async {
    try {
      final response = await supabaseClient
          .from('stores')
          .select('*')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      debugPrint('✅ تم جلب ${(response as List).length} متجر');

      return (response as List).map((json) {
        return StoreModel.fromJson(json);
      }).toList();
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
      final response = await supabaseClient
          .from('products')
          .select('''
            *,
            stores!inner(name),
            categories(name)
          ''')
          .eq('is_active', true)
          .gte('price', minPrice)
          .lte('price', maxPrice)
          .gt('stock_quantity', 0)
          .order('price', ascending: true)
          .limit(limit);

      debugPrint('✅ تم فلترة ${(response as List).length} منتج');

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
      debugPrint('❌ خطأ في فلترة المنتجات: $e');
      return [];
    }
  }
}
