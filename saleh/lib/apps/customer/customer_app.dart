import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/user_preferences_service.dart';
import 'routes/customer_router.dart';

/// تطبيق العميل - السوق للتسوق والشراء
/// منفصل تماماً عن تطبيق التاجر
class CustomerApp extends ConsumerStatefulWidget {
  const CustomerApp({super.key});

  @override
  ConsumerState<CustomerApp> createState() => _CustomerAppState();
}

class _CustomerAppState extends ConsumerState<CustomerApp> {
  late final router = CustomerRouter.createRouter(ref);

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(preferencesStateProvider).themeMode;

    return MaterialApp.router(
      title: 'MBUY Market',
      debugShowCheckedModeBanner: false,

      // Theme - يدعم Light و Dark
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

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
