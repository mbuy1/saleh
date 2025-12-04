import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/circle_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['نساء', 'رجال', 'المنزل', 'أطفال', 'تجميل'];

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
        // Top Tab Bar
        Container(
          color: Colors.white,
          width: double.infinity,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: MbuyColors.textPrimary,
            indicatorWeight: 2,
            labelColor: MbuyColors.textPrimary,
            unselectedLabelColor: MbuyColors.textSecondary,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: 'Cairo',
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MbuyColors.secondaryBeige,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://via.placeholder.com/800x400',
                ), // Placeholder
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                'عروض $tabName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                ),
              ),
            ),
          ),

          // Circle Categories
          SizedBox(
            height: 110,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return CircleItem(
                  label: 'قسم ${index + 1}',
                  // imageUrl: 'https://via.placeholder.com/100',
                  icon: const Icon(
                    Icons.category_outlined,
                    color: MbuyColors.textSecondary,
                  ),
                  onTap: () {},
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'وصل حديثاً',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 16),

          // Product Grid (Placeholder)
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
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MbuyColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: MbuyColors.surface,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: MbuyColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'منتج تجريبي ${index + 1}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '99.00 ر.س',
                            style: TextStyle(
                              color: MbuyColors.textPrimary,
                              fontWeight: FontWeight.bold,
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

          const SizedBox(height: 80), // Bottom padding for navigation bar
        ],
      ),
    );
  }
}
