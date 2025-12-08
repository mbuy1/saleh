import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import 'merchant_products_screen.dart';
import 'merchant_orders_screen.dart';
import 'merchant_store_setup_screen.dart';
import '../widgets/merchant_bottom_bar.dart';
import '../widgets/merchant_profile_tab.dart';

// Simple, focused merchant dashboard that provides tab navigation only.
class MerchantDashboardScreen extends StatefulWidget {
  final AppModeProvider appModeProvider;

  const MerchantDashboardScreen({super.key, required this.appModeProvider});

  @override
  State<MerchantDashboardScreen> createState() =>
      _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState extends State<MerchantDashboardScreen> {
  int _currentIndex = 0;
  final GlobalKey<MerchantProductsScreenState> _productsKey =
      GlobalKey<MerchantProductsScreenState>();

  List<Widget> get _merchantTabs => [
    MerchantProductsScreen(key: _productsKey),
    MerchantOrdersScreen(),
    MerchantStoreSetupScreen(),
    MerchantProfileTab(appModeProvider: widget.appModeProvider),
  ];

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: _merchantTabs[_currentIndex],
      bottomNavigationBar: MerchantBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        onAddTap: () {
          // If currently on products tab, trigger the add dialog inside the products screen
          if (_currentIndex == 0) {
            _productsKey.currentState?.openAddProductDialog();
            return;
          }

          // Default: when not on products tab, navigate to products tab first
          setState(() {
            _currentIndex = 0;
          });
          // call the dialog after a short delay so the widget is mounted
          Future.delayed(const Duration(milliseconds: 150), () {
            _productsKey.currentState?.openAddProductDialog();
          });
        },
        onStoreTap: null,
      ),
    );
  }
}
