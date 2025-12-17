import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================================
/// MbuyDialog - حوارات موحدة للتطبيق
/// ============================================================================

/// مكون حوار موحد لتطبيق MBUY
class MbuyDialog extends StatelessWidget {
  /// العنوان
  final String? title;

  /// المحتوى (نص)
  final String? content;

  /// محتوى مخصص
  final Widget? contentWidget;

  /// الأيقونة
  final IconData? icon;
  final String? svgIcon;

  /// لون الأيقونة
  final Color? iconColor;

  /// أزرار
  final List<Widget>? actions;

  /// نص زر التأكيد
  final String? confirmText;

  /// نص زر الإلغاء
  final String? cancelText;

  /// عند التأكيد
  final VoidCallback? onConfirm;

  /// عند الإلغاء
  final VoidCallback? onCancel;

  /// لون زر التأكيد
  final Color? confirmColor;

  /// هل يمكن إغلاقه بالضغط خارجه
  final bool barrierDismissible;

  const MbuyDialog({
    super.key,
    this.title,
    this.content,
    this.contentWidget,
    this.icon,
    this.svgIcon,
    this.iconColor,
    this.actions,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.barrierDismissible = true,
  });

  /// حوار تأكيد
  factory MbuyDialog.confirm({
    Key? key,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? icon,
  }) {
    return MbuyDialog(
      key: key,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmColor: confirmColor,
      icon: icon ?? Icons.help_outline,
      iconColor: AppTheme.primaryColor,
    );
  }

  /// حوار تحذير
  factory MbuyDialog.warning({
    Key? key,
    required String title,
    required String content,
    String confirmText = 'متابعة',
    String cancelText = 'إلغاء',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return MbuyDialog(
      key: key,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.warning_amber_rounded,
      iconColor: AppTheme.warningColor,
      confirmColor: AppTheme.warningColor,
    );
  }

  /// حوار خطأ
  factory MbuyDialog.error({
    Key? key,
    required String title,
    required String content,
    String confirmText = 'حسناً',
    VoidCallback? onConfirm,
  }) {
    return MbuyDialog(
      key: key,
      title: title,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
      icon: Icons.error_outline,
      iconColor: AppTheme.errorColor,
      confirmColor: AppTheme.errorColor,
    );
  }

  /// حوار نجاح
  factory MbuyDialog.success({
    Key? key,
    required String title,
    required String content,
    String confirmText = 'تم',
    VoidCallback? onConfirm,
  }) {
    return MbuyDialog(
      key: key,
      title: title,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
      icon: Icons.check_circle_outline,
      iconColor: AppTheme.successColor,
      confirmColor: AppTheme.successColor,
    );
  }

  /// حوار حذف
  factory MbuyDialog.delete({
    Key? key,
    required String title,
    String? content,
    String confirmText = 'حذف',
    String cancelText = 'إلغاء',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return MbuyDialog(
      key: key,
      title: title,
      content:
          content ?? 'هل أنت متأكد من الحذف؟ لا يمكن التراجع عن هذا الإجراء.',
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.delete_outline,
      iconColor: AppTheme.errorColor,
      confirmColor: AppTheme.errorColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      contentPadding: const EdgeInsets.all(AppDimensions.spacing24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الأيقونة
          if (icon != null || svgIcon != null) ...[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.primaryColor).withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: svgIcon != null
                  ? Center(
                      child: SvgPicture.asset(
                        svgIcon!,
                        width: 32,
                        height: 32,
                        colorFilter: ColorFilter.mode(
                          iconColor ?? AppTheme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      size: 32,
                      color: iconColor ?? AppTheme.primaryColor,
                    ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
          ],

          // العنوان
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: AppDimensions.fontHeadline,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing12),
          ],

          // المحتوى
          if (content != null)
            Text(
              content!,
              style: const TextStyle(
                fontSize: AppDimensions.fontBody,
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

          if (contentWidget != null) contentWidget!,

          const SizedBox(height: AppDimensions.spacing24),

          // الأزرار
          if (actions != null)
            Row(children: actions!)
          else
            _buildDefaultActions(context),
        ],
      ),
    );
  }

  Widget _buildDefaultActions(BuildContext context) {
    return Row(
      children: [
        if (cancelText != null)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                onCancel?.call();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textSecondaryColor,
                side: BorderSide(color: AppTheme.borderColor),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusM,
                ),
              ),
              child: Text(cancelText!),
            ),
          ),
        if (cancelText != null && confirmText != null)
          const SizedBox(width: AppDimensions.spacing12),
        if (confirmText != null)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                onConfirm?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor ?? AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusM,
                ),
              ),
              child: Text(confirmText!),
            ),
          ),
      ],
    );
  }

  /// عرض الحوار
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? content,
    Widget? contentWidget,
    IconData? icon,
    String? svgIcon,
    Color? iconColor,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => MbuyDialog(
        title: title,
        content: content,
        contentWidget: contentWidget,
        icon: icon,
        svgIcon: svgIcon,
        iconColor: iconColor,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
      ),
    );
  }

  /// عرض حوار تأكيد
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => MbuyDialog.confirm(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
      ),
    );
  }

  /// عرض حوار حذف
  static Future<bool?> showDelete(
    BuildContext context, {
    required String title,
    String? content,
    String confirmText = 'حذف',
    String cancelText = 'إلغاء',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => MbuyDialog.delete(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }
}
