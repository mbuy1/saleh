import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';

/// Scaffold موحد للصفحات الفرعية
/// يضمن توحيد تصميم زر العودة وتجنب مشكلة البار السفلي
class SubPageScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showSearchBar;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;

  const SubPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showSearchBar = false,
    this.onSearchChanged,
    this.searchHint,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppTheme.backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: SafeArea(
        bottom: false, // لا نضيف padding من الأسفل - لتجنب مشكلة البار السفلي
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // شريط البحث (اختياري)
            if (showSearchBar) _buildSearchBar(),
            // المحتوى الرئيسي
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 90, // مسافة للبار السفلي
                ),
                child: body,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          // زر العودة
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
          // العنوان
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          // الأزرار الإضافية
          if (actions != null && actions!.isNotEmpty)
            ...actions!
          else
            // مساحة فارغة لتوازن العنوان
            const SizedBox(
              width: AppDimensions.iconM + AppDimensions.spacing16,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: searchHint ?? 'البحث...',
            hintStyle: TextStyle(color: AppTheme.textHintColor),
            prefixIcon: Icon(Icons.search, color: AppTheme.textHintColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing12,
            ),
          ),
        ),
      ),
    );
  }
}

/// Header موحد للصفحات الفرعية (يمكن استخدامه منفصلاً)
class SubPageHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const SubPageHeader({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackPressed ?? () => context.pop(),
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
            ...actions!
          else
            const SizedBox(
              width: AppDimensions.iconM + AppDimensions.spacing16,
            ),
        ],
      ),
    );
  }
}
