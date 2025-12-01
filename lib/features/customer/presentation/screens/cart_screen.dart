import 'package:flutter/material.dart';
import '../../data/cart_service.dart';
import '../../data/order_service.dart';
import '../../data/coupon_service.dart';
import '../../../../core/permissions_helper.dart';
import '../../../../shared/widgets/profile_button.dart';

class CartScreen extends StatefulWidget {
  final String? userRole; // 'customer' أو 'merchant'

  const CartScreen({super.key, this.userRole});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  double _total = 0;
  bool _isLoading = true;
  final TextEditingController _couponController = TextEditingController();
  Map<String, dynamic>? _appliedCoupon;
  bool _isValidatingCoupon = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // التحقق من الصلاحيات: فقط customer يمكنه رؤية السلة
      final canAdd = await PermissionsHelper.canAddToCart();
      if (!canAdd) {
        // إذا كان merchant، لا نحاول جلب السلة
        setState(() {
          _cartItems = [];
          _total = 0;
        });
        return;
      }

      final items = await CartService.getCartItems();
      final total = await CartService.getCartTotal();

      setState(() {
        _cartItems = items;
        _total = total;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب السلة: ${e.toString()}'),
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

  Future<void> _updateQuantity(String cartItemId, int newQuantity) async {
    // التحقق من الصلاحيات
    final canAdd = await PermissionsHelper.canAddToCart();
    if (!canAdd) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('غير مسموح: التاجر لا يمكنه تعديل السلة'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      await CartService.updateCartItemQuantity(cartItemId, newQuantity);
      _loadCart(); // إعادة تحميل السلة
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحديث الكمية: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeItem(String cartItemId) async {
    // التحقق من الصلاحيات
    final canAdd = await PermissionsHelper.canAddToCart();
    if (!canAdd) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('غير مسموح: التاجر لا يمكنه حذف من السلة'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      await CartService.removeFromCart(cartItemId);

      _loadCart(); // إعادة تحميل السلة
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف العنصر من السلة'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حذف العنصر: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _completeOrder() async {
    // التحقق من الصلاحيات
    final canCreate = await PermissionsHelper.canCreateOrder();
    if (!canCreate) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('غير مسموح: التاجر لا يمكنه إنشاء طلبات كعميل'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (_cartItems.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('السلة فارغة'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // إنشاء طلب من السلة
      final orderId = await OrderService.createOrderFromCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إنشاء الطلب بنجاح! رقم الطلب: $orderId'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // إعادة تحميل السلة (ستكون فارغة الآن)
        _loadCart();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إتمام الطلب: ${e.toString()}'),
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
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى إدخال كود الكوبون'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isValidatingCoupon = true;
    });

    try {
      // حساب مبلغ الطلب الحالي
      final orderAmount = _total;

      // التحقق من صحة الكوبون
      final coupon = await CouponService.validateCoupon(
        code,
        orderAmount: orderAmount,
      );

      setState(() {
        _appliedCoupon = coupon;
        _isValidatingCoupon = false;
      });

      if (mounted) {
        final discountType = coupon['discount_type'] as String? ?? 'fixed';
        final discountValue = (coupon['discount_value'] as num? ?? 0)
            .toDouble();

        String discountText = '';
        if (discountType == 'percent') {
          discountText = '$discountValue%';
        } else {
          discountText = '${discountValue.toStringAsFixed(2)} ر.س';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تطبيق الكوبون بنجاح! الخصم: $discountText'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _appliedCoupon = null;
        _isValidatingCoupon = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _couponController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('السلة'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: const [
          Padding(padding: EdgeInsets.only(left: 8), child: ProfileButton()),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.userRole == 'merchant'
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 64,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'وضع التصفح فقط',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'التاجر لا يمكنه استخدام سلة العميل',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : _cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'السلة فارغة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // قائمة العناصر
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, _cartItems[index]);
                    },
                  ),
                ),
                // ملخص السلة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // حقل الكوبون
                      if (widget.userRole == 'customer') ...[
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _couponController,
                                decoration: InputDecoration(
                                  labelText: 'كود الكوبون',
                                  hintText: 'أدخل كود الكوبون',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  suffixIcon: _appliedCoupon != null
                                      ? IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: _removeCoupon,
                                        )
                                      : null,
                                ),
                                enabled:
                                    !_isValidatingCoupon &&
                                    _appliedCoupon == null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed:
                                  _isValidatingCoupon || _appliedCoupon != null
                                  ? null
                                  : _applyCoupon,
                              child: _isValidatingCoupon
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('تطبيق'),
                            ),
                          ],
                        ),
                        if (_appliedCoupon != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'كوبون مطبق: ${_appliedCoupon!['code']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _buildCouponDiscountText(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'المجموع',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_total.toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      if (_appliedCoupon != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الخصم (${_appliedCoupon!['code']})',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green.shade700,
                              ),
                            ),
                            Text(
                              '- ${_buildCouponDiscountText()}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _completeOrder,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('إتمام الطلب'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, Map<String, dynamic> item) {
    final product = item['products'] as Map<String, dynamic>?;
    final cartItemId = item['id'] as String;
    final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
    final productName = product?['name'] ?? 'بدون اسم';
    final productPrice = (product?['price'] as num?)?.toDouble() ?? 0;
    final totalPrice = productPrice * quantity;
    final isCustomer = widget.userRole == 'customer';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        ),
        title: Text(productName),
        subtitle: Text(
          '${productPrice.toStringAsFixed(2)} ر.س × $quantity = ${totalPrice.toStringAsFixed(2)} ر.س',
        ),
        trailing: isCustomer
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      _updateQuantity(cartItemId, quantity - 1);
                    },
                  ),
                  Text('$quantity'),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      _updateQuantity(cartItemId, quantity + 1);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      _removeItem(cartItemId);
                    },
                  ),
                ],
              )
            : null, // لا تظهر أزرار التعديل للتاجر
      ),
    );
  }

  String _buildCouponDiscountText() {
    if (_appliedCoupon == null) return '';

    final discountType = _appliedCoupon!['discount_type'] as String? ?? 'fixed';
    final discountValue = (_appliedCoupon!['discount_value'] as num? ?? 0)
        .toDouble();

    if (discountType == 'percent') {
      return '$discountValue%';
    } else {
      return '${discountValue.toStringAsFixed(2)} ر.س';
    }
  }
}
