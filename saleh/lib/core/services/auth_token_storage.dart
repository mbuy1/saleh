import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// خدمة تخزين آمنة للتوكنات باستخدام FlutterSecureStorage
/// تحفظ access_token و refresh_token في مخزن آمن ومشفر على الجهاز
///
/// Updated for Worker v2.0:
/// - userType بدلاً من role
/// - merchantId للتجار
/// - displayName للعرض
class AuthTokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _userTypeKey = 'user_type'; // تغيير من user_role
  static const _userEmailKey = 'user_email';
  static const _merchantIdKey = 'merchant_id'; // جديد
  static const _displayNameKey = 'display_name'; // جديد
  static const _expiresAtKey = 'expires_at'; // جديد

  final FlutterSecureStorage _storage;

  AuthTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  /// حفظ التوكن مع معلومات المستخدم (Worker v2.0 format)
  Future<void> saveToken({
    required String accessToken,
    required String userId,
    required String userType,
    String? userEmail,
    String? refreshToken,
    String? merchantId,
    String? displayName,
    int? expiresIn,
  }) async {
    final List<Future<void>> futures = [
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _userTypeKey, value: userType),
    ];

    if (userEmail != null) {
      futures.add(_storage.write(key: _userEmailKey, value: userEmail));
    }
    if (refreshToken != null) {
      futures.add(_storage.write(key: _refreshTokenKey, value: refreshToken));
    }
    if (merchantId != null) {
      futures.add(_storage.write(key: _merchantIdKey, value: merchantId));
    }
    if (displayName != null) {
      futures.add(_storage.write(key: _displayNameKey, value: displayName));
    }
    if (expiresIn != null) {
      final expiresAt = DateTime.now()
          .add(Duration(seconds: expiresIn))
          .toIso8601String();
      futures.add(_storage.write(key: _expiresAtKey, value: expiresAt));
    }

    await Future.wait(futures);
  }

  /// حفظ refresh token منفصلاً
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// استرجاع التوكن
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// استرجاع refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// استرجاع معرف المستخدم
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// استرجاع نوع المستخدم (customer, merchant, merchant_user, admin, etc.)
  Future<String?> getUserType() async {
    return await _storage.read(key: _userTypeKey);
  }

  /// للتوافق مع الكود القديم - إرجاع userType
  @Deprecated('Use getUserType() instead')
  Future<String?> getUserRole() async {
    return await getUserType();
  }

  /// استرجاع إيميل المستخدم
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// استرجاع معرف التاجر (للتجار فقط)
  Future<String?> getMerchantId() async {
    return await _storage.read(key: _merchantIdKey);
  }

  /// استرجاع اسم العرض
  Future<String?> getDisplayName() async {
    return await _storage.read(key: _displayNameKey);
  }

  /// التحقق من وجود توكن صالح
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return false;

    // التحقق من انتهاء الصلاحية
    final expiresAtStr = await _storage.read(key: _expiresAtKey);
    if (expiresAtStr != null) {
      final expiresAt = DateTime.tryParse(expiresAtStr);
      if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
        return false; // انتهت الصلاحية
      }
    }

    return true;
  }

  /// مسح جميع البيانات المحفوظة (تسجيل خروج)
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _userTypeKey),
      _storage.delete(key: _userEmailKey),
      _storage.delete(key: _merchantIdKey),
      _storage.delete(key: _displayNameKey),
      _storage.delete(key: _expiresAtKey),
    ]);
  }

  /// حذف جميع البيانات من المخزن (استخدم بحذر)
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// الحصول على جميع بيانات المستخدم المحفوظة
  Future<Map<String, String?>> getAllUserData() async {
    return {
      'userId': await getUserId(),
      'userType': await getUserType(),
      'userEmail': await getUserEmail(),
      'merchantId': await getMerchantId(),
      'displayName': await getDisplayName(),
    };
  }
}

// ==========================================================================
// Riverpod Provider
// ==========================================================================

/// Provider لـ AuthTokenStorage
final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  return AuthTokenStorage();
});
