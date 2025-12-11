import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'orders_tab.dart';
import 'products_tab.dart';
import 'account_tab.dart';
import '../../../conversations/presentation/screens/conversations_screen.dart';

/// شاشة لوحة التحكم الرئيسية مع NavigationBar
/// تحتوي على 5 تبويبات: الرئيسية، الطلبات، المنتجات، المحادثات، ملفي
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
    OrdersTab(),
    ProductsTab(),
    ConversationsScreen(),
    AccountTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // إزالة AppBar لأنه موجود داخل كل Tab
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'الطلبات',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'المنتجات',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'المحادثات',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'ملفي',
          ),
        ],
      ),
    );
  }
}
