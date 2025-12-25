import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../payments/data/payment_repository.dart';

/// Ø´Ø§Ø´Ø© Ù†Ù‚Ø§Ø· Ø§Ù„ØªØ§Ø¬Ø± - Ù†Ø¸Ø§Ù… Ø§Ù„Ù…ÙƒØ§ÙØ¢Øª ÙˆØ§Ù„Ù†Ù‚Ø§Ø·
class PointsScreen extends ConsumerStatefulWidget {
  const PointsScreen({super.key});

  @override
  ConsumerState<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends ConsumerState<PointsScreen> {
  int _currentPoints = 0;
  int _lifetimePoints = 0;
  int _redeemedPoints = 0;
  bool _isLoading = true;
  List<PointTransaction> _transactions = [];
  List<PointReward> _availableRewards = [];

  @override
  void initState() {
    super.initState();
    _loadPointsData();
  }

  Future<void> _loadPointsData() async {
    setState(() => _isLoading = true);

    // Ù…Ø­Ø§ÙƒØ§Ø© ØªØ­Ù…ÙŠÙ„ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª (Ø³ÙŠØªÙ… Ø§Ø³ØªØ¨Ø¯Ø§Ù„Ù‡Ø§ Ø¨Ù€ API calls)
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _currentPoints = 1250;
      _lifetimePoints = 3500;
      _redeemedPoints = 2250;

      _transactions = [
        PointTransaction(
          id: '1',
          type: PointTransactionType.earned,
          amount: 50,
          description: 'Ø¨ÙŠØ¹ Ù…Ù†ØªØ¬ - Ø·Ù„Ø¨ #1234',
          date: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        PointTransaction(
          id: '2',
          type: PointTransactionType.earned,
          amount: 100,
          description: 'Ø¥ÙƒÙ…Ø§Ù„ Ø§Ù„ØªØ­Ø¯ÙŠ Ø§Ù„ÙŠÙˆÙ…ÙŠ',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        PointTransaction(
          id: '3',
          type: PointTransactionType.redeemed,
          amount: 500,
          description: 'Ø§Ø³ØªØ¨Ø¯Ø§Ù„ - Ø®ØµÙ… 10% Ø¹Ù„Ù‰ Ø§Ù„Ø¨Ø§Ù‚Ø©',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        PointTransaction(
          id: '4',
          type: PointTransactionType.bonus,
          amount: 200,
          description: 'Ù…ÙƒØ§ÙØ£Ø© ØªØ³Ø¬ÙŠÙ„ Ù…ØªØ¬Ø± Ø¬Ø¯ÙŠØ¯',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        PointTransaction(
          id: '5',
          type: PointTransactionType.earned,
          amount: 30,
          description: 'Ø¥Ø¶Ø§ÙØ© Ù…Ù†ØªØ¬ Ø¬Ø¯ÙŠØ¯',
          date: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ];

      _availableRewards = [
        PointReward(
          id: '1',
          title: 'Ø®ØµÙ… 5%',
          description: 'Ø®ØµÙ… Ø¹Ù„Ù‰ Ø§Ù„Ø¨Ø§Ù‚Ø© Ø§Ù„ØªØ§Ù„ÙŠØ©',
          pointsCost: 500,
          iconPath: AppIcons.discount,
          color: Colors.green,
        ),
        PointReward(
          id: '2',
          title: 'Ø®ØµÙ… 10%',
          description: 'Ø®ØµÙ… Ø¹Ù„Ù‰ Ø§Ù„Ø¨Ø§Ù‚Ø© Ø§Ù„ØªØ§Ù„ÙŠØ©',
          pointsCost: 900,
          iconPath: AppIcons.discount,
          color: Colors.blue,
        ),
        PointReward(
          id: '3',
          title: '5 ØµÙˆØ± AI Ù…Ø¬Ø§Ù†ÙŠØ©',
          description: 'ØµÙˆØ± Ø¥Ø¶Ø§ÙÙŠØ© Ù„Ù‡Ø°Ø§ Ø§Ù„Ø´Ù‡Ø±',
          pointsCost: 300,
          iconPath: AppIcons.image,
          color: Colors.purple,
        ),
        PointReward(
          id: '4',
          title: 'ÙÙŠØ¯ÙŠÙˆ AI Ù…Ø¬Ø§Ù†ÙŠ',
          description: 'ÙÙŠØ¯ÙŠÙˆ ÙˆØ§Ø­Ø¯ Ø¥Ø¶Ø§ÙÙŠ',
          pointsCost: 600,
          iconPath: AppIcons.videocam,
          color: Colors.orange,
        ),
        PointReward(
          id: '5',
          title: 'Ø¯Ø¹Ù… Ø£ÙˆÙ„ÙˆÙŠØ©',
          description: 'Ø£Ø³Ø¨ÙˆØ¹ Ù…Ù† Ø§Ù„Ø¯Ø¹Ù… Ø§Ù„Ù…Ù…ÙŠØ²',
          pointsCost: 1000,
          iconPath: AppIcons.supportAgent,
          color: Colors.red,
        ),
      ];

      _isLoading = false;
    });
  }

  Future<void> _redeemReward(PointReward reward) async {
    if (_currentPoints < reward.pointsCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ø±ØµÙŠØ¯ Ø§Ù„Ù†Ù‚Ø§Ø· ØºÙŠØ± ÙƒØ§ÙÙ'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ø§Ø³ØªØ¨Ø¯Ø§Ù„ ${reward.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              reward.iconPath,
              width: AppDimensions.iconHero,
              height: AppDimensions.iconHero,
              colorFilter: ColorFilter.mode(reward.color, BlendMode.srcIn),
            ),
            const SizedBox(height: 16),
            Text('Ø³ÙŠØªÙ… Ø®ØµÙ… ${reward.pointsCost} Ù†Ù‚Ø·Ø© Ù…Ù† Ø±ØµÙŠØ¯Ùƒ'),
            const SizedBox(height: 8),
            Text(
              'Ø§Ù„Ø±ØµÙŠØ¯ Ø¨Ø¹Ø¯ Ø§Ù„Ø§Ø³ØªØ¨Ø¯Ø§Ù„: ${_currentPoints - reward.pointsCost} Ù†Ù‚Ø·Ø©',
              style: TextStyle(color: AppTheme.slate600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('ØªØ£ÙƒÙŠØ¯ Ø§Ù„Ø§Ø³ØªØ¨Ø¯Ø§Ù„'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _currentPoints -= reward.pointsCost;
        _redeemedPoints += reward.pointsCost;
        _transactions.insert(
          0,
          PointTransaction(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: PointTransactionType.redeemed,
            amount: reward.pointsCost,
            description: 'Ø§Ø³ØªØ¨Ø¯Ø§Ù„ - ${reward.title}',
            date: DateTime.now(),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ØªÙ… Ø§Ø³ØªØ¨Ø¯Ø§Ù„ ${reward.title} Ø¨Ù†Ø¬Ø§Ø­!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Ø«Ø§Ø¨Øª ÙÙŠ Ø§Ù„Ø£Ø¹Ù„Ù‰
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildHeader(context),
            ),
            const SizedBox(height: 16),
            // Ø§Ù„Ù…Ø­ØªÙˆÙ‰ Ø§Ù„Ù‚Ø§Ø¨Ù„ Ù„Ù„ØªÙ…Ø±ÙŠØ±
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadPointsData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ø±ØµÙŠØ¯ Ø§Ù„Ù†Ù‚Ø§Ø· Ø§Ù„Ø±Ø¦ÙŠØ³ÙŠ
                            _buildPointsCard(),
                            const SizedBox(height: 16),
                            // Ø¥Ø­ØµØ§Ø¦ÙŠØ§Øª Ø³Ø±ÙŠØ¹Ø©
                            _buildStatsRow(),
                            const SizedBox(height: 24),
                            // Ø§Ù„Ù…ÙƒØ§ÙØ¢Øª Ø§Ù„Ù…ØªØ§Ø­Ø©
                            _buildRewardsSection(),
                            const SizedBox(height: 24),
                            // Ø³Ø¬Ù„ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª
                            _buildTransactionsSection(),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusS,
            ),
            child: SvgPicture.asset(
              AppIcons.arrowBack,
              width: AppDimensions.iconS,
              height: AppDimensions.iconS,
              colorFilter: const ColorFilter.mode(
                AppTheme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Text(
            'Ù†Ù‚Ø§Ø·ÙŠ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: _showHelpDialog,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusS,
            ),
            child: SvgPicture.asset(
              AppIcons.help,
              width: AppDimensions.iconS,
              height: AppDimensions.iconS,
              colorFilter: const ColorFilter.mode(
                AppTheme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPointsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ø±ØµÙŠØ¯ Ø§Ù„Ù†Ù‚Ø§Ø·',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: AppDimensions.fontTitle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppIcons.star,
                      width: AppDimensions.iconXS,
                      height: AppDimensions.iconXS,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'VIP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_currentPoints',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppDimensions.fontDisplay1 + 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  ' Ù†Ù‚Ø·Ø©',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AppDimensions.fontHeadline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Ø²Ø± Ø´Ø±Ø§Ø¡ Ù†Ù‚Ø§Ø·
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showBuyPointsSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: SvgPicture.asset(
                AppIcons.addCircle,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  Colors.orange,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(
                'Ø´Ø±Ø§Ø¡ Ù†Ù‚Ø§Ø·',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.fontTitle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Ø´Ø±ÙŠØ· Ø§Ù„ØªÙ‚Ø¯Ù… Ù„Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„ØªØ§Ù„ÙŠ
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø°Ù‡Ø¨ÙŠ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: AppDimensions.fontLabel,
                    ),
                  ),
                  Text(
                    '${((_currentPoints / 2000) * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppDimensions.fontLabel,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _currentPoints / 2000,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Text(
                '${2000 - _currentPoints} Ù†Ù‚Ø·Ø© Ù„Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„ØªØ§Ù„ÙŠ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: AppDimensions.fontCaption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBuyPointsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BuyPointsSheet(
        onPurchase: (package) {
          Navigator.pop(context);
          _showPaymentDialog(package);
        },
      ),
    );
  }

  void _showPaymentDialog(PointsPackage package) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            SvgPicture.asset(
              AppIcons.creditCard,
              width: AppDimensions.iconM,
              height: AppDimensions.iconM,
              colorFilter: const ColorFilter.mode(
                AppTheme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text('ØªØ£ÙƒÙŠØ¯ Ø§Ù„Ø´Ø±Ø§Ø¡'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.star,
                    width: AppDimensions.iconXL,
                    height: AppDimensions.iconXL,
                    colorFilter: const ColorFilter.mode(
                      Colors.orange,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${package.points} Ù†Ù‚Ø·Ø©',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimensions.fontHeadline,
                        ),
                      ),
                      if (package.bonus > 0)
                        Text(
                          '+ ${package.bonus} Ù†Ù‚Ø·Ø© Ù‡Ø¯ÙŠØ©',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: AppDimensions.fontLabel,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${package.price} Ø±.Ø³',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontDisplay3,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ø³ÙŠØªÙ… Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ù†Ù‚Ø§Ø· ÙÙˆØ±Ø§Ù‹ Ø¥Ù„Ù‰ Ø­Ø³Ø§Ø¨Ùƒ Ø¨Ø¹Ø¯ Ø¥ØªÙ…Ø§Ù… Ø§Ù„Ø¯ÙØ¹.',
              style: TextStyle(
                fontSize: AppDimensions.fontBody2,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          ElevatedButton(
            onPressed: () => _processPurchase(context, package),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Ø§Ù„Ø¯ÙØ¹ Ø§Ù„Ø¢Ù†'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ù…ÙƒØªØ³Ø¨',
            '$_lifetimePoints',
            AppIcons.trendingUp,
            AppTheme.successColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'ØªÙ… Ø§Ø³ØªØ¨Ø¯Ø§Ù„Ù‡',
            '$_redeemedPoints',
            AppIcons.gift,
            AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    String iconPath,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: AppDimensions.iconS,
              height: AppDimensions.iconS,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: AppDimensions.fontHeadline,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppDimensions.fontCaption,
                  color: AppTheme.slate600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ø§Ù„Ù…ÙƒØ§ÙØ¢Øª Ø§Ù„Ù…ØªØ§Ø­Ø©',
              style: TextStyle(
                fontSize: AppDimensions.fontHeadline,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Ø¹Ø±Ø¶ Ø¬Ù…ÙŠØ¹ Ø§Ù„Ù…ÙƒØ§ÙØ¢Øª
              },
              child: const Text('Ø¹Ø±Ø¶ Ø§Ù„ÙƒÙ„'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // ØªÙ… Ø¥ØµÙ„Ø§Ø­ Ø§Ù„Ù…Ù‚Ø§Ø³ - Ø§Ø³ØªØ®Ø¯Ø§Ù… GridView Ø¨Ø¯Ù„Ø§Ù‹ Ù…Ù† ListView Ø§Ù„Ø£ÙÙ‚ÙŠ
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65, // ØªÙ… ØªØ¹Ø¯ÙŠÙ„ Ø§Ù„Ù†Ø³Ø¨Ø© Ù„ØªÙ†Ø§Ø³Ø¨ Ø§Ù„Ù…Ø­ØªÙˆÙ‰
          ),
          itemCount: _availableRewards.length > 4
              ? 4
              : _availableRewards.length,
          itemBuilder: (context, index) {
            final reward = _availableRewards[index];
            return _buildRewardCard(reward);
          },
        ),
      ],
    );
  }

  Widget _buildRewardCard(PointReward reward) {
    final canRedeem = _currentPoints >= reward.pointsCost;

    return GestureDetector(
      onTap: () => _redeemReward(reward),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: canRedeem
                ? reward.color.withValues(alpha: 0.3)
                : AppTheme.borderColor,
            width: canRedeem ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: reward.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: SvgPicture.asset(
                reward.iconPath,
                width: AppDimensions.iconXL,
                height: AppDimensions.iconXL,
                colorFilter: ColorFilter.mode(reward.color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              reward.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontBody,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              reward.description,
              style: TextStyle(
                fontSize: AppDimensions.fontCaption,
                color: AppTheme.slate600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.star,
                  width: AppDimensions.iconXS,
                  height: AppDimensions.iconXS,
                  colorFilter: const ColorFilter.mode(
                    Colors.orange,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${reward.pointsCost}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontSubtitle,
                    color: canRedeem ? Colors.orange : AppTheme.slate600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: canRedeem
                    ? AppTheme.primaryColor
                    : AppTheme.slate600.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                canRedeem ? 'Ø§Ø³ØªØ¨Ø¯Ø§Ù„' : 'ØºÙŠØ± ÙƒØ§ÙÙ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: canRedeem ? Colors.white : AppTheme.slate600,
                  fontSize: AppDimensions.fontLabel,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ø³Ø¬Ù„ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª',
          style: TextStyle(
            fontSize: AppDimensions.fontHeadline,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return _buildTransactionItem(transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(PointTransaction transaction) {
    final isPositive = transaction.type != PointTransactionType.redeemed;
    final color = switch (transaction.type) {
      PointTransactionType.earned => AppTheme.successColor,
      PointTransactionType.redeemed => AppTheme.errorColor,
      PointTransactionType.bonus => Colors.purple,
      PointTransactionType.expired => AppTheme.slate600,
    };
    final iconPath = switch (transaction.type) {
      PointTransactionType.earned => AppIcons.addCircle,
      PointTransactionType.redeemed => AppIcons.removeCircle,
      PointTransactionType.bonus => AppIcons.gift,
      PointTransactionType.expired => AppIcons.time,
    };

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: AppDimensions.iconS,
          height: AppDimensions.iconS,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
      title: Text(
        transaction.description,
        style: TextStyle(fontSize: AppDimensions.fontBody),
      ),
      subtitle: Text(
        _formatDate(transaction.date),
        style: TextStyle(
          fontSize: AppDimensions.fontLabel,
          color: AppTheme.slate600,
        ),
      ),
      trailing: Text(
        '${isPositive ? '+' : '-'}${transaction.amount}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: AppDimensions.fontTitle,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'Ù…Ù†Ø° ${diff.inMinutes} Ø¯Ù‚ÙŠÙ‚Ø©';
    } else if (diff.inHours < 24) {
      return 'Ù…Ù†Ø° ${diff.inHours} Ø³Ø§Ø¹Ø©';
    } else if (diff.inDays < 7) {
      return 'Ù…Ù†Ø° ${diff.inDays} ÙŠÙˆÙ…';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _processPurchase(
    BuildContext dialogContext,
    PointsPackage package,
  ) async {
    Navigator.pop(dialogContext);

    // Ø¹Ø±Ø¶ Ù…Ø¤Ø´Ø± Ø§Ù„ØªØ­Ù…ÙŠÙ„
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final paymentRepo = ref.read(paymentRepositoryProvider);

      // Ù…Ø­Ø§ÙˆÙ„Ø© Ø¥Ù†Ø´Ø§Ø¡ Ù†ÙŠØ© Ø¯ÙØ¹ Ø­Ù‚ÙŠÙ‚ÙŠØ©
      // Ø¥Ø°Ø§ ÙØ´Ù„ (Ù„Ø¹Ø¯Ù… ÙˆØ¬ÙˆØ¯ Moyasar keys)ØŒ Ø§Ø³ØªØ®Ø¯Ù… Ø§Ù„Ù…Ø­Ø§ÙƒØ§Ø©
      try {
        final intent = await paymentRepo.createPaymentIntent(
          packageId: 'pkg_${package.points}',
        );

        // Ø¥ØºÙ„Ø§Ù‚ Ù…Ø¤Ø´Ø± Ø§Ù„ØªØ­Ù…ÙŠÙ„
        if (mounted) Navigator.pop(context);

        // ÙØªØ­ ØµÙØ­Ø© Ø§Ù„Ø¯ÙØ¹
        final url = Uri.parse(intent.invoiceUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);

          // Ø¹Ø±Ø¶ Ø±Ø³Ø§Ù„Ø©
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ø£ÙƒÙ…Ù„ Ø§Ù„Ø¯ÙØ¹ ÙÙŠ Ø§Ù„Ù…ØªØµÙØ­ØŒ Ø³ØªÙØ¶Ø§Ù Ø§Ù„Ù†Ù‚Ø§Ø· ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹'),
                backgroundColor: AppTheme.infoColor,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 5),
              ),
            );
          }
        }
      } catch (e) {
        // Ø¥Ø°Ø§ ÙØ´Ù„ Ø§Ù„Ø¯ÙØ¹ Ø§Ù„Ø­Ù‚ÙŠÙ‚ÙŠØŒ Ø§Ø³ØªØ®Ø¯Ù… Ø§Ù„Ù…Ø­Ø§ÙƒØ§Ø©
        final result = await paymentRepo.simulatePayment(
          packageId: 'pkg_${package.points}',
        );

        // Ø¥ØºÙ„Ø§Ù‚ Ù…Ø¤Ø´Ø± Ø§Ù„ØªØ­Ù…ÙŠÙ„
        if (mounted) Navigator.pop(context);

        if (result.success) {
          setState(() {
            _currentPoints += result.pointsAdded;
            _lifetimePoints += result.pointsAdded;
            _transactions.insert(
              0,
              PointTransaction(
                id: DateTime.now().toString(),
                type: PointTransactionType.bonus,
                amount: result.pointsAdded,
                description: 'Ø´Ø±Ø§Ø¡ ${package.points} Ù†Ù‚Ø·Ø©',
                date: DateTime.now(),
              ),
            );
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message),
                backgroundColor: AppTheme.successColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      // Ø¥ØºÙ„Ø§Ù‚ Ù…Ø¤Ø´Ø± Ø§Ù„ØªØ­Ù…ÙŠÙ„ ÙÙŠ Ø­Ø§Ù„Ø© Ø§Ù„Ø®Ø·Ø£
      if (mounted) Navigator.pop(context);

      // Ø¹Ù†Ø¯ ÙØ´Ù„ ÙƒÙ„ Ø´ÙŠØ¡ØŒ Ø§Ø³ØªØ®Ø¯Ù… Ø§Ù„Ù…Ø­Ø§ÙƒØ§Ø© Ø§Ù„Ù…Ø­Ù„ÙŠØ©
      setState(() {
        _currentPoints += package.points + package.bonus;
        _lifetimePoints += package.points + package.bonus;
        _transactions.insert(
          0,
          PointTransaction(
            id: DateTime.now().toString(),
            type: PointTransactionType.bonus,
            amount: package.points + package.bonus,
            description: 'Ø´Ø±Ø§Ø¡ ${package.points} Ù†Ù‚Ø·Ø©',
            date: DateTime.now(),
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ØªÙ… Ø¥Ø¶Ø§ÙØ© ${package.points + package.bonus} Ù†Ù‚Ø·Ø©! (Ù…Ø­Ø§ÙƒØ§Ø©)',
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ÙƒÙŠÙ ØªÙƒØ³Ø¨ Ø§Ù„Ù†Ù‚Ø§Ø·ØŸ'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _HelpItem(
                iconPath: AppIcons.cart,
                title: 'Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª',
                description: 'Ø§ÙƒØ³Ø¨ 1 Ù†Ù‚Ø·Ø© Ø¹Ù† ÙƒÙ„ Ø±ÙŠØ§Ù„ Ù…Ø¨ÙŠØ¹Ø§Øª',
              ),
              SizedBox(height: 12),
              _HelpItem(
                iconPath: AppIcons.add,
                title: 'Ø¥Ø¶Ø§ÙØ© Ù…Ù†ØªØ¬Ø§Øª',
                description: '30 Ù†Ù‚Ø·Ø© Ø¹Ù† ÙƒÙ„ Ù…Ù†ØªØ¬ Ø¬Ø¯ÙŠØ¯',
              ),
              SizedBox(height: 12),
              _HelpItem(
                iconPath: AppIcons.checkCircle,
                title: 'Ø§Ù„ØªØ­Ø¯ÙŠØ§Øª Ø§Ù„ÙŠÙˆÙ…ÙŠØ©',
                description: 'Ø£ÙƒÙ…Ù„ Ø§Ù„ØªØ­Ø¯ÙŠØ§Øª ÙˆØ§ÙƒØ³Ø¨ Ø­ØªÙ‰ 100 Ù†Ù‚Ø·Ø©',
              ),
              SizedBox(height: 12),
              _HelpItem(
                iconPath: AppIcons.share,
                title: 'Ø¯Ø¹ÙˆØ© Ø£ØµØ¯Ù‚Ø§Ø¡',
                description: '500 Ù†Ù‚Ø·Ø© Ø¹Ù† ÙƒÙ„ ØµØ¯ÙŠÙ‚ ÙŠØ³Ø¬Ù„',
              ),
              SizedBox(height: 12),
              _HelpItem(
                iconPath: AppIcons.star,
                title: 'Ø§Ù„ØªÙ‚ÙŠÙŠÙ…Ø§Øª',
                description: '10 Ù†Ù‚Ø§Ø· Ø¹Ù† ÙƒÙ„ ØªÙ‚ÙŠÙŠÙ… 5 Ù†Ø¬ÙˆÙ…',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ÙÙ‡Ù…Øª'),
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;

  const _HelpItem({
    required this.iconPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            iconPath,
            width: AppDimensions.iconS,
            height: AppDimensions.iconS,
            colorFilter: const ColorFilter.mode(
              AppTheme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                description,
                style: TextStyle(
                  fontSize: AppDimensions.fontLabel,
                  color: AppTheme.slate600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Ù†Ù…Ø§Ø°Ø¬ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª
enum PointTransactionType { earned, redeemed, bonus, expired }

class PointTransaction {
  final String id;
  final PointTransactionType type;
  final int amount;
  final String description;
  final DateTime date;

  PointTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });
}

class PointReward {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final String iconPath;
  final Color color;

  PointReward({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.iconPath,
    required this.color,
  });
}

// ============================================================================
// Ø´Ø±Ø§Ø¡ Ø§Ù„Ù†Ù‚Ø§Ø·
// ============================================================================

class PointsPackage {
  final String id;
  final int points;
  final int bonus;
  final double price;
  final bool isPopular;

  const PointsPackage({
    required this.id,
    required this.points,
    required this.bonus,
    required this.price,
    this.isPopular = false,
  });

  int get totalPoints => points + bonus;
  double get pricePerPoint => price / totalPoints;
}

class _BuyPointsSheet extends StatelessWidget {
  final Function(PointsPackage) onPurchase;

  const _BuyPointsSheet({required this.onPurchase});

  static const List<PointsPackage> packages = [
    PointsPackage(id: '1', points: 100, bonus: 0, price: 10),
    PointsPackage(id: '2', points: 500, bonus: 50, price: 45),
    PointsPackage(
      id: '3',
      points: 1000,
      bonus: 150,
      price: 80,
      isPopular: true,
    ),
    PointsPackage(id: '4', points: 2500, bonus: 500, price: 180),
    PointsPackage(id: '5', points: 5000, bonus: 1500, price: 300),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.star,
                    width: AppDimensions.iconL,
                    height: AppDimensions.iconL,
                    colorFilter: const ColorFilter.mode(
                      Colors.orange,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ø´Ø±Ø§Ø¡ Ù†Ù‚Ø§Ø·',
                      style: TextStyle(
                        fontSize: AppDimensions.fontDisplay3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ø§Ø®ØªØ± Ø§Ù„Ø¨Ø§Ù‚Ø© Ø§Ù„Ù…Ù†Ø§Ø³Ø¨Ø© Ù„Ùƒ',
                      style: TextStyle(
                        fontSize: AppDimensions.fontBody2,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Packages List
          SizedBox(
            height: 350,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final package = packages[index];
                return _buildPackageCard(context, package);
              },
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.shield,
                  width: AppDimensions.iconXS,
                  height: AppDimensions.iconXS,
                  colorFilter: ColorFilter.mode(
                    Colors.grey[600]!,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Ø¯ÙØ¹ Ø¢Ù…Ù† ÙˆÙ…Ø´ÙØ±',
                  style: TextStyle(
                    fontSize: AppDimensions.fontLabel,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, PointsPackage package) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: package.isPopular
            ? Colors.orange.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: package.isPopular
              ? Colors.orange.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
          width: package.isPopular ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPurchase(package),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Points Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${package.points}',
                            style: TextStyle(
                              fontSize: AppDimensions.fontDisplay2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' Ù†Ù‚Ø·Ø©',
                            style: TextStyle(
                              fontSize: AppDimensions.fontBody,
                              color: Colors.grey,
                            ),
                          ),
                          if (package.isPopular) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Ø§Ù„Ø£ÙƒØ«Ø± Ù…Ø¨ÙŠØ¹Ø§Ù‹',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppDimensions.fontCaption,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (package.bonus > 0)
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.gift,
                              width: AppDimensions.fontBody,
                              height: AppDimensions.fontBody,
                              colorFilter: const ColorFilter.mode(
                                Colors.green,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+${package.bonus} Ù†Ù‚Ø·Ø© Ù‡Ø¯ÙŠØ©',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: AppDimensions.fontLabel,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${package.price.toInt()} Ø±.Ø³',
                      style: TextStyle(
                        fontSize: AppDimensions.fontHeadline,
                        fontWeight: FontWeight.bold,
                        color: package.isPopular
                            ? Colors.orange
                            : AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      '${package.pricePerPoint.toStringAsFixed(2)} Ø±.Ø³/Ù†Ù‚Ø·Ø©',
                      style: TextStyle(
                        fontSize: AppDimensions.fontCaption,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
