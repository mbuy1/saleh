import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../merchant/data/merchant_store_provider.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   شريط التنقل السفلي + الهيدر العلوي - التصميم مثبت ومعتمد                ║
// ║   تاريخ التثبيت: 25 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   العناصر المثبتة:                                                        ║
// ║   • 4 تبويبات: الرئيسية، الطلبات، المنتجات، استديو AI                   ║
// ║   • الأيقونة النشطة: primaryColor (Oxford Blue #00214A)                   ║
// ║   • الهيدر العلوي الثابت مع Oxford Blue                                   ║
// ║   • شريط الحالة بأيقونات بيضاء                                            ║
// ║   • المحادثات: الوصول عبر أيقونة الإشعارات في الهيدر                     ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل التصميم إلا بطلب صريح وواضح من المالك                     ║
// ║   ⛔ DO NOT MODIFY design without EXPLICIT owner request                  ║
// ║                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// Dashboard Shell - يحتوي على البار السفلي الثابت والهيدر العلوي
/// يعرض الصفحات الفرعية داخله مع إبقاء البار السفلي والهيدر العلوي ظاهراً
/// التبويبات: الرئيسية، الطلبات، المنتجات، استديو AI
/// المحادثات: متاحة عبر أيقونة الإشعارات في الهيدر العلوي
///
/// 🔒 LOCKED DESIGN - تصميم مثبت
/// Last updated: 2025-12-25
/// تم تقليص البار السفلي إلى 4 تبويبات ونقل المحادثات للهيدر
class DashboardShell extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  ConsumerState<DashboardShell> createState() => _DashboardShellState();
}

/// Adaptive Breakpoints
enum ScreenSize {
  mobile, // < 600
  tablet, // 600-900
  desktop, // 900-1200
  large, // > 1200
}

