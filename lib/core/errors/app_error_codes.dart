/// تعريف أكواد الأخطاء الموحدة عبر التطبيق
library;

enum AppErrorCode {
  // ============================================================================
  // Network & API Errors (1000-1099)
  // ============================================================================
  networkError('NETWORK_ERROR', 1000, 'خطأ في الاتصال بالإنترنت'),
  serverError('SERVER_ERROR', 1001, 'خطأ في الخادم'),
  timeout('TIMEOUT', 1002, 'انتهت مهلة الطلب'),
  unauthorized('UNAUTHORIZED', 1003, 'يجب تسجيل الدخول'),
  forbidden('FORBIDDEN', 1004, 'ليس لديك صلاحية الوصول'),
  notFound('NOT_FOUND', 1005, 'العنصر غير موجود'),
  rateLimitExceeded(
    'RATE_LIMIT_EXCEEDED',
    1006,
    'تم تجاوز عدد الطلبات المسموحة',
  ),

  // ============================================================================
  // Validation Errors (1100-1199)
  // ============================================================================
  validationError('VALIDATION_ERROR', 1100, 'بيانات غير صحيحة'),
  invalidEmail('INVALID_EMAIL', 1101, 'البريد الإلكتروني غير صحيح'),
  invalidPhone('INVALID_PHONE', 1102, 'رقم الهاتف غير صحيح'),
  invalidAmount('INVALID_AMOUNT', 1103, 'المبلغ غير صحيح'),
  requiredField('REQUIRED_FIELD', 1104, 'هذا الحقل مطلوب'),

  // ============================================================================
  // Authentication Errors (1200-1299)
  // ============================================================================
  authFailed('AUTH_FAILED', 1200, 'فشل تسجيل الدخول'),
  invalidCredentials('INVALID_CREDENTIALS', 1201, 'البيانات غير صحيحة'),
  accountDisabled('ACCOUNT_DISABLED', 1202, 'الحساب معطل'),
  emailNotVerified('EMAIL_NOT_VERIFIED', 1203, 'البريد الإلكتروني غير موثق'),
  tokenExpired('TOKEN_EXPIRED', 1204, 'انتهت صلاحية الجلسة'),

  // ============================================================================
  // Business Logic Errors (1300-1399)
  // ============================================================================
  insufficientBalance('INSUFFICIENT_BALANCE', 1300, 'الرصيد غير كافٍ'),
  insufficientPoints('INSUFFICIENT_POINTS', 1301, 'النقاط غير كافية'),
  outOfStock('OUT_OF_STOCK', 1302, 'المنتج غير متوفر'),
  cartEmpty('CART_EMPTY', 1303, 'السلة فارغة'),
  orderNotFound('ORDER_NOT_FOUND', 1304, 'الطلب غير موجود'),
  storeNotFound('STORE_NOT_FOUND', 1305, 'المتجر غير موجود'),
  productNotFound('PRODUCT_NOT_FOUND', 1306, 'المنتج غير موجود'),
  featureNotFound('FEATURE_NOT_FOUND', 1307, 'الميزة غير موجودة أو معطلة'),
  duplicateEntry('DUPLICATE_ENTRY', 1308, 'هذا العنصر موجود مسبقاً'),

  // ============================================================================
  // Unknown Error (9999)
  // ============================================================================
  unknown('UNKNOWN_ERROR', 9999, 'حدث خطأ غير متوقع');

  const AppErrorCode(this.code, this.numericCode, this.defaultMessage);

  final String code;
  final int numericCode;
  final String defaultMessage;

  /// البحث عن error code بالنص
  static AppErrorCode? fromCode(String code) {
    try {
      return AppErrorCode.values.firstWhere((e) => e.code == code);
    } catch (_) {
      return null;
    }
  }

  /// البحث عن error code بالرقم
  static AppErrorCode? fromNumericCode(int numericCode) {
    try {
      return AppErrorCode.values.firstWhere(
        (e) => e.numericCode == numericCode,
      );
    } catch (_) {
      return null;
    }
  }
}

/// استثناء مخصص للتطبيق
class AppException implements Exception {
  final AppErrorCode errorCode;
  final String? message;
  final dynamic details;
  final StackTrace? stackTrace;

  AppException({
    required this.errorCode,
    this.message,
    this.details,
    this.stackTrace,
  });

  /// الرسالة التي ستعرض للمستخدم
  String get userMessage => message ?? errorCode.defaultMessage;

  /// رسالة تقنية للمطورين
  String get technicalMessage =>
      '[${errorCode.code}] $userMessage${details != null ? ' | Details: $details' : ''}';

  @override
  String toString() => technicalMessage;

  /// إنشاء من API response
  factory AppException.fromResponse(Map<String, dynamic> response) {
    final errorCodeStr = response['error_code'] as String?;
    final errorMessage = response['error'] as String?;
    final details = response['details'];

    AppErrorCode code = AppErrorCode.unknown;
    if (errorCodeStr != null) {
      code = AppErrorCode.fromCode(errorCodeStr) ?? AppErrorCode.unknown;
    }

    return AppException(
      errorCode: code,
      message: errorMessage,
      details: details,
    );
  }

  /// إنشاء من network error
  factory AppException.network([String? message]) {
    return AppException(errorCode: AppErrorCode.networkError, message: message);
  }

  /// إنشاء من server error
  factory AppException.server([String? message]) {
    return AppException(errorCode: AppErrorCode.serverError, message: message);
  }

  /// إنشاء من validation error
  factory AppException.validation(String message, {dynamic details}) {
    return AppException(
      errorCode: AppErrorCode.validationError,
      message: message,
      details: details,
    );
  }
}
