import '../../features/auth/data/auth_repository.dart';

/// Utility functions for authentication
/// Use these instead of directly accessing supabaseClient.auth
class AuthUtils {
  /// Get current user ID
  /// Replaces: supabaseClient.auth.currentUser?.id
  static Future<String?> getCurrentUserId() async {
    return await AuthRepository.getUserId();
  }

  /// Get current user email
  /// Replaces: supabaseClient.auth.currentUser?.email
  static Future<String?> getCurrentUserEmail() async {
    return await AuthRepository.getUserEmail();
  }

  /// Check if user is authenticated
  /// Replaces: supabaseClient.auth.currentUser != null
  static Future<bool> isAuthenticated() async {
    return await AuthRepository.isLoggedIn();
  }

  /// Get current user data
  /// Replaces: supabaseClient.auth.currentUser
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      return await AuthRepository.getCurrentUser();
    } catch (e) {
      return null;
    }
  }
}

