import '../dummy_data.dart';
import '../models.dart';

/// Repository للمتاجر - يوفر واجهة موحدة للوصول للبيانات
class StoreRepository {
  // Cache للمتاجر
  static List<Store>? _cachedStores;
  static DateTime? _cacheTime;
  static const _cacheDuration = Duration(minutes: 10);

  /// جلب جميع المتاجر (مع Caching و Pagination)
  Future<List<Store>> getAllStores({
    bool forceRefresh = false,
    int page = 0,
    int pageSize = 10,
  }) async {
    List<Store> allStores;

    if (!forceRefresh && _isCacheValid()) {
      allStores = _cachedStores!;
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
      allStores = DummyData.stores.cast<Store>();
      _updateCache(allStores);
    }

    // تطبيق Pagination
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, allStores.length);

    if (startIndex >= allStores.length) return [];

    return allStores.sublist(startIndex, endIndex);
  }

  /// جلب متجر بالـ ID
  Future<Store?> getStoreById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.getStoreById(id);
  }

  /// جلب المتاجر المدعومة
  Future<List<Store>> getBoostedStores() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final allStores = await getAllStores(pageSize: 100);
    return allStores.where((s) => s.isBoosted).toList();
  }

  /// جلب المتاجر الموثقة
  Future<List<Store>> getVerifiedStores() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final allStores = await getAllStores(pageSize: 100);
    return allStores.where((s) => s.isVerified).toList();
  }

  /// البحث في المتاجر
  Future<List<Store>> searchStores(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final allStores = await getAllStores(pageSize: 100);
    final lowerQuery = query.toLowerCase();

    return allStores.where((store) {
      return store.name.toLowerCase().contains(lowerQuery) ||
          store.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// مسح الكاش
  void clearCache() {
    _cachedStores = null;
    _cacheTime = null;
  }

  /// التحقق من صلاحية الكاش
  bool _isCacheValid() {
    if (_cachedStores == null || _cacheTime == null) return false;
    return DateTime.now().difference(_cacheTime!) < _cacheDuration;
  }

  /// تحديث الكاش
  void _updateCache(List<Store> stores) {
    _cachedStores = stores;
    _cacheTime = DateTime.now();
  }
}
