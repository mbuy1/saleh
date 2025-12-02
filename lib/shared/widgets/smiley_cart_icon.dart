import 'package:flutter/material.dart';
import 'smiley_cart_painter.dart';
import '../../core/constants/app_constants.dart';

/// أيقونة Smiley Cart بسيطة وقابلة لإعادة الاستخدام
/// تستخدم في أي مكان يحتاج عرض الأيقونة
class SmileyCartIcon extends StatelessWidget {
  /// حجم الأيقونة
  final double size;

  /// هل الأيقونة نشطة (ملونة بالتدرج)
  final bool isActive;

  /// لون مخصص للخطوط (اختياري)
  final Color? customLineColor;

  const SmileyCartIcon({
    super.key,
    this.size = AppConstants.defaultIconSize,
    this.isActive = false,
    this.customLineColor,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد اللون بناءً على الحالة والسمة
    final lineColor =
        customLineColor ??
        AppConstants.getLineColor(context, isActive: isActive);

    // التدرج فقط إذا كانت الأيقونة نشطة
    final gradient = isActive ? AppConstants.logoSweepGradient : null;

    // سمك الخط المناسب للحجم
    final strokeWidth = AppConstants.getStrokeWidth(size);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: SmileyCartPainter(
          lineColor: lineColor,
          gradient: gradient,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
