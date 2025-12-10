import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/auth_controller.dart';

/// شاشة الرئيسية - Home Tab
/// تعرض ملخص سريع للمعلومات الأساسية والإحصائيات
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رسالة ترحيب
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.waving_hand, color: Colors.amber, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'مرحباً بك',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (authState.userRole != null)
                    Text(
                      'الدور: ${authState.userRole}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // عنوان الإحصائيات
          Text(
            'الإحصائيات السريعة',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // بطاقات الإحصائيات
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'المنتجات',
                  value: '0',
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'الطلبات',
                  value: '0',
                  icon: Icons.receipt_long,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'المبيعات',
                  value: '0 ر.س',
                  icon: Icons.monetization_on,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'العملاء',
                  value: '0',
                  icon: Icons.people,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // روابط سريعة
          Text(
            'روابط سريعة',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _QuickLinkCard(
            title: 'إضافة منتج جديد',
            icon: Icons.add_box,
            color: Colors.blue,
            onTap: () {
              // سيتم الربط لاحقاً
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('قريباً: إضافة منتج')),
              );
            },
          ),
          const SizedBox(height: 8),
          _QuickLinkCard(
            title: 'عرض الطلبات الجديدة',
            icon: Icons.notification_important,
            color: Colors.orange,
            onTap: () {
              // سيتم الربط لاحقاً
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('قريباً: الطلبات الجديدة')),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// بطاقة إحصائية صغيرة
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة رابط سريع
class _QuickLinkCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(51), // 0.2 * 255 = 51
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
