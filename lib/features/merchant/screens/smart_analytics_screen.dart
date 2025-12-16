import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

// ============================================================================
// Models
// ============================================================================

class DashboardStats {
  final double revenue;
  final int orders;
  final int customers;
  final double avgOrderValue;
  final int pageViews;
  final int visitors;
  final double revenueChange;
  final double ordersChange;
  final double customersChange;

  DashboardStats({
    required this.revenue,
    required this.orders,
    required this.customers,
    required this.avgOrderValue,
    required this.pageViews,
    required this.visitors,
    required this.revenueChange,
    required this.ordersChange,
    required this.customersChange,
  });
}

class SmartInsight {
  final String id;
  final String type;
  final String priority;
  final String title;
  final String? description;
  final String? recommendation;
  final double? metricValue;
  final double? metricChange;
  final bool isRead;
  final DateTime createdAt;

  SmartInsight({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    this.description,
    this.recommendation,
    this.metricValue,
    this.metricChange,
    required this.isRead,
    required this.createdAt,
  });

  IconData get icon {
    switch (type) {
      case 'sales_trend':
        return CupertinoIcons.graph_square;
      case 'product_opportunity':
        return CupertinoIcons.cube_box;
      case 'customer_risk':
        return CupertinoIcons.person_badge_minus;
      case 'inventory_alert':
        return CupertinoIcons.archivebox;
      default:
        return CupertinoIcons.lightbulb;
    }
  }

