import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_token_storage.dart';

/// Auth Repository - يتعامل مع جميع عمليات المصادقة
///
/// المسؤوليات:
/// - تسجيل الدخول/الخروج
/// - إدارة التوكنات (Supabase JWT)
/// - حفظ جلسة المستخدم
///
/// يتواصل مع Worker على:
/// POST /auth/supabase/login
///
/// مثال Request:
/// {
///   "email": "user@example.com",
///   "password": "password123"
/// }
///
/// مثال Response (نجاح) - Supabase Auth Format:
/// {
///   "session": {
///     "access_token": "eyJhbGciOiJIUzI1NiIs...",
///     "refresh_token": "...",
///     "expires_in": 3600,
///     "token_type": "bearer"
///   },
///   "user": {
///     "id": "auth-user-uuid",
///     "email": "user@example.com",
///     "user_metadata": {
///       "full_name": "User Name",
///       "role": "merchant"
///     }
///   },
///   "profile": {
///     "id": "profile-uuid",
///     "auth_user_id": "auth-user-uuid",
///     "role": "merchant",
///     "display_name": "Display Name",
///     "email": "user@example.com",
///     "avatar_url": null
///   }
/// }
///
/// مثال Response (فشل):
/// {
///   "error": "INVALID_CREDENTIALS",
///   "message": "Invalid email or password"
/// }
class AuthRepository {
  final ApiService _apiService;
  final AuthTokenStorage _tokenStorage;

  AuthRepository({
    required ApiService apiService,
    required AuthTokenStorage tokenStorage,
  }) : _apiService = apiService,
       _tokenStorage = tokenStorage;

  // ==========================================================================
  // تسجيل حساب جديد
  // ==========================================================================

