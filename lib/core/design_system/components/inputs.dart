import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/radius.dart';
import '../tokens/typography.dart';

/// Design System Inputs - أنماط حقول الإدخال
///
/// تعريفات حقول الإدخال الموحدة في التطبيق

class DSInputStyles {
  DSInputStyles._();

  // ============================================================================
  // Default Input Decoration
  // ============================================================================

  static InputDecoration standard({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    labelStyle: DSTypography.labelMedium,
    hintStyle: DSTypography.bodyMedium.copyWith(color: DSColors.textHint),
    filled: true,
    fillColor: DSColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: DSSpacing.md,
      vertical: DSSpacing.md,
    ),
    border: OutlineInputBorder(
      borderRadius: DSRadius.borderMD,
      borderSide: const BorderSide(color: DSColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: DSRadius.borderMD,
      borderSide: const BorderSide(color: DSColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: DSRadius.borderMD,
      borderSide: const BorderSide(color: DSColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: DSRadius.borderMD,
      borderSide: const BorderSide(color: DSColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: DSRadius.borderMD,
      borderSide: const BorderSide(color: DSColors.error, width: 2),
    ),
  );

  // ============================================================================
  // Filled Input - حقل ممتلئ
  // ============================================================================

  static InputDecoration filled({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    labelStyle: DSTypography.labelMedium,
    hintStyle: DSTypography.bodyMedium.copyWith(color: DSColors.textHint),
    filled: true,
    fillColor: DSColors.slate100,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: DSSpacing.md,
      vertical: DSSpacing.md,
    ),
    border: OutlineInputBorder(
      borderRadius: DSRadius.borderMD,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: DSRadius.borderMD,
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: DSRadius.borderMD,
      borderSide: const BorderSide(color: DSColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: DSRadius.borderMD,
      borderSide: const BorderSide(color: DSColors.error),
    ),
  );

  // ============================================================================
  // Search Input - حقل البحث
  // ============================================================================

  static InputDecoration search({String? hintText, Widget? suffixIcon}) =>
      InputDecoration(
        hintText: hintText ?? 'بحث...',
        prefixIcon: const Icon(Icons.search, color: DSColors.textHint),
        suffixIcon: suffixIcon,
        hintStyle: DSTypography.bodyMedium.copyWith(color: DSColors.textHint),
        filled: true,
        fillColor: DSColors.slate100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DSSpacing.md,
          vertical: DSSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: DSRadius.full,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DSRadius.full,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DSRadius.full,
          borderSide: const BorderSide(color: DSColors.primary),
        ),
      );

  // ============================================================================
  // Underline Input - حقل بخط سفلي
  // ============================================================================

  static InputDecoration underline({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    labelStyle: DSTypography.labelMedium,
    hintStyle: DSTypography.bodyMedium.copyWith(color: DSColors.textHint),
    contentPadding: const EdgeInsets.symmetric(vertical: DSSpacing.sm),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(color: DSColors.border),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: DSColors.border),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: DSColors.primary, width: 2),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: DSColors.error),
    ),
  );
}
