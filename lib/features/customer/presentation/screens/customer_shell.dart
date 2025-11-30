import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
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
    // التحقق إذا كان المستخدم تاجر (حتى لو في وضع customer كمشاهد)
    final bool isMerchant = widget.userRole == 'merchant';

    return Scaffold(
      appBar: isMerchant
          ? AppBar(
              title: const Text('Saleh - وضع العميل'),
              actions: [
                // زر "لوحة التحكم" - يظهر فقط للتاجر
                TextButton.icon(
                  onPressed: () {
                    // تغيير AppMode إلى merchant للعودة إلى لوحة التحكم
                    widget.appModeProvider.setMerchantMode();
                  },
                  icon: const Icon(Icons.dashboard),
                  label: const Text('لوحة التحكم'),
                ),
              ],
            )
          : AppBar(
              title: const Text('Saleh'),
              automaticallyImplyLeading: false,
            ),
      drawer: widget.userRole == 'customer'
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
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
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'استكشف',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'المتاجر',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'السلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'الخريطة',
          ),
        ],
      ),
    );
  }
}

