import 'package:flutter/material.dart';

class MerchantServicesScreen extends StatelessWidget {
  const MerchantServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خدمات التاجر')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: const [
          _ServiceCard(icon: Icons.local_shipping, label: 'الموردين'),
          _ServiceCard(icon: Icons.shopping_bag, label: 'دروب شوبينغ'),
          _ServiceCard(icon: Icons.camera_alt, label: 'المصورين'),
          _ServiceCard(icon: Icons.brush, label: 'المصممين'),
          _ServiceCard(icon: Icons.star, label: 'المؤثرين'),
          _ServiceCard(icon: Icons.link, label: 'رابط المتجر'),
          _ServiceCard(icon: Icons.copy, label: 'نسخ الرابط'),
          _ServiceCard(icon: Icons.share, label: 'مشاركة'),
          _ServiceCard(icon: Icons.qr_code, label: 'QR Code'),
          _ServiceCard(icon: Icons.storefront, label: 'عرض متجري'),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ServiceCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('خدمة $label (قريباً)')));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
