import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================================
/// Base Screen Widget - شاشة أساسية موحدة
/// ============================================================================
///
/// هذا الـ Widget يوفر قالب موحد لجميع الشاشات الفرعية في التطبيق
/// يقلل من تكرار الكود ويضمن تناسق التصميم
///
/// الميزات:
/// - AppBar موحد مع زر رجوع
/// - دعم حالة التحميل
/// - دعم حالة الخطأ
/// - دعم حالة البيانات الفارغة
/// - Pull to Refresh
/// - FAB اختياري

/// أنواع حالات الشاشة
enum ScreenState { loading, loaded, empty, error }

/// شاشة أساسية موحدة
class BaseScreen extends StatelessWidget {
  /// عنوان الشاشة
  final String title;

  /// محتوى الشاشة الرئيسي
  final Widget body;

  /// حالة الشاشة الحالية
  final ScreenState state;

  /// رسالة الخطأ (إذا كانت الحالة error)
  final String? errorMessage;

  /// دالة إعادة المحاولة
  final VoidCallback? onRetry;

  /// دالة التحديث (Pull to Refresh)
  final Future<void> Function()? onRefresh;

  /// أيقونة الحالة الفارغة
  final IconData? emptyIcon;

  /// عنوان الحالة الفارغة
  final String? emptyTitle;

  /// وصف الحالة الفارغة
  final String? emptySubtitle;

  /// زر إجراء في الحالة الفارغة
  final Widget? emptyAction;

  /// أزرار في AppBar
  final List<Widget>? actions;

  /// FAB
  final Widget? floatingActionButton;

  /// موقع FAB
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// شريط سفلي
  final Widget? bottomNavigationBar;

  /// لون الخلفية
  final Color? backgroundColor;

  /// إظهار AppBar
  final bool showAppBar;

  /// إظهار زر الرجوع
  final bool showBackButton;

  /// عرض العنوان في المنتصف
  final bool centerTitle;

  /// Padding للمحتوى
  final EdgeInsetsGeometry? padding;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.state = ScreenState.loaded,
    this.errorMessage,
    this.onRetry,
    this.onRefresh,
    this.emptyIcon,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyAction,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.showAppBar = true,
    this.showBackButton = true,
    this.centerTitle = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppTheme.backgroundColor,
      appBar: showAppBar ? _buildAppBar(context) : null,
      body: _buildBody(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.surfaceColor,
      foregroundColor: AppTheme.textPrimaryColor,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      toolbarHeight: AppDimensions.appBarHeight,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimensions.iconM,
                color: AppTheme.primaryColor,
              ),
              onPressed: () => context.pop(),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppDimensions.fontHeadline,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      actions: actions,
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget content;

    switch (state) {
      case ScreenState.loading:
        content = const _LoadingState();
        break;
      case ScreenState.error:
        content = _ErrorState(
          message: errorMessage ?? 'حدث خطأ غير متوقع',
          onRetry: onRetry,
        );
        break;
      case ScreenState.empty:
        content = _EmptyState(
          icon: emptyIcon ?? Icons.inbox_outlined,
          title: emptyTitle ?? 'لا توجد بيانات',
          subtitle: emptySubtitle,
          action: emptyAction,
        );
        break;
      case ScreenState.loaded:
        content = padding != null
            ? Padding(padding: padding!, child: body)
            : body;
        break;
    }

    if (onRefresh != null && state == ScreenState.loaded) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        color: AppTheme.primaryColor,
        child: content,
      );
    }

    return content;
  }
}

/// حالة التحميل
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryColor),
          SizedBox(height: AppDimensions.spacing16),
          Text(
            'جاري التحميل...',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: AppDimensions.fontBody,
            ),
          ),
        ],
      ),
    );
  }
}

/// حالة الخطأ
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: AppDimensions.iconDisplay,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            const Text(
              'حدث خطأ!',
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              message,
              style: const TextStyle(
                fontSize: AppDimensions.fontBody,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacing24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing24,
                    vertical: AppDimensions.spacing12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// حالة البيانات الفارغة
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const _EmptyState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconDisplay,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppDimensions.fontTitle,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
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
            if (action != null) ...[
              const SizedBox(height: AppDimensions.spacing24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// شاشة فرعية بسيطة مع هيدر
class SubPageScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const SubPageScreen({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimensions.iconS,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          if (actions != null && actions!.isNotEmpty)
            Row(children: actions!)
          else
            const SizedBox(
              width: AppDimensions.iconM + AppDimensions.spacing16,
            ),
        ],
      ),
    );
  }
}

/// شاشة قيد التطوير
class ComingSoonScreen extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;

  const ComingSoonScreen({
    super.key,
    required this.title,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SubPageScreen(
      title: title,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacing24),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.construction_outlined,
                  size: AppDimensions.iconDisplay,
                  color: AppTheme.accentColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppDimensions.fontHeadline,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing12),
              Text(
                description ?? 'هذه الصفحة قيد التطوير\nسيتم إطلاقها قريباً',
                style: const TextStyle(
                  fontSize: AppDimensions.fontBody,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing32),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing16,
                  vertical: AppDimensions.spacing8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.1),
                  borderRadius: AppDimensions.borderRadiusM,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: AppDimensions.iconS,
                      color: AppTheme.accentColor,
                    ),
                    SizedBox(width: AppDimensions.spacing8),
                    Text(
                      'قريباً',
                      style: TextStyle(
                        fontSize: AppDimensions.fontCaption,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
