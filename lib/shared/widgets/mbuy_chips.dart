import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================================
/// MbuyChip - شرائح موحدة للتطبيق
/// ============================================================================

/// نوع الشريحة
enum MbuyChipType { filled, outlined, filter, input }

/// مكون شريحة موحد لتطبيق MBUY
class MbuyChip extends StatelessWidget {
  /// النص
  final String label;

  /// الأيقونة
  final IconData? icon;

  /// أيقونة الحذف
  final IconData? deleteIcon;

  /// عند الضغط
  final VoidCallback? onTap;

  /// عند الحذف
  final VoidCallback? onDeleted;

  /// محدد
  final bool selected;

  /// معطل
  final bool disabled;

  /// نوع الشريحة
  final MbuyChipType type;

  /// اللون
  final Color? color;

  /// لون النص
  final Color? textColor;

  const MbuyChip({
    super.key,
    required this.label,
    this.icon,
    this.deleteIcon,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.disabled = false,
    this.type = MbuyChipType.filled,
    this.color,
    this.textColor,
  });

  /// شريحة فلتر
  const MbuyChip.filter({
    super.key,
    required this.label,
    this.icon,
    required this.selected,
    this.onTap,
    this.disabled = false,
    this.color,
  }) : type = MbuyChipType.filter,
       deleteIcon = null,
       onDeleted = null,
       textColor = null;

  /// شريحة إدخال (قابلة للحذف)
  const MbuyChip.input({
    super.key,
    required this.label,
    this.icon,
    this.onDeleted,
    this.disabled = false,
    this.color,
  }) : type = MbuyChipType.input,
       selected = false,
       onTap = null,
       deleteIcon = Icons.close,
       textColor = null;

  /// شريحة حالة
  factory MbuyChip.status({
    Key? key,
    required String label,
    required Color color,
    IconData? icon,
  }) {
    return MbuyChip(
      key: key,
      label: label,
      icon: icon,
      color: color,
      textColor: Colors.white,
      type: MbuyChipType.filled,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MbuyChipType.filter:
        return FilterChip(
          label: Text(label),
          avatar: icon != null ? Icon(icon, size: 18) : null,
          selected: selected,
          onSelected: disabled ? null : (_) => onTap?.call(),
          selectedColor: (color ?? AppTheme.primaryColor).withValues(
            alpha: 0.2,
          ),
          checkmarkColor: color ?? AppTheme.primaryColor,
          labelStyle: TextStyle(
            color: selected
                ? (color ?? AppTheme.primaryColor)
                : AppTheme.textPrimaryColor,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusXL,
            side: BorderSide(
              color: selected
                  ? (color ?? AppTheme.primaryColor)
                  : AppTheme.borderColor,
            ),
          ),
        );

      case MbuyChipType.input:
        return InputChip(
          label: Text(label),
          avatar: icon != null
              ? Icon(icon, size: 18, color: AppTheme.textSecondaryColor)
              : null,
          deleteIcon: deleteIcon != null ? Icon(deleteIcon, size: 18) : null,
          onDeleted: disabled ? null : onDeleted,
          onPressed: onTap,
          backgroundColor: (color ?? AppTheme.primaryColor).withValues(
            alpha: 0.1,
          ),
          deleteIconColor: AppTheme.textSecondaryColor,
          labelStyle: TextStyle(color: color ?? AppTheme.textPrimaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusXL,
          ),
        );

      case MbuyChipType.outlined:
        return ActionChip(
          label: Text(label),
          avatar: icon != null
              ? Icon(icon, size: 18, color: color ?? AppTheme.primaryColor)
              : null,
          onPressed: disabled ? null : onTap,
          backgroundColor: Colors.transparent,
          labelStyle: TextStyle(color: color ?? AppTheme.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusXL,
            side: BorderSide(color: color ?? AppTheme.primaryColor),
          ),
        );

      case MbuyChipType.filled:
        return ActionChip(
          label: Text(label),
          avatar: icon != null
              ? Icon(icon, size: 18, color: textColor ?? Colors.white)
              : null,
          onPressed: disabled ? null : onTap,
          backgroundColor: color ?? AppTheme.primaryColor,
          labelStyle: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusXL,
          ),
        );
    }
  }
}

