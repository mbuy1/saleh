import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'placeholder_screen.dart';
import '../../../ai_studio/presentation/screens/mbuy_studio_screen.dart';
import '../../../marketing/presentation/screens/marketing_screen.dart';
import 'merchant_services_screen.dart';
import 'mbuy_tools_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF2D2B4E,
        ), // Dark purple/navy color from image
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'تجار تبايع',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
        actions: [
          // Logo placeholder
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'T',
                  style: TextStyle(
                    color: Color(0xFF2D2B4E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(context),
            const SizedBox(height: 16),
            _buildProfileCard(context),
            const SizedBox(height: 16),
            _buildStoreLink(context),
            const SizedBox(height: 16),
            _buildGridMenu(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
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
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background image placeholder or gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFF0F0F0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'برنامج أربح أكثر',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2B4E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'قلّص عمولة المبيعات لكل عملية شراء تجي من رابطك الخاص بالبرنامج',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Image placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.monetization_on,
                      size: 40,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Add Product Button
            Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 4),
                const Text('إضافة منتج', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(width: 16),
            // Profile Info
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'MBuy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2B4E),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2B4E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D2B4E),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(80, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'عرض متجري',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          minimumSize: const Size(80, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'سجل تجاري',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // New Orders Circle
            Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2D2B4E),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '0',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('الطلبات الجديدة', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'رابط متجري',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.qr_code, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.grey),
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(text: 'tabayu.com/Muath-Buy'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ الرابط')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.grey),
                  onPressed: () {},
                ),
                const Spacer(),
                const Text(
                  'tabayu.com/Muath-Buy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2B4E),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ميز متجرك برابط مستقل',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    final items = [
      {
        'icon': Icons.auto_awesome,
        'label': 'MBUY Studio',
        'screen': 'MbuyStudio',
        'badge': 'AI',
      },
      {
        'icon': Icons.build,
        'label': 'أدوات MBUY',
        'screen': 'MbuyTools',
        'badge': 'جديد',
      },
      {
        'icon': Icons.assignment_outlined,
        'label': 'الطلبات الخاصة',
        'screen': 'SpecialOrders',
      },
      {
        'icon': Icons.receipt_long_outlined,
        'label': 'الطلبات',
        'screen': 'Orders',
      },
      {
        'icon': Icons.campaign_outlined,
        'label': 'التسويق',
        'screen': 'Marketing',
      },
      {
        'icon': Icons.storefront_outlined,
        'label': 'إدارة المتجر',
        'screen': 'StoreManagement',
      },
      {
        'icon': Icons.monetization_on_outlined,
        'label': 'ضاعف ظهورك',
        'screen': 'DoubleExposure',
      },
      {
        'icon': Icons.palette_outlined,
        'label': 'مظهر المتجر',
        'screen': 'StoreAppearance',
        'badge': 'جديد',
      },
      {
        'icon': Icons.savings_outlined,
        'label': 'اربح أكثر',
        'screen': 'EarnMore',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            onTap: () {
              if (item['screen'] == 'MbuyStudio') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MbuyStudioScreen()),
                );
              } else if (item['screen'] == 'MbuyTools') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MbuyToolsScreen()),
                );
              } else if (item['screen'] == 'Marketing') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MarketingScreen()),
                );
              } else if (item['screen'] == 'StoreManagement') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MerchantServicesScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PlaceholderScreen(title: item['label'] as String),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 32,
                          color: const Color(0xFF2D2B4E),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2B4E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.containsKey('badge'))
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item['badge'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
