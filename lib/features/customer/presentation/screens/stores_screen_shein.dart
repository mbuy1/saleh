import 'package:flutter/material.dart';
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
import 'profile_screen.dart';
import 'category_products_screen_shein.dart';

/// صفحة المتاجر بتصميم SHEIN
class StoresScreenShein extends StatefulWidget {
  final String? userRole;

  const StoresScreenShein({super.key, this.userRole});

  @override
  State<StoresScreenShein> createState() => _StoresScreenSheinState();
}

class _StoresScreenSheinState extends State<StoresScreenShein> {
  int _selectedCategoryIndex = 0;
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
    _loadStores();
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFFF6B6B), const Color(0xFFFF5252)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // بانر ممتد لأعلى الشاشة
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      // شريط البحث مع mBuy والإشعارات
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            // اسم mBuy على اليمين
                            Text(
                              'mBuy',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // شريط البحث في المنتصف
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: 'ابحث عن متجر...',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 14,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // أيقونة الإشعارات على اليسار
                            Stack(
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                Positioned(
                                  right: 4,
                                  top: 0,
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
                          ],
                        ),
                      ),
                      // شريط الفئات ملتصق مباشرة
                      SheinCategoryBar(
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
                    ],
                  ),
                ),
              ),
            ),

            // المحتوى الرئيسي
            SliverList(
              delegate: SliverChildListDelegate([
                // 1. Hero Banner الرئيسي (Carousel)
                SheinBannerCarousel(
                  banners: [
                    {
                      'imageUrl':
                          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=600&fit=crop',
                      'title': 'اكتشف المتاجر',
                      'subtitle': 'تسوق من أفضل المتاجر المحلية',
                    },
                    {
                      'imageUrl':
                          'https://images.unsplash.com/photo-1555421689-491a97ff2040?w=800&h=600&fit=crop',
                      'title': 'عروض المتاجر',
                      'subtitle': 'خصومات حصرية وعروض مميزة',
                    },
                    {
                      'imageUrl':
                          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=800&h=600&fit=crop',
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
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildLooksSection() {
    final looks = [
      {
        'image':
            'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=280&h=400&fit=crop',
        'name': 'متاجر نسائية',
        'id': '1',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1490578474895-699cd4e2cf59?w=280&h=400&fit=crop',
        'name': 'متاجر رجالية',
        'id': '2',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=280&h=400&fit=crop',
        'name': 'متاجر إلكترونيات',
        'id': '3',
      },
      {
        'image':
            CloudflareHelper.getDefaultPlaceholderImage(
              width: 140,
              height: 200,
              text: 'متاجر منزلية',
            ) ??
            'https://images.unsplash.com/photo-1484101403633-562f891dc89a?w=280&h=400&fit=crop',
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
                final imageUrl =
                    look['image'] ??
                    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=280&h=400&fit=crop';
                final name = look['name'] ?? 'متجر';
                final id = look['id'] ?? '0';
                return SheinLookCard(
                  imageUrl: imageUrl,
                  categoryName: name,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryProductsScreenShein(
                          categoryId: id,
                          categoryName: name,
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
        'image':
            'https://images.unsplash.com/photo-1445205170230-053b83016050?w=200&h=200&fit=crop',
        'name': 'ملابس',
        'id': '1',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=200&h=200&fit=crop',
        'name': 'إلكترونيات',
        'id': '2',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1484101403633-562f891dc89a?w=200&h=200&fit=crop',
        'name': 'منزلية',
        'id': '3',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=200&h=200&fit=crop',
        'name': 'أحذية',
        'id': '4',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1492707892479-7bc8d5a4ee93?w=200&h=200&fit=crop',
        'name': 'إكسسوارات',
        'id': '5',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=200&h=200&fit=crop',
        'name': 'رياضة',
        'id': '6',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=200&h=200&fit=crop',
        'name': 'حقائب',
        'id': '7',
      },
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: SheinCategoryIcon(
              imageUrl: category['image']!,
              categoryName: category['name']!,
              size: 75,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromotionalBanners() {
    final banners = [
      {
        'image':
            CloudflareHelper.getDefaultPlaceholderImage(
              width: 400,
              height: 120,
              text: 'متاجر مميزة',
            ) ??
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=120&fit=crop',
        'title': 'متاجر مميزة',
        'id': '1',
      },
      {
        'image':
            CloudflareHelper.getDefaultPlaceholderImage(
              width: 400,
              height: 120,
              text: 'عروض خاصة',
            ) ??
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=400&h=120&fit=crop',
        'title': 'عروض خاصة',
        'id': '2',
      },
    ];

    return Column(
      children: banners.map((banner) {
        final imageUrl = banner['image'] as String;
        final title = banner['title'] as String;
        final id = banner['id'] as String;
        return SheinPromotionalBanner(
          imageUrl: imageUrl,
          title: title,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryProductsScreenShein(
                  categoryId: id,
                  categoryName: title,
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
