import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_dimensions.dart';
import 'app_icon.dart';

/// زر قابل للوصول مع دعم كامل للـ Accessibility
/// يتضمن:
/// - Semantic labels للقراء الشاشة
/// - Haptic feedback
/// - حالات التركيز
/// - حجم لمس مناسب (48x48 كحد أدنى)
class AccessibleButton extends StatelessWidget {
  final String label;
  final String? semanticLabel;
  final String? hint;
  final VoidCallback onPressed;
  final String? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final bool isEnabled;
  final AccessibleButtonSize size;
  final AccessibleButtonStyle style;

  const AccessibleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticLabel,
    this.hint,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = AccessibleButtonSize.medium,
    this.style = AccessibleButtonStyle.filled,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? _getBackgroundColor();
    final effectiveForegroundColor = foregroundColor ?? _getForegroundColor();
    final buttonSize = _getButtonSize();

    return Semantics(
      label: semanticLabel ?? label,
      hint: hint,
      button: true,
      enabled: isEnabled && !isLoading,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled && !isLoading
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed();
                }
              : null,
          borderRadius: BorderRadius.circular(buttonSize.borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              color: isEnabled ? effectiveBackgroundColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(buttonSize.borderRadius),
              border: style == AccessibleButtonStyle.outlined
                  ? Border.all(
                      color: isEnabled ? AppTheme.primaryColor : Colors.grey,
                      width: 1.5,
                    )
                  : null,
            ),
            child: Container(
              constraints: BoxConstraints(
                minHeight: buttonSize.minHeight,
                minWidth: buttonSize.minWidth,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: buttonSize.horizontalPadding,
                vertical: buttonSize.verticalPadding,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) ...[
                    SizedBox(
                      width: buttonSize.iconSize,
                      height: buttonSize.iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          effectiveForegroundColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (icon != null) ...[
                    AppIcon(
                      icon!,
                      size: buttonSize.iconSize,
                      color: isEnabled ? effectiveForegroundColor : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: buttonSize.fontSize,
                      fontWeight: FontWeight.w600,
                      color: isEnabled ? effectiveForegroundColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (style) {
      case AccessibleButtonStyle.filled:
        return AppTheme.primaryColor;
      case AccessibleButtonStyle.outlined:
        return Colors.transparent;
      case AccessibleButtonStyle.text:
        return Colors.transparent;
      case AccessibleButtonStyle.tonal:
        return AppTheme.primaryColor.withValues(alpha: 0.1);
    }
  }

  Color _getForegroundColor() {
    switch (style) {
      case AccessibleButtonStyle.filled:
        return Colors.white;
      case AccessibleButtonStyle.outlined:
      case AccessibleButtonStyle.text:
      case AccessibleButtonStyle.tonal:
        return AppTheme.primaryColor;
    }
  }

  _ButtonSize _getButtonSize() {
    switch (size) {
      case AccessibleButtonSize.small:
        return const _ButtonSize(
          minHeight: 36,
          minWidth: 64,
          horizontalPadding: 12,
          verticalPadding: 8,
          fontSize: 12,
          iconSize: 16,
          borderRadius: 8,
        );
      case AccessibleButtonSize.medium:
        return const _ButtonSize(
          minHeight: 48,
          minWidth: 88,
          horizontalPadding: 16,
          verticalPadding: 12,
          fontSize: 14,
          iconSize: 20,
          borderRadius: 12,
        );
      case AccessibleButtonSize.large:
        return const _ButtonSize(
          minHeight: 56,
          minWidth: 120,
          horizontalPadding: 24,
          verticalPadding: 16,
          fontSize: 16,
          iconSize: 24,
          borderRadius: 16,
        );
    }
  }
}

enum AccessibleButtonSize { small, medium, large }

enum AccessibleButtonStyle { filled, outlined, text, tonal }

class _ButtonSize {
  final double minHeight;
  final double minWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final double iconSize;
  final double borderRadius;

  const _ButtonSize({
    required this.minHeight,
    required this.minWidth,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.fontSize,
    required this.iconSize,
    required this.borderRadius,
  });
}

/// زر أيقونة قابل للوصول
class AccessibleIconButton extends StatelessWidget {
  final String icon;
  final String semanticLabel;
  final VoidCallback onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final bool isEnabled;
  final String? tooltip;

  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 24,
    this.isEnabled = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Semantics(
      label: semanticLabel,
      button: true,
      enabled: isEnabled,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed();
                }
              : null,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: AppIcon(
                icon,
                size: size,
                color: isEnabled
                    ? (color ?? AppTheme.primaryColor)
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// عنصر قائمة قابل للوصول
class AccessibleListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? semanticLabel;
  final String? leadingIcon;
  final String? trailingIcon;
  final VoidCallback? onTap;
  final bool isEnabled;
  final Widget? trailing;

  const AccessibleListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.semanticLabel,
    this.leadingIcon,
    this.trailingIcon,
    this.onTap,
    this.isEnabled = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? title,
      hint: subtitle,
      button: onTap != null,
      enabled: isEnabled,
      child: ListTile(
        leading: leadingIcon != null
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AppIcon(
                    leadingIcon!,
                    size: 20,
                    color: isEnabled ? AppTheme.primaryColor : Colors.grey,
                  ),
                ),
              )
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isEnabled ? AppTheme.textPrimaryColor : Colors.grey,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: isEnabled ? Colors.grey[600] : Colors.grey[400],
                ),
              )
            : null,
        trailing:
            trailing ??
            (trailingIcon != null
                ? AppIcon(trailingIcon!, size: 16, color: Colors.grey)
                : null),
        onTap: isEnabled && onTap != null
            ? () {
                HapticFeedback.lightImpact();
                onTap!();
              }
            : null,
      ),
    );
  }
}
