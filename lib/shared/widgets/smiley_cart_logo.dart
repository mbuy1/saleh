import 'package:flutter/material.dart';
import 'smiley_cart_painter.dart';
import '../../core/constants/app_constants.dart';

/// شعار Smiley Cart كبير للاستخدام في Splash Screen
/// يدعم الوضع الفاتح والداكن تلقائياً
class SmileyCartLogo extends StatelessWidget {
  /// حجم الشعار
  final double size;

  /// هل يتم رسم الظل
  final bool withShadow;

  const SmileyCartLogo({
    super.key,
    this.size = AppConstants.largeLogoSize,
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // اللون يعتمد على السمة
    final lineColor = isDark ? Colors.white : AppConstants.metaIndigo;

    // سمك الخط للشعار الكبير
    final strokeWidth = AppConstants.getStrokeWidth(size);

    Widget logo = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: SmileyCartPainter(
          lineColor: lineColor,
          gradient: AppConstants.logoSweepGradient,
          strokeWidth: strokeWidth,
          drawShadow: withShadow,
        ),
      ),
    );

    // إضافة الظل إذا كان مطلوباً
    if (withShadow) {
      logo = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppConstants.metaIndigo.withValues(
                alpha: AppConstants.shadowOpacity,
              ),
              blurRadius: AppConstants.shadowBlurRadius,
              offset: const Offset(
                AppConstants.shadowOffsetX,
                AppConstants.shadowOffsetY,
              ),
            ),
          ],
        ),
        child: logo,
      );
    }

    return logo;
  }
}
