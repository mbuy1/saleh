import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../shared/widgets/mbuy_search_bar.dart';
import '../../../../shared/widgets/circle_item.dart';
import '../../../../shared/widgets/category_browser_view.dart';
import 'categories_screen.dart';

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
    return Column(
      children: [
        // Tab Bar
        Container(
          color: Colors.white,
          width: double.infinity,
          child: TabBar(
            controller: _tabController,
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
            tabs: const [
              Tab(text: 'المتاجر'),
              Tab(text: 'الفئات'),
            ],
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildStoresTab(), _buildCategoriesTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildStoresTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar (Full Width)
          MbuySearchBar(
            hintText: 'ابحث عن متجر...',
            onTap: () {
              // Navigate to search
            },
          ),

          const SizedBox(height: 24),

          // Grid of Circular Stores
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 items per row
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemCount: DummyData.stores.length,
            itemBuilder: (context, index) {
              final store = DummyData.stores[index];
              return CircleItem(
                label: store.name,
                imageUrl:
                    store.logoUrl, // Assuming logoUrl exists or use placeholder
                size: 60,
                onTap: () {
                  // Navigate to store details
                },
              );
            },
          ),

          const SizedBox(height: 80), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return CategoryBrowserView(
      mainCategories: _getMainStoreCategories(),
      onViewAllCategories: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
        );
      },
    );
  }

  List<MainCategory> _getMainStoreCategories() {
    return [
      MainCategory(
        id: '1',
        name: 'متاجر أزياء',
        icon: Icons.checkroom,
        subCategories: [
          SubCategory(id: '1-1', name: 'ملابس نسائية', icon: Icons.woman),
          SubCategory(id: '1-2', name: 'ملابس رجالية', icon: Icons.man),
          SubCategory(id: '1-3', name: 'ملابس أطفال', icon: Icons.child_care),
          SubCategory(id: '1-4', name: 'أحذية', icon: Icons.verified_user),
          SubCategory(id: '1-5', name: 'إكسسوارات', icon: Icons.watch),
        ],
      ),
      MainCategory(
        id: '2',
        name: 'متاجر إلكترونيات',
        icon: Icons.phone_android,
        subCategories: [
          SubCategory(id: '2-1', name: 'هواتف وأجهزة', icon: Icons.smartphone),
          SubCategory(id: '2-2', name: 'حواسيب', icon: Icons.laptop),
          SubCategory(id: '2-3', name: 'أجهزة منزلية', icon: Icons.tv),
          SubCategory(id: '2-4', name: 'كاميرات', icon: Icons.camera_alt),
          SubCategory(
            id: '2-5',
            name: 'ألعاب فيديو',
            icon: Icons.sports_esports,
          ),
        ],
      ),
      MainCategory(
        id: '3',
        name: 'منزل وديكور',
        icon: Icons.home_outlined,
        subCategories: [
          SubCategory(id: '3-1', name: 'أثاث', icon: Icons.chair),
          SubCategory(id: '3-2', name: 'ديكورات', icon: Icons.format_paint),
          SubCategory(id: '3-3', name: 'مفروشات', icon: Icons.bed),
          SubCategory(id: '3-4', name: 'إضاءة', icon: Icons.lightbulb),
          SubCategory(id: '3-5', name: 'أدوات مطبخ', icon: Icons.kitchen),
        ],
      ),
      MainCategory(
        id: '4',
        name: 'جمال وعناية',
        icon: Icons.face,
        subCategories: [
          SubCategory(id: '4-1', name: 'عطور', icon: Icons.spa),
          SubCategory(id: '4-2', name: 'مكياج', icon: Icons.brush),
          SubCategory(
            id: '4-3',
            name: 'عناية شخصية',
            icon: Icons.face_retouching_natural,
          ),
          SubCategory(id: '4-4', name: 'صالونات', icon: Icons.content_cut),
        ],
      ),
      MainCategory(
        id: '5',
        name: 'مطاعم وكافيهات',
        icon: Icons.restaurant,
        subCategories: [
          SubCategory(id: '5-1', name: 'مطاعم', icon: Icons.restaurant_menu),
          SubCategory(id: '5-2', name: 'كافيهات', icon: Icons.local_cafe),
          SubCategory(id: '5-3', name: 'حلويات', icon: Icons.cake),
          SubCategory(id: '5-4', name: 'وجبات سريعة', icon: Icons.fastfood),
        ],
      ),
      MainCategory(
        id: '6',
        name: 'رياضة ولياقة',
        icon: Icons.sports_soccer,
        subCategories: [
          SubCategory(
            id: '6-1',
            name: 'ملابس رياضية',
            icon: Icons.sports_handball,
          ),
          SubCategory(
            id: '6-2',
            name: 'معدات رياضية',
            icon: Icons.fitness_center,
          ),
          SubCategory(
            id: '6-3',
            name: 'نوادي رياضية',
            icon: Icons.sports_gymnastics,
          ),
          SubCategory(id: '6-4', name: 'مكملات غذائية', icon: Icons.restaurant),
        ],
      ),
    ];
  }
}
