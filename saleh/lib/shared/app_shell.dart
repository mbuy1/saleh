import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/controllers/root_controller.dart';
import '../apps/customer/customer_app.dart';
import '../apps/merchant/merchant_app.dart';
import '../features/auth/data/auth_controller.dart';
import 'screens/login_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _checkSavedSession();
  }

  /// التحقق من وجود جلسة محفوظة عند فتح التطبيق
  Future<void> _checkSavedSession() async {
    // انتظر قليلاً للسماح لـ AuthController بالتهيئة
    await Future.delayed(const Duration(milliseconds: 100));

    final authState = ref.read(authControllerProvider);
    final rootController = ref.read(rootControllerProvider.notifier);

    if (authState.isAuthenticated && authState.userRole != null) {
      // توجد جلسة صالحة - انتقل للتطبيق المناسب حسب الدور
      if (authState.userRole == 'merchant') {
        rootController.switchToMerchantApp();
      } else {
        rootController.switchToCustomerApp();
      }
    }

    if (mounted) {
      setState(() => _isCheckingSession = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rootState = ref.watch(rootControllerProvider);

    // أثناء التحقق من الجلسة - عرض شاشة تحميل
    if (_isCheckingSession) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    // تحديد أي تطبيق يعرض
    switch (rootState.currentApp) {
      case CurrentApp.customer:
        // تطبيق العميل - منفصل تماماً
        return const CustomerApp();

      case CurrentApp.merchant:
        // تطبيق التاجر - منفصل تماماً
        return const MerchantApp();

      case CurrentApp.none:
        // لم يتم تحديد التطبيق - عرض شاشة تسجيل الدخول
        return MaterialApp(
          title: 'MBUY',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar'), Locale('en')],
          home: const LoginScreen(),
        );
    }
  }
}
