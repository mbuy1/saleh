import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/media/media_screen.dart';
import 'features/categories/categories_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/account/account_screen.dart';
import 'shared/widgets/app_header.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MbuyMarketApp());
}

class MbuyMarketApp extends StatelessWidget {
  const MbuyMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MBUY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const MainScreen(),
    );
  }
}

/// Main Screen with Bottom Navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Start at Home (الرئيسية)
  bool _isScrolled = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 100;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.home_outlined,
      'activeIcon': Icons.home,
      'label': 'الرئيسية',
    },
    {
      'icon': Icons.grid_view_outlined,
      'activeIcon': Icons.grid_view,
      'label': 'التصنيفات',
    },
    {
      'icon': Icons.play_circle_outline,
      'activeIcon': Icons.play_circle,
      'label': 'ميديا',
    },
    {
      'icon': Icons.shopping_cart_outlined,
      'activeIcon': Icons.shopping_cart,
      'label': 'السلة',
    },
    {
      'icon': Icons.person_outline,
      'activeIcon': Icons.person,
      'label': 'حسابي',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(scrollController: _scrollController),
          const CategoriesScreen(),
          const MediaScreen(),
          const CartScreen(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppTheme.bottomNavShadow,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              return _buildNavItem(
                index: index,
                icon: item['icon'] as IconData,
                activeIcon: item['activeIcon'] as IconData,
                label: item['label'] as String,
                badgeCount: index == 3 ? 2 : null, // Badge on cart
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badgeCount,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected
                      ? AppTheme.navBarSelected
                      : AppTheme.navBarUnselected,
                  size: 24,
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.badgeColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badgeCount > 9 ? '9+' : '$badgeCount',
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
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppTheme.navBarSelected
                    : AppTheme.navBarUnselected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
