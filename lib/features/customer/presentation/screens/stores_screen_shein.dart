import 'package:flutter/material.dart';
import '../../../../shared/widgets/shein/shein_top_bar.dart';
import '../../../../shared/widgets/shein/shein_search_bar.dart';
import '../../../../shared/widgets/shein/shein_category_bar.dart';
import '../../../../shared/widgets/shein/shein_banner_carousel.dart';
import '../../../../shared/widgets/shein/shein_look_card.dart';
import '../../../../shared/widgets/shein/shein_category_icon.dart';
import '../../../../shared/widgets/shein/shein_promotional_banner.dart';
import '../../../../core/services/cloudflare_helper.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../shared/widgets/store_card_compact.dart';
import '../../../../core/data/repositories/store_repository.dart';
import '../../../../core/data/models.dart';
import 'store_details_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'category_products_screen_shein.dart';
import '../../data/cart_service.dart';

/// صفحة المتاجر بتصميم SHEIN
class StoresScreenShein extends StatefulWidget {
  final String? userRole;

  const StoresScreenShein({super.key, this.userRole});

  @override
  State<StoresScreenShein> createState() => _StoresScreenSheinState();
}

class _StoresScreenSheinState extends State<StoresScreenShein> {
  int _selectedCategoryIndex = 0;
  int _cartItemCount = 0;
  List<Store> _stores = [];
  bool _isLoading = true;

  final List<String> _categories = [
    'كل',
    'المتاجر المميزة',
    'الأكثر مبيعاً',
    'الأعلى تقييماً',
    'قريب منك',
  ];

  final StoreRepository _storeRepository = StoreRepository();

  @override
  void initState() {
    super.initState();
    _loadCartCount();
    _loadStores();
  }

  Future<void> _loadCartCount() async {
    try {
      final items = await CartService.getCartItems();
      if (mounted) {
        setState(() {
          _cartItemCount = items.length;
        });
      }
    } catch (e) {
      // تجاهل الخطأ
    }
  }

  Future<void> _loadStores() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stores = await _storeRepository.getAllStores();
      if (mounted) {
        setState(() {
          _stores = stores;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _stores = DummyData.stores;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SheinTopBar(
        logoText: 'mBuy',
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_none,
                  size: 24,
                  color: Colors.black87,
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // شريط البحث
          SliverToBoxAdapter(
            child: SheinSearchBar(
              hintText: 'ابحث عن متجر...',
              bagBadgeCount: _cartItemCount,
              hasMessageNotification: true,
              onSearchTap: () {
                // Navigate to search
              },
              onBagTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartScreen(userRole: widget.userRole),
                  ),
                );
              },
              onHeartTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
          ),

          // قائمة الفئات
          SliverToBoxAdapter(
            child: SheinCategoryBar(
              categories: _categories,
              initialIndex: _selectedCategoryIndex,
              onCategoryChanged: (index) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
                _loadStores();
              },
              onMenuTap: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),

          // المحتوى الرئيسي
          SliverList(
            delegate: SliverChildListDelegate([
              // 1. Hero Banner الرئيسي (Carousel)
              SheinBannerCarousel(
                banners: [
                  {
                    'imageUrl': CloudflareHelper.getDefaultPlaceholderImage(
                      width: 400,
                      height: 320,
                      text: 'اكتشف المتاجر',
                    ),
                    'title': 'اكتشف المتاجر',
                    'subtitle': 'تسوق من أفضل المتاجر المحلية',
                  },
                  {
                    'imageUrl': CloudflareHelper.getDefaultPlaceholderImage(
                      width: 400,
                      height: 320,
                      text: 'عروض المتاجر',
                    ),
                    'title': 'عروض المتاجر',
                    'subtitle': 'خصومات حصرية وعروض مميزة',
                  },
                  {
                    'imageUrl': CloudflareHelper.getDefaultPlaceholderImage(
                      width: 400,
                      height: 320,
                      text: 'متاجر مميزة',
                    ),
                    'title': 'متاجر مميزة',
                    'subtitle': 'اكتشف أفضل العلامات التجارية',
                  },
                ],
              ),

              // 2. صف أفقي من Looks (بطاقات مع صور عارضات)
              _buildLooksSection(),

              // 3. شبكة من الأيقونات الدائرية للفئات
              _buildCategoryIconsGrid(),

              // 4. بانرات ترويجية إضافية
              _buildPromotionalBanners(),

              // 5. قائمة المتاجر
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                _buildStoresGrid(),

              const SizedBox(height: 80), // مساحة للشريط السفلي
            ]),
          ),
        ],
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildLooksSection() {
    final looks = [
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 140,
          height: 200,
          text: 'متاجر نسائية',
        ),
        'name': 'متاجر نسائية',
        'id': '1',
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 140,
          height: 200,
          text: 'متاجر رجالية',
        ),
        'name': 'متاجر رجالية',
        'id': '2',
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 140,
          height: 200,
          text: 'متاجر إلكترونيات',
        ),
        'name': 'متاجر إلكترونيات',
        'id': '3',
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 140,
          height: 200,
          text: 'متاجر منزلية',
        ),
        'name': 'متاجر منزلية',
        'id': '4',
      },
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'اكتشف المزيد',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              itemCount: looks.length,
              itemBuilder: (context, index) {
                final look = looks[index];
                return SheinLookCard(
                  imageUrl: look['image']!,
                  categoryName: look['name']!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryProductsScreenShein(
                          categoryId: look['id']!,
                          categoryName: look['name']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIconsGrid() {
    final categories = [
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 80,
          height: 80,
          text: 'ملابس',
        ),
        'name': 'ملابس',
        'id': '1',
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 80,
          height: 80,
          text: 'إلكترونيات',
        ),
        'name': 'إلكترونيات',
        'id': '2',
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 80,
          height: 80,
          text: 'منزلية',
        ),
        'name': 'منزلية',
        'id': '3',
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 80,
          height: 80,
          text: 'أحذية',
        ),
        'name': 'أحذية',
        'id': '4',
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 80,
          height: 80,
          text: 'إكسسوارات',
        ),
        'name': 'إكسسوارات',
        'id': '5',
      },
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return SheinCategoryIcon(
            imageUrl: category['image']!,
            categoryName: category['name']!,
            size: 65,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryProductsScreenShein(
                    categoryId: category['id']!,
                    categoryName: category['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPromotionalBanners() {
    final banners = [
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 400,
          height: 120,
          text: 'متاجر مميزة',
        ),
        'title': 'متاجر مميزة',
        'id': '1',
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 400,
          height: 120,
          text: 'عروض خاصة',
        ),
        'title': 'عروض خاصة',
        'id': '2',
      },
    ];

    return Column(
      children: banners.map((banner) {
        return SheinPromotionalBanner(
          imageUrl: banner['image']!,
          title: banner['title'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryProductsScreenShein(
                  categoryId: banner['id']!,
                  categoryName: banner['title']!,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildStoresGrid() {
    if (_stores.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'لا توجد متاجر متاحة',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _stores.length,
        itemBuilder: (context, index) {
          final store = _stores[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoreDetailsScreen(
                    storeId: store.id,
                    storeName: store.name,
                  ),
                ),
              );
            },
            child: StoreCardCompact(store: store),
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.black87),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'mBuy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'تطبيق التسوق',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