  /// تسجيل حساب جديد باستخدام Supabase Auth
  ///
  /// [email] البريد الإلكتروني
  /// [password] كلمة المرور
  /// [fullName] الاسم الكامل (اختياري)
  /// [role] الدور: merchant أو customer
  ///
  /// يرمي [Exception] إذا فشل التسجيل
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? fullName,
    String role = 'merchant',
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/supabase/register',
        body: {
          'email': email.trim().toLowerCase(),
          'password': password,
          'full_name': fullName?.trim(),
          'role': role,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['access_token'] != null && data['user'] != null) {
          final accessToken = data['access_token'] as String;
          final refreshToken = data['refresh_token'] as String?;
          final user = data['user'] as Map<String, dynamic>;
          final profile = data['profile'] as Map<String, dynamic>?;

          final userRole =
              user['role'] as String? ?? profile?['role'] as String? ?? role;

          // حفظ التوكن ومعلومات المستخدم
          await _tokenStorage.saveToken(
            accessToken: accessToken,
            userId: user['id'] as String,
            userRole: userRole,
            userEmail: user['email'] as String?,
          );

          if (refreshToken != null) {
            await _tokenStorage.saveRefreshToken(refreshToken);
          }

          return data;
        }
      }

      // معالجة حالة الفشل
      Map<String, dynamic>? errorData;
      try {
        errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {
        errorData = null;
      }

      final errorMessage = errorData?['message'] ?? errorData?['error'];

      // ترجمة رسائل الخطأ الشائعة
      if (errorMessage?.toString().contains('already') == true ||
          errorMessage?.toString().contains('exists') == true) {
        throw Exception('البريد الإلكتروني مسجل مسبقاً');
      }

      throw Exception(errorMessage ?? 'فشل إنشاء الحساب');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('حدث خطأ أثناء إنشاء الحساب: ${e.toString()}');
    }
  }

  // ==========================================================================
  // تسجيل الدخول
  // ==========================================================================

  /// تسجيل الدخول باستخدام email وpassword (Supabase Auth)
  ///
  /// [identifier] يمكن أن يكون email
  /// [password] كلمة المرور
  /// [loginAs] غير مستخدم (محفوظ للتوافق)
  ///
  /// يرمي [Exception] إذا فشل تسجيل الدخول
  Future<Map<String, dynamic>> signIn({
    required String identifier,
    required String password,
    String? loginAs,
  }) async {
    try {
      // إرسال طلب تسجيل الدخول إلى Worker (Supabase Auth)
      final response = await _apiService.post(
        '/auth/supabase/login',
        body: {'email': identifier.trim(), 'password': password},
      );

      // التحقق من نجاح الطلب
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Worker الآن يرجع البيانات مباشرة (CLEAN format)
        // {
        //   "success": true,
        //   "access_token": "...",
        //   "refresh_token": "...",
        //   "expires_in": 3600,
        //   "user": { "id": "...", "email": "...", "role": "..." },
        //   "profile": { ... }
        // }
        if (data['access_token'] != null && data['user'] != null) {
          final accessToken = data['access_token'] as String;
          final refreshToken = data['refresh_token'] as String?;
          final user = data['user'] as Map<String, dynamic>;

          // Profile قد يكون null إذا لم يتم إنشاؤه بعد
          final profile = data['profile'] != null
              ? data['profile'] as Map<String, dynamic>
              : null;

          // استخراج role من user object مباشرة (له الأولوية)
          final userRole =
              user['role'] as String? ??
              profile?['role'] as String? ??
              'customer';

          // حفظ التوكن ومعلومات المستخدم
          await _tokenStorage.saveToken(
            accessToken: accessToken,
            userId: user['id'] as String,
            userRole: userRole,
            userEmail: user['email'] as String?,
          );

          // حفظ refresh_token إذا موجود
          if (refreshToken != null) {
            await _tokenStorage.saveRefreshToken(refreshToken);
          }

          return data;
        }
      }

      // معالجة حالة الفشل
      Map<String, dynamic>? errorData;
      try {
        errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {
        errorData = null;
      }
      throw Exception(
        errorData?['message'] ?? errorData?['error'] ?? 'فشل تسجيل الدخول',
      );
    } catch (e) {
      // إعادة رمي الخطأ مع رسالة واضحة
      if (e is Exception) {
        rethrow;
      }
      throw Exception('حدث خطأ أثناء تسجيل الدخول: ${e.toString()}');
    }
  }

  // ==========================================================================
  // نسيت كلمة المرور
  // ==========================================================================

  /// إرسال رابط إعادة تعيين كلمة المرور
  ///
  /// [email] البريد الإلكتروني
  ///
  /// يرمي [Exception] إذا فشل الإرسال
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await _apiService.post(
        '/auth/supabase/forgot-password',
        body: {'email': email.trim().toLowerCase()},
      );

      if (response.statusCode == 200) {
        return; // نجاح
      }

      Map<String, dynamic>? errorData;
      try {
        errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {
        errorData = null;
      }

      throw Exception(errorData?['message'] ?? 'فشل إرسال رابط إعادة التعيين');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('حدث خطأ أثناء إرسال الرابط');
    }
  }

  // ==========================================================================
  // تسجيل الخروج
  // ==========================================================================

  /// تسجيل الخروج - حذف جميع البيانات المحفوظة
  Future<void> signOut() async {
    try {
      // محاولة إرسال طلب تسجيل خروج إلى Worker (اختياري)
      // ملاحظة: Worker الحالي لا يحتوي على endpoint للخروج
      // يمكن إضافته لاحقاً لإلغاء الجلسة من قاعدة البيانات
      // await _apiService.post('/auth/logout');
    } catch (_) {
      // الاستمرار في تسجيل الخروج حتى لو فشل الطلب
    } finally {
      // حذف جميع البيانات المحفوظة محلياً
      await _tokenStorage.clear();
    }
  }

  // ==========================================================================
  // التحقق من الجلسة
  // ==========================================================================

  /// التحقق من وجود جلسة صالحة (توكن محفوظ)
  Future<bool> hasValidSession() async {
    return await _tokenStorage.hasValidToken();
  }

  // ==========================================================================
  // الحصول على معلومات المستخدم
  // ==========================================================================

  /// الحصول على دور المستخدم الحالي
  Future<String?> getUserRole() async {
    return await _tokenStorage.getUserRole();
  }

  /// الحصول على معرف المستخدم
  Future<String?> getUserId() async {
    return await _tokenStorage.getUserId();
  }

  /// الحصول على إيميل المستخدم
  Future<String?> getUserEmail() async {
    return await _tokenStorage.getUserEmail();
  }
}

// ==========================================================================
// Riverpod Providers
// ==========================================================================

/// Provider لـ AuthTokenStorage
final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  return AuthTokenStorage();
});

/// Provider لـ AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ApiService();
  final tokenStorage = ref.watch(authTokenStorageProvider);

  return AuthRepository(apiService: apiService, tokenStorage: tokenStorage);
});
