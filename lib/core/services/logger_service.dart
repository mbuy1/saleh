/// خدمة Logging مركزية
library;

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error, fatal }

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  // التحكم في المستوى الأدنى للطباعة
  LogLevel minimumLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  // قائمة الـ listeners للـ logs (مثلاً Firebase Crashlytics)
  final List<void Function(LogEntry)> _listeners = [];

  /// إضافة listener للـ logs
  void addListener(void Function(LogEntry) listener) {
    _listeners.add(listener);
  }

  /// حذف listener
  void removeListener(void Function(LogEntry) listener) {
    _listeners.remove(listener);
  }

  /// Debug log (تفاصيل تقنية)
  void debug(String message, {String? tag, dynamic data}) {
    _log(LogLevel.debug, message, tag: tag, data: data);
  }

  /// Info log (معلومات عامة)
  void info(String message, {String? tag, dynamic data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  /// Warning log (تحذيرات)
  void warning(String message, {String? tag, dynamic data}) {
    _log(LogLevel.warning, message, tag: tag, data: data);
  }

  /// Error log (أخطاء)
  void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      data: error,
      stackTrace: stackTrace,
    );
  }

  /// Fatal log (أخطاء حرجة)
  void fatal(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.fatal,
      message,
      tag: tag,
      data: error,
      stackTrace: stackTrace,
    );
  }

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic data,
    StackTrace? stackTrace,
  }) {
    // تحقق من المستوى
    if (level.index < minimumLevel.index) {
      return;
    }

    final entry = LogEntry(
      level: level,
      message: message,
      tag: tag ?? 'App',
      data: data,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
    );

    // طباعة في Console
    _printToConsole(entry);

    // إرسال للـ listeners
    for (final listener in _listeners) {
      try {
        listener(entry);
      } catch (e) {
        debugPrint('⚠️ Logger listener error: $e');
      }
    }
  }

  void _printToConsole(LogEntry entry) {
    final emoji = _getEmojiForLevel(entry.level);
    final timestamp = entry.timestamp.toString().substring(11, 19);
    final prefix = '[$timestamp] $emoji [${entry.tag}]';

    debugPrint('$prefix ${entry.message}');

    if (entry.data != null) {
      debugPrint('  └─ Data: ${entry.data}');
    }

    if (entry.stackTrace != null && entry.level.index >= LogLevel.error.index) {
      debugPrint('  └─ Stack trace:\n${entry.stackTrace}');
    }
  }

  String _getEmojiForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.fatal:
        return '💀';
    }
  }
}

/// سجل Log واحد
class LogEntry {
  final LogLevel level;
  final String message;
  final String tag;
  final dynamic data;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  LogEntry({
    required this.level,
    required this.message,
    required this.tag,
    this.data,
    this.stackTrace,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level.name,
      'message': message,
      'tag': tag,
      'data': data?.toString(),
      'timestamp': timestamp.toIso8601String(),
      'has_stack_trace': stackTrace != null,
    };
  }
}

// Global instance للاستخدام السريع
final logger = LoggerService();
