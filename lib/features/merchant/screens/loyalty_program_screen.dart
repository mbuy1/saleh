import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Program status
            if (!isActive)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 12),
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
                const SizedBox(width: 12),
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
            const SizedBox(height: 12),
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
                const SizedBox(width: 12),
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
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 12),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
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
        padding: const EdgeInsets.all(16),
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
                  const SizedBox(width: 8),
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
                  SizedBox(height: 16),
                  Text('لا توجد مستويات'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withAlpha(25),
                  child: Icon(_getIconByName(tier['icon']), color: color),
                ),
                const SizedBox(width: 12),
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
                  SizedBox(height: 16),
                  Text('لا يوجد أعضاء'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
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
              const SizedBox(width: 8),
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
                  SizedBox(height: 16),
                  Text('لا توجد مكافآت'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'كيف يعمل البرنامج؟',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
          const SizedBox(width: 8),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('قريباً: تعديل إعدادات البرنامج')),
    );
  }

  void _showAddTierDialog() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('قريباً: إضافة مستوى جديد')));
  }

  void _showEditTierDialog(Map<String, dynamic> tier) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('قريباً: تعديل المستوى')));
  }

  void _showAddRewardDialog() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('قريباً: إضافة مكافأة جديدة')));
  }

  void _showMemberDetails(Map<String, dynamic> member) {
    // Show member details bottom sheet
  }

  void _showRewardDetails(Map<String, dynamic> reward) {
    // Show reward details
  }
}
