import 'package:flutter/material.dart';
import 'smiley_cart_painter.dart';
import '../../core/constants/app_constants.dart';

/// أيقونة Smiley Cart متحركة - تتحول بين الحالة العادية والنشطة
/// مثالية للاستخدام في BottomNavigationBar
class AnimatedSmileyCartIcon extends StatefulWidget {
  /// حجم الأيقونة
  final double size;

  /// هل الأيقونة نشطة
  final bool isActive;

  /// دالة يتم استدعاؤها عند النقر
  final VoidCallback? onTap;

  const AnimatedSmileyCartIcon({
    super.key,
    this.size = AppConstants.smallIconSize,
    this.isActive = false,
    this.onTap,
  });

  @override
  State<AnimatedSmileyCartIcon> createState() => _AnimatedSmileyCartIconState();
}

class _AnimatedSmileyCartIconState extends State<AnimatedSmileyCartIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.defaultAnimationDuration,
    );

    _colorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppConstants.smoothCurve),
    );

    // بدء الرسوم المتحركة إذا كانت الأيقونة نشطة
    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedSmileyCartIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    // تحديث الرسوم المتحركة عند تغيير الحالة
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            final lineColor = ColorTween(
              begin: AppConstants.getLineColor(context, isActive: false),
              end: AppConstants.getLineColor(context, isActive: true),
            ).evaluate(_colorAnimation)!;

            final gradient = widget.isActive
                ? AppConstants.logoSweepGradient
                : null;

            return CustomPaint(
              painter: SmileyCartPainter(
                lineColor: lineColor,
                gradient: gradient,
                strokeWidth: AppConstants.getStrokeWidth(widget.size),
              ),
            );
          },
        ),
      ),
    );
  }
}
