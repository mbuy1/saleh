import 'package:flutter_riverpod/flutter_riverpod.dart';

/// التطبيق الحالي - تاجر أو عميل
enum CurrentApp {
  /// تطبيق التاجر - لوحة التحكم وإدارة المتجر
  merchant,

  /// تطبيق العميل - تصفح المتاجر والشراء
  customer,

  /// غير محدد - لم يتم اختيار التطبيق بعد (شاشة تسجيل الدخول)
  none,
}

/// نية تسجيل الدخول - مؤقتة أثناء عملية تسجيل الدخول فقط
enum LoginIntent { merchant, customer }

/// حالة التطبيق الجذري
class RootState {
  final CurrentApp currentApp;
  final CurrentApp? lastApp;
  final LoginIntent? loginIntent;
  final bool isInitialized;

  /// هل يمكن الرجوع للوحة التحكم؟ (غير مستخدم حالياً)
  final bool canSwitchBackToMerchant;

  const RootState({
    this.currentApp = CurrentApp.none,
    this.lastApp,
    this.loginIntent,
    this.isInitialized = false,
    this.canSwitchBackToMerchant = false,
  });

  RootState copyWith({
    CurrentApp? currentApp,
    CurrentApp? lastApp,
    LoginIntent? loginIntent,
    bool? isInitialized,
    bool? canSwitchBackToMerchant,
    bool clearIntent = false,
    bool clearLastApp = false,
  }) {
    return RootState(
      currentApp: currentApp ?? this.currentApp,
      lastApp: clearLastApp ? null : (lastApp ?? this.lastApp),
      loginIntent: clearIntent ? null : (loginIntent ?? this.loginIntent),
      isInitialized: isInitialized ?? this.isInitialized,
      canSwitchBackToMerchant:
          canSwitchBackToMerchant ?? this.canSwitchBackToMerchant,
    );
  }

  bool get isMerchantApp => currentApp == CurrentApp.merchant;
  bool get isCustomerApp => currentApp == CurrentApp.customer;
  bool get hasNoApp => currentApp == CurrentApp.none;
}

/// متحكم الجذر - يقرر أي تطبيق يعمل
class RootController extends Notifier<RootState> {
  @override
  RootState build() => const RootState();

  /// تعيين نية تسجيل الدخول (مؤقت)
  void setLoginIntent(LoginIntent intent) {
    state = state.copyWith(loginIntent: intent);
  }

  /// مسح نية تسجيل الدخول
  void clearLoginIntent() {
    state = state.copyWith(clearIntent: true);
  }

  /// الانتقال إلى تطبيق التاجر
  void switchToMerchantApp() {
    state = state.copyWith(
      currentApp: CurrentApp.merchant,
      isInitialized: true,
      clearIntent: true,
      canSwitchBackToMerchant: false,
    );
  }

  /// الانتقال إلى تطبيق العميل
  void switchToCustomerApp() {
    state = state.copyWith(
      currentApp: CurrentApp.customer,
      isInitialized: true,
      clearIntent: true,
      canSwitchBackToMerchant: true,
    );
  }

  /// إعادة التعيين (عند تسجيل الخروج)
  void reset() {
    state = const RootState();
  }

  /// تهيئة التطبيق بعد تسجيل الدخول الناجح
  void initializeAfterLogin() {
    // دائماً ننتقل لتطبيق التاجر
    switchToMerchantApp();
  }
}

/// Provider للتحكم بالتطبيق الجذري
final rootControllerProvider = NotifierProvider<RootController, RootState>(
  RootController.new,
);

/// Provider للتطبيق الحالي
final currentAppProvider = Provider<CurrentApp>((ref) {
  return ref.watch(rootControllerProvider).currentApp;
});

/// Provider للتحقق هل التطبيق هو تطبيق التاجر
final isMerchantAppProvider = Provider<bool>((ref) {
  return ref.watch(rootControllerProvider).isMerchantApp;
});
