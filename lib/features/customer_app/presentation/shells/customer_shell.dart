import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// Customer Shell - Bottom Navigation للعميل
/// الترتيب من اليمين لليسار (RTL): ميديا، تصنيفات، الرئيسية، متاجر، السلة
/// ⚠️ هذا الـ Shell خاص بتطبيق العميل فقط
class CustomerShell extends ConsumerWidget {
  final Widget child;

  const CustomerShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current location to determine active tab
    final String location = GoRouterState.of(context).uri.path;
    final int currentIndex = _calculateSelectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // RTL Order: Media, Categories, Home, Stores, Cart
                _buildNavItem(
                  context,
                  icon: Icons.play_circle_outline,
                  activeIcon: Icons.play_circle,
                  label: 'ميديا',
                  index: 0,
                  currentIndex: currentIndex,
                  onTap: () => context.go('/media'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.category_outlined,
                  activeIcon: Icons.category,
                  label: 'تصنيفات',
                  index: 1,
                  currentIndex: currentIndex,
                  onTap: () => context.go('/categories'),
                ),
                _buildHomeButton(
                  context,
                  isActive: currentIndex == 2,
                  onTap: () => context.go('/home'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.store_outlined,
                  activeIcon: Icons.store,
                  label: 'متاجر',
                  index: 3,
                  currentIndex: currentIndex,
                  onTap: () => context.go('/stores'),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart,
                  label: 'السلة',
                  index: 4,
                  currentIndex: currentIndex,
                  onTap: () => context.go('/cart'),
                  showBadge: true,
                  badgeCount: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/media')) return 0;
    if (location.startsWith('/categories')) return 1;
    if (location.startsWith('/home') || location == '/') {
      return 2;
    }
    if (location.startsWith('/stores')) return 3;
    if (location.startsWith('/cart')) return 4;
    return 2; // Default to home
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    final bool isActive = index == currentIndex;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
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
                  color: isActive ? AppTheme.primaryColor : Colors.grey[500],
                  size: 24,
                ),
                if (showBadge && badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badgeCount > 9 ? '9+' : '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? AppTheme.primaryColor : Colors.grey[500],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton(
    BuildContext context, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? [AppTheme.primaryColor, AppTheme.secondaryColor]
                : [Colors.grey[400]!, Colors.grey[500]!],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isActive ? AppTheme.primaryColor : Colors.grey)
                  .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.home, color: Colors.white, size: 28),
      ),
    );
  }
}
