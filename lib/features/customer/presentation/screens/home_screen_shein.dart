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
  int _selectedCategoryIndex = 0; // "كل" هو الافتراضي
  List<Product> _featuredProducts = [];
  bool _isLoadingProducts = false;
  List<Map<String, dynamic>> _productCategories = [];
  bool _isLoadingCategories = false;

  @override
  void initState() {
    super.initState();
    _loadProductCategories();
    _loadFeaturedProducts();
  }

  Future<void> _loadProductCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final response = await ApiService.get(
        '/public/categories',
        requireAuth: false,
      );

      if (response['ok'] == true && response['data'] != null) {
        final allCategories = List<Map<String, dynamic>>.from(response['data']);

        // تصفية الفئات الرئيسية فقط (parent_id == null) وفعالة
        final mainCategories = allCategories
            .where(
              (cat) => cat['parent_id'] == null && (cat['is_active'] == true),
            )
            .toList();

        // ترتيب حسب display_order
        mainCategories.sort((a, b) {
          final orderA = a['display_order'] as int? ?? 0;
          final orderB = b['display_order'] as int? ?? 0;
          return orderA.compareTo(orderB);
        });

        // إضافة "كل" في البداية
        final categoriesList = [
          {'id': null, 'name': 'كل', 'display_order': -1},
        ];
        categoriesList.addAll(mainCategories);

        if (mounted) {
          setState(() {
            _productCategories = categoriesList;
            _isLoadingCategories = false;
          });
        }
      } else {
        // لا نستخدم fallback بأرقام ثابتة - نترك القائمة فارغة
        if (mounted) {
          setState(() {
            _productCategories = [
              {'id': null, 'name': 'كل', 'display_order': -1},
            ];
            _isLoadingCategories = false;
          });
        }
      }
    } catch (e) {
      // لا نستخدم fallback بأرقام ثابتة - نترك القائمة فارغة
      if (mounted) {
        setState(() {
          _productCategories = [
            {'id': null, 'name': 'كل', 'display_order': -1},
          ];
          _isLoadingCategories = false;
        });
      }
    }
  }

  Future<void> _loadFeaturedProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      // استخدام Worker API عبر ApiService (public endpoint)
      // إذا كان هناك فئة محددة، نستخدم UUID الخاص بها
      String? categoryId;
      if (_selectedCategoryIndex > 0 &&
          _selectedCategoryIndex < _productCategories.length) {
        final selectedCategory = _productCategories[_selectedCategoryIndex];
        categoryId = selectedCategory['id']?.toString();
      }

      final result = await ApiService.getProducts(
        limit: 10,
        status: 'active',
        categoryId: categoryId,
      );

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
            // Padding في الأعلى لتجنب التداخل مع شريط البحث Sticky (72 = ارتفاع شريط البحث)
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.of(context).padding.top + 72),
            ),
            // بانر ممتد لأعلى الشاشة
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    // اسم mBuy (بدون شريط البحث - موجود في StickySearchBar)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            'mBuy',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          // أيقونة الإشعارات
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
                    // شريط الفئات ملتصق مباشرة (فئات المنتجات)
                    _isLoadingCategories
                        ? const SizedBox(height: 48)
                        : SheinCategoryBar(
                            categories: _productCategories
                                .map((cat) => cat['name'] as String)
                                .toList(),
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
    // استخدام الفئات الحقيقية من قاعدة البيانات بدلاً من الأرقام الثابتة
    // نستخدم أول 5 فئات من _productCategories (تخطي "كل")
    final looks = _productCategories
        .where((cat) => cat['id'] != null)
        .take(5)
        .map(
          (cat) => {
            'image':
                'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=280&h=400&fit=crop',
            'name': cat['name']?.toString() ?? 'فئة',
            'id': cat['id']?.toString() ?? '',
          },
        )
        .toList();

    // إذا لم تكن هناك فئات كافية، نستخدم قائمة فارغة
    if (looks.isEmpty) {
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
                    final categoryId = look['id']?.toString();
                    if (categoryId != null && categoryId.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryProductsScreenShein(
                            categoryId: categoryId,
                            categoryName: look['name']?.toString() ?? 'فئة',
                          ),
                        ),
                      );
                    }
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
    // استخدام الفئات الحقيقية من قاعدة البيانات بدلاً من الأرقام الثابتة
    final categories = _productCategories
        .where((cat) => cat['id'] != null)
        .map(
          (cat) => {
            'image':
                'https://images.unsplash.com/photo-1618932260643-eee4a2f652a6?w=200&h=200&fit=crop',
            'name': cat['name']?.toString() ?? 'فئة',
            'id': cat['id']?.toString() ?? '',
          },
        )
        .toList();

    // إذا لم تكن هناك فئات، نستخدم قائمة فارغة
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

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
                final categoryId = category['id']?.toString();
                if (categoryId != null && categoryId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryProductsScreenShein(
                        categoryId: categoryId,
                        categoryName: category['name']?.toString() ?? 'فئة',
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromotionalBanners() {
    // استخدام الفئات الحقيقية من قاعدة البيانات بدلاً من الأرقام الثابتة
    // نستخدم أول 4 فئات من _productCategories (تخطي "كل")
    final banners = _productCategories
        .where((cat) => cat['id'] != null)
        .take(4)
        .map(
          (cat) => {
            'image':
                CloudflareHelper.getDefaultPlaceholderImage(
                  width: 400,
                  height: 120,
                  text: cat['name']?.toString() ?? 'فئة',
                ) ??
                'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400&h=120&fit=crop',
            'title': cat['name']?.toString() ?? 'فئة',
            'id': cat['id']?.toString() ?? '',
          },
        )
        .toList();

    // إذا لم تكن هناك فئات، نستخدم قائمة فارغة
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: banners.map((banner) {
        final imageUrl = banner['image'] as String;
        final title = banner['title'] as String;
        final id = banner['id'] as String;
        return SheinPromotionalBanner(
          imageUrl: imageUrl,
          title: title,
          onTap: () {
            if (id.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryProductsScreenShein(
                    categoryId: id,
                    categoryName: title,
                  ),
                ),
              );
            }
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
