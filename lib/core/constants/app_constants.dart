import 'package:flutter/material.dart';

/// ثوابت التطبيق - الألوان والأبعاد والإعدادات الأساسية
class AppConstants {
  // منع إنشاء كائن من هذه الفئة
  AppConstants._();

  // ========================
  //   ألوان Smiley Cart
  // ========================

  /// لون أزرق Meta AI
  static const Color metaBlue = Color(0xFF1877F2);

  /// لون بنفسجي Meta AI
  static const Color metaIndigo = Color(0xFF6366F1);

  /// لون وردي Meta AI
  static const Color metaPink = Color(0xFFEC4899);

  /// لون بنفسجي فاتح
  static const Color metaViolet = Color(0xFF8B5CF6);

  /// لون بنفسجي فاتح إضافي
  static const Color metaPurple = Color(0xFFA855F7);

  // ========================
  //   تدرجات الألوان
  // ========================

  /// تدرج دائري للشعار الرئيسي (Meta AI Style)
  static const SweepGradient logoSweepGradient = SweepGradient(
    startAngle: 0.0,
    endAngle: 3.14 * 2,
    colors: [metaBlue, metaIndigo, metaPink, metaBlue],
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  /// تدرج خطي للشعار (135 درجة)
  static const LinearGradient logoLinearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(135 * 3.14159 / 180), // 135 degrees in radians
    colors: [metaBlue, metaIndigo, metaPink],
    stops: [0.0, 0.5, 1.0],
  );

  /// تدرج خفيف للخلفية
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [metaViolet, metaPurple],
    stops: [0.0, 1.0],
  );

  // ========================
  //   الأبعاد والمقاسات
  // ========================

  /// سمك الخط الافتراضي للأيقونة
  static const double defaultStrokeWidth = 2.5;

  /// سمك الخط للأيقونات الصغيرة (24px)
  static const double smallStrokeWidth = 2.0;

  /// سمك الخط للأيقونات الكبيرة (128px+)
  static const double largeStrokeWidth = 3.5;

  /// حجم الأيقونة الافتراضي
  static const double defaultIconSize = 40.0;

  /// حجم الأيقونة الصغيرة (Navigation Bar)
  static const double smallIconSize = 28.0;

  /// حجم الشعار الكبير (Splash Screen)
  static const double largeLogoSize = 200.0;

  /// نصف قطر الدائرة الخارجية (نسبة من الحجم الكلي)
  static const double outerCircleRadiusRatio = 0.45;

  /// نسبة حجم السلة من الدائرة (60% من الارتفاع)
  static const double basketSizeRatio = 0.6;

  /// نسبة القطع السفلي من الدائرة (للابتسامة)
  static const double smileCutoutRatio = 0.15;

  // ========================
  //   إعدادات الرسوم المتحركة
  // ========================

  /// مدة الرسوم المتحركة الافتراضية
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  /// مدة رسوم متحركة bounce (Splash Screen)
  static const Duration bounceAnimationDuration = Duration(milliseconds: 800);

  /// مدة عرض Splash Screen
  static const Duration splashScreenDuration = Duration(milliseconds: 2500);

  /// منحنى الرسوم المتحركة الناعم
  static const Curve smoothCurve = Curves.easeInOutCubic;

  /// منحنى Bounce
  static const Curve bounceCurve = Curves.elasticOut;

  // ========================
  //   إعدادات الظل
  // ========================

  /// شفافية الظل
  static const double shadowOpacity = 0.2;

  /// نصف قطر تمويه الظل
  static const double shadowBlurRadius = 8.0;

  /// إزاحة الظل (X)
  static const double shadowOffsetX = 0.0;

  /// إزاحة الظل (Y)
  static const double shadowOffsetY = 4.0;

  // ========================
  //   دوال مساعدة
  // ========================

  /// حساب سمك الخط بناءً على حجم الأيقونة
  static double getStrokeWidth(double size) {
    if (size < 30) return smallStrokeWidth;
    if (size > 100) return largeStrokeWidth;
    return defaultStrokeWidth;
  }

  /// الحصول على لون الخط بناءً على السمة (فاتح/داكن)
  static Color getLineColor(BuildContext context, {bool isActive = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isActive) {
      return isDark ? Colors.white : metaIndigo;
    }
    return isDark ? Colors.white70 : Colors.black54;
  }

  /// الحصول على التدرج بناءً على الحالة النشطة
  static Gradient? getGradient(bool isActive) {
    return isActive ? logoSweepGradient : null;
  }
}
