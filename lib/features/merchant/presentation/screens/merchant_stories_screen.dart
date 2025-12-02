import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة الستوري للتاجر
class MerchantStoriesScreen extends StatefulWidget {
  const MerchantStoriesScreen({super.key});

  @override
  State<MerchantStoriesScreen> createState() => _MerchantStoriesScreenState();
}

class _MerchantStoriesScreenState extends State<MerchantStoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('الستوري'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // TODO: فتح شاشة إنشاء ستوري جديد
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة إنشاء ستوري قريباً')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStoryCard(
            title: 'عرض جديد على المنتجات',
            views: 1250,
            duration: '24 ساعة',
            isActive: true,
          ),
          _buildStoryCard(
            title: 'منتج جديد متوفر الآن',
            views: 890,
            duration: 'منتهي',
            isActive: false,
          ),
          _buildStoryCard(
            title: 'عرض خاص للعملاء',
            views: 2100,
            duration: 'منتهي',
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard({
    required String title,
    required int views,
    required String duration,
    required bool isActive,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: MbuyColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 16, color: MbuyColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '$views مشاهدة',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: MbuyColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: MbuyColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: isActive ? MbuyColors.success : MbuyColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MbuyColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'نشط',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: MbuyColors.success,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

