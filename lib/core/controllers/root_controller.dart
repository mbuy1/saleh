import 'package:flutter_riverpod/flutter_riverpod.dart';

/// التطبيق الحالي - عميل أو تاجر
/// كل تطبيق يعمل بشكل مستقل تماماً
enum CurrentApp {
  /// تطبيق العميل - للتسوق والشراء فقط
  customer,

  /// تطبيق التاجر - لوحة التحكم وإدارة المتجر
  merchant,

  /// غير محدد - لم يتم اختيار التطبيق بعد (شاشة تسجيل الدخول)
  none,
}

/// نية تسجيل الدخول - مؤقتة أثناء عملية تسجيل الدخول فقط
enum LoginIntent { customer, merchant }

/// حالة التطبيق الجذري
class RootState {
  final CurrentApp currentApp;
  final CurrentApp? lastApp;
  final LoginIntent? loginIntent;
  final bool isInitialized;

  /// هل يمكن الرجوع للوحة التحكم؟
  /// true فقط إذا دخل المستخدم CustomerApp عبر زر Switch من MerchantApp
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

  bool get isCustomerApp => currentApp == CurrentApp.customer;
  bool get isMerchantApp => currentApp == CurrentApp.merchant;
  bool get hasNoApp => currentApp == CurrentApp.none;

  /// هل التاجر يشاهد كعميل؟
  bool get isMerchantViewingAsCustomer =>
      isCustomerApp &&
      canSwitchBackToMerchant &&
      lastApp == CurrentApp.merchant;
}

/// متحكم الجذر - يقرر أي تطبيق يعمل
class RootController extends StateNotifier<RootState> {
  RootController() : super(const RootState());

  /// تعيين نية تسجيل الدخول (مؤقت)
  void setLoginIntent(LoginIntent intent) {
    state = state.copyWith(loginIntent: intent);
  }

  /// مسح نية تسجيل الدخول
  void clearLoginIntent() {
    state = state.copyWith(clearIntent: true);
  }

  /// الانتقال إلى تطبيق العميل (تسجيل دخول عادي)
  void switchToCustomerApp() {
    state = state.copyWith(
      currentApp: CurrentApp.customer,
      isInitialized: true,
      clearIntent: true,
      canSwitchBackToMerchant: false,
    );
  }

  /// الانتقال إلى تطبيق العميل من لوحة التاجر (يمكنه الرجوع)
  void switchToCustomerAppFromMerchant() {
    state = state.copyWith(
      lastApp: CurrentApp.merchant,
      currentApp: CurrentApp.customer,
      isInitialized: true,
      clearIntent: true,
      canSwitchBackToMerchant: true,
    );
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

  /// الرجوع إلى لوحة التحكم (من CustomerApp بعد Switch)
  void switchBackToMerchantDashboard() {
    if (state.canSwitchBackToMerchant && state.lastApp == CurrentApp.merchant) {
      state = state.copyWith(
        currentApp: CurrentApp.merchant,
        isInitialized: true,
        // نُبقي canSwitchBackToMerchant = true للسماح بالتبديل مجدداً
      );
    }
  }

  /// إعادة التعيين (عند تسجيل الخروج)
  void reset() {
    state = const RootState();
  }

  /// تهيئة التطبيق بعد تسجيل الدخول الناجح
  void initializeAfterLogin() {
    final intent = state.loginIntent;
    if (intent == LoginIntent.customer) {
      switchToCustomerApp();
    } else if (intent == LoginIntent.merchant) {
      switchToMerchantApp();
    }
  }
}

/// Provider للتحكم بالتطبيق الجذري
final rootControllerProvider = StateNotifierProvider<RootController, RootState>(
  (ref) => RootController(),
);

/// Provider للتطبيق الحالي
final currentAppProvider = Provider<CurrentApp>((ref) {
  return ref.watch(rootControllerProvider).currentApp;
});

/// Provider للتحقق هل التطبيق هو تطبيق العميل
final isCustomerAppProvider = Provider<bool>((ref) {
  return ref.watch(rootControllerProvider).isCustomerApp;
});

/// Provider للتحقق هل التطبيق هو تطبيق التاجر
final isMerchantAppProvider = Provider<bool>((ref) {
  return ref.watch(rootControllerProvider).isMerchantApp;
});

/// Provider للتحقق هل التاجر يشاهد كعميل (يمكنه الرجوع للوحة التحكم)
final canSwitchBackToMerchantProvider = Provider<bool>((ref) {
  return ref.watch(rootControllerProvider).canSwitchBackToMerchant;
});

/// Provider للتحقق هل التاجر يشاهد كعميل
final isMerchantViewingAsCustomerProvider = Provider<bool>((ref) {
  return ref.watch(rootControllerProvider).isMerchantViewingAsCustomer;
});
