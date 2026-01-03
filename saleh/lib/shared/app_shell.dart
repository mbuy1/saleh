import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/controllers/root_controller.dart';
import '../core/services/api_service.dart';
import '../core/services/user_preferences_service.dart';
import '../core/router/app_router.dart';
import '../apps/merchant/merchant_app.dart';
import '../apps/customer/customer_app.dart';
import '../features/auth/data/auth_controller.dart';

/// AppShell - يقرر أي تطبيق يعرض بناءً على RootController
/// هذا هو Widget الجذري للتطبيق
///
/// يدعم حفظ الجلسة (Persistent Login):
/// - عند فتح التطبيق يتحقق من وجود جلسة صالحة
/// - إذا وجدت جلسة ينتقل للواجهة المناسبة حسب الدور
/// - إذا لم توجد يعرض شاشة تسجيل الدخول
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _isCheckingSession = true;
  late final _authRouter = AppRouter.createRouter(ref);

  @override
  void initState() {
    super.initState();
    _checkSavedSession();
  }

  /// التحقق من وجود جلسة محفوظة عند فتح التطبيق
  /// يتحقق من وجود token وصحته قبل السماح بالدخول
  Future<void> _checkSavedSession() async {
    // انتظر قليلاً للسماح لـ AuthController بالتهيئة
    await Future.delayed(const Duration(milliseconds: 100));

    final apiService = ref.read(apiServiceProvider);
    final rootController = ref.read(rootControllerProvider.notifier);
    final authController = ref.read(authControllerProvider.notifier);

    // 1. التحقق من وجود token
    final hasToken = await apiService.hasValidTokens();

    if (!hasToken) {
      // لا يوجد token - عرض شاشة تسجيل الدخول
      if (mounted) {
        setState(() => _isCheckingSession = false);
      }
      return;
    }

    // 2. التحقق من صحة token عبر التحقق من الجلسة
    try {
      await authController.checkSession();
      final updatedAuthState = ref.read(authControllerProvider);

      if (updatedAuthState.isAuthenticated &&
          updatedAuthState.userType != null) {
        // توجد جلسة صالحة - انتقل للتطبيق المناسب حسب نوع المستخدم
        if (updatedAuthState.userType == 'customer') {
          rootController.switchToCustomerApp();
        } else {
          // merchant أو أي نوع آخر
          rootController.switchToMerchantApp();
        }
      } else {
        // Token غير صالح - مسح الجلسة
        await authController.logout();
      }
    } catch (e) {
      // خطأ في التحقق - مسح الجلسة
      await authController.logout();
    }

    if (mounted) {
      setState(() => _isCheckingSession = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rootState = ref.watch(rootControllerProvider);
    final themeMode = ref.watch(preferencesStateProvider).themeMode;

    // أثناء التحقق من الجلسة - عرض شاشة تحميل
    if (_isCheckingSession) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    // تحديد أي تطبيق يعرض
    if (rootState.isCustomerApp) {
      // تطبيق العميل
      return const CustomerApp();
    } else if (rootState.isMerchantApp) {
      // تطبيق التاجر
      return const MerchantApp();
    } else {
      // لم يتم تحديد التطبيق - عرض شاشة تسجيل الدخول مع GoRouter للتنقل
      return MaterialApp.router(
        title: 'MBUY',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: _authRouter,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar'), Locale('en')],
      );
    }
  }
}
