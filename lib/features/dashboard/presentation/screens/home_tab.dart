import 'package:flutter/material.dart';
import 'mbuy_studio_screen.dart';
import 'mbuy_tools_screen.dart';
import 'merchant_services_screen.dart';
import 'placeholder_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        title: const Text(
          'MBUY',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'متجر السعادة',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // (ب) شريط الأيقونات الأربعة
            _buildTopIconsGrid(context),

            const SizedBox(height: 24),

            // (ج) أربعة مربعات كبيرة للرصد السريع
            _buildStatisticsGrid(context),

            const SizedBox(height: 24),

            // (د) ثلاثة تبويبات/بطاقات رئيسية
            _buildMainCards(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIconsGrid(BuildContext context) {
    final items = [
      {
        'icon': Icons.lightbulb_outline,
        'label': 'رؤيتنا وأفكارنا',
        'screen': 'VisionAndIdeasScreen',
      },
      {
        'icon': Icons.campaign_outlined,
        'label': 'التسويق',
        'screen': 'MarketingScreen',
      },
      {
        'icon': Icons.local_offer_outlined,
        'label': 'الترويج',
        'screen': 'PromotionScreen',
      },
      {
        'icon': Icons.bar_chart,
        'label': 'التحليلات',
        'screen': 'AnalyticsReportsScreen',
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        return Expanded(
          child: Column(
            children: [
              IconButton.filledTonal(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PlaceholderScreen(title: item['label'] as String),
                    ),
                  );
                },
                icon: Icon(item['icon'] as IconData),
              ),
              const SizedBox(height: 4),
              Text(
                item['label'] as String,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: const [
        _StatCard(title: 'الرصيد', value: '0.00', unit: 'ر.س'),
        _StatCard(title: 'النقاط', value: '150', unit: 'نقطة'),
        _StatCard(title: 'الطلبات', value: '12', unit: 'طلب'),
        _StatCard(title: 'العملاء', value: '45', unit: 'عميل'),
      ],
    );
  }

  Widget _buildMainCards(BuildContext context) {
    return Column(
      children: [
        _MainFeatureCard(
          title: 'MBUY Studio',
          description: 'توليد الصور والفيديو والمحتوى بالذكاء الاصطناعي',
          icon: Icons.movie_filter,
          color: Colors.purple.shade50,
          iconColor: Colors.purple,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MbuyStudioScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _MainFeatureCard(
          title: 'MBUY Tools',
          description: 'أدوات الذكاء الاصطناعي، التحليلات، والأتمتة',
          icon: Icons.smart_toy,
          color: Colors.blue.shade50,
          iconColor: Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MbuyToolsScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _MainFeatureCard(
          title: 'خدمات التاجر',
          description: 'الموردين، الدروب شوبينغ، المصورين، والمزيد',
          icon: Icons.storefront,
          color: Colors.orange.shade50,
          iconColor: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MerchantServicesScreen()),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                unit,
                style: TextStyle(color: Colors.grey[400], fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _MainFeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
