import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import 'explore_screen.dart';
import 'stores_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'map_screen.dart';
import 'customer_wallet_screen.dart';
import 'customer_points_screen.dart';
import 'customer_orders_screen.dart';

class CustomerShell extends StatefulWidget {
  final AppModeProvider appModeProvider;
  final String? userRole; // 'customer' أو 'merchant'

  const CustomerShell({
    super.key,
    required this.appModeProvider,
    this.userRole,
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
    final bool isExploreScreen = _currentIndex == 0;

    return Scaffold(
      drawer: widget.userRole == 'customer'
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Saleh',
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
                      // TODO: إضافة شاشة الإعدادات
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _screens[_currentIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isExploreScreen
              ? Colors.black.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
          showSelectedLabels: false, // إلغاء النص
          showUnselectedLabels: false, // إلغاء النص
          items: [
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 0,
                icon: Icons.explore,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 1,
                icon: Icons.store,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 2,
                icon: Icons.home,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 3,
                icon: Icons.shopping_cart,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildCircleIcon(
                isSelected: _currentIndex == 4,
                icon: Icons.map,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon({required bool isSelected, required IconData icon}) {
    final bool isExploreScreen = _currentIndex == 0;

    if (isSelected) {
      // الأيقونة المحددة بتدرج لوني
      return ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            MbuyColors.primaryBlue,
            MbuyColors.primaryPurple,
            MbuyColors.accentPink,
          ],
        ).createShader(bounds),
        child: Icon(icon, size: 28, color: Colors.white),
      );
    } else {
      // الأيقونة غير المحددة
      return Icon(
        icon,
        size: 28,
        color: isExploreScreen
            ? Colors.white.withValues(alpha: 0.7)
            : MbuyColors.textSecondary,
      );
    }
  }
}
