import 'package:flutter/foundation.dart';
import '../../features/auth/data/auth_repository.dart';

// DEPRECATED: Use AuthRepository directly instead
// This file is kept for backward compatibility only

/// Helper class to provide Supabase-like User object from MBUY Auth
class MbuyUser {
  final String id;
  final String? email;
  final String? fullName;
  final Map<String, dynamic> data;

  MbuyUser({
    required this.id,
    this.email,
    this.fullName,
    Map<String, dynamic>? data,
  }) : data = data ?? {};

  factory MbuyUser.fromMap(Map<String, dynamic> map) {
    return MbuyUser(
      id: map['id'] as String,
      email: map['email'] as String?,
      fullName: map['full_name'] as String?,
      data: map,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      ...data,
    };
  }
}

/// Helper class to check auth state similar to Supabase
class MbuyAuthHelper {
  /// Get current user (similar to supabaseClient.auth.currentUser)
  /// DEPRECATED: Use AuthRepository.getCurrentUser() instead
  @Deprecated('Use AuthRepository.getCurrentUser() instead')
  static Future<MbuyUser?> getCurrentUser() async {
    try {
      final userInfo = await AuthRepository.getCurrentUser();
      return MbuyUser.fromMap(userInfo);
    } catch (e) {
      debugPrint('[MbuyAuthHelper] Error getting current user: $e');
      return null;
    }
  }

  /// Check if user is signed in
  /// DEPRECATED: Use AuthRepository.isLoggedIn() instead
  @Deprecated('Use AuthRepository.isLoggedIn() instead')
  static Future<bool> isSignedIn() async {
    return await AuthRepository.isLoggedIn();
  }

  /// Get current user ID (similar to supabaseClient.auth.currentUser?.id)
  /// DEPRECATED: Use AuthRepository.getUserId() instead
  @Deprecated('Use AuthRepository.getUserId() instead')
  static Future<String?> getCurrentUserId() async {
    return await AuthRepository.getUserId();
  }

  /// Get current user email
  /// DEPRECATED: Use AuthRepository.getUserEmail() instead
  @Deprecated('Use AuthRepository.getUserEmail() instead')
  static Future<String?> getCurrentUserEmail() async {
    return await AuthRepository.getUserEmail();
  }

  /// Check if user is authenticated (similar to supabaseClient.auth.currentUser != null)
  /// DEPRECATED: Use AuthRepository.isLoggedIn() instead
  @Deprecated('Use AuthRepository.isLoggedIn() instead')
  static Future<bool> hasCurrentUser() async {
    return await AuthRepository.isLoggedIn();
  }
}

