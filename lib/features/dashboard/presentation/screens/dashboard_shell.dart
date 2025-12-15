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
      extendBody: true, // Important: allows FAB to extend above nav bar
      bottomNavigationBar: _buildCustomBottomNav(context, currentIndex),
    );
  }

  Widget _buildCustomBottomNav(BuildContext context, int currentIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 12, right: 12),
      child: SizedBox(
        height:
            AppDimensions.bottomNavHeight + 36, // Extra height for FAB overflow
        child: Stack(
          clipBehavior: Clip.none, // Allow FAB to overflow
          children: [
            // Glass Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 28, // Move nav bar down to align with FAB top
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: AppDimensions.bottomNavHeight + 10,
                    decoration: BoxDecoration(
                      // Glassmorphism effect
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 25,
                          offset: const Offset(0, -8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
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
                          const SizedBox(width: 70),
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
                  ),
                ),
              ),
            ),
            // Floating Action Button (FAB) - Elevated above nav bar
            Positioned(
              top: 2,
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
                      border: Border.all(color: Colors.white, width: 3.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.5),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ],
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
      child: Semantics(
        button: true,
        label: label,
        selected: isSelected,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                size: 28, // Bigger icon size
                color: isSelected
                    ? AppTheme
                          .primaryColor // Blue (#2563EB) - Active icon
                    : Colors.grey[800], // Darker for better contrast
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11, // Slightly smaller for long text
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? AppTheme
                            .primaryColor // Blue (#2563EB)
                      : Colors.grey[800], // Darker text for better readability
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
