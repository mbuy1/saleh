import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/controllers/root_controller.dart';
import '../apps/customer/customer_app.dart';
import '../apps/merchant/merchant_app.dart';
import 'screens/login_screen.dart';

/// AppShell - يقرر أي تطبيق يعرض بناءً على RootController
/// هذا هو Widget الجذري للتطبيق
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootState = ref.watch(rootControllerProvider);

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
