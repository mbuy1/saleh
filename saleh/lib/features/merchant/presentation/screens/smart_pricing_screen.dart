// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../../core/services/api_service.dart';
import '../../../../core/theme/app_theme.dart';

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
        ).showSnackBar(const SnackBar(content: Text('ØªÙ… Ø­ÙØ¸ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ÙØ´Ù„ Ø­ÙØ¸ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª: $e')));
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
      ).showSnackBar(const SnackBar(content: Text('ØªÙ… ØªØ·Ø¨ÙŠÙ‚ Ø§Ù„Ø³Ø¹Ø± Ø§Ù„Ø¬Ø¯ÙŠØ¯')));
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ÙØ´Ù„ ØªØ·Ø¨ÙŠÙ‚ Ø§Ù„Ø³Ø¹Ø±: $e')));
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
              text: 'Ù†Ø¸Ø±Ø© Ø¹Ø§Ù…Ø©',
              icon: Badge(
                isLabelVisible: _alerts.isNotEmpty,
                label: Text('${_alerts.length}'),
                child: const Icon(Icons.dashboard),
              ),
            ),
            const Tab(text: 'Ø§Ù„Ù‚ÙˆØ§Ø¹Ø¯', icon: Icon(Icons.rule)),
            const Tab(text: 'Ø§Ù„Ø§Ù‚ØªØ±Ø§Ø­Ø§Øª', icon: Icon(Icons.lightbulb)),
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
                    child: const Text('Ø¥Ø¹Ø§Ø¯Ø© Ø§Ù„Ù…Ø­Ø§ÙˆÙ„Ø©'),
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
                    'Ø§Ù„ØªÙ†Ø¨ÙŠÙ‡Ø§Øª',
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
                'Ø§Ù‚ØªØ±Ø§Ø­Ø§Øª ØªØ³Ø¹ÙŠØ±',
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
                  'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„ØªØ³Ø¹ÙŠØ±',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _showSettingsDialog,
                  child: const Text('ØªØ¹Ø¯ÙŠÙ„'),
                ),
              ],
            ),
            const Divider(),
            _buildSettingRow('Ø§Ù„ØªØ³Ø¹ÙŠØ± Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠ', autoPricing),
            _buildSettingRow('Ù…Ø·Ø§Ø¨Ù‚Ø© Ø§Ù„Ù…Ù†Ø§ÙØ³ÙŠÙ†', competitorMatching),
            _buildSettingRow('ØªØ³Ø¹ÙŠØ± Ø§Ù„طلب', demandPricing),
            const Divider(),
            Row(
              children: [
                _buildStatItem(
                  'Ø§Ù„Ù‡Ø§Ù…Ø´ Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠ',
                  '${_settings['default_margin_percent'] ?? 30}%',
                ),
                _buildStatItem(
                  'Ø§Ù„Ø­Ø¯ Ø§Ù„Ø£Ø¯Ù†Ù‰',
                  '${_settings['min_margin_percent'] ?? 10}%',
                ),
                _buildStatItem(
                  'Ø§Ù„Ø­Ø¯ Ø§Ù„Ø£Ù‚ØµÙ‰',
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
                child: const Text('ØªØ·Ø¨ÙŠÙ‚'),
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
                        product?['name'] ?? 'Ù…Ù†ØªØ¬',
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
                        'Ø§Ù„Ø³Ø¹Ø± Ø§Ù„Ø­Ø§Ù„ÙŠ',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        '$currentPrice Ø±ÙŠØ§Ù„',
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
                        'Ø§Ù„Ø³Ø¹Ø± Ø§Ù„Ù…Ù‚ØªØ±Ø­',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        '$suggestedPrice Ø±ÙŠØ§Ù„',
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
                    '${isIncrease ? '+' : ''}${difference.toStringAsFixed(2)} Ø±ÙŠØ§Ù„',
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
                    'Ø«Ù‚Ø©: ${((suggestion['confidence_score'] ?? 0) * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
                const Spacer(),
                TextButton(
                  onPressed: () => _applySuggestion(suggestion),
                  child: const Text('ØªØ·Ø¨ÙŠÙ‚'),
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
                  Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ù‚ÙˆØ§Ø¹Ø¯ ØªØ³Ø¹ÙŠØ±'),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'Ø£Ù†Ø´Ø¦ Ù‚Ø§Ø¹Ø¯Ø© Ø¬Ø¯ÙŠØ¯Ø© Ù„Ø£ØªÙ…ØªØ© Ø§Ù„ØªØ³Ø¹ÙŠØ±',
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
            Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ø§Ù‚ØªØ±Ø§Ø­Ø§Øª Ø­Ø§Ù„ÙŠØ§Ù‹'),
            SizedBox(height: AppDimensions.spacing8),
            Text(
              'Ø³ÙŠØªÙ… ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø£Ø³Ø¹Ø§Ø± ÙˆØªÙ‚Ø¯ÙŠÙ… Ø§Ù‚ØªØ±Ø§Ø­Ø§Øª',
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
            Text('Ù„Ø§ ÙŠÙˆØ¬Ø¯ Ø³Ø¬Ù„ ØªØºÙŠÙŠØ±Ø§Øª'),
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
            title: Text(product?['name'] ?? 'Ù…Ù†ØªØ¬'),
            subtitle: Text(
              '${item['change_type'] ?? 'manual'} - ${item['change_reason'] ?? ''}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$oldPrice â†’ $newPrice',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncrease ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  '${isIncrease ? '+' : ''}${(newPrice - oldPrice).toStringAsFixed(2)} Ø±ÙŠØ§Ù„',
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
                  'Ù†ØµØ§Ø¦Ø­ Ø§Ù„ØªØ³Ø¹ÙŠØ±',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            _buildTipItem('Ø±Ø§Ù‚Ø¨ Ø£Ø³Ø¹Ø§Ø± Ø§Ù„Ù…Ù†Ø§ÙØ³ÙŠÙ† Ø¨Ø§Ù†ØªØ¸Ø§Ù…'),
            _buildTipItem('Ø§Ø­Ø±Øµ Ø¹Ù„Ù‰ Ù‡Ø§Ù…Ø´ Ø±Ø¨Ø­ Ù„Ø§ ÙŠÙ‚Ù„ Ø¹Ù† 15%'),
            _buildTipItem('Ø§Ø³ØªØ®Ø¯Ù… Ø§Ù„Ø£Ø³Ø¹Ø§Ø± Ø§Ù„Ù†ÙØ³ÙŠØ© (99 Ø¨Ø¯Ù„ 100)'),
            _buildTipItem('Ø¬Ø±Ø¨ Ø§Ø®ØªØ¨Ø§Ø± A/B Ù„Ù„Ø£Ø³Ø¹Ø§Ø±'),
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
          const Text('â€¢ ', style: TextStyle(color: Colors.blue)),
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
        return 'Ù†Ø³Ø¨Ø© Ø¥Ø¶Ø§ÙÙŠØ© Ø¹Ù„Ù‰ Ø§Ù„ØªÙƒÙ„ÙØ©';
      case 'margin':
        return 'Ù‡Ø§Ù…Ø´ Ø±Ø¨Ø­ Ø«Ø§Ø¨Øª';
      case 'competitor':
        return 'Ù…Ø·Ø§Ø¨Ù‚Ø© Ø§Ù„Ù…Ù†Ø§ÙØ³ÙŠÙ†';
      case 'demand':
        return 'ØªØ³Ø¹ÙŠØ± Ø­Ø³Ø¨ Ø§Ù„طلب';
      case 'time_based':
        return 'ØªØ³Ø¹ÙŠØ± Ø²Ù…Ù†ÙŠ';
      case 'bulk':
        return 'ØªØ³Ø¹ÙŠØ± Ø§Ù„Ø¬Ù…Ù„Ø©';
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
            title: const Text('Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„ØªØ³Ø¹ÙŠØ±'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Ø§Ù„ØªØ³Ø¹ÙŠØ± Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠ'),
                    subtitle: const Text('تحديث Ø§Ù„Ø£Ø³Ø¹Ø§Ø± ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹'),
                    value: _settings['auto_pricing_enabled'] ?? false,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings['auto_pricing_enabled'] = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Ù…Ø·Ø§Ø¨Ù‚Ø© Ø§Ù„Ù…Ù†Ø§ÙØ³ÙŠÙ†'),
                    subtitle: const Text('ØªØªØ¨Ø¹ Ø£Ø³Ø¹Ø§Ø± Ø§Ù„Ù…Ù†Ø§ÙØ³ÙŠÙ†'),
                    value: _settings['competitor_matching_enabled'] ?? false,
                    onChanged: (value) {
                      setDialogState(() {
                        _settings['competitor_matching_enabled'] = value;
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Ù‡Ø§Ù…Ø´ Ø§Ù„Ø±Ø¨Ø­ Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠ'),
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
                child: const Text('Ø­ÙØ¸'),
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
          title: const Text('Ø¥Ù†Ø´Ø§Ø¡ Ù‚Ø§Ø¹Ø¯Ø© ØªØ³Ø¹ÙŠØ± Ø¬Ø¯ÙŠØ¯Ø©'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ø³Ù… Ø§Ù„Ù‚Ø§Ø¹Ø¯Ø©',
                      hintText: 'Ù…Ø«Ø§Ù„: Ø®ØµÙ… Ù†Ù‡Ø§ÙŠØ© Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
                    onSaved: (v) => ruleName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: ruleType,
                    decoration: const InputDecoration(
                      labelText: 'Ù†ÙˆØ¹ Ø§Ù„Ù‚Ø§Ø¹Ø¯Ø©',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'time_based',
                        child: Text('Ø­Ø³Ø¨ Ø§Ù„ÙˆÙ‚Øª'),
                      ),
                      DropdownMenuItem(
                        value: 'quantity_based',
                        child: Text('Ø­Ø³Ø¨ Ø§Ù„ÙƒÙ…ÙŠØ©'),
                      ),
                      DropdownMenuItem(
                        value: 'customer_based',
                        child: Text('Ø­Ø³Ø¨ Ø§Ù„Ø¹Ù…ÙŠÙ„'),
                      ),
                      DropdownMenuItem(
                        value: 'competitor_based',
                        child: Text('Ø­Ø³Ø¨ Ø§Ù„Ù…Ù†Ø§ÙØ³ÙŠÙ†'),
                      ),
                      DropdownMenuItem(
                        value: 'inventory_based',
                        child: Text('Ø­Ø³Ø¨ Ø§Ù„Ù…Ø®Ø²ÙˆÙ†'),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() => ruleType = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ù„ÙˆØµÙ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onSaved: (v) => description = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Ù†Ø³Ø¨Ø© Ø§Ù„Ø®ØµÙ…: ${discountPercent.toInt()}%'),
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
                    title: const Text('ØªÙØ¹ÙŠÙ„ ÙÙˆØ±ÙŠ'),
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

                  // Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ù‚Ø§Ø¹Ø¯Ø© Ù…Ø­Ù„ÙŠØ§Ù‹
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
                      content: Text('ØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ù‚Ø§Ø¹Ø¯Ø© "$ruleName" بنجاح'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('Ø¥Ù†Ø´Ø§Ø¡'),
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
        title: Text(rule['name'] ?? 'Ù‚Ø§Ø¹Ø¯Ø©'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ø§Ù„Ù†ÙˆØ¹: ${_getRuleTypeLabel(rule['rule_type'])}'),
            if (rule['description'] != null)
              Text('Ø§Ù„ÙˆØµÙ: ${rule['description']}'),
            Text('Ø§Ù„Ø­Ø§Ù„Ø©: ${rule['is_active'] == true ? 'Ù†Ø´Ø·' : 'Ù…ØªÙˆÙ‚Ù'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ø¥ØºÙ„Ø§Ù‚'),
          ),
        ],
      ),
    );
  }
}
