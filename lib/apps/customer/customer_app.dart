import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../core/theme/app_theme.dart';
import 'routes/customer_router.dart';

/// تطبيق العميل - منفصل تماماً عن تطبيق التاجر
/// لا يحتوي أي شاشات أو مسارات أو أزرار خاصة بالتاجر
class CustomerApp extends ConsumerStatefulWidget {
  const CustomerApp({super.key});

  @override
  ConsumerState<CustomerApp> createState() => _CustomerAppState();
}

class _CustomerAppState extends ConsumerState<CustomerApp> {
  late final router = CustomerRouter.createRouter(ref);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MBUY',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,

      // Router خاص بالعميل فقط
      routerConfig: router,

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en')],
    );
  }
}
