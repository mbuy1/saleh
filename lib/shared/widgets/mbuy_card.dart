import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';

/// أنواع البطاقات المتاحة
enum MbuyCardType { flat, elevated, gradient }

/// مكون بطاقة موحد لتطبيق MBUY
/// يوفر تصميم متسق لجميع البطاقات في التطبيق مع micro-interactions
class MbuyCard extends StatefulWidget {
  final Widget child;
  final MbuyCardType type;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? color;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final Border? border;

  const MbuyCard({
    super.key,
    required this.child,
    this.type = MbuyCardType.elevated,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.color,
    this.gradient,
    this.onTap,
    this.border,
  });

  /// بطاقة مسطحة (Flat)
  const MbuyCard.flat({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.onTap,
    this.border,
  }) : type = MbuyCardType.flat,
       elevation = 0,
       gradient = null;

  /// بطاقة مرفوعة (Elevated)
  const MbuyCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.color,
    this.onTap,
    this.border,
  }) : type = MbuyCardType.elevated,
       gradient = null;

  /// بطاقة بتدرج لوني (Gradient)
  const MbuyCard.gradient({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.gradient,
    this.onTap,
    this.border,
  }) : type = MbuyCardType.gradient,
       color = null;

  @override
  State<MbuyCard> createState() => _MbuyCardState();
}

class _MbuyCardState extends State<MbuyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        widget.borderRadius ?? AppDimensions.borderRadiusL;
    final effectivePadding =
        widget.padding ?? const EdgeInsets.all(AppDimensions.spacing16);
    final effectiveElevation = widget.elevation ?? _getDefaultElevation();

    Widget cardContent = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: widget.type == MbuyCardType.gradient
            ? null
            : (widget.color ?? AppTheme.surfaceColor),
        gradient: widget.type == MbuyCardType.gradient
            ? (widget.gradient ?? AppTheme.cardGradient)
            : null,
        borderRadius: effectiveBorderRadius,
        border:
            widget.border ?? Border.all(color: AppTheme.borderColor, width: 1),
        boxShadow: effectiveElevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: effectiveElevation * 2,
                  offset: Offset(0, effectiveElevation / 2),
                ),
              ]
            : null,
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      cardContent = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            borderRadius: effectiveBorderRadius,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: effectiveBorderRadius,
              child: Semantics(button: true, child: cardContent),
            ),
          ),
        ),
      );
    }

    if (widget.margin != null) {
      return Padding(padding: widget.margin!, child: cardContent);
    }

    return cardContent;
  }

  double _getDefaultElevation() {
    switch (widget.type) {
      case MbuyCardType.flat:
        return 0;
      case MbuyCardType.elevated:
        return AppDimensions.cardElevationMedium;
      case MbuyCardType.gradient:
        return AppDimensions.cardElevationLow;
    }
  }
}
