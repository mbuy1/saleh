import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

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
  bool _isLoading = true;
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
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _settings = ReportSettings(
        isEnabled: true,
        dailyEnabled: true,
        dailyTime: '08:00',
        weeklyEnabled: true,
        weeklyDay: 0,
        weeklyTime: '09:00',
        monthlyEnabled: true,
        monthlyDay: 1,
        monthlyTime: '10:00',
        sendEmail: true,
        sendPush: true,
        reportEmail: 'merchant@example.com',
        reportFormat: 'detailed',
        includeCharts: true,
        includeRecommendations: true,
      );

      _reports = [
        GeneratedReport(
          id: '1',
          reportType: 'daily',
          periodStart: DateTime.now().subtract(const Duration(days: 1)),
          periodEnd: DateTime.now().subtract(const Duration(days: 1)),
          title:
              'التقرير اليومي - ${_formatDate(DateTime.now().subtract(const Duration(days: 1)))}',
          totalRevenue: 4580,
          totalOrders: 23,
          totalCustomers: 18,
          avgOrderValue: 199.13,
          revenueChange: 12.5,
          ordersChange: 8.3,
          executiveSummary:
              'أداء جيد! ارتفعت المبيعات بنسبة 12.5% مقارنة باليوم السابق.',
          topProducts: [
            TopProduct(
              productId: '1',
              name: 'قميص أبيض',
              quantity: 8,
              revenue: 1200,
            ),
            TopProduct(
              productId: '2',
              name: 'بنطلون جينز',
              quantity: 5,
              revenue: 950,
            ),
          ],
          isSent: true,
          sentAt: DateTime.now().subtract(const Duration(hours: 2)),
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        GeneratedReport(
          id: '2',
          reportType: 'weekly',
          periodStart: DateTime.now().subtract(const Duration(days: 7)),
          periodEnd: DateTime.now().subtract(const Duration(days: 1)),
          title: 'التقرير الأسبوعي',
          totalRevenue: 32450,
          totalOrders: 156,
          totalCustomers: 89,
          avgOrderValue: 208.01,
          revenueChange: 18.2,
          ordersChange: 15.1,
          executiveSummary: 'أسبوع ممتاز! نمو قوي في المبيعات والعملاء الجدد.',
          topProducts: [
            TopProduct(
              productId: '1',
              name: 'قميص أبيض',
              quantity: 45,
              revenue: 6750,
            ),
            TopProduct(
              productId: '2',
              name: 'بنطلون جينز',
              quantity: 32,
              revenue: 6080,
            ),
            TopProduct(
              productId: '3',
              name: 'حذاء رياضي',
              quantity: 28,
              revenue: 5600,
            ),
          ],
          isSent: true,
          sentAt: DateTime.now().subtract(const Duration(days: 1)),
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        GeneratedReport(
          id: '3',
          reportType: 'monthly',
          periodStart: DateTime(2025, 11, 1),
          periodEnd: DateTime(2025, 11, 30),
          title: 'التقرير الشهري - نوفمبر 2025',
          totalRevenue: 125800,
          totalOrders: 612,
          totalCustomers: 324,
          avgOrderValue: 205.56,
          revenueChange: 22.7,
          ordersChange: 19.4,
          executiveSummary: 'شهر رائع! تحقيق أهداف المبيعات بنسبة 115%.',
          topProducts: [
            TopProduct(
              productId: '1',
              name: 'قميص أبيض',
              quantity: 180,
              revenue: 27000,
            ),
            TopProduct(
              productId: '2',
              name: 'بنطلون جينز',
              quantity: 145,
              revenue: 27550,
            ),
          ],
          isSent: true,
          sentAt: DateTime(2025, 12, 1),
          createdAt: DateTime(2025, 12, 1),
        ),
      ];

      _isLoading = false;
    });
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
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(AppIcons.arrowBack, width: 24, height: 24),
            onPressed: () => context.pop(),
          ),
          title: const Text('التقارير التلقائية'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.add_circled),
              onPressed: _showGenerateReportSheet,
              tooltip: 'إنشاء تقرير',
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'التقارير'),
              Tab(text: 'الإعدادات'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [_buildReportsTab(), _buildSettingsTab()],
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
              onChanged: (v) {
                // TODO: Update settings
              },
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

  void _generateReport(String type) {
    // TODO: Call API to generate report
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري إنشاء التقرير...'),
        backgroundColor: Colors.blue,
      ),
    );
    _loadData();
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
