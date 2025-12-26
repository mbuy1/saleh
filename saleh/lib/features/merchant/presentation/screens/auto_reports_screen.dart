import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../../core/services/api_service.dart';

// ignore_for_file: unused_field

// ============================================================================
// Models
// ============================================================================

class GeneratedReport {
  final String id;
  final String reportType;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String title;
  final double totalRevenue;
  final int totalOrders;
  final int totalCustomers;
  final double avgOrderValue;
  final double? revenueChange;
  final double? ordersChange;
  final String? executiveSummary;
  final List<TopProduct> topProducts;
  final bool isSent;
  final DateTime? sentAt;
  final DateTime createdAt;

  GeneratedReport({
    required this.id,
    required this.reportType,
    required this.periodStart,
    required this.periodEnd,
    required this.title,
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalCustomers,
    required this.avgOrderValue,
    this.revenueChange,
    this.ordersChange,
    this.executiveSummary,
    required this.topProducts,
    required this.isSent,
    this.sentAt,
    required this.createdAt,
  });

  factory GeneratedReport.fromJson(Map<String, dynamic> json) {
    return GeneratedReport(
      id: json['id'] ?? '',
      reportType: json['report_type'] ?? 'daily',
      periodStart: json['period_start'] != null
          ? DateTime.parse(json['period_start'])
          : DateTime.now(),
      periodEnd: json['period_end'] != null
          ? DateTime.parse(json['period_end'])
          : DateTime.now(),
      title: json['title'] ?? '',
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      totalCustomers: json['total_customers'] ?? 0,
      avgOrderValue: (json['avg_order_value'] ?? 0).toDouble(),
      revenueChange: json['revenue_change']?.toDouble(),
      ordersChange: json['orders_change']?.toDouble(),
      executiveSummary: json['executive_summary'],
      topProducts: (json['top_products'] as List? ?? [])
          .map((p) => TopProduct.fromJson(p))
          .toList(),
      isSent: json['is_sent'] ?? false,
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  String get reportTypeText {
    switch (reportType) {
      case 'daily':
        return 'يومي';
      case 'weekly':
        return 'أسبوعي';
      case 'monthly':
        return 'شهري';
      default:
        return 'مخصص';
    }
  }

  IconData get reportTypeIcon {
    switch (reportType) {
      case 'daily':
        return CupertinoIcons.sun_max;
      case 'weekly':
        return CupertinoIcons.calendar;
      case 'monthly':
        return CupertinoIcons.calendar_badge_plus;
      default:
        return CupertinoIcons.doc_chart;
    }
  }

  Color get reportTypeColor {
    switch (reportType) {
      case 'daily':
        return Colors.blue;
      case 'weekly':
        return Colors.purple;
      case 'monthly':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }
}

class TopProduct {
  final String productId;
  final String name;
  final int quantity;
  final double revenue;

  TopProduct({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.revenue,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }
}

class ReportSettings {
  final bool isEnabled;
  final bool dailyEnabled;
  final String dailyTime;
  final bool weeklyEnabled;
  final int weeklyDay;
  final String weeklyTime;
  final bool monthlyEnabled;
  final int monthlyDay;
  final String monthlyTime;
  final bool sendEmail;
  final bool sendPush;
  final String? reportEmail;
  final String reportFormat;
  final bool includeCharts;
  final bool includeRecommendations;

  ReportSettings({
    required this.isEnabled,
    required this.dailyEnabled,
    required this.dailyTime,
    required this.weeklyEnabled,
    required this.weeklyDay,
    required this.weeklyTime,
    required this.monthlyEnabled,
    required this.monthlyDay,
    required this.monthlyTime,
    required this.sendEmail,
    required this.sendPush,
    this.reportEmail,
    required this.reportFormat,
    required this.includeCharts,
    required this.includeRecommendations,
  });

  factory ReportSettings.fromJson(Map<String, dynamic> json) {
    return ReportSettings(
      isEnabled: json['is_enabled'] ?? true,
      dailyEnabled: json['daily_report_enabled'] ?? true,
      dailyTime: json['daily_report_time'] ?? '08:00',
      weeklyEnabled: json['weekly_report_enabled'] ?? true,
      weeklyDay: json['weekly_report_day'] ?? 0,
      weeklyTime: json['weekly_report_time'] ?? '09:00',
      monthlyEnabled: json['monthly_report_enabled'] ?? true,
      monthlyDay: json['monthly_report_day'] ?? 1,
      monthlyTime: json['monthly_report_time'] ?? '10:00',
      sendEmail: json['send_email'] ?? true,
      sendPush: json['send_push'] ?? true,
      reportEmail: json['report_email'],
      reportFormat: json['report_format'] ?? 'detailed',
      includeCharts: json['include_charts'] ?? true,
      includeRecommendations: json['include_recommendations'] ?? true,
    );
  }
}

// ============================================================================
// Main Screen
// ============================================================================

class AutoReportsScreen extends StatefulWidget {
  const AutoReportsScreen({super.key});

  @override
  State<AutoReportsScreen> createState() => _AutoReportsScreenState();
}

class _AutoReportsScreenState extends State<AutoReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();
  bool _isLoading = true;
  String? _error;
  List<GeneratedReport> _reports = [];
  ReportSettings? _settings;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // جلب البيانات من API بشكل متوازي
      final results = await Future.wait([
        _api.get('/secure/reports/settings'),
        _api.get('/secure/reports'),
      ]);

      final settingsResponse = json.decode(results[0].body);
      final reportsResponse = json.decode(results[1].body);

      setState(() {
        // تحويل الإعدادات
        if (settingsResponse['ok'] == true &&
            settingsResponse['data'] != null) {
          _settings = ReportSettings.fromJson(settingsResponse['data']);
        }

        // تحويل التقارير
        if (reportsResponse['ok'] == true && reportsResponse['data'] != null) {
          final reportsData = reportsResponse['data'] as List? ?? [];
          _reports = reportsData
              .map((j) => GeneratedReport.fromJson(j))
              .toList();
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ في تحميل البيانات: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<GeneratedReport> get _filteredReports {
    if (_selectedFilter == 'all') return _reports;
    return _reports.where((r) => r.reportType == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header ثابت مع TabBar
              Container(
                color:
                    theme.appBarTheme.backgroundColor ??
                    theme.colorScheme.primary,
                child: Column(
                  children: [
                    // Header Row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                AppIcons.arrowBack,
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'التقارير التلقائية',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.add_circled,
                              color: Colors.white,
                            ),
                            onPressed: _showGenerateReportSheet,
                            tooltip: 'إنشاء تقرير',
                          ),
                        ],
                      ),
                    ),
                    // TabBar
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: const [
                        Tab(text: 'التقارير'),
                        Tab(text: 'الإعدادات'),
                      ],
                    ),
                  ],
                ),
              ),
              // Body content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [_buildReportsTab(), _buildSettingsTab()],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsTab() {
    return Column(
      children: [
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: AppDimensions.paddingM,
          child: Row(
            children: [
              _buildFilterChip('all', 'الكل'),
              const SizedBox(width: AppDimensions.spacing8),
              _buildFilterChip('daily', 'يومي'),
              const SizedBox(width: AppDimensions.spacing8),
              _buildFilterChip('weekly', 'أسبوعي'),
              const SizedBox(width: AppDimensions.spacing8),
              _buildFilterChip('monthly', 'شهري'),
            ],
          ),
        ),

        // Reports List
        Expanded(
          child: _filteredReports.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredReports.length,
                    itemBuilder: (context, index) {
                      return _buildReportCard(_filteredReports[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final theme = Theme.of(context);
    final isSelected = _selectedFilter == value;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = value),
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
    );
  }

  Widget _buildFormatOption(
    String value,
    String title,
    String subtitle,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      borderRadius: AppDimensions.borderRadiusS,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? theme.colorScheme.primary : theme.hintColor,
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(GeneratedReport report) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: InkWell(
        onTap: () => _showReportDetails(report),
        borderRadius: AppDimensions.borderRadiusL,
        child: Padding(
          padding: AppDimensions.paddingM,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: report.reportTypeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      report.reportTypeIcon,
                      color: report.reportTypeColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'تقرير ${report.reportTypeText}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (report.isSent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: AppDimensions.borderRadiusM,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            CupertinoIcons.checkmark_circle,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'مُرسل',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacing16),

              // Stats Row
              Row(
                children: [
                  _buildMiniStat(
                    'الإيرادات',
                    '${report.totalRevenue.toStringAsFixed(0)} ر.س',
                    report.revenueChange,
                  ),
                  const SizedBox(width: AppDimensions.spacing16),
                  _buildMiniStat(
                    'الطلبات',
                    report.totalOrders.toString(),
                    report.ordersChange,
                  ),
                  const SizedBox(width: AppDimensions.spacing16),
                  _buildMiniStat(
                    'العملاء',
                    report.totalCustomers.toString(),
                    null,
                  ),
                ],
              ),

              if (report.executiveSummary != null) ...[
                const SizedBox(height: AppDimensions.spacing12),
                Container(
                  padding: AppDimensions.paddingS,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.lightbulb,
                        size: 16,
                        color: theme.hintColor,
                      ),
                      const SizedBox(width: AppDimensions.spacing8),
                      Expanded(
                        child: Text(
                          report.executiveSummary!,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.hintColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, double? change) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (change != null) ...[
                const SizedBox(width: 4),
                Icon(
                  change >= 0
                      ? CupertinoIcons.arrow_up
                      : CupertinoIcons.arrow_down,
                  size: 10,
                  color: change >= 0 ? Colors.green : Colors.red,
                ),
                Text(
                  '${change.abs().toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: change >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    if (_settings == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Master Toggle
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusL,
            ),
            child: SwitchListTile(
              value: _settings!.isEnabled,
              onChanged: (v) => _updateSettings({'is_enabled': v}),
              title: const Text('تفعيل التقارير التلقائية'),
              subtitle: const Text('إرسال تقارير دورية تلقائياً'),
              secondary: const Icon(CupertinoIcons.doc_chart),
            ),
          ),

          const SizedBox(height: 24),

          // Schedule Section
          Text(
            'جدول التقارير',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),

          _buildScheduleCard(
            'التقرير اليومي',
            'يُرسل كل يوم في الساعة ${_settings!.dailyTime}',
            CupertinoIcons.sun_max,
            Colors.blue,
            _settings!.dailyEnabled,
          ),
          _buildScheduleCard(
            'التقرير الأسبوعي',
            'يُرسل كل أسبوع يوم ${_getDayName(_settings!.weeklyDay)}',
            CupertinoIcons.calendar,
            Colors.purple,
            _settings!.weeklyEnabled,
          ),
          _buildScheduleCard(
            'التقرير الشهري',
            'يُرسل في اليوم ${_settings!.monthlyDay} من كل شهر',
            CupertinoIcons.calendar_badge_plus,
            Colors.orange,
            _settings!.monthlyEnabled,
          ),

          const SizedBox(height: 24),

          // Delivery Section
          Text(
            'قنوات الإرسال',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusL,
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: _settings!.sendEmail,
                  onChanged: (v) {},
                  title: const Text('البريد الإلكتروني'),
                  secondary: const Icon(CupertinoIcons.mail),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _settings!.sendPush,
                  onChanged: (v) {},
                  title: const Text('إشعارات الهاتف'),
                  secondary: const Icon(CupertinoIcons.bell),
                ),
              ],
            ),
          ),

          if (_settings!.sendEmail) ...[
            const SizedBox(height: AppDimensions.spacing16),
            TextField(
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني للتقارير',
                hintText: 'example@email.com',
                prefixIcon: const Icon(CupertinoIcons.mail),
                border: OutlineInputBorder(
                  borderRadius: AppDimensions.borderRadiusM,
                ),
              ),
              controller: TextEditingController(text: _settings!.reportEmail),
            ),
          ],

          const SizedBox(height: 24),

          // Format Section
          Text(
            'تنسيق التقرير',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusL,
            ),
            child: Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                children: [
                  _buildFormatOption(
                    'summary',
                    'ملخص سريع',
                    'أرقام أساسية فقط',
                    _settings!.reportFormat == 'summary',
                  ),
                  const Divider(height: 16),
                  _buildFormatOption(
                    'detailed',
                    'تفصيلي',
                    'تحليل كامل مع رسوم بيانية',
                    _settings!.reportFormat == 'detailed',
                  ),
                  const Divider(height: 16),
                  _buildFormatOption(
                    'executive',
                    'تنفيذي',
                    'ملخص للإدارة مع التوصيات',
                    _settings!.reportFormat == 'executive',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Options
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusL,
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: _settings!.includeCharts,
                  onChanged: (v) {},
                  title: const Text('تضمين الرسوم البيانية'),
                  secondary: const Icon(CupertinoIcons.chart_bar),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _settings!.includeRecommendations,
                  onChanged: (v) {},
                  title: const Text('تضمين التوصيات'),
                  secondary: const Icon(CupertinoIcons.lightbulb),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool enabled,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusM),
      child: SwitchListTile(
        value: enabled,
        onChanged: (v) {},
        title: Text(title),
        subtitle: Text(subtitle),
        secondary: Container(
          padding: AppDimensions.paddingXS,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppDimensions.borderRadiusS,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  String _getDayName(int day) {
    const days = [
      'الأحد',
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
    ];
    return days[day % 7];
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.doc_chart,
            size: 64,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Text(
            'لا توجد تقارير',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            'قم بإنشاء تقرير جديد أو انتظر التقرير التلقائي',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _showGenerateReportSheet,
            icon: const Icon(CupertinoIcons.add),
            label: const Text('إنشاء تقرير'),
          ),
        ],
      ),
    );
  }

  void _showGenerateReportSheet() {
    final theme = Theme.of(context);
    String selectedType = 'daily';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: AppDimensions.paddingXL,
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
                  'إنشاء تقرير جديد',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                _buildReportTypeOption(
                  'daily',
                  'تقرير يومي',
                  'ملخص أداء الأمس',
                  CupertinoIcons.sun_max,
                  Colors.blue,
                  selectedType,
                  (v) => setSheetState(() => selectedType = v),
                ),
                _buildReportTypeOption(
                  'weekly',
                  'تقرير أسبوعي',
                  'ملخص آخر 7 أيام',
                  CupertinoIcons.calendar,
                  Colors.purple,
                  selectedType,
                  (v) => setSheetState(() => selectedType = v),
                ),
                _buildReportTypeOption(
                  'monthly',
                  'تقرير شهري',
                  'ملخص الشهر الماضي',
                  CupertinoIcons.calendar_badge_plus,
                  Colors.orange,
                  selectedType,
                  (v) => setSheetState(() => selectedType = v),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _generateReport(selectedType);
                    },
                    child: const Text('إنشاء التقرير'),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportTypeOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String selected,
    Function(String) onSelect,
  ) {
    final theme = Theme.of(context);
    final isSelected = value == selected;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusM,
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => onSelect(value),
        borderRadius: AppDimensions.borderRadiusM,
        child: Padding(
          padding: AppDimensions.paddingM,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: theme.hintColor),
                    ),
                  ],
                ),
              ),
              Icon(
                selected == value
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected == value
                    ? theme.colorScheme.primary
                    : theme.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateReport(String type) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري إنشاء التقرير...'),
        backgroundColor: Colors.blue,
      ),
    );

    try {
      final res = await _api.post(
        '/secure/reports/generate',
        body: {'report_type': type},
      );
      final response = json.decode(res.body);

      if (mounted) {
        if (response['ok'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء التقرير بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'فشل إنشاء التقرير'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _updateSettings(Map<String, dynamic> updates) async {
    try {
      final res = await _api.put('/secure/reports/settings', body: updates);
      final response = json.decode(res.body);

      if (mounted) {
        if (response['ok'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ الإعدادات'),
              backgroundColor: Colors.green,
            ),
          );
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'فشل حفظ الإعدادات'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showReportDetails(GeneratedReport report) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: AppDimensions.paddingL,
                decoration: BoxDecoration(
                  color: report.reportTypeColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
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
                    const SizedBox(height: AppDimensions.spacing16),
                    Row(
                      children: [
                        Icon(
                          report.reportTypeIcon,
                          color: report.reportTypeColor,
                          size: 32,
                        ),
                        const SizedBox(width: AppDimensions.spacing12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_formatDate(report.periodStart)} - ${_formatDate(report.periodEnd)}',
                                style: TextStyle(color: theme.hintColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: AppDimensions.paddingL,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Grid
                      Row(
                        children: [
                          _buildStatBox(
                            'الإيرادات',
                            '${report.totalRevenue.toStringAsFixed(0)} ر.س',
                            report.revenueChange,
                            Colors.green,
                          ),
                          const SizedBox(width: AppDimensions.spacing12),
                          _buildStatBox(
                            'الطلبات',
                            report.totalOrders.toString(),
                            report.ordersChange,
                            Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                      Row(
                        children: [
                          _buildStatBox(
                            'العملاء',
                            report.totalCustomers.toString(),
                            null,
                            Colors.purple,
                          ),
                          const SizedBox(width: AppDimensions.spacing12),
                          _buildStatBox(
                            'متوسط الطلب',
                            '${report.avgOrderValue.toStringAsFixed(0)} ر.س',
                            null,
                            Colors.orange,
                          ),
                        ],
                      ),

                      if (report.executiveSummary != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'الملخص التنفيذي',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        Container(
                          padding: AppDimensions.paddingM,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: AppDimensions.borderRadiusM,
                          ),
                          child: Text(report.executiveSummary!),
                        ),
                      ],

                      if (report.topProducts.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'المنتجات الأكثر مبيعاً',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing12),
                        ...report.topProducts.map((p) => _buildProductItem(p)),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Actions
              Container(
                padding: AppDimensions.paddingL,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Share report
                        },
                        icon: const Icon(CupertinoIcons.share),
                        label: const Text('مشاركة'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _sendReport(report);
                        },
                        icon: const Icon(CupertinoIcons.paperplane),
                        label: const Text('إرسال'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(
    String label,
    String value,
    double? change,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: AppDimensions.paddingM,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppDimensions.borderRadiusM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: color)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (change != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    change >= 0
                        ? CupertinoIcons.arrow_up
                        : CupertinoIcons.arrow_down,
                    size: 12,
                    color: change >= 0 ? Colors.green : Colors.red,
                  ),
                  Text(
                    '${change.abs().toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: change >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(TopProduct product) {
    final theme = Theme.of(context);

    return Container(
      padding: AppDimensions.paddingS,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusS,
            ),
            child: Icon(
              CupertinoIcons.cube_box,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${product.quantity} قطعة',
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
              ],
            ),
          ),
          Text(
            '${product.revenue.toStringAsFixed(0)} ر.س',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _sendReport(GeneratedReport report) {
    // TODO: Send report via email
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال التقرير بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
