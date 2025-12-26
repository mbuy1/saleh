import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// صفحة اختصاراتي - صفحة كاملة مع زر إغلاق
class ShortcutsPanel extends StatelessWidget {
  const ShortcutsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'اختصاراتي',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
        children: [
          _buildShortcutCard(
            context,
            icon: Icons.add_box,
            title: 'منتج جديد',
            color: AppTheme.primaryColor,
            onTap: () => context.push('/dashboard/products/add'),
          ),
          _buildShortcutCard(
            context,
            icon: Icons.receipt_long,
            title: 'طلب جديد',
            color: AppTheme.successColor,
            onTap: () => context.push('/dashboard/orders'),
          ),
          _buildShortcutCard(
            context,
            icon: Icons.person_add,
            title: 'عميل جديد',
            color: AppTheme.secondaryColor,
            onTap: () {},
          ),
          _buildShortcutCard(
            context,
            icon: Icons.analytics,
            title: 'التقارير',
            color: AppTheme.accentColor,
            onTap: () => context.push('/dashboard/reports'),
          ),
          _buildShortcutCard(
            context,
            icon: Icons.settings,
            title: 'الإعدادات',
            color: AppTheme.slate600,
            onTap: () => context.push('/settings'),
          ),
          _buildShortcutCard(
            context,
            icon: Icons.campaign,
            title: 'حملة تسويقية',
            color: AppTheme.infoColor,
            onTap: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تخصيص الاختصارات قريباً')),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        label: const Text('تخصيص', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildShortcutCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
