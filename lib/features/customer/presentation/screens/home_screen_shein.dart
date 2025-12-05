import 'package:flutter/material.dart';
import '../../../../shared/widgets/shein/shein_category_bar.dart';
import '../../../../shared/widgets/shein/shein_banner_carousel.dart';
import '../../../../shared/widgets/shein/shein_look_card.dart';
import '../../../../shared/widgets/shein/shein_category_icon.dart';
import '../../../../shared/widgets/shein/shein_promotional_banner.dart';
import '../../../../core/services/cloudflare_helper.dart';
import 'category_products_screen_shein.dart';
import 'profile_screen.dart';
import '../../../../shared/widgets/product_card_compact.dart';
import '../../../../core/data/models.dart';
import '../../../../core/services/api_service.dart';

/// الصفحة الرئيسية بتصميم SHEIN
class HomeScreenShein extends StatefulWidget {
  final String? userRole;

  const HomeScreenShein({super.key, this.userRole});

  @override
  State<HomeScreenShein> createState() => _HomeScreenSheinState();
}

class _HomeScreenSheinState extends State<HomeScreenShein> {
  int _selectedCategoryIndex = 1; // "نساء" هو الافتراضي
  List<Product> _featuredProducts = [];
  bool _isLoadingProducts = false;

  final List<String> _categories = [
    'كل',
    'نساء',
    'المنزل + الحيوانات الأليفة',
    'رجال',
    'أحذية',
    'منتج',
  ];

  @override
  void initState() {
    super.initState();
    _loadFeaturedProducts();
  }

  Future<void> _loadFeaturedProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      // استخدام Worker API عبر ApiService (public endpoint)
      final result = await ApiService.getProducts(limit: 10, status: 'active');

      if (result['ok'] == true && result['data'] != null) {
        final products = (result['data'] as List).map((data) {
          return Product(
            id: data['id']?.toString() ?? '',
            name: data['name']?.toString() ?? 'منتج',
            description: data['description']?.toString() ?? '',
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            categoryId: data['category_id']?.toString() ?? '',
            storeId: data['store_id']?.toString() ?? '',
            rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
            reviewCount: (data['review_count'] as num?)?.toInt() ?? 0,
            stockCount: (data['stock'] as num?)?.toInt() ?? 0,
            imageUrl: data['image_url']?.toString(),
          );
        }).toList();

        if (mounted) {
          setState(() {
            _featuredProducts = products;
            _isLoadingProducts = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingProducts = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
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
            colors: [const Color(0xFF00D9B3), const Color(0xFF00B38F)],
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
                                        hintText: 'البحث عن المنتجات...',
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
                          _loadFeaturedProducts();
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
                          'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&h=600&fit=crop',
                      'title': 'ألوان الشتاء الرائجة',
                      'subtitle': 'اكتشفي أحدث صيحات الموضة',
                    },
                    {
                      'imageUrl':
                          'https://images.unsplash.com/photo-1558769132-cb1aea1f8cf5?w=800&h=600&fit=crop',
                      'title': 'عروض خاصة',
                      'subtitle': 'خصومات تصل إلى 70%',
                    },
                    {
                      'imageUrl':
                          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&h=600&fit=crop',
                      'title': 'مجموعات جديدة',
                      'subtitle': 'تسوقي أحدث الإطلالات',
                    },
                  ],
                ),

                // 2. صف أفقي من Looks (بطاقات مع صور عارضات)
                _buildLooksSection(),

                // 3. شبكة من الأيقونات الدائرية للفئات
                _buildCategoryIconsGrid(),

                // 4. بانرات ترويجية إضافية
                _buildPromotionalBanners(),

                // 5. منتجات مميزة
                _buildFeaturedProductsSection(),

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
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=280&h=400&fit=crop',
        'name': 'إطلالات يومية',
        'id': '1',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=280&h=400&fit=crop',
        'name': 'محتشمة',
        'id': '2',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=280&h=400&fit=crop',
        'name': 'عمل',
        'id': '3',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=280&h=400&fit=crop',
        'name': 'حفلات',
        'id': '4',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=280&h=400&fit=crop',
        'name': 'موعد في',
        'id': '5',
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
              'اكتشفي المزيد',
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
    // استخدام صور Cloudflare إذا كانت متاحة، وإلا placeholder
    final categories = [
      {
        'image':
            'https://images.unsplash.com/photo-1618932260643-eee4a2f652a6?w=200&h=200&fit=crop',
        'name': 'ملابس علوية',
        'id': '1',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1624206112918-f140f087f9db?w=200&h=200&fit=crop',
        'name': 'ملابس سفلية',
        'id': '2',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=200&h=200&fit=crop',
        'name': 'فساتين',
        'id': '3',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=200&h=200&fit=crop',
        'name': 'بلایز',
        'id': '4',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=200&h=200&fit=crop',
        'name': 'بدلات',
        'id': '5',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=200&h=200&fit=crop',
        'name': 'تيشيرتات',
        'id': '6',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200&h=200&fit=crop',
        'name': 'أطقم منسقة',
        'id': '7',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=200&h=200&fit=crop',
        'name': 'بناطيل',
        'id': '8',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1542272604-787c3835535d?w=200&h=200&fit=crop',
        'name': 'الدنيم',
        'id': '9',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1591369822096-ffd140ec948f?w=200&h=200&fit=crop',
        'name': 'جمبسوت وبوديسون',
        'id': '10',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1475178626620-a4d074967452?w=200&h=200&fit=crop',
        'name': 'جينز',
        'id': '11',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1467043237213-65f2da53396f?w=200&h=200&fit=crop',
        'name': 'ملابس منسوجة',
        'id': '12',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=200&h=200&fit=crop',
        'name': 'تنانير',
        'id': '13',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=200&h=200&fit=crop',
        'name': 'ملابس الحفلات',
        'id': '14',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1612423284934-2850a4ea6b0f?w=200&h=200&fit=crop',
        'name': 'فساتين طو',
        'id': '15',
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
              text: 'جاذبية أنيقة',
            ) ??
            'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400&h=120&fit=crop',
        'title': 'جاذبية أنيقة',
        'id': '1',
      },
      {
        'image':
            CloudflareHelper.getDefaultPlaceholderImage(
              width: 400,
              height: 120,
              text: 'الضروريات الموسمية',
            ) ??
            'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400&h=120&fit=crop',
        'title': 'الضروريات الموسمية',
        'id': '2',
      },
      {
        'image':
            CloudflareHelper.getDefaultPlaceholderImage(
              width: 400,
              height: 120,
              text: 'أهم الترندات',
            ) ??
            'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400&h=120&fit=crop',
        'title': 'أهم الترندات',
        'id': '3',
      },
      {
        'image':
            CloudflareHelper.getDefaultPlaceholderImage(
              width: 400,
              height: 120,
              text: 'كاجوال',
            ) ??
            'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=400&h=120&fit=crop',
        'title': 'كاجوال',
        'id': '4',
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

  Widget _buildFeaturedProductsSection() {
    if (_isLoadingProducts) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_featuredProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'منتجات مميزة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              itemCount: _featuredProducts.length,
              itemBuilder: (context, index) {
                final product = _featuredProducts[index];
                return ProductCardCompact(product: product, width: 160);
              },
            ),
          ),
        ],
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
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('طلباتي'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('المفضلة'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
