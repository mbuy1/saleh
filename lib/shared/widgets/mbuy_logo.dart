import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// شعار MBuy الرسمي - أيقونة عربة التسوق مع الوجه المبتسم
class MbuyLogo extends StatelessWidget {
  final double size;
  final bool showBackground;

  const MbuyLogo({
    super.key,
    this.size = 60,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: MbuyLogoPainter(showBackground: showBackground),
    );
  }
}

class MbuyLogoPainter extends CustomPainter {
  final bool showBackground;

  MbuyLogoPainter({this.showBackground = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle with gradient (optional)
    if (showBackground) {
      final backgroundPaint = Paint()
        ..shader = ui.Gradient.radial(
          center,
          radius,
          [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
          [0.0, 1.0],
        );
      canvas.drawCircle(center, radius, backgroundPaint);
    }

    // Outer circle with gradient (blue to magenta)
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = ui.Gradient.sweep(
        center,
        [
          const Color(0xFF4A90E2), // Blue
          const Color(0xFFE91E63), // Magenta/Pink
        ],
        [0.0, 1.0],
      );

    canvas.drawCircle(center, radius - 2, circlePaint);

    // Shopping Cart
    final cartPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = ui.Gradient.linear(
        Offset(center.dx - radius * 0.3, center.dy - radius * 0.2),
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.2),
        [
          const Color(0xFF4A90E2),
          const Color(0xFFE91E63),
        ],
      );

    // Cart handle
    final handlePath = Path()
      ..moveTo(center.dx - radius * 0.25, center.dy - radius * 0.15)
      ..lineTo(center.dx - radius * 0.35, center.dy - radius * 0.3);
    canvas.drawPath(handlePath, cartPaint);

    // Cart basket
    final basketPath = Path()
      ..moveTo(center.dx - radius * 0.35, center.dy - radius * 0.3)
      ..lineTo(center.dx - radius * 0.35, center.dy + radius * 0.1)
      ..lineTo(center.dx + radius * 0.35, center.dy + radius * 0.1)
      ..lineTo(center.dx + radius * 0.35, center.dy - radius * 0.3)
      ..lineTo(center.dx - radius * 0.25, center.dy - radius * 0.15);

    canvas.drawPath(basketPath, cartPaint);

    // Basket lines (items)
    for (int i = 0; i < 4; i++) {
      final x = center.dx - radius * 0.25 + (i * radius * 0.15);
      canvas.drawLine(
        Offset(x, center.dy - radius * 0.2),
        Offset(x, center.dy + radius * 0.05),
        cartPaint,
      );
    }

    // Smiley Face
    final facePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        Offset(center.dx - radius * 0.2, center.dy + radius * 0.2),
        Offset(center.dx + radius * 0.2, center.dy + radius * 0.2),
        [
          const Color(0xFF4A90E2),
          const Color(0xFFE91E63),
        ],
      );

    // Eyes (two circles)
    final eyeRadius = radius * 0.08;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.15, center.dy + radius * 0.25),
      eyeRadius,
      facePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.15, center.dy + radius * 0.25),
      eyeRadius,
      facePaint,
    );

    // Smile (arc)
    final smilePath = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + radius * 0.35),
          width: radius * 0.5,
          height: radius * 0.3,
        ),
        -0.3,
        2.6,
      );
    canvas.drawPath(smilePath, facePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
