// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class SmartPricingScreen extends StatefulWidget {
  const SmartPricingScreen({super.key});

  @override
  State<SmartPricingScreen> createState() => _SmartPricingScreenState();
}

class _SmartPricingScreenState extends State<SmartPricingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _error;

  Map<String, dynamic> _settings = {};
  List<Map<String, dynamic>> _rules = [];
  List<Map<String, dynamic>> _alerts = [];
  List<Map<String, dynamic>> _suggestions = [];
  List<Map<String, dynamic>> _history = [];

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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _api.get('/secure/pricing/settings'),
        _api.get('/secure/pricing/rules'),
        _api.get('/secure/pricing/alerts'),
        _api.get('/secure/pricing/suggestions'),
        _api.get('/secure/pricing/history?limit=30'),
      ]);

      if (!mounted) return;

      setState(() {
        _settings = jsonDecode(results[0].body)['data'] ?? {};
        _rules = List<Map<String, dynamic>>.from(
          jsonDecode(results[1].body)['data'] ?? [],
        );
        _alerts = List<Map<String, dynamic>>.from(
          jsonDecode(results[2].body)['data'] ?? [],
        );
        _suggestions = List<Map<String, dynamic>>.from(
          jsonDecode(results[3].body)['data'] ?? [],
        );
        _history = List<Map<String, dynamic>>.from(
          jsonDecode(results[4].body)['data'] ?? [],
        );
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateSettings(Map<String, dynamic> newSettings) async {
    try {
      final response = await _api.put(
        '/secure/pricing/settings',
        body: newSettings,
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      if (data['ok'] == true) {
        setState(() => _settings = data['data']);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل حفظ الإعدادات: $e')));
    }
  }

  Future<void> _applySuggestion(Map<String, dynamic> suggestion) async {
    try {
      await _api.post(
        '/secure/pricing/suggestions/${suggestion['id']}/apply',
        body: {},
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم تطبيق السعر الجديد')));
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تطبيق السعر: $e')));
    }
  }

  Future<void> _dismissAlert(String alertId) async {
    try {
      await _api.patch(
        '/secure/pricing/alerts/$alertId',
        body: {'status': 'dismissed'},
      );
      _loadData();
    } catch (e) {
      // Ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('التسعير الذكي'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: [
            Tab(
              text: 'نظرة عامة',
              icon: Badge(
                isLabelVisible: _alerts.isNotEmpty,
                label: Text('${_alerts.length}'),
                child: const Icon(Icons.dashboard),
              ),
            ),
            const Tab(text: 'القواعد', icon: Icon(Icons.rule)),
            const Tab(text: 'الاقتراحات', icon: Icon(Icons.lightbulb)),
            const Tab(text: 'السجل', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: AppDimensions.spacing16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: AppDimensions.spacing16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildRulesTab(),
                _buildSuggestionsTab(),
                _buildHistoryTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Settings summary card
            _buildSettingsCard(),

            const SizedBox(height: 24),

            // Alerts
            if (_alerts.isNotEmpty) ...[
              Row(
                children: [
                  const Text(
                    'التنبيهات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: AppDimensions.borderRadiusM,
                    ),
                    child: Text(
                      '${_alerts.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing12),
              ..._alerts.take(5).map((alert) => _buildAlertCard(alert)),
            ],

            const SizedBox(height: 24),

            // Quick suggestions
            if (_suggestions.isNotEmpty) ...[
              const Text(
                'اقتراحات تسعير',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppDimensions.spacing12),
              ..._suggestions.take(3).map((s) => _buildSuggestionCard(s)),
            ],

            const SizedBox(height: 24),

            // Tips
            _buildTipsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    final autoPricing = _settings['auto_pricing_enabled'] ?? false;
    final competitorMatching =
        _settings['competitor_matching_enabled'] ?? false;
    final demandPricing = _settings['demand_pricing_enabled'] ?? false;

    return Card(
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: AppTheme.primaryColor),
                const SizedBox(width: AppDimensions.spacing8),
                const Text(
                  'إعدادات التسعير',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _showSettingsDialog,
                  child: const Text('تعديل'),
                ),
              ],
            ),
            const Divider(),
            _buildSettingRow('التسعير التلقائي', autoPricing),
            _buildSettingRow('مطابقة المنافسين', competitorMatching),
            _buildSettingRow('تسعير الطلب', demandPricing),
            const Divider(),
            Row(
              children: [
                _buildStatItem(
                  'الهامش الافتراضي',
                  '${_settings['default_margin_percent'] ?? 30}%',
                ),
                _buildStatItem(
                  'الحد الأدنى',
                  '${_settings['min_margin_percent'] ?? 10}%',
                ),
                _buildStatItem(
                  'الحد الأقصى',
                  '${_settings['max_margin_percent'] ?? 100}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String label, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: enabled ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: AppDimensions.spacing8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final severity = alert['severity'] ?? 'medium';
    final color = severity == 'critical'
        ? Colors.red
        : severity == 'high'
        ? Colors.orange
        : Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(25),
          child: Icon(
            _getAlertIcon(alert['alert_type']),
            color: color,
            size: 20,
          ),
        ),
        title: Text(alert['title'] ?? ''),
        subtitle: Text(
          alert['message'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (alert['suggested_price'] != null)
              TextButton(
                onPressed: () {
                  // Apply suggested price
                },
                child: const Text('تطبيق'),
              ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => _dismissAlert(alert['id']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    final product = suggestion['product'] as Map<String, dynamic>?;
    final currentPrice = (suggestion['current_price'] ?? 0).toDouble();
    final suggestedPrice = (suggestion['suggested_price'] ?? 0).toDouble();
    final difference = suggestedPrice - currentPrice;
    final isIncrease = difference > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: AppDimensions.paddingS,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (product?['image_url'] != null)
                  ClipRRect(
                    borderRadius: AppDimensions.borderRadiusS,
                    child: Image.network(
                      product!['image_url'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: AppDimensions.borderRadiusS,
                    ),
                    child: const Icon(Icons.inventory),
                  ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?['name'] ?? 'منتج',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        suggestion['reasoning'] ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'السعر الحالي',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        '$currentPrice ريال',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: isIncrease ? Colors.green : Colors.red,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'السعر المقترح',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        '$suggestedPrice ريال',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncrease ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isIncrease
                        ? Colors.green.withAlpha(25)
                        : Colors.red.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${isIncrease ? '+' : ''}${difference.toStringAsFixed(2)} ريال',
                    style: TextStyle(
                      fontSize: 12,
                      color: isIncrease ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (suggestion['confidence_score'] != null) ...[
                  const SizedBox(width: AppDimensions.spacing8),
                  Text(
                    'ثقة: ${((suggestion['confidence_score'] ?? 0) * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
                const Spacer(),
                TextButton(
                  onPressed: () => _applySuggestion(suggestion),
                  child: const Text('تطبيق'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesTab() {
    return Scaffold(
      body: _rules.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rule, size: 64, color: Colors.grey),
                  SizedBox(height: AppDimensions.spacing16),
                  Text('لا توجد قواعد تسعير'),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'أنشئ قاعدة جديدة لأتمتة التسعير',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: AppDimensions.paddingM,
              itemCount: _rules.length,
              itemBuilder: (context, index) {
                final rule = _rules[index];
                return _buildRuleCard(rule);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRuleDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRuleCard(Map<String, dynamic> rule) {
    final isActive = rule['is_active'] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? Colors.green.withAlpha(25)
              : Colors.grey.withAlpha(25),
          child: Icon(
            _getRuleIcon(rule['rule_type']),
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(rule['name'] ?? ''),
        subtitle: Text(
          rule['description'] ?? _getRuleTypeLabel(rule['rule_type']),
          maxLines: 1,
        ),
        trailing: Switch(
          value: isActive,
          onChanged: (value) async {
            await _api.patch(
              '/secure/pricing/rules/${rule['id']}',
              body: {'is_active': value},
            );
            _loadData();
          },
        ),
        onTap: () => _showRuleDetails(rule),
      ),
    );
  }

  Widget _buildSuggestionsTab() {
    if (_suggestions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey),
            SizedBox(height: AppDimensions.spacing16),
            Text('لا توجد اقتراحات حالياً'),
            SizedBox(height: AppDimensions.spacing8),
            Text(
              'سيتم تحليل الأسعار وتقديم اقتراحات',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        return _buildSuggestionCard(_suggestions[index]);
      },
    );
  }

  Widget _buildHistoryTab() {
    if (_history.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: AppDimensions.spacing16),
            Text('لا يوجد سجل تغييرات'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        final product = item['product'] as Map<String, dynamic>?;
        final oldPrice = (item['old_price'] ?? 0).toDouble();
        final newPrice = (item['new_price'] ?? 0).toDouble();
        final isIncrease = newPrice > oldPrice;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isIncrease
                  ? Colors.green.withAlpha(25)
                  : Colors.red.withAlpha(25),
              child: Icon(
                isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                color: isIncrease ? Colors.green : Colors.red,
              ),
            ),
            title: Text(product?['name'] ?? 'منتج'),
            subtitle: Text(
              '${item['change_type'] ?? 'manual'} - ${item['change_reason'] ?? ''}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$oldPrice → $newPrice',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncrease ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  '${isIncrease ? '+' : ''}${(newPrice - oldPrice).toStringAsFixed(2)} ريال',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipsCard() {
    return Card(
      color: Colors.blue.withAlpha(25),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber[700]),
                const SizedBox(width: AppDimensions.spacing8),
                const Text(
                  'نصائح التسعير',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            _buildTipItem('راقب أسعار المنافسين بانتظام'),
            _buildTipItem('احرص على هامش ربح لا يقل عن 15%'),
            _buildTipItem('استخدم الأسعار النفسية (99 بدل 100)'),
            _buildTipItem('جرب اختبار A/B للأسعار'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.blue)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  IconData _getAlertIcon(String? type) {
    switch (type) {
      case 'competitor_lower':
        return Icons.trending_down;
      case 'margin_low':
        return Icons.warning;
      case 'demand_high':
        return Icons.trending_up;
      case 'suggested_change':
        return Icons.lightbulb;
      default:
        return Icons.notifications;
    }
  }

  IconData _getRuleIcon(String? type) {
    switch (type) {
      case 'markup':
        return Icons.add_chart;
      case 'margin':
        return Icons.percent;
      case 'competitor':
        return Icons.people;
      case 'demand':
        return Icons.trending_up;
      case 'time_based':
        return Icons.schedule;
      case 'bulk':
        return Icons.inventory;
      default:
        return Icons.rule;
    }
  }

  String _getRuleTypeLabel(String? type) {
    switch (type) {
      case 'markup':
        return 'نسبة إضافية على التكلفة';
      case 'margin':
        return 'هامش ربح ثابت';
      case 'competitor':
        return 'مطابقة المنافسين';
      case 'demand':
        return 'تسعير حسب الطلب';
      case 'time_based':
        return 'تسعير زمني';
      case 'bulk':
        return 'تسعير الجملة';
      default:
        return '';
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('إعدادات التسعير'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('التسعير التلقائي'),
                    subtitle: const Text('تحديث الأسعار تلقائياً'),
                    value: _settings['auto_pricing_enabled'] ?? false,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings['auto_pricing_enabled'] = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('مطابقة المنافسين'),
                    subtitle: const Text('تتبع أسعار المنافسين'),
                    value: _settings['competitor_matching_enabled'] ?? false,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings['competitor_matching_enabled'] = value;
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('هامش الربح الافتراضي'),
                    trailing: DropdownButton<int>(
                      value: (_settings['default_margin_percent'] ?? 30)
                          .toInt(),
                      items: [10, 15, 20, 25, 30, 40, 50]
                          .map(
                            (v) =>
                                DropdownMenuItem(value: v, child: Text('$v%')),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _settings['default_margin_percent'] = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateSettings(_settings);
                },
                child: const Text('حفظ'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddRuleDialog() {
    final formKey = GlobalKey<FormState>();
    String ruleName = '';
    String ruleType = 'time_based';
    String description = '';
    double discountPercent = 10;
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إنشاء قاعدة تسعير جديدة'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'اسم القاعدة',
                      hintText: 'مثال: خصم نهاية الأسبوع',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                    onSaved: (v) => ruleName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: ruleType,
                    decoration: const InputDecoration(
                      labelText: 'نوع القاعدة',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'time_based',
                        child: Text('حسب الوقت'),
                      ),
                      DropdownMenuItem(
                        value: 'quantity_based',
                        child: Text('حسب الكمية'),
                      ),
                      DropdownMenuItem(
                        value: 'customer_based',
                        child: Text('حسب العميل'),
                      ),
                      DropdownMenuItem(
                        value: 'competitor_based',
                        child: Text('حسب المنافسين'),
                      ),
                      DropdownMenuItem(
                        value: 'inventory_based',
                        child: Text('حسب المخزون'),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() => ruleType = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'الوصف (اختياري)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onSaved: (v) => description = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: Text('نسبة الخصم: ${discountPercent.toInt()}%'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Slider(
                          value: discountPercent,
                          min: 5,
                          max: 50,
                          divisions: 9,
                          label: '${discountPercent.toInt()}%',
                          onChanged: (v) =>
                              setDialogState(() => discountPercent = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  SwitchListTile(
                    title: const Text('تفعيل فوري'),
                    value: isActive,
                    onChanged: (v) => setDialogState(() => isActive = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  formKey.currentState?.save();
                  Navigator.pop(context);

                  // إضافة القاعدة محلياً
                  setState(() {
                    _rules.add({
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'name': ruleName,
                      'rule_type': ruleType,
                      'description': description,
                      'discount_percent': discountPercent,
                      'is_active': isActive,
                      'created_at': DateTime.now().toIso8601String(),
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إنشاء قاعدة "$ruleName" بنجاح'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRuleDetails(Map<String, dynamic> rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(rule['name'] ?? 'قاعدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('النوع: ${_getRuleTypeLabel(rule['rule_type'])}'),
            if (rule['description'] != null)
              Text('الوصف: ${rule['description']}'),
            Text('الحالة: ${rule['is_active'] == true ? 'نشط' : 'متوقف'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
