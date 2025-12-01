import '../dummy_data.dart';
import '../models.dart';

/// Repository للمنتجات - يوفر واجهة موحدة للوصول للبيانات
class ProductRepository {
  // Cache للمنتجات
  static List<Product>? _cachedProducts;
  static DateTime? _cacheTime;
  static const _cacheDuration = Duration(minutes: 5);

  /// جلب جميع المنتجات (مع Caching)
  Future<List<Product>> getAllProducts({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid()) {
      return _cachedProducts!;
    }

    await Future.delayed(const Duration(milliseconds: 300));

    final products = DummyData.products.cast<Product>();
    _updateCache(products);
    return products;
  }

  /// جلب منتج بالـ ID
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.getProductById(id);
  }

  /// جلب منتجات حسب الفئة مع Pagination
  Future<List<Product>> getProductsByCategory(
    String categoryId, {
    int page = 0,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allProducts = DummyData.getProductsByCategory(
      categoryId,
    ).cast<Product>();

    // تطبيق Pagination
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, allProducts.length);

    if (startIndex >= allProducts.length) return [];

    return allProducts.sublist(startIndex, endIndex);
  }

  /// جلب منتجات حسب المتجر مع Pagination
  Future<List<Product>> getProductsByStore(
    String storeId, {
    int page = 0,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allProducts = DummyData.getProductsByStore(storeId).cast<Product>();

    // تطبيق Pagination
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, allProducts.length);

    if (startIndex >= allProducts.length) return [];

    return allProducts.sublist(startIndex, endIndex);
  }

  /// البحث في المنتجات
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final allProducts = await getAllProducts();
    final lowerQuery = query.toLowerCase();

    return allProducts.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// مسح الكاش
  void clearCache() {
    _cachedProducts = null;
    _cacheTime = null;
  }

  /// التحقق من صلاحية الكاش
  bool _isCacheValid() {
    if (_cachedProducts == null || _cacheTime == null) return false;
    return DateTime.now().difference(_cacheTime!) < _cacheDuration;
  }

  /// تحديث الكاش
  void _updateCache(List<Product> products) {
    _cachedProducts = products;
    _cacheTime = DateTime.now();
  }
}
