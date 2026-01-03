import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/data.dart';
import '../../models/models.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  int _selectedAddressIndex = 0;
  int _selectedPaymentIndex = 0;
  bool _isPlacingOrder = false;

  // Payment methods (local for now)
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: '1',
      type: PaymentType.card,
      name: 'بطاقة ائتمان',
      details: '**** **** **** 1234',
      icon: Icons.credit_card,
    ),
    PaymentMethod(
      id: '2',
      type: PaymentType.applePay,
      name: 'Apple Pay',
      details: '',
      icon: Icons.apple,
    ),
    PaymentMethod(
      id: '3',
      type: PaymentType.cash,
      name: 'الدفع عند الاستلام',
      details: 'رسوم إضافية 10 ر.س',
      icon: Icons.money,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Load cart and addresses
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).loadCart();
      ref.read(checkoutProvider.notifier).loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final cart = cartState.cart;
    final addresses = checkoutState.addresses;

    if (cartState.isLoading || checkoutState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (cart == null || cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('إتمام الطلب')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              const Text('السلة فارغة'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('تصفح المنتجات'),
              ),
            ],
          ),
        ),
      );
    }

    final subtotal = cart.subtotal;
    final shipping = 25.0;
    final total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(title: const Text('إتمام الطلب')),
      body: Column(
        children: [
          // Stepper Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepIndicator(0, 'العنوان'),
                _buildStepConnector(0),
                _buildStepIndicator(1, 'الدفع'),
                _buildStepConnector(1),
                _buildStepIndicator(2, 'التأكيد'),
              ],
            ),
          ),

          // Step Content
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                _buildAddressStep(addresses),
                _buildPaymentStep(),
                _buildConfirmationStep(
                  addresses,
                  cart,
                  subtotal,
                  shipping,
                  total,
                ),
              ],
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الإجمالي'),
                      Text(
                        '${total.toStringAsFixed(0)} ر.س',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _currentStep--);
                            },
                            child: const Text('السابق'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isPlacingOrder
                              ? null
                              : () {
                                  if (_currentStep < 2) {
                                    setState(() => _currentStep++);
                                  } else {
                                    _placeOrder(addresses, cart);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isPlacingOrder
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _currentStep == 2 ? 'تأكيد الطلب' : 'التالي',
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
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                : null,
          ),
          child: Center(
            child: isActive && !isCurrent
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(int step) {
    final isActive = _currentStep > step;

    return Container(
      width: 50,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
    );
  }

  Widget _buildAddressStep(List<ShippingAddress> addresses) {
    if (addresses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('لا توجد عناوين محفوظة'),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // Add new address
              },
              icon: const Icon(Icons.add),
              label: const Text('إضافة عنوان جديد'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر عنوان التوصيل',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...addresses.asMap().entries.map((entry) {
            final index = entry.key;
            final address = entry.value;
            return _buildAddressCard(address, index);
          }),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Add new address
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة عنوان جديد'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(ShippingAddress address, int index) {
    final isSelected = _selectedAddressIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedAddressIndex = index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => setState(() => _selectedAddressIndex = index),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.label.isNotEmpty
                              ? address.label
                              : 'عنوان ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'افتراضي',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address.fullAddress,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address.phone,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  // Edit address
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر طريقة الدفع',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._paymentMethods.asMap().entries.map((entry) {
            final index = entry.key;
            final method = entry.value;
            return _buildPaymentCard(method, index);
          }),
          const SizedBox(height: 24),

          // Promo Code
          const Text(
            'كود الخصم',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'أدخل كود الخصم',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  // Apply promo code
                },
                child: const Text('تطبيق'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(PaymentMethod method, int index) {
    final isSelected = _selectedPaymentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPaymentIndex = index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => setState(() => _selectedPaymentIndex = index),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : null,
              ),
              Icon(method.icon, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (method.details.isNotEmpty)
                      Text(
                        method.details,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationStep(
    List<ShippingAddress> addresses,
    Cart cart,
    double subtotal,
    double shipping,
    double total,
  ) {
    if (addresses.isEmpty || _selectedAddressIndex >= addresses.length) {
      return const Center(child: Text('يرجى اختيار عنوان'));
    }

    final selectedAddress = addresses[_selectedAddressIndex];
    final selectedPayment = _paymentMethods[_selectedPaymentIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Summary
          const Text(
            'ملخص الطلب',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Address
          _buildSummaryCard(
            title: 'عنوان التوصيل',
            icon: Icons.location_on,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedAddress.label.isNotEmpty
                      ? selectedAddress.label
                      : 'العنوان',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedAddress.fullAddress,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            onEdit: () => setState(() => _currentStep = 0),
          ),
          const SizedBox(height: 12),

          // Payment
          _buildSummaryCard(
            title: 'طريقة الدفع',
            icon: Icons.payment,
            content: Row(
              children: [
                Icon(selectedPayment.icon),
                const SizedBox(width: 8),
                Text(selectedPayment.name),
                if (selectedPayment.details.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    selectedPayment.details,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
            onEdit: () => setState(() => _currentStep = 1),
          ),
          const SizedBox(height: 12),

          // Cart Items
          _buildSummaryCard(
            title: 'المنتجات (${cart.items.length})',
            icon: Icons.shopping_bag,
            content: Column(
              children: cart.items.take(3).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        '${item.quantity}x',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.productName.isNotEmpty
                              ? item.productName
                              : 'منتج',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${(item.price * item.quantity).toStringAsFixed(0)} ر.س',
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            onEdit: () => context.pop(),
          ),
          const SizedBox(height: 24),

          // Price Details
          const Text(
            'تفاصيل السعر',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildPriceRow('المجموع الفرعي', subtotal),
                const SizedBox(height: 8),
                _buildPriceRow('التوصيل', shipping),
                const Divider(height: 24),
                _buildPriceRow('الإجمالي', total, isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required Widget content,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(onPressed: onEdit, child: const Text('تعديل')),
            ],
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '${isDiscount ? "-" : ""}${amount.toStringAsFixed(0)} ر.س',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.green : null,
          ),
        ),
      ],
    );
  }

  Future<void> _placeOrder(List<ShippingAddress> addresses, Cart cart) async {
    if (addresses.isEmpty || _selectedAddressIndex >= addresses.length) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار عنوان توصيل')));
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      final selectedAddress = addresses[_selectedAddressIndex];
      final selectedPayment = _paymentMethods[_selectedPaymentIndex];

      final orderNumber = await ref
          .read(checkoutProvider.notifier)
          .placeOrder(
            addressId: selectedAddress.id,
            paymentMethod: selectedPayment.type.name,
          );

      if (orderNumber != null && mounted) {
        // Clear cart after successful order
        await ref.read(cartProvider.notifier).clearCart();

        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'تم الطلب بنجاح!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'رقم الطلب: $orderNumber',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/orders');
                    },
                    child: const Text('تتبع الطلب'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/');
                    },
                    child: const Text('مواصلة التسوق'),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        final error = ref.read(checkoutProvider).error;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error ?? 'حدث خطأ أثناء إنشاء الطلب')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }
}

enum PaymentType { card, applePay, cash }

class PaymentMethod {
  final String id;
  final PaymentType type;
  final String name;
  final String details;
  final IconData icon;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    required this.details,
    required this.icon,
  });
}
