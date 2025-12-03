import 'package:flutter/material.dart';
import '../../../../shared/widgets/shein/shein_top_bar.dart';
import '../../../../shared/widgets/shein/shein_search_bar.dart';
import '../../../../shared/widgets/shein/shein_category_bar.dart';
import '../../../../shared/widgets/shein/shein_banner_carousel.dart';
import '../../../../shared/widgets/shein/shein_look_card.dart';
import '../../../../shared/widgets/shein/shein_category_icon.dart';
import '../../../../shared/widgets/shein/shein_promotional_banner.dart';
import '../../../../core/services/cloudflare_helper.dart';
import 'category_products_screen_shein.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../../data/cart_service.dart';
import '../../../../core/supabase_client.dart';
import '../../../../shared/widgets/product_card_compact.dart';
import '../../../../core/data/models.dart';

/// الصفحة الرئيسية بتصميم SHEIN
class HomeScreenShein extends StatefulWidget {
  final String? userRole;

  const HomeScreenShein({super.key, this.userRole});

  @override
  State<HomeScreenShein> createState() => _HomeScreenSheinState();
}

class _HomeScreenSheinState extends State<HomeScreenShein> {
  int _selectedCategoryIndex = 1; // "نساء" هو الافتراضي
  int _cartItemCount = 0;
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
    _loadCartCount();
    _loadFeaturedProducts();
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

  Future<void> _loadFeaturedProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      final response = await supabaseClient
          .from('products')
          .select()
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .limit(10);

