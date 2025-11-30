import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'core/root_widget.dart' as app;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تحميل متغيرات البيئة من ملف .env
  await dotenv.load(fileName: ".env");
  
  // تهيئة Supabase
  await initSupabase();
  
  // TODO: إضافة Firebase Analytics و FCM
  // - await Firebase.initializeApp();
  // - إعداد Firebase Analytics
  // - إعداد Firebase Cloud Messaging (FCM)
  // - حفظ device token في Supabase
  
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
