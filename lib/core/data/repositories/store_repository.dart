import 'package:flutter/foundation.dart';
import '../dummy_data.dart';
import '../models.dart';
import '../../services/api_service.dart';

/// Repository للمتاجر - يوفر واجهة موحدة للوصول للبيانات من Worker API
class StoreRepository {
  // Cache للمتاجر
  static List<Store>? _cachedStores;
  static DateTime? _cacheTime;
  static const _cacheDuration = Duration(minutes: 10);

  /// جلب جميع المتاجر من Worker API (مع Caching و Pagination)
  Future<List<Store>> getAllStores({
    bool forceRefresh = false,
    int page = 0,
    int pageSize = 10,
  }) async {
    List<Store> allStores;

    if (!forceRefresh && _isCacheValid()) {
      allStores = _cachedStores!;
    } else {
      try {
        final response = await ApiService.getStores(
          limit: 100, // جلب كل المتاجر
        );

        if (response['ok'] == true && response['data'] != null) {
          final data = response['data'];
          final storesData = (data is List) ? data : [];
          allStores = storesData
              .map((json) => Store.fromJson(json as Map<String, dynamic>))
              .toList();
          debugPrint('✅ تم جلب ${allStores.length} متجر من Worker API');
          _updateCache(allStores);
        } else {
          // Fallback to dummy data if API fails
          debugPrint(
            '⚠️ Worker API failed, using fallback data: ${response['error']}',
          );
          allStores = DummyData.stores.cast<Store>();
          _updateCache(allStores);
        }
      } catch (e) {
        debugPrint('❌ خطأ في جلب المتاجر: $e');
        // Fallback to dummy data
        allStores = DummyData.stores.cast<Store>();
        _updateCache(allStores);
      }
    }

    // تطبيق Pagination
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, allStores.length);

    if (startIndex >= allStores.length) return [];

    return allStores.sublist(startIndex, endIndex);
  }

  /// جلب متجر بالـ ID من Worker API
  Future<Store?> getStoreById(String id) async {
    try {
      final response = await ApiService.getStoreById(id);

      if (response['ok'] == true && response['data'] != null) {
        debugPrint('✅ تم جلب المتجر $id من Worker API');
        return Store.fromJson(response['data']);
      }

      // Fallback to dummy data
      debugPrint('⚠️ Store not found in API, using fallback');
      return DummyData.getStoreById(id);
    } catch (e) {
      debugPrint('❌ خطأ في جلب المتجر: $e');
      return DummyData.getStoreById(id);
    }
  }

  /// جلب المتاجر المدعومة من Worker API
  Future<List<Store>> getBoostedStores() async {
    try {
      final response = await ApiService.getStores(isBoosted: true, limit: 50);

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final storesData = (data is List) ? data : [];
        final stores = storesData
            .map((json) => Store.fromJson(json as Map<String, dynamic>))
            .toList();
        debugPrint('✅ تم جلب ${stores.length} متجر مدعوم');
        return stores;
      }

      // Fallback
      debugPrint('⚠️ Using fallback for boosted stores');
      final allStores = await getAllStores(pageSize: 100);
      return allStores.where((s) => s.isBoosted).toList();
    } catch (e) {
      debugPrint('❌ خطأ: $e');
      final allStores = await getAllStores(pageSize: 100);
      return allStores.where((s) => s.isBoosted).toList();
    }
  }

  /// جلب المتاجر الموثقة من Worker API
  Future<List<Store>> getVerifiedStores() async {
    try {
      final response = await ApiService.getStores(isVerified: true, limit: 50);

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'];
        final storesData = (data is List) ? data : [];
        final stores = storesData
            .map((json) => Store.fromJson(json as Map<String, dynamic>))
            .toList();
        debugPrint('✅ تم جلب ${stores.length} متجر موثق');
        return stores;
      }

      // Fallback
      debugPrint('⚠️ Using fallback for verified stores');
      final allStores = await getAllStores(pageSize: 100);
      return allStores.where((s) => s.isVerified).toList();
    } catch (e) {
      debugPrint('❌ خطأ: $e');
      final allStores = await getAllStores(pageSize: 100);
      return allStores.where((s) => s.isVerified).toList();
    }
  }

  /// البحث في المتاجر
  Future<List<Store>> searchStores(String query) async {
    // البحث محلياً من الكاش حالياً
    // يمكن إضافة endpoint للبحث في Worker لاحقاً
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
