import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/cloudflare_images_service.dart';
import 'core/firebase_service.dart';
import 'core/root_widget.dart' as app;
import 'features/common/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تحميل متغيرات البيئة من ملف .env
  await dotenv.load(fileName: ".env");

  // تهيئة Firebase
  try {
    await Firebase.initializeApp();
    FirebaseService.initAnalytics();
    await FirebaseService.setupFCM();
    debugPrint('✅ تم تهيئة Firebase بنجاح');
  } catch (e) {
    debugPrint('⚠️ خطأ في تهيئة Firebase: $e');
  }

  // تهيئة Supabase مع حفظ الجلسة
  try {
    await initSupabase();
    debugPrint('✅ تم تهيئة Supabase بنجاح');
  } catch (e) {
    // إذا فشل تهيئة Supabase، نتابع بدونها (للتطوير فقط)
    // في الإنتاج يجب إيقاف التطبيق إذا فشل Supabase
    debugPrint('⚠️ خطأ في تهيئة Supabase: $e');
  }

  // تهيئة Cloudflare Images Service
  try {
    await CloudflareImagesService.initialize();
    debugPrint('✅ تم تهيئة Cloudflare Images بنجاح');
  } catch (e) {
    // إذا فشل تهيئة Cloudflare، نتابع بدونها
    // (مفيد في حالة عدم وجود ملفات الإعداد)
    debugPrint('⚠️ تحذير: فشل تهيئة Cloudflare Images: $e');
    debugPrint('   التطبيق سيعمل لكن رفع الصور لن يكون متاحاً');
  }

  // تهيئة Theme Provider
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode();

  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MyApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'Mbuy',
          debugShowCheckedModeBanner: false,

          // Theme Configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,

          // تفعيل RTL للعربية
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'SA'), // العربية
            Locale('en', 'US'), // الإنجليزية
          ],
          locale: const Locale('ar', 'SA'),

          // إعداد المسارات (Routes)
          routes: {
            '/home': (context) => app.RootWidget(themeProvider: themeProvider),
            '/splash': (context) => const SplashScreen(),
          },
          initialRoute: '/splash', // بدء التطبيق بـ Splash Screen
          // استخدام RootWidget الذي يفحص حالة المستخدم ويعرض الشاشة المناسبة
          home: app.RootWidget(themeProvider: themeProvider),
        );
      },
    );
  }
}
