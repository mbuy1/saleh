import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import 'explore_screen.dart';
import 'stores_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'map_screen.dart';

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
  int _currentIndex = 2; // Home هي الصفحة الرئيسية (index 2)
  Offset _fabPosition = const Offset(
    20,
    100,
  ); // Initial position for draggable button

  // Screens
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const ExploreScreen(), // 0: Explore (Video)
      const StoresScreen(), // 1: Stores
      const HomeScreen(), // 2: Home (الصفحة الرئيسية) - الافتراضية
      const CartScreen(), // 3: Cart
      const MapScreen(), // 4: Map
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Check if we are on the Explore screen (Video) to change UI style
    final bool isExplore = _currentIndex == 0;

    return Scaffold(
      // لا يوجد AppBar - كل صفحة تدير الـ header الخاص بها
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _screens),

          // Draggable Dashboard Button (only if merchant access)
          if (widget.appModeProvider.hasMerchantAccess())
            Positioned(
              left: _fabPosition.dx,
              top: _fabPosition.dy,
              child: Draggable(
                feedback: Material(
                  color: Colors.transparent,
                  child: _buildDashboardButton(isDragging: true),
                ),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    // Keep button within screen bounds
                    final screenSize = MediaQuery.of(context).size;
                    _fabPosition = Offset(
                      details.offset.dx.clamp(0, screenSize.width - 60),
                      details.offset.dy.clamp(0, screenSize.height - 200),
                    );
                  });
                },
                child: _buildDashboardButton(),
              ),
            ),
        ],
      ),

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
              label: 'اكسبلور',
              icon: Icons.explore_outlined,
              activeIcon: Icons.explore,
            ),
            _buildNavItem(
              label: 'المتاجر',
              icon: Icons.storefront_outlined,
              activeIcon: Icons.storefront,
            ),
            _buildNavItem(
              label: 'الرئيسية',
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
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

  Widget _buildDashboardButton({bool isDragging = false}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00D9B3), Color(0xFF00A896)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D9B3).withValues(alpha: 0.4),
            blurRadius: isDragging ? 20 : 12,
            offset: Offset(0, isDragging ? 8 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.appModeProvider.setMerchantMode();
          },
          customBorder: const CircleBorder(),
          child: const Icon(Icons.storefront, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
