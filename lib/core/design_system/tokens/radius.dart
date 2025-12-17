import 'package:flutter/material.dart';

/// Design System Radius - انحناءات الزوايا
///
/// قيم انحناء الزوايا الموحدة في التطبيق

class DSRadius {
  DSRadius._();

  // ============================================================================
  // Radius Values - قيم الانحناء
  // ============================================================================

  /// 4px - زوايا صغيرة جداً
  static const double xs = 4.0;

  /// 8px - زوايا صغيرة
  static const double sm = 8.0;

  /// 12px - زوايا متوسطة
  static const double md = 12.0;

  /// 16px - زوايا كبيرة
  static const double lg = 16.0;

  /// 20px - زوايا كبيرة جداً
  static const double xl = 20.0;

  /// 24px - زوايا ضخمة
  static const double xxl = 24.0;

  /// 100px - دائرية
  static const double circle = 100.0;

  // ============================================================================
  // BorderRadius Presets - إعدادات جاهزة
  // ============================================================================

  /// بدون انحناء
  static BorderRadius get none => BorderRadius.zero;

  /// انحناء صغير جداً
  static BorderRadius get borderXS => BorderRadius.circular(xs);

  /// انحناء صغير
  static BorderRadius get borderSM => BorderRadius.circular(sm);

  /// انحناء متوسط
  static BorderRadius get borderMD => BorderRadius.circular(md);

  /// انحناء كبير
  static BorderRadius get borderLG => BorderRadius.circular(lg);

  /// انحناء كبير جداً
  static BorderRadius get borderXL => BorderRadius.circular(xl);

  /// انحناء ضخم
  static BorderRadius get borderXXL => BorderRadius.circular(xxl);

  /// دائري كامل
  static BorderRadius get full => BorderRadius.circular(circle);

  // ============================================================================
  // Special Radius - انحناءات خاصة
  // ============================================================================

  /// انحناء علوي فقط (للـ Bottom Sheets)
  static BorderRadius get topMD =>
      const BorderRadius.vertical(top: Radius.circular(md));

  static BorderRadius get topLG =>
      const BorderRadius.vertical(top: Radius.circular(lg));

  static BorderRadius get topXL =>
      const BorderRadius.vertical(top: Radius.circular(xl));

  /// انحناء سفلي فقط
  static BorderRadius get bottomMD =>
      const BorderRadius.vertical(bottom: Radius.circular(md));
}