class _DashboardShellState extends ConsumerState<DashboardShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // ضبط ألوان شريط الحالة مرة واحدة عند الإنشاء
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // أيقونات بيضاء
        statusBarBrightness: Brightness.dark, // للـ iOS
      ),
    );
  }

  /// تحديد حجم الشاشة الحالي
  ScreenSize _getScreenSize(double width) {
    if (width < 600) return ScreenSize.mobile;
    if (width < 900) return ScreenSize.tablet;
    if (width < 1200) return ScreenSize.desktop;
    return ScreenSize.large;
  }

  /// Adaptive Density - المسافات حسب حجم الشاشة
  double _getPadding(ScreenSize size) {
    switch (size) {
      case ScreenSize.mobile:
        return 12.0;
      case ScreenSize.tablet:
        return 16.0;
      case ScreenSize.desktop:
        return 20.0;
      case ScreenSize.large:
        return 24.0;
    }
  }

  /// Adaptive Icon Size
  double _getIconSize(ScreenSize size) {
    switch (size) {
      case ScreenSize.mobile:
        return 22.0;
      case ScreenSize.tablet:
        return 24.0;
      case ScreenSize.desktop:
      case ScreenSize.large:
        return 26.0;
    }
  }

  /// Adaptive Font Size
  double _getFontSize(ScreenSize size) {
    switch (size) {
      case ScreenSize.mobile:
        return 12.0;
      case ScreenSize.tablet:
        return 13.0;
      case ScreenSize.desktop:
      case ScreenSize.large:
        return 14.0;
    }
  }

  void _openAllMenu() {
    HapticFeedback.lightImpact();
    context.push('/dashboard/all-menu');
  }

  /// الحصول على الـ index الحالي بناءً على المسار
  /// الترتيب: الرئيسية(0)، الطلبات(1)، المنتجات(2)، استديو AI(3)
  /// المحادثات: لا تظهر في البار السفلي (الوصول عبر الإشعارات)
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/dashboard/orders')) return 1;
    if (location.startsWith('/dashboard/products')) {
      return 2; // صفحة المنتجات
    }
    if (location.startsWith('/dashboard/studio') ||
        location.startsWith('/dashboard/content-studio')) {
      return 3; // استديو AI في البار السفلي
    }
    // المحادثات لا تظهر في البار السفلي
    return 0; // home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/dashboard/orders');
        break;
      case 2:
        // صفحة المنتجات
        context.go('/dashboard/products');
        break;
      case 3:
        // استديو AI في البار السفلي
        context.go('/dashboard/studio');
        break;
    }
  }

  void _openSearch(BuildContext context) {
    HapticFeedback.lightImpact();
    context.push('/dashboard/search');
  }

  /// عرض صفحة إضافة منتج
  void _showProductTypeSelection(BuildContext context) {
    HapticFeedback.lightImpact();
    context.push('/dashboard/add-product');
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final storeAsync = ref.watch(merchantStoreControllerProvider);
    final store = storeAsync.hasValue ? storeAsync.value : null;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenSize = _getScreenSize(screenWidth);
    final useSideNav = screenSize != ScreenSize.mobile;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        body: Row(
          textDirection: TextDirection.rtl,
          children: [
            // NavigationRail للديسكتوب والتابلت
            if (useSideNav)
              _buildNavigationRail(context, currentIndex, screenSize),
            // المحتوى الرئيسي
            Expanded(
              child: Column(
                children: [
                  _buildPersistentHeader(
                    context,
                    store?.name ?? 'mbuy',
                    screenSize,
                  ),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
        // BottomNavigationBar للموبايل فقط
        bottomNavigationBar: !useSideNav
            ? _buildCustomBottomNav(context, currentIndex, screenSize)
            : null,
      ),
    );
  }

  /// الهيدر العلوي الثابت - اللون الأساسي
  Widget _buildPersistentHeader(
    BuildContext context,
    String storeName,
    ScreenSize screenSize,
  ) {
    final topPadding = MediaQuery.of(context).padding.top;
    final padding = _getPadding(screenSize);
    final iconSize = _getIconSize(screenSize);
    final isDesktop = screenSize != ScreenSize.mobile;

    // اللون الأساسي للهيدر (Teal Green)
    const Color headerColor = AppTheme.primaryColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + padding * 0.7,
        bottom: padding,
        left: padding,
        right: padding,
      ),
      decoration: const BoxDecoration(color: headerColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // الجانب الأيسر - أزرار الإجراءات
          Row(
            children: [
              _buildHeaderButton(
                Icons.search,
                () => _openSearch(context),
                iconSize,
              ),
              _buildHeaderButton(
                Icons.smart_toy_outlined,
                () => context.push('/dashboard/ai-assistant'),
                iconSize,
              ),
              _buildHeaderButton(
                Icons.notifications_outlined,
                () => context.push('/dashboard/notifications'),
                iconSize,
              ),
              _buildHeaderButton(
                Icons.bolt,
                () => context.push('/dashboard/shortcuts'),
                iconSize,
              ),
              _buildHeaderButton(
                Icons.add,
                () => _showProductTypeSelection(context),
                iconSize,
              ),
            ],
          ),
          // الجانب الأيمن - اسم المتجر والشعار
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/dashboard/view-store'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض متجري',
                          style: TextStyle(
                            fontSize: AppDimensions.fontCaption,
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.visibility,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // أيقونة المتجر - تفتح القائمة في الموبايل
              if (!isDesktop)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _openAllMenu();
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.storefront,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(
    IconData icon,
    VoidCallback onTap,
    double iconSize,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: iconSize * 0.27),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }

  Widget _buildCustomBottomNav(
    BuildContext context,
    int currentIndex,
    ScreenSize screenSize,
  ) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconSize = _getIconSize(screenSize);
    final fontSize = _getFontSize(screenSize);
    final navHeight = screenSize == ScreenSize.mobile ? 65.0 : 70.0;

    return Container(
      height: navHeight + bottomPadding,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundColorDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: AppIcons.home,
              label: 'الرئيسية',
              isSelected: currentIndex == 0,
              onTap: () => _onItemTapped(0, context),
              isDark: isDark,
              iconSize: iconSize,
              fontSize: fontSize,
            ),
            _buildNavItem(
              icon: AppIcons.orders,
              label: 'الطلبات',
              isSelected: currentIndex == 1,
              onTap: () => _onItemTapped(1, context),
              isDark: isDark,
              iconSize: iconSize,
              fontSize: fontSize,
            ),
            _buildNavItem(
              icon: AppIcons.product,
              label: 'المنتجات',
              isSelected: currentIndex == 2,
              onTap: () => _onItemTapped(2, context),
              isDark: isDark,
              iconSize: iconSize,
              fontSize: fontSize,
            ),
            _buildNavItem(
              icon: AppIcons.studio,
              label: 'استديو AI',
              isSelected: currentIndex == 3,
              onTap: () => _onItemTapped(3, context),
              isDark: isDark,
              iconSize: iconSize,
              fontSize: fontSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required double iconSize,
    required double fontSize,
  }) {
    // استخدام الألوان الموحدة من AppTheme
    final selectedColor = AppTheme.activeColor(isDark);
    final unselectedColor = AppTheme.inactiveColor(isDark);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              size: iconSize,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            SizedBox(height: fontSize * 0.3),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize * 0.92,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// NavigationRail للديسكتوب والتابلت - Adaptive Navigation
  Widget _buildNavigationRail(
    BuildContext context,
    int currentIndex,
    ScreenSize screenSize,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final padding = _getPadding(screenSize);
    final iconSize = _getIconSize(screenSize);
    final fontSize = _getFontSize(screenSize);
    final isExtended = screenSize == ScreenSize.large;

    // استخدام الألوان الموحدة
    final selectedColor = AppTheme.activeColor(isDark);
    final unselectedColor = AppTheme.inactiveColor(isDark);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundColorDark : Colors.white,
        border: Border(
          left: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: NavigationRail(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _onItemTapped(index, context),
        extended: isExtended,
        labelType: isExtended
            ? NavigationRailLabelType.none
            : NavigationRailLabelType.all,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(color: selectedColor, size: iconSize),
        unselectedIconTheme: IconThemeData(
          color: unselectedColor,
          size: iconSize,
        ),
        selectedLabelTextStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: selectedColor,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: fontSize * 0.92,
          fontWeight: FontWeight.w500,
          color: unselectedColor,
        ),
        minWidth: screenSize == ScreenSize.tablet ? 72 : 80,
        minExtendedWidth: 200,
        destinations: [
          NavigationRailDestination(
            icon: AppIcon(AppIcons.home, size: iconSize),
            selectedIcon: AppIcon(
              AppIcons.home,
              size: iconSize,
              color: selectedColor,
            ),
            label: const Text('الرئيسية'),
            padding: EdgeInsets.symmetric(vertical: padding * 0.8),
          ),
          NavigationRailDestination(
            icon: AppIcon(AppIcons.orders, size: iconSize),
            selectedIcon: AppIcon(
              AppIcons.orders,
              size: iconSize,
              color: selectedColor,
            ),
            label: const Text('الطلبات'),
            padding: EdgeInsets.symmetric(vertical: padding * 0.8),
          ),
          NavigationRailDestination(
            icon: AppIcon(AppIcons.product, size: iconSize),
            selectedIcon: AppIcon(
              AppIcons.product,
              size: iconSize,
              color: selectedColor,
            ),
            label: const Text('المنتجات'),
            padding: EdgeInsets.symmetric(vertical: padding * 0.8),
          ),
          NavigationRailDestination(
            icon: AppIcon(AppIcons.studio, size: iconSize),
            selectedIcon: AppIcon(
              AppIcons.studio,
              size: iconSize,
              color: selectedColor,
            ),
            label: const Text('استديو AI'),
            padding: EdgeInsets.symmetric(vertical: padding * 0.8),
          ),
        ],
      ),
    );
  }
}
