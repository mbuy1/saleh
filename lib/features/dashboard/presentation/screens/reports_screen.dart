import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة السجلات والتقارير - تقارير شاملة عن نشاط المتجر
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

    // محاكاة تحميل البيانات (سيتم استبدالها بـ API calls)
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _salesData = {
        'total': 15420.50,
        'thisMonth': 3200.00,
        'lastMonth': 2800.00,
        'growth': 14.3,
        'orders': 45,
        'avgOrderValue': 342.67,
        'topProducts': [
          {'name': 'منتج 1', 'sales': 12, 'revenue': 1200},
          {'name': 'منتج 2', 'sales': 8, 'revenue': 960},
          {'name': 'منتج 3', 'sales': 5, 'revenue': 500},
        ],
        'chartData': [2100, 2400, 1800, 2800, 3200, 2900, 3500],
      };

      _productsData = {
        'total': 28,
        'active': 24,
        'outOfStock': 4,
        'lowStock': 3,
        'topViewed': [
          {'name': 'منتج A', 'views': 450},
          {'name': 'منتج B', 'views': 320},
          {'name': 'منتج C', 'views': 280},
        ],
      };

      _customersData = {
        'total': 156,
        'newThisMonth': 23,
        'returning': 89,
        'avgLifetimeValue': 523.40,
        'topCustomers': [
          {'name': 'عميل 1', 'orders': 12, 'spent': 2400},
          {'name': 'عميل 2', 'orders': 8, 'spent': 1800},
          {'name': 'عميل 3', 'orders': 6, 'spent': 1200},
        ],
      };

      _activityLogs = [
        {
          'action': 'طلب جديد',
          'details': 'طلب #1234 بقيمة 350 ر.س',
          'time': DateTime.now().subtract(const Duration(minutes: 15)),
          'iconPath': AppIcons.cart,
          'color': AppTheme.successColor,
        },
        {
          'action': 'منتج جديد',
          'details': 'تم إضافة "قميص أزرق"',
          'time': DateTime.now().subtract(const Duration(hours: 2)),
          'iconPath': AppIcons.add,
          'color': AppTheme.primaryColor,
        },
        {
          'action': 'تعديل سعر',
          'details': 'تم تعديل سعر "حذاء رياضي"',
          'time': DateTime.now().subtract(const Duration(hours: 5)),
          'iconPath': AppIcons.edit,
          'color': AppTheme.warningColor,
        },
        {
          'action': 'عميل جديد',
          'details': 'تسجيل عميل جديد: أحمد',
          'time': DateTime.now().subtract(const Duration(days: 1)),
          'iconPath': AppIcons.person,
          'color': AppTheme.infoColor,
        },
        {
          'action': 'مخزون منخفض',
          'details': 'تنبيه: "ساعة ذكية" أقل من 5 قطع',
          'time': DateTime.now().subtract(const Duration(days: 1)),
          'iconPath': AppIcons.warning,
          'color': AppTheme.errorColor,
        },
      ];

      _isLoading = false;
    });
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
          'السجلات والتقارير',
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
            tooltip: 'تصدير التقرير',
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
            tooltip: 'تحديث',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.slate600,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'المبيعات'),
            Tab(text: 'المنتجات'),
            Tab(text: 'العملاء'),
            Tab(text: 'السجل'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSalesTab(),
                _buildProductsTab(),
                _buildCustomersTab(),
                _buildActivityTab(),
              ],
            ),
    );
  }

  void _exportReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصدير التقرير'),
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
                  const SnackBar(content: Text('جاري تصدير PDF...')),
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
                  const SnackBar(content: Text('جاري تصدير Excel...')),
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
                  'إجمالي المبيعات',
                  '${NumberFormat('#,##0.00').format(_salesData['total'])} ر.س',
                  AppIcons.attachMoney,
                  AppTheme.successColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'هذا الشهر',
                  '${NumberFormat('#,##0.00').format(_salesData['thisMonth'])} ر.س',
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
                  'عدد الطلبات',
                  '${_salesData['orders']}',
                  AppIcons.shoppingBag,
                  AppTheme.infoColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'متوسط الطلب',
                  '${NumberFormat('#,##0.00').format(_salesData['avgOrderValue'])} ر.س',
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
                  'إجمالي المنتجات',
                  '${_productsData['total']}',
                  AppIcons.inventory,
                  AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'منتجات نشطة',
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
                  'نفد المخزون',
                  '${_productsData['outOfStock']}',
                  AppIcons.removeShoppingCart,
                  AppTheme.errorColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'مخزون منخفض',
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
            'الأكثر مشاهدة',
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
                '${item['views']} مشاهدة',
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
                  'إجمالي العملاء',
                  '${_customersData['total']}',
                  AppIcons.people,
                  AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'عملاء جدد',
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
                  'عملاء عائدون',
                  '${_customersData['returning']}',
                  AppIcons.refresh,
                  AppTheme.infoColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildStatCard(
                  'متوسط الإنفاق',
                  '${NumberFormat('#,##0.00').format(_customersData['avgLifetimeValue'])} ر.س',
                  AppIcons.wallet,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing24),

          // Top Customers
          _buildSection(
            'أفضل العملاء',
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
              subtitle: Text('${item['orders']} طلب'),
              trailing: Text(
                '${NumberFormat('#,##0').format(item['spent'])} ر.س',
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
                  'نمو المبيعات',
                  style: TextStyle(color: AppTheme.slate600, fontSize: 14),
                ),
                Text(
                  '${isPositive ? '+' : ''}${growth.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 24,
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
            'مقارنة بالشهر الماضي',
            style: TextStyle(color: AppTheme.slate600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder() {
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
            'المبيعات الأسبوعية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < 7; i++)
                  _buildChartBar(
                    (_salesData['chartData'] as List?)?[i]?.toDouble() ?? 0,
                    ['س', 'أ', 'ث', 'أ', 'خ', 'ج', 'س'][i],
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
        Text(label, style: TextStyle(fontSize: 10, color: AppTheme.slate600)),
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
          const Text(
            'المنتجات الأكثر مبيعاً',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              subtitle: Text('${product['sales']} مبيعات'),
              trailing: Text(
                '${NumberFormat('#,##0').format(product['revenue'])} ر.س',
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  style: TextStyle(color: AppTheme.slate600, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: TextStyle(color: AppTheme.slate600, fontSize: 11),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else {
      return 'منذ ${diff.inDays} يوم';
    }
  }
}
