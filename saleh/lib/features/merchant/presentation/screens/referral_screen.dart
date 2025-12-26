import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../../../core/services/api_service.dart';

// ignore_for_file: unused_field

// ============================================================================
// Models
// ============================================================================

class ReferralSettings {
  final String id;
  final String storeId;
  final bool isEnabled;
  final String referrerRewardType;
  final double referrerRewardValue;
  final double? referrerRewardMax;
  final String refereeRewardType;
  final double refereeRewardValue;
  final double refereeMinOrder;
  final bool requireFirstPurchase;
  final double minOrderAmount;
  final int maxReferralsPerUser;
  final int rewardValidityDays;
  final int totalReferrals;
  final int successfulReferrals;
  final double totalRewardsGiven;

  ReferralSettings({
    required this.id,
    required this.storeId,
    required this.isEnabled,
    required this.referrerRewardType,
    required this.referrerRewardValue,
    this.referrerRewardMax,
    required this.refereeRewardType,
    required this.refereeRewardValue,
    required this.refereeMinOrder,
    required this.requireFirstPurchase,
    required this.minOrderAmount,
    required this.maxReferralsPerUser,
    required this.rewardValidityDays,
    required this.totalReferrals,
    required this.successfulReferrals,
    required this.totalRewardsGiven,
  });

  factory ReferralSettings.fromJson(Map<String, dynamic> json) {
    return ReferralSettings(
      id: json['id'] ?? '',
      storeId: json['store_id'] ?? '',
      isEnabled: json['is_enabled'] ?? false,
      referrerRewardType: json['referrer_reward_type'] ?? 'percentage',
      referrerRewardValue: (json['referrer_reward_value'] ?? 10).toDouble(),
      referrerRewardMax: json['referrer_reward_max']?.toDouble(),
      refereeRewardType: json['referee_reward_type'] ?? 'percentage',
      refereeRewardValue: (json['referee_reward_value'] ?? 10).toDouble(),
      refereeMinOrder: (json['referee_min_order'] ?? 50).toDouble(),
      requireFirstPurchase: json['require_first_purchase'] ?? true,
      minOrderAmount: (json['min_order_amount'] ?? 100).toDouble(),
      maxReferralsPerUser: json['max_referrals_per_user'] ?? 50,
      rewardValidityDays: json['reward_validity_days'] ?? 30,
      totalReferrals: json['total_referrals'] ?? 0,
      successfulReferrals: json['successful_referrals'] ?? 0,
      totalRewardsGiven: (json['total_rewards_given'] ?? 0).toDouble(),
    );
  }
}

class ReferralCode {
  final String id;
  final String userId;
  final String code;
  final int totalUses;
  final int successfulUses;
  final double totalEarnings;
  final bool isActive;
  final String? userName;

  ReferralCode({
    required this.id,
    required this.userId,
    required this.code,
    required this.totalUses,
    required this.successfulUses,
    required this.totalEarnings,
    required this.isActive,
    this.userName,
  });

  factory ReferralCode.fromJson(Map<String, dynamic> json) {
    return ReferralCode(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      code: json['code'] ?? '',
      totalUses: json['total_uses'] ?? 0,
      successfulUses: json['successful_uses'] ?? 0,
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      isActive: json['is_active'] ?? true,
      userName: json['user_name'],
    );
  }
}

class Referral {
  final String id;
  final String referrerId;
  final String refereeId;
  final String status;
  final String? orderId;
  final double? orderAmount;
  final String referrerRewardType;
  final double referrerRewardValue;
  final String refereeRewardType;
  final double refereeRewardValue;
  final DateTime? completedAt;
  final DateTime createdAt;

