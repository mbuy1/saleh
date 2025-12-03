import 'package:flutter/material.dart';
import '../../../../shared/widgets/shein/shein_top_bar.dart';
import '../../../../shared/widgets/shein/shein_search_bar.dart';
import '../../../../shared/widgets/shein/shein_category_bar.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../shared/widgets/store_card_compact.dart';
import '../../../../core/data/repositories/store_repository.dart';
import '../../../../core/data/models.dart';
import 'store_details_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
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
              hintText: 'ابحث عن متجر...',
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

          // قائمة المتاجر
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= _stores.length) {
                      return const SizedBox.shrink();
                    }
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
                  childCount: _stores.length,
                ),
              ),
            ),
        ],
      ),
      drawer: _buildDrawer(),
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
        ],
      ),
    );
  }
}

