import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import 'merchant_store_setup_screen.dart';
import 'merchant_promotions_screen.dart';
import 'merchant_help_center_screen.dart';
import 'merchant_products_screen.dart';
import 'merchant_orders_screen.dart';
import '../../../../shared/widgets/mbuy_logo.dart';
// الشاشات الجديدة
import 'merchant_analytics_screen_new.dart';
import 'merchant_reviews_screen.dart';
import 'merchant_coupons_screen.dart';
import 'merchant_banners_screen.dart';
import 'merchant_videos_screen.dart';

class MerchantDashboardScreen extends StatefulWidget {
  final AppModeProvider appModeProvider;

  const MerchantDashboardScreen({super.key, required this.appModeProvider});

  @override
  State<MerchantDashboardScreen> createState() =>
      _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState extends State<MerchantDashboardScreen> {
  // Mock Data
  final String storeName = 'معاذ باي';
  final String storeStatus = 'سجل تجاري';
  final String storeLink = 'tabayu.com/Muath-Buy';

  // Chart Data from center screen (Revenue & Expense Comparison)
  // Dual-axis bar chart data for Jan-Jun
  final List<SalesVisitsData> barChartData = [
    SalesVisitsData(month: 'يناير', revenue: 700, expense: 500),
    SalesVisitsData(month: 'فبراير', revenue: 1700, expense: 1200),
    SalesVisitsData(month: 'مارس', revenue: 2000, expense: 1500),
    SalesVisitsData(month: 'أبريل', revenue: 400, expense: 300),
    SalesVisitsData(month: 'مايو', revenue: 3000, expense: 2500),
    SalesVisitsData(month: 'يونيو', revenue: 2500, expense: 2000),
  ];

  // Constants from image measurements
  static const double _chartHeight = 200.0;
  static const double _axisLabelFontSize = 10.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Facebook gray background
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          // Profile Section (Facebook-style)
          SliverToBoxAdapter(child: _buildProfileSection()),

          // Shortcuts Section (replaced with chart)
          SliverToBoxAdapter(child: _buildShortcutsSection()),

          // Store Management Section (Full Width)
          SliverToBoxAdapter(child: _buildStoreManagementSection()),

          // Main Menu Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildListDelegate([
                _buildMenuCard(
                  icon: Icons.analytics,
                  title: 'الإحصائيات',
                  subtitle: 'تحليلات المتجر',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MerchantAnalyticsScreenNew(),
                      ),
                    );
                  },
                  badge: 'جديد',
                ),
                _buildMenuCard(
                  icon: Icons.star_rate,
                  title: 'التقييمات',
                  subtitle: 'إدارة المراجعات',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFf5576c), Color(0xFFf093fb)],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantReviewsScreen(),
                      ),
                    );
                  },
                  badge: 'جديد',
                ),
                _buildMenuCard(
                  icon: Icons.local_offer,
                  title: 'الكوبونات',
                  subtitle: 'إدارة الخصومات',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantCouponsScreen(),
                      ),
                    );
                  },
                  badge: 'جديد',
                ),
                _buildMenuCard(
                  icon: Icons.image,
                  title: 'البانرات',
                  subtitle: 'إعلانات المتجر',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantBannersScreen(),
                      ),
                    );
                  },
                  badge: 'جديد',
                ),
                _buildMenuCard(
                  icon: Icons.video_library,
                  title: 'الفيديوهات',
                  subtitle: 'إدارة المحتوى',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantVideosScreen(),
                      ),
                    );
                  },
                  badge: 'جديد',
                ),
                _buildMenuCard(
                  icon: Icons.loyalty,
                  title: 'الولاء',
                  subtitle: 'برامج الولاء والمكافآت',
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade400, Colors.purple.shade600],
                  ),
                  onTap: () {
                    _showSnackBar('سيتم إضافة الولاء قريباً');
                  },
                ),
                _buildMenuCard(
                  icon: Icons.campaign_outlined,
                  title: 'التسويق',
                  subtitle: 'الحملات والعروض',
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.orange.shade600],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantPromotionsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.article_outlined,
                  title: 'يوميات التاجر',
                  subtitle: 'القصص والمحتوى',
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  ),
                  onTap: () {
                    _showSnackBar('سيتم إضافة يوميات التاجر قريباً');
                  },
                ),
                _buildMenuCard(
                  icon: Icons.local_shipping_outlined,
                  title: 'الشحن',
                  subtitle: 'إدارة الشحن والتوصيل',
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.teal.shade600],
                  ),
                  onTap: () {
                    _showSnackBar('سيتم إضافة الشحن قريباً');
                  },
                ),
                _buildMenuCard(
                  icon: Icons.handshake_outlined,
                  title: 'ادعمني ودادعمك',
                  subtitle: 'الدعم المتبادل',
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade400, Colors.pink.shade600],
                  ),
                  onTap: () {
                    _showSnackBar('سيتم إضافة ادعمني ودادعمك قريباً');
                  },
                ),
              ]),
            ),
          ),

          // Show More Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () {
                  // TODO: عرض المزيد
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'عرض المزيد',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: MbuyColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),

          // Help & Support Section
          SliverToBoxAdapter(child: _buildHelpSupportSection()),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'القائمة',
        style: GoogleFonts.cairo(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: MbuyColors.textPrimary,
        ),
      ),
      // في RTL: leading على اليمين، actions على اليسار
      // نريد: الإعدادات على اليسار (actions)، الانتقال على اليمين (leading)
      leadingWidth: 60,
      leading: IconButton(
        icon: Icon(Icons.swap_horiz, color: MbuyColors.textPrimary),
        onPressed: () {
          widget.appModeProvider.setCustomerMode();
        },
        tooltip: 'الانتقال إلى تطبيق العميل',
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings_outlined, color: MbuyColors.textPrimary),
          onPressed: () {
            // TODO: Navigate to settings
            _showSnackBar('سيتم إضافة الإعدادات قريباً');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: MbuyColors.textPrimary,
          ),
          onPressed: () {
            _showNotificationsBottomSheet();
          },
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MbuyColors.borderLight, width: 0.5),
      ),
      child: Column(
        children: [
          // MBuy Logo at the top
          Center(child: MbuyLogo(size: 80, showBackground: false)),
          const SizedBox(height: 16),
          // Balance and Coins Section (replacing store avatar)
          _buildBalanceSection(),
          const SizedBox(height: 20),
          // Three Tabs: الترويج, mbuy tools, mbuy studio (separated and larger)
          _buildTabsSection(),
        ],
      ),
    );
  }

  Widget _buildShortcutsSection() {
    // This section replaces "اختصاراتك" with the chart
    // Exact dimensions matching "اختصاراتك" card from Facebook design
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: MbuyColors.borderLight, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SizedBox(height: _chartHeight, child: _buildChartWidget()),
        ),
        // Tabs below chart: المبيعات, الزيارات, الاحصائيات
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            border: Border.all(color: MbuyColors.borderLight, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildChartTab(
                  label: 'المبيعات',
                  color: const Color(0xFF4A90E2),
                ),
              ),
              Expanded(
                child: _buildChartTab(label: 'الزيارات', color: Colors.green),
              ),
              Expanded(
                child: _buildChartTab(
                  label: 'الاحصائيات',
                  color: MbuyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartTab({required String label, required Color color}) {
    return InkWell(
      onTap: () {
        // Navigate to appropriate screen based on label
        if (label == 'المبيعات') {
          _showSnackBar('عرض المبيعات');
          // TODO: Navigate to sales screen
        } else if (label == 'الزيارات') {
          _showSnackBar('عرض الزيارات');
          // TODO: Navigate to visits screen
        } else if (label == 'الاحصائيات') {
          _showSnackBar('عرض الاحصائيات');
          // TODO: Navigate to statistics screen
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label == 'المبيعات' || label == 'الزيارات')
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            if (label == 'المبيعات' || label == 'الزيارات')
              const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: MbuyColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Balance
        Text(
          'الرصيد الإجمالي:',
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: MbuyColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '5000.00 SAR',
          style: GoogleFonts.cairo(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MbuyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        // Currencies/Coins - Same format as Total Balance
        Text(
          'العملات:',
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: MbuyColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // Coin Icon
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.monetization_on,
                color: Colors.amber,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '1250 MBuy Coins',
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MbuyColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTabButton(
                icon: Icons.trending_up,
                label: 'الترويج',
                subtitle: 'دعم المنتجات والمتاجر',
                gradient: LinearGradient(
                  colors: [Colors.purple.shade400, Colors.purple.shade600],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MerchantPromotionsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTabButton(
                icon: Icons.analytics,
                label: 'mbuy tools',
                subtitle: 'التحليلات والأدوات الذكية',
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                ),
                onTap: () {
                  _showSnackBar('سيتم إضافة mbuy tools قريباً');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTabButton(
                icon: Icons.shopping_bag,
                label: 'تصفح المنتجات',
                subtitle: 'عرض منتجات السوق',
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade600],
                ),
                onTap: () {
                  // التبديل إلى وضع العميل
                  widget.appModeProvider.setMode(AppMode.customer);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // زر mbuy studio في صف منفصل
        _buildTabButton(
          icon: Icons.video_library,
          label: 'mbuy studio',
          subtitle: 'الفيديو والصوت والصورة',
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade600],
          ),
          onTap: () {
            _showSnackBar('سيتم إضافة mbuy studio قريباً');
          },
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 100, maxHeight: 120),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartWidget() {
    // Calculate max values for dual-axis chart
    final maxRevenue = barChartData
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b);
    final maxExpense = barChartData
        .map((e) => e.expense)
        .reduce((a, b) => a > b ? a : b);
    final maxLeftAxis = ((maxRevenue / 1000).ceil() * 1000).toDouble();
    final maxRightAxis = ((maxExpense / 1000).ceil() * 1000).toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxLeftAxis,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0 ||
                    value == maxLeftAxis / 2 ||
                    value == maxLeftAxis) {
                  return Text(
                    '${(value / 1000).toStringAsFixed(0)}K',
                    style: GoogleFonts.cairo(
                      fontSize: _axisLabelFontSize,
                      color: const Color(0xFF666666),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0 ||
                    value == maxRightAxis / 2 ||
                    value == maxRightAxis) {
                  return Text(
                    '${(value / 1000).toStringAsFixed(0)}K',
                    style: GoogleFonts.cairo(
                      fontSize: _axisLabelFontSize,
                      color: const Color(0xFF666666),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < barChartData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      barChartData[index].month,
                      style: GoogleFonts.cairo(
                        fontSize: _axisLabelFontSize,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxLeftAxis / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: const Color(0xFFE0E0E0), strokeWidth: 0.5);
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(barChartData.length, (index) {
          final data = barChartData[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              // Revenue bars (blue) - left axis
              BarChartRodData(
                toY: data.revenue,
                color: const Color(0xFF4A90E2),
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              // Expense bars (green) - right axis
              BarChartRodData(
                toY: data.expense,
                color: Colors.green,
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
            barsSpace: 4,
          );
        }),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 120),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.cairo(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreManagementSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MerchantStoreSetupScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.store_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'خدمات التاجر',
                            style: GoogleFonts.cairo(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'إدارة المتجر والمنتجات والطلبات',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.inventory_2_outlined,
                        label: 'المنتجات',
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
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.settings_outlined,
                        label: 'الإعدادات',
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
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.receipt_long_outlined,
                        label: 'الطلبات',
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSupportSection() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MerchantHelpCenterScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MbuyColors.borderLight, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(Icons.help_outline, color: MbuyColors.textTertiary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'المساعدة والدعم',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: MbuyColors.textPrimary,
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
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  // Removed _showStoreMenuBottomSheet and related methods - now using MerchantStoreManagementScreen instead

  void _showNotificationsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              labelColor: MbuyColors.primaryIndigo,
              unselectedLabelColor: MbuyColors.textSecondary,
              indicatorColor: MbuyColors.primaryIndigo,
              tabs: [
                Tab(
                  child: Text(
                    'الإشعارات',
                    style: GoogleFonts.cairo(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'المجتمع',
                    style: GoogleFonts.cairo(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 300,
              child: TabBarView(
                children: [
                  // Notifications Tab
                  Center(
                    child: Text(
                      'لا توجد إشعارات',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ),
                  // Community Tab
                  Center(
                    child: Text(
                      'المجتمع',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Model for Bar Chart
class SalesVisitsData {
  final String month;
  final double revenue; // المبيعات
  final double expense; // الزيارات

  SalesVisitsData({
    required this.month,
    required this.revenue,
    required this.expense,
  });
}
