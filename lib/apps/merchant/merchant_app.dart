import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/router/app_router.dart';

/// تطبيق التاجر - لوحة التحكم وإدارة المتجر
/// منفصل تماماً عن تطبيق العميل
class MerchantApp extends ConsumerStatefulWidget {
  const MerchantApp({super.key});

  @override
  ConsumerState<MerchantApp> createState() => _MerchantAppState();
}

class _MerchantAppState extends ConsumerState<MerchantApp> {
  late final router = AppRouter.createRouter(ref);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MBUY Merchant',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,

      // Router خاص بالتاجر فقط
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
