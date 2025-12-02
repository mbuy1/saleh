import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة المجتمع للتاجر
class MerchantCommunityScreen extends StatelessWidget {
  const MerchantCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('المجتمع'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCommunityCard(
            context: context,
            title: 'مجموعة التجار',
            description: 'انضم لمجموعة التجار وشارك تجربتك',
            memberCount: 1250,
            icon: Icons.people,
          ),
          _buildCommunityCard(
            context: context,
            title: 'نصائح التسويق',
            description: 'تعلم من أفضل الممارسات',
            memberCount: 890,
            icon: Icons.trending_up,
          ),
          _buildCommunityCard(
            context: context,
            title: 'دعم فني',
            description: 'احصل على المساعدة من الخبراء',
            memberCount: 450,
            icon: Icons.support_agent,
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard({
    required BuildContext context,
    required String title,
    required String description,
    required int memberCount,
    required IconData icon,
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: MbuyColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$memberCount عضو',
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: MbuyColors.textTertiary,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: فتح المجموعة
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('سيتم إضافة المجموعات قريباً')),
          );
        },
      ),
    );
  }
}

