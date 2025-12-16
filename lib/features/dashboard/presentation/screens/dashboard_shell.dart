import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/app_icon.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   شريط التنقل السفلي - التصميم مثبت ومعتمد                                ║
// ║   تاريخ التثبيت: 14 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   العناصر المثبتة:                                                        ║
// ║   • 5 تبويبات: الرئيسية، الطلبات، +، المحادثات، دروب شوبينقنا            ║
// ║   • زر + بتدرج أزرق (metallicGradient)                                    ║
// ║   • الأيقونة النشطة: primaryColor (Blue #2563EB)                          ║
// ║   • تم التبديل بين دروب شوبينقنا واختصاراتي - مثبت                        ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل التصميم إلا بطلب صريح وواضح من المالك                     ║
// ║   ⛔ DO NOT MODIFY design without EXPLICIT owner request                  ║
// ║                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// Dashboard Shell - يحتوي على البار السفلي الثابت
/// يعرض الصفحات الفرعية داخله مع إبقاء البار السفلي ظاهراً
/// التبويبات: الرئيسية، الطلبات، +، المحادثات، دروب شوبينقنا
///
/// 🔒 LOCKED DESIGN - تصميم مثبت
/// Last updated: 2025-12-15
/// تم التبديل بين دروب شوبينقنا واختصاراتي - التصميم مثبت الآن
class DashboardShell extends StatefulWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  /// الحصول على الـ index الحالي بناءً على المسار
  /// الترتيب: الرئيسية(0)، الطلبات(1)، +(2)، المحادثات(3)، دروب شوبينقنا(4)
  /// 🔒 LOCKED - تم التثبيت بعد التبديل بين دروب شوبينقنا واختصاراتي
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/dashboard/orders')) return 1;
    if (location.startsWith('/dashboard/products')) {
      return 2; // زر + يظهر عند صفحة المنتجات
    }
    if (location.startsWith('/dashboard/conversations')) return 3;
    if (location.startsWith('/dashboard/dropshipping')) {
      return 4; // دروب شوبينقنا في البار السفلي
    }
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
        // دروب شوبينقنا في البار السفلي (تم التبديل مع اختصاراتي)
        context.go('/dashboard/dropshipping');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: widget.child,
      extendBody: true, // Important: allows FAB to extend above nav bar
      bottomNavigationBar: _buildCustomBottomNav(context, currentIndex),
    );
  }

  Widget _buildCustomBottomNav(BuildContext context, int currentIndex) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 70 + bottomPadding, // ارتفاع نحيف + SafeArea
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Navigation Bar
            Positioned.fill(
              child: Row(
                children: [
                  // الجزء الأيسر - عنصرين
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(
                          icon: AppIcons.home,
                          label: 'الرئيسية',
                          isSelected: currentIndex == 0,
                          onTap: () => _onItemTapped(0, context),
                        ),
                        _buildNavItem(
                          icon: AppIcons.orders,
                          label: 'الطلبات',
                          isSelected: currentIndex == 1,
                          onTap: () => _onItemTapped(1, context),
                        ),
                      ],
                    ),
                  ),
                  // مساحة للزر المركزي
                  const SizedBox(width: 72),
                  // الجزء الأيمن - عنصرين
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(
                          icon: AppIcons.chat,
                          label: 'المحادثات',
                          isSelected: currentIndex == 3,
                          onTap: () => _onItemTapped(3, context),
                        ),
                        _buildNavItem(
                          icon: AppIcons.shipping,
                          label: 'دروب شيب',
                          isSelected: currentIndex == 4,
                          onTap: () => _onItemTapped(4, context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // زر + في المنتصف
            Positioned(
              top: -20,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => _onItemTapped(2, context),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppTheme.metallicGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AppIcon(AppIcons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),
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
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              size: 24,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
