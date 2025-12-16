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
      body: SafeArea(
        child: Column(
          children: [
            // AppBar مخصص
            _buildAppBar(context),
            // المحتوى
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                color: AppTheme.accentColor,
                child: _isLoading
                    ? const SkeletonMarketingScreen()
                    : GridView.count(
                        crossAxisCount: 2,
                        padding: AppDimensions.paddingM,
                        mainAxisSpacing: AppDimensions.spacing16,
                        crossAxisSpacing: AppDimensions.spacing16,
                        childAspectRatio: 0.95,
                        children: [
                          _buildGlassGridItem(
                            title: 'الكوبونات',
                            iconPath: AppIcons.discount,
                            color: const Color(0xFF4CAF50),
                            onTap: () => context.push('/dashboard/coupons'),
                          ),
                          _buildGlassGridItem(
                            title: 'العروض الخاطفة',
                            iconPath: AppIcons.flash,
                            color: const Color(0xFFEF4444),
                            onTap: () => context.push('/dashboard/flash-sales'),
                          ),
                          _buildGlassGridItem(
                            title: 'السلات المتروكة',
                            iconPath: AppIcons.cart,
                            color: const Color(0xFFE91E63),
                            onTap: () =>
                                context.push('/dashboard/abandoned-cart'),
                          ),
                          _buildGlassGridItem(
                            title: 'برنامج الإحالة',
                            iconPath: AppIcons.share,
                            color: const Color(0xFF10B981),
                            onTap: () => context.push('/dashboard/referral'),
                          ),
                          _buildGlassGridItem(
                            title: 'برنامج الولاء',
                            iconPath: AppIcons.loyalty,
                            color: const Color(0xFF00BCD4),
                            onTap: () =>
                                context.push('/dashboard/loyalty-program'),
                          ),
                          _buildGlassGridItem(
                            title: 'شرائح العملاء',
                            iconPath: AppIcons.users,
                            color: const Color(0xFF3B82F6),
                            onTap: () =>
                                context.push('/dashboard/customer-segments'),
                          ),
                          _buildGlassGridItem(
                            title: 'رسائل مخصصة',
                            iconPath: AppIcons.chat,
                            color: const Color(0xFF22C55E),
                            onTap: () =>
                                context.push('/dashboard/custom-messages'),
                          ),
                          _buildGlassGridItem(
                            title: 'التسعير الذكي',
                            iconPath: AppIcons.dollar,
                            color: Colors.orange,
                            onTap: () =>
                                context.push('/dashboard/smart-pricing'),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: AppIcon(AppIcons.arrowBack, color: AppTheme.primaryColor),
            onPressed: () => context.pop(),
          ),
          const Expanded(
            child: Text(
              'التسويق',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontDisplay3,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // لتوازن زر الرجوع
        ],
      ),
    );
  }

  Widget _buildGlassGridItem({
    required String title,
    required String iconPath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GlassCard.withSvgIcon(
      iconPath: iconPath,
      iconBackgroundColor: color,
      iconSize: AppDimensions.iconXL,
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppDimensions.fontTitle,
          color: AppTheme.textPrimaryColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
