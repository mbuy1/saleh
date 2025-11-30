import 'package:flutter/material.dart';

class CustomerPointsScreen extends StatelessWidget {
  const CustomerPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النقاط'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.stars,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              const Text(
                'النقاط للتاجر فقط',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'النقاط هي "رصيد خدمات" يستخدمه التاجر لتفعيل مميزات داخل التطبيق مثل:\n\n'
                '• توليد فيديو تسويقي\n'
                '• توليد صورة لمنتج\n'
                '• إبراز المتجر على الخريطة\n'
                '• رفع مقطع في صفحة Explore\n'
                '• تثبيت متجر في صفحة المتاجر\n'
                '• دعم منتج أو متجر (boost)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                'العميل لا يدفع بالنقاط، بل يستفيد من النتائج عندما يستخدم التاجر نقاطه.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
