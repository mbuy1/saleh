import 'package:flutter/material.dart';
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
        const SnackBar(content: Text('جاري إعادة حساب التصنيفات...')),
      );

      await _api.post('/secure/segments/analytics/calculate-all', body: {});

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إعادة حساب التصنيفات')));
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('تصنيف العملاء'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recalculateAll,
            tooltip: 'إعادة حساب RFM',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'الشرائح', icon: Icon(Icons.pie_chart)),
            Tab(text: 'الوسوم', icon: Icon(Icons.label)),
            Tab(text: 'التحليلات', icon: Icon(Icons.analytics)),
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
                  const SizedBox(height: 16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
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
                _buildSegmentsTab(),
                _buildTagsTab(),
                _buildAnalyticsTab(),
              ],
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
                  SizedBox(height: 16),
                  Text('لا توجد شرائح عملاء'),
                  SizedBox(height: 8),
                  Text(
                    'أنشئ شريحة لتصنيف عملائك',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withAlpha(25),
                child: Icon(_getIconByName(segment['icon']), color: color),
              ),
              const SizedBox(width: 12),
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
                        const SizedBox(width: 8),
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
                              'تلقائي',
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
                    'عميل',
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
                  SizedBox(height: 16),
                  Text('لا توجد وسوم'),
                  SizedBox(height: 8),
                  Text(
                    'أنشئ وسماً لتمييز عملائك',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
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
            const SizedBox(width: 8),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'إجمالي العملاء',
                    '$total',
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'الأبطال',
                    '${tiers['champion'] ?? 0}',
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'العملاء المخلصين',
                    '${tiers['loyal'] ?? 0}',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'معرضين للخسارة',
                    '${tiers['at_risk'] ?? 0}',
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tier distribution
            const Text(
              'توزيع العملاء حسب التصنيف',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTierDistribution(tiers, total),

            const SizedBox(height: 24),

            // Top customers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'أفضل العملاء',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Show all customers
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
        padding: const EdgeInsets.all(16),
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
      {'key': 'champion', 'label': 'أبطال', 'color': Colors.purple},
      {'key': 'loyal', 'label': 'مخلصين', 'color': Colors.green},
      {'key': 'regular', 'label': 'عاديين', 'color': Colors.blue},
      {'key': 'new', 'label': 'جدد', 'color': Colors.teal},
      {'key': 'at_risk', 'label': 'معرضين للخسارة', 'color': Colors.orange},
      {'key': 'lost', 'label': 'مفقودين', 'color': Colors.red},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                  const SizedBox(width: 8),
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
        title: Text(customer?['full_name'] ?? 'عميل'),
        subtitle: Row(
          children: [
            _buildTierBadge(tier),
            const SizedBox(width: 8),
            Text(
              '$totalOrders طلب',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Text(
          '$totalSpent ريال',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'ما هو تحليل RFM؟',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRfmItem('R - Recency', 'متى آخر مرة اشترى فيها العميل'),
            _buildRfmItem('F - Frequency', 'كم مرة يشتري العميل'),
            _buildRfmItem('M - Monetary', 'كم ينفق العميل'),
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
            '• $title: ',
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
        return 'بطل';
      case 'loyal':
        return 'مخلص';
      case 'new':
        return 'جديد';
      case 'at_risk':
        return 'معرض للخسارة';
      case 'lost':
        return 'مفقود';
      default:
        return 'عادي';
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
          title: const Text('شريحة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الشريحة',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('تصنيف تلقائي'),
                  subtitle: const Text('تعبئة العملاء تلقائياً'),
                  value: isAuto,
                  onChanged: (v) => setDialogState(() => isAuto = v),
                ),
                const SizedBox(height: 12),
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
              child: const Text('إلغاء'),
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
                  ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                }
              },
              child: const Text('إنشاء'),
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
          title: const Text('وسم جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الوسم',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
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
              child: const Text('إلغاء'),
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
                  ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                }
              },
              child: const Text('إنشاء'),
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
        title: const Text('حذف الوسم'),
        content: const Text('هل أنت متأكد من حذف هذا الوسم؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
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
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
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
              padding: const EdgeInsets.all(16),
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
                  const SizedBox(width: 12),
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
                          '${segment['customer_count'] ?? 0} عميل',
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
            Expanded(
              child: Center(
                child: Text(
                  'قائمة العملاء قريباً',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
