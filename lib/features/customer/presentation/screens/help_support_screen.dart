import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة المساعدة والدعم
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('المساعدة والدعم'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpCard(
            icon: Icons.help_outline,
            title: 'الأسئلة الشائعة',
            onTap: () {
              _showFAQ();
            },
          ),
          _buildHelpCard(
            icon: Icons.chat_bubble_outline,
            title: 'الدردشة المباشرة',
            onTap: () {
              // TODO: فتح الدردشة
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة الدردشة المباشرة قريباً')),
              );
            },
          ),
          _buildHelpCard(
            icon: Icons.email_outlined,
            title: 'اتصل بنا',
            onTap: () {
              _showContactInfo();
            },
          ),
          _buildHelpCard(
            icon: Icons.bug_report_outlined,
            title: 'الإبلاغ عن مشكلة',
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

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
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
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showFAQ() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الأسئلة الشائعة',
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFAQItem('كيف أضيف منتج إلى السلة؟', 'اضغط على المنتج ثم اضغط زر "إضافة إلى السلة"'),
            _buildFAQItem('كيف أتابع طلبي؟', 'اذهب إلى "طلباتي" من القائمة الجانبية'),
            _buildFAQItem('كيف أغير كلمة المرور؟', 'اذهب إلى الإعدادات > تغيير كلمة المرور'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: GoogleFonts.cairo(fontSize: 14)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: GoogleFonts.cairo(fontSize: 13, color: MbuyColors.textSecondary),
          ),
        ),
      ],
    );
  }

  void _showContactInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصل بنا'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactItem(Icons.email, 'البريد الإلكتروني', 'support@mbuy.com'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.phone, 'الهاتف', '+966 50 123 4567'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.access_time, 'ساعات العمل', '9 صباحاً - 5 مساءً'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: MbuyColors.textSecondary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: MbuyColors.textTertiary,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MbuyColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

