import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/exports.dart';

class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  bool _isLoading = false;

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor, size: 24),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'التسويق',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppTheme.accentColor,
          child: _isLoading
              ? const SkeletonMarketingScreen()
              : GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildGridItem(
                      title: 'الكوبونات',
                      icon: Icons.local_offer_outlined,
                      color: const Color(0xFF4CAF50),
                      onTap: () => context.push('/dashboard/coupons'),
                    ),
                    _buildGridItem(
                      title: 'العروض الخاطفة',
                      icon: Icons.flash_on_outlined,
                      color: const Color(0xFFEF4444),
                      onTap: () => context.push('/dashboard/flash-sales'),
                    ),
                    _buildGridItem(
                      title: 'السلات المتروكة',
                      icon: Icons.shopping_cart_checkout_outlined,
                      color: const Color(0xFFE91E63),
                      onTap: () => context.push('/dashboard/abandoned-cart'),
                    ),
                    _buildGridItem(
                      title: 'برنامج الإحالة',
                      icon: Icons.share_outlined,
                      color: const Color(0xFF10B981),
                      onTap: () => context.push('/dashboard/referral'),
                    ),
                    _buildGridItem(
                      title: 'برنامج الولاء',
                      icon: Icons.loyalty_outlined,
                      color: const Color(0xFF00BCD4),
                      onTap: () => context.push('/dashboard/loyalty-program'),
                    ),
                    _buildGridItem(
                      title: 'شرائح العملاء',
                      icon: Icons.group_work_outlined,
                      color: const Color(0xFF3B82F6),
                      onTap: () => context.push('/dashboard/customer-segments'),
                    ),
                    _buildGridItem(
                      title: 'رسائل مخصصة',
                      icon: Icons.message_outlined,
                      color: const Color(0xFF22C55E),
                      onTap: () => context.push('/dashboard/custom-messages'),
                    ),
                    _buildGridItem(
                      title: 'التسعير الذكي',
                      icon: Icons.price_change_outlined,
                      color: Colors.orange,
                      onTap: () => context.push('/dashboard/smart-pricing'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
