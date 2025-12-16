import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/mbuy_button.dart';

/// مساعد لعرض رسائل الأخطاء والنجاح
class DialogHelper {
  DialogHelper._();

  /// عرض رسالة خطأ حرجة مع زر إعادة المحاولة
  static Future<bool?> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? retryButtonText,
    String? cancelButtonText,
    VoidCallback? onRetry,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusL,
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppIcons.error,
                width: AppDimensions.iconL,
                height: AppDimensions.iconL,
                colorFilter: const ColorFilter.mode(
                  AppTheme.errorColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
            height: 1.5,
          ),
        ),
        actions: [
          if (cancelButtonText != null)
            MbuyButton.text(
              text: cancelButtonText,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          if (retryButtonText != null && onRetry != null)
            MbuyButton.primary(
              text: retryButtonText,
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry();
              },
            ),
        ],
      ),
    );
  }

  /// عرض رسالة نجاح
  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'حسناً',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusL,
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppIcons.checkCircle,
                width: AppDimensions.iconL,
                height: AppDimensions.iconL,
                colorFilter: const ColorFilter.mode(
                  AppTheme.successColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
            height: 1.5,
          ),
        ),
        actions: [
          MbuyButton.primary(
            text: buttonText,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// عرض رسالة تحذير
  static Future<bool?> showWarningDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmButtonText = 'نعم',
    String cancelButtonText = 'إلغاء',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusL,
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppIcons.warning,
                width: AppDimensions.iconL,
                height: AppDimensions.iconL,
                colorFilter: const ColorFilter.mode(
                  AppTheme.warningColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
            height: 1.5,
          ),
        ),
        actions: [
          MbuyButton.text(
            text: cancelButtonText,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          MbuyButton(
            text: confirmButtonText,
            type: MbuyButtonType.primary,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  /// عرض رسالة تأكيد حذف
  static Future<bool?> showDeleteConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String deleteButtonText = 'حذف',
    String cancelButtonText = 'إلغاء',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusL,
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppIcons.delete,
                width: AppDimensions.iconL,
                height: AppDimensions.iconL,
                colorFilter: const ColorFilter.mode(
                  AppTheme.errorColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
            height: 1.5,
          ),
        ),
        actions: [
          MbuyButton.text(
            text: cancelButtonText,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          MbuyButton(
            text: deleteButtonText,
            type: MbuyButtonType.primary,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  /// عرض Bottom Sheet لخيارات متعددة
  static Future<T?> showOptionsSheet<T>({
    required BuildContext context,
    required String title,
    required List<OptionItem<T>> options,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetRadius),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: AppDimensions.spacing12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ),
            const Divider(height: 1),
            // Options
            ...options.map(
              (option) => ListTile(
                leading: option.icon != null
                    ? Icon(option.icon, color: option.iconColor)
                    : null,
                title: Text(
                  option.title,
                  style: TextStyle(
                    color: option.textColor ?? AppTheme.textPrimaryColor,
                  ),
                ),
                subtitle: option.subtitle != null
                    ? Text(option.subtitle!)
                    : null,
                onTap: () => Navigator.of(context).pop(option.value),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
          ],
        ),
      ),
    );
  }
}

/// عنصر خيار في Bottom Sheet
class OptionItem<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final T value;

  const OptionItem({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.textColor,
  });
}
