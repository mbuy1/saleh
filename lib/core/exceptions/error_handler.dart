import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../theme/app_theme.dart';
import 'app_exception.dart';

/// معالج الأخطاء في UI
class ErrorHandler {
  /// عرض خطأ في SnackBar
  static void showErrorSnackBar(
    BuildContext context,
    dynamic error, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final appException = error is AppException
        ? error
        : AppException.fromException(error);

    // تسجيل الأخطاء الخطيرة
    if (appException.isCritical) {
      _logError(appException);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_getIconForException(appException.type), color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                appException.userMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: _getColorForException(appException.type),
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: SnackBarAction(
          label: 'حسناً',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  /// عرض خطأ في Dialog
  static void showErrorDialog(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    final appException = error is AppException
        ? error
        : AppException.fromException(error);

    if (appException.isCritical) {
      _logError(appException);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          _getIconForException(appException.type),
          color: _getColorForException(appException.type),
          size: 48,
        ),
        title: Text(
          _getTitleForException(appException.type),
          textAlign: TextAlign.center,
        ),
        content: Text(appException.userMessage, textAlign: TextAlign.center),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('إعادة المحاولة'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  /// معالجة خطأ بشكل صامت (للـ background operations)
  static void handleSilently(dynamic error) {
    final appException = error is AppException
        ? error
        : AppException.fromException(error);

    if (appException.isCritical) {
      _logError(appException);
    }
  }

  /// تسجيل الخطأ (يمكن ربطه بـ Crashlytics/Sentry)
  static void _logError(AppException exception) {
    if (kDebugMode) {
      debugPrint('❌ AppException: ${exception.type}');
      debugPrint('   Message: ${exception.message}');
      debugPrint('   Code: ${exception.code}');
      if (exception.originalError != null) {
        debugPrint('   Original: ${exception.originalError}');
      }
    }

    // TODO: إرسال الأخطاء الخطيرة إلى Crashlytics/Sentry
    // FirebaseCrashlytics.instance.recordError(exception, exception.stackTrace);
  }

  /// الحصول على أيقونة مناسبة للخطأ
  static IconData _getIconForException(AppExceptionType type) {
    switch (type) {
      case AppExceptionType.network:
        return Icons.wifi_off;
      case AppExceptionType.server:
        return Icons.cloud_off;
      case AppExceptionType.validation:
        return Icons.error_outline;
      case AppExceptionType.unauthorized:
        return Icons.lock_outline;
      case AppExceptionType.notFound:
        return Icons.search_off;
      case AppExceptionType.timeout:
        return Icons.hourglass_empty;
      case AppExceptionType.unknown:
        return Icons.warning_amber;
    }
  }

  /// الحصول على لون مناسب للخطأ
  static Color _getColorForException(AppExceptionType type) {
    switch (type) {
      case AppExceptionType.network:
        return MbuyColors.warning;
      case AppExceptionType.server:
        return MbuyColors.error;
      case AppExceptionType.validation:
        return MbuyColors.warning;
      case AppExceptionType.unauthorized:
        return MbuyColors.error;
      case AppExceptionType.notFound:
        return MbuyColors.info;
      case AppExceptionType.timeout:
        return MbuyColors.warning;
      case AppExceptionType.unknown:
        return MbuyColors.error;
    }
  }

  /// الحصول على عنوان مناسب للخطأ
  static String _getTitleForException(AppExceptionType type) {
    switch (type) {
      case AppExceptionType.network:
        return 'مشكلة في الاتصال';
      case AppExceptionType.server:
        return 'خطأ في الخادم';
      case AppExceptionType.validation:
        return 'خطأ في البيانات';
      case AppExceptionType.unauthorized:
        return 'غير مصرح';
      case AppExceptionType.notFound:
        return 'غير موجود';
      case AppExceptionType.timeout:
        return 'انتهى الوقت';
      case AppExceptionType.unknown:
        return 'خطأ غير متوقع';
    }
  }
}
