import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/cart_service.dart';
import '../../../../core/permissions_helper.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/services/order_service.dart';
import '../../../../core/firebase_service.dart';
import '../../../../shared/widgets/skeleton/skeleton_loader.dart';
import '../../../../shared/widgets/profile_button.dart';
import '../../../../shared_widgets/cards/protection_banner.dart';
import '../../../../shared/widgets/circle_item.dart';

class CartScreen extends StatefulWidget {
  final String? userRole; // 'customer' أو 'merchant'

  const CartScreen({super.key, this.userRole});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemModel> _cartItems = [];
  double _total = 0;
  bool _isLoading = true;
  final TextEditingController _couponController = TextEditingController();
  Map<String, dynamic>? _appliedCoupon;
  bool _isValidatingCoupon = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
    // تتبع عرض السلة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseService.logScreenView('cart');
    });
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final canAdd = await PermissionsHelper.canAddToCart();
      if (!canAdd) {
        setState(() {
          _cartItems = [];
          _total = 0;
        });
        return;
      }

      final items = await CartService.getCartItems();
      final total = CartService.calculateTotal(items);

      setState(() {
        _cartItems = items;
        _total = total;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب السلة: ${e.toString()}'),
            backgroundColor: MbuyColors.alertRed,
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
    final canAdd = await PermissionsHelper.canAddToCart();
    if (!canAdd) return;

    try {
      await CartService.updateQuantity(cartItemId, newQuantity);
      _loadCart();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحديث الكمية: ${e.toString()}'),
            backgroundColor: MbuyColors.alertRed,
          ),
        );
      }
    }
  }

  Future<void> _removeItem(String cartItemId) async {
    final canAdd = await PermissionsHelper.canAddToCart();
    if (!canAdd) return;

    try {
      await CartService.removeFromCart(cartItemId);
      _loadCart();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف العنصر من السلة'),
            backgroundColor: MbuyColors.primaryMaroon,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حذف العنصر: ${e.toString()}'),
            backgroundColor: MbuyColors.alertRed,
          ),
        );
      }
    }
  }

  Future<void> _completeOrder() async {
    final canCreate = await PermissionsHelper.canCreateOrder();
    if (!canCreate) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ليس لديك صلاحية لإنشاء طلب'),
            backgroundColor: MbuyColors.alertRed,
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
            backgroundColor: MbuyColors.alertRed,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // تحويل CartItems إلى format مناسب لـ OrderService
      final cartItemsForOrder = _cartItems.map((item) {
        return {
          'product_id': item.productId,
          'quantity': item.quantity,
          'price': item.product?.finalPrice ?? 0.0,
        };
      }).toList();

      // استخدام OrderService لإنشاء الطلب
      final result = await OrderService.createOrder(
        cartItems: cartItemsForOrder,
        deliveryAddress: 'عنوان التوصيل', // TODO: جلب من إعدادات المستخدم
        paymentMethod: 'wallet', // TODO: السماح للمستخدم باختيار طريقة الدفع
        couponCode: _appliedCoupon?['code'],
      );

      if (result != null && result['ok'] == true) {
        final orderId = result['data']?['order_id'] ?? 'غير معروف';
        final totalAmount = result['data']?['total_amount'] as double? ?? 0.0;
        final couponCode = _appliedCoupon?['code'];

        // تتبع إتمام الطلب
        await FirebaseService.logPlaceOrder(
          orderId: orderId.toString(),
          totalAmount: totalAmount,
          couponCode: couponCode,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إنشاء الطلب بنجاح! رقم الطلب: $orderId'),
              backgroundColor: MbuyColors.primaryMaroon,
              duration: const Duration(seconds: 3),
            ),
          );
          _loadCart();
        }
      } else {
        throw Exception(result?['error'] ?? 'فشل إنشاء الطلب');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إتمام الطلب: ${e.toString()}'),
            backgroundColor: MbuyColors.alertRed,
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
    if (code.isEmpty) return;

    setState(() {
      _isValidatingCoupon = true;
    });

    try {
      // TODO: تفعيل CouponService لاحقاً
      await Future.delayed(const Duration(seconds: 1));
      final coupon = {'code': code, 'discount': 10.0};

      setState(() {
        _appliedCoupon = coupon;
        _isValidatingCoupon = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تطبيق الكوبون بنجاح!'),
            backgroundColor: MbuyColors.primaryMaroon,
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
            backgroundColor: MbuyColors.alertRed,
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

  @override
  Widget build(BuildContext context) {
    final itemCount = _cartItems.length;

    return MbuyScaffold(
      backgroundColor: MbuyColors.background,
      appBar: MbuyAppBar(
        title: 'عربة التسوق ${itemCount > 0 ? "($itemCount)" : ""}',
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ProfileButton(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: MbuyColors.textSecondary,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('قريباً: المفضلة')));
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonLoader()
          : widget.userRole == 'merchant'
          ? _buildMerchantView()
          : _cartItems.isEmpty
          ? _buildEmptyCart()
          : _buildCartContent(),
    );
  }

  Widget _buildMerchantView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.remove_shopping_cart,
            size: 64,
            color: MbuyColors.secondaryBrown,
          ),
          SizedBox(height: 16),
          Text(
            'وضع التصفح فقط',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'التاجر لا يمكنه استخدام سلة العميل',
            style: TextStyle(fontSize: 14, color: MbuyColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: MbuyColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: MbuyColors.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'عربة تسوقك فارغة',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف منتجات لتبدأ التسوق',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: MbuyColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context), // Go back to home/explore
            style: ElevatedButton.styleFrom(
              backgroundColor: MbuyColors.primaryMaroon,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
              size: 22,
            ),
            label: Text(
              'استكشف المنتجات',
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Suggested products even when empty
          _buildSuggestedProducts(),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              // 1. Protection Banner
              const ProtectionBanner(),

              // 2. Cart Items
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return _buildCartItem(context, {
                    'id': item.id,
                    'product_id': item.productId,
                    'quantity': item.quantity,
                    'product': item.product != null
                        ? {
                            'name': item.product!.name,
                            'price': item.product!.price,
                            'image_url': item.product!.imageUrl,
                            'discount_price': item.product!.discountPrice,
                          }
                        : null,
                  });
                },
              ),

              const SizedBox(height: 16),

              // 3. Coupon & Summary
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: MbuyColors.borderLight),
                ),
                child: Column(
                  children: [
                    // Coupon Field
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
                                borderSide: const BorderSide(
                                  color: MbuyColors.borderLight,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: MbuyColors.borderLight,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: MbuyColors.primaryMaroon,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              isDense: true,
                              suffixIcon: _appliedCoupon != null
                                  ? IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: _removeCoupon,
                                    )
                                  : null,
                            ),
                            enabled:
                                !_isValidatingCoupon && _appliedCoupon == null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Semantics(
                          label: 'تطبيق كوبون الخصم',
                          button: true,
                          enabled:
                              !_isValidatingCoupon && _appliedCoupon == null,
                          child: ElevatedButton(
                            onPressed:
                                _isValidatingCoupon || _appliedCoupon != null
                                ? null
                                : _applyCoupon,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MbuyColors.primaryMaroon,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isValidatingCoupon
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('تطبيق'),
                          ),
                        ),
                      ],
                    ),

                    if (_appliedCoupon != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: MbuyColors.primaryMaroon,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'تم تطبيق الخصم: ${_buildCouponDiscountText()}',
                            style: const TextStyle(
                              color: MbuyColors.primaryMaroon,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const Divider(height: 24, color: MbuyColors.borderLight),

                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المجموع',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MbuyColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${_total.toStringAsFixed(2)} ر.س',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MbuyColors.primaryMaroon,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 4. Suggested Products
              _buildSuggestedProducts(),
            ],
          ),
        ),

        // Checkout Button (Sticky at bottom)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
              top: BorderSide(color: MbuyColors.borderLight),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Semantics(
                label: 'إتمام الطلب بمبلغ ${_total.toStringAsFixed(2)} ريال',
                button: true,
                enabled: !_isLoading,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _completeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MbuyColors.primaryMaroon,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'إتمام الطلب (${_total.toStringAsFixed(2)} ر.س)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedProducts() {
    return Column(
      children: [
        MbuySectionHeader(
          title: 'توصيات لك',
          subtitle: 'منتجات قد تعجبك',
          backgroundColor: Colors.transparent,
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 6,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return CircleItem(
                label: 'منتج ${index + 1}',
                // imageUrl: 'https://via.placeholder.com/100',
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: MbuyColors.textSecondary,
                ),
                onTap: () {},
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, Map<String, dynamic> item) {
    final product = item['products'] as Map<String, dynamic>?;
    final cartItemId = item['id'] as String;
    final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
    final productName = product?['name'] ?? 'بدون اسم';
    final productPrice = (product?['price'] as num?)?.toDouble() ?? 0;
    final imageUrl = product?['image_url'] as String?;
    final isCustomer = widget.userRole == 'customer';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MbuyColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: MbuyColors.surface,
              borderRadius: BorderRadius.circular(8),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? const Icon(
                    Icons.image,
                    color: MbuyColors.textTertiary,
                    size: 32,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: MbuyColors.textSecondary,
                      ),
                      onPressed: isCustomer
                          ? () => _removeItem(cartItemId)
                          : null,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${productPrice.toStringAsFixed(2)} ر.س',
                  style: GoogleFonts.cairo(
                    color: MbuyColors.primaryMaroon,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                if (isCustomer)
                  Row(
                    children: [
                      _buildQtyBtn(
                        Icons.remove,
                        () => _updateQuantity(cartItemId, quantity - 1),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: MbuyColors.borderLight),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: Text(
                          '$quantity',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildQtyBtn(
                        Icons.add,
                        () => _updateQuantity(cartItemId, quantity + 1),
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

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: MbuyColors.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16, color: MbuyColors.textPrimary),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Skeleton Cart Items
        ...List.generate(
          3,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonListItem(hasTrailing: false),
          ),
        ),
        const SizedBox(height: 24),
        // Skeleton Total Card
        SkeletonLoader(
          width: double.infinity,
          height: 100,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }
}
