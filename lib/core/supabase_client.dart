import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// تهيئة Supabase
///
/// يجب استدعاء هذه الدالة في main() قبل runApp()
///
/// المفاتيح المطلوبة في ملف .env:
/// - SUPABASE_URL: رابط مشروع Supabase
/// - SUPABASE_ANON_KEY: المفتاح العام (anon key) من Supabase
Future<void> initSupabase() async {
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseUrl.isEmpty) {
    throw Exception('SUPABASE_URL غير موجود في ملف .env');
  }

  if (supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
    throw Exception('SUPABASE_ANON_KEY غير موجود في ملف .env');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  debugPrint('✅ Supabase initialized with PKCE auth flow');
}

/// Getter للوصول إلى Supabase client في بقية المشروع
///
/// مثال الاستخدام:
/// ```dart
/// final response = supabaseClient.from('table_name').select();
/// ```
SupabaseClient get supabaseClient => Supabase.instance.client;
