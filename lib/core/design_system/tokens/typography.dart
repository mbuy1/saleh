import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Design System Typography - الطباعة
///
/// أنماط النصوص الموحدة في التطبيق

class DSTypography {
  DSTypography._();

  // ============================================================================
  // Font Family
  // ============================================================================

  static String get fontFamily => GoogleFonts.cairo().fontFamily ?? 'Cairo';

  // ============================================================================
  // Display Styles - العناوين الكبيرة
  // ============================================================================

  static TextStyle get displayLarge => GoogleFonts.cairo(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: DSColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get displayMedium => GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: DSColors.textPrimary,
    height: 1.25,
  );

  static TextStyle get displaySmall => GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: DSColors.textPrimary,
    height: 1.3,
  );

  // ============================================================================
  // Headline Styles - عناوين الأقسام
  // ============================================================================

  static TextStyle get headlineLarge => GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: DSColors.textPrimary,
    height: 1.35,
  );

  static TextStyle get headlineMedium => GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: DSColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get headlineSmall => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: DSColors.textPrimary,
    height: 1.4,
  );

  // ============================================================================
  // Title Styles - العناوين الفرعية
  // ============================================================================

  static TextStyle get titleLarge => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: DSColors.textPrimary,
    height: 1.45,
  );

  static TextStyle get titleMedium => GoogleFonts.cairo(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: DSColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get titleSmall => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: DSColors.textPrimary,
    height: 1.5,
  );

  // ============================================================================
  // Body Styles - النص الأساسي
  // ============================================================================

  static TextStyle get bodyLarge => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: DSColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: DSColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: DSColors.textSecondary,
    height: 1.5,
  );

  // ============================================================================
  // Label Styles - التسميات
  // ============================================================================

  static TextStyle get labelLarge => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: DSColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get labelMedium => GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: DSColors.textSecondary,
    height: 1.4,
  );

  static TextStyle get labelSmall => GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: DSColors.textHint,
    height: 1.4,
  );

  // ============================================================================
  // Special Styles - أنماط خاصة
  // ============================================================================

  /// نص الأزرار
  static TextStyle get button =>
      GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4);

  /// نص الروابط
  static TextStyle get link => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: DSColors.primary,
    decoration: TextDecoration.underline,
    height: 1.5,
  );

  /// نص الأسعار
  static TextStyle get price => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: DSColors.accent,
    height: 1.3,
  );

  /// نص الأرقام
  static TextStyle get number => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: DSColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );
}
