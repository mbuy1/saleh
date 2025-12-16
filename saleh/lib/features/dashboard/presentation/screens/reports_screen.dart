import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
          'icon': Icons.shopping_cart,
          'color': AppTheme.successColor,
        },
        {
          'action': 'منتج جديد',
          'details': 'تم إضافة "قميص أزرق"',
          'time': DateTime.now().subtract(const Duration(hours: 2)),
          'icon': Icons.add_box,
          'color': AppTheme.primaryColor,
        },
        {
          'action': 'تعديل سعر',
          'details': 'تم تعديل سعر "حذاء رياضي"',
          'time': DateTime.now().subtract(const Duration(hours: 5)),
          'icon': Icons.edit,
          'color': AppTheme.warningColor,
        },
        {
          'action': 'عميل جديد',
          'details': 'تسجيل عميل جديد: أحمد',
          'time': DateTime.now().subtract(const Duration(days: 1)),
          'icon': Icons.person_add,
          'color': AppTheme.infoColor,
        },
        {
          'action': 'مخزون منخفض',
          'details': 'تنبيه: "ساعة ذكية" أقل من 5 قطع',
          'time': DateTime.now().subtract(const Duration(days: 1)),
          'icon': Icons.warning,
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
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'السجلات والتقارير',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: _exportReport,
            tooltip: 'تصدير التقرير',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
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
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري تصدير PDF...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
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
      padding: const EdgeInsets.all(16),
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
                  Icons.attach_money,
                  AppTheme.successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'هذا الشهر',
                  '${NumberFormat('#,##0.00').format(_salesData['thisMonth'])} ر.س',
                  Icons.trending_up,
                  AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'عدد الطلبات',
                  '${_salesData['orders']}',
                  Icons.shopping_bag,
                  AppTheme.infoColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'متوسط الطلب',
                  '${NumberFormat('#,##0.00').format(_salesData['avgOrderValue'])} ر.س',
                  Icons.analytics,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Growth Indicator
          _buildGrowthCard(),
          const SizedBox(height: 24),

          // Chart Placeholder
          _buildChartPlaceholder(),
          const SizedBox(height: 24),

          // Top Products
          _buildTopProductsSection(),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
                  Icons.inventory_2,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'منتجات نشطة',
                  '${_productsData['active']}',
                  Icons.check_circle,
                  AppTheme.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'نفد المخزون',
                  '${_productsData['outOfStock']}',
                  Icons.remove_shopping_cart,
                  AppTheme.errorColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'مخزون منخفض',
                  '${_productsData['lowStock']}',
                  Icons.warning,
                  AppTheme.warningColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Top Viewed
          _buildSection(
            'الأكثر مشاهدة',
            _productsData['topViewed'] as List? ?? [],
            (item) => ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.visibility,
                  color: AppTheme.primaryColor,
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
      padding: const EdgeInsets.all(16),
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
                  Icons.people,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'عملاء جدد',
                  '${_customersData['newThisMonth']}',
                  Icons.person_add,
                  AppTheme.successColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'عملاء عائدون',
                  '${_customersData['returning']}',
                  Icons.replay,
                  AppTheme.infoColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'متوسط الإنفاق',
                  '${NumberFormat('#,##0.00').format(_customersData['avgLifetimeValue'])} ر.س',
                  Icons.account_balance_wallet,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Top Customers
          _buildSection(
            'أفضل العملاء',
            _customersData['topCustomers'] as List? ?? [],
            (item) => ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.accentColor.withValues(alpha: 0.1),
                child: const Icon(Icons.person, color: AppTheme.accentColor),
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
      padding: const EdgeInsets.all(16),
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
    IconData icon,
    Color color,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: AppTheme.slate600)),
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
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
            size: 32,
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
                child: const Icon(
                  Icons.shopping_bag,
                  color: AppTheme.successColor,
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
            child: Icon(
              log['icon'] as IconData,
              color: log['color'] as Color,
              size: 20,
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
