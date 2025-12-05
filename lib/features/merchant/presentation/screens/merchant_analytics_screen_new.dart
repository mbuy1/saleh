import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// شاشة الإحصائيات المتقدمة للتاجر - متصلة بـ Worker API
class MerchantAnalyticsScreenNew extends StatefulWidget {
  const MerchantAnalyticsScreenNew({super.key});

  @override
  State<MerchantAnalyticsScreenNew> createState() =>
      _MerchantAnalyticsScreenNewState();
}

class _MerchantAnalyticsScreenNewState
    extends State<MerchantAnalyticsScreenNew> {
  bool _isLoading = true;
  String _selectedPeriod = '30';
  Map<String, dynamic>? _analyticsData;
  List<dynamic> _topProducts = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        ApiService.get('/secure/merchant/analytics?period=$_selectedPeriod'),
        ApiService.get('/secure/merchant/analytics/top-products?limit=5'),
      ]);

      final analyticsResult = results[0];
      final topProductsResult = results[1];

      if (analyticsResult['ok'] == true) {
        _analyticsData = analyticsResult['data'];
      } else {
        _error = analyticsResult['error'] ?? 'فشل في تحميل الإحصائيات';
      }

      if (topProductsResult['ok'] == true) {
        _topProducts = topProductsResult['data'] ?? [];
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: Text(
          'الإحصائيات والتحليلات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorState()
          : RefreshIndicator(
              onRefresh: _loadAnalytics,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPeriodSelector(),
                  const SizedBox(height: 16),
                  _buildOverviewCards(),
                  const SizedBox(height: 24),
                  _buildRevenueChart(),
                  const SizedBox(height: 24),
                  _buildTopProductsSection(),
                  const SizedBox(height: 24),
                  _buildRecentOrdersSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: MbuyColors.error),
          const SizedBox(height: 16),
          Text(
            _error ?? 'حدث خطأ',
            style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadAnalytics,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MbuyColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildPeriodButton('7', '7 أيام'),
          _buildPeriodButton('30', '30 يوم'),
          _buildPeriodButton('90', '3 أشهر'),
          _buildPeriodButton('365', 'سنة'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String value, String label) {
    final isSelected = _selectedPeriod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedPeriod = value);
          _loadAnalytics();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? MbuyColors.primaryIndigo : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: isSelected ? Colors.white : MbuyColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    final overview = _analyticsData?['overview'] ?? {};

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          title: 'إجمالي الإيرادات',
          value: '${overview['totalRevenue']?.toStringAsFixed(0) ?? '0'}',
          unit: 'ر.س',
          icon: Icons.attach_money,
          color: MbuyColors.success,
        ),
        _buildStatCard(
          title: 'عدد الطلبات',
          value: '${overview['totalOrders'] ?? 0}',
          unit: 'طلب',
          icon: Icons.shopping_bag,
          color: MbuyColors.primaryIndigo,
        ),
        _buildStatCard(
          title: 'متوسط قيمة الطلب',
          value: '${overview['avgOrderValue']?.toStringAsFixed(0) ?? '0'}',
          unit: 'ر.س',
          icon: Icons.trending_up,
          color: MbuyColors.warning,
        ),
        _buildStatCard(
          title: 'التقييم',
          value: '${overview['avgRating'] ?? '0.0'}',
          unit: '(${overview['totalReviews'] ?? 0})',
          icon: Icons.star,
          color: Colors.amber,
        ),
        _buildStatCard(
          title: 'طلبات مكتملة',
          value: '${overview['completedOrders'] ?? 0}',
          unit: 'طلب',
          icon: Icons.check_circle,
          color: MbuyColors.success,
        ),
        _buildStatCard(
          title: 'طلبات قيد الانتظار',
          value: '${overview['pendingOrders'] ?? 0}',
          unit: 'طلب',
          icon: Icons.hourglass_empty,
          color: MbuyColors.info,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MbuyColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: MbuyColors.textSecondary,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      unit,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    final chartData =
        _analyticsData?['chartData'] as Map<String, dynamic>? ?? {};

    if (chartData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: MbuyColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'لا توجد بيانات للرسم البياني',
            style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
          ),
        ),
      );
    }

    final sortedKeys = chartData.keys.toList()..sort();
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedKeys.length; i++) {
      final revenue = (chartData[sortedKeys[i]]?['revenue'] ?? 0).toDouble();
      spots.add(FlSpot(i.toDouble(), revenue));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MbuyColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإيرادات',
            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: MbuyColors.border, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: MbuyColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots.isNotEmpty ? spots : [FlSpot(0, 0)],
                    isCurved: true,
                    color: MbuyColors.primaryIndigo,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: MbuyColors.primaryIndigo.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MbuyColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المنتجات الأكثر مبيعاً',
            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_topProducts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'لا توجد منتجات',
                  style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
                ),
              ),
            )
          else
            ...List.generate(_topProducts.length, (index) {
              final product = _topProducts[index];
              return _buildProductItem(
                rank: index + 1,
                name: product['name'] ?? '',
                sales: product['sales_count'] ?? 0,
                price: (product['price'] ?? 0).toDouble(),
                imageUrl: product['images']?.isNotEmpty == true
                    ? product['images'][0]
                    : null,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildProductItem({
    required int rank,
    required String name,
    required int sales,
    required double price,
    String? imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? MbuyColors.primaryIndigo.withValues(alpha: 0.1)
                  : MbuyColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  color: rank <= 3
                      ? MbuyColors.primaryIndigo
                      : MbuyColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: MbuyColors.background,
              borderRadius: BorderRadius.circular(8),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Icon(Icons.image, color: MbuyColors.textSecondary)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$sales مبيعات',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: MbuyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${price.toStringAsFixed(0)} ر.س',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: MbuyColors.primaryIndigo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersSection() {
    final recentOrdersData = _analyticsData?['recentOrders'];
    final recentOrders = (recentOrdersData is List) ? recentOrdersData : [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MbuyColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آخر الطلبات',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to orders
                },
                child: Text(
                  'عرض الكل',
                  style: GoogleFonts.cairo(color: MbuyColors.primaryIndigo),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (recentOrders.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'لا توجد طلبات',
                  style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
                ),
              ),
            )
          else
            ...recentOrders.take(5).map((order) => _buildOrderItem(order)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final status = order['status'] ?? 'pending';
    final statusColors = {
      'pending': MbuyColors.warning,
      'processing': MbuyColors.info,
      'shipped': MbuyColors.primaryIndigo,
      'delivered': MbuyColors.success,
      'cancelled': MbuyColors.error,
    };
    final statusLabels = {
      'pending': 'قيد الانتظار',
      'processing': 'جاري التجهيز',
      'shipped': 'تم الشحن',
      'delivered': 'تم التسليم',
      'cancelled': 'ملغي',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MbuyColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_long,
              color: MbuyColors.primaryIndigo,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${order['id']?.toString().substring(0, 8) ?? ''}',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                ),
                Text(
                  order['created_at']?.toString().split('T')[0] ?? '',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: MbuyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${order['total_amount']?.toStringAsFixed(0) ?? '0'} ر.س',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (statusColors[status] ?? MbuyColors.textSecondary)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusLabels[status] ?? status,
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    color: statusColors[status] ?? MbuyColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
