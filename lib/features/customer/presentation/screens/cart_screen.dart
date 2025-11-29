/// شاشة Cart
/// 
/// عرض السلة مع عناصر وهمية
/// 
/// TODO: ربط هذه الشاشة بجداول Supabase:
/// - carts: جلب سلة المستخدم الحالي
/// - cart_items: جلب عناصر السلة مع معلومات المنتجات
/// - products: جلب تفاصيل المنتجات (الاسم، السعر، الصورة)
/// - product_media: جلب صور المنتجات من Cloudflare
/// 
/// TODO: ربط بوابات الدفع:
/// - Tap Payment Gateway
/// - HyperPay Gateway
/// - ربط مع جدول payments لتسجيل المعاملات
/// - معالجة حالات الدفع (نجح، فشل، معلق)

import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // عناصر وهمية
    final cartItems = List.generate(3, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('السلة'),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
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
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, cartItems[index]);
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
                            '${cartItems.length * 50} ر.س',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: إضافة منطق إتمام الطلب
                            // 1. التحقق من صحة بيانات السلة
                            // 2. إنشاء طلب جديد في جدول orders
                            // 3. فتح بوابة الدفع (Tap/HyperPay)
                            // 4. معالجة استجابة الدفع
                            // 5. تحديث حالة الطلب في orders
                            // 6. إرسال إشعار FCM للمستخدم والتاجر
                            // 7. تتبع الحدث في Firebase Analytics (place_order)
                            // 8. تفريغ السلة (carts و cart_items)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('إتمام الطلب')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('إتمام الطلب'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, int itemIndex) {
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
        title: Text('منتج $itemIndex'),
        subtitle: Text('${itemIndex * 50} ر.س'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                // TODO: تقليل الكمية
              },
            ),
            const Text('1'),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                // TODO: زيادة الكمية
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                // TODO: حذف العنصر
              },
            ),
          ],
        ),
      ),
    );
  }
}

