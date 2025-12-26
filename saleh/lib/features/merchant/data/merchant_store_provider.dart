import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/store.dart';
import 'merchant_repository.dart';

/// Merchant Store Controller
/// يدير حالة المتجر باستخدام AsyncNotifier
/// يستخدم AsyncValue للتعامل مع loading/error/data
class MerchantStoreController extends AsyncNotifier<Store?> {
  late MerchantRepository _repository;

  @override
  Future<Store?> build() async {
    _repository = ref.watch(merchantRepositoryProvider);
    // تحميل المتجر تلقائياً عند الإنشاء
    return await _loadStore();
  }

  /// جلب متجر التاجر
  Future<Store?> _loadStore() async {
    try {
      return await _repository.getMerchantStore();
    } catch (e) {
      // في حالة عدم وجود متجر، نعيد null بدلاً من رمي خطأ
      if (e.toString().contains('not found') ||
          e.toString().contains('NO_STORE')) {
        return null;
      }
      rethrow;
    }
  }

  /// إعادة تحميل المتجر
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadStore());
  }

  /// إنشاء متجر جديد
  Future<bool> createStore({
    required String name,
    String? description,
    String? city,
  }) async {
    state = const AsyncLoading();

    try {
      final newStore = await _repository.createStore(
        name: name,
        description: description,
        city: city,
      );

      state = AsyncData(newStore);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// تحديث معلومات المتجر
  Future<bool> updateStoreInfo({
    required String storeId,
    String? name,
    String? description,
    String? city,
    Map<String, dynamic>? settings,
  }) async {
    final previousState = state;
    state = const AsyncLoading();

    try {
      final updatedStore = await _repository.updateStore(
        storeId: storeId,
        name: name,
        description: description,
        city: city,
        settings: settings,
      );

      state = AsyncData(updatedStore);
      return true;
    } catch (e, st) {
      // استعادة الحالة السابقة مع إضافة الخطأ
      state = previousState.hasValue
          ? AsyncData(previousState.value)
          : AsyncError(e, st);
      return false;
    }
  }

  /// تحديث إعدادات المتجر فقط
  Future<bool> updateStoreSettings(Map<String, dynamic> newSettings) async {
    final currentStore = state.hasValue ? state.value : null;
    if (currentStore == null) return false;

    // دمج الإعدادات الجديدة مع القديمة
    final currentSettings = currentStore.settings ?? {};
    final mergedSettings = {...currentSettings, ...newSettings};

    return updateStoreInfo(storeId: currentStore.id, settings: mergedSettings);
  }

  /// تحديث المتجر المحلي (بعد التعديل)
  void updateStore(Store store) {
    state = AsyncData(store);
  }

  /// مسح حالة المتجر
  void clearStore() {
    state = const AsyncData(null);
  }
}

/// Provider للـ MerchantStoreController
final merchantStoreControllerProvider =
    AsyncNotifierProvider<MerchantStoreController, Store?>(
      MerchantStoreController.new,
    );

/// Provider لحالة المتجر فقط
final merchantStoreProvider = Provider<Store?>((ref) {
  final state = ref.watch(merchantStoreControllerProvider);
  return state.hasValue ? state.value : null;
});

/// Provider لحالة التحميل
final merchantStoreLoadingProvider = Provider<bool>((ref) {
  return ref.watch(merchantStoreControllerProvider).isLoading;
});

/// Provider لرسالة الخطأ
final merchantStoreErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(merchantStoreControllerProvider);
  return state.hasError ? state.error.toString() : null;
});

/// Provider للتحقق من وجود متجر
final hasMerchantStoreProvider = Provider<bool>((ref) {
  final state = ref.watch(merchantStoreControllerProvider);
  return state.hasValue && state.value != null;
});
