import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================================
/// MbuyUnifiedEmptyState - حالة فارغة موحدة
/// ============================================================================
///
/// يوفر:
/// - تصميم موحد لجميع حالات الفراغ
/// - دعم الأيقونات SVG و Material
/// - زر إجراء اختياري
/// - animations عند الظهور
/// - دعم RTL
///
/// أنواع الاستخدام:
/// ```dart
/// MbuyUnifiedEmptyState.noData(
///   title: 'لا توجد منتجات',
///   onAction: () => addProduct(),
/// )
///
/// MbuyUnifiedEmptyState.noResults(
///   title: 'لا توجد نتائج',
///   subtitle: 'جرب البحث بكلمات أخرى',
/// )
///
/// MbuyUnifiedEmptyState.error(
///   title: 'حدث خطأ',
///   onRetry: () => reload(),
/// )
/// ```

/// أنواع حالات الفراغ
enum EmptyStateType {
  noData,
  noResults,
  noConnection,
  error,
  maintenance,
  comingSoon,
  custom,
}

class MbuyUnifiedEmptyState extends StatefulWidget {
  /// العنوان الرئيسي
  final String title;

  /// العنوان الفرعي (اختياري)
  final String? subtitle;

  /// أيقونة Material (تُستخدم إذا لم يتم تحديد svgIcon)
  final IconData? icon;

  /// مسار أيقونة SVG (الأولوية على icon)
  final String? svgIcon;

  /// لون الأيقونة
  final Color? iconColor;

  /// لون خلفية الأيقونة
  final Color? iconBackgroundColor;

  /// نص زر الإجراء
  final String? actionLabel;

  /// دالة زر الإجراء
  final VoidCallback? onAction;

  /// نص زر ثانوي
  final String? secondaryActionLabel;

  /// دالة الزر الثانوي
  final VoidCallback? onSecondaryAction;

  /// حجم الأيقونة
  final double iconSize;

  /// نوع الحالة (للتخصيص التلقائي)
  final EmptyStateType type;

  /// تفعيل الـ animation
  final bool animate;

  /// widget مخصص بدلاً من الأيقونة
  final Widget? customIcon;

  const MbuyUnifiedEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.svgIcon,
    this.iconColor,
    this.iconBackgroundColor,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconSize = 48,
    this.type = EmptyStateType.custom,
    this.animate = true,
    this.customIcon,
  });

  /// حالة لا توجد بيانات
  factory MbuyUnifiedEmptyState.noData({
    Key? key,
    required String title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return MbuyUnifiedEmptyState(
      key: key,
      title: title,
      subtitle: subtitle ?? 'لم يتم العثور على أي عناصر',
      icon: Icons.inbox_outlined,
      actionLabel: actionLabel,
      onAction: onAction,
      type: EmptyStateType.noData,
    );
  }

  /// حالة لا توجد نتائج بحث
  factory MbuyUnifiedEmptyState.noResults({
    Key? key,
    required String title,
    String? subtitle,
    VoidCallback? onClear,
  }) {
    return MbuyUnifiedEmptyState(
      key: key,
      title: title,
      subtitle: subtitle ?? 'جرب البحث بكلمات مختلفة',
      icon: Icons.search_off_outlined,
      actionLabel: onClear != null ? 'مسح البحث' : null,
      onAction: onClear,
      type: EmptyStateType.noResults,
    );
  }

  /// حالة لا يوجد اتصال
  factory MbuyUnifiedEmptyState.noConnection({
    Key? key,
    String? title,
    String? subtitle,
    VoidCallback? onRetry,
  }) {
    return MbuyUnifiedEmptyState(
      key: key,
      title: title ?? 'لا يوجد اتصال بالإنترنت',
      subtitle: subtitle ?? 'تحقق من اتصالك وحاول مرة أخرى',
      icon: Icons.wifi_off_outlined,
      iconColor: AppTheme.warningColor,
      actionLabel: 'إعادة المحاولة',
      onAction: onRetry,
      type: EmptyStateType.noConnection,
    );
  }

  /// حالة خطأ
  factory MbuyUnifiedEmptyState.error({
    Key? key,
    String? title,
    String? subtitle,
    VoidCallback? onRetry,
  }) {
    return MbuyUnifiedEmptyState(
      key: key,
      title: title ?? 'حدث خطأ',
      subtitle: subtitle ?? 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى',
      icon: Icons.error_outline,
      iconColor: AppTheme.errorColor,
      actionLabel: 'إعادة المحاولة',
      onAction: onRetry,
      type: EmptyStateType.error,
    );
  }

  /// حالة صيانة
  factory MbuyUnifiedEmptyState.maintenance({
    Key? key,
    String? title,
    String? subtitle,
  }) {
    return MbuyUnifiedEmptyState(
      key: key,
      title: title ?? 'جاري الصيانة',
      subtitle: subtitle ?? 'نعمل على تحسين الخدمة. عد قريباً!',
      icon: Icons.construction_outlined,
      iconColor: AppTheme.warningColor,
      type: EmptyStateType.maintenance,
    );
  }

  /// حالة قريباً
  factory MbuyUnifiedEmptyState.comingSoon({
    Key? key,
    String? title,
    String? subtitle,
  }) {
    return MbuyUnifiedEmptyState(
      key: key,
      title: title ?? 'قريباً',
      subtitle: subtitle ?? 'هذه الميزة قيد التطوير',
      icon: Icons.rocket_launch_outlined,
      iconColor: AppTheme.infoColor,
      type: EmptyStateType.comingSoon,
    );
  }

  @override
  State<MbuyUnifiedEmptyState> createState() => _MbuyUnifiedEmptyStateState();
}

