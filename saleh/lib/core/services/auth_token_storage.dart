import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// خدمة تخزين آمنة للتوكنات باستخدام FlutterSecureStorage
/// تحفظ access_token و refresh_token في مخزن آمن ومشفر على الجهاز
class AuthTokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _userRoleKey = 'user_role';
  static const _userEmailKey = 'user_email';

  final FlutterSecureStorage _storage;

  AuthTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  /// حفظ التوكن مع معلومات المستخدم
  Future<void> saveToken({
    required String accessToken,
    required String userId,
    required String userRole,
    String? userEmail,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _userRoleKey, value: userRole),
      if (userEmail != null)
        _storage.write(key: _userEmailKey, value: userEmail),
    ]);
  }

  /// استرجاع التوكن
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// استرجاع refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// حفظ refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// استرجاع معرف المستخدم
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// استرجاع دور المستخدم (customer, merchant, admin)
  Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  /// استرجاع إيميل المستخدم
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// التحقق من وجود توكن صالح
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// مسح جميع البيانات المحفوظة (تسجيل خروج)
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _userRoleKey),
      _storage.delete(key: _userEmailKey),
    ]);
  }

  /// حذف جميع البيانات من المخزن (استخدم بحذر)
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

// ==========================================================================
// Riverpod Provider
// ==========================================================================

/// Provider لـ AuthTokenStorage
final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  return AuthTokenStorage();
});
