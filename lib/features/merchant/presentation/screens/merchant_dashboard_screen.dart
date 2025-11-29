/// MerchantDashboardScreen - لوحة تحكم التاجر
/// 
/// شاشة بسيطة تحتوي:
/// - نص "لوحة تحكم التاجر"
/// - زر في AppBar: "شاهد التطبيق بنظرة العميل"
/// - عند الضغط: يغيّر AppMode من merchant إلى customer

import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import 'merchant_store_setup_screen.dart';
import 'merchant_products_screen.dart';
import 'merchant_orders_screen.dart';

class MerchantDashboardScreen extends StatelessWidget {
  final AppModeProvider appModeProvider;

  const MerchantDashboardScreen({
    super.key,
    required this.appModeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم التاجر'),
        actions: [
          TextButton.icon(
            onPressed: () {
              // تغيير AppMode إلى customer
              appModeProvider.setCustomerMode();
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('شاهد التطبيق بنظرة العميل'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'لوحة تحكم التاجر',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildMenuCard(
            context,
            icon: Icons.store,
            title: 'إدارة المتجر',
            subtitle: 'إنشاء أو تعديل متجرك',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantStoreSetupScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            context,
            icon: Icons.inventory_2,
            title: 'المنتجات',
            subtitle: 'إدارة منتجات متجرك',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantProductsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            context,
            icon: Icons.receipt_long,
            title: 'الطلبات',
            subtitle: 'عرض طلبات متجرك',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantOrdersScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