  Referral({
    required this.id,
    required this.referrerId,
    required this.refereeId,
    required this.status,
    this.orderId,
    this.orderAmount,
    required this.referrerRewardType,
    required this.referrerRewardValue,
    required this.refereeRewardType,
    required this.refereeRewardValue,
    this.completedAt,
    required this.createdAt,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'] ?? '',
      referrerId: json['referrer_id'] ?? '',
      refereeId: json['referee_id'] ?? '',
      status: json['status'] ?? 'pending',
      orderId: json['order_id'],
      orderAmount: json['order_amount']?.toDouble(),
      referrerRewardType: json['referrer_reward_type'] ?? 'percentage',
      referrerRewardValue: (json['referrer_reward_value'] ?? 0).toDouble(),
      refereeRewardType: json['referee_reward_type'] ?? 'percentage',
      refereeRewardValue: (json['referee_reward_value'] ?? 0).toDouble(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  String get statusText {
    switch (status) {
      case 'completed':
        return 'مكتملة';
      case 'pending':
        return 'قيد الانتظار';
      case 'expired':
        return 'منتهية';
      case 'cancelled':
        return 'ملغية';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// ============================================================================
// Main Screen
// ============================================================================

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();
  bool _isLoading = true;
  String? _error;
  ReferralSettings? _settings;
  List<ReferralCode> _codes = [];
  List<Referral> _referrals = [];
  Map<String, dynamic> _stats = {};

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
      // جلب البيانات من API بشكل متوازي
      final results = await Future.wait([
        _api.get('/secure/referral/settings'),
        _api.get('/secure/referral/stats'),
        _api.get('/secure/referral/codes'),
        _api.get('/secure/referral'),
      ]);

      final settingsResponse = json.decode(results[0].body);
      final statsResponse = json.decode(results[1].body);
      final codesResponse = json.decode(results[2].body);
      final referralsResponse = json.decode(results[3].body);

      setState(() {
        // تحويل الإعدادات
        if (settingsResponse['ok'] == true &&
            settingsResponse['data'] != null) {
          _settings = ReferralSettings.fromJson(settingsResponse['data']);
        }

        // تحويل الإحصائيات
        if (statsResponse['ok'] == true && statsResponse['data'] != null) {
          _stats = statsResponse['data'] as Map<String, dynamic>;
        }

        // تحويل الأكواد
        if (codesResponse['ok'] == true && codesResponse['data'] != null) {
          final codesData = codesResponse['data'] as List? ?? [];
          _codes = codesData.map((j) => ReferralCode.fromJson(j)).toList();
        }

        // تحويل الإحالات
        if (referralsResponse['ok'] == true &&
            referralsResponse['data'] != null) {
          final referralsData = referralsResponse['data'] as List? ?? [];
          _referrals = referralsData.map((j) => Referral.fromJson(j)).toList();
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
                              'برنامج الإحالة',
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
                              CupertinoIcons.gear,
                              color: Colors.white,
                            ),
                            onPressed: _showSettingsSheet,
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
                        Tab(
                          text: 'الإحصائيات',
                          icon: Icon(CupertinoIcons.chart_bar),
                        ),
                        Tab(text: 'الأكواد', icon: Icon(CupertinoIcons.ticket)),
                        Tab(
                          text: 'الإحالات',
                          icon: Icon(CupertinoIcons.person_2),
                        ),
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
                        children: [
                          _buildStatsTab(),
                          _buildCodesTab(),
                          _buildReferralsTab(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // Stats Tab
  // ============================================================================

  Widget _buildStatsTab() {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Program status card
            Container(
              width: double.infinity,
              padding: AppDimensions.paddingL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _settings?.isEnabled == true
                      ? [Colors.green, Colors.green.shade700]
                      : [Colors.grey, Colors.grey.shade700],
                ),
                borderRadius: AppDimensions.borderRadiusL,
              ),
              child: Row(
                children: [
                  Icon(
                    _settings?.isEnabled == true
                        ? CupertinoIcons.checkmark_shield
                        : CupertinoIcons.xmark_shield,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: AppDimensions.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _settings?.isEnabled == true
                              ? 'البرنامج مفعّل'
                              : 'البرنامج معطّل',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _settings?.isEnabled == true
                              ? 'عملاؤك يمكنهم دعوة أصدقائهم'
                              : 'فعّل البرنامج للبدء',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _settings?.isEnabled ?? false,
                    onChanged: (v) => _toggleProgram(v),
                    activeThumbColor: Colors.white,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'إجمالي الإحالات',
                    _stats['total_referrals']?.toString() ?? '0',
                    CupertinoIcons.person_2,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'إحالات ناجحة',
                    _stats['successful_referrals']?.toString() ?? '0',
                    CupertinoIcons.checkmark_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'نسبة التحويل',
                    '${_stats['conversion_rate'] ?? 0}%',
                    CupertinoIcons.percent,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'المكافآت الموزعة',
                    '${_stats['total_rewards_given'] ?? 0} ر.س',
                    CupertinoIcons.gift,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Rewards info
            Text(
              'إعدادات المكافآت',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),

            _buildRewardInfoCard(
              'مكافأة المُحيل',
              _settings?.referrerRewardType == 'percentage'
                  ? '${_settings?.referrerRewardValue.toInt()}% من قيمة الطلب'
                  : '${_settings?.referrerRewardValue.toInt()} ر.س',
              CupertinoIcons.person,
              theme.colorScheme.primary,
            ),
            _buildRewardInfoCard(
              'مكافأة المُحال',
              _settings?.refereeRewardType == 'percentage'
                  ? '${_settings?.refereeRewardValue.toInt()}% خصم'
                  : '${_settings?.refereeRewardValue.toInt()} ر.س رصيد',
              CupertinoIcons.person_add,
              Colors.teal,
            ),
            _buildRewardInfoCard(
              'الحد الأدنى للطلب',
              '${_settings?.minOrderAmount.toInt()} ر.س',
              CupertinoIcons.cart,
              Colors.orange,
            ),

            const SizedBox(height: 24),

            // Top referrers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'أفضل المُحيلين',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing8),

            ..._codes.take(3).map((code) => _buildTopReferrerCard(code)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppDimensions.paddingS,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppDimensions.borderRadiusM,
      ),
      child: Row(
        children: [
          Container(
            padding: AppDimensions.paddingXS,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusS,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildTopReferrerCard(ReferralCode code) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppDimensions.paddingS,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppDimensions.borderRadiusM,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Text(
              code.userName?[0].toUpperCase() ?? '?',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code.userName ?? 'مستخدم',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${code.successfulUses} إحالة ناجحة',
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
              ],
            ),
          ),
          Text(
            '${code.totalEarnings.toStringAsFixed(0)} ر.س',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Codes Tab
  // ============================================================================

  Widget _buildCodesTab() {
    if (_codes.isEmpty) {
      return _buildEmptyState(
        icon: CupertinoIcons.ticket,
        title: 'لا توجد أكواد إحالة',
        subtitle: 'ستظهر هنا أكواد الإحالة التي ينشئها العملاء',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: AppDimensions.paddingM,
        itemCount: _codes.length,
        itemBuilder: (context, index) => _buildCodeCard(_codes[index]),
      ),
    );
  }

  Widget _buildCodeCard(ReferralCode code) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: code.isActive
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  child: Text(
                    code.userName?[0].toUpperCase() ?? '?',
                    style: TextStyle(
                      color: code.isActive
                          ? theme.colorScheme.primary
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        code.userName ?? 'مستخدم',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              code.code,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacing8),
                          InkWell(
                            onTap: () => _copyCode(code.code),
                            child: Icon(
                              CupertinoIcons.doc_on_clipboard,
                              size: 16,
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: code.isActive,
                  onChanged: (v) => _toggleCode(code),
                  activeThumbColor: theme.colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            const Divider(),
            const SizedBox(height: AppDimensions.spacing8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCodeStat('الاستخدامات', code.totalUses.toString()),
                _buildCodeStat('ناجحة', code.successfulUses.toString()),
                _buildCodeStat(
                  'الأرباح',
                  '${code.totalEarnings.toStringAsFixed(0)} ر.س',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeStat(String label, String value) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: theme.hintColor)),
      ],
    );
  }

  // ============================================================================
  // Referrals Tab
  // ============================================================================

  Widget _buildReferralsTab() {
    if (_referrals.isEmpty) {
      return _buildEmptyState(
        icon: CupertinoIcons.person_2,
        title: 'لا توجد إحالات',
        subtitle: 'ستظهر هنا الإحالات عندما يستخدم العملاء أكواد الإحالة',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: AppDimensions.paddingM,
        itemCount: _referrals.length,
        itemBuilder: (context, index) => _buildReferralCard(_referrals[index]),
      ),
    );
  }

  Widget _buildReferralCard(Referral referral) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  referral.status == 'completed'
                      ? CupertinoIcons.checkmark_circle_fill
                      : CupertinoIcons.clock,
                  color: referral.statusColor,
                ),
                const SizedBox(width: AppDimensions.spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: referral.statusColor.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                  child: Text(
                    referral.statusText,
                    style: TextStyle(
                      fontSize: 12,
                      color: referral.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (referral.orderAmount != null)
                  Text(
                    '${referral.orderAmount!.toStringAsFixed(0)} ر.س',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                      Text(
                        'مكافأة المُحيل',
                        style: TextStyle(fontSize: 12, color: theme.hintColor),
                      ),
                      Text(
                        '${referral.referrerRewardValue.toStringAsFixed(0)} ر.س',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مكافأة المُحال',
                        style: TextStyle(fontSize: 12, color: theme.hintColor),
                      ),
                      Text(
                        '${referral.refereeRewardValue.toStringAsFixed(0)} ر.س',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (referral.orderId != null) ...[
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                'رقم الطلب: ${referral.orderId}',
                style: TextStyle(fontSize: 12, color: theme.hintColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Settings Sheet
  // ============================================================================

  void _showSettingsSheet() {
    if (_settings == null) return;

    final theme = Theme.of(context);
    String referrerType = _settings!.referrerRewardType;
    double referrerValue = _settings!.referrerRewardValue;
    String refereeType = _settings!.refereeRewardType;
    double refereeValue = _settings!.refereeRewardValue;
    double minOrder = _settings!.minOrderAmount;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            padding: AppDimensions.paddingXL,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'إعدادات البرنامج',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.xmark_circle_fill),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Referrer reward
                        const Text(
                          'مكافأة المُحيل',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton(
                                'percentage',
                                referrerType,
                                'نسبة %',
                                () => setSheetState(
                                  () => referrerType = 'percentage',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacing8),
                            Expanded(
                              child: _buildTypeButton(
                                'fixed',
                                referrerType,
                                'مبلغ ثابت',
                                () =>
                                    setSheetState(() => referrerType = 'fixed'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacing12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: referrerValue.toInt().toString(),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: referrerType == 'percentage'
                                      ? 'النسبة'
                                      : 'المبلغ',
                                  suffixText: referrerType == 'percentage'
                                      ? '%'
                                      : 'ر.س',
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (v) =>
                                    referrerValue = double.tryParse(v) ?? 0,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Referee reward
                        const Text(
                          'مكافأة المُحال (العميل الجديد)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton(
                                'percentage',
                                refereeType,
                                'خصم %',
                                () => setSheetState(
                                  () => refereeType = 'percentage',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacing8),
                            Expanded(
                              child: _buildTypeButton(
                                'fixed',
                                refereeType,
                                'رصيد ثابت',
                                () =>
                                    setSheetState(() => refereeType = 'fixed'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacing12),
                        TextFormField(
                          initialValue: refereeValue.toInt().toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: refereeType == 'percentage'
                                ? 'نسبة الخصم'
                                : 'مبلغ الرصيد',
                            suffixText: refereeType == 'percentage'
                                ? '%'
                                : 'ر.س',
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (v) =>
                              refereeValue = double.tryParse(v) ?? 0,
                        ),

                        const SizedBox(height: 24),

                        // Min order
                        const Text(
                          'الحد الأدنى للطلب',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        TextFormField(
                          initialValue: minOrder.toInt().toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'الحد الأدنى',
                            suffixText: 'ر.س',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (v) => minOrder = double.tryParse(v) ?? 0,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _saveSettings(
                        referrerType,
                        referrerValue,
                        refereeType,
                        refereeValue,
                        minOrder,
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('حفظ الإعدادات'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(
    String value,
    String selected,
    String label,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final isSelected = value == selected;

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.borderRadiusM,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? theme.colorScheme.primary : theme.hintColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // Empty State
  // ============================================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppDimensions.paddingXXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: theme.hintColor.withValues(alpha: 0.3)),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              subtitle,
              style: TextStyle(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Actions
  // ============================================================================

  Future<void> _toggleProgram(bool enabled) async {
    // تحديث واجهة المستخدم فوراً
    setState(() {
      _settings = ReferralSettings(
        id: _settings!.id,
        storeId: _settings!.storeId,
        isEnabled: enabled,
        referrerRewardType: _settings!.referrerRewardType,
        referrerRewardValue: _settings!.referrerRewardValue,
        referrerRewardMax: _settings!.referrerRewardMax,
        refereeRewardType: _settings!.refereeRewardType,
        refereeRewardValue: _settings!.refereeRewardValue,
        refereeMinOrder: _settings!.refereeMinOrder,
        requireFirstPurchase: _settings!.requireFirstPurchase,
        minOrderAmount: _settings!.minOrderAmount,
        maxReferralsPerUser: _settings!.maxReferralsPerUser,
        rewardValidityDays: _settings!.rewardValidityDays,
        totalReferrals: _settings!.totalReferrals,
        successfulReferrals: _settings!.successfulReferrals,
        totalRewardsGiven: _settings!.totalRewardsGiven,
      );
    });

    try {
      final res = await _api.patch(
        '/secure/referral/settings',
        body: {'is_enabled': enabled},
      );
      final response = json.decode(res.body);

      if (mounted) {
        if (response['ok'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                enabled ? 'تم تفعيل البرنامج' : 'تم إيقاف البرنامج',
              ),
              backgroundColor: enabled ? Colors.green : Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // إرجاع الحالة السابقة
          _loadData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'فشل تحديث الإعدادات'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _toggleCode(ReferralCode code) async {
    try {
      final res = await _api.patch(
        '/secure/referral/codes/${code.id}',
        body: {'is_active': !code.isActive},
      );
      final response = json.decode(res.body);

      if (mounted) {
        if (response['ok'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                code.isActive ? 'تم إيقاف الكود' : 'تم تفعيل الكود',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'فشل تحديث الكود'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الكود'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _saveSettings(
    String referrerType,
    double referrerValue,
    String refereeType,
    double refereeValue,
    double minOrder,
  ) async {
    try {
      final res = await _api.patch(
        '/secure/referral/settings',
        body: {
          'referrer_reward_type': referrerType,
          'referrer_reward_value': referrerValue,
          'referee_reward_type': refereeType,
          'referee_reward_value': refereeValue,
          'min_order_amount': minOrder,
        },
      );
      final response = json.decode(res.body);

      if (mounted) {
        if (response['ok'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ الإعدادات'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'فشل حفظ الإعدادات'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
