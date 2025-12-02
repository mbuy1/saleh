import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة الشروط والأحكام
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('الشروط والأحكام'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
            Text(
              'شروط وأحكام استخدام تطبيق mBuy',
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MbuyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. القبول بالشروط',
              content:
                  'باستخدام تطبيق mBuy، أنت توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على أي من هذه الشروط، يرجى عدم استخدام التطبيق.',
            ),
            _buildSection(
              title: '2. استخدام التطبيق',
              content:
                  'يجب استخدام التطبيق للأغراض القانونية فقط. يحظر استخدام التطبيق لأي غرض غير قانوني أو غير مصرح به.',
            ),
            _buildSection(
              title: '3. الحسابات',
              content:
                  'أنت مسؤول عن الحفاظ على سرية معلومات حسابك وكلمة المرور. يجب إبلاغنا فوراً عن أي استخدام غير مصرح به لحسابك.',
            ),
            _buildSection(
              title: '4. المنتجات والخدمات',
              content:
                  'نحتفظ بالحق في تعديل أو إيقاف أي منتج أو خدمة في أي وقت دون إشعار مسبق.',
            ),
            _buildSection(
              title: '5. المدفوعات',
              content:
                  'جميع المدفوعات تتم بشكل آمن. نحتفظ بالحق في رفض أو إلغاء أي طلب في أي وقت.',
            ),
            _buildSection(
              title: '6. الخصوصية',
              content:
                  'نحترم خصوصيتك ونحمي معلوماتك الشخصية وفقاً لسياسة الخصوصية الخاصة بنا.',
            ),
            const SizedBox(height: 24),
            Text(
              'آخر تحديث: ديسمبر 2024',
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: MbuyColors.textTertiary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: MbuyColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

