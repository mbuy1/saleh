import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import 'merchant_dashboard_screen.dart';
import 'merchant_products_screen.dart';
import 'merchant_orders_screen.dart';
import 'merchant_wallet_screen.dart';
import '../widgets/merchant_profile_tab.dart';

class MerchantHomeScreen extends StatefulWidget {
  final AppModeProvider appModeProvider;

  const MerchantHomeScreen({super.key, required this.appModeProvider});

  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  final int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MerchantDashboardScreen(appModeProvider: widget.appModeProvider),
      const MerchantProductsScreen(),
      const MerchantOrdersScreen(),
      const MerchantWalletScreen(),
      MerchantProfileTab(appModeProvider: widget.appModeProvider),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
    );
  }
}
