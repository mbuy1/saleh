import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/store.dart';
import 'merchant_repository.dart';

/// Merchant Store State
/// حالة المتجر مع التحميل والأخطاء
class MerchantStoreState {
  final Store? store;
  final bool isLoading;
  final String? errorMessage;

  MerchantStoreState({this.store, this.isLoading = false, this.errorMessage});

  MerchantStoreState copyWith({
    Store? store,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MerchantStoreState(
      store: store ?? this.store,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasStore => store != null;
  bool get hasError => errorMessage != null;
}

/// Merchant Store Controller
/// يدير حالة المتجر باستخدام StateNotifier
class MerchantStoreController extends StateNotifier<MerchantStoreState> {
  final MerchantRepository _repository;

  MerchantStoreController(this._repository)
    : super(MerchantStoreState(isLoading: false));

  /// جلب متجر التاجر
  Future<void> loadMerchantStore() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final store = await _repository.getMerchantStore();
      state = MerchantStoreState(store: store, isLoading: false);
    } catch (e) {
      state = MerchantStoreState(
        store: null,
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// إنشاء متجر جديد
  Future<bool> createStore({
    required String name,
    String? description,
    String? city,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final newStore = await _repository.createStore(
        name: name,
        description: description,
        city: city,
      );

      state = MerchantStoreState(store: newStore, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// تحديث معلومات المتجر
  Future<bool> updateStoreInfo({
    required String storeId,
    String? name,
    String? description,
    String? city,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final updatedStore = await _repository.updateStore(
        storeId: storeId,
        name: name,
        description: description,
        city: city,
      );

      state = MerchantStoreState(store: updatedStore, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// تحديث المتجر المحلي (بعد التعديل)
  void updateStore(Store store) {
    state = state.copyWith(store: store);
  }

  /// مسح حالة المتجر
  void clearStore() {
    state = MerchantStoreState(isLoading: false);
  }

  /// مسح رسالة الخطأ
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider للـ MerchantStoreController
final merchantStoreControllerProvider =
    StateNotifierProvider<MerchantStoreController, MerchantStoreState>((ref) {
      final repository = ref.watch(merchantRepositoryProvider);
      return MerchantStoreController(repository);
    });

/// Provider لحالة المتجر فقط
final merchantStoreProvider = Provider<Store?>((ref) {
  return ref.watch(merchantStoreControllerProvider).store;
});

/// Provider لحالة التحميل
final merchantStoreLoadingProvider = Provider<bool>((ref) {
  return ref.watch(merchantStoreControllerProvider).isLoading;
});

/// Provider لرسالة الخطأ
final merchantStoreErrorProvider = Provider<String?>((ref) {
  return ref.watch(merchantStoreControllerProvider).errorMessage;
});

/// Provider للتحقق من وجود متجر
final hasMerchantStoreProvider = Provider<bool>((ref) {
  return ref.watch(merchantStoreControllerProvider).hasStore;
});
