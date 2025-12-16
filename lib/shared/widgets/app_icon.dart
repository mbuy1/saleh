import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================
/// APP ICON WIDGET - ويدجت الأيقونات الموحد
/// ============================================================
/// استخدم هذا الويدجت لعرض جميع الأيقونات في التطبيق
///
/// الميزات:
/// - دعم ملفات SVG
/// - ألوان من Theme تلقائياً
/// - أحجام موحدة
/// - دعم الأيقونات المعبأة والمخططة
///
/// أمثلة:
/// ```dart
/// // أيقونة بسيطة
/// AppIcon(AppIcons.home)
///
/// // أيقونة بحجم مخصص
/// AppIcon(AppIcons.home, size: 28)
///
/// // أيقونة بلون مخصص
/// AppIcon(AppIcons.home, color: Colors.blue)
///
/// // أيقونة في زر
/// AppIcon.button(AppIcons.add, onTap: () {})
///
/// // أيقونة ملونة للتنقل
/// AppIcon.nav(AppIcons.home, isSelected: true)
/// ```
/// ============================================================

class AppIcon extends StatelessWidget {
  /// مسار ملف SVG
  final String icon;

  /// حجم الأيقونة (العرض والارتفاع)
  final double? size;

  /// لون الأيقونة (يستخدم اللون من Theme إذا لم يُحدد)
  final Color? color;

  /// معامل الأسطر (stroke) في SVG
  final double? strokeWidth;

  /// التوافق الدلالي (Semantics)
  final String? semanticLabel;

  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
    this.semanticLabel,
  });

  /// أيقونة زر تنقل (Bottom Navigation)
  factory AppIcon.nav(
    String icon, {
    Key? key,
    bool isSelected = false,
    double? size,
    Color? selectedColor,
    Color? unselectedColor,
  }) {
    return _AppNavIcon(
      icon,
      key: key,
      isSelected: isSelected,
      size: size ?? AppIconSize.navBar,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
    );
  }

  /// أيقونة في زر مع حدث ضغط
  static Widget button(
    String icon, {
    Key? key,
    required VoidCallback onTap,
    double? size,
    Color? color,
    Color? backgroundColor,
    EdgeInsets? padding,
    String? tooltip,
  }) {
    return _AppIconButton(
      icon,
      key: key,
      onTap: onTap,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
      padding: padding,
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? AppIconSize.medium;
    final iconColor =
        color ?? Theme.of(context).iconTheme.color ?? AppTheme.textPrimaryColor;

    return SvgPicture.asset(
      icon,
      width: iconSize,
      height: iconSize,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
    );
  }
}

/// ============================================================
/// أيقونة التنقل السفلي
/// ============================================================
class _AppNavIcon extends AppIcon {
  final bool isSelected;
  final Color? selectedColor;
  final Color? unselectedColor;

  const _AppNavIcon(
    super.icon, {
    super.key,
    this.isSelected = false,
    super.size,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor;

    if (isSelected) {
      iconColor = selectedColor ?? AppTheme.primaryColor;
    } else {
      iconColor = unselectedColor ?? AppTheme.textSecondaryColor;
    }

    return SvgPicture.asset(
      icon,
      width: size ?? AppIconSize.navBar,
      height: size ?? AppIconSize.navBar,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
    );
  }
}

/// ============================================================
/// زر أيقونة
/// ============================================================
class _AppIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final double? size;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final String? tooltip;

  const _AppIconButton(
    this.icon, {
    super.key,
    required this.onTap,
    this.size,
    this.color,
    this.backgroundColor,
    this.padding,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? AppIconSize.medium;
    final iconColor =
        color ?? Theme.of(context).iconTheme.color ?? AppTheme.textPrimaryColor;
    final bgColor = backgroundColor ?? Colors.transparent;
    final buttonPadding = padding ?? const EdgeInsets.all(8);

    Widget iconWidget = Container(
      padding: buttonPadding,
      decoration: bgColor != Colors.transparent
          ? BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(
                iconSize / 2 + buttonPadding.horizontal / 2,
              ),
            )
          : null,
      child: SvgPicture.asset(
        icon,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );

    if (tooltip != null) {
      iconWidget = Tooltip(message: tooltip!, child: iconWidget);
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: iconWidget,
    );
  }
}

/// ============================================================
/// أحجام الأيقونات الموحدة
/// ============================================================
class AppIconSize {
  AppIconSize._();

  /// صغير جداً - للشارات والمؤشرات
  static const double tiny = 12.0;

  /// صغير - للقوائم المدمجة
  static const double small = 16.0;

  /// متوسط - الافتراضي
  static const double medium = 24.0;

  /// كبير - للعناوين والأزرار
  static const double large = 28.0;

  /// كبير جداً - للشاشات الرئيسية
  static const double xLarge = 32.0;

  /// ضخم - للصفحات الفارغة
  static const double huge = 48.0;

  /// شريط التنقل السفلي
  static const double navBar = 24.0;

  /// AppBar
  static const double appBar = 24.0;

  /// FAB
  static const double fab = 24.0;
}

/// ============================================================
/// ألوان الأيقونات الموحدة
/// ============================================================
class AppIconColor {
  AppIconColor._();

  /// لون أساسي
  static Color primary(BuildContext context) => AppTheme.primaryColor;

  /// لون ثانوي
  static Color secondary(BuildContext context) => AppTheme.textSecondaryColor;

  /// لون النص الأساسي
  static Color text(BuildContext context) => AppTheme.textPrimaryColor;

  /// لون النجاح
  static Color success(BuildContext context) => AppTheme.successColor;

  /// لون التحذير
  static Color warning(BuildContext context) => AppTheme.warningColor;

  /// لون الخطأ
  static Color error(BuildContext context) => AppTheme.errorColor;

  /// لون معطل
  static Color disabled(BuildContext context) =>
      AppTheme.textSecondaryColor.withValues(alpha: 0.5);

  /// لون أبيض
  static Color white(BuildContext context) => Colors.white;
}
