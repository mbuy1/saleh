import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة سياسات المتاجر
class MerchantPoliciesScreen extends StatelessWidget {
  const MerchantPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('سياسات المتاجر'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPolicyCard(
            title: 'سياسة المنتجات',
            content:
                'يجب أن تكون جميع المنتجات المضافة قانونية ومطابقة للمواصفات. يحظر بيع المنتجات المقلدة أو المحظورة.',
          ),
          _buildPolicyCard(
            title: 'سياسة الأسعار',
            content:
                'يجب أن تكون الأسعار واضحة ودقيقة. يحظر التلاعب بالأسعار أو الإعلان عن أسعار خاطئة.',
          ),
          _buildPolicyCard(
            title: 'سياسة الشحن',
            content:
                'يجب تحديد أوقات الشحن بدقة. يحظر تأخير الشحن دون إشعار العملاء.',
          ),
          _buildPolicyCard(
            title: 'سياسة الإرجاع',
            content:
                'يجب توضيح سياسة الإرجاع للعملاء. يحظر رفض الإرجاع في الحالات المشروعة.',
          ),
          _buildPolicyCard(
            title: 'سياسة الخصوصية',
            content:
                'يجب حماية بيانات العملاء وعدم مشاركتها مع أطراف ثالثة دون موافقة.',
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard({required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 12),
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
      ),
    );
  }
}

