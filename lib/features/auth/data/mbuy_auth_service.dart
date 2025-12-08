import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/services/api_service.dart';
import '../../../core/services/secure_storage_service.dart';

/// MBUY Custom Auth Service
/// Uses Worker API for authentication (no Supabase Auth)
class MbuyAuthService {
  static const String baseUrl = ApiService.baseUrl;

  /// Register a new user
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    try {
      debugPrint('[MBUY Auth] Registering user: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email.trim().toLowerCase(),
          'password': password,
          if (fullName != null) 'full_name': fullName,
          if (phone != null) 'phone': phone,
        }),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 && data['ok'] == true) {
        // Save token and user info
        final token = data['token'] as String;
        final user = data['user'] as Map<String, dynamic>;

        await SecureStorageService.saveToken(token);
        await SecureStorageService.saveUserId(user['id'] as String);
        await SecureStorageService.saveUserEmail(user['email'] as String);

        debugPrint('[MBUY Auth] ✅ Registration successful');
        return data;
      } else {
        final errorMessage = data['message'] ?? data['error'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('[MBUY Auth] ❌ Registration error: $e');
      rethrow;
    }
  }

  /// Login with email and password
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('[MBUY Auth] Logging in: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['ok'] == true) {
        // Save token and user info
        final token = data['token'] as String;
        final user = data['user'] as Map<String, dynamic>;

        await SecureStorageService.saveToken(token);
        await SecureStorageService.saveUserId(user['id'] as String);
        await SecureStorageService.saveUserEmail(user['email'] as String);

        debugPrint('[MBUY Auth] ✅ Login successful');
        return data;
      } else {
        final errorCode = data['code'] ?? data['error_code'];
        final errorMessage = data['message'] ?? data['error'] ?? 'Login failed';

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
      debugPrint('[MBUY Auth] ❌ Login error: $e');
      rethrow;
    }
  }

  /// Get current user profile
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['ok'] == true) {
        return data['user'] as Map<String, dynamic>;
      } else {
        final errorMessage = data['message'] ?? data['error'] ?? 'Failed to get user';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('[MBUY Auth] ❌ Get current user error: $e');
      rethrow;
    }
  }

  /// Logout
  static Future<void> logout() async {
    try {
      final token = await SecureStorageService.getToken();
      if (token != null) {
        try {
          await http.post(
            Uri.parse('$baseUrl/auth/logout'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
        } catch (e) {
          debugPrint('[MBUY Auth] ⚠️ Logout API call failed: $e');
          // Continue with local logout even if API call fails
        }
      }

      // Clear local storage
      await SecureStorageService.clearAll();
      debugPrint('[MBUY Auth] ✅ Logout successful');
    } catch (e) {
      debugPrint('[MBUY Auth] ❌ Logout error: $e');
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

  /// Get current user info (synchronous from storage)
  /// Returns a Map with user info similar to Supabase User object
  /// Returns null if user is not logged in
  static Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    try {
      final loggedIn = await MbuyAuthService.isLoggedIn();
      if (!loggedIn) {
        return null;
      }

      final userId = await MbuyAuthService.getUserId();
      final userEmail = await MbuyAuthService.getUserEmail();

      if (userId == null || userEmail == null) {
        return null;
      }

      // Try to get full user info from API
      try {
        final user = await MbuyAuthService.getCurrentUser();
        return user;
      } catch (e) {
        // If API call fails, return basic info from storage
        debugPrint('[MBUY Auth] ⚠️ Failed to get full user info, using cached data: $e');
        return {
          'id': userId,
          'email': userEmail,
        };
      }
    } catch (e) {
      debugPrint('[MBUY Auth] ❌ Get current user info error: $e');
      return null;
    }
  }
}

