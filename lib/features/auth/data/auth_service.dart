import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import 'auth_repository.dart';

/// Auth Service - Uses MBUY Custom Auth only
/// No Supabase Auth dependency
class AuthService {
  /// تسجيل مستخدم جديد
  ///
  /// يقوم بـ:
  /// 1. إنشاء حساب في MBUY Auth
  /// 2. إنشاء row في user_profiles مع الدور المحدد
  /// 3. إذا كان تاجر: إنشاء متجر تلقائياً عبر API
  ///
  /// Parameters:
  /// - email: البريد الإلكتروني
  /// - password: كلمة المرور
  /// - displayName: الاسم المعروض
  /// - role: دور المستخدم ('customer' أو 'merchant')
  /// - storeName: اسم المتجر (مطلوب للتاجر)
  /// - city: المدينة (مطلوب للتاجر)
  ///
  /// Returns: Map with user data
  /// Throws: Exception في حالة الفشل
  static Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String displayName,
    String role = 'customer',
    String? accountType,
    String? storeName,
    String? city,
  }) async {
    try {
      debugPrint('📝 محاولة تسجيل مستخدم جديد: $email');

      // 1. إنشاء حساب في MBUY Auth
      final result = await AuthRepository.register(
        email: email,
        password: password,
        fullName: displayName,
        role: role,
        accountType: accountType ?? role,
      );

      final user = result['user'] as Map<String, dynamic>;
      debugPrint('✅ تم إنشاء حساب المستخدم: ${user['email']}');

      // 2. إنشاء user_profile + wallet عبر Worker API (دفعة واحدة)
      try {
        final response = await ApiService.post(
          '/secure/auth/initialize-user',
          data: {'role': role, 'display_name': displayName},
        );

        if (response['ok'] == true) {
          debugPrint('✅ تم إنشاء user_profile + wallet بدور: $role');
        } else {
          debugPrint(
            '⚠️ تحذير: فشل إنشاء user_profile/wallet: ${response['error']}',
          );
        }
      } catch (e) {
        // إذا فشل الإدراج، ربما السجل موجود مسبقاً
        debugPrint('⚠️ تحذير: فشل إنشاء user_profile/wallet عبر Worker: $e');
      }

      // 3. إذا كان تاجر: إنشاء متجر تلقائياً عبر Worker API
      if (role == 'merchant' && storeName != null) {
        try {
          debugPrint('🏪 جاري إنشاء متجر للتاجر...');

          // استخدام Worker API الجديد (لا نرسل user_id - يتم جلبها من JWT)
          final storeResult = await ApiService.post(
            '/secure/merchant/store',
            data: {
              'name': storeName,
              'city': city ?? '',
              'description': '',
              'visibility': 'public',
              'status': 'active',
              // لا نرسل user_id - يتم جلبها من JWT في Backend
            },
          );

          if (storeResult['ok'] == true) {
            debugPrint('✅ تم إنشاء المتجر بنجاح!');
            debugPrint('✅ حصل التاجر على 100 نقطة ترحيبية');
          } else {
            debugPrint(
              '⚠️ فشل إنشاء المتجر: ${storeResult['error'] ?? storeResult['message']}',
            );
            // لا نرمي خطأ هنا - يمكن للتاجر إنشاء المتجر لاحقاً
          }
        } catch (e) {
          debugPrint('⚠️ تحذير: فشل إنشاء المتجر: $e');
          // لا نرمي خطأ هنا - يمكن للتاجر إنشاء المتجر لاحقاً
        }
      }

      return result;
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
  /// Returns: Map with user and token data
  /// Throws: Exception في حالة الفشل
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
    String? loginAs,
  }) async {
    try {
      debugPrint('🔐 محاولة تسجيل الدخول: $email as ${loginAs ?? 'customer'}');

      final result = await AuthRepository.login(
        email: email,
        password: password,
        loginAs: loginAs,
      );

      debugPrint('✅ تم تسجيل الدخول بنجاح: ${result['user']?['email']}');
      return result;
    } catch (e) {
      debugPrint('❌ خطأ في تسجيل الدخول: $e');
      rethrow;
    }
  }

  /// تسجيل خروج
  ///
  /// Throws: Exception في حالة الفشل
  static Future<void> signOut() async {
    try {
      await AuthRepository.logout();
      debugPrint('[AuthService] ✅ Logout successful');
    } catch (e) {
      throw Exception('خطأ في تسجيل الخروج: ${e.toString()}');
    }
  }

  /// جلب المستخدم الحالي
  ///
  /// Returns: Map with user data if logged in, null otherwise
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final isLoggedIn = await AuthRepository.isLoggedIn();
      if (!isLoggedIn) {
        return null;
      }

      // Verify token by calling /auth/me
      final user = await AuthRepository.getCurrentUser();
      return user;
    } catch (e) {
      debugPrint('[AuthService] Error getting current user: $e');
      // Clear invalid token
      await AuthRepository.logout();
      return null;
    }
  }

  /// التحقق من حالة تسجيل الدخول
  ///
  /// Returns: true إذا كان المستخدم مسجل، false إذا لم يكن
  static Future<bool> isSignedIn() async {
    return await AuthRepository.isLoggedIn();
  }

  /// Get current user ID
  static Future<String?> getCurrentUserId() async {
    return await AuthRepository.getUserId();
  }

  /// Get current user email
  static Future<String?> getCurrentUserEmail() async {
    return await AuthRepository.getUserEmail();
  }
}
