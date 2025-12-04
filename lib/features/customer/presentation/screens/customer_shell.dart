import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/mbuy_search_bar.dart';
import 'explore_screen.dart';
import 'stores_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'map_screen.dart';
import 'categories_screen.dart';
import 'search_screen.dart';

class CustomerShell extends StatefulWidget {
  final AppModeProvider appModeProvider;
  final String? userRole;
  final ThemeProvider? themeProvider;

  const CustomerShell({
    super.key,
    required this.appModeProvider,
    this.userRole,
    this.themeProvider,
  });

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _currentIndex = 0; // Home is default

  // Screens
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(), // 0: Home (الصفحة الرئيسية)
      const StoresScreen(), // 1: Stores
      const ExploreScreen(), // 2: Explore (Video)
      const CartScreen(), // 3: Cart
      const MapScreen(), // 4: Map
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Check if we are on the Explore screen (Video) to change UI style
    final bool isExplore = _currentIndex == 2;

    return Scaffold(
      // Header (Only show on Home and Stores)
      appBar: (_currentIndex == 0 || _currentIndex == 1)
          ? PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: widget.appModeProvider.hasMerchantAccess()
                    ? IconButton(
                        icon: const Icon(
                          Icons.dashboard_outlined,
                          color: MbuyColors.textPrimary,
                          size: 26,
                        ),
                        tooltip: 'العودة إلى لوحة التحكم',
                        onPressed: () {
                          widget.appModeProvider.setMerchantMode();
                        },
                      )
                    : null,
                titleSpacing: widget.appModeProvider.hasMerchantAccess() ? 0 : 16,
                title: Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: MbuySearchBar(
                        hintText: 'البحث',
                        readOnly: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                        suffixIcon: const Icon(
                          Icons.camera_alt_outlined,
                          color: MbuyColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Categories Button
                    IconButton(
                      icon: const Icon(
                        Icons.grid_view_outlined,
                        color: MbuyColors.textPrimary,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoriesScreen(),
                          ),
                        );
                      },
                    ),
                    // Profile Button
                    IconButton(
                      icon: const Icon(
                        Icons.person_outline,
                        color: MbuyColors.textPrimary,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,

      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isExplore ? Colors.black : Colors.white,
          border: Border(
            top: BorderSide(
              color: isExplore ? Colors.white12 : MbuyColors.borderLight,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: isExplore ? Colors.black : Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedItemColor: isExplore ? Colors.white : MbuyColors.textPrimary,
          unselectedItemColor: isExplore
              ? Colors.white60
              : MbuyColors.textTertiary,
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            fontFamily: 'Cairo',
          ),
          items: [
            _buildNavItem(
              label: 'الرئيسية',
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
            ),
            _buildNavItem(
              label: 'المتاجر',
              icon: Icons.storefront_outlined,
              activeIcon: Icons.storefront,
            ),
            _buildNavItem(
              label: 'اكسبلور',
              icon: Icons.explore_outlined,
              activeIcon: Icons.explore,
            ),
            _buildNavItem(
              label: 'حقيبة التسوق',
              icon: Icons.shopping_bag_outlined,
              activeIcon: Icons.shopping_bag,
            ),
            _buildNavItem(
              label: 'الخريطة',
              icon: Icons.map_outlined,
              activeIcon: Icons.map,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(icon, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(activeIcon, size: 24),
      ),
      label: label,
    );
  }
}
