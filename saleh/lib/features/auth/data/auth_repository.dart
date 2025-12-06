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
  }) async {
    try {
      debugPrint('[AuthRepository] Registering user: $email');

      final response = await ApiService.post(
        '/auth/register',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
          if (fullName != null) 'full_name': fullName,
          if (phone != null) 'phone': phone,
        },
        requireAuth: false, // Register doesn't need auth
      );

      if (response['ok'] == true) {
        // Save token and user info
        final token = response['token'] as String;
        final user = response['user'] as Map<String, dynamic>;

        await SecureStorageService.saveToken(token);
        await SecureStorageService.saveUserId(user['id'] as String);
        await SecureStorageService.saveUserEmail(user['email'] as String);

        debugPrint('[AuthRepository] ✅ Registration successful');
        return response;
      } else {
        final errorMessage = response['message'] ?? response['error'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('[AuthRepository] ❌ Registration error: $e');
      rethrow;
    }
  }

  /// Login with email and password
  /// POST /auth/login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('[AuthRepository] Logging in: $email');

      final response = await ApiService.post(
        '/auth/login',
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
        },
        requireAuth: false, // Login doesn't need auth
      );

      if (response['ok'] == true) {
        // Save token and user info
        final token = response['token'] as String;
        final user = response['user'] as Map<String, dynamic>;

        await SecureStorageService.saveToken(token);
        await SecureStorageService.saveUserId(user['id'] as String);
        await SecureStorageService.saveUserEmail(user['email'] as String);

        debugPrint('[AuthRepository] ✅ Login successful');
        return response;
      } else {
        final errorCode = response['code'] ?? response['error_code'];
        final errorMessage = response['message'] ?? response['error'] ?? 'Login failed';

        // Handle specific error codes
        if (errorCode == 'INVALID_CREDENTIALS') {
          throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
        } else if (errorCode == 'ACCOUNT_DISABLED') {
          throw Exception('تم تعطيل حسابك. يرجى التواصل مع الدعم');
        } else {
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      debugPrint('[AuthRepository] ❌ Login error: $e');
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

      final response = await ApiService.get(
        '/auth/me',
        requireAuth: true, // This endpoint requires auth
      );

      if (response['ok'] == true) {
        return response['user'] as Map<String, dynamic>;
      } else {
        final errorMessage = response['message'] ?? response['error'] ?? 'Failed to get user';
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
          await ApiService.post(
            '/auth/logout',
            requireAuth: true,
          );
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
        final errorMessage = response['message'] ?? response['error'] ?? 'Failed to change password';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('[AuthRepository] ❌ Change password error: $e');
      rethrow;
    }
  }
}

