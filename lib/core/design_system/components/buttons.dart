import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/radius.dart';
import '../tokens/typography.dart';

/// Design System Buttons - أنماط الأزرار
///
/// مكونات الأزرار الموحدة في التطبيق

class DSButtonStyles {
  DSButtonStyles._();

  // ============================================================================
  // Primary Button - الزر الرئيسي
  // ============================================================================

  static ButtonStyle get primary => ElevatedButton.styleFrom(
    backgroundColor: DSColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: DSSpacing.buttonPaddingH,
      vertical: DSSpacing.buttonPaddingV,
    ),
    shape: RoundedRectangleBorder(borderRadius: DSRadius.borderMD),
    elevation: 0,
    textStyle: DSTypography.button,
  );

  // ============================================================================
  // Secondary Button - الزر الثانوي
  // ============================================================================

  static ButtonStyle get secondary => ElevatedButton.styleFrom(
    backgroundColor: DSColors.secondary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: DSSpacing.buttonPaddingH,
      vertical: DSSpacing.buttonPaddingV,
    ),
    shape: RoundedRectangleBorder(borderRadius: DSRadius.borderMD),
    elevation: 0,
    textStyle: DSTypography.button,
  );

  // ============================================================================
  // Accent Button - زر التمييز
  // ============================================================================

  static ButtonStyle get accent => ElevatedButton.styleFrom(
    backgroundColor: DSColors.accent,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: DSSpacing.buttonPaddingH,
      vertical: DSSpacing.buttonPaddingV,
    ),
    shape: RoundedRectangleBorder(borderRadius: DSRadius.borderMD),
    elevation: 0,
    textStyle: DSTypography.button,
  );

  // ============================================================================
  // Outlined Button - زر محدد
  // ============================================================================

  static ButtonStyle get outlined => OutlinedButton.styleFrom(
    foregroundColor: DSColors.primary,
    padding: const EdgeInsets.symmetric(
      horizontal: DSSpacing.buttonPaddingH,
      vertical: DSSpacing.buttonPaddingV,
    ),
    shape: RoundedRectangleBorder(borderRadius: DSRadius.borderMD),
    side: const BorderSide(color: DSColors.primary),
    textStyle: DSTypography.button,
  );

  // ============================================================================
  // Text Button - زر نصي
  // ============================================================================

  static ButtonStyle get text => TextButton.styleFrom(
    foregroundColor: DSColors.primary,
    padding: const EdgeInsets.symmetric(
      horizontal: DSSpacing.sm,
      vertical: DSSpacing.xs,
    ),
    shape: RoundedRectangleBorder(borderRadius: DSRadius.borderSM),
    textStyle: DSTypography.button,
  );

  // ============================================================================
  // Icon Button - زر أيقونة
  // ============================================================================

  static ButtonStyle get icon => IconButton.styleFrom(
    foregroundColor: DSColors.textPrimary,
    padding: const EdgeInsets.all(DSSpacing.sm),
    shape: RoundedRectangleBorder(borderRadius: DSRadius.borderSM),
  );

  // ============================================================================
  // Danger Button - زر الخطر
  // ============================================================================

  static ButtonStyle get danger => ElevatedButton.styleFrom(
    backgroundColor: DSColors.error,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: DSSpacing.buttonPaddingH,
      vertical: DSSpacing.buttonPaddingV,
    ),
    shape: RoundedRectangleBorder(borderRadius: DSRadius.borderMD),
    elevation: 0,
    textStyle: DSTypography.button,
  );

  // ============================================================================
  // Success Button - زر النجاح
  // ============================================================================

  static ButtonStyle get success => ElevatedButton.styleFrom(
    backgroundColor: DSColors.success,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: DSSpacing.buttonPaddingH,
      vertical: DSSpacing.buttonPaddingV,
    ),
    shape: RoundedRectangleBorder(borderRadius: DSRadius.borderMD),
    elevation: 0,
    textStyle: DSTypography.button,
  );
}