/// ============================================================================
/// MbuyChipGroup - مجموعة شرائح
/// ============================================================================

class MbuyChipGroup<T> extends StatelessWidget {
  /// العناصر
  final List<ChipOption<T>> options;

  /// القيمة المحددة (للاختيار الفردي)
  final T? selectedValue;

  /// القيم المحددة (للاختيار المتعدد)
  final List<T>? selectedValues;

  /// عند الاختيار
  final ValueChanged<T>? onSelected;

  /// اختيار متعدد
  final bool multiSelect;

  /// التفاف
  final bool wrap;

  /// المسافة بين الشرائح
  final double spacing;

  const MbuyChipGroup({
    super.key,
    required this.options,
    this.selectedValue,
    this.selectedValues,
    this.onSelected,
    this.multiSelect = false,
    this.wrap = true,
    this.spacing = AppDimensions.spacing8,
  });

  @override
  Widget build(BuildContext context) {
    final chips = options.map((option) {
      final isSelected = multiSelect
          ? (selectedValues?.contains(option.value) ?? false)
          : option.value == selectedValue;

      return MbuyChip.filter(
        label: option.label,
        icon: option.icon,
        selected: isSelected,
        onTap: () => onSelected?.call(option.value),
        color: option.color,
      );
    }).toList();

    if (wrap) {
      return Wrap(spacing: spacing, runSpacing: spacing, children: chips);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .map(
              (chip) => Padding(
                padding: EdgeInsets.only(right: spacing),
                child: chip,
              ),
            )
            .toList(),
      ),
    );
  }
}

/// عنصر شريحة
class ChipOption<T> {
  final T value;
  final String label;
  final IconData? icon;
  final Color? color;

  const ChipOption({
    required this.value,
    required this.label,
    this.icon,
    this.color,
  });
}

/// ============================================================================
/// MbuyTag - وسم صغير
/// ============================================================================

class MbuyTag extends StatelessWidget {
  /// النص
  final String label;

  /// اللون
  final Color? color;

  /// لون النص
  final Color? textColor;

  /// حجم صغير
  final bool small;

  const MbuyTag({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.small = false,
  });

  /// وسم نجاح
  factory MbuyTag.success(String label, {bool small = false}) {
    return MbuyTag(
      label: label,
      color: AppTheme.successColor.withValues(alpha: 0.1),
      textColor: AppTheme.successColor,
      small: small,
    );
  }

  /// وسم خطأ
  factory MbuyTag.error(String label, {bool small = false}) {
    return MbuyTag(
      label: label,
      color: AppTheme.errorColor.withValues(alpha: 0.1),
      textColor: AppTheme.errorColor,
      small: small,
    );
  }

  /// وسم تحذير
  factory MbuyTag.warning(String label, {bool small = false}) {
    return MbuyTag(
      label: label,
      color: AppTheme.warningColor.withValues(alpha: 0.1),
      textColor: AppTheme.warningColor,
      small: small,
    );
  }

  /// وسم معلومات
  factory MbuyTag.info(String label, {bool small = false}) {
    return MbuyTag(
      label: label,
      color: AppTheme.infoColor.withValues(alpha: 0.1),
      textColor: AppTheme.infoColor,
      small: small,
    );
  }

  /// وسم أساسي
  factory MbuyTag.primary(String label, {bool small = false}) {
    return MbuyTag(
      label: label,
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      textColor: AppTheme.primaryColor,
      small: small,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppDimensions.spacing6 : AppDimensions.spacing8,
        vertical: small ? AppDimensions.spacing2 : AppDimensions.spacing4,
      ),
      decoration: BoxDecoration(
        color: color ?? AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(small ? 4 : AppDimensions.radiusXS),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: small ? AppDimensions.fontCaption : AppDimensions.fontLabel,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppTheme.primaryColor,
        ),
      ),
    );
  }
}
