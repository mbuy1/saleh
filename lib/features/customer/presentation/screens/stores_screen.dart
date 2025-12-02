import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/widgets/store_card_compact.dart';
import '../../../../shared/widgets/profile_button.dart';
import '../../../../shared/widgets/alibaba/alibaba_search_bar.dart';
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
    return MbuyScaffold(
      backgroundColor: MbuyColors.background,
      appBar: MbuyAppBar(
        tabController: _tabController,
        tabs: const ['المتاجر', 'الفئات'],
        showProfileButton: true,
        customProfileButton: const ProfileButton(),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: AlibabaSearchBar(
              hintText: 'ابحث عن متجر...',
              onTap: () {
                // Navigate to search
              },
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
      ),
    );
  }

  Widget _buildStoresTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            // 1. Best Stores (Carousel)
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  MbuySectionHeader(
                    title: 'أفضل المتاجر',
                    subtitle: 'المتاجر الأكثر مبيعاً هذا الأسبوع',
                    icon: Icons.storefront,
                    onViewMore: () {},
                  ),
                  SizedBox(
                    height: 195,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final stores = DummyData.stores;
                        if (index >= stores.length) return const SizedBox();
                        return StoreCardCompact(store: stores[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 2. Top Rated Stores (Carousel)
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  MbuySectionHeader(
                    title: 'متاجر مميزة',
                    subtitle: 'تقييم عالي من العملاء',
                    icon: Icons.star_outline,
                    onViewMore: () {},
                  ),
                  SizedBox(
                    height: 195,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final stores = DummyData.stores.reversed.toList();
                        if (index >= stores.length) return const SizedBox();
                        return StoreCardCompact(store: stores[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 3. New Stores (Carousel)
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  MbuySectionHeader(
                    title: 'متاجر جديدة',
                    subtitle: 'انضمت حديثاً إلى mBuy',
                    icon: Icons.new_releases_outlined,
                    onViewMore: () {},
                  ),
                  SizedBox(
                    height: 195,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final stores = DummyData.stores;
                        if (index >= stores.length) return const SizedBox();
                        return StoreCardCompact(store: stores[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 4. Suggested Stores (Grid)
            MbuySectionHeader(
              title: 'متاجر مقترحة',
              icon: Icons.recommend_outlined,
              iconColor: MbuyColors.textSecondary,
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85, // Slightly taller for store cards
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: DummyData.stores.length,
              itemBuilder: (context, index) {
                return StoreCardCompact(
                  store: DummyData.stores[index],
                  width: double.infinity,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return CategoryBrowserView(
      mainCategories: _getMainStoreCategories(),
      onViewAllCategories: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CategoriesScreen(),
          ),
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
