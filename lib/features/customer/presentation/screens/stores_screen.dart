import 'package:flutter/material.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../shared/widgets/modern_hero_section.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../../../shared/widgets/brand_card.dart';
import '../../../../shared/widgets/circle_item.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'الكل',
    'أزياء',
    'إلكترونيات',
    'منزل',
    'مطاعم',
    'جمال',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Modern Hero Section
        const ModernHeroSection(
          title: 'المتاجر',
          subtitle: 'اكتشف أفضل المتاجر المحلية',
          icon: Icons.storefront_outlined,
          iconColor: Color(0xFF00D9B3),
          height: 180,
        ),

        // Tab Bar
        Container(
          color: Colors.white,
          width: double.infinity,
          height: 50,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: const Color(0xFF00D9B3),
            indicatorWeight: 3,
            labelColor: const Color(0xFF212529),
            unselectedLabelColor: const Color(0xFF6C757D),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: 'Cairo',
              fontSize: 14,
            ),
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) => _buildStoresTab(tab)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStoresTab(String category) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Stats Cards Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  StatsCard(
                    value: '250+',
                    label: 'متجر نشط',
                    color: Colors.green.shade100,
                    icon: Icons.store_outlined,
                  ),
                  StatsCard(
                    value: '4.8',
                    label: 'متوسط التقييم',
                    color: Colors.amber.shade100,
                    icon: Icons.star_outline,
                  ),
                  StatsCard(
                    value: '15',
                    label: 'وقت الاستجابة (دقيقة)',
                    color: Colors.blue.shade100,
                    icon: Icons.access_time_outlined,
                  ),
                  StatsCard(
                    value: '95%',
                    label: 'معدل الرضا',
                    color: Colors.purple.shade100,
                    icon: Icons.thumb_up_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Featured Stores Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'متاجر مميزة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                      color: Color(0xFF212529),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'عرض الكل',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xFF00D9B3),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Featured Stores Horizontal List
            SizedBox(
              height: 110,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  BrandCard(
                    name: 'متجر الموضة',
                    backgroundColor: const Color(0xFF212529),
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  BrandCard(
                    name: 'تك ستور',
                    backgroundColor: const Color(0xFF007BFF),
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  BrandCard(
                    name: 'خصم 30%',
                    backgroundColor: const Color(0xFFDC3545),
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  BrandCard(
                    name: 'هوم ديكور',
                    backgroundColor: const Color(0xFFF5E6D3),
                    textColor: Colors.black,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  BrandCard(
                    name: 'بيوتي سنتر',
                    backgroundColor: const Color(0xFFFFC0CB),
                    textColor: Colors.black,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // All Stores Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'جميع المتاجر - $category',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Color(0xFF212529),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Stores Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                ),
                itemCount: DummyData.stores.length,
                itemBuilder: (context, index) {
                  final store = DummyData.stores[index];
                  return CircleItem(
                    label: store.name,
                    imageUrl: store.logoUrl,
                    size: 60,
                    onTap: () {
                      // Navigate to store details
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }
}
