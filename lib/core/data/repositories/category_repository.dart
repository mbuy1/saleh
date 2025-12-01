import '../dummy_data.dart';
import '../models.dart';

/// Repository للفئات - يوفر واجهة موحدة للوصول للبيانات
class CategoryRepository {
  // Cache للفئات (الفئات نادراً ما تتغير)
  static List<Category>? _cachedMainCategories;
  static List<Category>? _cachedAllCategories;

  /// جلب الفئات الرئيسية
  Future<List<Category>> getMainCategories() async {
    if (_cachedMainCategories != null) {
      return _cachedMainCategories!;
    }

    await Future.delayed(const Duration(milliseconds: 200));
    final categories = DummyData.mainCategories.cast<Category>();
    _cachedMainCategories = categories;
    return categories;
  }

  /// جلب جميع الفئات
  Future<List<Category>> getAllCategories() async {
    if (_cachedAllCategories != null) {
      return _cachedAllCategories!;
    }

    await Future.delayed(const Duration(milliseconds: 200));
    final categories = DummyData.allCategories.cast<Category>();
    _cachedAllCategories = categories;
    return categories;
  }

  /// جلب فئة بالـ ID
  Future<Category?> getCategoryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final categories = await getAllCategories();
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// جلب الفئات الفرعية
  Future<List<Category>> getSubcategories(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final categories = DummyData.getCategoriesByParent(
      parentId,
    ).cast<Category>();
    return categories;
  }

  /// مسح الكاش
  void clearCache() {
    _cachedMainCategories = null;
    _cachedAllCategories = null;
  }
}
