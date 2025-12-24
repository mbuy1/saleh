import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_dimensions.dart';

/// ============================================================================
/// Design System Widgets - مكونات نظام التصميم الموحد
/// ============================================================================
///
/// تم إنشاؤها بناءً على تصميم app_store_screen كـ Design Baseline
/// Brand Primary: #215950
///
/// المكونات:
/// - MbuySectionHeader: عنوان قسم مع رابط "عرض الكل"
/// - MbuyFeatureCard: بطاقة ميزة مع أيقونة وعنوان ووصف
/// - MbuyBannerCarouselCard: بطاقة بانر للكاروسيل
/// - MbuySearchField: حقل بحث موحد
/// - MbuySegmentedTabs: تبويبات مقسمة
/// - MbuyChipFilter: فلتر chips أفقي
/// - MbuyListCard: بطاقة قائمة موحدة
/// - MbuyStatCard: بطاقة إحصائيات
/// - MbuyIconBox: مربع أيقونة ناعم
/// ============================================================================

// ============================================================================
// SECTION HEADER - عنوان قسم
// ============================================================================

/// عنوان قسم مع أيقونة ورابط "عرض الكل"
class MbuySectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  const MbuySectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.actionText,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 16),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppTheme.textPrimary(isDark);
    final primaryColor = AppTheme.primaryColor;

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? primaryColor, size: 22),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: AppDimensions.fontHeadline,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          if (actionText != null)
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onAction?.call();
              },
              child: Text(
                actionText!,
                style: TextStyle(
                  fontSize: AppDimensions.fontBody,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// عنوان قسم بسيط (للاستخدام الداخلي)
class MbuySectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;

  const MbuySectionTitle({
    super.key,
    required this.title,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: padding,
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppDimensions.fontHeadline,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppTheme.textPrimaryColor,
        ),
      ),
    );
  }
}

// ============================================================================
// FEATURE CARD - بطاقة ميزة
// ============================================================================

