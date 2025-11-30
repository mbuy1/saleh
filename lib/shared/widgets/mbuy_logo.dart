import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Widget للشعار الدائري Mbuy
/// 
/// يحتوي على:
/// - دائرة بحد جراديانت (من الأزرق إلى الموف)
/// - سلة مبتسمة داخل الدائرة
/// 
/// Variants:
/// - MbuyLogo.large() - للشاشات الكبيرة (Splash, Welcome)
/// - MbuyLogo.small() - للاستخدام في AppBar أو كأيقونة صغيرة
class MbuyLogo extends StatelessWidget {
  final double size;
  final bool showBackground;

  const MbuyLogo({
    super.key,
    required this.size,
    this.showBackground = false,
  });

  /// نسخة كبيرة للشاشات الكبيرة (Splash, Welcome)
  factory MbuyLogo.large({bool showBackground = false}) {
    return MbuyLogo(size: 120, showBackground: showBackground);
  }

  /// نسخة صغيرة للاستخدام في AppBar أو كأيقونة
  factory MbuyLogo.small({bool showBackground = false}) {
    return MbuyLogo(size: 40, showBackground: showBackground);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showBackground
          ? BoxDecoration(
              color: MbuyColors.surfaceLight,
              shape: BoxShape.circle,
            )
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // نصف دائرة مفتوحة من الأسفل بجراديانت
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _HalfCirclePainter(
                strokeWidth: size * 0.08,
                gradient: MbuyColors.circularGradient,
              ),
            ),
          ),
          // السلة المبتسمة في المنتصف
          _buildSmileCart(size * 0.6),
        ],
      ),
    );
  }

  Widget _buildSmileCart(double iconSize) {
    // سلة مبتسمة واضحة - تصميم محسّن مع خلفية جراديانت
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: MbuyColors.primaryGradient,
      ),
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // السلة (الجزء العلوي)
            Positioned(
              top: iconSize * 0.2,
              child: Container(
                width: iconSize * 0.55,
                height: iconSize * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(iconSize * 0.12),
                    topRight: Radius.circular(iconSize * 0.12),
                    bottomLeft: Radius.circular(iconSize * 0.06),
                    bottomRight: Radius.circular(iconSize * 0.06),
                  ),
                ),
                child: Stack(
                  children: [
                    // خطوط داخل السلة
                    Positioned(
                      left: iconSize * 0.1,
                      top: iconSize * 0.06,
                      child: Container(
                        width: 2.5,
                        height: iconSize * 0.18,
                        color: MbuyColors.primaryBlue.withValues(alpha: 0.4),
                      ),
                    ),
                    Positioned(
                      right: iconSize * 0.1,
                      top: iconSize * 0.06,
                      child: Container(
                        width: 2.5,
                        height: iconSize * 0.18,
                        color: MbuyColors.primaryPurple.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // العيون (دائرتان صغيرتان - أوضح)
            Positioned(
              top: iconSize * 0.32,
              left: iconSize * 0.22,
              child: Container(
                width: iconSize * 0.1,
                height: iconSize * 0.1,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: iconSize * 0.32,
              right: iconSize * 0.22,
              child: Container(
                width: iconSize * 0.1,
                height: iconSize * 0.1,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // الفم المبتسم (قوس - أوضح)
            Positioned(
              bottom: iconSize * 0.25,
              child: CustomPaint(
                size: Size(iconSize * 0.5, iconSize * 0.25),
                painter: _SmilePainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter لرسم نصف دائرة مفتوحة من الأسفل بجراديانت
class _HalfCirclePainter extends CustomPainter {
  final double strokeWidth;
  final SweepGradient gradient;

  _HalfCirclePainter({
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // إنشاء شادر للجراديانت
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final shader = gradient.createShader(rect);
    paint.shader = shader;

    // رسم نصف دائرة مفتوحة من الأسفل (من -90 درجة إلى 90 درجة)
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // قوس من الأعلى (من 180 درجة إلى 0 درجة)
    final startAngle = 3.14159; // 180 درجة (أعلى)
    final sweepAngle = -3.14159; // -180 درجة (نصف دائرة)
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_HalfCirclePainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradient != gradient;
  }
}

/// Painter لرسم الفم المبتسم
class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.8,
      size.width,
      size.height * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SmilePainter oldDelegate) => false;
}

