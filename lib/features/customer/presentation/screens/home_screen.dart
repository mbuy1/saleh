import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../shared/widgets/profile_button.dart';
import '../../../../shared/widgets/enhanced_search_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/product_card_compact.dart';

class HomeScreen extends StatefulWidget {
  final String? userRole;

  const HomeScreen({super.key, this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // التبويبات
            Expanded(
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorColor: MbuyColors.primaryPurple,
                indicatorWeight: 3,
                labelColor: MbuyColors.primaryPurple,
                unselectedLabelColor: MbuyColors.textSecondary,
                labelStyle: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'المنتجات'),
                  Tab(text: 'الفئات'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // أيقونة الحساب
            const ProfileButton(),
          ],
        ),
      ),
      body: Column(
        children: [
          // شريط البحث
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: const EnhancedSearchBar(),
          ),
          // المحتوى
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildProductsTab(), _buildCategoriesTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildSection(
          title: 'أفضل العروض',
          subtitle: 'خصومات حصرية',
          icon: Icons.local_fire_department,
          products: DummyData.products.take(5).toList(),
        ),
        _buildSection(
          title: 'الأعلى تصنيفاً',
          subtitle: 'منتجات موثوقة',
          icon: Icons.star,
          products: DummyData.products.skip(5).take(5).toList(),
        ),
        _buildSection(
          title: 'وصل حديثاً',
          subtitle: 'أحدث المنتجات',
          icon: Icons.new_releases,
          products: DummyData.products.skip(10).take(5).toList(),
        ),
        _buildSection(
          title: 'مختاراتك',
          subtitle: 'خصيصاً لك',
          icon: Icons.favorite,
          products: DummyData.products.skip(15).take(5).toList(),
        ),
        _buildSection(
          title: 'عشوائية',
          subtitle: 'اكتشف المزيد',
          icon: Icons.shuffle,
          products: DummyData.products.take(8).toList(),
          isFeed: true,
        ),
      ],
    );
  }

  Widget _buildCategoriesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'الفئات',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MbuyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildCategoryCard('إلكترونيات', Icons.phone_android, Colors.blue),
            _buildCategoryCard('أزياء', Icons.checkroom, Colors.pink),
            _buildCategoryCard('منزل', Icons.home, Colors.orange),
            _buildCategoryCard('رياضة', Icons.sports_soccer, Colors.green),
            _buildCategoryCard('جمال', Icons.spa, Colors.purple),
            _buildCategoryCard('كتب', Icons.book, Colors.brown),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List products,
    bool isFeed = false,
  }) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            icon: icon,
            onViewMore: () {},
          ),
          if (isFeed)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCardCompact(
                  product: products[index],
                  width: double.infinity,
                );
              },
            )
          else
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCardCompact(product: products[index]);
                },
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String name, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                name,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
