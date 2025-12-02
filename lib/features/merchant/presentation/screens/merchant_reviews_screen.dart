import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة التقييمات للتاجر
class MerchantReviewsScreen extends StatefulWidget {
  const MerchantReviewsScreen({super.key});

  @override
  State<MerchantReviewsScreen> createState() => _MerchantReviewsScreenState();
}

class _MerchantReviewsScreenState extends State<MerchantReviewsScreen> {
  final double _averageRating = 4.8;
  final int _totalReviews = 245;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('تقييمات المتجر'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // إحصائيات التقييمات
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: MbuyColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  _averageRating.toStringAsFixed(1),
                  style: GoogleFonts.cairo(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < _averageRating.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: MbuyColors.warning,
                      size: 24,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_totalReviews تقييم',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // قائمة التقييمات
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildReviewCard(
                  customerName: 'أحمد محمد',
                  rating: 5,
                  comment: 'منتج رائع وجودة ممتازة، أنصح الجميع بشرائه',
                  date: 'منذ يومين',
                ),
                _buildReviewCard(
                  customerName: 'فاطمة علي',
                  rating: 4,
                  comment: 'جيد جداً لكن التوصيل تأخر قليلاً',
                  date: 'منذ 5 أيام',
                ),
                _buildReviewCard(
                  customerName: 'خالد سعيد',
                  rating: 5,
                  comment: 'أفضل متجر إلكترونيات، خدمة ممتازة',
                  date: 'منذ أسبوع',
                ),
                _buildReviewCard(
                  customerName: 'سارة أحمد',
                  rating: 3,
                  comment: 'المنتج جيد لكن السعر مرتفع قليلاً',
                  date: 'منذ أسبوعين',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String customerName,
    required int rating,
    required String comment,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: MbuyColors.primaryIndigo,
                  child: Text(
                    customerName[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: MbuyColors.warning,
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: MbuyColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              comment,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: MbuyColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

