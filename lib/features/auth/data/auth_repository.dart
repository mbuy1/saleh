import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_token_storage.dart';

/// Auth Repository - يتعامل مع جميع عمليات المصادقة
///
/// المسؤوليات:
/// - تسجيل الدخول/الخروج
/// - إدارة التوكنات
/// - حفظ جلسة المستخدم
///
/// يتواصل مع Worker على:
/// POST /auth/login
///
/// مثال Request:
/// {
///   "email": "user@example.com",
///   "password": "password123",
///   "login_as": "merchant" // اختياري: customer أو merchant
/// }
///
/// مثال Response (نجاح):
/// {
///   "ok": true,
///   "user": {
///     "id": "uuid",
///     "email": "user@example.com",
///     "full_name": "User Name",
///     "phone": "+966...",
///     "is_active": true,
///     "created_at": "2025-01-01T00:00:00Z"
///   },
///   "profile": {
///     "id": "uuid",
///     "mbuy_user_id": "uuid",
///     "role": "merchant",
///     "display_name": "Display Name",
///     "email": "user@example.com",
///     "phone": "+966...",
///     "avatar_url": null
///   },
///   "token": "eyJhbGciOiJIUzI1NiIs..."
/// }
///
/// مثال Response (فشل):
/// {
///   "ok": false,
///   "code": "INVALID_CREDENTIALS",
///   "error": "Invalid credentials",
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
  // تسجيل الدخول
  // ==========================================================================

  /// تسجيل الدخول باستخدام email وpassword
  ///
  /// [identifier] يمكن أن يكون email
  /// [password] كلمة المرور
  /// [loginAs] اختياري: "merchant" أو "customer" (افتراضي: أي دور)
  ///
  /// يرمي [Exception] إذا فشل تسجيل الدخول
  Future<Map<String, dynamic>> signIn({
    required String identifier,
    required String password,
    String? loginAs,
  }) async {
    try {
      // إرسال طلب تسجيل الدخول إلى Worker
      final response = await _apiService.post(
        '/auth/login',
        body: {
          'email': identifier.trim(),
          'password': password,
          if (loginAs != null) 'login_as': loginAs,
        },
      );

      // التحقق من نجاح الطلب
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['ok'] == true) {
          // استخراج البيانات
          final token = data['token'] as String;
          final user = data['user'] as Map<String, dynamic>;
          final profile = data['profile'] as Map<String, dynamic>;

          // حفظ التوكن ومعلومات المستخدم
          await _tokenStorage.saveToken(
            accessToken: token,
            userId: user['id'] as String,
            userRole: profile['role'] as String,
            userEmail: user['email'] as String?,
          );

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
