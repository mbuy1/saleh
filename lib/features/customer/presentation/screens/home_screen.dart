import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../shared/widgets/mbuy_loader.dart';
import '../../../../shared/widgets/profile_button.dart';
import '../../../../shared/widgets/categories_bar.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../data/cart_service.dart';

class HomeScreen extends StatefulWidget {
  final String? userRole; // 'customer' أو 'merchant'

  const HomeScreen({super.key, this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String _selectedCategoryId = 'all';
  bool _useDummyData = false; // تبديل بين البيانات الحقيقية والوهمية

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_useDummyData) {
        // استخدام البيانات الوهمية
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // محاكاة التحميل
        final products = DummyData.getProductsByCategory(_selectedCategoryId);
        setState(() {
          _products = products.map((p) => p.toJson()).toList();
        });
      } else {
        // جلب من Supabase
        final response = await supabaseClient
            .from('products')
            .select()
            .eq('status', 'active')
            .limit(20)
            .order('created_at', ascending: false);

        setState(() {
          _products = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      // في حالة فشل Supabase، استخدم البيانات الوهمية
      final products = DummyData.getProductsByCategory(_selectedCategoryId);
      setState(() {
        _products = products.map((p) => p.toJson()).toList();
        _useDummyData = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم التحويل للبيانات التجريبية'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // شريط البحث والفلاتر
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان مع أيقونة الحساب وزر العودة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'الرئيسية',
                              style: GoogleFonts.cairo(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        const ProfileButton(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // شريط البحث
                    const MbuySearchBar(hintText: 'ابحث عن منتج...'),
                    const SizedBox(height: 12),
                    // زر عرض جميع الفئات
                    InkWell(
                      onTap: () {
                        // TODO: Navigate to all categories screen
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: MbuyColors.borderLight),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.grid_view_rounded,
                              size: 20,
                              color: MbuyColors.primaryPurple,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'عرض جميع الفئات',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: MbuyColors.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // شريط الفئات
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CategoriesBar(
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: (categoryId) {
                    setState(() {
                      _selectedCategoryId = categoryId;
                    });
                    _loadProducts();
                  },
                ),
              ),
            ),

            // المنتجات
            if (_isLoading)
              const SliverFillRemaining(child: Center(child: MbuyLoader()))
            else if (_products.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: MbuyColors.cardGradient,
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'لا توجد منتجات متاحة',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تحقق مرة أخرى قريبًا',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
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
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildProductCard(_products[index]);
                  }, childCount: _products.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isCustomer = widget.userRole == 'customer';
    final productId = product['id'] as String?;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: MbuyColors.primaryBlue.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // Navigate to product details
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Modern Image with Gradient
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: MbuyColors.cardGradient,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Subtle Overlay
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Product Info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name
                      Text(
                        product['name'] ?? 'بدون اسم',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Price & Add Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: MbuyColors.successGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${product['price'] ?? 0} ر.س',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Add to Cart Button - للعميل فقط
                          if (isCustomer && productId != null)
                            Container(
                              decoration: BoxDecoration(
                                gradient: MbuyColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: MbuyColors.primaryBlue.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () async {
                                    if (!mounted) return;
                                    final scaffoldMessenger =
                                        ScaffoldMessenger.of(context);
                                    try {
                                      await CartService.addToCart(productId);
                                      if (mounted) {
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            content: const Row(
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'تم إضافة المنتج إلى السلة',
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.error,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'خطأ: ${e.toString()}',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.add_shopping_cart,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
