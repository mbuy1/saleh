import 'package:flutter/material.dart';
import '../../../../core/services/services.dart';

/// مثال: صفحة Checkout كاملة باستخدام الـ Services الجديدة
///
/// استخدم هذا المثال عند تحديث صفحات الطلبات

class CheckoutScreenExample extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreenExample({super.key, required this.cartItems});

  @override
  State<CheckoutScreenExample> createState() => _CheckoutScreenExampleState();
}

class _CheckoutScreenExampleState extends State<CheckoutScreenExample> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();

  double _walletBalance = 0.0;
  int _pointsBalance = 0;
  int _pointsToUse = 0;
  String _selectedPaymentMethod = 'wallet';
  bool _isLoading = false;
  bool _isProcessing = false;

  final List<Map<String, String>> _paymentMethods = [
    {'id': 'wallet', 'name': 'المحفظة', 'icon': '💰'},
    {'id': 'cash', 'name': 'عند الاستلام', 'icon': '💵'},
    {'id': 'card', 'name': 'بطاقة ائتمان', 'icon': '💳'},
    {'id': 'tap', 'name': 'Tap', 'icon': '📱'},
  ];

  @override
  void initState() {
    super.initState();
    _loadBalances();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  /// تحميل رصيد المحفظة والنقاط
  Future<void> _loadBalances() async {
    setState(() => _isLoading = true);

    try {
      final wallet = await WalletService.getBalance();
      final points = await PointsService.getBalance();

      setState(() {
        _walletBalance = wallet;
        _pointsBalance = points;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('فشل تحميل البيانات: $e');
    }
  }

  /// حساب ملخص الطلب
  Map<String, double> _calculateSummary() {
    return OrderService.calculateOrderSummary(
      items: widget.cartItems,
      pointsToUse: _pointsToUse,
      couponDiscount: 0.0, // يمكن إضافة منطق الكوبون لاحقاً
    );
  }

  /// معالجة الطلب
  Future<void> _processOrder() async {
    // التحقق من البيانات
    if (_addressController.text.trim().isEmpty) {
      _showError('الرجاء إدخال عنوان التوصيل');
      return;
    }

    if (widget.cartItems.isEmpty) {
      _showError('السلة فارغة');
      return;
    }

    // حساب المجموع
    final summary = _calculateSummary();
    final total = summary['total']!;

    // التحقق من الرصيد إذا كان الدفع من المحفظة
    if (_selectedPaymentMethod == 'wallet') {
      if (!await WalletService.hasSufficientBalance(total)) {
        _showError(
          'رصيد المحفظة غير كافٍ. الرصيد الحالي: $_walletBalance ريال',
        );
        return;
      }
    }

    // التحقق من النقاط
    if (_pointsToUse > 0) {
      if (!await PointsService.hasSufficientPoints(_pointsToUse)) {
        _showError('عدد النقاط المتاحة: $_pointsBalance');
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      // إنشاء الطلب عبر API Gateway
      final result = await OrderService.createOrder(
        cartItems: widget.cartItems,
        deliveryAddress: _addressController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
        pointsToUse: _pointsToUse > 0 ? _pointsToUse : null,
        couponCode: _couponController.text.trim().isNotEmpty
            ? _couponController.text.trim()
            : null,
      );

      if (!mounted) return;
      setState(() => _isProcessing = false);

      if (result != null && result['ok'] == true) {
        final orderId = result['order']['id'];
        final orderTotal = result['order']['total_amount'];

        _showSuccess(
          'تم إنشاء الطلب بنجاح!\nرقم الطلب: $orderId\nالمجموع: $orderTotal ريال',
        );

        // العودة إلى الصفحة السابقة
        Navigator.pop(context, true);
      } else {
        _showError('فشل إنشاء الطلب');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('خطأ في معالجة الطلب: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final summary = _calculateSummary();

    return Scaffold(
      appBar: AppBar(title: const Text('إتمام الطلب'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // عرض الرصيد والنقاط
            _buildBalanceCard(),
            const SizedBox(height: 16),

            // عنوان التوصيل
            _buildAddressField(),
            const SizedBox(height: 16),

            // اختيار النقاط
            _buildPointsSelector(),
            const SizedBox(height: 16),

            // كود الخصم
            _buildCouponField(),
            const SizedBox(height: 16),

            // طريقة الدفع
            _buildPaymentMethodSelector(),
            const SizedBox(height: 16),

            // ملخص الطلب
            _buildOrderSummary(summary),
            const SizedBox(height: 24),

            // زر التأكيد
            ElevatedButton(
              onPressed: _isProcessing ? null : _processOrder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'تأكيد الطلب (${summary['total']!.toStringAsFixed(2)} ريال)',
                      style: const TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('رصيد المحفظة:', style: TextStyle(fontSize: 16)),
                Text(
                  '${_walletBalance.toStringAsFixed(2)} ريال',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('النقاط:', style: TextStyle(fontSize: 16)),
                Text(
                  '$_pointsBalance نقطة (${PointsService.pointsToSAR(_pointsBalance).toStringAsFixed(2)} ريال)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return TextField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'عنوان التوصيل',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_on),
      ),
      maxLines: 2,
    );
  }

  Widget _buildPointsSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'استخدام النقاط',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'خصم: ${PointsService.pointsToSAR(_pointsToUse).toStringAsFixed(2)} ريال',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            Slider(
              value: _pointsToUse.toDouble(),
              max: _pointsBalance.toDouble(),
              divisions: _pointsBalance > 0 ? _pointsBalance : 1,
              label: '$_pointsToUse نقطة',
              onChanged: (value) {
                setState(() => _pointsToUse = value.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponField() {
    return TextField(
      controller: _couponController,
      decoration: InputDecoration(
        labelText: 'كود الخصم (اختياري)',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.local_offer),
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            // TODO: التحقق من الكوبون
          },
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'طريقة الدفع',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._paymentMethods.map((method) {
              final isSelected = _selectedPaymentMethod == method['id']!;
              return InkWell(
                onTap: () {
                  setState(() => _selectedPaymentMethod = method['id']!);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        method['icon']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(method['name']!),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(Map<String, double> summary) {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملخص الطلب',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildSummaryRow('المجموع الفرعي', summary['subtotal']!),
            if (summary['pointsDiscount']! > 0)
              _buildSummaryRow(
                'خصم النقاط',
                -summary['pointsDiscount']!,
                color: Colors.green,
              ),
            if (summary['couponDiscount']! > 0)
              _buildSummaryRow(
                'خصم الكوبون',
                -summary['couponDiscount']!,
                color: Colors.green,
              ),
            const Divider(),
            _buildSummaryRow('المجموع الكلي', summary['total']!, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount, {
    Color? color,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} ريال',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isTotal ? Colors.blue : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
