import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import 'merchant_store_setup_screen.dart';
import 'merchant_products_screen.dart';
import 'merchant_orders_screen.dart';
import 'merchant_wallet_screen.dart';
import 'merchant_points_screen.dart';

class MerchantDashboardScreen extends StatelessWidget {
  final AppModeProvider appModeProvider;

  const MerchantDashboardScreen({
    super.key,
    required this.appModeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text(
          'لوحة تحكم التاجر',
          style: TextStyle(
            color: MbuyColors.textPrimary,
            fontFamily: 'Arabic',
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // تغيير AppMode إلى customer
              appModeProvider.setCustomerMode();
            },
            icon: const Icon(Icons.shopping_bag, color: MbuyColors.primaryBlue),
            label: const Text(
              'شاهد التطبيق بنظرة العميل',
              style: TextStyle(
                color: MbuyColors.primaryBlue,
                fontFamily: 'Arabic',
              ),
            ),
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
              color: MbuyColors.textPrimary,
              fontFamily: 'Arabic',
            ),
          ),
          const SizedBox(height: 24),
          // Cards للمحفظة والنقاط
          Row(
            children: [
              Expanded(
                child: _buildWalletCard(context),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPointsCard(context),
              ),
            ],
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
          const SizedBox(height: 16),
          _buildMenuCard(
            context,
            icon: Icons.account_balance_wallet,
            title: 'محفظة التاجر',
            subtitle: 'عرض رصيدك وعملياتك',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantWalletScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            context,
            icon: Icons.stars,
            title: 'نقاط التاجر',
            subtitle: 'استخدم نقاطك لتفعيل المميزات',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantPointsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return Card(
      color: MbuyColors.surfaceLight,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MerchantWalletScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: MbuyColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'محفظتي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                        fontFamily: 'Arabic',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // TODO: جلب الرصيد الحقيقي من WalletService
              const Text(
                '0.00 ر.س',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MbuyColors.primaryBlue,
                  fontFamily: 'Arabic',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'رصيد المحفظة',
                style: TextStyle(
                  fontSize: 12,
                  color: MbuyColors.textSecondary,
                  fontFamily: 'Arabic',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsCard(BuildContext context) {
    return Card(
      color: MbuyColors.surfaceLight,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MerchantPointsScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: MbuyColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.stars,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'نقاطي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                        fontFamily: 'Arabic',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // TODO: جلب رصيد النقاط الحقيقي من MerchantPointsService
              const Text(
                '0 نقطة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MbuyColors.primaryPurple,
                  fontFamily: 'Arabic',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'رصيد النقاط',
                style: TextStyle(
                  fontSize: 12,
                  color: MbuyColors.textSecondary,
                  fontFamily: 'Arabic',
                ),
              ),
            ],
          ),
        ),
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
      color: MbuyColors.surfaceLight,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: MbuyColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: MbuyColors.textPrimary,
            fontFamily: 'Arabic',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: MbuyColors.textSecondary,
            fontFamily: 'Arabic',
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: MbuyColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}

