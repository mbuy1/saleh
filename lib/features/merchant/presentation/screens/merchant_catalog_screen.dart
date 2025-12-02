import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة الكتالوج للتاجر
class MerchantCatalogScreen extends StatefulWidget {
  const MerchantCatalogScreen({super.key});

  @override
  State<MerchantCatalogScreen> createState() => _MerchantCatalogScreenState();
}

class _MerchantCatalogScreenState extends State<MerchantCatalogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('كتالوج المتجر'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: فتح شاشة إنشاء كتالوج جديد
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة إنشاء كتالوج قريباً')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCatalogCard(
            title: 'كتالوج المنتجات الجديدة',
            productCount: 45,
            views: 3200,
            isPublished: true,
          ),
          _buildCatalogCard(
            title: 'كتالوج العروض الخاصة',
            productCount: 28,
            views: 1890,
            isPublished: true,
          ),
          _buildCatalogCard(
            title: 'كتالوج قيد الإعداد',
            productCount: 12,
            views: 0,
            isPublished: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogCard({
    required String title,
    required int productCount,
    required int views,
    required bool isPublished,
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
                    color: isPublished
                        ? MbuyColors.success.withValues(alpha: 0.1)
                        : MbuyColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isPublished ? MbuyColors.success : MbuyColors.warning,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isPublished ? 'منشور' : 'مسودة',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPublished ? MbuyColors.success : MbuyColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatItem(Icons.inventory_2, '$productCount', 'منتج'),
                const SizedBox(width: 16),
                _buildStatItem(Icons.visibility, '$views', 'مشاهدة'),
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
        Icon(icon, size: 18, color: MbuyColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MbuyColors.textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: MbuyColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

