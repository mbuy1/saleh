import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

/// أيقونة الحساب الشخصي مع Bottom Sheet
class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showProfileSheet(context),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: MbuyColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: MbuyColors.primaryPurple.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'م',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ProfileBottomSheet(),
    );
  }
}

/// Bottom Sheet للحساب الشخصي
class ProfileBottomSheet extends StatelessWidget {
  const ProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MbuyColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                // الصورة الشخصية
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: MbuyColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'م',
                      style: GoogleFonts.cairo(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // المعلومات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مستخدم mBuy',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'user@mbuy.com',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: MbuyColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // القائمة الأفقية للأقسام الرئيسية
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildQuickAction(
                  icon: Icons.person,
                  label: 'الملف الشخصي',
                  onTap: () {},
                ),
                _buildQuickAction(
                  icon: Icons.favorite,
                  label: 'المفضلة',
                  onTap: () {},
                ),
                _buildQuickAction(
                  icon: Icons.help_outline,
                  label: 'تحتاج مساعدة؟',
                  onTap: () {},
                ),
                _buildQuickAction(
                  icon: Icons.store,
                  label: 'أنشئ متجرك',
                  color: MbuyColors.primaryPurple,
                  onTap: () {},
                ),
                _buildQuickAction(
                  icon: Icons.account_balance_wallet,
                  label: 'رصيد mBuy',
                  onTap: () {},
                ),
                _buildQuickAction(
                  icon: Icons.shopping_bag,
                  label: 'طلباتي',
                  onTap: () {},
                ),
                _buildQuickAction(
                  icon: Icons.store_outlined,
                  label: 'المتاجر المتابعة',
                  onTap: () {},
                ),
                _buildQuickAction(
                  icon: Icons.local_offer,
                  label: 'الكوبونات',
                  onTap: () {},
                ),
                _buildQuickAction(
                  icon: Icons.history,
                  label: 'سجل التصفح',
                  onTap: () {},
                ),
                _buildQuickAction(
                  icon: Icons.lightbulb_outline,
                  label: 'الاقتراحات',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // الإعدادات في الأسفل
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MbuyColors.surface,
              border: Border(top: BorderSide(color: MbuyColors.borderLight)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  const Icon(
                    Icons.settings,
                    color: MbuyColors.textSecondary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'الإعدادات',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: MbuyColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(left: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color != null
                    ? color.withValues(alpha: 0.1)
                    : MbuyColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color ?? MbuyColors.textSecondary,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: MbuyColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
