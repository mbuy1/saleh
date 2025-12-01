import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../shared/widgets/profile_button.dart';
import '../../../../shared/widgets/enhanced_search_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/store_card_compact.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen>
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
            // Ø§Ù„ØªØ¨ÙˆÙŠØ¨Ø§Øª
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
                  Tab(text: 'Ø§Ù„Ù…ØªØ§Ø¬Ø±'),
                  Tab(text: 'Ø§Ù„ÙØ¦Ø§Øª'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Ø£ÙŠÙ‚ÙˆÙ†Ø© Ø§Ù„Ø­Ø³Ø§Ø¨
            const ProfileButton(),
          ],
        ),
      ),
      body: Column(
        children: [
          // Ø´Ø±ÙŠØ· Ø§Ù„Ø¨Ø­Ø«
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: const EnhancedSearchBar(),
          ),
          // Ø§Ù„Ù…Ø­ØªÙˆÙ‰
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildStoresTab(), _buildCategoriesTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildSection(
          title: 'Ø£ÙØ¶Ù„ Ø§Ù„Ù…ØªØ§Ø¬Ø±',
          subtitle: 'Ø§Ù„Ø£ÙƒØ«Ø± Ø·Ù„Ø¨Ø§Ù‹',
          icon: Icons.local_fire_department,
          stores: DummyData.stores.take(5).toList(),
        ),
        _buildSection(
          title: 'Ø§Ù„Ø£Ø¹Ù„Ù‰ ØªÙ‚ÙŠÙŠÙ…Ø§Ù‹',
          subtitle: 'Ù…ØªØ§Ø¬Ø± Ù…ÙˆØ«ÙˆÙ‚Ø©',
          icon: Icons.star,
          stores: DummyData.stores.skip(5).take(5).toList(),
        ),
        _buildSection(
          title: 'Ù…ØªØ§Ø¬Ø± Ø¬Ø¯ÙŠØ¯Ø©',
          subtitle: 'Ø§ÙƒØªØ´Ù Ø§Ù„Ø¬Ø¯ÙŠØ¯',
          icon: Icons.new_releases,
          stores: DummyData.stores.take(5).toList(),
        ),
        _buildSection(
          title: 'Ø²Ø±ØªÙ‡Ø§ Ø³Ø§Ø¨Ù‚Ø§Ù‹',
          subtitle: 'Ù…ØªØ§Ø¬Ø±Ùƒ Ø§Ù„Ù…ÙØ¶Ù„Ø©',
          icon: Icons.history,
          stores: DummyData.stores.skip(5).take(5).toList(),
        ),
        _buildSection(
          title: 'Ù…ØªØ§Ø¬Ø± Ù…Ù‚ØªØ±Ø­Ø©',
          subtitle: 'Ù‚Ø¯ ØªØ¹Ø¬Ø¨Ùƒ',
          icon: Icons.recommend,
          stores: DummyData.stores.take(6).toList(),
          isGrid: true,
        ),
      ],
    );
  }

  Widget _buildCategoriesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'ÙØ¦Ø§Øª Ø§Ù„Ù…ØªØ§Ø¬Ø±',
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
            _buildCategoryCard(
              'Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ§Øª',
              Icons.phone_android,
              Colors.blue,
            ),
            _buildCategoryCard('Ø£Ø²ÙŠØ§Ø¡', Icons.checkroom, Colors.pink),
            _buildCategoryCard('Ù…Ù†Ø²Ù„', Icons.home, Colors.orange),
            _buildCategoryCard('Ø±ÙŠØ§Ø¶Ø©', Icons.sports_soccer, Colors.green),
            _buildCategoryCard('Ø¬Ù…Ø§Ù„', Icons.spa, Colors.purple),
            _buildCategoryCard('ÙƒØªØ¨', Icons.book, Colors.brown),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List stores,
    bool isGrid = false,
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
          if (isGrid)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: stores.length,
              itemBuilder: (context, index) {
                return StoreCardCompact(
                  store: stores[index],
                  width: double.infinity,
                );
              },
            )
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  return StoreCardCompact(store: stores[index]);
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
