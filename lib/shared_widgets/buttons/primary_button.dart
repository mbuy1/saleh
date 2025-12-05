import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// زر رئيسي قابل لإعادة الاستخدام في جميع أنحاء التطبيق
///
/// يوفر أنماط موحدة للأزرار مع خيارات تخصيص
class PrimaryButton extends StatelessWidget {
  /// نص الزر
  final String text;

  /// عند الضغط على الزر
  final VoidCallback? onPressed;

  /// أيقونة الزر (اختياري)
  final IconData? icon;

  /// نمط الزر
  final ButtonStyle buttonStyle;

  /// عرض الزر (null = full width)
  final double? width;

  /// ارتفاع الزر
  final double height;

  /// حجم الخط
  final double fontSize;

  /// تحميل (Loading)
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.buttonStyle = ButtonStyle.primary,
    this.width,
    this.height = 50,
    this.fontSize = 16,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColors = _getButtonColors();
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColors.backgroundColor,
          foregroundColor: buttonColors.foregroundColor,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: buttonColors.borderColor != null
                ? BorderSide(color: buttonColors.borderColor!, width: 1.5)
                : BorderSide.none,
          ),
          elevation: buttonStyle == ButtonStyle.primary ? 2 : 0,
          shadowColor: Colors.black26,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    buttonColors.foregroundColor,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _ButtonColors _getButtonColors() {
    switch (buttonStyle) {
      case ButtonStyle.primary:
        return _ButtonColors(
          backgroundColor: MbuyColors.primaryMaroon,
          foregroundColor: Colors.white,
        );
      case ButtonStyle.secondary:
        return _ButtonColors(
          backgroundColor: Colors.white,
          foregroundColor: MbuyColors.primaryMaroon,
          borderColor: MbuyColors.primaryMaroon,
        );
      case ButtonStyle.success:
        return _ButtonColors(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        );
      case ButtonStyle.danger:
        return _ButtonColors(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        );
      case ButtonStyle.warning:
        return _ButtonColors(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        );
      case ButtonStyle.light:
        return _ButtonColors(
          backgroundColor: Colors.grey[100]!,
          foregroundColor: MbuyColors.textPrimary,
        );
    }
  }
}

/// أنماط الأزرار المتاحة
enum ButtonStyle {
  /// زر رئيسي (أحمر)
  primary,

  /// زر ثانوي (أبيض مع حدود)
  secondary,

  /// زر نجاح (أخضر)
  success,

  /// زر خطر (أحمر فاتح)
  danger,

  /// زر تحذير (برتقالي)
  warning,

  /// زر فاتح (رمادي)
  light,
}

class _ButtonColors {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  _ButtonColors({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });
}

/// زر صغير لإجراءات سريعة
class SmallButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SmallButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            backgroundColor ?? MbuyColors.primaryMaroon.withValues(alpha: 0.1),
        foregroundColor: foregroundColor ?? MbuyColors.primaryMaroon,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 6)],
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// زر أيقونة دائري
class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;

  const IconCircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color:
            backgroundColor ?? MbuyColors.primaryMaroon.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: iconSize),
        color: iconColor ?? MbuyColors.primaryMaroon,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

/// زر FAB (Floating Action Button) مخصص
class CustomFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? MbuyColors.primaryMaroon,
        foregroundColor: foregroundColor ?? Colors.white,
        icon: Icon(icon),
        label: Text(
          label!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? MbuyColors.primaryMaroon,
      foregroundColor: foregroundColor ?? Colors.white,
      child: Icon(icon),
    );
  }
}
