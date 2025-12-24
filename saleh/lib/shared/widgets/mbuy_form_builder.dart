import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================================
/// MbuyFormBuilder - نظام موحد لإنشاء النماذج
/// ============================================================================
///
/// يوفر:
/// - Form validation موحد
/// - Error messages متناسقة
/// - Styling موحد
/// - Accessibility support
///
/// مثال الاستخدام:
/// ```dart
/// MbuyFormBuilder(
///   formKey: _formKey,
///   fields: [
///     MbuyFormField.email(controller: _emailController),
///     MbuyFormField.password(controller: _passwordController),
///   ],
///   submitButton: MbuyFormSubmitButton(
///     label: 'تسجيل الدخول',
///     onSubmit: _handleLogin,
///   ),
/// )
/// ```

/// أنواع حقول النموذج
enum MbuyFormFieldType {
  text,
  email,
  password,
  phone,
  number,
  multiline,
  dropdown,
}

/// مكون FormBuilder الرئيسي
class MbuyFormBuilder extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final Widget? submitButton;
  final double fieldSpacing;
  final EdgeInsetsGeometry? padding;
  final bool autovalidateMode;

  const MbuyFormBuilder({
    super.key,
    required this.formKey,
    required this.fields,
    this.submitButton,
    this.fieldSpacing = AppDimensions.spacing16,
    this.padding,
    this.autovalidateMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...fields.map((field) => Padding(
                  padding: EdgeInsets.only(bottom: fieldSpacing),
                  child: field,
                )),
            if (submitButton != null) ...[
              SizedBox(height: fieldSpacing),
              submitButton!,
            ],
          ],
        ),
      ),
    );
  }
}

/// حقل نموذج موحد مع validation
class MbuyFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final MbuyFormFieldType type;
  final String? Function(String?)? validator;
  final bool isRequired;
  final int maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final FocusNode? focusNode;
  final String? semanticLabel;

  const MbuyFormField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.type = MbuyFormFieldType.text,
    this.validator,
    this.isRequired = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled = true,
    this.focusNode,
    this.semanticLabel,
  });

  /// حقل البريد الإلكتروني
  factory MbuyFormField.email({
    Key? key,
    TextEditingController? controller,
    String label = 'البريد الإلكتروني',
    String? hint,
    bool isRequired = true,
    void Function(String)? onChanged,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) {
    return MbuyFormField(
      key: key,
      controller: controller,
      label: label,
      hint: hint ?? 'أدخل بريدك الإلكتروني',
      type: MbuyFormFieldType.email,
      isRequired: isRequired,
      onChanged: onChanged,
      textInputAction: textInputAction ?? TextInputAction.next,
      focusNode: focusNode,
      prefixIcon: const Icon(Icons.email_outlined),
      semanticLabel: 'حقل البريد الإلكتروني',
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'البريد الإلكتروني مطلوب';
        }
        if (value != null && value.isNotEmpty) {
          final emailRegex = RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          );
          if (!emailRegex.hasMatch(value)) {
            return 'البريد الإلكتروني غير صالح';
          }
        }
        return null;
      },
    );
  }

  /// حقل كلمة المرور
  factory MbuyFormField.password({
    Key? key,
    TextEditingController? controller,
    String label = 'كلمة المرور',
    String? hint,
    bool isRequired = true,
    int minLength = 6,
    void Function(String)? onChanged,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) {
    return MbuyFormField(
      key: key,
      controller: controller,
      label: label,
      hint: hint ?? 'أدخل كلمة المرور',
      type: MbuyFormFieldType.password,
      isRequired: isRequired,
      onChanged: onChanged,
      textInputAction: textInputAction ?? TextInputAction.done,
      focusNode: focusNode,
      prefixIcon: const Icon(Icons.lock_outline),
      semanticLabel: 'حقل كلمة المرور',
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'كلمة المرور مطلوبة';
        }
        if (value != null && value.length < minLength) {
          return 'كلمة المرور يجب أن تكون $minLength أحرف على الأقل';
        }
        return null;
      },
    );
  }

  /// حقل الهاتف
  factory MbuyFormField.phone({
    Key? key,
    TextEditingController? controller,
    String label = 'رقم الهاتف',
    String? hint,
    bool isRequired = true,
    void Function(String)? onChanged,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) {
    return MbuyFormField(
      key: key,
      controller: controller,
      label: label,
      hint: hint ?? '05xxxxxxxx',
      type: MbuyFormFieldType.phone,
      isRequired: isRequired,
      onChanged: onChanged,
      textInputAction: textInputAction ?? TextInputAction.next,
      focusNode: focusNode,
      prefixIcon: const Icon(Icons.phone_outlined),
      semanticLabel: 'حقل رقم الهاتف',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'رقم الهاتف مطلوب';
        }
        if (value != null && value.isNotEmpty) {
          if (value.length < 10) {
            return 'رقم الهاتف يجب أن يكون 10 أرقام';
          }
        }
        return null;
      },
    );
  }

  /// حقل الاسم
  factory MbuyFormField.name({
    Key? key,
    TextEditingController? controller,
    String label = 'الاسم',
    String? hint,
    bool isRequired = true,
    void Function(String)? onChanged,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) {
    return MbuyFormField(
      key: key,
      controller: controller,
      label: label,
      hint: hint ?? 'أدخل اسمك',
      type: MbuyFormFieldType.text,
      isRequired: isRequired,
      onChanged: onChanged,
      textInputAction: textInputAction ?? TextInputAction.next,
      focusNode: focusNode,
      prefixIcon: const Icon(Icons.person_outline),
      semanticLabel: 'حقل الاسم',
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'الاسم مطلوب';
        }
        if (value != null && value.length < 2) {
          return 'الاسم يجب أن يكون حرفين على الأقل';
        }
        return null;
      },
    );
  }

  /// حقل رقمي
  factory MbuyFormField.number({
    Key? key,
    TextEditingController? controller,
    String? label,
    String? hint,
    bool isRequired = false,
    double? min,
    double? max,
    void Function(String)? onChanged,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    Widget? prefixIcon,
  }) {
    return MbuyFormField(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
      type: MbuyFormFieldType.number,
      isRequired: isRequired,
      onChanged: onChanged,
      textInputAction: textInputAction ?? TextInputAction.next,
      focusNode: focusNode,
      prefixIcon: prefixIcon,
      semanticLabel: label ?? 'حقل رقمي',
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'هذا الحقل مطلوب';
        }
        if (value != null && value.isNotEmpty) {
          final number = double.tryParse(value);
          if (number == null) {
            return 'أدخل رقماً صالحاً';
          }
          if (min != null && number < min) {
            return 'القيمة يجب أن تكون $min أو أكثر';
          }
          if (max != null && number > max) {
            return 'القيمة يجب أن تكون $max أو أقل';
          }
        }
        return null;
      },
    );
  }

  /// حقل متعدد الأسطر
  factory MbuyFormField.multiline({
    Key? key,
    TextEditingController? controller,
    String? label,
    String? hint,
    bool isRequired = false,
    int maxLines = 4,
    int? maxLength,
    void Function(String)? onChanged,
    FocusNode? focusNode,
  }) {
    return MbuyFormField(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
      type: MbuyFormFieldType.multiline,
      isRequired: isRequired,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      focusNode: focusNode,
      semanticLabel: label ?? 'حقل نص متعدد الأسطر',
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            }
          : null,
    );
  }

  @override
  State<MbuyFormField> createState() => _MbuyFormFieldState();
}

