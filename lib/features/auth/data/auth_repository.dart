import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/secure_storage_service.dart';

/// Auth Repository - Uses MBUY Custom Auth only
/// No Supabase Auth dependency
class AuthRepository {
  static const String baseUrl = ApiService.baseUrl;

  /// Register a new user
  /// POST /auth/register
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? fullName,
    String? phone,
    String? role,
    String? accountType,
  }) async {
    try {
      debugPrint(
        '[AuthRepository] Registering user: $email with role: ${role ?? accountType ?? 'customer'}',
      );

      final response = await ApiService.post(
        '/auth/register',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
          if (fullName != null) 'full_name': fullName,
          if (phone != null) 'phone': phone,
          if (accountType != null) 'account_type': accountType,
          if (role != null) 'role': role,
        },
        requireAuth: false, // Register doesn't need auth
      );

      if (response['ok'] == true) {
        // Save token and user info
        final token = response['token'] as String;
        final user = response['user'] as Map<String, dynamic>;
        final profile = response['profile'] as Map<String, dynamic>?;

        await SecureStorageService.saveToken(token);
        await SecureStorageService.saveUserId(user['id'] as String);
        await SecureStorageService.saveUserEmail(user['email'] as String);

        // Save role if profile exists
        if (profile != null && profile['role'] != null) {
          await SecureStorageService.saveString(
            'user_role',
            profile['role'] as String,
          );
        }

        debugPrint('[AuthRepository] ✅ Registration successful');
        return response;
      } else {
        final errorMessage =
            response['message'] ?? response['error'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('[AuthRepository] ❌ Registration error: $e');
      rethrow;
    }
  }

  /// Login with email and password
  /// POST /auth/login
  /// After successful login, token is saved and user data is returned
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? loginAs,
  }) async {
    try {
      debugPrint('LOGIN_REQUEST_START');
      debugPrint(
        '[AuthRepository] 🔐 Logging in: $email as ${loginAs ?? 'customer'}',
      );
      debugPrint('[AuthRepository] 📡 Endpoint: POST /auth/login');
      debugPrint(
        '[AuthRepository] 📦 Data: email=${email.trim().toLowerCase()}, password=***, login_as=${loginAs ?? 'customer'}',
      );

      final response = await ApiService.post(
        '/auth/login',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
          if (loginAs != null) 'login_as': loginAs,
        },
        requireAuth: false, // Login doesn't need auth
      );

      debugPrint('LOGIN_RESPONSE: statusCode=200, body=${response.toString()}');
      debugPrint('[AuthRepository] 📥 Response: ${response.toString()}');

      if (response['ok'] == true) {
        // Save token and user info
        final token = response['token'] as String?;
        final user = response['user'] as Map<String, dynamic>?;
        final profile = response['profile'] as Map<String, dynamic>?;

        if (token == null || user == null) {
          debugPrint('[AuthRepository] ⚠️ Missing token or user in response');
          throw Exception('استجابة غير صحيحة من الخادم');
        }

        // Save token to secure storage (using auth_token key)
        await SecureStorageService.saveToken(token);
        await SecureStorageService.saveUserId(user['id'] as String);
        await SecureStorageService.saveUserEmail(user['email'] as String);

        // Save role and login_as if profile exists
        if (profile != null && profile['role'] != null) {
          await SecureStorageService.saveString(
            'user_role',
            profile['role'] as String,
          );
        }
        if (loginAs != null) {
          await SecureStorageService.saveString('login_as', loginAs);
        }

        debugPrint(
          '[AuthRepository] ✅ Login successful - Token saved to secure storage',
        );
        debugPrint('[AuthRepository] ✅ User ID: ${user['id']}');
        debugPrint('[AuthRepository] ✅ User Email: ${user['email']}');
        if (profile != null) {
          debugPrint('[AuthRepository] ✅ User Role: ${profile['role']}');
        }

        return response;
      } else {
        final errorCode = response['code'] ?? response['error_code'];
        final errorMessage =
            response['message'] ?? response['error'] ?? 'Login failed';

        debugPrint(
          '[AuthRepository] ❌ Login failed: code=$errorCode, message=$errorMessage',
        );

        // Handle specific error codes
        if (errorCode == 'INVALID_CREDENTIALS') {
          throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
        } else if (errorCode == 'ACCOUNT_DISABLED') {
          throw Exception('تم تعطيل حسابك. يرجى التواصل مع الدعم');
        } else if (errorCode == 'NOT_MERCHANT') {
          throw Exception(
            'هذا الحساب غير مسجل كتاجر. يرجى استخدام تسجيل دخول العميل.',
          );
        } else {
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      debugPrint('[AuthRepository] ❌ Login error: $e');
      debugPrint('[AuthRepository] ❌ Error type: ${e.runtimeType}');
      if (e is Exception) {
        debugPrint('[AuthRepository] ❌ Exception message: ${e.toString()}');
      }
      rethrow;
    }
  }

  /// Verify token and load user data after login
  /// Calls /auth/me to verify token and get user data
  /// Returns user data if successful, throws exception if failed
  static Future<Map<String, dynamic>> verifyAndLoadUser() async {
    try {
      debugPrint('[AuthRepository] 🔍 Verifying token and loading user...');

      final token = await SecureStorageService.getToken();
      if (token == null) {
        debugPrint('[AuthRepository] ⚠️ No token found in secure storage');
        throw Exception('Not authenticated');
      }

      debugPrint(
        '[AuthRepository] 📡 Calling GET /auth/me with Authorization header',
      );

      final response = await ApiService.get(
        '/auth/me',
        requireAuth: true, // This endpoint requires auth
      );

      debugPrint(
        'AUTH_ME_RESPONSE: statusCode=200, body=${response.toString()}',
      );
      debugPrint(
        '[AuthRepository] 📥 /auth/me Response: ${response.toString()}',
      );

      if (response['ok'] == true) {
        final user = response['user'] as Map<String, dynamic>;
        debugPrint('[AuthRepository] ✅ User verified and loaded successfully');
        debugPrint('[AuthRepository] ✅ User ID: ${user['id']}');
        debugPrint('[AuthRepository] ✅ User Email: ${user['email']}');
        return user;
      } else {
        final errorMessage =
            response['message'] ?? response['error'] ?? 'Failed to get user';
        debugPrint('[AuthRepository] ❌ /auth/me failed: $errorMessage');

        // Clear invalid token
        await SecureStorageService.clearAll();
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('[AuthRepository] ❌ Verify and load user error: $e');

      // If error is 401 or 500, clear token
      if (e.toString().contains('401') ||
          e.toString().contains('UNAUTHORIZED') ||
          e.toString().contains('500') ||
          e.toString().contains('INTERNAL_ERROR')) {
        debugPrint('[AuthRepository] 🗑️ Clearing invalid token due to error');
        await SecureStorageService.clearAll();
      }

      rethrow;
    }
  }

  /// Get current user profile
  /// GET /auth/me
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      debugPrint('[AuthRepository] 📡 Calling GET /auth/me');

      final response = await ApiService.get(
        '/auth/me',
        requireAuth: true, // This endpoint requires auth
      );

      debugPrint(
        'AUTH_ME_RESPONSE: statusCode=200, body=${response.toString()}',
      );

      if (response['ok'] == true) {
        return response['user'] as Map<String, dynamic>;
      } else {
        final errorMessage =
            response['message'] ?? response['error'] ?? 'Failed to get user';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('[AuthRepository] ❌ Get current user error: $e');
      rethrow;
    }
  }

  /// Logout
  /// POST /auth/logout
  static Future<void> logout() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token != null) {
        try {
          await ApiService.post('/auth/logout', requireAuth: true);
        } catch (e) {
          debugPrint('[AuthRepository] ⚠️ Logout API call failed: $e');
          // Continue with local logout even if API call fails
        }
      }

      // Clear local storage
      await SecureStorageService.clearAll();
      debugPrint('[AuthRepository] ✅ Logout successful');
    } catch (e) {
      debugPrint('[AuthRepository] ❌ Logout error: $e');
      // Clear local storage even if API call fails
      await SecureStorageService.clearAll();
      rethrow;
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await SecureStorageService.isLoggedIn();
  }

  /// Get stored user ID
  static Future<String?> getUserId() async {
    return await SecureStorageService.getUserId();
  }

  /// Get stored user email
  static Future<String?> getUserEmail() async {
    return await SecureStorageService.getUserEmail();
  }

  /// Get stored JWT token
  static Future<String?> getToken() async {
    return await SecureStorageService.getToken();
  }

  /// Verify token by calling /auth/me
  /// Returns true if token is valid, false otherwise
  static Future<bool> verifyToken() async {
    try {
      await getCurrentUser();
      return true;
    } catch (e) {
      debugPrint('[AuthRepository] ⚠️ Token verification failed: $e');
      // Clear invalid token
      await SecureStorageService.clearAll();
      return false;
    }
  }

  /// Change password
  /// POST /auth/change-password
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      debugPrint('[AuthRepository] Changing password...');

      final response = await ApiService.post(
        '/auth/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        requireAuth: true,
      );

      if (response['ok'] == true) {
        debugPrint('[AuthRepository] ✅ Password changed successfully');
      } else {
        final errorMessage =
            response['message'] ??
            response['error'] ??
            'Failed to change password';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('[AuthRepository] ❌ Change password error: $e');
      rethrow;
    }
  }
}