/// بطاقة ميزة بأيقونة وعنوان ووصف
class MbuyFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showBadge;
  final String? badgeText;
  final Color? badgeColor;

  const MbuyFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.showBadge = false,
    this.badgeText,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.primaryColor;

    final cardColor = isDark ? AppTheme.cardColorDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : AppTheme.borderColor;
    final textColor = isDark ? Colors.white : AppTheme.textPrimaryColor;
    final secondaryTextColor = isDark
        ? Colors.white.withValues(alpha: 0.7)
        : AppTheme.textSecondaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Box
                MbuyIconBox(
                  icon: icon,
                  size: 48,
                  iconSize: 24,
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  iconColor: primaryColor,
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: AppDimensions.fontTitle,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (showBadge && badgeText != null) ...[
                            const SizedBox(width: 8),
                            MbuyBadge(
                              text: badgeText!,
                              color: badgeColor ?? AppTheme.warningColor,
                            ),
                          ],
                        ],
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: AppDimensions.fontBody2,
                            color: secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Trailing
                trailing ??
                    Icon(
                      Icons.chevron_left,
                      color: secondaryTextColor,
                      size: 24,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BANNER CAROUSEL CARD - بطاقة بانر
// ============================================================================

/// بطاقة بانر للكاروسيل مع gradient
class MbuyBannerCarouselCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final IconData? icon;
  final Widget? image;
  final Gradient? gradient;
  final String? badgeText;
  final Color? badgeColor;
  final String? actionText;
  final VoidCallback? onTap;
  final VoidCallback? onAction;
  final double? rating;
  final int? reviewCount;

  const MbuyBannerCarouselCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.image,
    this.gradient,
    this.badgeText,
    this.badgeColor,
    this.actionText,
    this.onTap,
    this.onAction,
    this.rating,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withValues(alpha: 0.2),
        isDark ? AppTheme.cardColorDark : Colors.white,
      ],
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: gradient ?? defaultGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon Box
                    if (icon != null)
                      MbuyIconBox(
                        icon: icon!,
                        size: 56,
                        iconSize: 28,
                        backgroundColor: primaryColor.withValues(alpha: 0.2),
                        iconColor: primaryColor,
                      ),
                    if (image != null) image!,
                    const SizedBox(width: 16),
                    // Title & Badges
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: AppDimensions.fontHeadline,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : AppTheme.textPrimaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (badgeText != null) ...[
                                const SizedBox(width: 8),
                                MbuyBadge(
                                  text: badgeText!,
                                  color: badgeColor ?? AppTheme.warningColor,
                                ),
                              ],
                            ],
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                fontSize: AppDimensions.fontBody2,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (description != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: AppDimensions.fontBody,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppTheme.textSecondaryColor,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating
                    if (rating != null)
                      MbuyRating(rating: rating!, reviewCount: reviewCount),
                    // Action Button
                    if (actionText != null)
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onAction?.call();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            actionText!,
                            style: const TextStyle(
                              fontSize: AppDimensions.fontBody,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SEARCH FIELD - حقل بحث موحد
// ============================================================================

/// حقل بحث موحد بتصميم app_store
class MbuySearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry padding;

  const MbuySearchField({
    super.key,
    this.controller,
    this.hintText = 'ابحث...',
    this.onChanged,
    this.onClear,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? AppTheme.cardColorDark : Colors.white;
    final borderColor = isDark ? AppTheme.cardBorderDark : AppTheme.borderColor;
    final textColor = isDark
        ? AppTheme.textPrimaryColorDark
        : AppTheme.textPrimaryColor;
    final hintColor = isDark
        ? AppTheme.textHintColorDark
        : AppTheme.textHintColor;

    return Padding(
      padding: padding,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: TextField(
          controller: controller,
          style: TextStyle(
            color: textColor,
            fontSize: AppDimensions.fontSubtitle,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: hintColor,
              fontSize: AppDimensions.fontSubtitle,
            ),
            prefixIcon: Icon(Icons.search, color: hintColor, size: 22),
            suffixIcon: controller?.text.isNotEmpty == true
                ? IconButton(
                    onPressed: () {
                      controller?.clear();
                      onClear?.call();
                    },
                    icon: Icon(Icons.close, color: hintColor, size: 20),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ============================================================================
// SEGMENTED TABS - تبويبات مقسمة
// ============================================================================

/// تبويبات مقسمة (مثل فلتر الوقت)
class MbuySegmentedTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry padding;

  const MbuySegmentedTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.primaryColor;

    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onChanged(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDimensions.fontBody,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.grey[600]),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================================
// CHIP FILTER - فلتر chips
// ============================================================================

/// فلتر chips أفقي (مثل التصنيفات)
class MbuyChipFilter extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry padding;

  const MbuyChipFilter({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.primaryColor;

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onChanged(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.white),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : AppTheme.borderColor),
                    width: 1,
                  ),
                ),
                child: Text(
                  items[index],
                  style: TextStyle(
                    fontSize: AppDimensions.fontBody,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? Colors.white70
                              : AppTheme.textSecondaryColor),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// LIST CARD - بطاقة قائمة
// ============================================================================

/// بطاقة قائمة موحدة (مثل عنصر في قائمة)
class MbuyListCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;

  const MbuyListCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.margin,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? AppTheme.cardColorDark : Colors.white;
    final borderColor = isDark ? AppTheme.cardBorderDark : AppTheme.borderColor;
    final textColor = isDark
        ? AppTheme.textPrimaryColorDark
        : AppTheme.textPrimaryColor;
    final secondaryTextColor = isDark
        ? AppTheme.textSecondaryColorDark
        : AppTheme.textSecondaryColor;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                leading,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: AppDimensions.fontTitle,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: AppDimensions.fontBody2,
                            color: secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STAT CARD - بطاقة إحصائيات
// ============================================================================

/// بطاقة إحصائيات (مثل بطاقات KPI)
class MbuyStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const MbuyStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.primaryColor;

    final cardColor = isDark ? AppTheme.cardColorDark : Colors.white;
    final borderColor = isDark ? AppTheme.cardBorderDark : AppTheme.borderColor;
    final textColor = isDark
        ? AppTheme.textPrimaryColorDark
        : AppTheme.textPrimaryColor;
    final secondaryTextColor = isDark
        ? AppTheme.textSecondaryColorDark
        : AppTheme.textSecondaryColor;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppDimensions.fontBody,
                        color: secondaryTextColor,
                      ),
                    ),
                    if (icon != null)
                      MbuyIconBox(
                        icon: icon!,
                        size: 36,
                        iconSize: 18,
                        backgroundColor: (iconColor ?? primaryColor).withValues(
                          alpha: 0.1,
                        ),
                        iconColor: iconColor ?? primaryColor,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppDimensions.fontH2,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: AppDimensions.fontBody2,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ICON BOX - مربع أيقونة ناعم
// ============================================================================

/// مربع أيقونة ناعم (نفس تصميم app_store)
class MbuyIconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;

  const MbuyIconBox({
    super.key,
    required this.icon,
    this.size = 48,
    this.iconSize = 24,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primaryColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(icon, color: iconColor ?? primaryColor, size: iconSize),
    );
  }
}

// ============================================================================
// BADGE - شارة
// ============================================================================

/// شارة صغيرة (PRO, جديد, etc.)
class MbuyBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color? textColor;

  const MbuyBadge({
    super.key,
    required this.text,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد لون النص تلقائياً بناء على لمعان اللون
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final defaultTextColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor ?? defaultTextColor,
        ),
      ),
    );
  }
}

// ============================================================================
// RATING - تقييم
// ============================================================================

/// عرض التقييم بالنجوم
class MbuyRating extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double starSize;

  const MbuyRating({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.textPrimaryColor;
    final mutedColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : AppTheme.textHintColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppTheme.ratingStarColor,
          size: starSize,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: AppDimensions.fontBody,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 8),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: AppDimensions.fontLabel,
              color: mutedColor,
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================================================
// QUICK ACTION BUTTON - زر إجراء سريع
// ============================================================================

/// زر إجراء سريع (مثل أزرار Header)
class MbuyQuickActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final bool isHighlighted;

  const MbuyQuickActionButton({
    super.key,
    required this.icon,
    this.label,
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.primaryColor;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: label != null ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isHighlighted
              ? primaryColor.withValues(alpha: 0.15)
              : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted
                ? primaryColor.withValues(alpha: 0.3)
                : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppTheme.borderColor),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isHighlighted
                  ? primaryColor
                  : (isDark ? Colors.white : AppTheme.textSecondaryColor),
              size: 18,
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label!,
                style: TextStyle(
                  fontSize: AppDimensions.fontBody,
                  fontWeight: FontWeight.w600,
                  color: isHighlighted
                      ? primaryColor
                      : (isDark ? Colors.white : AppTheme.textSecondaryColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PAGE HEADER - هيدر الصفحة
// ============================================================================

/// هيدر صفحة موحد
class MbuyPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const MbuyPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.textPrimaryColor;
    final secondaryTextColor = isDark
        ? Colors.white.withValues(alpha: 0.7)
        : AppTheme.textSecondaryColor;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // زر الرجوع
          if (onBack != null)
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onBack?.call();
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : AppTheme.borderColor,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: textColor,
                  size: 18,
                ),
              ),
            ),
          if (onBack != null) const SizedBox(width: 16),
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDimensions.fontH2,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: AppDimensions.fontBody,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // الإجراءات
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

// ============================================================================
// CAROUSEL INDICATORS - مؤشرات الكاروسيل
// ============================================================================

/// مؤشرات الكاروسيل
class MbuyCarouselIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;

  const MbuyCarouselIndicators({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.primaryColor;
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.2)
        : AppTheme.borderColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentIndex == index ? primaryColor : inactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
