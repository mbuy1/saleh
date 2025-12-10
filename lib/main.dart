import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

/// MBUY Merchant Application
/// Clean Architecture - Worker-Only Backend
///
/// This app communicates exclusively with Cloudflare Worker
/// No direct Supabase integration in Flutter code
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MbuyApp()));
}

class MbuyApp extends ConsumerWidget {
  const MbuyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // إنشاء Router مع ref للوصول إلى حالة المصادقة
    final router = AppRouter.createRouter(ref);

    return MaterialApp.router(
      title: 'MBUY Merchant',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,

      // Router مع حماية المصادقة
      routerConfig: router,

      // *** مهم جداً لحل No MaterialLocalizations ***
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en')],
    );
  }
}
