import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/radius.dart';
import '../tokens/shadows.dart';

/// Design System Cards - أنماط البطاقات
///
/// تعريفات البطاقات الموحدة في التطبيق

class DSCardStyles {
  DSCardStyles._();

  // ============================================================================
  // Default Card - بطاقة افتراضية
  // ============================================================================

  static BoxDecoration get defaultCard => BoxDecoration(
    color: DSColors.card,
    borderRadius: DSRadius.borderMD,
    boxShadow: DSShadows.card,
  );

  // ============================================================================
  // Elevated Card - بطاقة مرتفعة
  // ============================================================================

  static BoxDecoration get elevated => BoxDecoration(
    color: DSColors.card,
    borderRadius: DSRadius.borderMD,
    boxShadow: DSShadows.md,
  );

  // ============================================================================
  // Outlined Card - بطاقة محددة
  // ============================================================================

  static BoxDecoration get outlined => BoxDecoration(
    color: DSColors.card,
    borderRadius: DSRadius.borderMD,
    border: Border.all(color: DSColors.border),
  );

  // ============================================================================
  // Flat Card - بطاقة مسطحة
  // ============================================================================

  static BoxDecoration get flat =>
      BoxDecoration(color: DSColors.card, borderRadius: DSRadius.borderMD);

  // ============================================================================
  // Gradient Card - بطاقة متدرجة
  // ============================================================================

  static BoxDecoration primaryGradient() => BoxDecoration(
    borderRadius: DSRadius.borderMD,
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [DSColors.primary, DSColors.primaryDark],
    ),
    boxShadow: DSShadows.colored(DSColors.primary),
  );

  static BoxDecoration accentGradient() => BoxDecoration(
    borderRadius: DSRadius.borderMD,
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [DSColors.accent, DSColors.accentDark],
    ),
    boxShadow: DSShadows.colored(DSColors.accent),
  );

  // ============================================================================
  // Interactive Card - بطاقة تفاعلية
  // ============================================================================

  static BoxDecoration interactive({bool isPressed = false}) => BoxDecoration(
    color: isPressed ? DSColors.slate100 : DSColors.card,
    borderRadius: DSRadius.borderMD,
    boxShadow: isPressed ? DSShadows.xs : DSShadows.card,
    border: Border.all(
      color: isPressed
          ? DSColors.primary.withValues(alpha: 0.3)
          : DSColors.border,
    ),
  );

  // ============================================================================
  // Card Padding Presets
  // ============================================================================

  static EdgeInsets get paddingSM => const EdgeInsets.all(DSSpacing.sm);
  static EdgeInsets get paddingMD => const EdgeInsets.all(DSSpacing.md);
  static EdgeInsets get paddingLG => const EdgeInsets.all(DSSpacing.lg);
}
