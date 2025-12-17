import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================================
/// MbuyBottomSheet - نافذة سفلية موحدة للتطبيق
/// ============================================================================

/// مكون نافذة سفلية موحد لتطبيق MBUY
class MbuyBottomSheet extends StatelessWidget {
  /// العنوان
  final String? title;

  /// المحتوى
  final Widget child;

  /// الأزرار
  final List<Widget>? actions;

  /// إظهار المقبض
  final bool showHandle;

  /// إظهار زر الإغلاق
  final bool showCloseButton;

  /// ارتفاع مخصص
  final double? height;

  /// هل يتمدد
  final bool isExpanded;

  /// لون الخلفية
  final Color? backgroundColor;

  /// padding
  final EdgeInsetsGeometry? padding;

  const MbuyBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.showHandle = true,
    this.showCloseButton = true,
    this.height,
    this.isExpanded = false,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        // Handle
        if (showHandle)
          Container(
            margin: const EdgeInsets.only(top: AppDimensions.spacing12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

        // Header
        if (title != null || showCloseButton)
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            child: Row(
              children: [
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontHeadline,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                if (showCloseButton)
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppTheme.textSecondaryColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),

        if (title != null || showCloseButton) const Divider(height: 1),

        // Content
        if (isExpanded)
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppDimensions.spacing16),
              child: child,
            ),
          )
        else
          Padding(
            padding: padding ?? const EdgeInsets.all(AppDimensions.spacing16),
            child: child,
          ),

        // Actions
        if (actions != null && actions!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            child: Row(
              children:
                  actions!
                      .map((action) => Expanded(child: action))
                      .toList()
                      .expand(
                        (widget) => [
                          widget,
                          const SizedBox(width: AppDimensions.spacing12),
                        ],
                      )
                      .toList()
                    ..removeLast(),
            ),
          ),

        // Safe Area
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );

    return Container(
      constraints: BoxConstraints(
        maxHeight: height ?? MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: content,
    );
  }

  /// عرض نافذة سفلية
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool showHandle = true,
    bool showCloseButton = true,
    double? height,
    bool isExpanded = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => MbuyBottomSheet(
        title: title,
        actions: actions,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        height: height,
        isExpanded: isExpanded,
        child: child,
      ),
    );
  }
}

/// ============================================================================
/// MbuyActionSheet - نافذة إجراءات سفلية
/// ============================================================================

class MbuyActionSheet extends StatelessWidget {
  /// العنوان
  final String? title;

  /// الوصف
  final String? description;

  /// الإجراءات
  final List<MbuyActionSheetItem> actions;

  /// إجراء الإلغاء
  final String cancelText;

  const MbuyActionSheet({
    super.key,
    this.title,
    this.description,
    required this.actions,
    this.cancelText = 'إلغاء',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppDimensions.spacing12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          if (title != null || description != null)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              child: Column(
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontHeadline,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  if (description != null) ...[
                    const SizedBox(height: AppDimensions.spacing8),
                    Text(
                      description!,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontBody,
                        color: AppTheme.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

          const Divider(height: 1),

          // Actions
          ...actions.map((action) => _buildActionItem(context, action)),

          // Cancel
          const Divider(height: 1),
          ListTile(
            onTap: () => Navigator.of(context).pop(),
            title: Text(
              cancelText,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Safe Area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, MbuyActionSheetItem action) {
    return ListTile(
      leading: action.icon != null
          ? Icon(
              action.icon,
              color: action.isDestructive
                  ? AppTheme.errorColor
                  : (action.color ?? AppTheme.textPrimaryColor),
            )
          : action.svgIcon != null
          ? SvgPicture.asset(
              action.svgIcon!,
              width: AppDimensions.iconM,
              height: AppDimensions.iconM,
              colorFilter: ColorFilter.mode(
                action.isDestructive
                    ? AppTheme.errorColor
                    : (action.color ?? AppTheme.textPrimaryColor),
                BlendMode.srcIn,
              ),
            )
          : null,
      title: Text(
        action.label,
        style: TextStyle(
          color: action.isDestructive
              ? AppTheme.errorColor
              : (action.color ?? AppTheme.textPrimaryColor),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: action.subtitle != null
          ? Text(
              action.subtitle!,
              style: const TextStyle(
                fontSize: AppDimensions.fontLabel,
                color: AppTheme.textSecondaryColor,
              ),
            )
          : null,
      onTap: () {
        Navigator.of(context).pop();
        action.onTap?.call();
      },
    );
  }

  /// عرض نافذة إجراءات
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? description,
    required List<MbuyActionSheetItem> actions,
    String cancelText = 'إلغاء',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MbuyActionSheet(
        title: title,
        description: description,
        actions: actions,
        cancelText: cancelText,
      ),
    );
  }
}

/// عنصر إجراء
class MbuyActionSheetItem {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final String? svgIcon;
  final Color? color;
  final bool isDestructive;
  final VoidCallback? onTap;

  const MbuyActionSheetItem({
    required this.label,
    this.subtitle,
    this.icon,
    this.svgIcon,
    this.color,
    this.isDestructive = false,
    this.onTap,
  });

  /// إجراء حذف
  factory MbuyActionSheetItem.delete({
    String label = 'حذف',
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return MbuyActionSheetItem(
      label: label,
      subtitle: subtitle,
      icon: Icons.delete_outline,
      isDestructive: true,
      onTap: onTap,
    );
  }

  /// إجراء مشاركة
  factory MbuyActionSheetItem.share({
    String label = 'مشاركة',
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return MbuyActionSheetItem(
      label: label,
      subtitle: subtitle,
      svgIcon: AppIcons.share,
      onTap: onTap,
    );
  }

  /// إجراء تعديل
  factory MbuyActionSheetItem.edit({
    String label = 'تعديل',
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return MbuyActionSheetItem(
      label: label,
      subtitle: subtitle,
      svgIcon: AppIcons.edit,
      onTap: onTap,
    );
  }
}
