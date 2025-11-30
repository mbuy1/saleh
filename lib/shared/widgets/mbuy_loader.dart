import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Widget للـ Loading Indicator باستخدام شعار Mbuy
/// 
/// يعرض:
/// - دائرة جراديانت دوارة (الحد الخارجي)
/// - السلة المبتسمة ثابتة في المنتصف
/// 
/// الاستخدام:
/// ```dart
/// MbuyLoader()
/// ```
class MbuyLoader extends StatefulWidget {
  final double size;

  const MbuyLoader({
    super.key,
    this.size = 60,
  });

  @override
  State<MbuyLoader> createState() => _MbuyLoaderState();
}

class _MbuyLoaderState extends State<MbuyLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // دائرة الجراديانت الدوارة
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CustomPaint(
                    painter: _RotatingGradientCirclePainter(
                      strokeWidth: widget.size * 0.1,
                      gradient: MbuyColors.circularGradient,
                    ),
                  ),
                ),
              );
            },
          ),
          // السلة المبتسمة الثابتة
          _buildSmileCart(widget.size * 0.5),
        ],
      ),
    );
  }

  Widget _buildSmileCart(double iconSize) {
    // استخدام نفس تصميم السلة المبتسمة المحسّن من MbuyLogo
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

/// Painter لرسم دائرة بحد جراديانت (للاستخدام في الـ Loader)
class _RotatingGradientCirclePainter extends CustomPainter {
  final double strokeWidth;
  final SweepGradient gradient;

  _RotatingGradientCirclePainter({
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final shader = gradient.createShader(rect);
    paint.shader = shader;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_RotatingGradientCirclePainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradient != gradient;
  }
}

