import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ============================================================================
/// MBUY Logger - خدمة التسجيل الموحدة
/// ============================================================================
///
/// خدمة logging موحدة تدعم:
/// - مستويات متعددة (debug, info, warning, error)
/// - تنسيق موحد للرسائل
/// - دعم metadata
/// - تصفية حسب الوحدة
/// - تصدير للملفات (اختياري)
///
/// الاستخدام:
/// ```dart
/// final logger = ref.read(loggerProvider);
/// logger.info('User logged in', tag: 'Auth');
/// logger.error('Failed to load', error: e, stackTrace: st);
/// ```

/// مستويات التسجيل
enum LogLevel {
  debug(0, '🔍', 'DEBUG'),
  info(1, '✅', 'INFO'),
  warning(2, '⚠️', 'WARN'),
  error(3, '❌', 'ERROR'),
  fatal(4, '💀', 'FATAL');

  final int value;
  final String emoji;
  final String label;

  const LogLevel(this.value, this.emoji, this.label);

  bool operator >=(LogLevel other) => value >= other.value;
  bool operator >(LogLevel other) => value > other.value;
  bool operator <=(LogLevel other) => value <= other.value;
  bool operator <(LogLevel other) => value < other.value;
}

/// سجل Log واحد
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? tag;
  final Object? error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? metadata;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
    this.error,
    this.stackTrace,
    this.metadata,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(
      '[${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}]',
    );
    buffer.write(' ${level.emoji} ${level.label}');
    if (tag != null) {
      buffer.write(' [$tag]');
    }
    buffer.write(': $message');
    if (error != null) {
      buffer.write('\n   Error: $error');
    }
    if (metadata != null && metadata!.isNotEmpty) {
      buffer.write('\n   Metadata: $metadata');
    }
    return buffer.toString();
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'level': level.name,
    'message': message,
    'tag': tag,
    'error': error?.toString(),
    'metadata': metadata,
  };
}

/// خدمة التسجيل الرئيسية
class MbuyLogger {
  final List<LogEntry> _logs = [];
  final int maxLogs;
  final LogLevel minLevel;
  final bool enableConsole;
  final Set<String> filteredTags;

  MbuyLogger({
    this.maxLogs = 1000,
    this.minLevel = LogLevel.debug,
    this.enableConsole = true,
    this.filteredTags = const {},
  });

  /// الحصول على جميع السجلات
  List<LogEntry> get logs => List.unmodifiable(_logs);

  /// الحصول على سجلات بمستوى معين
  List<LogEntry> getLogsByLevel(LogLevel level) {
    return _logs.where((log) => log.level == level).toList();
  }

  /// الحصول على سجلات بتاج معين
  List<LogEntry> getLogsByTag(String tag) {
    return _logs.where((log) => log.tag == tag).toList();
  }

  /// مسح جميع السجلات
  void clearLogs() {
    _logs.clear();
  }

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    // تحقق من المستوى
    if (level < minLevel) return;

    // تحقق من التاج المفلتر
    if (tag != null && filteredTags.contains(tag)) return;

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );

    // إضافة للقائمة
    _logs.add(entry);

    // حذف السجلات القديمة إذا تجاوزنا الحد
    if (_logs.length > maxLogs) {
      _logs.removeRange(0, _logs.length - maxLogs);
    }

    // طباعة للكونسول
    if (enableConsole && kDebugMode) {
      developer.log(
        entry.toString(),
        name: tag ?? 'MBUY',
        level: level.value * 250,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// تسجيل debug
  void debug(String message, {String? tag, Map<String, dynamic>? metadata}) {
    _log(LogLevel.debug, message, tag: tag, metadata: metadata);
  }

  /// تسجيل info
  void info(String message, {String? tag, Map<String, dynamic>? metadata}) {
    _log(LogLevel.info, message, tag: tag, metadata: metadata);
  }

  /// تسجيل warning
  void warning(
    String message, {
    String? tag,
    Object? error,
    Map<String, dynamic>? metadata,
  }) {
    _log(LogLevel.warning, message, tag: tag, error: error, metadata: metadata);
  }

  /// تسجيل error
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  /// تسجيل fatal error
  void fatal(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    _log(
      LogLevel.fatal,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  /// تسجيل بداية عملية (لقياس الوقت)
  Stopwatch startOperation(String name, {String? tag}) {
    debug('⏱️ Started: $name', tag: tag);
    return Stopwatch()..start();
  }

  /// تسجيل نهاية عملية
  void endOperation(
    String name,
    Stopwatch stopwatch, {
    String? tag,
    bool success = true,
  }) {
    stopwatch.stop();
    final duration = stopwatch.elapsedMilliseconds;
    if (success) {
      info('⏱️ Completed: $name in ${duration}ms', tag: tag);
    } else {
      warning('⏱️ Failed: $name after ${duration}ms', tag: tag);
    }
  }

  /// تسجيل API request
  void apiRequest(String method, String path, {Map<String, dynamic>? body}) {
    debug(
      '📤 $method $path',
      tag: 'API',
      metadata: body != null ? {'body_keys': body.keys.toList()} : null,
    );
  }

  /// تسجيل API response
  void apiResponse(
    String method,
    String path, {
    required int statusCode,
    int? durationMs,
    Object? error,
  }) {
    final isSuccess = statusCode >= 200 && statusCode < 300;
    final level = isSuccess ? LogLevel.info : LogLevel.error;

    _log(
      level,
      '📥 $method $path [$statusCode] ${durationMs != null ? '${durationMs}ms' : ''}',
      tag: 'API',
      error: isSuccess ? null : error,
    );
  }

  /// تسجيل انتقال الشاشة
  void screenView(String screenName, {Map<String, dynamic>? params}) {
    info('📱 Screen: $screenName', tag: 'Navigation', metadata: params);
  }

  /// تسجيل حدث المستخدم
  void userEvent(String event, {Map<String, dynamic>? params}) {
    info('👆 Event: $event', tag: 'User', metadata: params);
  }

  /// تصدير السجلات كـ JSON
  List<Map<String, dynamic>> exportLogs() {
    return _logs.map((e) => e.toJson()).toList();
  }
}

/// Logger Provider
final loggerProvider = Provider<MbuyLogger>((ref) {
  return MbuyLogger(
    maxLogs: 1000,
    minLevel: kDebugMode ? LogLevel.debug : LogLevel.info,
    enableConsole: true,
  );
});

/// Tags شائعة
abstract class LogTags {
  static const String auth = 'Auth';
  static const String api = 'API';
  static const String navigation = 'Navigation';
  static const String user = 'User';
  static const String products = 'Products';
  static const String orders = 'Orders';
  static const String store = 'Store';
  static const String storage = 'Storage';
  static const String push = 'Push';
  static const String analytics = 'Analytics';
}
