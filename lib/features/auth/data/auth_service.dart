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
      // 1. إنشاء حساب في Supabase Auth
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('فشل إنشاء الحساب');
      }

      final user = response.user!;

      // 2. إنشاء row في user_profiles
      await supabaseClient.from('user_profiles').insert({
        'id': user.id,
        'role': 'customer',
        'display_name': displayName,
      });

      // 3. إنشاء wallet للمستخدم الجديد
      await supabaseClient.from('wallets').insert({
        'owner_id': user.id,
        'type': 'customer',
        'balance': 0,
        'currency': 'SAR',
      });

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
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw Exception('فشل تسجيل الدخول');
      }

      return response.session!;
    } catch (e) {
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
