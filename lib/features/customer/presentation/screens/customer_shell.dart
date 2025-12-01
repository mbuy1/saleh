import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import 'explore_screen.dart';
import 'stores_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';
import 'customer_wallet_screen.dart';
import 'customer_points_screen.dart';
import 'customer_orders_screen.dart';

class CustomerShell extends StatefulWidget {
  final AppModeProvider appModeProvider;
  final String? userRole; // 'customer' أو 'merchant'
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
  int _currentIndex = 2; // Home هو الافتراضي (في المنتصف)

  List<Widget> get _screens => [
    ExploreScreen(userRole: widget.userRole),
    const StoresScreen(),
    HomeScreen(userRole: widget.userRole),
    CartScreen(userRole: widget.userRole),
    const MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.userRole == 'customer'
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: MbuyColors.primaryGradient,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'mBuy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'تطبيق التسوق',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: const Text('طلباتي'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerOrdersScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text('محفظتي'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerWalletScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.stars),
                    title: const Text('نقاطي'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerPointsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('الإعدادات'),
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.themeProvider != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                              themeProvider: widget.themeProvider!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          : null,
      body: Stack(
        children: [
          _screens[_currentIndex],
          // زر العودة للتاجر في الأعلى
          if (widget.userRole == 'merchant')
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        widget.appModeProvider.setMerchantMode();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'العودة',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
          ),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withValues(alpha: 0.6),
          items: [
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 0,
                icon: Icons.explore,
              ),
              label: 'اكسبلور',
            ),
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 1,
                icon: Icons.store,
              ),
              label: 'المتاجر',
            ),
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 2,
                icon: Icons.home,
              ),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 3,
                icon: Icons.shopping_cart,
              ),
              label: 'السلة',
            ),
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 4,
                icon: Icons.map,
              ),
              label: 'الخريطة',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon({required bool isSelected, required IconData icon}) {
    if (isSelected) {
      // الأيقونة المحددة بتدرج Purple
      return ShaderMask(
        shaderCallback: (bounds) =>
            MbuyColors.primaryGradient.createShader(bounds),
        child: Icon(icon, size: 28, color: Colors.white),
      );
    } else {
      // الأيقونة غير المحددة
      return Icon(icon, size: 28, color: Colors.white.withValues(alpha: 0.6));
    }
  }
}
