import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage Service for storing sensitive data like JWT tokens
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys
  static const String _keyJwtToken =
      'auth_token'; // Changed to auth_token as requested
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'mbuy_user_id';
  static const String _keyUserEmail = 'mbuy_user_email';
  static const String _keyStoreId = 'store_id';

  /// Save JWT token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyJwtToken, value: token);
  }

  /// Get JWT token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyJwtToken);
  }

  /// Delete JWT token
  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyJwtToken);
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// Delete refresh token
  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  /// Save store ID
  static Future<void> saveStoreId(String storeId) async {
    await _storage.write(key: _keyStoreId, value: storeId);
  }

  /// Get store ID
  static Future<String?> getStoreId() async {
    return await _storage.read(key: _keyStoreId);
  }

  /// Delete store ID
  static Future<void> deleteStoreId() async {
    await _storage.delete(key: _keyStoreId);
  }

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Delete user ID
  static Future<void> deleteUserId() async {
    await _storage.delete(key: _keyUserId);
  }

  /// Save user email
  static Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _keyUserEmail, value: email);
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  /// Delete user email
  static Future<void> deleteUserEmail() async {
    await _storage.delete(key: _keyUserEmail);
  }

  /// Clear all auth data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Save a string value with a custom key
  static Future<void> saveString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Get a string value with a custom key
  static Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a string value with a custom key
  static Future<void> deleteString(String key) async {
    await _storage.delete(key: key);
  }
}
