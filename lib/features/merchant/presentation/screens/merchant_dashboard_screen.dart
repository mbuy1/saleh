import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import 'merchant_orders_screen.dart';
import 'merchant_store_setup_screen.dart';
import 'merchant_promotions_screen.dart';

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

  // Chart Data (merged Sales & Visits)
  final List<ChartData> chartData = [
    ChartData(time: '6 ص', sales: 20, visits: 15),
    ChartData(time: '12 ص', sales: 35, visits: 25),
    ChartData(time: '6 م', sales: 45, visits: 30),
    ChartData(time: '12 م', sales: 30, visits: 20),
  ];

  // Category totals
  final double salesTotal = 6.0; // hours
  final double visitsTotal = 1.22; // hours
  final double statsTotal = 0.38; // hours

  // App usage data
  final List<AppUsage> appUsage = [
    AppUsage(name: 'أدواتي', time: '36 د', color: Colors.orange, icon: Icons.build),
    AppUsage(name: 'يوميات', time: '32 د', color: Colors.purple, icon: Icons.book),
    AppUsage(name: 'ضاعف ظهورك', time: '47 د', color: Colors.yellow, icon: Icons.trending_up),
    AppUsage(name: 'mBuy Studio', time: '5 س 15 د', color: Colors.black, icon: Icons.movie_creation),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Facebook gray background
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          // Profile Section (Facebook-style)
          SliverToBoxAdapter(child: _buildProfileSection()),

          // Chart Section (below store link)
          SliverToBoxAdapter(child: _buildChartSection()),

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
                  icon: Icons.shopping_bag_outlined,
                  title: 'الطلبات',
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantOrdersScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.store_outlined,
                  title: 'إدارة المتجر',
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantStoreSetupScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.campaign_outlined,
                  title: 'التسويق',
                  iconColor: Colors.blue,
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
                  icon: Icons.palette_outlined,
                  title: 'مظهر المتجر',
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantStoreSetupScreen(),
                      ),
                    );
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

          // Switch to Customer App Button
          SliverToBoxAdapter(child: _buildSwitchAppButton()),

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
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: MbuyColors.textPrimary),
          onPressed: () {
            // TODO: البحث
          },
        ),
        IconButton(
          icon: Icon(Icons.settings_outlined, color: MbuyColors.textPrimary),
          onPressed: () {
            // TODO: الإعدادات
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
          // Profile Row
          Row(
            children: [
              // Store Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: MbuyColors.primaryIndigo.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.store,
                  color: MbuyColors.primaryIndigo,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              // Store Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeName,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      storeStatus,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // View Store Button (instead of dropdown arrow)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MerchantStoreSetupScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'عرض المتجر',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Store Link Section (instead of "Create new page")
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MbuyColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رابط متجري',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: MbuyColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              storeLink,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MbuyColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildLinkActionButton(
                            icon: Icons.qr_code,
                            onTap: () {
                              _showSnackBar('سيتم إضافة QR Code قريباً');
                            },
                          ),
                          const SizedBox(width: 4),
                          _buildLinkActionButton(
                            icon: Icons.copy,
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: storeLink));
                              _showSnackBar('تم نسخ الرابط');
                            },
                          ),
                          const SizedBox(width: 4),
                          _buildLinkActionButton(
                            icon: Icons.share,
                            onTap: () {
                              _showSnackBar('سيتم إضافة المشاركة قريباً');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Plus Icon (like Facebook)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: MbuyColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: MbuyColors.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: MbuyColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    final totalTime = '${(salesTotal + visitsTotal + statsTotal).toStringAsFixed(0)} س ${((salesTotal + visitsTotal + statsTotal) % 1 * 60).toInt()} د';
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MbuyColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Time
          Text(
            totalTime,
            style: GoogleFonts.cairo(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          // Chart
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartData.map((data) {
                final maxValue = 60.0;
                final salesHeight = (data.sales / maxValue) * 120;
                final visitsHeight = (data.visits / maxValue) * 120;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Stacked bars (Sales + Visits merged)
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Visits (bottom, light blue)
                            Container(
                              height: visitsHeight,
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.3),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                            // Sales (top, dark blue)
                            Container(
                              height: salesHeight,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.time,
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: MbuyColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Y-axis labels
          Row(
            children: [
              Text(
                '0',
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: MbuyColors.textTertiary,
                ),
              ),
              const Spacer(),
              Text(
                '30 د',
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: MbuyColors.textTertiary,
                ),
              ),
              const Spacer(),
              Text(
                '60 د',
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: MbuyColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Category Summary
          Row(
            children: [
              Expanded(
                child: _buildCategoryItem(
                  'المبيعات',
                  '${salesTotal.toStringAsFixed(0)} س ${((salesTotal % 1) * 60).toInt()} د',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildCategoryItem(
                  'الزيارات',
                  '${visitsTotal.toStringAsFixed(0)} س ${((visitsTotal % 1) * 60).toInt()} د',
                  Colors.cyan,
                ),
              ),
              Expanded(
                child: _buildCategoryItem(
                  'الإحصائيات',
                  '${(statsTotal * 60).toInt()} د',
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // App Usage List
          ...appUsage.map((app) => _buildAppUsageItem(app)),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: MbuyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppUsageItem(AppUsage app) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: app.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(app.icon, color: app.color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              app.name,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: MbuyColors.textPrimary,
              ),
            ),
          ),
          Text(
            app.time,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: MbuyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: MbuyColors.borderLight, width: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: MbuyColors.textPrimary,
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
    return Container(
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
    );
  }

  Widget _buildSwitchAppButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () {
          widget.appModeProvider.setCustomerMode();
        },
        icon: const Icon(Icons.swap_horiz, size: 20),
        label: Text(
          'الانتقال إلى تطبيق العميل',
          style: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MbuyColors.primaryIndigo,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Data Models
class ChartData {
  final String time;
  final double sales;
  final double visits;

  ChartData({
    required this.time,
    required this.sales,
    required this.visits,
  });
}

class AppUsage {
  final String name;
  final String time;
  final Color color;
  final IconData icon;

  AppUsage({
    required this.name,
    required this.time,
    required this.color,
    required this.icon,
  });
}
