import 'package:flutter/material.dart';

/// Design System Colors - ألوان نظام التصميم
///
/// هذا الملف يحتوي على جميع ألوان التطبيق بشكل منظم
/// مستخرج من AppTheme للحفاظ على التوافقية

class DSColors {
  DSColors._();

  // ============================================================================
  // Primary Colors - الألوان الأساسية
  // ============================================================================

  /// اللون الأساسي للتطبيق - أزرق
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // ============================================================================
  // Secondary Colors - الألوان الثانوية
  // ============================================================================

  /// اللون الثانوي - تركواز
  static const Color secondary = Color(0xFF00B4B4);
  static const Color secondaryLight = Color(0xFF4DD4D4);
  static const Color secondaryDark = Color(0xFF008585);

  // ============================================================================
  // Accent Colors - ألوان التمييز
  // ============================================================================

  /// لون التمييز - برتقالي للأزرار والإجراءات
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentLight = Color(0xFFFF9A6C);
  static const Color accentDark = Color(0xFFE54D1B);

  // ============================================================================
  // Semantic Colors - ألوان دلالية
  // ============================================================================

  /// نجاح
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  /// تحذير
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  /// خطأ
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  /// معلومات
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // ============================================================================
  // Neutral Colors - ألوان محايدة
  // ============================================================================

  /// الخلفية
  static const Color background = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  /// النصوص
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);

  /// الحدود
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderDark = Color(0xFFCBD5E1);

  /// Slate Scale
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
}
