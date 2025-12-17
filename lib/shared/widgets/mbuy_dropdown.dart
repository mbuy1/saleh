import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================================
/// MbuyDropdown - قائمة منسدلة موحدة للتطبيق
/// ============================================================================

/// مكون قائمة منسدلة موحد لتطبيق MBUY
class MbuyDropdown<T> extends StatelessWidget {
  /// القيمة المحددة
  final T? value;

  /// العناصر
  final List<DropdownMenuItem<T>> items;

  /// عند التغيير
  final ValueChanged<T?>? onChanged;

  /// التسمية
  final String? label;

  /// نص التلميح
  final String? hint;

  /// الأيقونة
  final IconData? prefixIcon;

  /// هل مطلوب
  final bool isRequired;

  /// التحقق
  final String? Function(T?)? validator;

  /// معطل
  final bool disabled;

  /// لون الخلفية
  final Color? backgroundColor;

  const MbuyDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
    this.prefixIcon,
    this.isRequired = false,
    this.validator,
    this.disabled = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      // ignore: deprecated_member_use
      value: value,
      items: items,
      onChanged: disabled ? null : onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label != null ? (isRequired ? '$label *' : label) : null,
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppTheme.textHintColor,
          fontSize: AppDimensions.fontBody,
        ),
        labelStyle: const TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: AppDimensions.fontBody,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: AppTheme.textSecondaryColor,
                size: AppDimensions.iconS,
              )
            : null,
        filled: true,
        fillColor: backgroundColor ?? AppTheme.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.errorColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      dropdownColor: AppTheme.surfaceColor,
      borderRadius: AppDimensions.borderRadiusM,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppTheme.textSecondaryColor,
      ),
      style: const TextStyle(
        fontSize: AppDimensions.fontBody,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  /// إنشاء عناصر من قائمة strings
  static List<DropdownMenuItem<String>> fromStrings(List<String> items) {
    return items
        .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
        .toList();
  }

  /// إنشاء عناصر من Map
  static List<DropdownMenuItem<T>> fromMap<T>(Map<T, String> items) {
    return items.entries
        .map(
          (entry) =>
              DropdownMenuItem<T>(value: entry.key, child: Text(entry.value)),
        )
        .toList();
  }
}

/// ============================================================================
/// MbuySelectField - حقل اختيار مع Bottom Sheet
/// ============================================================================

class MbuySelectField<T> extends StatelessWidget {
  /// القيمة المحددة
  final T? value;

  /// النص المعروض
  final String? displayText;

  /// التسمية
  final String? label;

  /// نص التلميح
  final String hint;

  /// الأيقونة
  final IconData? prefixIcon;

  /// هل مطلوب
  final bool isRequired;

  /// عند الضغط
  final VoidCallback? onTap;

  /// معطل
  final bool disabled;

  const MbuySelectField({
    super.key,
    this.value,
    this.displayText,
    this.label,
    required this.hint,
    this.prefixIcon,
    this.isRequired = false,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && displayText != null;

    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: AppDimensions.borderRadiusM,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing14,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              Icon(
                prefixIcon,
                color: AppTheme.textSecondaryColor,
                size: AppDimensions.iconS,
              ),
              const SizedBox(width: AppDimensions.spacing12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null)
                    Text(
                      isRequired ? '$label *' : label!,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontLabel,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  Text(
                    hasValue ? displayText! : hint,
                    style: TextStyle(
                      fontSize: AppDimensions.fontBody,
                      color: hasValue
                          ? AppTheme.textPrimaryColor
                          : AppTheme.textHintColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// MbuyBottomSheetSelect - اختيار من Bottom Sheet
/// ============================================================================

class MbuyBottomSheetSelect<T> extends StatelessWidget {
  /// العنوان
  final String title;

  /// العناصر
  final List<SelectOption<T>> options;

  /// القيمة المحددة
  final T? selectedValue;

  /// عند الاختيار
  final ValueChanged<T>? onSelected;

  /// هل يسمح بالبحث
  final bool searchable;

  const MbuyBottomSheetSelect({
    super.key,
    required this.title,
    required this.options,
    this.selectedValue,
    this.onSelected,
    this.searchable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
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
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontHeadline,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: AppTheme.textSecondaryColor,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Options
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option.value == selectedValue;

                return ListTile(
                  leading: option.icon != null
                      ? Icon(
                          option.icon,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondaryColor,
                        )
                      : null,
                  title: Text(
                    option.label,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimaryColor,
                    ),
                  ),
                  subtitle: option.subtitle != null
                      ? Text(
                          option.subtitle!,
                          style: const TextStyle(
                            fontSize: AppDimensions.fontLabel,
                            color: AppTheme.textSecondaryColor,
                          ),
                        )
                      : null,
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppTheme.primaryColor,
                        )
                      : null,
                  onTap: () {
                    onSelected?.call(option.value);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),

          // Bottom Safe Area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  /// عرض Bottom Sheet
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<SelectOption<T>> options,
    T? selectedValue,
    bool searchable = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MbuyBottomSheetSelect<T>(
        title: title,
        options: options,
        selectedValue: selectedValue,
        searchable: searchable,
        onSelected: (value) => Navigator.of(context).pop(value),
      ),
    );
  }
}

/// عنصر اختيار
class SelectOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;

  const SelectOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}
