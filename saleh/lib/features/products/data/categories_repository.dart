import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../domain/models/category.dart';

/// Categories Repository
/// يتعامل مع جميع عمليات API الخاصة بالتصنيفات
class CategoriesRepository {
  final ApiService _apiService;

  CategoriesRepository(this._apiService);

  /// جلب جميع التصنيفات النشطة
  /// المسار: GET /categories
  /// لا يحتاج authentication (public endpoint)
  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiService.get('/categories');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['ok'] == true && data['categories'] != null) {
          final List categoriesList = data['categories'] as List;
          return categoriesList
              .map((json) => Category.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          // لا توجد تصنيفات أو استجابة غير متوقعة
          return [];
        }
      } else {
        // خطأ من الخادم
        throw Exception('فشل جلب التصنيفات (رمز ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }
}

/// Provider للـ CategoriesRepository
final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return CategoriesRepository(apiService);
});