class _MbuyUnifiedEmptyStateState extends State<MbuyUnifiedEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _iconColor {
    if (widget.iconColor != null) return widget.iconColor!;

    switch (widget.type) {
      case EmptyStateType.error:
        return AppTheme.errorColor;
      case EmptyStateType.noConnection:
      case EmptyStateType.maintenance:
        return AppTheme.warningColor;
      case EmptyStateType.comingSoon:
        return AppTheme.infoColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  Color get _iconBgColor {
    return widget.iconBackgroundColor ?? _iconColor.withValues(alpha: 0.1);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // الأيقونة
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildIcon(),
                ),
                const SizedBox(height: AppDimensions.spacing24),

                // العنوان
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontDisplay3,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                // العنوان الفرعي
                if (widget.subtitle != null) ...[
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    widget.subtitle!,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontBody,
                      color: AppTheme.textSecondaryColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                // الأزرار
                if (widget.actionLabel != null || widget.secondaryActionLabel != null) ...[
                  const SizedBox(height: AppDimensions.spacing24),
                  _buildActions(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.customIcon != null) {
      return widget.customIcon!;
    }

    return Container(
      width: widget.iconSize * 2,
      height: widget.iconSize * 2,
      decoration: BoxDecoration(
        color: _iconBgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: widget.svgIcon != null
            ? SvgPicture.asset(
                widget.svgIcon!,
                width: widget.iconSize,
                height: widget.iconSize,
                colorFilter: ColorFilter.mode(_iconColor, BlendMode.srcIn),
              )
            : Icon(
                widget.icon ?? Icons.inbox_outlined,
                size: widget.iconSize,
                color: _iconColor,
              ),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        if (widget.actionLabel != null)
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: widget.onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing24,
                  vertical: AppDimensions.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusM,
                ),
              ),
              child: Text(
                widget.actionLabel!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        if (widget.secondaryActionLabel != null) ...[
          const SizedBox(height: AppDimensions.spacing12),
          TextButton(
            onPressed: widget.onSecondaryAction,
            child: Text(
              widget.secondaryActionLabel!,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Empty State بسيط للقوائم
class SimpleEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const SimpleEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppTheme.textHintColor,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              message,
              style: const TextStyle(
                fontSize: AppDimensions.fontBody,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: AppDimensions.spacing16),
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
