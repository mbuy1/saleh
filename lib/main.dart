import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'core/services/cloudflare_images_service.dart';
import 'core/root_widget.dart' as app;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تحميل متغيرات البيئة من ملف .env
  await dotenv.load(fileName: ".env");

  // تهيئة Supabase
  try {
    await initSupabase();
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mbuy',
      debugShowCheckedModeBanner: false,
      // استخدام الثيم الفاتح الجديد
      theme: AppTheme.lightTheme,
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
      // استخدام RootWidget الذي يفحص حالة المستخدم ويعرض الشاشة المناسبة
      home: const app.RootWidget(),
    );
  }
}
