import 'package:flutter/material.dart';

class MbuyToolsScreen extends StatelessWidget {
  const MbuyToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MBUY Tools')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('التحليلات', [
            'لوحة تحليلات لحظية',
            'تقارير المبيعات المتقدمة',
          ]),
          _buildSection('التسويق والحملات', [
            'منشئ حملات تسويقية',
            'مراقبة الحملات',
            'أدوات SEO',
          ]),
          _buildSection('أدوات الإدارة', [
            'إدارة المخزون الذكي',
            'إدارة فريق العمل',
          ]),
          _buildSection('الأتمتة والبوتات', [
            'مساعد ذكي (AI Assistant)',
            'بوت الرد الآلي',
            'مدير المهام المؤتمت',
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        ...items.map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.build_circle_outlined),
              title: Text(item),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
