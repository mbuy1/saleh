import 'package:flutter/material.dart';

/// Design System Animations - الحركات
///
/// إعدادات الحركات والانتقالات الموحدة

class DSAnimations {
  DSAnimations._();

  // ============================================================================
  // Duration - مدة الحركة
  // ============================================================================

  /// سريع جداً - 100ms
  static const Duration instant = Duration(milliseconds: 100);

  /// سريع - 150ms
  static const Duration fast = Duration(milliseconds: 150);

  /// عادي - 200ms
  static const Duration normal = Duration(milliseconds: 200);

  /// متوسط - 300ms
  static const Duration medium = Duration(milliseconds: 300);

  /// بطيء - 400ms
  static const Duration slow = Duration(milliseconds: 400);

  /// بطيء جداً - 500ms
  static const Duration slower = Duration(milliseconds: 500);

  // ============================================================================
  // Curves - منحنيات الحركة
  // ============================================================================

  /// انتقال سلس عادي
  static const Curve defaultCurve = Curves.easeInOut;

  /// انتقال سريع للخارج
  static const Curve easeOut = Curves.easeOut;

  /// انتقال سريع للداخل
  static const Curve easeIn = Curves.easeIn;

  /// انتقال نابض
  static const Curve bounce = Curves.bounceOut;

  /// انتقال مرن
  static const Curve elastic = Curves.elasticOut;

  /// انتقال خطي
  static const Curve linear = Curves.linear;

  /// انتقال تسارعي
  static const Curve decelerate = Curves.decelerate;

  // ============================================================================
  // Page Transition Duration
  // ============================================================================

  /// انتقال الصفحات
  static const Duration pageTransition = Duration(milliseconds: 300);

  /// انتقال الـ Bottom Sheet
  static const Duration bottomSheet = Duration(milliseconds: 250);

  /// انتقال الـ Dialog
  static const Duration dialog = Duration(milliseconds: 200);
}
