import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة الدعم الفني للتاجر
class MerchantTechnicalSupportScreen extends StatelessWidget {
  const MerchantTechnicalSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('الدعم الفني'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSupportCard(
            icon: Icons.chat_bubble_outline,
            title: 'الدردشة المباشرة',
            subtitle: 'تواصل معنا مباشرة',
            onTap: () {
              // TODO: فتح الدردشة
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة الدردشة المباشرة قريباً')),
              );
            },
          ),
          _buildSupportCard(
            icon: Icons.email_outlined,
            title: 'البريد الإلكتروني',
            subtitle: 'support@mbuy.com',
            onTap: () {
              // TODO: فتح تطبيق البريد
            },
          ),
          _buildSupportCard(
            icon: Icons.phone_outlined,
            title: 'الهاتف',
            subtitle: '+966 50 123 4567',
            onTap: () {
              // TODO: فتح تطبيق الهاتف
            },
          ),
          _buildSupportCard(
            icon: Icons.bug_report_outlined,
            title: 'الإبلاغ عن مشكلة',
            subtitle: 'أبلغنا عن أي مشكلة تواجهها',
            onTap: () {
              // TODO: فتح نموذج الإبلاغ
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة نموذج الإبلاغ قريباً')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MbuyColors.primaryIndigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: MbuyColors.primaryIndigo),
        ),
        title: Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MbuyColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: MbuyColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

