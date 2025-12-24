import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';

/// Ø´Ø§Ø´Ø© Ø§Ù„Ø³Ø¬Ù„Ø§Øª ÙˆØ§Ù„ØªÙ‚Ø§Ø±ÙŠØ± - ØªÙ‚Ø§Ø±ÙŠØ± Ø´Ø§Ù…Ù„Ø© Ø¹Ù† Ù†Ø´Ø§Ø· Ø§Ù„Ù…ØªØ¬Ø±
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Data
  Map<String, dynamic> _salesData = {};
  Map<String, dynamic> _productsData = {};
  Map<String, dynamic> _customersData = {};
  List<Map<String, dynamic>> _activityLogs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // âš ï¸ Ø¨ÙŠØ§Ù†Ø§Øª ØªØ¬Ø±ÙŠØ¨ÙŠØ© Ù„Ù„Ø¹Ø±Ø¶ - Ø³ÙŠØªÙ… Ø±Ø¨Ø·Ù‡Ø§ Ø¨Ù€ API Ù„Ø§Ø­Ù‚Ø§Ù‹
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      // Ù…Ù„Ø§Ø­Ø¸Ø©: Ù‡Ø°Ù‡ Ø¨ÙŠØ§Ù†Ø§Øª ÙˆÙ‡Ù…ÙŠØ© Ù„Ù„Ø¹Ø±Ø¶ Ø§Ù„ØªÙˆØ¶ÙŠØ­ÙŠ ÙÙ‚Ø·
      _salesData = {
        'total': 0.0,
        'thisMonth': 0.0,
        'lastMonth': 0.0,
        'growth': 0.0,
        'orders': 0,
        'avgOrderValue': 0.0,
        'topProducts': <Map<String, dynamic>>[],
        'chartData': <int>[],
        'isDemo': true, // Ø¹Ù„Ø§Ù…Ø© Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„ÙˆÙ‡Ù…ÙŠØ©
      };

      // Ù…Ù„Ø§Ø­Ø¸Ø©: Ù‡Ø°Ù‡ Ø¨ÙŠØ§Ù†Ø§Øª ÙˆÙ‡Ù…ÙŠØ© Ù„Ù„Ø¹Ø±Ø¶ Ø§Ù„ØªÙˆØ¶ÙŠØ­ÙŠ ÙÙ‚Ø·
      _productsData = {
        'total': 0,
        'active': 0,
        'outOfStock': 0,
        'lowStock': 0,
        'topViewed': <Map<String, dynamic>>[],
        'isDemo': true,
      };

      // Ù…Ù„Ø§Ø­Ø¸Ø©: Ù‡Ø°Ù‡ Ø¨ÙŠØ§Ù†Ø§Øª ÙˆÙ‡Ù…ÙŠØ© Ù„Ù„Ø¹Ø±Ø¶ Ø§Ù„ØªÙˆØ¶ÙŠØ­ÙŠ ÙÙ‚Ø·
      _customersData = {
        'total': 0,
        'newThisMonth': 0,
        'returning': 0,
        'avgLifetimeValue': 0.0,
        'topCustomers': <Map<String, dynamic>>[],
        'isDemo': true,
      };

      _activityLogs = <Map<String, dynamic>>[];

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppTheme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Ø§Ù„Ø³Ø¬Ù„Ø§Øª ÙˆØ§Ù„ØªÙ‚Ø§Ø±ÙŠØ±',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.fontHeadline,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.download,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppTheme.textPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: _exportReport,
            tooltip: 'ØªØµØ¯ÙŠØ± Ø§Ù„ØªÙ‚Ø±ÙŠØ±',
          ),
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.refresh,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppTheme.textPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: _loadData,
            tooltip: 'ØªØ­Ø¯ÙŠØ«',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.slate600,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª'),
            Tab(text: 'Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª'),
            Tab(text: 'Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡'),
            Tab(text: 'Ø§Ù„Ø³Ø¬Ù„'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ØªÙ†Ø¨ÙŠÙ‡ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ù‚ÙŠØ¯ Ø§Ù„ØªØ·ÙˆÙŠØ±
                Container(
                  width: double.infinity,
                  margin: AppDimensions.paddingS,
                  padding: AppDimensions.paddingM,
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusM,
                    border: Border.all(
                      color: AppTheme.warningColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.warningColor,
                        size: AppDimensions.iconS,
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      Expanded(
                        child: Text(
                          'Ø§Ù„ØªÙ‚Ø§Ø±ÙŠØ± Ù‚ÙŠØ¯ Ø§Ù„ØªØ·ÙˆÙŠØ± - Ø³ÙŠØªÙ… Ø±Ø¨Ø·Ù‡Ø§ Ø¨Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„ÙØ¹Ù„ÙŠØ© Ù‚Ø±ÙŠØ¨Ø§Ù‹',
                          style: TextStyle(
                            color: AppTheme.warningColor,
                            fontSize: AppDimensions.fontBody2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSalesTab(),
                      _buildProductsTab(),
                      _buildCustomersTab(),
                      _buildActivityTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _exportReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ØªØµØ¯ÙŠØ± Ø§Ù„ØªÙ‚Ø±ÙŠØ±'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: SvgPicture.asset(
                AppIcons.document,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.red,
                  BlendMode.srcIn,
                ),
              ),
              title: const Text('PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ø¬Ø§Ø±ÙŠ ØªØµØ¯ÙŠØ± PDF...')),
                );
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                AppIcons.chart,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.green,
                  BlendMode.srcIn,
                ),
              ),
              title: const Text('Excel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ø¬Ø§Ø±ÙŠ ØªØµØ¯ÙŠØ± Excel...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª',
                  '${NumberFormat('#,##0.00').format(_salesData['total'])} Ø±.Ø³',
                  AppIcons.attachMoney,
                  AppTheme.successColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'Ù‡Ø°Ø§ Ø§Ù„Ø´Ù‡Ø±',
                  '${NumberFormat('#,##0.00').format(_salesData['thisMonth'])} Ø±.Ø³',
                  AppIcons.trendingUp,
                  AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª',
                  '${_salesData['orders']}',
                  AppIcons.shoppingBag,
                  AppTheme.infoColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'Ù…ØªÙˆØ³Ø· Ø§Ù„Ø·Ù„Ø¨',
                  '${NumberFormat('#,##0.00').format(_salesData['avgOrderValue'])} Ø±.Ø³',
                  AppIcons.analytics,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing24),

          // Growth Indicator
          _buildGrowthCard(),
          SizedBox(height: AppDimensions.spacing24),

          // Chart Placeholder
          _buildChartPlaceholder(),
          SizedBox(height: AppDimensions.spacing24),

          // Top Products
          _buildTopProductsSection(),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª',
                  '${_productsData['total']}',
                  AppIcons.inventory,
                  AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'Ù…Ù†ØªØ¬Ø§Øª Ù†Ø´Ø·Ø©',
                  '${_productsData['active']}',
                  AppIcons.checkCircle,
                  AppTheme.successColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Ù†ÙØ¯ Ø§Ù„Ù…Ø®Ø²ÙˆÙ†',
                  '${_productsData['outOfStock']}',
                  AppIcons.removeShoppingCart,
                  AppTheme.errorColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'Ù…Ø®Ø²ÙˆÙ† Ù…Ù†Ø®ÙØ¶',
                  '${_productsData['lowStock']}',
                  AppIcons.warning,
                  AppTheme.warningColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing24),

          // Top Viewed
          _buildSection(
            'Ø§Ù„Ø£ÙƒØ«Ø± Ù…Ø´Ø§Ù‡Ø¯Ø©',
            _productsData['topViewed'] as List? ?? [],
            (item) => ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: SvgPicture.asset(
                  AppIcons.visibility,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppTheme.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(item['name']),
              trailing: Text(
                '${item['views']} Ù…Ø´Ø§Ù‡Ø¯Ø©',
                style: TextStyle(color: AppTheme.slate600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡',
                  '${_customersData['total']}',
                  AppIcons.people,
                  AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'Ø¹Ù…Ù„Ø§Ø¡ Ø¬Ø¯Ø¯',
                  '${_customersData['newThisMonth']}',
                  AppIcons.personAdd,
                  AppTheme.successColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Ø¹Ù…Ù„Ø§Ø¡ Ø¹Ø§Ø¦Ø¯ÙˆÙ†',
                  '${_customersData['returning']}',
                  AppIcons.refresh,
                  AppTheme.infoColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'Ù…ØªÙˆØ³Ø· Ø§Ù„Ø¥Ù†ÙØ§Ù‚',
                  '${NumberFormat('#,##0.00').format(_customersData['avgLifetimeValue'])} Ø±.Ø³',
                  AppIcons.wallet,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing24),

          // Top Customers
          _buildSection(
            'Ø£ÙØ¶Ù„ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡',
            _customersData['topCustomers'] as List? ?? [],
            (item) => ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.accentColor.withValues(alpha: 0.1),
                child: SvgPicture.asset(
                  AppIcons.person,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppTheme.accentColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(item['name']),
              subtitle: Text('${item['orders']} Ø·Ù„Ø¨'),
              trailing: Text(
                '${NumberFormat('#,##0').format(item['spent'])} Ø±.Ø³',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: _activityLogs.length,
      itemBuilder: (context, index) {
        final log = _activityLogs[index];
        return _buildActivityItem(log);
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String iconPath,
    Color color,
  ) {
    return Container(
      padding: AppDimensions.paddingM,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusL,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppDimensions.paddingXS,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppDimensions.borderRadiusS,
                ),
                child: SvgPicture.asset(
                  iconPath,
                  width: AppDimensions.iconS,
                  height: AppDimensions.iconS,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          Text(
            value,
            style: TextStyle(
              fontSize: AppDimensions.fontDisplay3,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.spacing4),
          Text(
            title,
            style: TextStyle(
              fontSize: AppDimensions.fontLabel,
              color: AppTheme.slate600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard() {
    final growth = _salesData['growth'] as double? ?? 0;
    final isPositive = growth >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPositive
            ? AppTheme.successColor.withValues(alpha: 0.1)
            : AppTheme.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            isPositive ? AppIcons.trendingUp : AppIcons.trendingDown,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              isPositive ? AppTheme.successColor : AppTheme.errorColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ù†Ù…Ùˆ Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª',
                  style: TextStyle(
                    color: AppTheme.slate600,
                    fontSize: AppDimensions.fontBody,
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${growth.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: AppDimensions.fontDisplay2,
                    fontWeight: FontWeight.bold,
                    color: isPositive
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Ù…Ù‚Ø§Ø±Ù†Ø© Ø¨Ø§Ù„Ø´Ù‡Ø± Ø§Ù„Ù…Ø§Ø¶ÙŠ',
            style: TextStyle(
              color: AppTheme.slate600,
              fontSize: AppDimensions.fontLabel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    final chartData = _salesData['chartData'] as List? ?? [];
    final dayLabels = ['Ø³', 'Ø£', 'Ø«', 'Ø£', 'Ø®', 'Ø¬', 'Ø³'];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹ÙŠØ©',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontTitle,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < 7; i++)
                  _buildChartBar(
                    i < chartData.length ? (chartData[i]?.toDouble() ?? 0) : 0,
                    dayLabels[i],
                    i == 6,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(double value, String label, bool isHighlighted) {
    final maxValue = 4000.0;
    final height = (value / maxValue) * 100;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: height.clamp(10, 100),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppTheme.primaryColor
                : AppTheme.primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppDimensions.fontCaption - 1,
            color: AppTheme.slate600,
          ),
        ),
      ],
    );
  }

  Widget _buildTopProductsSection() {
    final products = _salesData['topProducts'] as List? ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„Ø£ÙƒØ«Ø± Ù…Ø¨ÙŠØ¹Ø§Ù‹',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontTitle,
            ),
          ),
          const SizedBox(height: 16),
          ...products.map(
            (product) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppTheme.successColor.withValues(alpha: 0.1),
                child: SvgPicture.asset(
                  AppIcons.shoppingBag,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppTheme.successColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(product['name']),
              subtitle: Text('${product['sales']} Ù…Ø¨ÙŠØ¹Ø§Øª'),
              trailing: Text(
                '${NumberFormat('#,##0').format(product['revenue'])} Ø±.Ø³',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    List items,
    Widget Function(dynamic) itemBuilder,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontTitle,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => itemBuilder(item)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> log) {
    final time = log['time'] as DateTime;
    final timeStr = _formatTimeAgo(time);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (log['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              log['iconPath'] as String,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                log['color'] as Color,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['action'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  log['details'],
                  style: TextStyle(
                    color: AppTheme.slate600,
                    fontSize: AppDimensions.fontLabel,
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: TextStyle(
              color: AppTheme.slate600,
              fontSize: AppDimensions.fontCaption,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return 'Ù…Ù†Ø° ${diff.inMinutes} Ø¯Ù‚ÙŠÙ‚Ø©';
    } else if (diff.inHours < 24) {
      return 'Ù…Ù†Ø° ${diff.inHours} Ø³Ø§Ø¹Ø©';
    } else {
      return 'Ù…Ù†Ø° ${diff.inDays} ÙŠÙˆÙ…';
    }
  }
}