      final products = (response as List).map((data) {
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
      backgroundColor: Colors.white,
      appBar: SheinTopBar(
        logoText: 'mBuy',
        actions: [
          // أيقونة الإشعارات
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none, size: 24, color: Colors.black87),
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
              hintText: 'البحث',
              bagBadgeCount: _cartItemCount,
              hasMessageNotification: true,
              onSearchTap: () {
                // Navigate to search
              },
              onBagTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartScreen(userRole: widget.userRole)),
                );
              },
              onHeartTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
              onMessageTap: () {
                // Navigate to messages
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
                // إعادة تحميل المنتجات عند تغيير الفئة
                _loadFeaturedProducts();
              },
              onMenuTap: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),

          // المحتوى الرئيسي
          SliverList(
            delegate: SliverChildListDelegate([
              // 1. البانر الرئيسي (Carousel)
              SheinBannerCarousel(
                banners: [
                  {
                    'imageUrl': CloudflareHelper.getDefaultPlaceholderImage(
                      width: 400,
                      height: 280,
                      text: 'ألوان الشتاء الرائجة',
                    ),
                    'title': 'ألوان الشتاء الرائجة',
                    'buttonText': 'تسوقي الآن',
                  },
                  {
                    'imageUrl': CloudflareHelper.getDefaultPlaceholderImage(
                      width: 400,
                      height: 280,
                      text: 'عروض خاصة',
                    ),
                    'title': 'عروض خاصة',
                    'buttonText': 'تسوقي الآن',
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
      drawer: _buildDrawer(),
    );
  }

  Widget _buildLooksSection() {
    final looks = [
      {
        'image': _getLookImage('looks/daily', 'إطلالات يومية', 140, 200),
        'name': 'إطلالات يومية',
        'id': '1'
      },
      {
        'image': _getLookImage('looks/modest', 'محتشمة', 140, 200),
        'name': 'محتشمة',
        'id': '2'
      },
      {
        'image': _getLookImage('looks/work', 'عمل', 140, 200),
        'name': 'عمل',
        'id': '3'
      },
      {
        'image': _getLookImage('looks/party', 'حفلات', 140, 200),
        'name': 'حفلات',
        'id': '4'
      },
      {
        'image': _getLookImage('looks/date', 'موعد في', 140, 200),
        'name': 'موعد في',
        'id': '5'
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
        'image': _getCategoryImage('1', 'ملابس علوية'),
        'name': 'ملابس علوية',
        'id': '1'
      },
      {
        'image': _getCategoryImage('2', 'ملابس سفلية'),
        'name': 'ملابس سفلية',
        'id': '2'
      },
      {
        'image': _getCategoryImage('3', 'فساتين'),
        'name': 'فساتين',
        'id': '3'
      },
      {
        'image': _getCategoryImage('4', 'بلایز'),
        'name': 'بلایز',
        'id': '4'
      },
      {
        'image': _getCategoryImage('5', 'بدلات'),
        'name': 'بدلات',
        'id': '5'
      },
      {
        'image': _getCategoryImage('6', 'تيشيرتات'),
        'name': 'تيشيرتات',
        'id': '6'
      },
      {
        'image': _getCategoryImage('7', 'أطقم منسقة'),
        'name': 'أطقم منسقة',
        'id': '7'
      },
      {
        'image': _getCategoryImage('8', 'بناطيل'),
        'name': 'بناطيل',
        'id': '8'
      },
      {
        'image': _getCategoryImage('9', 'الدنيم'),
        'name': 'الدنيم',
        'id': '9'
      },
      {
        'image': _getCategoryImage('10', 'جمبسوت'),
        'name': 'جمبسوت وبوديسون',
        'id': '10'
      },
      {
        'image': _getCategoryImage('11', 'جينز'),
        'name': 'جينز',
        'id': '11'
      },
      {
        'image': _getCategoryImage('12', 'منسوجة'),
        'name': 'ملابس منسوجة',
        'id': '12'
      },
      {
        'image': _getCategoryImage('13', 'تنانير'),
        'name': 'تنانير',
        'id': '13'
      },
      {
        'image': _getCategoryImage('14', 'حفلات'),
        'name': 'ملابس الحفلات',
        'id': '14'
      },
      {
        'image': _getCategoryImage('15', 'فساتين طو'),
        'name': 'فساتين طو',
        'id': '15'
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
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 400, height: 120, text: 'جاذبية أنيقة') 
            ?? 'https://via.placeholder.com/400x120/90EE90/000000?text=جاذبية+أنيقة',
        'title': 'جاذبية أنيقة',
        'id': '1'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 400, height: 120, text: 'الضروريات الموسمية') 
            ?? 'https://via.placeholder.com/400x120/FFB6C1/000000?text=الضروريات+الموسمية',
        'title': 'الضروريات الموسمية',
        'id': '2'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 400, height: 120, text: 'أهم الترندات') 
            ?? 'https://via.placeholder.com/400x120/D3D3D3/000000?text=أهم+الترندات',
        'title': 'أهم الترندات',
        'id': '3'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 400, height: 120, text: 'كاجوال') 
            ?? 'https://via.placeholder.com/400x120/FFE4B5/000000?text=كاجوال',
        'title': 'كاجوال',
        'id': '4'
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
                return ProductCardCompact(
                  product: product,
                  width: 160,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// الحصول على صورة الفئة من Cloudflare أو placeholder
  String _getCategoryImage(String categoryId, String categoryName) {
    // محاولة استخدام R2 أولاً (إذا كانت الصور موجودة هناك)
    final r2Path = 'categories/icons/category-$categoryId.png';
    final r2Url = CloudflareHelper.buildR2ImageUrl(r2Path, width: 80, height: 80);
    if (r2Url != null) {
      return r2Url;
    }
    
    // إذا لم تكن موجودة في R2، استخدم placeholder
    return CloudflareHelper.getDefaultPlaceholderImage(
      width: 80,
      height: 80,
      text: categoryName,
    );
  }

  /// الحصول على صورة Look من Cloudflare أو placeholder
  String _getLookImage(String lookPath, String lookName, int width, int height) {
    // محاولة استخدام R2 أولاً
    final r2Path = '$lookPath.jpg';
    final r2Url = CloudflareHelper.buildR2ImageUrl(r2Path, width: width, height: height);
    if (r2Url != null) {
      return r2Url;
    }
    
    // إذا لم تكن موجودة في R2، استخدم placeholder
    return CloudflareHelper.getDefaultPlaceholderImage(
      width: width,
      height: height,
      text: lookName,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

