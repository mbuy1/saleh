import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================================
/// MbuySwitch - مفتاح تبديل موحد للتطبيق
/// ============================================================================

/// مكون مفتاح تبديل موحد لتطبيق MBUY
class MbuySwitch extends StatelessWidget {
  /// القيمة الحالية
  final bool value;

  /// عند التغيير
  final ValueChanged<bool>? onChanged;

  /// اللون عند التفعيل
  final Color? activeColor;

  /// اللون عند عدم التفعيل
  final Color? inactiveColor;

  /// معطل
  final bool disabled;

  const MbuySwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: disabled ? null : onChanged,
      // ignore: deprecated_member_use
      activeColor: activeColor ?? AppTheme.primaryColor,
      activeTrackColor: (activeColor ?? AppTheme.primaryColor).withValues(
        alpha: 0.5,
      ),
      inactiveThumbColor: inactiveColor ?? Colors.grey.shade400,
      inactiveTrackColor: Colors.grey.shade300,
    );
  }
}

/// ============================================================================
/// MbuySwitchTile - عنصر قائمة مع مفتاح تبديل
/// ============================================================================

class MbuySwitchTile extends StatelessWidget {
  /// العنوان
  final String title;

  /// الوصف
  final String? subtitle;

  /// الأيقونة
  final IconData? icon;

  /// القيمة
  final bool value;

  /// عند التغيير
  final ValueChanged<bool>? onChanged;

  /// اللون عند التفعيل
  final Color? activeColor;

  /// معطل
  final bool disabled;

  const MbuySwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: AppDimensions.avatarS,
              height: AppDimensions.avatarS,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconS,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDimensions.fontBody,
                    fontWeight: FontWeight.w500,
                    color: disabled
                        ? AppTheme.textHintColor
                        : AppTheme.textPrimaryColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: AppDimensions.fontLabel,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          MbuySwitch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
            disabled: disabled,
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// MbuyCheckbox - مربع اختيار موحد
/// ============================================================================

class MbuyCheckbox extends StatelessWidget {
  /// القيمة الحالية
  final bool value;

  /// عند التغيير
  final ValueChanged<bool?>? onChanged;

  /// اللون عند التفعيل
  final Color? activeColor;

  /// معطل
  final bool disabled;

  /// شكل دائري
  final bool isCircular;

  const MbuyCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.disabled = false,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: disabled ? null : onChanged,
      activeColor: activeColor ?? AppTheme.primaryColor,
      shape: isCircular
          ? const CircleBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
      side: BorderSide(
        color: value
            ? (activeColor ?? AppTheme.primaryColor)
            : Colors.grey.shade400,
        width: 1.5,
      ),
    );
  }
}

/// ============================================================================
/// MbuyCheckboxTile - عنصر قائمة مع مربع اختيار
/// ============================================================================

class MbuyCheckboxTile extends StatelessWidget {
  /// العنوان
  final String title;

  /// الوصف
  final String? subtitle;

  /// القيمة
  final bool value;

  /// عند التغيير
  final ValueChanged<bool?>? onChanged;

  /// اللون عند التفعيل
  final Color? activeColor;

  /// معطل
  final bool disabled;

  const MbuyCheckboxTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : () => onChanged?.call(!value),
      borderRadius: AppDimensions.borderRadiusM,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
          color: value
              ? AppTheme.primaryColor.withValues(alpha: 0.05)
              : AppTheme.surfaceColor,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(
            color: value ? AppTheme.primaryColor : AppTheme.borderColor,
          ),
        ),
        child: Row(
          children: [
            MbuyCheckbox(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
              disabled: disabled,
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimensions.fontBody,
                      fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                      color: disabled
                          ? AppTheme.textHintColor
                          : AppTheme.textPrimaryColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppDimensions.spacing4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: AppDimensions.fontLabel,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// MbuyRadio - زر راديو موحد
/// ============================================================================

class MbuyRadio<T> extends StatelessWidget {
  /// القيمة
  final T value;

  /// القيمة المجمعة
  final T? groupValue;

  /// عند التغيير
  final ValueChanged<T?>? onChanged;

  /// اللون عند التفعيل
  final Color? activeColor;

  /// معطل
  final bool disabled;

  const MbuyRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.activeColor,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Radio<T>(
      value: value,
      // ignore: deprecated_member_use
      groupValue: groupValue,
      // ignore: deprecated_member_use
      onChanged: disabled ? null : onChanged,
      activeColor: activeColor ?? AppTheme.primaryColor,
    );
  }
}

/// ============================================================================
/// MbuyRadioTile - عنصر قائمة مع زر راديو
/// ============================================================================

class MbuyRadioTile<T> extends StatelessWidget {
  /// العنوان
  final String title;

  /// الوصف
  final String? subtitle;

  /// القيمة
  final T value;

  /// القيمة المجمعة
  final T? groupValue;

  /// عند التغيير
  final ValueChanged<T?>? onChanged;

  /// اللون عند التفعيل
  final Color? activeColor;

  /// معطل
  final bool disabled;

  const MbuyRadioTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.activeColor,
    this.disabled = false,
  });

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : () => onChanged?.call(value),
      borderRadius: AppDimensions.borderRadiusM,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
          color: _selected
              ? AppTheme.primaryColor.withValues(alpha: 0.05)
              : AppTheme.surfaceColor,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(
            color: _selected ? AppTheme.primaryColor : AppTheme.borderColor,
          ),
        ),
        child: Row(
          children: [
            MbuyRadio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: activeColor,
              disabled: disabled,
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimensions.fontBody,
                      fontWeight: _selected ? FontWeight.w600 : FontWeight.w500,
                      color: disabled
                          ? AppTheme.textHintColor
                          : AppTheme.textPrimaryColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppDimensions.spacing4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: AppDimensions.fontLabel,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
