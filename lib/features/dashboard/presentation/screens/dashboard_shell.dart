import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   شريط التنقل السفلي - التصميم مثبت ومعتمد                                ║
// ║   تاريخ التثبيت: 14 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   العناصر المثبتة:                                                        ║
// ║   • 5 تبويبات: الرئيسية، الطلبات، +، المحادثات، المتجر                    ║
// ║   • زر + بتدرج معدني (metallicGradient)                                   ║
// ║   • الأيقونة النشطة: primaryColor                                         ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل التصميم إلا بطلب صريح وواضح من المالك                     ║
// ║   ⛔ DO NOT MODIFY design without EXPLICIT owner request                  ║
// ║                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// Dashboard Shell - يحتوي على البار السفلي الثابت
/// يعرض الصفحات الفرعية داخله مع إبقاء البار السفلي ظاهراً
/// التبويبات: الرئيسية، الطلبات، +، المحادثات، المتجر
///
/// 🔒 LOCKED DESIGN - تصميم مثبت
/// Last updated: 2025-12-14
class DashboardShell extends StatefulWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  /// الحصول على الـ index الحالي بناءً على المسار
  /// الترتيب: الرئيسية(0)، الطلبات(1)، +(2)، المحادثات(3)، المتجر(4)
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/dashboard/orders')) return 1;
    if (location.startsWith('/dashboard/products')) {
      return 2; // زر + يظهر المنتجات
    }
    if (location.startsWith('/dashboard/conversations')) return 3;
    if (location.startsWith('/dashboard/store')) return 4;
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
        // زر + يفتح صفحة المنتجات
        context.go('/dashboard/products');
        break;
      case 3:
        context.go('/dashboard/conversations');
        break;
      case 4:
        context.go('/dashboard/store');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: AppTheme.surfaceColor),
        child: NavigationBar(
          height: AppDimensions.bottomNavHeight,
          backgroundColor: AppTheme.surfaceColor,
          surfaceTintColor: Colors.transparent,
          indicatorColor: AppTheme.primaryColor.withValues(alpha: 0.15),
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _onItemTapped(index, context),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            // 1. الرئيسية
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                size: AppDimensions.iconM,
                color: AppTheme.textSecondaryColor,
              ),
              selectedIcon: Icon(
                Icons.home,
                size: AppDimensions.iconM,
                color: AppTheme.primaryColor,
              ),
              label: 'الرئيسية',
            ),
            // 2. الطلبات
            NavigationDestination(
              icon: Icon(
                Icons.shopping_bag_outlined,
                size: AppDimensions.iconM,
                color: AppTheme.textSecondaryColor,
              ),
              selectedIcon: Icon(
                Icons.shopping_bag,
                size: AppDimensions.iconM,
                color: AppTheme.primaryColor,
              ),
              label: 'الطلبات',
            ),
            // 3. زر + (المنتجات) - Meta AI Gradient
            NavigationDestination(
              icon: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppTheme.metallicGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
              selectedIcon: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppTheme.metallicGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
              label: '',
            ),
            // 4. المحادثات
            NavigationDestination(
              icon: Icon(
                Icons.chat_bubble_outline,
                size: AppDimensions.iconM,
                color: AppTheme.textSecondaryColor,
              ),
              selectedIcon: Icon(
                Icons.chat_bubble,
                size: AppDimensions.iconM,
                color: AppTheme.primaryColor,
              ),
              label: 'المحادثات',
            ),
            // 5. المتجر
            NavigationDestination(
              icon: Icon(
                Icons.store_outlined,
                size: AppDimensions.iconM,
                color: AppTheme.textSecondaryColor,
              ),
              selectedIcon: Icon(
                Icons.store,
                size: AppDimensions.iconM,
                color: AppTheme.primaryColor,
              ),
              label: 'المتجر',
            ),
          ],
        ),
      ),
    );
  }
}
