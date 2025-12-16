import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';
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
    this.useSafeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
  });

  /// Whether to wrap body in SafeArea
  final bool useSafeArea;

  /// Whether to respect top safe area (status bar)
  final bool safeAreaTop;

  /// Whether to respect bottom safe area (navigation bar)
  final bool safeAreaBottom;

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = _buildBody(context);

    // Wrap with SafeArea if enabled and no AppBar (AppBar handles top safe area)
    if (useSafeArea) {
      bodyContent = SafeArea(
        top: !showAppBar && safeAreaTop, // AppBar handles top safe area
        bottom: safeAreaBottom,
        child: bodyContent,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppTheme.backgroundColor,
      appBar: showAppBar ? _buildAppBar(context) : null,
      body: bodyContent,
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
              icon: SvgPicture.asset(
                AppIcons.arrowBack,
                width: AppDimensions.iconM,
                height: AppDimensions.iconM,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
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
          iconPath: AppIcons.inbox,
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
              child: SvgPicture.asset(
                AppIcons.error,
                width: AppDimensions.iconDisplay,
                height: AppDimensions.iconDisplay,
                colorFilter: const ColorFilter.mode(
                  Colors.red,
                  BlendMode.srcIn,
                ),
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
                icon: SvgPicture.asset(
                  AppIcons.refresh,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
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
  final String iconPath;
  final String title;
  final String? subtitle;
  final Widget? action;

  const _EmptyState({
    required this.iconPath,
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
              child: SvgPicture.asset(
                iconPath,
                width: AppDimensions.iconDisplay,
                height: AppDimensions.iconDisplay,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
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
              child: SvgPicture.asset(
                AppIcons.arrowBack,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
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
                child: SvgPicture.asset(
                  AppIcons.tools,
                  width: AppDimensions.iconDisplay,
                  height: AppDimensions.iconDisplay,
                  colorFilter: ColorFilter.mode(
                    AppTheme.accentColor,
                    BlendMode.srcIn,
                  ),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppIcons.time,
                      width: AppDimensions.iconS,
                      height: AppDimensions.iconS,
                      colorFilter: const ColorFilter.mode(
                        AppTheme.accentColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing8),
                    const Text(
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
