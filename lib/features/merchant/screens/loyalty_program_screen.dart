// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class LoyaltyProgramScreen extends StatefulWidget {
  const LoyaltyProgramScreen({super.key});

  @override
  State<LoyaltyProgramScreen> createState() => _LoyaltyProgramScreenState();
}

class _LoyaltyProgramScreenState extends State<LoyaltyProgramScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _error;

  Map<String, dynamic> _program = {};
  List<Map<String, dynamic>> _tiers = [];
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _rewards = [];
  Map<String, dynamic> _stats = {};

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
        _api.get('/secure/loyalty/program'),
        _api.get('/secure/loyalty/tiers'),
        _api.get('/secure/loyalty/members?limit=20'),
        _api.get('/secure/loyalty/rewards'),
        _api.get('/secure/loyalty/stats'),
      ]);

      if (!mounted) return;

      setState(() {
        _program = jsonDecode(results[0].body)['data'] ?? {};
        _tiers = List<Map<String, dynamic>>.from(
          jsonDecode(results[1].body)['data'] ?? [],
        );
        _members = List<Map<String, dynamic>>.from(
          jsonDecode(results[2].body)['data'] ?? [],
        );
        _rewards = List<Map<String, dynamic>>.from(
          jsonDecode(results[3].body)['data'] ?? [],
        );
        _stats = jsonDecode(results[4].body)['data'] ?? {};
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

  Future<void> _toggleProgram(bool enabled) async {
    try {
      await _api.put(
        '/secure/loyalty/program',
        body: {..._program, 'is_active': enabled},
      );

      if (!mounted) return;
      setState(() {
        _program['is_active'] = enabled;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(enabled ? 'تم تفعيل البرنامج' : 'تم إيقاف البرنامج'),
        ),
      );
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
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('برنامج الولاء'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_program.isNotEmpty)
            Switch(
              value: _program['is_active'] ?? false,
              onChanged: _toggleProgram,
              activeThumbColor: Colors.white,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard)),
            Tab(text: 'المستويات', icon: Icon(Icons.military_tech)),
            Tab(text: 'الأعضاء', icon: Icon(Icons.people)),
            Tab(text: 'المكافآت', icon: Icon(Icons.card_giftcard)),
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
                _buildTiersTab(),
                _buildMembersTab(),
                _buildRewardsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    final isActive = _program['is_active'] ?? false;
    final totalMembers = _stats['total_members'] ?? 0;
    final totalIssued = _stats['total_points_issued'] ?? 0;
    final totalRedeemed = _stats['total_points_redeemed'] ?? 0;
    final outstanding = _stats['points_outstanding'] ?? 0;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Program status
            if (!isActive)
              Container(
                padding: AppDimensions.paddingS,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(25),
                  borderRadius: AppDimensions.borderRadiusS,
                  border: Border.all(color: Colors.orange.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: AppDimensions.spacing12),
                    const Expanded(
                      child: Text('برنامج الولاء غير مفعل حالياً'),
                    ),
                    TextButton(
                      onPressed: () => _toggleProgram(true),
                      child: const Text('تفعيل'),
                    ),
                  ],
                ),
              ),

            // Stats cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'الأعضاء',
                    '$totalMembers',
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'النقاط الممنوحة',
                    _formatNumber(totalIssued),
                    Icons.star,
                    Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'النقاط المستبدلة',
                    _formatNumber(totalRedeemed),
                    Icons.redeem,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'النقاط المعلقة',
                    _formatNumber(outstanding),
                    Icons.pending,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Program settings summary
            const Text(
              'إعدادات البرنامج',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Card(
              child: Padding(
                padding: AppDimensions.paddingM,
                child: Column(
                  children: [
                    _buildSettingRow(
                      'نقطة لكل ريال',
                      '${_program['points_per_currency'] ?? 1}',
                    ),
                    _buildSettingRow(
                      'قيمة النقطة',
                      '${_program['points_value'] ?? 0.01} ريال',
                    ),
                    _buildSettingRow(
                      'حد الاستبدال الأدنى',
                      '${_program['min_points_redeem'] ?? 100} نقطة',
                    ),
                    if (_program['points_expiry_days'] != null)
                      _buildSettingRow(
                        'انتهاء الصلاحية',
                        '${_program['points_expiry_days']} يوم',
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _showSettingsDialog,
                          child: const Text('تعديل الإعدادات'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tier distribution
            if ((_stats['tier_distribution'] as List?)?.isNotEmpty ??
                false) ...[
              const Text(
                'توزيع الأعضاء',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppDimensions.spacing12),
              _buildTierDistribution(),
            ],

            const SizedBox(height: 24),

            // How it works
            _buildHowItWorks(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTierDistribution() {
    final tiers =
        (_stats['tier_distribution'] as List?)?.cast<Map<String, dynamic>>() ??
        [];
    final total = tiers.fold<int>(
      0,
      (sum, t) => sum + ((t['count'] ?? 0) as int),
    );

    return Card(
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          children: tiers.map((tier) {
            final count = (tier['count'] ?? 0) as int;
            final percentage = total > 0 ? (count / total) : 0.0;
            final tierData = _tiers.firstWhere(
              (t) => t['id'] == tier['id'],
              orElse: () => {'color': '#6366F1'},
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      tier['name'] ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(
                          _parseColor(tierData['color']),
                        ),
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  SizedBox(
                    width: 40,
                    child: Text('$count', textAlign: TextAlign.end),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTiersTab() {
    return Scaffold(
      body: _tiers.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.military_tech_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  Text('لا توجد مستويات'),
                ],
              ),
            )
          : ListView.builder(
              padding: AppDimensions.paddingM,
              itemCount: _tiers.length,
              itemBuilder: (context, index) {
                final tier = _tiers[index];
                return _buildTierCard(tier);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTierDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTierCard(Map<String, dynamic> tier) {
    final color = _parseColor(tier['color'] ?? '#6366F1');
    final multiplier = (tier['points_multiplier'] ?? 1.0).toDouble();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withAlpha(25),
                  child: Icon(_getIconByName(tier['icon']), color: color),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tier['name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (tier['description'] != null)
                        Text(
                          tier['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditTierDialog(tier),
                ),
              ],
            ),
            const Divider(),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildTierBadge('${tier['min_points'] ?? 0} نقطة', Icons.star),
                _buildTierBadge(
                  '${tier['min_orders'] ?? 0} طلب',
                  Icons.shopping_cart,
                ),
                _buildTierBadge('${multiplier}x مضاعف', Icons.bolt),
                if (tier['free_shipping'] == true)
                  _buildTierBadge('شحن مجاني', Icons.local_shipping),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildMembersTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _members.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: AppDimensions.spacing16),
                  Text('لا يوجد أعضاء'),
                ],
              ),
            )
          : ListView.builder(
              padding: AppDimensions.paddingM,
              itemCount: _members.length,
              itemBuilder: (context, index) {
                return _buildMemberCard(_members[index]);
              },
            ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
    final customer = member['customer'] as Map<String, dynamic>?;
    final tier = member['tier'] as Map<String, dynamic>?;
    final currentPoints = member['current_points'] ?? 0;
    final lifetimePoints = member['lifetime_points'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tier != null
              ? _parseColor(tier['color'] ?? '#6366F1').withAlpha(25)
              : Colors.grey[200],
          child: customer?['avatar_url'] != null
              ? ClipOval(
                  child: Image.network(
                    customer!['avatar_url'],
                    fit: BoxFit.cover,
                  ),
                )
              : Text(
                  (customer?['full_name'] ?? '?')[0].toUpperCase(),
                  style: TextStyle(
                    color: tier != null
                        ? _parseColor(tier['color'] ?? '#6366F1')
                        : Colors.grey,
                  ),
                ),
        ),
        title: Text(customer?['full_name'] ?? 'عميل'),
        subtitle: Row(
          children: [
            if (tier != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _parseColor(tier['color'] ?? '#6366F1').withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tier['name'] ?? '',
                  style: TextStyle(
                    fontSize: 10,
                    color: _parseColor(tier['color'] ?? '#6366F1'),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
            ],
            Text(
              '$lifetimePoints نقطة كلية',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$currentPoints',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text(
              'نقطة',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _showMemberDetails(member),
      ),
    );
  }

  Widget _buildRewardsTab() {
    return Scaffold(
      body: _rewards.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: AppDimensions.spacing16),
                  Text('لا توجد مكافآت'),
                ],
              ),
            )
          : ListView.builder(
              padding: AppDimensions.paddingM,
              itemCount: _rewards.length,
              itemBuilder: (context, index) {
                return _buildRewardCard(_rewards[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRewardDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward) {
    final isActive = reward['is_active'] ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: isActive ? 1.0 : 0.5,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber.withAlpha(25),
            child: Icon(
              _getRewardIcon(reward['reward_type']),
              color: Colors.amber[700],
            ),
          ),
          title: Text(reward['name'] ?? ''),
          subtitle: Text(
            reward['description'] ?? _getRewardTypeLabel(reward['reward_type']),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${reward['points_cost'] ?? 0}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                'نقطة',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          onTap: () => _showRewardDetails(reward),
        ),
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Card(
      color: Colors.blue.withAlpha(25),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.blue[700]),
                const SizedBox(width: AppDimensions.spacing8),
                const Text(
                  'كيف يعمل البرنامج؟',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            _buildStep('1', 'العميل يشتري من متجرك'),
            _buildStep('2', 'يكسب نقاط على كل ريال'),
            _buildStep('3', 'يستبدل النقاط بمكافآت وخصومات'),
            _buildStep('4', 'يرتقي للمستويات الأعلى'),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.blue,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: AppDimensions.spacing8),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  // Helper methods
  String _formatNumber(dynamic number) {
    final n = (number ?? 0);
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}م';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}ك';
    return '$n';
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
      case 'grade':
        return Icons.grade;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'diamond':
        return Icons.diamond;
      case 'star':
        return Icons.star;
      default:
        return Icons.military_tech;
    }
  }

  IconData _getRewardIcon(String? type) {
    switch (type) {
      case 'discount':
        return Icons.local_offer;
      case 'product':
        return Icons.inventory;
      case 'shipping':
        return Icons.local_shipping;
      case 'coupon':
        return Icons.confirmation_number;
      case 'gift':
        return Icons.card_giftcard;
      default:
        return Icons.redeem;
    }
  }

  String _getRewardTypeLabel(String? type) {
    switch (type) {
      case 'discount':
        return 'خصم';
      case 'product':
        return 'منتج مجاني';
      case 'shipping':
        return 'شحن مجاني';
      case 'coupon':
        return 'كوبون';
      case 'gift':
        return 'هدية';
      default:
        return '';
    }
  }

  // Dialogs
  void _showSettingsDialog() {
    int pointsPerSar = _program['points_per_sar'] ?? 1;
    int pointsValue = _program['points_value'] ?? 100;
    bool enrollOnPurchase = _program['auto_enroll'] ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إعدادات البرنامج'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // النقاط لكل ريال
                Row(
                  children: [
                    Expanded(child: Text('نقطة لكل $pointsPerSar ر.س')),
                    Slider(
                      value: pointsPerSar.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '$pointsPerSar ر.س',
                      onChanged: (v) =>
                          setDialogState(() => pointsPerSar = v.toInt()),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacing16),
                // قيمة النقاط
                Row(
                  children: [
                    Expanded(child: Text('كل $pointsValue نقطة = 1 ر.س')),
                    Slider(
                      value: pointsValue.toDouble(),
                      min: 50,
                      max: 500,
                      divisions: 9,
                      label: '$pointsValue',
                      onChanged: (v) =>
                          setDialogState(() => pointsValue = v.toInt()),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacing16),
                SwitchListTile(
                  title: const Text('تسجيل تلقائي عند الشراء'),
                  value: enrollOnPurchase,
                  onChanged: (v) => setDialogState(() => enrollOnPurchase = v),
                  contentPadding: EdgeInsets.zero,
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
                setState(() {
                  _program['points_per_sar'] = pointsPerSar;
                  _program['points_value'] = pointsValue;
                  _program['auto_enroll'] = enrollOnPurchase;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حفظ الإعدادات'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTierDialog() {
    final formKey = GlobalKey<FormState>();
    String tierName = '';
    int minPoints = 0;
    double discount = 5;
    Color tierColor = AppTheme.primaryColor;

    final colors = [
      AppTheme.primaryColor,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إضافة مستوى جديد'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'اسم المستوى',
                      hintText: 'مثال: الفضي',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                    onSaved: (v) => tierName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'الحد الأدنى من النقاط',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    onSaved: (v) => minPoints = int.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  Row(
                    children: [
                      Text('نسبة الخصم: ${discount.toInt()}%'),
                      Expanded(
                        child: Slider(
                          value: discount,
                          min: 0,
                          max: 30,
                          divisions: 6,
                          label: '${discount.toInt()}%',
                          onChanged: (v) => setDialogState(() => discount = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  const Text('لون المستوى'),
                  const SizedBox(height: AppDimensions.spacing8),
                  Wrap(
                    spacing: 8,
                    children: colors.map((color) {
                      return GestureDetector(
                        onTap: () => setDialogState(() => tierColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: tierColor == color
                                ? Border.all(color: Colors.black, width: 3)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
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
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  formKey.currentState?.save();
                  Navigator.pop(context);

                  setState(() {
                    _tiers.add({
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'name': tierName,
                      'min_points': minPoints,
                      'discount_percent': discount,
                      'color': tierColor.toARGB32().toRadixString(16),
                      'members_count': 0,
                    });
                    // ترتيب المستويات حسب النقاط
                    _tiers.sort(
                      (a, b) => (a['min_points'] ?? 0).compareTo(
                        b['min_points'] ?? 0,
                      ),
                    );
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إضافة مستوى "$tierName"'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTierDialog(Map<String, dynamic> tier) {
    final formKey = GlobalKey<FormState>();
    String tierName = tier['name'] ?? '';
    int minPoints = tier['min_points'] ?? 0;
    double discount = (tier['discount_percent'] ?? 5).toDouble();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('تعديل مستوى: $tierName'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'اسم المستوى',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: tierName,
                    validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                    onSaved: (v) => tierName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'الحد الأدنى من النقاط',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: minPoints.toString(),
                    onSaved: (v) => minPoints = int.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  Row(
                    children: [
                      Text('نسبة الخصم: ${discount.toInt()}%'),
                      Expanded(
                        child: Slider(
                          value: discount,
                          min: 0,
                          max: 30,
                          divisions: 6,
                          label: '${discount.toInt()}%',
                          onChanged: (v) => setDialogState(() => discount = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // حذف المستوى
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('حذف المستوى'),
                    content: Text('هل تريد حذف مستوى "$tierName"؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('إلغاء'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _tiers.removeWhere((t) => t['id'] == tier['id']);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم حذف المستوى'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('حذف'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  formKey.currentState?.save();
                  Navigator.pop(context);

                  setState(() {
                    final index = _tiers.indexWhere(
                      (t) => t['id'] == tier['id'],
                    );
                    if (index != -1) {
                      _tiers[index] = {
                        ...tier,
                        'name': tierName,
                        'min_points': minPoints,
                        'discount_percent': discount,
                      };
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تحديث المستوى'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRewardDialog() {
    final formKey = GlobalKey<FormState>();
    String rewardName = '';
    String rewardType = 'discount';
    int pointsCost = 100;
    String rewardValue = '10';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إضافة مكافأة جديدة'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'اسم المكافأة',
                      hintText: 'مثال: خصم 10%',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                    onSaved: (v) => rewardName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: rewardType,
                    decoration: const InputDecoration(
                      labelText: 'نوع المكافأة',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'discount',
                        child: Text('خصم نسبة مئوية'),
                      ),
                      DropdownMenuItem(
                        value: 'fixed',
                        child: Text('خصم مبلغ ثابت'),
                      ),
                      DropdownMenuItem(
                        value: 'free_shipping',
                        child: Text('شحن مجاني'),
                      ),
                      DropdownMenuItem(value: 'gift', child: Text('هدية')),
                      DropdownMenuItem(value: 'coupon', child: Text('كوبون')),
                    ],
                    onChanged: (v) => setDialogState(() => rewardType = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'النقاط المطلوبة',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: '100',
                    onSaved: (v) =>
                        pointsCost = int.tryParse(v ?? '100') ?? 100,
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  if (rewardType == 'discount' || rewardType == 'fixed')
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: rewardType == 'discount'
                            ? 'نسبة الخصم (%)'
                            : 'قيمة الخصم (ر.س)',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: '10',
                      onSaved: (v) => rewardValue = v ?? '10',
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
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  formKey.currentState?.save();
                  Navigator.pop(context);

                  setState(() {
                    _rewards.add({
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'name': rewardName,
                      'type': rewardType,
                      'points_cost': pointsCost,
                      'value': rewardValue,
                      'is_active': true,
                      'redemptions_count': 0,
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إضافة مكافأة "$rewardName"'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemberDetails(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
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
                    (member['name'] ?? 'U')
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
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
                  member['name'] ?? 'عضو',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withAlpha(20),
                    borderRadius: AppDimensions.borderRadiusXL,
                  ),
                  child: Text(
                    member['tier'] ?? 'أساسي',
                    style: const TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildMemberStatRow('النقاط الحالية', '${member['points'] ?? 0}'),
              _buildMemberStatRow(
                'إجمالي النقاط المكتسبة',
                '${member['total_earned'] ?? 0}',
              ),
              _buildMemberStatRow(
                'النقاط المستبدلة',
                '${member['total_redeemed'] ?? 0}',
              ),
              _buildMemberStatRow(
                'عدد الطلبات',
                '${member['orders_count'] ?? 0}',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddPointsDialog(member);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة نقاط'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('إغلاق'),
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

  Widget _buildMemberStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAddPointsDialog(Map<String, dynamic> member) {
    final pointsController = TextEditingController();
    String reason = 'manual';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة نقاط لـ ${member['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pointsController,
              decoration: const InputDecoration(
                labelText: 'عدد النقاط',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            DropdownButtonFormField<String>(
              value: reason,
              decoration: const InputDecoration(
                labelText: 'السبب',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'manual', child: Text('إضافة يدوية')),
                DropdownMenuItem(value: 'bonus', child: Text('مكافأة')),
                DropdownMenuItem(value: 'compensation', child: Text('تعويض')),
                DropdownMenuItem(value: 'promotion', child: Text('عرض ترويجي')),
              ],
              onChanged: (v) => reason = v!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final points = int.tryParse(pointsController.text) ?? 0;
              if (points > 0) {
                Navigator.pop(context);
                setState(() {
                  final index = _members.indexWhere(
                    (m) => m['id'] == member['id'],
                  );
                  if (index != -1) {
                    _members[index]['points'] =
                        (_members[index]['points'] ?? 0) + points;
                    _members[index]['total_earned'] =
                        (_members[index]['total_earned'] ?? 0) + points;
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إضافة $points نقطة'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showRewardDetails(Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reward['name'] ?? 'مكافأة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRewardDetailRow('النوع', _getRewardTypeLabel(reward['type'])),
            _buildRewardDetailRow(
              'النقاط المطلوبة',
              '${reward['points_cost'] ?? 0}',
            ),
            _buildRewardDetailRow(
              'عدد الاستبدالات',
              '${reward['redemptions_count'] ?? 0}',
            ),
            _buildRewardDetailRow(
              'الحالة',
              reward['is_active'] == true ? 'نشط' : 'متوقف',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _rewards.removeWhere((r) => r['id'] == reward['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف المكافأة'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
