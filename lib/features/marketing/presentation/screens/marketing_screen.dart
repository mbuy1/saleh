import 'package:flutter/material.dart';

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({super.key});

  final List<Map<String, dynamic>> _tools = const [
    {'title': 'النقاط', 'icon': Icons.star, 'route': '/marketing/points'},
    {
      'title': 'كاش باك',
      'icon': Icons.money_off,
      'route': '/marketing/cashback',
    },
    {
      'title': 'كوبونات',
      'icon': Icons.local_offer,
      'route': '/marketing/coupons',
    },
    {
      'title': 'حملات تسويقية',
      'icon': Icons.campaign,
      'route': '/marketing/campaigns',
    },
    {'title': 'كتالوج', 'icon': Icons.menu_book, 'route': '/marketing/catalog'},
    {
      'title': 'السلة المتروكة',
      'icon': Icons.shopping_cart_checkout,
      'route': '/marketing/abandoned_cart',
    },
    {
      'title': 'برنامج الولاء',
      'icon': Icons.loyalty,
      'route': '/marketing/loyalty',
    },
    {
      'title': 'إعادة استهداف',
      'icon': Icons.replay,
      'route': '/marketing/retargeting',
    },
    {
      'title': 'منتجات مقترحة',
      'icon': Icons.recommend,
      'route': '/marketing/suggestions',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'التسويق',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 24),
            const Text(
              'أدوات التسويق',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: _tools.length,
              itemBuilder: (context, index) {
                final tool = _tools[index];
                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('جاري فتح: ${tool['title']}')),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tool['icon'],
                          size: 32,
                          color: const Color(0xFF2D2B4E),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tool['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2B4E), Color(0xFF4A4785)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ضاعف مبيعاتك',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'استخدم أدوات التسويق المتقدمة للوصول لعملاء جدد والحفاظ على عملائك الحاليين',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
