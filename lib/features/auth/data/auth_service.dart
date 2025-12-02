import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase_client.dart';

class AuthService {
  /// تسجيل مستخدم جديد
  ///
  /// يقوم بـ:
  /// 1. إنشاء حساب في Supabase Auth
  /// 2. إنشاء row في user_profiles مع role = 'customer'
  ///
  /// Parameters:
  /// - email: البريد الإلكتروني
  /// - password: كلمة المرور
  /// - displayName: الاسم المعروض
  ///
  /// Returns: User object من Supabase
  /// Throws: Exception في حالة الفشل
  static Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      debugPrint('📝 محاولة تسجيل مستخدم جديد: $email');

      // 1. إنشاء حساب في Supabase Auth
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        debugPrint('❌ فشل إنشاء الحساب: لا يوجد مستخدم');
        throw Exception('فشل إنشاء الحساب');
      }

      final user = response.user!;
      debugPrint('✅ تم إنشاء حساب المستخدم: ${user.email}');

      // 2. إنشاء row في user_profiles
      try {
        await supabaseClient.from('user_profiles').insert({
          'id': user.id,
          'role': 'customer',
          'display_name': displayName,
        });
      } catch (e) {
        // إذا فشل الإدراج، ربما السجل موجود مسبقاً
        debugPrint('⚠️ تحذير: فشل إنشاء user_profile: $e');
      }

      // 3. إنشاء wallet للمستخدم الجديد
      try {
        await supabaseClient.from('wallets').insert({
          'owner_id': user.id,
          'type': 'customer',
          'balance': 0,
          'currency': 'SAR',
        });
      } catch (e) {
        // إذا فشل الإدراج، ربما السجل موجود مسبقاً
        debugPrint('⚠️ تحذير: فشل إنشاء wallet: $e');
      }

      // ملاحظة: points_accounts يتم إنشاؤه فقط عند تحويل المستخدم إلى تاجر (role = 'merchant')
      // النقاط هي "رصيد خدمات" للتاجر فقط، وليست للعميل

      return user;
    } catch (e) {
      throw Exception('خطأ في التسجيل: ${e.toString()}');
    }
  }

  /// تسجيل دخول
  ///
  /// Parameters:
  /// - email: البريد الإلكتروني
  /// - password: كلمة المرور
  ///
  /// Returns: Session object من Supabase
  /// Throws: Exception في حالة الفشل
  static Future<Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 محاولة تسجيل الدخول: $email');

      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        debugPrint('❌ فشل تسجيل الدخول: لا توجد جلسة');
        throw Exception('فشل تسجيل الدخول - لا توجد جلسة');
      }

      debugPrint('✅ تم تسجيل الدخول بنجاح: ${response.user?.email}');
      debugPrint(
        '📱 Session ID: ${response.session!.accessToken.substring(0, 20)}...',
      );

      return response.session!;
    } on AuthException catch (e) {
      debugPrint('❌ خطأ في المصادقة: ${e.message}');
      if (e.message.contains('Invalid login credentials')) {
        throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      } else if (e.message.contains('Email not confirmed')) {
        throw Exception('يرجى تأكيد البريد الإلكتروني أولاً');
      }
      throw Exception('خطأ في تسجيل الدخول: ${e.message}');
    } catch (e) {
      debugPrint('❌ خطأ غير متوقع: $e');
      throw Exception('خطأ في تسجيل الدخول: ${e.toString()}');
    }
  }

  /// تسجيل خروج
  ///
  /// Throws: Exception في حالة الفشل
  static Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('خطأ في تسجيل الخروج: ${e.toString()}');
    }
  }

  /// جلب المستخدم الحالي
  ///
  /// Returns: User object إذا كان المستخدم مسجل، null إذا لم يكن مسجل
  static User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }

  /// التحقق من حالة تسجيل الدخول
  ///
  /// Returns: true إذا كان المستخدم مسجل، false إذا لم يكن
  static bool isSignedIn() {
    return getCurrentUser() != null;
  }
}
