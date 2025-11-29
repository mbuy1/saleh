/// شاشة Map
/// 
/// خريطة المتاجر (Placeholder حالياً)
/// في الأعلى:
/// - زر الحساب الشخصي
/// - زر البحث بالفئات
/// - زر المفضلة
/// - حقل بحث (TextField)
/// 
/// TODO: ربط هذه الشاشة بجداول Supabase:
/// - stores: جلب المتاجر مع إحداثيات الموقع (latitude, longitude)
/// - عرض المتاجر على خريطة حقيقية (Google Maps / Mapbox)
/// - البحث عن المتاجر حسب الموقع الحالي
/// - عرض تفاصيل المتجر عند الضغط على Marker
/// 
/// TODO: إضافة Cloudflare:
/// - عرض صور المتاجر من Cloudflare على الخريطة

import 'package:flutter/material.dart';
import 'customer_orders_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // شريط البحث والأزرار
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // صف الأزرار
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // زر الحساب الشخصي
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        // TODO: فتح صفحة الحساب
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('الحساب الشخصي')),
                        );
                      },
                      tooltip: 'الحساب الشخصي',
                    ),
                    // زر البحث بالفئات
                    IconButton(
                      icon: const Icon(Icons.category),
                      onPressed: () {
                        // TODO: فتح البحث بالفئات
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('البحث بالفئات')),
                        );
                      },
                      tooltip: 'البحث بالفئات',
                    ),
                    // زر المفضلة
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        // TODO: فتح المفضلة
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('المفضلة')),
                        );
                      },
                      tooltip: 'المفضلة',
                    ),
                    // زر طلباتي
                    IconButton(
                      icon: const Icon(Icons.receipt_long),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomerOrdersScreen(),
                          ),
                        );
                      },
                      tooltip: 'طلباتي',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // حقل البحث
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن متجر...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSubmitted: (value) {
                    // TODO: إضافة منطق البحث
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('البحث عن: $value')),
                    );
                  },
                ),
              ],
            ),
          ),
          // خريطة Placeholder
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.map,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'خريطة المتاجر',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'سيتم إضافة خريطة حقيقية لاحقاً',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

