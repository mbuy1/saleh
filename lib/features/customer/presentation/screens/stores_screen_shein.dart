import 'package:flutter/material.dart';
import '../../../../shared/widgets/shein/shein_category_bar.dart';
import '../../../../shared/widgets/shein/shein_banner_carousel.dart';
import '../../../../shared/widgets/shein/shein_look_card.dart';
import '../../../../shared/widgets/shein/shein_category_icon.dart';
import '../../../../shared/widgets/shein/shein_promotional_banner.dart';
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
  List<Map<String, dynamic>> _storeCategories = [];
  bool _isLoadingCategories = false;

  // فئات المتاجر (منفصلة عن فئات المنتجات)
  final List<Map<String, dynamic>> _defaultStoreCategories = [
    {'id': null, 'name': 'كل', 'type': 'all'},
    {'id': 'featured', 'name': 'المتاجر المميزة', 'type': 'featured'},
    {'id': 'best_selling', 'name': 'الأكثر مبيعاً', 'type': 'best_selling'},
    {'id': 'top_rated', 'name': 'الأعلى تقييماً', 'type': 'top_rated'},
    {'id': 'nearby', 'name': 'قريب منك', 'type': 'nearby'},
  ];

  final StoreRepository _storeRepository = StoreRepository();

  @override
  void initState() {
    super.initState();
    _loadStoreCategories();
    _loadStores();
  }

  Future<void> _loadStoreCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      // يمكن جلب فئات المتاجر من API في المستقبل
      // حالياً نستخدم الفئات الافتراضية
      if (mounted) {
        setState(() {
          _storeCategories = _defaultStoreCategories;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      // Fallback إلى فئات افتراضية
      if (mounted) {
        setState(() {
          _storeCategories = _defaultStoreCategories;
          _isLoadingCategories = false;
        });
      }
    }
  }

  Future<void> _loadStores() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // إذا كانت فئة محددة، فلنستخدمها للتصفية
      String? categoryType;
      if (_selectedCategoryIndex > 0 && _storeCategories.isNotEmpty) {
        final selectedCategory = _storeCategories[_selectedCategoryIndex];
        categoryType = selectedCategory['type'] as String?;
      }

      List<Store> stores;
      if (categoryType == 'featured') {
        // المتاجر المميزة
        stores = await _storeRepository.getAllStores();
        stores = stores.where((s) => s.isVerified == true).toList();
      } else if (categoryType == 'best_selling') {
        // الأكثر مبيعاً (يمكن إضافة منطق لاحقاً)
        stores = await _storeRepository.getAllStores();
      } else if (categoryType == 'top_rated') {
        // الأعلى تقييماً (يمكن إضافة منطق لاحقاً)
        stores = await _storeRepository.getAllStores();
        stores.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (categoryType == 'nearby') {
        // قريب منك (يمكن إضافة منطق لاحقاً)
        stores = await _storeRepository.getAllStores();
      } else {
        // كل المتاجر
        stores = await _storeRepository.getAllStores();
      }

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
                    // شريط الفئات ملتصق مباشرة (فئات المتاجر - منفصلة عن فئات المنتجات)
                    _isLoadingCategories
                        ? const SizedBox(height: 48)
                        : SheinCategoryBar(
                            categories: _storeCategories
                                .map((cat) => cat['name'] as String)
                                .toList(),
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
    // ملاحظة: يجب جلب الفئات من قاعدة البيانات بدلاً من استخدام أرقام ثابتة
    // TODO: جلب الفئات من API واستخدام UUIDs الحقيقية
    final looks = <Map<String, dynamic>>[];

    // إذا لم تكن هناك فئات، نستخدم قائمة فارغة
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
                final id = look['id']?.toString();
                if (id == null || id.isEmpty || id == '0') {
                  // لا نعرض البطاقة إذا لم يكن هناك UUID صالح
                  return const SizedBox.shrink();
                }
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
    // ملاحظة: يجب جلب الفئات من قاعدة البيانات بدلاً من استخدام أرقام ثابتة
    // هذا placeholder - يجب استبداله بجلب الفئات الحقيقية
    // TODO: جلب الفئات من API واستخدام UUIDs الحقيقية
    final categories = <Map<String, dynamic>>[];

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
                final categoryId = category['id'] as String?;
                if (categoryId != null && categoryId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryProductsScreenShein(
                        categoryId: categoryId,
                        categoryName: category['name'] as String? ?? 'فئة',
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
    // ملاحظة: يجب جلب الفئات من قاعدة البيانات بدلاً من استخدام أرقام ثابتة
    // TODO: جلب الفئات من API واستخدام UUIDs الحقيقية
    final banners = <Map<String, dynamic>>[];

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
