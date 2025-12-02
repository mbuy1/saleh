import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// MbuyAppBar - الـ AppBar المركزي الموحد لجميع شاشات التطبيق
/// ═══════════════════════════════════════════════════════════════════════════
///
/// هذا هو المكان المركزي لأي عنصر مشترك في AppBar جميع الشاشات
/// مثل زر عام، أيقونة، أو أكشن مشترك.
///
/// عند الحاجة لإضافة زر في AppBar جميع الشاشات مستقبلاً، يجب إضافته هنا أولاً.
///
/// الاستخدام:
/// ```dart
/// // AppBar بسيط مع عنوان
/// MbuyAppBar(title: 'الصفحة الرئيسية')
///
/// // AppBar مع Tabs
/// MbuyAppBar(
///   tabController: _tabController,
///   tabs: ['المنتجات', 'الفئات'],
/// )
///
/// // AppBar مع أزرار مخصصة
/// MbuyAppBar(
///   title: 'الإعدادات',
///   leading: IconButton(...),
///   actions: [IconButton(...)],
/// )
///
/// // AppBar مع widget مخصص في المنتصف
/// MbuyAppBar(
///   centerWidget: YourCustomWidget(),
/// )
/// ```
///
/// ═══════════════════════════════════════════════════════════════════════════

class MbuyAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// عنوان الشاشة (نص بسيط)
  final String? title;

  /// Widget مخصص للعنوان (يتجاوز title)
  final Widget? titleWidget;

  /// Widget مخصص في المنتصف (يتجاوز title و titleWidget و tabs)
  final Widget? centerWidget;

  /// TabController للـ Tabs
  final TabController? tabController;

  /// قائمة أسماء الـ Tabs
  final List<String>? tabs;

  /// Widget مخصص لزر البداية (اليسار في LTR، اليمين في RTL)
  final Widget? leading;

  /// هل نعرض زر العودة تلقائياً؟ (افتراضي: حسب Navigator)
  final bool automaticallyImplyLeading;

  /// قائمة الأزرار/الأيقونات في نهاية AppBar
  final List<Widget>? actions;

  /// ارتفاع AppBar (افتراضي: 60)
  final double toolbarHeight;

  /// لون الخلفية (افتراضي: أبيض)
  final Color? backgroundColor;

  /// الارتفاع (elevation) (افتراضي: 0)
  final double elevation;

  /// لون العنوان (افتراضي: textPrimary)
  final Color? titleColor;

  /// حجم خط العنوان (افتراضي: 18)
  final double titleFontSize;

  /// وزن خط العنوان (افتراضي: bold)
  final FontWeight titleFontWeight;

  /// هل العنوان في المنتصف؟ (افتراضي: false)
  final bool centerTitle;

  /// المسافة من البداية (افتراضي: 16)
  final double titleSpacing;

  /// لون Tabs المحددة (افتراضي: textPrimary)
  final Color? selectedTabColor;

  /// لون Tabs غير المحددة (افتراضي: textSecondary)
  final Color? unselectedTabColor;

  /// لون خط المؤشر للـ Tabs (افتراضي: textPrimary)
  final Color? indicatorColor;

  /// سماكة خط المؤشر للـ Tabs (افتراضي: 1.5)
  final double indicatorWeight;

  /// هل Tabs قابلة للتمرير؟ (افتراضي: true)
  final bool isScrollable;

  /// حجم خط الـ Tabs (افتراضي: 16)
  final double tabFontSize;

  /// وزن خط Tab المحددة (افتراضي: bold)
  final FontWeight selectedTabFontWeight;

  /// وزن خط Tab غير المحددة (افتراضي: w500)
  final FontWeight unselectedTabFontWeight;

  /// Padding للـ Tabs (افتراضي: 12 أفقي)
  final EdgeInsets tabPadding;

  /// هل نعرض ProfileButton في البداية؟ (افتراضي: false)
  /// ملاحظة: يظهر في بداية الشاشة (يمين في RTL، يسار في LTR)
  final bool showProfileButton;

  /// Widget مخصص للـ Profile Button (يتجاوز showProfileButton)
  final Widget? customProfileButton;

  const MbuyAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerWidget,
    this.tabController,
    this.tabs,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.toolbarHeight = 60,
    this.backgroundColor,
    this.elevation = 0,
    this.titleColor,
    this.titleFontSize = 18,
    this.titleFontWeight = FontWeight.bold,
    this.centerTitle = false,
    this.titleSpacing = 16,
    this.selectedTabColor,
    this.unselectedTabColor,
    this.indicatorColor,
    this.indicatorWeight = 1.5,
    this.isScrollable = true,
    this.tabFontSize = 16,
    this.selectedTabFontWeight = FontWeight.bold,
    this.unselectedTabFontWeight = FontWeight.w500,
    this.tabPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.showProfileButton = false,
    this.customProfileButton,
  });

  @override
  Widget build(BuildContext context) {
    Widget? finalTitle;

    // إذا كان هناك centerWidget، نستخدمه
    if (centerWidget != null) {
      finalTitle = centerWidget;
    }
    // إذا كان هناك tabs
    else if (tabController != null && tabs != null) {
      finalTitle = _buildTabsSection(context);
    }
    // إذا كان هناك titleWidget
    else if (titleWidget != null) {
      finalTitle = titleWidget;
    }
    // إذا كان هناك title نصي
    else if (title != null) {
      finalTitle = Text(
        title!,
        style: GoogleFonts.cairo(
          fontSize: titleFontSize,
          fontWeight: titleFontWeight,
          color: titleColor ?? MbuyColors.textPrimary,
        ),
      );
    }

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation,
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
      leading: leading,
      title: finalTitle,
      actions: actions,
    );
  }

  Widget _buildTabsSection(BuildContext context) {
    // إذا كان showProfileButton مفعل أو هناك customProfileButton
    final bool hasProfileButton =
        showProfileButton || customProfileButton != null;

    if (hasProfileButton) {
      return Row(
        children: [
          // Profile Button
          if (customProfileButton != null)
            customProfileButton!
          else if (showProfileButton)
            _buildDefaultProfileButton(),

          const SizedBox(width: 16),

          // Tabs
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildTabBar(),
            ),
          ),
        ],
      );
    } else {
      // Tabs فقط بدون Profile Button
      return _buildTabBar();
    }
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: tabController,
      isScrollable: isScrollable,
      indicatorColor: indicatorColor ?? MbuyColors.textPrimary,
      indicatorWeight: indicatorWeight,
      labelColor: selectedTabColor ?? MbuyColors.textPrimary,
      unselectedLabelColor: unselectedTabColor ?? MbuyColors.textSecondary,
      labelPadding: tabPadding,
      labelStyle: GoogleFonts.cairo(
        fontSize: tabFontSize,
        fontWeight: selectedTabFontWeight,
      ),
      unselectedLabelStyle: GoogleFonts.cairo(
        fontSize: tabFontSize,
        fontWeight: unselectedTabFontWeight,
      ),
      tabs: tabs!.map((t) => Tab(text: t)).toList(),
    );
  }

  Widget _buildDefaultProfileButton() {
    // هنا نستورد ProfileButton إذا أردنا استخدامه
    // لكن لتجنب Circular dependency، سنعمل Container بسيط
    // الشاشات يمكنها تمرير customProfileButton
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
