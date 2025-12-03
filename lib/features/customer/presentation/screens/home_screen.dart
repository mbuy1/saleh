import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/data/models.dart';
import '../../../../shared/widgets/product_card_compact.dart';
import '../../../../shared/widgets/profile_button.dart';
import '../../../../shared/widgets/alibaba/alibaba_search_bar.dart';
import '../../../../shared/widgets/category_browser_view.dart';
import '../../../../shared/widgets/mbuy_logo.dart';
import 'categories_screen.dart';
import 'all_products_screen.dart';
import '../../data/services/home_service.dart';
import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<ProductModel> _featuredProducts = [];
  List<ProductModel> _newArrivals = [];
  List<ProductModel> _bestSellers = [];
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await HomeService.getHomeData();
    setState(() {
      _featuredProducts = data['featuredProducts'] as List<ProductModel>;
      _newArrivals = data['newArrivals'] as List<ProductModel>;
      _bestSellers = data['bestSellers'] as List<ProductModel>;
      _categories = data['categories'] as List<CategoryModel>;
      _isLoading = false;
    });
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
        tabs: const ['المنتجات', 'الفئات'],
        showProfileButton: true,
        customProfileButton: const ProfileButton(),
      ),
      body: Column(
        children: [
          // MBuy Logo at the top
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(child: MbuyLogo(size: 60, showBackground: false)),
          ),
          // Search Bar (Fixed below AppBar)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: AlibabaSearchBar(
              onTap: () {
                // Navigate to search screen
              },
            ),
          ),

          // Tab Content
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            // 1. Best Offers (Carousel)
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  MbuySectionHeader(
                    title: 'أفضل العروض',
                    subtitle: 'خصومات تصل إلى 70%',
                    icon: Icons.local_offer_outlined,
                    onViewMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllProductsScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 240,
                    child: _featuredProducts.isEmpty
                        ? const Center(child: Text('لا توجد منتجات متاحة'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _featuredProducts.length,
                            itemBuilder: (context, index) {
                              return _buildProductCard(
                                _featuredProducts[index],
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 2. Top Rated (Carousel)
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  MbuySectionHeader(
                    title: 'الأعلى تقييماً',
                    subtitle: 'منتجات أحبها العملاء',
                    icon: Icons.star_outline,
                    onViewMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllProductsScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 240,
                    child: _bestSellers.isEmpty
                        ? const Center(child: Text('لا توجد منتجات متاحة'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _bestSellers.length,
                            itemBuilder: (context, index) {
                              return _buildProductCard(_bestSellers[index]);
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 3. New Arrivals (Carousel)
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  MbuySectionHeader(
                    title: 'وصل حديثاً',
                    subtitle: 'أحدث المنتجات في السوق',
                    icon: Icons.new_releases_outlined,
                    onViewMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllProductsScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 240,
                    child: _newArrivals.isEmpty
                        ? const Center(child: Text('لا توجد منتجات متاحة'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _newArrivals.length,
                            itemBuilder: (context, index) {
                              return _buildProductCard(_newArrivals[index]);
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 4. You May Like (Grid)
            MbuySectionHeader(
              title: 'قد يعجبك أيضاً',
              icon: Icons.recommend_outlined,
              iconColor: MbuyColors.textSecondary,
            ),

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
              itemCount: _featuredProducts.length,
              itemBuilder: (context, index) {
                return _buildProductCard(_featuredProducts[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final dummyProduct = Product(
      id: product.id,
      name: product.name,
      price: product.finalPrice,
      categoryId: product.categoryId ?? '',
      storeId: product.storeId,
      imageUrl: product.imageUrl ?? 'https://via.placeholder.com/150',
      rating: product.rating ?? 0.0,
      description: product.description ?? '',
    );

    return ProductCardCompact(product: dummyProduct);
  }

  Widget _buildCategoriesTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return CategoryBrowserView(
      mainCategories: _categories.isEmpty
          ? _getMainProductCategories()
          : _getMainProductCategories(),
      onViewAllCategories: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
        );
      },
    );
  }

  List<MainCategory> _getMainProductCategories() {
    return [
      MainCategory(
        id: '1',
        name: 'ملابس نسائية',
        icon: Icons.checkroom,
        subCategories: [
          SubCategory(id: '1-1', name: 'فساتين', icon: Icons.style),
          SubCategory(id: '1-2', name: 'ملابس علوية', icon: Icons.checkroom),
          SubCategory(
            id: '1-3',
            name: 'تي شيرتات',
            icon: Icons.sentiment_satisfied_alt,
          ),
          SubCategory(id: '1-4', name: 'بلايز', icon: Icons.dry_cleaning),
          SubCategory(id: '1-5', name: 'سراويل', icon: Icons.downhill_skiing),
          SubCategory(id: '1-6', name: 'تنانير', icon: Icons.girl),
        ],
      ),
      MainCategory(
        id: '2',
        name: 'ملابس رجالية',
        icon: Icons.man,
        subCategories: [
          SubCategory(id: '2-1', name: 'قمصان', icon: Icons.checkroom),
          SubCategory(
            id: '2-2',
            name: 'تي شيرتات',
            icon: Icons.sentiment_satisfied_alt,
          ),
          SubCategory(id: '2-3', name: 'بناطيل', icon: Icons.downhill_skiing),
          SubCategory(id: '2-4', name: 'بدلات', icon: Icons.business_center),
          SubCategory(id: '2-5', name: 'جاكيتات', icon: Icons.shield),
        ],
      ),
      MainCategory(
        id: '3',
        name: 'إلكترونيات',
        icon: Icons.phone_android,
        subCategories: [
          SubCategory(id: '3-1', name: 'هواتف ذكية', icon: Icons.smartphone),
          SubCategory(id: '3-2', name: 'حواسيب محمولة', icon: Icons.laptop),
          SubCategory(id: '3-3', name: 'أجهزة لوحية', icon: Icons.tablet),
          SubCategory(id: '3-4', name: 'ساعات ذكية', icon: Icons.watch),
          SubCategory(id: '3-5', name: 'سماعات', icon: Icons.headphones),
        ],
      ),
      MainCategory(
        id: '4',
        name: 'منزل وديكور',
        icon: Icons.home_outlined,
        subCategories: [
          SubCategory(id: '4-1', name: 'أثاث', icon: Icons.chair),
          SubCategory(id: '4-2', name: 'إضاءة', icon: Icons.lightbulb),
          SubCategory(id: '4-3', name: 'مفروشات', icon: Icons.bed),
          SubCategory(id: '4-4', name: 'ديكورات', icon: Icons.format_paint),
          SubCategory(id: '4-5', name: 'أدوات مطبخ', icon: Icons.kitchen),
        ],
      ),
      MainCategory(
        id: '5',
        name: 'جمال وعناية',
        icon: Icons.face,
        subCategories: [
          SubCategory(id: '5-1', name: 'عطور', icon: Icons.spa),
          SubCategory(id: '5-2', name: 'مكياج', icon: Icons.brush),
          SubCategory(
            id: '5-3',
            name: 'عناية بالبشرة',
            icon: Icons.face_retouching_natural,
          ),
          SubCategory(id: '5-4', name: 'عناية بالشعر', icon: Icons.content_cut),
        ],
      ),
      MainCategory(
        id: '6',
        name: 'رياضة',
        icon: Icons.sports_soccer,
        subCategories: [
          SubCategory(
            id: '6-1',
            name: 'ملابس رياضية',
            icon: Icons.sports_handball,
          ),
          SubCategory(
            id: '6-2',
            name: 'أحذية رياضية',
            icon: Icons.sports_baseball,
          ),
          SubCategory(
            id: '6-3',
            name: 'معدات رياضية',
            icon: Icons.fitness_center,
          ),
          SubCategory(id: '6-4', name: 'مكملات غذائية', icon: Icons.restaurant),
        ],
      ),
    ];
  }
}
