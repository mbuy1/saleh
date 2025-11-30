import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import '../../data/cart_service.dart';

class ExploreScreen extends StatelessWidget {
  final String? userRole; // 'customer' أو 'merchant'

  const ExploreScreen({super.key, this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استكشف'),
        actions: [
          // قائمة في أعلى يمين (3 خطوط)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              // TODO: إضافة منطق لكل خيار
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم اختيار: $value')),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'explore',
                child: Row(
                  children: [
                    Icon(Icons.explore, size: 20),
                    SizedBox(width: 8),
                    Text('استكشف'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'friends',
                child: Row(
                  children: [
                    Icon(Icons.people, size: 20),
                    SizedBox(width: 8),
                    Text('الأصدقاء'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'trending',
                child: Row(
                  children: [
                    Icon(Icons.trending_up, size: 20),
                    SizedBox(width: 8),
                    Text('الترند'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _ExploreScreenContent(userRole: userRole),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد منتجات متاحة',
          style: TextStyle(fontSize: 18, color: Colors.grey),
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // صورة/Container Placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 64,
                color: Colors.grey,
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
                      const Icon(Icons.store, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        store['name'] ?? 'متجر',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                if (store != null) const SizedBox(height: 8),
                // عنوان المنتج
                Text(
                  product['name'] ?? 'بدون اسم',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (product['description'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    product['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  '${product['price'] ?? 0} ر.س',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                // أزرار
                // ملاحظة: زر "شراء الآن" يعمل فقط للعميل (role == 'customer')
                // التاجر في وضع Viewer Mode: لا يمكنه الشراء أو إضافة للسلة
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: userRole == 'customer' && product['id'] != null
                            ? () async {
                                try {
                                  await CartService.addToCart(product['id']);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم إضافة المنتج إلى السلة'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('خطأ: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            : null, // معطل للتاجر (Viewer Mode)
                        icon: const Icon(Icons.shopping_bag),
                        label: const Text('شراء الآن'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: إضافة منطق "الانتقال إلى المتجر"
                          // - جلب معلومات المتجر من جدول stores
                          // - تتبع الحدث في Firebase Analytics (view_store)
                          // - الانتقال إلى صفحة المتجر
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('الانتقال إلى المتجر')),
                          );
                        },
                        icon: const Icon(Icons.store),
                        label: const Text('المتجر'),
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

