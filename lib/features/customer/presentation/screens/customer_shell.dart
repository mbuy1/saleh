/// CustomerShell - الواجهة الرئيسية للعميل
/// 
/// تحتوي على:
/// - Scaffold مع BottomNavigationBar
/// - 5 Tabs: Explore, Stores, Home, Cart, Map
/// - كل Tab له شاشة منفصلة
/// - زر "لوحة التحكم" في AppBar (للتاجر فقط)

import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import 'explore_screen.dart';
import 'stores_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'map_screen.dart';

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

  final List<Widget> _screens = [
    const ExploreScreen(),
    const StoresScreen(),
    const HomeScreen(),
    const CartScreen(),
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
          : null, // لا AppBar للعميل العادي
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

