import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import 'merchant_dashboard_screen.dart';
import 'merchant_products_screen.dart';
import 'merchant_community_screen.dart';
import 'merchant_messages_screen.dart';
import 'merchant_profile_screen.dart';
import 'merchant_store_management_screen.dart';
import '../widgets/merchant_bottom_bar.dart';

class MerchantHomeScreen extends StatefulWidget {
  final AppModeProvider appModeProvider;

  const MerchantHomeScreen({super.key, required this.appModeProvider});

  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MerchantDashboardScreen(appModeProvider: widget.appModeProvider),
      const MerchantCommunityScreen(),
      const MerchantProductsScreen(),
      const MerchantMessagesScreen(),
      const MerchantProfileScreen(),
    ];
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: MerchantBottomBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        onAddTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MerchantProductsScreen(),
            ),
          );
        },
        onStoreTap: () {
          // Navigate to full store management screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MerchantStoreManagementScreen(),
            ),
          );
        },
      ),
    );
  }
}
