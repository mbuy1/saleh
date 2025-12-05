import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// BottomNavigationBar مشترك للتنقل بين الشاشات الرئيسية
///
/// يدعم 5 شاشات رئيسية:
/// - HomeScreen (الرئيسية)
/// - ExploreScreen (استكشاف)
/// - StoresScreen (المتاجر)
/// - CartScreen (السلة)
/// - MapScreen (الخريطة)
class SharedBottomNav extends StatelessWidget {
  /// الفهرس الحالي للشاشة النشطة (0-4)
  final int currentIndex;

  /// Callback يتم استدعاؤه عند تغيير الشاشة
  final Function(int) onTap;

  /// عدد العناصر في السلة (لعرض Badge)
  final int cartItemCount;

  const SharedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'الرئيسية',
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'ميديا',
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.store_outlined,
                activeIcon: Icons.store,
                label: 'المتاجر',
              ),
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                label: 'السلة',
                badge: cartItemCount > 0 ? cartItemCount : null,
              ),
              _buildNavItem(
                context: context,
                index: 4,
                icon: Icons.map_outlined,
                activeIcon: Icons.map,
                label: 'الخريطة',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badge,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive
                      ? MbuyColors.primaryMaroon
                      : MbuyColors.textSecondary,
                  size: 26,
                ),
                // Badge للعناصر (مثل السلة)
                if (badge != null && badge > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        badge > 9 ? '9+' : '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? MbuyColors.primaryMaroon
                    : MbuyColors.textSecondary,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation Controller للتنقل بين الشاشات الرئيسية
/// استخدام:
/// ```dart
/// final navController = SharedBottomNavController();
///
/// bottomNavigationBar: SharedBottomNav(
///   currentIndex: navController.currentIndex,
///   onTap: navController.changePage,
/// ),
///
/// body: navController.pages[navController.currentIndex],
/// ```
class SharedBottomNavController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changePage(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// يمكن تعديل هذه القائمة حسب شاشات المشروع
  /// List<Widget> pages = [
  ///   HomeScreen(),
  ///   ExploreScreen(),
  ///   StoresScreen(),
  ///   CartScreen(),
  ///   MapScreen(),
  /// ];
}
