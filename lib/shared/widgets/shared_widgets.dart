import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_theme.dart';
import 'mbuy_card.dart';

/// ============================================================================
/// Shared Widgets - مكونات مشتركة للتطبيق
/// يجب استخدام هذه المكونات في جميع الشاشات لضمان التناسق
/// ============================================================================

/// AppBar مخصص للتطبيق
class MbuyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;

  const MbuyAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor ?? AppTheme.surfaceColor, // Light background (white)
      foregroundColor:
          foregroundColor ?? AppTheme.textPrimaryColor, // Dark text
      elevation: elevation,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      toolbarHeight: AppDimensions.appBarHeight,
      automaticallyImplyLeading: false, // نتحكم نحن بالـ leading
      leading: showBackButton
          ? (leading ??
                IconButton(
                  icon: SvgPicture.asset(
                    AppIcons.arrowBack,
                    width: AppDimensions.iconM,
                    height: AppDimensions.iconM,
                    colorFilter: const ColorFilter.mode(
                      AppTheme.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ))
          : leading,
      iconTheme: const IconThemeData(
        color: AppTheme.primaryColor, // Blue icons for actions
        size: AppDimensions.iconM,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppDimensions.fontHeadline,
          color: foregroundColor ?? AppTheme.textPrimaryColor,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);
}

/// Scaffold مخصص للتطبيق
class MbuyScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final bool showAppBar;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const MbuyScaffold({
    super.key,
    this.title,
    required this.body,
    this.showAppBar = true,
    this.showBackButton = true,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppTheme.backgroundColor,
      appBar: showAppBar && title != null
          ? MbuyAppBar(
              title: title!,
              showBackButton: showBackButton,
              actions: actions,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

/// زر رئيسي للتطبيق
class MbuyPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;

  const MbuyPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = AppDimensions.buttonHeightXL,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppTheme.accentColor,
        foregroundColor: foregroundColor ?? Colors.white,
        minimumSize: Size(width ?? double.infinity, height),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusM,
        ),
        elevation: 0,
        disabledBackgroundColor: (backgroundColor ?? AppTheme.accentColor)
            .withValues(alpha: 0.6),
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
              mainAxisSize: MainAxisSize.min,
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
    );

    return width != null
        ? button
        : SizedBox(width: double.infinity, child: button);
  }
}

/// زر ثانوي للتطبيق
class MbuySecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? borderColor;
  final Color? foregroundColor;
  final double? width;
  final double height;

  const MbuySecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.borderColor,
    this.foregroundColor,
    this.width,
    this.height = AppDimensions.buttonHeightL,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? AppTheme.primaryColor,
        minimumSize: Size(width ?? double.infinity, height),
        side: BorderSide(
          color: borderColor ?? AppTheme.primaryColor.withValues(alpha: 0.3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusM,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppDimensions.iconS),
            const SizedBox(width: AppDimensions.spacing8),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: AppDimensions.fontBody,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// حقل إدخال نص مخصص
class MbuyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextDirection? textDirection;
  final bool enabled;
  final void Function(String)? onChanged;

  const MbuyTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.textDirection,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textDirection: textDirection,
      maxLines: maxLines,
      enabled: enabled,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: AppDimensions.fontBody,
        color: AppTheme.textPrimaryColor,
      ),
      decoration: InputDecoration(
        labelText: label,
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
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppTheme.surfaceColor,
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
          borderSide: const BorderSide(color: AppTheme.accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      validator: validator,
    );
  }
}

