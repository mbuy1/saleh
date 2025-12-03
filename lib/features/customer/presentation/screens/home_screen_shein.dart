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
                    ) ?? 'https://via.placeholder.com/400x280/FF6B9D/FFFFFF?text=ألوان+الشتاء+الرائجة',
                    'title': 'ألوان الشتاء الرائجة',
                    'buttonText': 'تسوقي الآن',
                  },
                  {
                    'imageUrl': CloudflareHelper.getDefaultPlaceholderImage(
                      width: 400,
                      height: 280,
                      text: 'عروض خاصة',
                    ) ?? 'https://via.placeholder.com/400x280/4ECDC4/FFFFFF?text=عروض+خاصة',
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
          text: 'إطلالات يومية',
        ) ?? 'https://via.placeholder.com/140x200/8B4513/FFFFFF?text=إطلالات+يومية',
        'name': 'إطلالات يومية',
        'id': '1'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 140,
          height: 200,
          text: 'محتشمة',
        ) ?? 'https://via.placeholder.com/140x200/556B2F/FFFFFF?text=محتشمة',
        'name': 'محتشمة',
        'id': '2'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 140,
          height: 200,
          text: 'عمل',
        ) ?? 'https://via.placeholder.com/140x200/800020/FFFFFF?text=عمل',
        'name': 'عمل',
        'id': '3'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 140,
          height: 200,
          text: 'حفلات',
        ) ?? 'https://via.placeholder.com/140x200/CD7F32/FFFFFF?text=حفلات',
        'name': 'حفلات',
        'id': '4'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(
          width: 140,
          height: 200,
          text: 'موعد في',
        ) ?? 'https://via.placeholder.com/140x200/8B4513/FFFFFF?text=موعد+في',
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
    final categories = [
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'ملابس علوية') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=ملابس+علوية',
        'name': 'ملابس علوية',
        'id': '1'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'ملابس سفلية') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=ملابس+سفلية',
        'name': 'ملابس سفلية',
        'id': '2'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'فساتين') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=فساتين',
        'name': 'فساتين',
        'id': '3'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'بلایز') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=بلایز',
        'name': 'بلایز',
        'id': '4'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'بدلات') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=بدلات',
        'name': 'بدلات',
        'id': '5'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'تيشيرتات') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=تيشيرتات',
        'name': 'تيشيرتات',
        'id': '6'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'أطقم منسقة') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=أطقم+منسقة',
        'name': 'أطقم منسقة',
        'id': '7'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'بناطيل') 
            ?? 'https://via.placeholder.com/100/FFFFFF/000000?text=بناطيل',
        'name': 'بناطيل',
        'id': '8'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'الدنيم') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=الدنيم',
        'name': 'الدنيم',
        'id': '9'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'جمبسوت') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=جمبسوت',
        'name': 'جمبسوت وبوديسون',
        'id': '10'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'جينز') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=جينز',
        'name': 'جينز',
        'id': '11'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'منسوجة') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=منسوجة',
        'name': 'ملابس منسوجة',
        'id': '12'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'تنانير') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=تنانير',
        'name': 'تنانير',
        'id': '13'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'حفلات') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=حفلات',
        'name': 'ملابس الحفلات',
        'id': '14'
      },
      {
        'image': CloudflareHelper.getDefaultPlaceholderImage(width: 80, height: 80, text: 'فساتين طو') 
            ?? 'https://via.placeholder.com/80/FFFFFF/000000?text=فساتين+طو',
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

