import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/permissions_helper.dart';
import '../../data/cart_service.dart';
import '../../data/favorites_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Map<String, dynamic>? _product;
  Map<String, dynamic>? _store;
  bool _isLoading = true;
  bool _isAddingToCart = false;
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isTogglingFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // جلب تفاصيل المنتج
      final productResponse = await supabaseClient
          .from('products')
          .select()
          .eq('id', widget.productId)
          .single();

      // جلب معلومات المتجر
      final storeResponse = await supabaseClient
          .from('stores')
          .select()
          .eq('id', productResponse['store_id'])
          .single();

      // التحقق إذا كان في المفضلة
      final isFav = await FavoritesService.isFavorite(widget.productId);

      setState(() {
        _product = productResponse;
        _store = storeResponse;
        _isFavorite = isFav;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب التفاصيل: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addToCart() async {
    // التحقق من الصلاحيات
    final canAdd = await PermissionsHelper.canAddToCart();
    if (!canAdd) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('التجار لا يمكنهم الشراء من المتاجر الأخرى'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isAddingToCart = true;
    });

    try {
      await CartService.addToCart(widget.productId, quantity: _quantity);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تمت إضافة $_quantity من المنتج إلى السلة'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'عرض السلة',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  Future<void> _buyNow() async {
    await _addToCart();
    if (mounted) {
      // الانتقال إلى شاشة السلة
      Navigator.pop(context);
    }
  }

  Future<void> _toggleFavorite() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يجب تسجيل الدخول أولاً'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isTogglingFavorite = true;
    });

    try {
      final newState = await FavoritesService.toggleFavorite(widget.productId);
      setState(() {
        _isFavorite = newState;
        _isTogglingFavorite = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newState ? 'تمت الإضافة للمفضلة' : 'تمت الإزالة من المفضلة',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isTogglingFavorite = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل المنتج')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل المنتج')),
        body: const Center(child: Text('لم يتم العثور على المنتج')),
      );
    }

    final price = (_product!['price'] as num?)?.toDouble() ?? 0;
    final stock = (_product!['stock'] as num?)?.toInt() ?? 0;
    final imageUrl = _product!['image_url'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('قريباً: مشاركة المنتج')),
              );
            },
          ),
          _isTogglingFavorite
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : null,
                  ),
                  onPressed: _toggleFavorite,
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة المنتج
            _buildProductImage(imageUrl),

            // معلومات المنتج
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنتج
                  Text(
                    _product!['name'] ?? 'منتج',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // السعر
                  Row(
                    children: [
                      Text(
                        '$price ر.س',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const Spacer(),
                      // حالة المخزون
                      _buildStockBadge(stock),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // معلومات المتجر
                  _buildStoreInfo(),
                  const SizedBox(height: 24),

                  // الوصف
                  if (_product!['description'] != null &&
                      (_product!['description'] as String).isNotEmpty) ...[
                    const Text(
                      'الوصف',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _product!['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // اختيار الكمية
                  _buildQuantitySelector(stock),
                  const SizedBox(height: 24),

                  // معلومات إضافية
                  _buildAdditionalInfo(),
                  const SizedBox(height: 100), // مساحة للأزرار في الأسفل
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(stock),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.shopping_bag, size: 80, color: Colors.grey),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            )
          : const Center(
              child: Icon(Icons.shopping_bag, size: 80, color: Colors.grey),
            ),
    );
  }

  Widget _buildStockBadge(int stock) {
    final isAvailable = stock > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAvailable ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isAvailable ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isAvailable ? 'متوفر ($stock)' : 'غير متوفر',
            style: TextStyle(
              color: isAvailable ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfo() {
    if (_store == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          child: const Icon(Icons.store, color: Colors.blue),
        ),
        title: Text(
          _store!['name'] ?? 'متجر',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: _store!['city'] != null ? Text(_store!['city']) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: الانتقال لصفحة تفاصيل المتجر
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('قريباً: عرض تفاصيل المتجر')),
          );
        },
      ),
    );
  }

  Widget _buildQuantitySelector(int stock) {
    final isAvailable = stock > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الكمية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              onPressed: _quantity > 1
                  ? () {
                      setState(() {
                        _quantity--;
                      });
                    }
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 32,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_quantity',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: isAvailable && _quantity < stock
                  ? () {
                      setState(() {
                        _quantity++;
                      });
                    }
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 32,
            ),
            const Spacer(),
            if (isAvailable)
              Text(
                'متوفر: $stock',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات إضافية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.inventory_2,
              'رمز المنتج',
              widget.productId.substring(0, 8),
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.local_shipping,
              'التوصيل',
              'متوفر في معظم المناطق',
            ),
            const Divider(height: 24),
            _buildInfoRow(Icons.replay, 'الإرجاع', 'خلال 7 أيام من الاستلام'),
            const Divider(height: 24),
            _buildInfoRow(Icons.verified_user, 'الضمان', 'ضمان البائع'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(int stock) {
    final isAvailable = stock > 0;
    final totalPrice =
        ((_product!['price'] as num?)?.toDouble() ?? 0) * _quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // السعر الإجمالي
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإجمالي',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '${totalPrice.toStringAsFixed(2)} ر.س',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            // أزرار الإضافة
            Expanded(
              child: Row(
                children: [
                  // زر إضافة للسلة
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isAvailable && !_isAddingToCart
                          ? _addToCart
                          : null,
                      icon: _isAddingToCart
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.shopping_cart),
                      label: const Text('أضف للسلة'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // زر شراء الآن
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isAvailable && !_isAddingToCart
                          ? _buyNow
                          : null,
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('اشتر الآن'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