/// حالة فارغة مخصصة
class MbuyEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const MbuyEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppDimensions.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppDimensions.avatarProfile,
              height: AppDimensions.avatarProfile,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconDisplay,
                color: AppTheme.primaryColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppDimensions.fontDisplay3,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: AppDimensions.fontBody,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: AppDimensions.spacing24),
              MbuyPrimaryButton(
                label: buttonLabel!,
                onPressed: onButtonPressed,
                width: 200,
                height: AppDimensions.buttonHeightL,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// مؤشر تحميل مخصص
class MbuyLoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;

  const MbuyLoadingIndicator({super.key, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: color ?? AppTheme.accentColor),
          if (message != null) ...[
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: AppDimensions.fontBody,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// شارة/Badge مخصصة
class MbuyBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const MbuyBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing8,
            vertical: AppDimensions.spacing4,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.accentColor,
        borderRadius: AppDimensions.borderRadiusXS,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: AppDimensions.fontCaption,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// SnackBar مخصص
class MbuySnackBar {
  static void show(
    BuildContext context, {
    required String message,
    MbuySnackBarType type = MbuySnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    Color backgroundColor;
    switch (type) {
      case MbuySnackBarType.success:
        backgroundColor = AppTheme.successColor;
        break;
      case MbuySnackBarType.error:
        backgroundColor = AppTheme.errorColor;
        break;
      case MbuySnackBarType.warning:
        backgroundColor = AppTheme.warningColor;
        break;
      case MbuySnackBarType.info:
        backgroundColor = AppTheme.infoColor;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusS,
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }
}

enum MbuySnackBarType { success, error, warning, info }

/// عنصر قائمة مخصص
class MbuyListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const MbuyListItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing14,
          ),
          child: Row(
            children: [
              Container(
                width: AppDimensions.avatarM,
                height: AppDimensions.avatarM,
                decoration: BoxDecoration(
                  color:
                      iconBackgroundColor ??
                      AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: AppDimensions.borderRadiusS,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppTheme.primaryColor,
                  size: AppDimensions.iconS,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontBody,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppDimensions.spacing2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: AppDimensions.fontLabel,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  SvgPicture.asset(
                    AppIcons.chevronRight,
                    width: AppDimensions.iconXS,
                    height: AppDimensions.iconXS,
                    colorFilter: const ColorFilter.mode(
                      AppTheme.textHintColor,
                      BlendMode.srcIn,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

/// قسم عنوان
class MbuySectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const MbuySectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.screenPaddingHorizontalOnly,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (actionLabel != null)
            TextButton(
              onPressed: onActionPressed,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: AppDimensions.fontBody2,
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            const SizedBox(),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppDimensions.fontHeadline,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// فاصل مخصص
class MbuyDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;

  const MbuyDivider({super.key, this.indent, this.endIndent});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
      color: Colors.grey.withValues(alpha: 0.15),
    );
  }
}

/// أيقونة دائرية
class MbuyCircleIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const MbuyCircleIcon({
    super.key,
    required this.icon,
    this.size = AppDimensions.avatarM,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryColor.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: iconColor ?? AppTheme.primaryColor,
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: child);
    }

    return child;
  }
}

/// عنصر شبكي للقوائم
class MbuyGridMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final String? badge;
  final Color? iconColor;

  const MbuyGridMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.badge,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return MbuyCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: AppDimensions.iconL,
                  color: iconColor ?? AppTheme.primaryColor,
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontBody2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: 0,
              left: 0,
              child: MbuyBadge(
                label: badge!,
                backgroundColor: AppTheme.warningColor,
              ),
            ),
        ],
      ),
    );
  }
}

/// عنصر قائمة (ListTile)
class MbuyListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const MbuyListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MbuyCard(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing8),
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppDimensions.spacing12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontBody,
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontCaption,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// حقل إدخال بتصميم محسن
class MbuyInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const MbuyInputField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        fontSize: AppDimensions.fontBody,
        color: AppTheme.textPrimaryColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppTheme.textHintColor,
          fontSize: AppDimensions.fontBody,
        ),
        labelStyle: const TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: AppDimensions.fontBody,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppTheme.surfaceColor,
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
          borderSide: const BorderSide(color: AppTheme.accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}

/// زر موحد
enum MbuyButtonType { primary, secondary, text }

class MbuyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final MbuyButtonType type;

  const MbuyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.type = MbuyButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MbuyButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(
              double.infinity,
              AppDimensions.buttonHeightL,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusM,
            ),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: AppDimensions.iconS),
                      const SizedBox(width: AppDimensions.spacing8),
                    ],
                    Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
        );
      case MbuyButtonType.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            minimumSize: const Size(
              double.infinity,
              AppDimensions.buttonHeightL,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusM,
            ),
          ),
          child: Text(label),
        );
      case MbuyButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          child: Text(label),
        );
    }
  }
}
