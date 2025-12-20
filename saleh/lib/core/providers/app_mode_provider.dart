import 'package:flutter_riverpod/flutter_riverpod.dart';

/// وضع التطبيق - تاجر أو عميل
enum AppMode {
  merchant, // لوحة تحكم التاجر
  customer, // تطبيق العميل/المتسوق
}

/// حالة وضع التطبيق
class AppModeState {
  final AppMode currentMode;

  const AppModeState({this.currentMode = AppMode.merchant});

  AppModeState copyWith({AppMode? currentMode}) {
    return AppModeState(currentMode: currentMode ?? this.currentMode);
  }

  bool get isMerchant => currentMode == AppMode.merchant;
  bool get isCustomer => currentMode == AppMode.customer;
}

/// متحكم وضع التطبيق
class AppModeController extends StateNotifier<AppModeState> {
  AppModeController() : super(const AppModeState());

  /// التبديل إلى وضع التاجر
  void switchToMerchant() {
    state = state.copyWith(currentMode: AppMode.merchant);
  }

  /// التبديل إلى وضع العميل
  void switchToCustomer() {
    state = state.copyWith(currentMode: AppMode.customer);
  }

  /// تبديل الوضع
  void toggleMode() {
    if (state.isMerchant) {
      switchToCustomer();
    } else {
      switchToMerchant();
    }
  }

  /// تعيين الوضع مباشرة
  void setMode(AppMode mode) {
    state = state.copyWith(currentMode: mode);
  }
}

/// Provider لوضع التطبيق
final appModeProvider = StateNotifierProvider<AppModeController, AppModeState>(
  (ref) => AppModeController(),
);

/// Provider مختصر للوضع الحالي
final currentAppModeProvider = Provider<AppMode>((ref) {
  return ref.watch(appModeProvider).currentMode;
});

/// Provider للتحقق هل الوضع تاجر
final isMerchantModeProvider = Provider<bool>((ref) {
  return ref.watch(appModeProvider).isMerchant;
});

/// Provider للتحقق هل الوضع عميل
final isCustomerModeProvider = Provider<bool>((ref) {
  return ref.watch(appModeProvider).isCustomer;
});
