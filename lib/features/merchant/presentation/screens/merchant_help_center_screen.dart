import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة مركز المساعدة للتاجر
class MerchantHelpCenterScreen extends StatelessWidget {
  const MerchantHelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('مركز المساعدة'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpSection(
            title: 'إدارة المتجر',
            items: [
              'كيف أنشئ متجر جديد؟',
              'كيف أضيف منتجات؟',
              'كيف أعدل معلومات المتجر؟',
            ],
          ),
          _buildHelpSection(
            title: 'الطلبات',
            items: [
              'كيف أتابع الطلبات؟',
              'كيف أغير حالة الطلب؟',
              'كيف أتعامل مع طلبات الإرجاع؟',
            ],
          ),
          _buildHelpSection(
            title: 'المحفظة والدفع',
            items: [
              'كيف أسحب الأموال؟',
              'ما هي طرق الدفع المتاحة؟',
              'كيف أتحقق من المعاملات؟',
            ],
          ),
          _buildHelpSection(
            title: 'النقاط والميزات',
            items: [
              'كيف أحصل على نقاط؟',
              'كيف أستخدم النقاط؟',
              'ما هي الميزات المتاحة؟',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection({required String title, required List<String> items}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MbuyColors.textPrimary,
          ),
        ),
        children: items.map((item) {
          return ListTile(
            title: Text(
              item,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: MbuyColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 16),
            onTap: () {
              // TODO: فتح تفاصيل السؤال
            },
          );
        }).toList(),
      ),
    );
  }
}

