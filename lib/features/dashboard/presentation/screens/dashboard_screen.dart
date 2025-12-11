import 'package:flutter/material.dart';
import 'home_tab.dart';
import '../../../community/presentation/screens/community_screen.dart';
import '../../../conversations/presentation/screens/conversations_screen.dart';
import '../../../store/presentation/screens/store_screen.dart';
import '../../../products/presentation/screens/add_product_screen.dart';

/// شاشة لوحة التحكم الرئيسية مع NavigationBar
/// تحتوي على 5 تبويبات: الرئيسية، المجتمع، إضافة منتج، المحادثات، المتجر
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
    CommunityScreen(),
    SizedBox(), // Placeholder for Add Product (handled by FAB)
    ConversationsScreen(),
    StoreScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // عند الضغط على زر الإضافة (المنتصف)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddProductScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
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
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'المجتمع',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.add_circle_outline,
              size: 32,
            ), // أيقونة أكبر للإضافة
            selectedIcon: Icon(Icons.add_circle, size: 32),
            label: 'إضافة',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'المحادثات',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'المتجر',
          ),
        ],
      ),
    );
  }
}
