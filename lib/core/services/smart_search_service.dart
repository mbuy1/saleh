import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// خدمة البحث الذكي باستخدام Cloudflare AI Search / AutoRAG
/// TODO: إكمال التنفيذ عند الحاجة
/// المفاتيح السرية يجب أن تكون في Worker Secrets، وليس هنا
class SmartSearchService {
  /// البحث الذكي في المنتجات
  /// 
  /// Parameters:
  /// - query: نص البحث
  /// - limit: عدد النتائج (افتراضي: 20)
  /// 
  /// Returns: List of search results
  static Future<List<Map<String, dynamic>>> searchProducts({
    required String query,
    int limit = 20,
  }) async {
    try {
      debugPrint('[SmartSearchService] Searching products: $query');
      
      final response = await ApiService.post(
        '/public/search/products',
        data: {
          'query': query,
          'limit': limit,
        },
        requireAuth: false,
      );

      if (response['ok'] == true) {
        return List<Map<String, dynamic>>.from(
          response['data']?['results'] ?? [],
        );
      } else {
        throw Exception(response['message'] ?? 'فشل البحث');
      }
    } catch (e) {
      debugPrint('[SmartSearchService] Error searching products: $e');
      rethrow;
    }
  }

  /// البحث الذكي في المتاجر
  /// 
  /// Parameters:
  /// - query: نص البحث
  /// - limit: عدد النتائج (افتراضي: 20)
  /// 
  /// Returns: List of search results
  static Future<List<Map<String, dynamic>>> searchStores({
    required String query,
    int limit = 20,
  }) async {
    try {
      debugPrint('[SmartSearchService] Searching stores: $query');
      
      final response = await ApiService.post(
        '/public/search/stores',
        data: {
          'query': query,
          'limit': limit,
        },
        requireAuth: false,
      );

      if (response['ok'] == true) {
        return List<Map<String, dynamic>>.from(
          response['data']?['results'] ?? [],
        );
      } else {
        throw Exception(response['message'] ?? 'فشل البحث');
      }
    } catch (e) {
      debugPrint('[SmartSearchService] Error searching stores: $e');
      rethrow;
    }
  }

  /// البحث الشامل (منتجات + متاجر)
  /// 
  /// Parameters:
  /// - query: نص البحث
  /// - limit: عدد النتائج لكل نوع (افتراضي: 10)
  /// 
  /// Returns: Map with products and stores results
  static Future<Map<String, dynamic>> searchAll({
    required String query,
    int limit = 10,
  }) async {
    try {
      debugPrint('[SmartSearchService] Searching all: $query');
      
      final response = await ApiService.post(
        '/public/search/all',
        data: {
          'query': query,
          'limit': limit,
        },
        requireAuth: false,
      );

      if (response['ok'] == true) {
        return {
          'products': List<Map<String, dynamic>>.from(
            response['data']?['products'] ?? [],
          ),
          'stores': List<Map<String, dynamic>>.from(
            response['data']?['stores'] ?? [],
          ),
          'suggestions': List<String>.from(
            response['data']?['suggestions'] ?? [],
          ),
        };
      } else {
        throw Exception(response['message'] ?? 'فشل البحث');
      }
    } catch (e) {
      debugPrint('[SmartSearchService] Error searching all: $e');
      rethrow;
    }
  }

  /// الحصول على اقتراحات البحث
  /// 
  /// Parameters:
  /// - query: نص البحث (جزئي)
  /// 
  /// Returns: List of search suggestions
  static Future<List<String>> getSearchSuggestions({
    required String query,
  }) async {
    try {
      debugPrint('[SmartSearchService] Getting search suggestions: $query');
      
      final response = await ApiService.post(
        '/public/search/suggestions',
        data: {
          'query': query,
        },
        requireAuth: false,
      );

      if (response['ok'] == true) {
        return List<String>.from(
          response['data']?['suggestions'] ?? [],
        );
      } else {
        throw Exception(response['message'] ?? 'فشل جلب الاقتراحات');
      }
    } catch (e) {
      debugPrint('[SmartSearchService] Error getting suggestions: $e');
      rethrow;
    }
  }
}

