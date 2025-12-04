import 'package:flutter/material.dart';
import '../../../../shared/widgets/modern_hero_section.dart';
import '../../../../shared/widgets/stats_card.dart';
import '../../../../shared/widgets/brand_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'الرئيسية',
    'نساء',
    'رجال',
    'منزل',
    'أطفال',
    'جمال'
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
          title: 'MBUY',
          subtitle: 'متجرك الإلكتروني الشامل',
          icon: Icons.shopping_bag_outlined,
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
            children: _tabs.map((tab) => _buildTabContent(tab)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(String tabName) {
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
                    value: '5000+',
                    label: 'منتج متوفر',
                    color: Colors.green.shade100,
                    icon: Icons.inventory_2_outlined,
                  ),
                  StatsCard(
                    value: '75.68',
                    label: 'متوسط التقييم',
                    color: Colors.blue.shade100,
                    icon: Icons.star_outline,
                  ),
                  StatsCard(
                    value: '9.20',
                    label: 'وقت التوصيل (ساعة)',
                    color: Colors.orange.shade100,
                    icon: Icons.delivery_dining_outlined,
                  ),
                  StatsCard(
                    value: '145.04',
                    label: 'متوسط السعر (ر.س)',
                    color: Colors.purple.shade100,
                    icon: Icons.payments_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Popular Brands Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'العلامات التجارية الشهيرة',
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

            // Brands Horizontal List
            SizedBox(
              height: 110,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  BrandCard(
                    name: 'Apple',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  BrandCard(
                    name: 'Samsung',
                    backgroundColor: const Color(0xFFF5E6D3),
                    textColor: Colors.black,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  BrandCard(
                    name: 'خصم 40%',
                    backgroundColor: const Color(0xFF007BFF),
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  BrandCard(
                    name: 'Nike',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  BrandCard(
                    name: 'Adidas',
                    backgroundColor: const Color(0xFF212529),
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Latest Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'وصل حديثاً - $tabName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Color(0xFF212529),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Product Grid
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: Color(0xFF6C757D),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'منتج ${index + 1}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '99.00 ر.س',
                              style: TextStyle(
                                color: Color(0xFF00D9B3),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }
}
