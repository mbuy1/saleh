/// أنواع الأخطاء في التطبيق
enum AppExceptionType {
  network, // مشاكل الاتصال
  server, // أخطاء السيرفر
  validation, // أخطاء التحقق من البيانات
  unauthorized, // عدم وجود صلاحية
  notFound, // البيانات غير موجودة
  timeout, // انتهاء الوقت
  unknown, // خطأ غير معروف
}

/// استثناء موحد للتطبيق
class AppException implements Exception {
  final AppExceptionType type;
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.type,
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  /// إنشاء استثناء من خطأ الشبكة
  factory AppException.network({String? message}) {
    return AppException(
      type: AppExceptionType.network,
      message: message ?? 'خطأ في الاتصال بالإنترنت',
      code: 'NETWORK_ERROR',
    );
  }

  /// إنشاء استثناء من خطأ السيرفر
  factory AppException.server({String? message, String? code}) {
    return AppException(
      type: AppExceptionType.server,
      message: message ?? 'خطأ في السيرفر',
      code: code ?? 'SERVER_ERROR',
    );
  }

  /// إنشاء استثناء من خطأ التحقق
  factory AppException.validation({required String message}) {
    return AppException(
      type: AppExceptionType.validation,
      message: message,
      code: 'VALIDATION_ERROR',
    );
  }

  /// إنشاء استثناء من عدم وجود صلاحية
  factory AppException.unauthorized({String? message}) {
    return AppException(
      type: AppExceptionType.unauthorized,
      message: message ?? 'غير مصرح لك بهذا الإجراء',
      code: 'UNAUTHORIZED',
    );
  }

  /// إنشاء استثناء من عدم وجود البيانات
  factory AppException.notFound({String? message}) {
    return AppException(
      type: AppExceptionType.notFound,
      message: message ?? 'البيانات المطلوبة غير موجودة',
      code: 'NOT_FOUND',
    );
  }

  /// إنشاء استثناء من انتهاء الوقت
  factory AppException.timeout({String? message}) {
    return AppException(
      type: AppExceptionType.timeout,
      message: message ?? 'انتهى وقت الاتصال',
      code: 'TIMEOUT',
    );
  }

  /// إنشاء استثناء غير معروف
  factory AppException.unknown({String? message, dynamic error}) {
    return AppException(
      type: AppExceptionType.unknown,
      message: message ?? 'حدث خطأ غير متوقع',
      code: 'UNKNOWN_ERROR',
      originalError: error,
    );
  }

  /// تحويل Exception عادي إلى AppException
  factory AppException.fromException(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppException) return error;

    final errorMessage = error.toString();

    // تحليل نوع الخطأ من الرسالة
    if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('internet')) {
      return AppException.network(message: errorMessage);
    }

    if (errorMessage.contains('timeout')) {
      return AppException.timeout(message: errorMessage);
    }

    if (errorMessage.contains('unauthorized') ||
        errorMessage.contains('not authorized') ||
        errorMessage.contains('permission')) {
      return AppException.unauthorized(message: errorMessage);
    }

    if (errorMessage.contains('not found') || errorMessage.contains('404')) {
      return AppException.notFound(message: errorMessage);
    }

    return AppException.unknown(message: errorMessage, error: error);
  }

  /// رسالة مناسبة للمستخدم
  String get userMessage {
    switch (type) {
      case AppExceptionType.network:
        return 'يرجى التحقق من اتصال الإنترنت';
      case AppExceptionType.server:
        return 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً';
      case AppExceptionType.validation:
        return message;
      case AppExceptionType.unauthorized:
        return 'غير مصرح لك بهذا الإجراء';
      case AppExceptionType.notFound:
        return 'البيانات المطلوبة غير موجودة';
      case AppExceptionType.timeout:
        return 'انتهى وقت الانتظار، يرجى المحاولة مرة أخرى';
      case AppExceptionType.unknown:
        return 'حدث خطأ غير متوقع';
    }
  }

  /// هل الخطأ خطير ويجب تسجيله
  bool get isCritical {
    return type == AppExceptionType.server || type == AppExceptionType.unknown;
  }

  @override
  String toString() {
    return 'AppException(type: $type, message: $message, code: $code)';
  }
}
