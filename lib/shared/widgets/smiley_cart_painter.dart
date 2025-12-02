import 'package:flutter/material.dart';
import 'dart:math' as math;

/// رسام مخصص لأيقونة Smiley Cart
/// يرسم دائرة خارجية مع تدرج ملون، سلة تسوق، عيون، وابتسامة
class SmileyCartPainter extends CustomPainter {
  /// لون الخطوط
  final Color lineColor;

  /// التدرج للدائرة الخارجية (اختياري)
  final Gradient? gradient;

  /// سمك الخط
  final double strokeWidth;

  /// هل يتم رسم الظل
  final bool drawShadow;

  SmileyCartPainter({
    required this.lineColor,
    this.gradient,
    required this.strokeWidth,
    this.drawShadow = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ========================
    // الدائرة الخارجية مع التدرج
    // ========================
    _drawOuterCircle(canvas, center, radius);

    // ========================
    // سلة التسوق
    // ========================
    _drawShoppingCart(canvas, center, radius);

    // ========================
    // العيون (العجلات)
    // ========================
    _drawEyes(canvas, center, radius);

    // ========================
    // الابتسامة
    // ========================
    _drawSmile(canvas, center, radius);
  }

  /// رسم الدائرة الخارجية (مفتوحة من الأسفل)
  void _drawOuterCircle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // تطبيق التدرج إذا كان موجوداً
    if (gradient != null) {
      final rect = Rect.fromCircle(center: center, radius: radius * 0.85);
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = lineColor;
    }

    // رسم قوس من 210 درجة إلى 330 درجة (فتحة في الأسفل للابتسامة)
    final arcRect = Rect.fromCircle(center: center, radius: radius * 0.85);
    const startAngle = -150 * math.pi / 180; // 210 degrees
    const sweepAngle = 300 * math.pi / 180; // 300 degrees arc

    canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);
  }

  /// رسم سلة التسوق
  void _drawShoppingCart(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // حساب أبعاد السلة
    final cartWidth = radius * 0.6;
    final cartHeight = radius * 0.4;
    final cartTop = center.dy - radius * 0.25;
    final cartLeft = center.dx - cartWidth / 2;

    final path = Path();

    // المقبض
    path.moveTo(cartLeft + cartWidth * 0.15, cartTop - radius * 0.1);
    path.lineTo(cartLeft + cartWidth * 0.25, cartTop);

    // الجزء العلوي من السلة
    path.lineTo(cartLeft + cartWidth * 0.85, cartTop);

    // الجانب الأيمن المنحني
    path.lineTo(cartLeft + cartWidth * 0.75, cartTop + cartHeight);

    // القاعدة
    path.lineTo(cartLeft + cartWidth * 0.25, cartTop + cartHeight);

    // الجانب الأيسر
    path.lineTo(cartLeft + cartWidth * 0.25, cartTop);

    canvas.drawPath(path, paint);

    // رسم خطوط السلة (التفاصيل الشبكية)
    final slotCount = 4;
    for (int i = 1; i < slotCount; i++) {
      final x = cartLeft + cartWidth * 0.25 + (cartWidth * 0.5 * i / slotCount);
      final slotPath = Path()
        ..moveTo(x, cartTop + radius * 0.05)
        ..lineTo(x, cartTop + cartHeight - radius * 0.05);
      canvas.drawPath(slotPath, paint);
    }
  }

  /// رسم العيون (العجلات)
  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final wheelRadius = radius * 0.06;
    final wheelY = center.dy + radius * 0.15;
    final wheelSpacing = radius * 0.25;

    // العجلة اليسرى (العين اليسرى)
    canvas.drawCircle(
      Offset(center.dx - wheelSpacing, wheelY),
      wheelRadius,
      paint,
    );

    // العجلة اليمنى (العين اليمنى)
    canvas.drawCircle(
      Offset(center.dx + wheelSpacing, wheelY),
      wheelRadius,
      paint,
    );
  }

  /// رسم الابتسامة
  void _drawSmile(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.9
      ..strokeCap = StrokeCap.round;

    // رسم قوس الابتسامة أسفل العجلات
    final smileRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.35),
      width: radius * 1.0,
      height: radius * 0.6,
    );

    const startAngle = math.pi; // 180 degrees (left)
    const sweepAngle = math.pi; // 180 degrees sweep (smile arc)

    canvas.drawArc(smileRect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant SmileyCartPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.gradient != gradient ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.drawShadow != drawShadow;
  }
}
