import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';
import '../constants/app_dimensions.dart';

/// معالج أخطاء API موحد
/// يوفر معالجة موحدة لجميع أخطاء API عبر التطبيق
class ApiErrorHandler {
  /// معالجة خطأ API وعرض رسالة للمستخدم
  static void handleError(BuildContext context, dynamic error) {
    String message = 'حدث خطأ غير متوقع';
    bool shouldNavigateToLogin = false;

    if (error is http.Response) {
      switch (error.statusCode) {
        case 401:
          message = 'انتهت صلاحية الجلسة - يرجى تسجيل الدخول مرة أخرى';
          shouldNavigateToLogin = true;
          break;
        case 403:
          message = 'ليس لديك صلاحية للوصول لهذا المورد';
          break;
        case 404:
          message = 'المورد المطلوب غير موجود';
          break;
        case 500:
          message = 'خطأ في الخادم - يرجى المحاولة لاحقاً';
          break;
        default:
          message = 'حدث خطأ (${error.statusCode})';
      }
    } else if (error is Exception) {
      final errorString = error.toString();
      if (errorString.contains('SocketException') ||
          errorString.contains('Network')) {
        message = 'لا يوجد اتصال بالإنترنت - يرجى التحقق من الاتصال';
      } else if (errorString.contains('Timeout')) {
        message = 'انتهت مهلة الاتصال - يرجى المحاولة مرة أخرى';
      } else {
        message = errorString.replaceFirst('Exception: ', '');
      }
    } else {
      message = error.toString();
    }

    // عرض رسالة الخطأ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusS,
        ),
        duration: const Duration(seconds: 4),
      ),
    );

    // التنقل لصفحة تسجيل الدخول إذا لزم الأمر
    if (shouldNavigateToLogin) {
      // سيتم التعامل معه من Router
    }
  }

  /// استخراج رسالة خطأ من Response
  static String extractErrorMessage(http.Response response) {
    try {
      final data = response.body;
      if (data.isNotEmpty) {
        // محاولة استخراج رسالة من JSON
        final json = data;
        if (json.contains('"message"')) {
          // يمكن إضافة parsing للـ JSON هنا إذا لزم الأمر
        }
      }
    } catch (_) {
      // تجاهل أخطاء parsing
    }

    // رسالة افتراضية حسب status code
    switch (response.statusCode) {
      case 401:
        return 'انتهت صلاحية الجلسة';
      case 403:
        return 'ليس لديك صلاحية';
      case 404:
        return 'المورد غير موجود';
      case 500:
        return 'خطأ في الخادم';
      default:
        return 'حدث خطأ (${response.statusCode})';
    }
  }
}

