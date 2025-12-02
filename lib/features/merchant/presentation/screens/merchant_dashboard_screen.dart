import 'dart:ui'; // For ImageFilter (Glassmorphism)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/merchant_bottom_bar.dart';
import 'merchant_products_screen.dart';
import 'merchant_orders_screen.dart';
import 'merchant_store_setup_screen.dart';

class MerchantDashboardScreen extends StatefulWidget {
  final AppModeProvider appModeProvider;

  const MerchantDashboardScreen({super.key, required this.appModeProvider});

  @override
  State<MerchantDashboardScreen> createState() =>
      _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState extends State<MerchantDashboardScreen> {
  // Mock Data
  final String storeName = 'متجر الإلكترونيات الذكية';
  final String storeStatus = 'عام';
  final int followersCount = 2450;
  final int newOrdersCount = 5;

  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Dashboard Content
            CustomScrollView(
              slivers: [
                // Combined Header (Store Info + Stats + Action)
                SliverToBoxAdapter(child: _buildStoreHeader()),

                // Feature Grid
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    100,
                  ), // Bottom padding for scrolling
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1, // Adjusted to prevent overflow
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    delegate: SliverChildListDelegate([
                      _buildFeatureCard(
                        icon: Icons.shopping_bag_outlined,
                        title: 'الطلبات',
                        badge: newOrdersCount,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MerchantOrdersScreen(),
                            ),
                          );
                        },
                      ),
                      _buildFeatureCard(
                        icon: Icons.inventory_2_outlined,
                        title: 'المنتجات',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MerchantProductsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildFeatureCard(
                        icon: Icons.stars_outlined,
                        title: 'نقاط التاجر',
                        subtitle: '1,250 نقطة',
                        onTap: () {},
                      ),
                      _buildFeatureCard(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'المحفظة',
                        subtitle: '12,450 ر.س',
                        onTap: () {},
                      ),
                      _buildFeatureCard(
                        icon: Icons.chat_bubble_outline,
                        title: 'الرسائل',
                        badge: 3,
                        onTap: () {},
                      ),
                      _buildFeatureCard(
                        icon: Icons.campaign_outlined,
                        title: 'العروض',
                        onTap: () {},
                      ),
                      _buildFeatureCard(
                        icon: Icons.photo_library_outlined,
                        title: 'الستوري',
                        onTap: () {},
                      ),
                      _buildFeatureCard(
                        icon: Icons.menu_book_outlined,
                        title: 'الكتالوج',
                        onTap: () {},
                      ),
                      _buildFeatureCard(
                        icon: Icons.star_outline,
                        title: 'التقييمات',
                        subtitle: '4.8 ⭐',
                        onTap: () {},
                      ),
                      _buildFeatureCard(
                        icon: Icons.settings_outlined,
                        title: 'الإعدادات',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MerchantStoreSetupScreen(),
                            ),
                          );
                        },
                      ),
                      _buildFeatureCard(
                        icon: Icons.bar_chart_outlined,
                        title: 'الإحصائيات',
                        onTap: () {},
                      ),
                      _buildFeatureCard(
                        icon: Icons.people_outline,
                        title: 'المتابعون',
                        subtitle: '$followersCount',
                        onTap: () {},
                      ),
                    ]),
                  ),
                ),

                // Collapsible Sections
                SliverToBoxAdapter(child: _buildCollapsibleSections()),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),

            // Bottom Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MerchantBottomBar(
                currentIndex: _bottomNavIndex,
                onTap: (index) {
                  setState(() {
                    _bottomNavIndex = index;
                  });
                },
                onAddTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MerchantProductsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(MbuySpacing.cardRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: MbuySpacing.glassBlur,
          sigmaY: MbuySpacing.glassBlur,
        ),
        child: Container(
          padding: EdgeInsets.all(MbuySpacing.headerPadding), // 14px
          decoration: BoxDecoration(
            color: MbuyColors.glassBackground,
            border: Border.all(color: MbuyColors.glassBorder, width: 1),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(MbuySpacing.cardRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 22,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Super Premium Store-Focused Header (iOS-like spacious)
              Row(
                children: [
                  // Store Image - 60px per Super Premium spec
                  Container(
                    width: MbuyIconSizes.merchant, // 60px
                    height: MbuyIconSizes.merchant,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: MbuyColors.surface,
                      border: Border.all(
                        color: MbuyColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.store_outlined,
                      color: MbuyColors.textSecondary,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: MbuySpacing.iconTextGap),
                  // Store Name & Status - Super Premium Typography
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeName,
                          style: GoogleFonts.cairo(
                            fontSize: 20, // Title L - SemiBold
                            fontWeight: FontWeight.w600,
                            color: MbuyColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          storeStatus,
                          style: GoogleFonts.cairo(
                            fontSize: 14, // Subtext - Medium
                            fontWeight: FontWeight.w500,
                            color: MbuyColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Actions - Gray Icons (24px header size)
                  Row(
                    children: [
                      _buildHeaderIconButton(
                        Icons.swap_horiz,
                        () => widget.appModeProvider.setCustomerMode(),
                      ),
                      const SizedBox(width: 6),
                      _buildHeaderIconButton(Icons.settings_outlined, () {}),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Stats Section - Clean Numbers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('المنتجات', '124', Icons.inventory_2_outlined),
                  _buildStatItem(
                    'الطلبات',
                    '$newOrdersCount',
                    Icons.shopping_bag_outlined,
                    isHighlighted: true,
                  ),
                  _buildStatItem('التقييم', '4.8', Icons.star_outline),
                ],
              ),

              const SizedBox(height: 20),

              // Manage Store Button - Gradient Style
              Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: MbuyColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: MbuyColors.primaryPurple.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Text(
                        'إدارة المتجر',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MbuyColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: MbuyColors.textSecondary,
            size: MbuyIconSizes.header, // 24px per Ultra Premium spec
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon, {
    bool isHighlighted = false,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: MbuyColors.textPrimary,
            height: 1.0,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: MbuyColors.textTertiary),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MbuyColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    String? subtitle,
    int? badge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(MbuySpacing.cardRadius),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MbuySpacing.cardRadius),
        splashColor: Colors.black.withValues(alpha: 0.05),
        highlightColor: Colors.black.withValues(alpha: 0.02),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: MbuyColors.borderLight, width: 1),
            borderRadius: BorderRadius.circular(MbuySpacing.cardRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة كبيرة ممتلئة 42-48px
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: MbuyColors.textPrimary,
                    size: MbuyIconSizes.gridItem, // 45px
                  ),
                  if (badge != null && badge > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: MbuyColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '$badge',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // نص تحت الأيقونة مباشرة
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: MbuyColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: MbuyColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsibleSections() {
    return Column(
      children: [
        _buildExpandableSection(
          title: 'المساعدة والدعم',
          items: [
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'مركز المساعدة',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.support_agent_outlined,
              title: 'الدعم الفني',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.policy_outlined,
              title: 'سياسات المتاجر',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildExpandableSection(
          title: 'الإدارة المالية',
          items: [
            _buildMenuItem(
              icon: Icons.receipt_long_outlined,
              title: 'إدارة الفواتير',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.payment_outlined,
              title: 'طرق الدفع',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.history_outlined,
              title: 'سجل المعاملات',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),

        // App Version
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Mbuy للتجار - الإصدار 1.0.0',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: MbuyColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MbuyColors.borderLight, width: 0.5),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: MbuyColors.textPrimary,
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_down,
            color: MbuyColors.textTertiary,
            size: 20,
          ),
          children: items,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: MbuyColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: MbuyColors.textSecondary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MbuyColors.textSecondary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 13,
                color: MbuyColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
