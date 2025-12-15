import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';

/// أنواع الأزرار المتاحة
enum MbuyButtonType { primary, secondary, outline, text, gradient }

/// حجم الزر
enum MbuyButtonSize { small, medium, large }

/// مكون زر موحد لتطبيق MBUY
/// يوفر تصميم متسق لجميع الأزرار في التطبيق مع micro-interactions
class MbuyButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final MbuyButtonType type;
  final MbuyButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Color? customColor;
  final Color? customTextColor;

  const MbuyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = MbuyButtonType.primary,
    this.size = MbuyButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.customColor,
    this.customTextColor,
  });

  /// زر أولي (Primary)
  const MbuyButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = MbuyButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : type = MbuyButtonType.primary,
       customColor = null,
       customTextColor = null;

  /// زر ثانوي (Secondary)
  const MbuyButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = MbuyButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : type = MbuyButtonType.secondary,
       customColor = null,
       customTextColor = null;

  /// زر محدد (Outline)
  const MbuyButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = MbuyButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : type = MbuyButtonType.outline,
       customColor = null,
       customTextColor = null;

  /// زر نصي (Text)
  const MbuyButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = MbuyButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : type = MbuyButtonType.text,
       customColor = null,
       customTextColor = null;

  /// زر بتدرج لوني (Gradient)
  const MbuyButton.gradient({
    super.key,
    required this.text,
    this.onPressed,
    this.size = MbuyButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : type = MbuyButtonType.gradient,
       customColor = null,
       customTextColor = null;

  @override
  State<MbuyButton> createState() => _MbuyButtonState();
}

class _MbuyButtonState extends State<MbuyButton>
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
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
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
    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: widget.text,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox(
            width: widget.fullWidth ? double.infinity : null,
            height: _getHeight(),
            child: widget.type == MbuyButtonType.gradient
                ? _buildGradientButton(isDisabled)
                : _buildMaterialButton(context, isDisabled),
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialButton(BuildContext context, bool isDisabled) {
    switch (widget.type) {
      case MbuyButtonType.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.customColor ?? AppTheme.primaryColor,
            foregroundColor: widget.customTextColor ?? Colors.white,
            disabledBackgroundColor: AppTheme.primaryColor.withValues(
              alpha: 0.5,
            ),
            elevation: AppDimensions.cardElevationMedium,
            padding: _getPadding(),
            shape: RoundedRectangleBorder(borderRadius: _getBorderRadius()),
          ),
          child: _buildContent(widget.customTextColor ?? Colors.white),
        );

      case MbuyButtonType.secondary:
        return ElevatedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.customColor ?? AppTheme.secondaryColor,
            foregroundColor: widget.customTextColor ?? Colors.white,
            disabledBackgroundColor: AppTheme.secondaryColor.withValues(
              alpha: 0.5,
            ),
            elevation: AppDimensions.cardElevationMedium,
            padding: _getPadding(),
            shape: RoundedRectangleBorder(borderRadius: _getBorderRadius()),
          ),
          child: _buildContent(widget.customTextColor ?? Colors.white),
        );

      case MbuyButtonType.outline:
        return OutlinedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.customColor ?? AppTheme.primaryColor,
            side: BorderSide(
              color: isDisabled
                  ? AppTheme.primaryColor.withValues(alpha: 0.3)
                  : widget.customColor ?? AppTheme.primaryColor,
              width: 1.5,
            ),
            padding: _getPadding(),
            shape: RoundedRectangleBorder(borderRadius: _getBorderRadius()),
          ),
          child: _buildContent(widget.customColor ?? AppTheme.primaryColor),
        );

      case MbuyButtonType.text:
        return TextButton(
          onPressed: isDisabled ? null : widget.onPressed,
          style: TextButton.styleFrom(
            foregroundColor: widget.customColor ?? AppTheme.primaryColor,
            padding: _getPadding(),
            shape: RoundedRectangleBorder(borderRadius: _getBorderRadius()),
          ),
          child: _buildContent(widget.customColor ?? AppTheme.primaryColor),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGradientButton(bool isDisabled) {
    return Material(
      elevation: isDisabled ? 0 : AppDimensions.cardElevationMedium,
      borderRadius: _getBorderRadius(),
      child: Ink(
        decoration: BoxDecoration(
          gradient: isDisabled
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.5),
                    AppTheme.primaryLight.withValues(alpha: 0.5),
                  ],
                )
              : AppTheme.primaryGradient,
          borderRadius: _getBorderRadius(),
        ),
        child: InkWell(
          onTap: isDisabled ? null : widget.onPressed,
          borderRadius: _getBorderRadius(),
          child: Container(
            padding: _getPadding(),
            alignment: Alignment.center,
            child: _buildContent(Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (widget.isLoading) {
      return SizedBox(
        width: _getLoadingSize(),
        height: _getLoadingSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: _getIconSize(), color: textColor),
          SizedBox(width: AppDimensions.spacing8),
          Text(
            widget.text,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.text,
      style: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  double _getHeight() {
    switch (widget.size) {
      case MbuyButtonSize.small:
        return AppDimensions.buttonHeightS;
      case MbuyButtonSize.medium:
        return AppDimensions.buttonHeightM;
      case MbuyButtonSize.large:
        return AppDimensions.buttonHeightL;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case MbuyButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacing6,
        );
      case MbuyButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing10,
        );
      case MbuyButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24,
          vertical: AppDimensions.spacing12,
        );
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.size) {
      case MbuyButtonSize.small:
        return AppDimensions.borderRadiusS;
      case MbuyButtonSize.medium:
        return AppDimensions.borderRadiusM;
      case MbuyButtonSize.large:
        return AppDimensions.borderRadiusL;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case MbuyButtonSize.small:
        return 12;
      case MbuyButtonSize.medium:
        return 14;
      case MbuyButtonSize.large:
        return 16;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case MbuyButtonSize.small:
        return AppDimensions.iconS;
      case MbuyButtonSize.medium:
        return AppDimensions.iconM;
      case MbuyButtonSize.large:
        return AppDimensions.iconL;
    }
  }

  double _getLoadingSize() {
    switch (widget.size) {
      case MbuyButtonSize.small:
        return 16;
      case MbuyButtonSize.medium:
        return 20;
      case MbuyButtonSize.large:
        return 24;
    }
  }
}
