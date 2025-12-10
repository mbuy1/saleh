import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'products_tab.dart';
import 'orders_tab.dart';
import 'account_tab.dart';

/// شاشة لوحة التحكم الرئيسية مع NavigationBar
/// تحتوي على 4 تبويبات: الرئيسية، المنتجات، الطلبات، الحساب
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // قائمة الصفحات الرئيسية
  final List<Widget> _pages = const [
    HomeTab(),
    ProductsTab(),
    OrdersTab(),
    AccountTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // إزالة زر العودة من الشاشات الرئيسية
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_getTitle()),
        centerTitle: true,
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'المنتجات',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'الطلبات',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'الحساب',
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'الرئيسية';
      case 1:
        return 'المنتجات';
      case 2:
        return 'الطلبات';
      case 3:
        return 'الحساب';
      default:
        return 'MBUY';
    }
  }
}
