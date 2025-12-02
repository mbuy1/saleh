import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة المتابعين للتاجر
class MerchantFollowersScreen extends StatefulWidget {
  const MerchantFollowersScreen({super.key});

  @override
  State<MerchantFollowersScreen> createState() => _MerchantFollowersScreenState();
}

class _MerchantFollowersScreenState extends State<MerchantFollowersScreen> {
  final int _totalFollowers = 2450;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('المتابعون'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // إحصائيات المتابعين
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
                  '$_totalFollowers',
                  style: GoogleFonts.cairo(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'متابع',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // قائمة المتابعين
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFollowerCard(
                  name: 'أحمد محمد',
                  isFollowing: true,
                  lastOrder: 'منذ 3 أيام',
                ),
                _buildFollowerCard(
                  name: 'فاطمة علي',
                  isFollowing: true,
                  lastOrder: 'منذ أسبوع',
                ),
                _buildFollowerCard(
                  name: 'خالد سعيد',
                  isFollowing: false,
                  lastOrder: 'منذ شهر',
                ),
                _buildFollowerCard(
                  name: 'سارة أحمد',
                  isFollowing: true,
                  lastOrder: 'منذ يومين',
                ),
                _buildFollowerCard(
                  name: 'محمد خالد',
                  isFollowing: true,
                  lastOrder: 'منذ 5 أيام',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowerCard({
    required String name,
    required bool isFollowing,
    required String lastOrder,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MbuyColors.primaryIndigo,
          child: Text(
            name[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          name,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MbuyColors.textPrimary,
          ),
        ),
        subtitle: Text(
          'آخر طلب: $lastOrder',
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: MbuyColors.textSecondary,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isFollowing
                ? MbuyColors.success.withValues(alpha: 0.1)
                : MbuyColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isFollowing ? MbuyColors.success : MbuyColors.borderLight,
              width: 1,
            ),
          ),
          child: Text(
            isFollowing ? 'متابع' : 'غير متابع',
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isFollowing ? MbuyColors.success : MbuyColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

