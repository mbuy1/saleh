import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({super.key});

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  // Mock Data
  final String merchantName = 'محمد أحمد';
  final String storeName = 'متجر الإلكترونيات الذكية';
  final String storeStatus = 'عام';
  final int followersCount = 2450;
  final int newOrdersCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Section
            SliverToBoxAdapter(child: _buildHeader()),

            // Merchant Profile Card
            SliverToBoxAdapter(child: _buildMerchantProfileCard()),

            // Feature Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildListDelegate([
                  _buildFeatureCard(
                    icon: Icons.shopping_bag_outlined,
                    title: 'الطلبات',
                    badge: newOrdersCount,
                    onTap: () {},
                  ),
                  _buildFeatureCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'المنتجات',
                    onTap: () {},
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
                    title: 'العروض والإعلانات',
                    onTap: () {},
                  ),
                  _buildFeatureCard(
                    icon: Icons.photo_library_outlined,
                    title: 'الستوري',
                    onTap: () {},
                  ),
                  _buildFeatureCard(
                    icon: Icons.menu_book_outlined,
                    title: 'كتالوج المتجر',
                    onTap: () {},
                  ),
                  _buildFeatureCard(
                    icon: Icons.star_outline,
                    title: 'تقييمات العملاء',
                    subtitle: '4.8 ⭐',
                    onTap: () {},
                  ),
                  _buildFeatureCard(
                    icon: Icons.settings_outlined,
                    title: 'الإعدادات المتقدمة',
                    onTap: () {},
                  ),
                  _buildFeatureCard(
                    icon: Icons.bar_chart_outlined,
                    title: 'الإحصائيات',
                    onTap: () {},
                  ),
                  _buildFeatureCard(
                    icon: Icons.people_outline,
                    title: 'المتابعون',
                    subtitle: '$followersCount متابع',
                    onTap: () {},
                  ),
                ]),
              ),
            ),

            // Divider
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Divider(color: MbuyColors.borderLight, thickness: 1),
              ),
            ),

            // Collapsible Sections
            SliverToBoxAdapter(child: _buildCollapsibleSections()),

            // Bottom Spacing
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          // Avatar with gradient border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: MbuyColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: MbuyColors.primaryPurple.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: MbuyColors.surface,
                child: Text(
                  merchantName.substring(0, 1),
                  style: GoogleFonts.cairo(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: MbuyColors.primaryPurple,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchantName,
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MbuyColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'لوحة التحكم',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MbuyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Search Button
          _buildHeaderIconButton(icon: Icons.search, onTap: () {}),
          const SizedBox(width: 8),

          // Settings Button
          _buildHeaderIconButton(icon: Icons.settings_outlined, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: MbuyColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: MbuyColors.textSecondary, size: 24),
        ),
      ),
    );
  }

  Widget _buildMerchantProfileCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Store Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: MbuyColors.primaryGradient,
                ),
                child: const Icon(Icons.store, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),

              // Store Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeName,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: MbuyColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            storeStatus,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: MbuyColors.success,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: MbuyColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$followersCount',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: MbuyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Important Stats Row (Products - Orders - Rating)
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

          const SizedBox(height: 24),

          // Manage Store Button
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(14),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: MbuyColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: MbuyColors.primaryPurple.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.store_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'إدارة المتجر',
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isHighlighted
                ? MbuyColors.primaryPurple
                : MbuyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: MbuyColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
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
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: MbuyColors.primaryPurple.withValues(alpha: 0.1),
        highlightColor: MbuyColors.primaryPurple.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MbuyColors.primaryPurple.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      color: MbuyColors.primaryPurple,
                      size: 34,
                    ),
                  ),
                  if (badge != null && badge > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: MbuyColors.error,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 0,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 22,
                          minHeight: 22,
                        ),
                        child: Text(
                          '$badge',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MbuyColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: MbuyColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
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
            color: MbuyColors.textSecondary,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MbuyColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: MbuyColors.textSecondary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: MbuyColors.textSecondary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: MbuyColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
