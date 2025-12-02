import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة العروض والإعلانات للتاجر
class MerchantPromotionsScreen extends StatefulWidget {
  const MerchantPromotionsScreen({super.key});

  @override
  State<MerchantPromotionsScreen> createState() => _MerchantPromotionsScreenState();
}

class _MerchantPromotionsScreenState extends State<MerchantPromotionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('العروض والإعلانات'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: فتح شاشة إنشاء عرض جديد
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة إنشاء عرض جديد قريباً')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPromotionCard(
            title: 'عرض الصيف الكبير',
            discount: 'خصم 30%',
            status: 'نشط',
            views: 1250,
            clicks: 340,
            endDate: '2024-12-31',
          ),
          _buildPromotionCard(
            title: 'عرض نهاية الأسبوع',
            discount: 'خصم 20%',
            status: 'معلق',
            views: 890,
            clicks: 210,
            endDate: '2024-12-15',
          ),
          _buildPromotionCard(
            title: 'عرض المنتجات الجديدة',
            discount: 'شحن مجاني',
            status: 'منتهي',
            views: 2100,
            clicks: 560,
            endDate: '2024-11-30',
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard({
    required String title,
    required String discount,
    required String status,
    required int views,
    required int clicks,
    required String endDate,
  }) {
    Color statusColor;
    switch (status) {
      case 'نشط':
        statusColor = MbuyColors.success;
        break;
      case 'معلق':
        statusColor = MbuyColors.warning;
        break;
      default:
        statusColor = MbuyColors.textTertiary;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: MbuyColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                discount,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatItem(Icons.visibility, '$views', 'مشاهدة'),
                const SizedBox(width: 16),
                _buildStatItem(Icons.touch_app, '$clicks', 'نقرة'),
                const Spacer(),
                Text(
                  'ينتهي: $endDate',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: MbuyColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: MbuyColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: MbuyColors.textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: MbuyColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

