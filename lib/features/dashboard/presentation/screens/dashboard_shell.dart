import 'dart:ui';
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
      bottomNavigationBar: _buildCustomBottomNav(context, currentIndex),
    );
  }

  Widget _buildCustomBottomNav(BuildContext context, int currentIndex) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: AppDimensions.bottomNavHeight + 20, // Extra height for FAB
          decoration: BoxDecoration(
            color: Colors.white, // Full opacity for better visibility
            border: const Border(
              top: BorderSide(
                color: AppTheme.slate300,
                width: 2,
              ), // Thicker border for better visibility
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, -4),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Navigation Icons Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 1. الرئيسية
                    _buildNavIcon(
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home,
                      label: 'الرئيسية',
                      isSelected: currentIndex == 0,
                      onTap: () => _onItemTapped(0, context),
                    ),
                    // 2. الطلبات
                    _buildNavIcon(
                      icon: Icons.shopping_bag_outlined,
                      selectedIcon: Icons.shopping_bag,
                      label: 'الطلبات',
                      isSelected: currentIndex == 1,
                      onTap: () => _onItemTapped(1, context),
                    ),
                    // Spacer for FAB
                    const SizedBox(width: 60),
                    // 4. المحادثات
                    _buildNavIcon(
                      icon: Icons.chat_bubble_outline,
                      selectedIcon: Icons.chat_bubble,
                      label: 'المحادثات',
                      isSelected: currentIndex == 3,
                      onTap: () => _onItemTapped(3, context),
                    ),
                    // 5. دروب شوبينقنا (تم التبديل مع اختصاراتي)
                    _buildNavIcon(
                      icon: Icons.shopping_bag_outlined,
                      selectedIcon: Icons.shopping_bag,
                      label: 'دروب شوبينقنا',
                      isSelected: currentIndex == 4,
                      onTap: () => _onItemTapped(4, context),
                    ),
                  ],
                ),
              ),
              // Floating Action Button (FAB) - Centered
              Positioned(
                top: -20,
                child: GestureDetector(
                  onTap: () => _onItemTapped(2, context),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppTheme.metallicGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(
                            alpha: 0.7,
                          ), // Stronger shadow for better visibility
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                          spreadRadius: 6,
                        ),
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                          spreadRadius: 3,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            size: AppDimensions.iconM,
            color: isSelected
                ? AppTheme
                      .primaryColor // Blue (#2563EB) - Active icon
                : AppTheme.mutedSlate, // Muted Slate (#64748B) - Inactive icons
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? AppTheme
                        .primaryColor // Blue (#2563EB)
                  : AppTheme.mutedSlate, // Muted Slate (#64748B)
            ),
          ),
        ],
      ),
    );
  }
}
