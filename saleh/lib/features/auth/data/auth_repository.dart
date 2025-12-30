import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_config.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_token_storage.dart';

/// Auth Repository - يتعامل مع جميع عمليات المصادقة
///
/// المسؤوليات:
/// - تسجيل الدخول/الخروج
/// - إدارة التوكنات (Custom JWT من Worker)
/// - حفظ جلسة المستخدم
///
/// Endpoints الجديدة:
/// - POST /auth/login
/// - POST /auth/register
/// - POST /auth/logout
/// - GET /auth/me
///
/// User Types:
/// - customer
/// - merchant
/// - merchant_user
/// - admin
/// - support
/// - moderator
/// - owner
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

  /// تسجيل حساب جديد (Worker v2.0)
  ///
  /// [email] البريد الإلكتروني
  /// [password] كلمة المرور
  /// [fullName] الاسم الكامل (اختياري)
  /// [userType] نوع المستخدم: merchant أو customer
  ///
  /// Worker Response:
  /// {
  ///   "success": true,
  ///   "token": "eyJ...",
  ///   "refresh_token": "...",
  ///   "expires_in": 3600,
  ///   "user": { "id", "email", "full_name", "user_type", "merchant_id" }
  /// }
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? fullName,
    String userType = 'merchant',
  }) async {
    try {
      final response = await _apiService.post(
        AppConfig.registerEndpoint,
        body: {
          'email': email.trim().toLowerCase(),
          'password': password,
          'full_name': fullName?.trim(),
          'user_type': userType,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['token'] != null && data['user'] != null) {
          final accessToken = data['token'] as String;
          final refreshToken = data['refresh_token'] as String?;
          final user = data['user'] as Map<String, dynamic>;
          final expiresIn = data['expires_in'] as int?;

          // حفظ التوكن ومعلومات المستخدم
          await _tokenStorage.saveToken(
            accessToken: accessToken,
            userId: user['id'] as String,
            userType: user['user_type'] as String? ?? userType,
            userEmail: user['email'] as String?,
            refreshToken: refreshToken,
            merchantId: user['merchant_id'] as String?,
            displayName: user['full_name'] as String? ?? fullName,
            expiresIn: expiresIn,
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

  /// تسجيل الدخول (Worker v2.0)
  ///
  /// [identifier] البريد الإلكتروني
  /// [password] كلمة المرور
  /// [loginAs] غير مستخدم (محفوظ للتوافق)
  ///
  /// Worker Response:
  /// {
  ///   "success": true,
  ///   "token": "eyJ...",
  ///   "refresh_token": "...",
  ///   "expires_in": 3600,
  ///   "user": { "id", "email", "full_name", "user_type", "merchant_id" }
  /// }
  Future<Map<String, dynamic>> signIn({
    required String identifier,
    required String password,
    String? loginAs,
  }) async {
    try {
      final response = await _apiService.post(
        AppConfig.loginEndpoint,
        body: {'email': identifier.trim(), 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['token'] != null && data['user'] != null) {
          final accessToken = data['token'] as String;
          final refreshToken = data['refresh_token'] as String?;
          final user = data['user'] as Map<String, dynamic>;
          final expiresIn = data['expires_in'] as int?;

          // حفظ التوكن ومعلومات المستخدم
          await _tokenStorage.saveToken(
            accessToken: accessToken,
            userId: user['id'] as String,
            userType: user['user_type'] as String? ?? 'customer',
            userEmail: user['email'] as String?,
            refreshToken: refreshToken,
            merchantId: user['merchant_id'] as String?,
            displayName: user['full_name'] as String?,
            expiresIn: expiresIn,
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
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await _apiService.post(
        AppConfig.forgotPasswordEndpoint,
        body: {'email': email.trim().toLowerCase()},
      );

      if (response.statusCode == 200) {
        return;
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

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      // إرسال طلب تسجيل خروج إلى Worker
      await _apiService.post(AppConfig.logoutEndpoint, body: {});
    } catch (_) {
      // الاستمرار حتى لو فشل الطلب
    } finally {
      await _tokenStorage.clear();
    }
  }

  // ==========================================================================
  // التحقق من الجلسة
  // ==========================================================================

  /// التحقق من وجود جلسة صالحة
  Future<bool> hasValidSession() async {
    return await _tokenStorage.hasValidToken();
  }

  // ==========================================================================
  // الحصول على معلومات المستخدم
  // ==========================================================================

  /// الحصول على نوع المستخدم الحالي
  Future<String?> getUserType() async {
    return await _tokenStorage.getUserType();
  }

  /// للتوافق مع الكود القديم
  @Deprecated('Use getUserType() instead')
  Future<String?> getUserRole() async {
    return await getUserType();
  }

  /// الحصول على معرف المستخدم
  Future<String?> getUserId() async {
    return await _tokenStorage.getUserId();
  }

  /// الحصول على إيميل المستخدم
  Future<String?> getUserEmail() async {
    return await _tokenStorage.getUserEmail();
  }

  /// الحصول على معرف التاجر
  Future<String?> getMerchantId() async {
    return await _tokenStorage.getMerchantId();
  }

  /// الحصول على اسم العرض
  Future<String?> getDisplayName() async {
    return await _tokenStorage.getDisplayName();
  }

  /// الحصول على جميع بيانات المستخدم
  Future<Map<String, String?>> getAllUserData() async {
    return await _tokenStorage.getAllUserData();
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