class _MbuyFormFieldState extends State<MbuyFormField> {
  bool _obscureText = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  TextInputType get _keyboardType {
    switch (widget.type) {
      case MbuyFormFieldType.email:
        return TextInputType.emailAddress;
      case MbuyFormFieldType.phone:
        return TextInputType.phone;
      case MbuyFormFieldType.number:
        return const TextInputType.numberWithOptions(decimal: true);
      case MbuyFormFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.type == MbuyFormFieldType.password;

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      textField: true,
      focusable: true,
      focused: _isFocused,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacing8),
              child: Row(
                children: [
                  Text(
                    widget.label!,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontBody,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  if (widget.isRequired)
                    const Text(
                      ' *',
                      style: TextStyle(
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: isPassword && _obscureText,
            keyboardType: _keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: isPassword ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            inputFormatters: widget.inputFormatters,
            style: const TextStyle(
              fontSize: AppDimensions.fontBody,
              color: AppTheme.textPrimaryColor,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              helperText: widget.helperText,
              hintStyle: const TextStyle(
                color: AppTheme.textHintColor,
                fontSize: AppDimensions.fontBody,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppTheme.textSecondaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      tooltip: _obscureText ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
                    )
                  : widget.suffixIcon,
              filled: true,
              fillColor: widget.enabled
                  ? AppTheme.surfaceColor
                  : AppTheme.backgroundColor,
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
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusM,
                borderSide: const BorderSide(color: AppTheme.errorColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusM,
                borderSide: const BorderSide(
                  color: AppTheme.errorColor,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusM,
                borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              errorStyle: const TextStyle(
                fontSize: AppDimensions.fontCaption,
                color: AppTheme.errorColor,
              ),
            ),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}

/// زر إرسال النموذج
class MbuyFormSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback? onSubmit;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final double height;

  const MbuyFormSubmitButton({
    super.key,
    required this.label,
    this.onSubmit,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.height = AppDimensions.buttonHeightXL,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: !isLoading && onSubmit != null,
      label: label,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppTheme.accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusM,
            ),
            elevation: 0,
            disabledBackgroundColor:
                (backgroundColor ?? AppTheme.accentColor).withValues(alpha: 0.6),
          ),
          child: isLoading
              ? const SizedBox(
                  height: AppDimensions.iconS,
                  width: AppDimensions.iconS,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: AppDimensions.iconS),
                      const SizedBox(width: AppDimensions.spacing8),
                    ],
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Validators موحدة
class MbuyValidators {
  /// التحقق من أن الحقل ليس فارغاً
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName مطلوب' : 'هذا الحقل مطلوب';
    }
    return null;
  }

  /// التحقق من البريد الإلكتروني
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  /// التحقق من طول كلمة المرور
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) return null;
    if (value.length < minLength) {
      return 'كلمة المرور يجب أن تكون $minLength أحرف على الأقل';
    }
    return null;
  }

  /// التحقق من تطابق كلمتي المرور
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) return null;
    if (value != password) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }

  /// التحقق من رقم الهاتف
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length < 10) {
      return 'رقم الهاتف يجب أن يكون 10 أرقام';
    }
    return null;
  }

  /// التحقق من الحد الأدنى للطول
  static String? minLength(String? value, int length, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;
    if (value.length < length) {
      return '${fieldName ?? 'هذا الحقل'} يجب أن يكون $length أحرف على الأقل';
    }
    return null;
  }

  /// التحقق من الحد الأقصى للطول
  static String? maxLength(String? value, int length, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;
    if (value.length > length) {
      return '${fieldName ?? 'هذا الحقل'} يجب أن يكون $length أحرف كحد أقصى';
    }
    return null;
  }

  /// دمج عدة validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
