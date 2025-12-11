import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المتجر')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: const [
              _StoreCard(icon: Icons.settings, title: 'إعدادات المتجر'),
              _StoreCard(icon: Icons.palette, title: 'مظهر المتجر'),
              _StoreCard(icon: Icons.local_shipping, title: 'الشحن'),
              _StoreCard(icon: Icons.analytics, title: 'التحليلات والتقارير'),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'إدارة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _StoreListTile(
            icon: Icons.pages,
            title: 'إدارة الصفحات',
            subtitle: 'من نحن، سياسة الخصوصية...',
          ),
          _StoreListTile(
            icon: Icons.payment,
            title: 'إعدادات الدفع',
            subtitle: 'طرق الدفع، الحساب البنكي...',
          ),
          _StoreListTile(
            icon: Icons.notifications,
            title: 'إعدادات الإشعارات',
            subtitle: 'تخصيص التنبيهات',
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _StoreCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('فتح $title (قريباً)')));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StoreListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('فتح $title (قريباً)')));
        },
      ),
    );
  }
}
