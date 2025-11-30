import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/cart_service.dart';
import '../../../../shared/widgets/mbuy_logo.dart';
import '../../../../shared/widgets/mbuy_loader.dart';
import '../../../../shared/widgets/mbuy_buttons.dart';

class ExploreScreen extends StatelessWidget {
  final String? userRole; // 'customer' أو 'merchant'

  const ExploreScreen({super.key, this.userRole});

  @override
  Widget build(BuildContext context) {
    final isMerchant = userRole == 'merchant';

    return Scaffold(
      backgroundColor: MbuyColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header مع الشعار
            _buildHeader(context),
            // رسالة توضيحية للتاجر في وضع Viewer Mode
            if (isMerchant)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: Colors.orange.shade50,
                child: const Row(
                  children: [
                    Icon(Icons.visibility, size: 18, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'أنت في وضع التصفح - لا يمكن الشراء أو إضافة للسلة',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Tabs (Placeholder الآن)
            _buildTabs(context),
            // المحتوى
            Expanded(child: _ExploreScreenContent(userRole: userRole)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // الشعار الدائري الصغير
          MbuyLogo.small(),
          const SizedBox(width: 12),
          // العنوان
          const Expanded(
            child: Text(
              'استكشف',
              style: TextStyle(
                color: MbuyColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arabic',
              ),
            ),
          ),
          // قائمة في أعلى يمين (3 خطوط)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: MbuyColors.textPrimary),
            color: Colors.white,
            onSelected: (value) {
              // TODO: إضافة منطق لكل خيار
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('تم اختيار: $value')));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'explore',
                child: Row(
                  children: [
                    Icon(
                      Icons.explore,
                      size: 20,
                      color: MbuyColors.textPrimary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'استكشف',
                      style: TextStyle(color: MbuyColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'friends',
                child: Row(
                  children: [
                    Icon(Icons.people, size: 20, color: MbuyColors.textPrimary),
                    SizedBox(width: 8),
                    Text(
                      'الأصدقاء',
                      style: TextStyle(color: MbuyColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'trending',
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 20,
                      color: MbuyColors.textPrimary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'الترند',
                      style: TextStyle(color: MbuyColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    // Placeholder الآن - يمكن إضافة Tabs لاحقاً
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: MbuyColors.surface),
      child: Row(
        children: [
          _buildTabButton('استكشف', true),
          const SizedBox(width: 16),
          _buildTabButton('الأصدقاء', false),
          const SizedBox(width: 16),
          _buildTabButton('الترند', false),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isSelected ? MbuyColors.primaryGradient : null,
        color: isSelected ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? null
            : Border.all(color: MbuyColors.surfaceLight, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : MbuyColors.textSecondary,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontFamily: 'Arabic',
        ),
      ),
    );
  }
}

class _ExploreScreenContent extends StatefulWidget {
  final String? userRole;

  const _ExploreScreenContent({this.userRole});

  @override
  State<_ExploreScreenContent> createState() => _ExploreScreenContentState();
}

class _ExploreScreenContentState extends State<_ExploreScreenContent> {
  List<Map<String, dynamic>> _products = [];
  final Map<String, Map<String, dynamic>> _storesMap = {};
  bool _isLoading = true;

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
      // جلب المنتجات مع معلومات المتجر
      final productsResponse = await supabaseClient
          .from('products')
          .select()
          .eq('status', 'active')
          .limit(20)
          .order('created_at', ascending: false);

      final products = List<Map<String, dynamic>>.from(productsResponse);

      // جلب معلومات المتاجر (بشكل منفصل لكل متجر)
      if (products.isNotEmpty) {
        final storeIds = products
            .map((p) => p['store_id'])
            .whereType<String>()
            .toSet();

        for (final storeId in storeIds) {
          try {
            final storeResponse = await supabaseClient
                .from('stores')
                .select()
                .eq('id', storeId)
                .maybeSingle();

            if (storeResponse != null) {
              _storesMap[storeId] = storeResponse;
            }
          } catch (e) {
            // تجاهل الأخطاء في جلب متجر واحد
          }
        }
      }

      setState(() {
        _products = products;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب المنتجات: ${e.toString()}'),
            backgroundColor: Colors.red,
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
    if (_isLoading) {
      return const Center(child: MbuyLoader());
    }

    if (_products.isEmpty) {
      return Center(
        child: Text(
          'لا توجد منتجات متاحة',
          style: TextStyle(
            fontSize: 18,
            color: MbuyColors.textSecondary,
            fontFamily: 'Arabic',
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final store = _storesMap[product['store_id']];
        return _buildExploreItem(context, product, store, widget.userRole);
      },
    );
  }

  Widget _buildExploreItem(
    BuildContext context,
    Map<String, dynamic> product,
    Map<String, dynamic>? store,
    String? userRole,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: MbuyColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // صورة/Container Placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MbuyColors.primaryBlue.withValues(alpha: 0.3),
                  MbuyColors.primaryPurple.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                size: 64,
                color: MbuyColors.textSecondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم التاجر
                if (store != null)
                  Row(
                    children: [
                      Icon(
                        Icons.store,
                        size: 16,
                        color: MbuyColors.primaryBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        store['name'] ?? 'متجر',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MbuyColors.primaryBlue,
                          fontFamily: 'Arabic',
                        ),
                      ),
                    ],
                  ),
                if (store != null) const SizedBox(height: 8),
                // عنوان المنتج
                Text(
                  product['name'] ?? 'بدون اسم',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: MbuyColors.textPrimary,
                    fontFamily: 'Arabic',
                  ),
                ),
                if (product['description'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    product['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: MbuyColors.textSecondary,
                      fontFamily: 'Arabic',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '${product['price'] ?? 0} ر.س',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MbuyColors.primaryBlue,
                    fontFamily: 'Arabic',
                  ),
                ),
                const SizedBox(height: 12),
                // أزرار
                // ملاحظة: زر "شراء الآن" يعمل فقط للعميل (role == 'customer')
                // التاجر في وضع Viewer Mode: لا يمكنه الشراء أو إضافة للسلة
                Row(
                  children: [
                    Expanded(
                      child: MbuySecondaryButton(
                        text: 'شراء الآن',
                        icon: Icons.shopping_bag,
                        onPressed:
                            userRole == 'customer' && product['id'] != null
                            ? () async {
                                try {
                                  await CartService.addToCart(product['id']);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'تم إضافة المنتج إلى السلة',
                                        ),
                                        backgroundColor: MbuyColors.success,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('خطأ: ${e.toString()}'),
                                        backgroundColor: MbuyColors.error,
                                      ),
                                    );
                                  }
                                }
                              }
                            : null, // معطل للتاجر (Viewer Mode)
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: MbuyPrimaryButton(
                        text: 'المتجر',
                        icon: Icons.store,
                        onPressed: () {
                          // TODO: إضافة منطق "الانتقال إلى المتجر"
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('الانتقال إلى المتجر'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
