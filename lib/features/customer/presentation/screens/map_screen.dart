import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // عنوان بسيط
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'الخريطة',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      fontFamily: 'Arabic',
                    ),
                  ),
                ],
              ),
            ),
            // محتوى الخريطة
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 100,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'ميزة الخريطة قريباً',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        fontFamily: 'Arabic',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'اكتشف المتاجر والمنتجات القريبة منك',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                        fontFamily: 'Arabic',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
