import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';

/// ============================================================================
/// Error Boundary - معالج الأخطاء الشامل
/// ============================================================================
///
/// يلتقط الأخطاء غير المعالجة في التطبيق ويعرض واجهة بديلة
/// بدلاً من crash التطبيق
///
/// الاستخدام:
/// ```dart
/// ErrorBoundary(
///   child: MyWidget(),
///   onError: (error, stackTrace) => logError(error),
/// )
/// ```

/// Error Boundary Widget
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;
  final void Function(Object error, StackTrace? stackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();
  }

  void _resetError() {
    setState(() {
      _error = null;
      _stackTrace = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!, _stackTrace) ??
          _DefaultErrorWidget(
            error: _error!,
            stackTrace: _stackTrace,
            onRetry: _resetError,
          );
    }

    return ErrorWidgetBuilder(
      onError: (error, stackTrace) {
        widget.onError?.call(error, stackTrace);
        if (mounted) {
          setState(() {
            _error = error;
            _stackTrace = stackTrace;
          });
        }
      },
      child: widget.child,
    );
  }
}

/// Error Widget Builder - يلتقط الأخطاء من الـ Widget Tree
class ErrorWidgetBuilder extends StatefulWidget {
  final Widget child;
  final void Function(Object error, StackTrace? stackTrace) onError;

  const ErrorWidgetBuilder({
    super.key,
    required this.child,
    required this.onError,
  });

  @override
  State<ErrorWidgetBuilder> createState() => _ErrorWidgetBuilderState();
}

class _ErrorWidgetBuilderState extends State<ErrorWidgetBuilder> {
  @override
  Widget build(BuildContext context) {
    // في Debug mode، لا نلتقط الأخطاء لنرى الـ Red Screen
    if (kDebugMode) {
      return widget.child;
    }

    // في Production، نستخدم ErrorWidget.builder
    ErrorWidget.builder = (FlutterErrorDetails details) {
      widget.onError(details.exception, details.stack);
      return _DefaultErrorWidget(
        error: details.exception,
        stackTrace: details.stack,
        onRetry: () {
          // يمكن للمستخدم الضغط للعودة
        },
      );
    };

    return widget.child;
  }
}

/// واجهة الخطأ الافتراضية
class _DefaultErrorWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

  const _DefaultErrorWidget({
    required this.error,
    this.stackTrace,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacing24),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.error,
                  width: 64,
                  height: 64,
                  colorFilter: const ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              const Text(
                'حدث خطأ غير متوقع',
                style: TextStyle(
                  fontSize: AppDimensions.fontHeadline,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing12),
              const Text(
                'نأسف لهذا الخطأ. يرجى المحاولة مرة أخرى\nأو التواصل مع الدعم إذا استمرت المشكلة.',
                style: TextStyle(
                  fontSize: AppDimensions.fontBody,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (kDebugMode) ...[
                const SizedBox(height: AppDimensions.spacing16),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacing12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(
                      fontSize: AppDimensions.fontCaption,
                      color: Colors.red,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.spacing32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onRetry != null)
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: SvgPicture.asset(
                        AppIcons.refresh,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: const Text('إعادة المحاولة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing24,
                          vertical: AppDimensions.spacing12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDimensions.borderRadiusM,
                        ),
                      ),
                    ),
                  const SizedBox(width: AppDimensions.spacing12),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: SvgPicture.asset(
                      AppIcons.home,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppTheme.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: const Text('الرئيسية'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing24,
                        vertical: AppDimensions.spacing12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDimensions.borderRadiusM,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Global Error Handler - معالج أخطاء عام
/// يُستخدم لتسجيل الأخطاء وإرسالها لخدمة مراقبة
class GlobalErrorHandler {
  static final GlobalErrorHandler _instance = GlobalErrorHandler._internal();
  factory GlobalErrorHandler() => _instance;
  GlobalErrorHandler._internal();

  final List<void Function(Object error, StackTrace? stackTrace)> _listeners =
      [];

  /// تهيئة معالج الأخطاء
  void initialize() {
    // التقاط أخطاء Flutter
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleError(details.exception, details.stack);
      // في Debug، نطبع الخطأ
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    // التقاط أخطاء Dart غير المعالجة
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleError(error, stack);
      return true;
    };
  }

  /// إضافة مستمع للأخطاء
  void addListener(
    void Function(Object error, StackTrace? stackTrace) listener,
  ) {
    _listeners.add(listener);
  }

  /// إزالة مستمع
  void removeListener(
    void Function(Object error, StackTrace? stackTrace) listener,
  ) {
    _listeners.remove(listener);
  }

  void _handleError(Object error, StackTrace? stackTrace) {
    // تسجيل الخطأ
    debugPrint('🔴 Error: $error');
    if (stackTrace != null) {
      debugPrint('📍 StackTrace: $stackTrace');
    }

    // إخطار المستمعين
    for (final listener in _listeners) {
      listener(error, stackTrace);
    }

    // NOTE: يمكن إضافة تكامل مع خدمات المراقبة مثل:
    // - Firebase Crashlytics
    // - Sentry
    // _sendToMonitoringService(error, stackTrace);
  }
}

/// App Error Reporter - لتسجيل الأخطاء المخصصة
class AppErrorReporter {
  /// تسجيل خطأ مخصص
  static void reportError(
    Object error, {
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? extras,
  }) {
    debugPrint('🔴 [Error Report] ${context ?? 'Unknown context'}');
    debugPrint('   Error: $error');
    if (extras != null) {
      debugPrint('   Extras: $extras');
    }
    if (stackTrace != null) {
      debugPrint('   Stack: $stackTrace');
    }

    // NOTE: يمكن إضافة تكامل مع خدمات المراقبة هنا
  }

  /// تسجيل تحذير
  static void reportWarning(String message, {Map<String, dynamic>? extras}) {
    debugPrint('🟡 [Warning] $message');
    if (extras != null) {
      debugPrint('   Extras: $extras');
    }
  }

  /// تسجيل معلومة
  static void reportInfo(String message, {Map<String, dynamic>? extras}) {
    debugPrint('🔵 [Info] $message');
    if (extras != null) {
      debugPrint('   Extras: $extras');
    }
  }
}
