import 'dart:io';
import 'package:flutter/material.dart';
import '../core/services/services.dart';
import '../core/services/api_service.dart';

/// Example: Using New API Services
///
/// هذا الملف يحتوي على أمثلة لاستخدام الـ services الجديدة
/// استخدم هذه الأمثلة كمرجع عند تحديث الكود القديم

class ApiServiceExamples {
  // ==========================================================================
  // WALLET EXAMPLES
  // ==========================================================================

  /// مثال: الحصول على رصيد المحفظة
  static Future<void> exampleGetWalletBalance() async {
    final balance = await WalletService.getBalance();
    debugPrint('Wallet Balance: $balance SAR');
  }

  /// مثال: إضافة رصيد للمحفظة
  static Future<void> exampleAddWalletFunds(BuildContext context) async {
    try {
      final success = await WalletService.addFunds(
        amount: 100.0,
        paymentMethod: 'card',
        paymentReference: 'pay_123456789',
      );

      if (success) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إضافة الرصيد بنجاح')));
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  /// مثال: التحقق من كفاية الرصيد
  static Future<bool> exampleCheckBalance(double requiredAmount) async {
    final hasFunds = await WalletService.hasSufficientBalance(requiredAmount);
    return hasFunds;
  }

  // ==========================================================================
  // POINTS EXAMPLES
  // ==========================================================================

  /// مثال: الحصول على رصيد النقاط
  static Future<void> exampleGetPoints() async {
    final points = await PointsService.getBalance();
    final valueInSAR = PointsService.pointsToSAR(points);
    debugPrint('Points: $points (قيمة: $valueInSAR SAR)');
  }

  /// مثال: التحقق من كفاية النقاط
  static Future<bool> exampleCheckPoints(int requiredPoints) async {
    return await PointsService.hasSufficientPoints(requiredPoints);
  }

  // ==========================================================================
  // ORDER EXAMPLES
  // ==========================================================================

  /// مثال: إنشاء طلب جديد
  static Future<void> exampleCreateOrder(BuildContext context) async {
    // تحضير عناصر السلة
    final cartItems = [
      {'product_id': 'uuid-product-1', 'quantity': 2, 'price': 150.0},
      {'product_id': 'uuid-product-2', 'quantity': 1, 'price': 300.0},
    ];

    try {
      final result = await OrderService.createOrder(
        cartItems: cartItems,
        deliveryAddress: 'حي النخيل، الرياض',
        paymentMethod: 'wallet', // wallet, cash, card, tap, etc.
        pointsToUse: 100, // استخدام 100 نقطة (خصم 10 ريال)
      );

      if (result != null) {
        final orderId = result['order']['id'];
        final total = result['order']['total_amount'];

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إنشاء الطلب #$orderId - المجموع: $total SAR'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  /// مثال: حساب ملخص الطلب
  static void exampleCalculateOrderSummary() {
    final items = [
      {'price': 150.0, 'quantity': 2},
      {'price': 300.0, 'quantity': 1},
    ];

    final summary = OrderService.calculateOrderSummary(
      items: items,
      pointsToUse: 100, // خصم 10 ريال
      couponDiscount: 20.0, // خصم 20 ريال
    );

    debugPrint('Subtotal: ${summary['subtotal']} SAR');
    debugPrint('Points Discount: ${summary['pointsDiscount']} SAR');
    debugPrint('Coupon Discount: ${summary['couponDiscount']} SAR');
    debugPrint('Total: ${summary['total']} SAR');
  }

  // ==========================================================================
  // MEDIA EXAMPLES
  // ==========================================================================

  /// مثال: رفع صورة
  static Future<void> exampleUploadImage(String imagePath) async {
    final imageUrl = await MediaService.uploadImage(File(imagePath));
    if (imageUrl != null) {
      debugPrint('Image uploaded: $imageUrl');
      // احفظ imageUrl في database
    }
  }

  /// مثال: رفع عدة صور
  static Future<void> exampleUploadMultipleImages(
    List<String> imagePaths,
  ) async {
    final files = imagePaths.map((path) => File(path)).toList();
    final urls = await MediaService.uploadImages(files);
    debugPrint('Uploaded ${urls.length} images');
  }

  // ==========================================================================
  // MERCHANT REGISTRATION EXAMPLE
  // ==========================================================================

  /// مثال: تسجيل تاجر جديد
  static Future<void> exampleRegisterMerchant(
    BuildContext context,
    String userId,
  ) async {
    try {
      final result = await ApiService.registerMerchant(
        userId: userId,
        storeName: 'متجر الإلكترونيات',
        city: 'الرياض',
        district: 'حي النخيل',
        address: 'شارع الملك فهد، مبنى 123',
      );

      if (result['ok'] == true) {
        final welcomePoints = result['points']['balance'];

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إنشاء المتجر بنجاح! حصلت على $welcomePoints نقطة',
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // ==========================================================================
  // HEALTH CHECK EXAMPLE
  // ==========================================================================

  /// مثال: فحص حالة API
  static Future<void> exampleHealthCheck() async {
    final isHealthy = await ApiService.checkHealth();
    debugPrint('API Status: ${isHealthy ? '✅ Healthy' : '❌ Down'}');
  }
}

// =============================================================================
// WIDGET EXAMPLES
// =============================================================================

/// مثال: Widget يعرض رصيد المحفظة والنقاط
class WalletPointsWidget extends StatefulWidget {
  const WalletPointsWidget({super.key});

  @override
  State<WalletPointsWidget> createState() => _WalletPointsWidgetState();
}

class _WalletPointsWidgetState extends State<WalletPointsWidget> {
  double _walletBalance = 0.0;
  int _pointsBalance = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBalances();
  }

  Future<void> _loadBalances() async {
    setState(() => _isLoading = true);

    final wallet = await WalletService.getBalance();
    final points = await PointsService.getBalance();

    setState(() {
      _walletBalance = wallet;
      _pointsBalance = points;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('رصيد المحفظة:'),
                Text(
                  '$_walletBalance SAR',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('النقاط:'),
                Text(
                  '$_pointsBalance نقطة',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