  Color get priorityColor {
    switch (priority) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class StoreGoal {
  final String id;
  final String goalType;
  final String period;
  final double targetValue;
  final double currentValue;
  final double progress;
  final String status;
  final DateTime startDate;
  final DateTime endDate;

  StoreGoal({
    required this.id,
    required this.goalType,
    required this.period,
    required this.targetValue,
    required this.currentValue,
    required this.progress,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  String get goalTypeText {
    switch (goalType) {
      case 'revenue':
        return 'الإيرادات';
      case 'orders':
        return 'الطلبات';
      case 'customers':
        return 'العملاء';
      case 'conversion':
        return 'التحويل';
      default:
        return goalType;
    }
  }

  IconData get goalIcon {
    switch (goalType) {
      case 'revenue':
        return CupertinoIcons.money_dollar_circle;
      case 'orders':
        return CupertinoIcons.cart;
      case 'customers':
        return CupertinoIcons.person_2;
      case 'conversion':
        return CupertinoIcons.percent;
      default:
        return CupertinoIcons.flag;
    }
  }
}

// ============================================================================
// Main Screen
// ============================================================================

class SmartAnalyticsScreen extends StatefulWidget {
  const SmartAnalyticsScreen({super.key});

  @override
  State<SmartAnalyticsScreen> createState() => _SmartAnalyticsScreenState();
}

class _SmartAnalyticsScreenState extends State<SmartAnalyticsScreen> {
  bool _isLoading = true;
  String _selectedPeriod = '7d';
  DashboardStats? _stats;
  List<SmartInsight> _insights = [];
  List<StoreGoal> _goals = [];
  List<Map<String, dynamic>> _chartData = [];
  Map<String, int> _customerSegments = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _stats = DashboardStats(
        revenue: 45750,
        orders: 156,
        customers: 89,
        avgOrderValue: 293.27,
        pageViews: 12500,
        visitors: 3200,
        revenueChange: 12.5,
        ordersChange: 8.3,
        customersChange: 15.2,
      );

      _chartData = [
        {'day': 'السبت', 'revenue': 5200, 'orders': 18},
        {'day': 'الأحد', 'revenue': 6800, 'orders': 24},
        {'day': 'الإثنين', 'revenue': 7200, 'orders': 28},
        {'day': 'الثلاثاء', 'revenue': 5900, 'orders': 20},
        {'day': 'الأربعاء', 'revenue': 8100, 'orders': 32},
        {'day': 'الخميس', 'revenue': 6300, 'orders': 22},
        {'day': 'الجمعة', 'revenue': 6250, 'orders': 12},
      ];

      _customerSegments = {
        'new': 45,
        'active': 28,
        'loyal': 12,
        'vip': 4,
        'at_risk': 8,
        'churned': 3,
      };

      _insights = [
        SmartInsight(
          id: '1',
          type: 'sales_trend',
          priority: 'high',
          title: 'ارتفاع المبيعات بنسبة 25%',
          description: 'مبيعات هذا الأسبوع أعلى من المعتاد',
          recommendation: 'استمر في الترويج للمنتجات الأكثر مبيعاً',
          metricValue: 25,
          metricChange: 25,
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        SmartInsight(
          id: '2',
          type: 'product_opportunity',
          priority: 'medium',
          title: 'منتج قد ينفد قريباً',
          description: 'المخزون المتبقي من "قميص أبيض" قليل',
          recommendation: 'أعد تزويد المخزون قبل نفاده',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        SmartInsight(
          id: '3',
          type: 'customer_risk',
          priority: 'critical',
          title: '5 عملاء VIP لم يشتروا منذ 30 يوم',
          description: 'عملاء مميزون قد يحتاجون تواصل',
          recommendation: 'أرسل لهم عرض خاص أو كوبون',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      _goals = [
        StoreGoal(
          id: '1',
          goalType: 'revenue',
          period: 'monthly',
          targetValue: 100000,
          currentValue: 67500,
          progress: 67.5,
          status: 'in_progress',
          startDate: DateTime(2025, 12, 1),
          endDate: DateTime(2025, 12, 31),
        ),
        StoreGoal(
          id: '2',
          goalType: 'orders',
          period: 'monthly',
          targetValue: 300,
          currentValue: 189,
          progress: 63,
          status: 'in_progress',
          startDate: DateTime(2025, 12, 1),
          endDate: DateTime(2025, 12, 31),
        ),
      ];

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(AppIcons.arrowBack, width: 24, height: 24),
            onPressed: () => context.pop(),
          ),
          title: const Text('لوحة التحكم الذكية'),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              initialValue: _selectedPeriod,
              onSelected: (value) {
                setState(() => _selectedPeriod = value);
                _loadData();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: '7d', child: Text('آخر 7 أيام')),
                const PopupMenuItem(value: '30d', child: Text('آخر 30 يوم')),
                const PopupMenuItem(value: '90d', child: Text('آخر 90 يوم')),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      _selectedPeriod == '7d'
                          ? '7 أيام'
                          : _selectedPeriod == '30d'
                          ? '30 يوم'
                          : '90 يوم',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    Icon(
                      CupertinoIcons.chevron_down,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  padding: AppDimensions.paddingM,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Cards
                      _buildStatsGrid(),

                      const SizedBox(height: 24),

                      // Revenue Chart
                      _buildChartCard(),

                      const SizedBox(height: 24),

                      // Insights Section
                      _buildInsightsSection(),

                      const SizedBox(height: 24),

                      // Goals Section
                      _buildGoalsSection(),

                      const SizedBox(height: 24),

                      // Customer Segments
                      _buildSegmentsSection(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    if (_stats == null) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'الإيرادات',
                '${_stats!.revenue.toStringAsFixed(0)} ر.س',
                CupertinoIcons.money_dollar_circle,
                Colors.green,
                _stats!.revenueChange,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: _buildStatCard(
                'الطلبات',
                _stats!.orders.toString(),
                CupertinoIcons.cart,
                Colors.blue,
                _stats!.ordersChange,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'العملاء الجدد',
                _stats!.customers.toString(),
                CupertinoIcons.person_add,
                Colors.purple,
                _stats!.customersChange,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: _buildStatCard(
                'متوسط الطلب',
                '${_stats!.avgOrderValue.toStringAsFixed(0)} ر.س',
                CupertinoIcons.tag,
                Colors.orange,
                null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    double? change,
  ) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                if (change != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: change >= 0
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: AppDimensions.borderRadiusM,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          change >= 0
                              ? CupertinoIcons.arrow_up
                              : CupertinoIcons.arrow_down,
                          size: 12,
                          color: change >= 0 ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${change.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: change >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 13, color: theme.hintColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: Padding(
        padding: AppDimensions.paddingL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإيرادات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _buildLegendItem('الإيرادات', theme.colorScheme.primary),
                    const SizedBox(width: AppDimensions.spacing16),
                    _buildLegendItem('الطلبات', Colors.orange),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10000,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${_chartData[groupIndex]['revenue']} ر.س',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < _chartData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _chartData[value.toInt()]['day'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: theme.hintColor,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: _chartData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: (entry.value['revenue'] as num).toDouble(),
                          color: theme.colorScheme.primary,
                          width: 16,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
      ],
    );
  }

  Widget _buildInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'رؤى ذكية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: const Text('عرض الكل')),
          ],
        ),
        const SizedBox(height: AppDimensions.spacing12),
        ..._insights.map((insight) => _buildInsightCard(insight)),
      ],
    );
  }

  Widget _buildInsightCard(SmartInsight insight) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusM),
      child: InkWell(
        onTap: () => _showInsightDetails(insight),
        borderRadius: AppDimensions.borderRadiusM,
        child: Padding(
          padding: AppDimensions.paddingM,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: insight.priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  insight.icon,
                  color: insight.priorityColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (!insight.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: insight.priorityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            insight.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    if (insight.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        insight.description!,
                        style: TextStyle(fontSize: 13, color: theme.hintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_left,
                size: 16,
                color: theme.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الأهداف',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.plus_circle),
              onPressed: _showAddGoalSheet,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacing12),
        ..._goals.map((goal) => _buildGoalCard(goal)),
      ],
    );
  }

  Widget _buildGoalCard(StoreGoal goal) {
    final theme = Theme.of(context);
    final progressColor = goal.progress >= 75
        ? Colors.green
        : goal.progress >= 50
        ? Colors.orange
        : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusM),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(goal.goalIcon, color: theme.colorScheme.primary),
                const SizedBox(width: AppDimensions.spacing8),
                Text(
                  goal.goalTypeText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${goal.progress.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: goal.progress / 100,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(progressColor),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${goal.currentValue.toStringAsFixed(0)} / ${goal.targetValue.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 13, color: theme.hintColor),
                ),
                Text(
                  'متبقي ${goal.endDate.difference(DateTime.now()).inDays} يوم',
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentsSection() {
    final total = _customerSegments.values.fold(0, (a, b) => a + b);

    final segmentInfo = {
      'new': {'label': 'جديد', 'color': Colors.blue},
      'active': {'label': 'نشط', 'color': Colors.green},
      'loyal': {'label': 'مخلص', 'color': Colors.purple},
      'vip': {'label': 'VIP', 'color': Colors.amber},
      'at_risk': {'label': 'معرض للخطر', 'color': Colors.orange},
      'churned': {'label': 'مفقود', 'color': Colors.red},
    };

    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: Padding(
        padding: AppDimensions.paddingL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تصنيف العملاء',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _customerSegments.entries.map((entry) {
                final info = segmentInfo[entry.key]!;
                final percentage = total > 0 ? (entry.value / total * 100) : 0;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: (info['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusXL,
                    border: Border.all(
                      color: (info['color'] as Color).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: info['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${info['label']}: ${entry.value}',
                        style: TextStyle(
                          fontSize: 13,
                          color: info['color'] as Color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${percentage.toStringAsFixed(0)}%)',
                        style: TextStyle(
                          fontSize: 11,
                          color: (info['color'] as Color).withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showInsightDetails(SmartInsight insight) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: AppDimensions.paddingXL,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.hintColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: AppDimensions.paddingS,
                    decoration: BoxDecoration(
                      color: insight.priorityColor.withValues(alpha: 0.1),
                      borderRadius: AppDimensions.borderRadiusM,
                    ),
                    child: Icon(insight.icon, color: insight.priorityColor),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Text(
                      insight.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (insight.description != null) ...[
                const SizedBox(height: AppDimensions.spacing16),
                Text(
                  insight.description!,
                  style: TextStyle(color: theme.hintColor),
                ),
              ],
              if (insight.recommendation != null) ...[
                const SizedBox(height: AppDimensions.spacing16),
                Container(
                  padding: AppDimensions.paddingS,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.lightbulb,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppDimensions.spacing8),
                      Expanded(
                        child: Text(
                          insight.recommendation!,
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Take action
                      },
                      child: const Text('اتخاذ إجراء'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing8),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddGoalSheet() {
    final theme = Theme.of(context);
    String selectedType = 'revenue';
    final targetController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.hintColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'إضافة هدف جديد',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'نوع الهدف',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildGoalTypeChip(
                      'revenue',
                      'الإيرادات',
                      selectedType,
                      (v) => setSheetState(() => selectedType = v),
                    ),
                    _buildGoalTypeChip(
                      'orders',
                      'الطلبات',
                      selectedType,
                      (v) => setSheetState(() => selectedType = v),
                    ),
                    _buildGoalTypeChip(
                      'customers',
                      'العملاء',
                      selectedType,
                      (v) => setSheetState(() => selectedType = v),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'القيمة المستهدفة',
                    suffixText: selectedType == 'revenue' ? 'ر.س' : null,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Create goal via API
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إضافة الهدف بنجاح'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('إضافة الهدف'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalTypeChip(
    String value,
    String label,
    String selected,
    Function(String) onSelect,
  ) {
    final theme = Theme.of(context);
    final isSelected = value == selected;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelect(value),
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
    );
  }
}
