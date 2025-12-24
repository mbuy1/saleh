import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class CustomerSegmentsScreen extends StatefulWidget {
  const CustomerSegmentsScreen({super.key});

  @override
  State<CustomerSegmentsScreen> createState() => _CustomerSegmentsScreenState();
}

class _CustomerSegmentsScreenState extends State<CustomerSegmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _error;

  List<Map<String, dynamic>> _segments = [];
  List<Map<String, dynamic>> _tags = [];
  Map<String, dynamic> _analyticsSummary = {};
  List<Map<String, dynamic>> _topCustomers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        _api.get('/secure/segments/segments'),
        _api.get('/secure/segments/tags'),
        _api.get('/secure/segments/analytics/summary'),
        _api.get('/secure/segments/analytics?limit=10'),
      ]);

      if (!mounted) return;

      setState(() {
        _segments = List<Map<String, dynamic>>.from(
          jsonDecode(results[0].body)['data'] ?? [],
        );
        _tags = List<Map<String, dynamic>>.from(
          jsonDecode(results[1].body)['data'] ?? [],
        );
        _analyticsSummary = jsonDecode(results[2].body)['data'] ?? {};
        _topCustomers = List<Map<String, dynamic>>.from(
          jsonDecode(results[3].body)['data'] ?? [],
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

  Future<void> _recalculateAll() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ø¬Ø§Ø±ÙŠ Ø¥Ø¹Ø§Ø¯Ø© Ø­Ø³Ø§Ø¨ Ø§Ù„ØªØµÙ†ÙŠÙØ§Øª...')),
      );

      await _api.post('/secure/segments/analytics/calculate-all', body: {});

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ØªÙ… Ø¥Ø¹Ø§Ø¯Ø© Ø­Ø³Ø§Ø¨ Ø§Ù„ØªØµÙ†ÙŠÙØ§Øª')));
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ø®Ø·Ø£: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Ø«Ø§Ø¨Øª Ù…Ø¹ TabBar
            Container(
              color: AppTheme.primaryColor,
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
                            'ØªØµÙ†ÙŠÙ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: _recalculateAll,
                          tooltip: 'Ø¥Ø¹Ø§Ø¯Ø© Ø­Ø³Ø§Ø¨ RFM',
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
                      Tab(text: 'Ø§Ù„Ø´Ø±Ø§Ø¦Ø­', icon: Icon(Icons.pie_chart)),
                      Tab(text: 'Ø§Ù„ÙˆØ³ÙˆÙ…', icon: Icon(Icons.label)),
                      Tab(text: 'Ø§Ù„ØªØ­Ù„ÙŠÙ„Ø§Øª', icon: Icon(Icons.analytics)),
                    ],
                  ),
                ],
              ),
            ),
            // Body content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: AppDimensions.spacing16),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
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
                        _buildSegmentsTab(),
                        _buildTagsTab(),
                        _buildAnalyticsTab(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentsTab() {
    return Scaffold(
      body: _segments.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey),
                  SizedBox(height: AppDimensions.spacing16),
                  Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ø´Ø±Ø§Ø¦Ø­ Ø¹Ù…Ù„Ø§Ø¡'),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'Ø£Ù†Ø´Ø¦ Ø´Ø±ÙŠØ­Ø© Ù„ØªØµÙ†ÙŠÙ Ø¹Ù…Ù„Ø§Ø¦Ùƒ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: AppDimensions.paddingM,
                itemCount: _segments.length,
                itemBuilder: (context, index) {
                  final segment = _segments[index];
                  return _buildSegmentCard(segment);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSegmentDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSegmentCard(Map<String, dynamic> segment) {
    final color = _parseColor(segment['color'] ?? '#6366F1');
    final count = segment['customer_count'] ?? 0;
    final isActive = segment['is_active'] ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showSegmentDetails(segment),
        borderRadius: AppDimensions.borderRadiusM,
        child: Padding(
          padding: AppDimensions.paddingM,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withAlpha(25),
                child: Icon(_getIconByName(segment['icon']), color: color),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          segment['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: AppDimensions.spacing8),
                        if (segment['segment_type'] == 'auto')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withAlpha(25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'ØªÙ„Ù‚Ø§Ø¦ÙŠ',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (segment['description'] != null)
                      Text(
                        segment['description'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$count',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                  Text(
                    'Ø¹Ù…ÙŠÙ„',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (!isActive)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.pause_circle, color: Colors.grey, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagsTab() {
    return Scaffold(
      body: _tags.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.label_outline, size: 64, color: Colors.grey),
                  SizedBox(height: AppDimensions.spacing16),
                  Text('Ù„Ø§ ØªÙˆØ¬Ø¯ ÙˆØ³ÙˆÙ…'),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'Ø£Ù†Ø´Ø¦ ÙˆØ³Ù…Ø§Ù‹ Ù„ØªÙ…ÙŠÙŠØ² Ø¹Ù…Ù„Ø§Ø¦Ùƒ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: AppDimensions.paddingM,
                itemCount: _tags.length,
                itemBuilder: (context, index) {
                  final tag = _tags[index];
                  return _buildTagCard(tag);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTagDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTagCard(Map<String, dynamic> tag) {
    final color = _parseColor(tag['color'] ?? '#3B82F6');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(25),
          child: Icon(Icons.label, color: color, size: 20),
        ),
        title: Text(tag['name'] ?? ''),
        subtitle: tag['description'] != null ? Text(tag['description']) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${tag['customer_count'] ?? 0}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _deleteTag(tag['id']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    final tiers = (_analyticsSummary['tiers'] as Map<String, dynamic>?) ?? {};
    final total = _analyticsSummary['total'] ?? 0;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡',
                    '$total',
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildSummaryCard(
                    'Ø§Ù„Ø£Ø¨Ø·Ø§Ù„',
                    '${tiers['champion'] ?? 0}',
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡ Ø§Ù„Ù…Ø®Ù„ØµÙŠÙ†',
                    '${tiers['loyal'] ?? 0}',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildSummaryCard(
                    'Ù…Ø¹Ø±Ø¶ÙŠÙ† Ù„Ù„Ø®Ø³Ø§Ø±Ø©',
                    '${tiers['at_risk'] ?? 0}',
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tier distribution
            const Text(
              'ØªÙˆØ²ÙŠØ¹ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡ Ø­Ø³Ø¨ Ø§Ù„ØªØµÙ†ÙŠÙ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            _buildTierDistribution(tiers, total),

            const SizedBox(height: 24),

            // Top customers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ø£ÙØ¶Ù„ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Show all customers
                  },
                  child: const Text('Ø¹Ø±Ø¶ Ø§Ù„ÙƒÙ„'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing8),
            ..._topCustomers
                .take(5)
                .map((customer) => _buildCustomerCard(customer)),

            const SizedBox(height: 24),

            // RFM explanation
            _buildRfmExplanation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierDistribution(Map<String, dynamic> tiers, int total) {
    final tierData = [
      {'key': 'champion', 'label': 'Ø£Ø¨Ø·Ø§Ù„', 'color': Colors.purple},
      {'key': 'loyal', 'label': 'Ù…Ø®Ù„ØµÙŠÙ†', 'color': Colors.green},
      {'key': 'regular', 'label': 'Ø¹Ø§Ø¯ÙŠÙŠÙ†', 'color': Colors.blue},
      {'key': 'new', 'label': 'Ø¬Ø¯Ø¯', 'color': Colors.teal},
      {'key': 'at_risk', 'label': 'Ù…Ø¹Ø±Ø¶ÙŠÙ† Ù„Ù„Ø®Ø³Ø§Ø±Ø©', 'color': Colors.orange},
      {'key': 'lost', 'label': 'Ù…ÙÙ‚ÙˆØ¯ÙŠÙ†', 'color': Colors.red},
    ];

    return Card(
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          children: tierData.map((tier) {
            final count = (tiers[tier['key']] ?? 0) as int;
            final percentage = total > 0 ? (count / total * 100) : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      tier['label'] as String,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(
                          tier['color'] as Color,
                        ),
                        minHeight: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '$count',
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> analytics) {
    final customer = analytics['customer'] as Map<String, dynamic>?;
    final tier = analytics['customer_tier'] ?? 'regular';
    final totalSpent = (analytics['total_spent'] ?? 0).toDouble();
    final totalOrders = analytics['total_orders'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTierColor(tier).withAlpha(25),
          child: customer?['avatar_url'] != null
              ? ClipOval(
                  child: Image.network(
                    customer!['avatar_url'],
                    fit: BoxFit.cover,
                  ),
                )
              : Text(
                  (customer?['full_name'] ?? '?')[0].toUpperCase(),
                  style: TextStyle(color: _getTierColor(tier)),
                ),
        ),
        title: Text(customer?['full_name'] ?? 'Ø¹Ù…ÙŠÙ„'),
        subtitle: Row(
          children: [
            _buildTierBadge(tier),
            const SizedBox(width: AppDimensions.spacing8),
            Text(
              '$totalOrders Ø·Ù„Ø¨',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Text(
          '$totalSpent Ø±ÙŠØ§Ù„',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTierBadge(String tier) {
    final color = _getTierColor(tier);
    final label = _getTierLabel(tier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRfmExplanation() {
    return Card(
      color: Colors.blue.withAlpha(25),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: AppDimensions.spacing8),
                const Text(
                  'Ù…Ø§ Ù‡Ùˆ ØªØ­Ù„ÙŠÙ„ RFMØŸ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            _buildRfmItem('R - Recency', 'Ù…ØªÙ‰ Ø¢Ø®Ø± Ù…Ø±Ø© Ø§Ø´ØªØ±Ù‰ ÙÙŠÙ‡Ø§ Ø§Ù„Ø¹Ù…ÙŠÙ„'),
            _buildRfmItem('F - Frequency', 'ÙƒÙ… Ù…Ø±Ø© ÙŠØ´ØªØ±ÙŠ Ø§Ù„Ø¹Ù…ÙŠÙ„'),
            _buildRfmItem('M - Monetary', 'ÙƒÙ… ÙŠÙ†ÙÙ‚ Ø§Ù„Ø¹Ù…ÙŠÙ„'),
          ],
        ),
      ),
    );
  }

  Widget _buildRfmItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'â€¢ $title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Expanded(child: Text(desc, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case 'champion':
        return Colors.purple;
      case 'loyal':
        return Colors.green;
      case 'new':
        return Colors.teal;
      case 'at_risk':
        return Colors.orange;
      case 'lost':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _getTierLabel(String tier) {
    switch (tier) {
      case 'champion':
        return 'Ø¨Ø·Ù„';
      case 'loyal':
        return 'Ù…Ø®Ù„Øµ';
      case 'new':
        return 'Ø¬Ø¯ÙŠØ¯';
      case 'at_risk':
        return 'Ù…Ø¹Ø±Ø¶ Ù„Ù„Ø®Ø³Ø§Ø±Ø©';
      case 'lost':
        return 'Ù…ÙÙ‚ÙˆØ¯';
      default:
        return 'Ø¹Ø§Ø¯ÙŠ';
    }
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _getIconByName(String? name) {
    switch (name) {
      case 'star':
        return Icons.star;
      case 'person_add':
        return Icons.person_add;
      case 'trending_up':
        return Icons.trending_up;
      case 'warning':
        return Icons.warning;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'favorite':
        return Icons.favorite;
      case 'shopping_cart':
        return Icons.shopping_cart;
      default:
        return Icons.group;
    }
  }

  void _showAddSegmentDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    String selectedColor = '#6366F1';
    bool isAuto = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Ø´Ø±ÙŠØ­Ø© Ø¬Ø¯ÙŠØ¯Ø©'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ø§Ø³Ù… Ø§Ù„Ø´Ø±ÙŠØ­Ø©',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Ø§Ù„ÙˆØµÙ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                SwitchListTile(
                  title: const Text('ØªØµÙ†ÙŠÙ ØªÙ„Ù‚Ø§Ø¦ÙŠ'),
                  subtitle: const Text('ØªØ¹Ø¨Ø¦Ø© Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡ ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹'),
                  value: isAuto,
                  onChanged: (v) => setDialogState(() => isAuto = v),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                Wrap(
                  spacing: 8,
                  children:
                      [
                            '#6366F1',
                            '#10B981',
                            '#F59E0B',
                            '#EF4444',
                            '#3B82F6',
                            '#8B5CF6',
                          ]
                          .map(
                            (color) => GestureDetector(
                              onTap: () =>
                                  setDialogState(() => selectedColor = color),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _parseColor(color),
                                  shape: BoxShape.circle,
                                  border: selectedColor == color
                                      ? Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ø¥Ù„ØºØ§Ø¡'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                Navigator.pop(context);

                try {
                  await _api.post(
                    '/secure/segments/segments',
                    body: {
                      'name': nameController.text,
                      'description': descController.text,
                      'segment_type': isAuto ? 'auto' : 'custom',
                      'color': selectedColor,
                    },
                  );
                  _loadData();
                } catch (e) {
                  if (!mounted) return;
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Ø®Ø·Ø£: $e')));
                }
              },
              child: const Text('Ø¥Ù†Ø´Ø§Ø¡'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTagDialog() {
    final nameController = TextEditingController();
    String selectedColor = '#3B82F6';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('ÙˆØ³Ù… Ø¬Ø¯ÙŠØ¯'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ø§Ø³Ù… Ø§Ù„ÙˆØ³Ù…',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing12),
              Wrap(
                spacing: 8,
                children:
                    [
                          '#3B82F6',
                          '#10B981',
                          '#F59E0B',
                          '#EF4444',
                          '#8B5CF6',
                          '#EC4899',
                        ]
                        .map(
                          (color) => GestureDetector(
                            onTap: () =>
                                setDialogState(() => selectedColor = color),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _parseColor(color),
                                shape: BoxShape.circle,
                                border: selectedColor == color
                                    ? Border.all(color: Colors.black, width: 2)
                                    : null,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ø¥Ù„ØºØ§Ø¡'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                Navigator.pop(context);

                try {
                  await _api.post(
                    '/secure/segments/tags',
                    body: {'name': nameController.text, 'color': selectedColor},
                  );
                  _loadData();
                } catch (e) {
                  if (!mounted) return;
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Ø®Ø·Ø£: $e')));
                }
              },
              child: const Text('Ø¥Ù†Ø´Ø§Ø¡'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTag(String tagId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ø­Ø°Ù Ø§Ù„ÙˆØ³Ù…'),
        content: const Text('Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† Ø­Ø°Ù Ù‡Ø°Ø§ Ø§Ù„ÙˆØ³Ù…ØŸ'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ø­Ø°Ù'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _api.delete('/secure/segments/tags/$tagId');
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ø®Ø·Ø£: $e')));
    }
  }

  void _showSegmentDetails(Map<String, dynamic> segment) {
    // Navigate to segment details or show bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: AppDimensions.paddingM,
              decoration: BoxDecoration(
                color: _parseColor(segment['color'] ?? '#6366F1').withAlpha(25),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _parseColor(segment['color'] ?? '#6366F1'),
                    child: Icon(
                      _getIconByName(segment['icon']),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          segment['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${segment['customer_count'] ?? 0} Ø¹Ù…ÙŠÙ„',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildCustomersList(segment)),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomersList(Map<String, dynamic> segment) {
    // Ù…Ø­Ø§ÙƒØ§Ø© Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡ Ø¨Ù†Ø§Ø¡Ù‹ Ø¹Ù„Ù‰ Ø§Ù„Ø´Ø±ÙŠØ­Ø©
    final customers = _generateMockCustomers(segment);

    if (customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              'Ù„Ø§ ÙŠÙˆØ¬Ø¯ Ø¹Ù…Ù„Ø§Ø¡ ÙÙŠ Ù‡Ø°Ù‡ Ø§Ù„Ø´Ø±ÙŠØ­Ø©',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withAlpha(30),
              child: Text(
                customer['name'].toString().substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              customer['name'],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer['email']),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildCustomerStat(
                      Icons.shopping_cart,
                      '${customer['orders']} Ø·Ù„Ø¨',
                    ),
                    const SizedBox(width: AppDimensions.spacing16),
                    _buildCustomerStat(
                      Icons.attach_money,
                      '${customer['total_spent']} Ø±.Ø³',
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 20),
                      SizedBox(width: AppDimensions.spacing8),
                      Text('Ø¹Ø±Ø¶ Ø§Ù„ØªÙØ§ØµÙŠÙ„'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'message',
                  child: Row(
                    children: [
                      Icon(Icons.message, size: 20),
                      SizedBox(width: AppDimensions.spacing8),
                      Text('Ø¥Ø±Ø³Ø§Ù„ Ø±Ø³Ø§Ù„Ø©'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'tag',
                  child: Row(
                    children: [
                      Icon(Icons.label, size: 20),
                      SizedBox(width: AppDimensions.spacing8),
                      Text('Ø¥Ø¶Ø§ÙØ© ÙˆØ³Ù…'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _showCustomerDetails(customer);
                    break;
                  case 'message':
                    _sendMessageToCustomer(customer);
                    break;
                  case 'tag':
                    _addTagToCustomer(customer);
                    break;
                }
              },
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildCustomerStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  List<Map<String, dynamic>> _generateMockCustomers(
    Map<String, dynamic> segment,
  ) {
    final segmentType = segment['segment_type'] ?? 'general';
    final count = segment['customer_count'] ?? 5;

    List<Map<String, dynamic>> customers = [];

    for (int i = 0; i < count && i < 20; i++) {
      customers.add({
        'id': 'cust_${i + 1}',
        'name': _getRandomName(i),
        'email': 'customer${i + 1}@example.com',
        'phone': '+966 5${50 + i} ${100 + i * 10} ${1000 + i * 100}',
        'orders': segmentType == 'vip' ? 20 + i * 5 : 3 + i,
        'total_spent': segmentType == 'vip' ? 5000 + i * 1000 : 500 + i * 100,
        'last_order': DateTime.now()
            .subtract(Duration(days: i * 3))
            .toIso8601String(),
        'segment': segment['name'],
        'tags': i % 3 == 0 ? ['Ø¹Ù…ÙŠÙ„ Ù…Ù…ÙŠØ²'] : [],
      });
    }

    return customers;
  }

  String _getRandomName(int index) {
    final names = [
      'Ø£Ø­Ù…Ø¯ Ù…Ø­Ù…Ø¯',
      'Ø³Ø§Ø±Ø© Ø¹Ù„ÙŠ',
      'Ù…Ø­Ù…Ø¯ Ø¹Ø¨Ø¯Ø§Ù„Ù„Ù‡',
      'ÙØ§Ø·Ù…Ø© Ø£Ø­Ù…Ø¯',
      'Ø®Ø§Ù„Ø¯ Ø¥Ø¨Ø±Ø§Ù‡ÙŠÙ…',
      'Ù†ÙˆØ±Ø© Ø³Ø¹Ø¯',
      'Ø¹Ù…Ø± ÙŠÙˆØ³Ù',
      'Ø±ÙŠÙ… Ø®Ø§Ù„Ø¯',
      'Ø³Ù„Ø·Ø§Ù† ÙÙ‡Ø¯',
      'Ù‡Ø¯Ù‰ Ø¹Ø¨Ø¯Ø§Ù„Ø±Ø­Ù…Ù†',
      'ÙÙŠØµÙ„ Ù†Ø§ØµØ±',
      'Ù…Ù†ÙŠØ±Ø© Ø³Ù„ÙŠÙ…Ø§Ù†',
      'Ø±Ø§Ø´Ø¯ Ø¹Ø¨Ø¯Ø§Ù„Ø¹Ø²ÙŠØ²',
      'Ø¹Ø§Ø¦Ø´Ø© Ù…Ø­Ù…Ø¯',
      'Ø¨Ù†Ø¯Ø± ØµØ§Ù„Ø­',
      'Ù„Ø·ÙŠÙØ© Ø£Ø­Ù…Ø¯',
      'Ù…Ø§Ø¬Ø¯ Ø¹Ù„ÙŠ',
      'Ø£Ø³Ù…Ø§Ø¡ Ø¹Ù…Ø±',
      'ØªØ±ÙƒÙŠ ÙÙ‡Ø¯',
      'Ø¯Ø§Ù†Ø© Ø³Ø¹ÙˆØ¯',
    ];
    return names[index % names.length];
  }

  void _showCustomerDetails(Map<String, dynamic> customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: AppDimensions.paddingXL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryColor.withAlpha(30),
                  child: Text(
                    customer['name'].toString().substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Center(
                child: Text(
                  customer['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  customer['email'],
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailCard('Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ø§ØªØµØ§Ù„', [
                _buildDetailRow('Ø§Ù„Ø¨Ø±ÙŠØ¯', customer['email']),
                _buildDetailRow('Ø§Ù„Ù‡Ø§ØªÙ', customer['phone']),
              ]),
              const SizedBox(height: AppDimensions.spacing16),
              _buildDetailCard('Ø¥Ø­ØµØ§Ø¦ÙŠØ§Øª Ø§Ù„Ø´Ø±Ø§Ø¡', [
                _buildDetailRow('Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª', '${customer['orders']}'),
                _buildDetailRow(
                  'Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ù…Ø´ØªØ±ÙŠØ§Øª',
                  '${customer['total_spent']} Ø±.Ø³',
                ),
                _buildDetailRow('Ø§Ù„Ø´Ø±ÙŠØ­Ø©', customer['segment']),
              ]),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _sendMessageToCustomer(customer);
                      },
                      icon: const Icon(Icons.message),
                      label: const Text('Ø±Ø³Ø§Ù„Ø©'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // ÙØªØ­ ØµÙØ­Ø© Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø¹Ù…ÙŠÙ„
                      },
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('Ø§Ù„Ø·Ù„Ø¨Ø§Øª'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Container(
      padding: AppDimensions.paddingM,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _sendMessageToCustomer(Map<String, dynamic> customer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ø¥Ø±Ø³Ø§Ù„ Ø±Ø³Ø§Ù„Ø© Ø¥Ù„Ù‰ ${customer['name']}...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _addTagToCustomer(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ø¥Ø¶Ø§ÙØ© ÙˆØ³Ù…'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tags.map((tag) {
            return ActionChip(
              label: Text(tag['name'] ?? 'ÙˆØ³Ù…'),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'ØªÙ… Ø¥Ø¶Ø§ÙØ© ÙˆØ³Ù… "${tag['name']}" Ù„Ù€ ${customer['name']}',
                    ),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
        ],
      ),
    );
  }
}
