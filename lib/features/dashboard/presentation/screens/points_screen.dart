import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة نقاط التاجر - نظام المكافآت والنقاط
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

    // محاكاة تحميل البيانات (سيتم استبدالها بـ API calls)
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
          description: 'بيع منتج - طلب #1234',
          date: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        PointTransaction(
          id: '2',
          type: PointTransactionType.earned,
          amount: 100,
          description: 'إكمال التحدي اليومي',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        PointTransaction(
          id: '3',
          type: PointTransactionType.redeemed,
          amount: 500,
          description: 'استبدال - خصم 10% على الباقة',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        PointTransaction(
          id: '4',
          type: PointTransactionType.bonus,
          amount: 200,
          description: 'مكافأة تسجيل متجر جديد',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        PointTransaction(
          id: '5',
          type: PointTransactionType.earned,
          amount: 30,
          description: 'إضافة منتج جديد',
          date: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ];

      _availableRewards = [
        PointReward(
          id: '1',
          title: 'خصم 5%',
          description: 'خصم على الباقة التالية',
          pointsCost: 500,
          iconPath: AppIcons.discount,
          color: Colors.green,
        ),
        PointReward(
          id: '2',
          title: 'خصم 10%',
          description: 'خصم على الباقة التالية',
          pointsCost: 900,
          iconPath: AppIcons.discount,
          color: Colors.blue,
        ),
        PointReward(
          id: '3',
          title: '5 صور AI مجانية',
          description: 'صور إضافية لهذا الشهر',
          pointsCost: 300,
          iconPath: AppIcons.image,
          color: Colors.purple,
        ),
        PointReward(
          id: '4',
          title: 'فيديو AI مجاني',
          description: 'فيديو واحد إضافي',
          pointsCost: 600,
          iconPath: AppIcons.videocam,
          color: Colors.orange,
        ),
        PointReward(
          id: '5',
          title: 'دعم أولوية',
          description: 'أسبوع من الدعم المميز',
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
          content: Text('رصيد النقاط غير كافٍ'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('استبدال ${reward.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              reward.iconPath,
              width: 48,
              height: 48,
              colorFilter: ColorFilter.mode(reward.color, BlendMode.srcIn),
            ),
            const SizedBox(height: 16),
            Text('سيتم خصم ${reward.pointsCost} نقطة من رصيدك'),
            const SizedBox(height: 8),
            Text(
              'الرصيد بعد الاستبدال: ${_currentPoints - reward.pointsCost} نقطة',
              style: TextStyle(color: AppTheme.slate600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('تأكيد الاستبدال'),
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
            description: 'استبدال - ${reward.title}',
            date: DateTime.now(),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم استبدال ${reward.title} بنجاح!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppTheme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'نقاطي',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.help,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppTheme.textPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: _showHelpDialog,
            tooltip: 'كيف أكسب النقاط؟',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPointsData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // رصيد النقاط الرئيسي
                    _buildPointsCard(),
                    const SizedBox(height: 16),
                    // إحصائيات سريعة
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    // المكافآت المتاحة
                    _buildRewardsSection(),
                    const SizedBox(height: 24),
                    // سجل المعاملات
                    _buildTransactionsSection(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
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
              const Text(
                'رصيد النقاط',
                style: TextStyle(color: Colors.white70, fontSize: 16),
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
                      width: 16,
                      height: 16,
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  ' نقطة',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // شريط التقدم للمستوى التالي
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'المستوى الذهبي',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${((_currentPoints / 2000) * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
                '${2000 - _currentPoints} نقطة للمستوى التالي',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
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
            'إجمالي المكتسب',
            '$_lifetimePoints',
            AppIcons.trendingUp,
            AppTheme.successColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'تم استبداله',
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
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: AppTheme.slate600),
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
            const Text(
              'المكافآت المتاحة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // عرض جميع المكافآت
              },
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableRewards.length,
            itemBuilder: (context, index) {
              final reward = _availableRewards[index];
              return _buildRewardCard(reward);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard(PointReward reward) {
    final canRedeem = _currentPoints >= reward.pointsCost;

    return GestureDetector(
      onTap: () => _redeemReward(reward),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: canRedeem
                ? reward.color.withValues(alpha: 0.3)
                : AppTheme.borderColor,
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: reward.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                reward.iconPath,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(reward.color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              reward.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.star,
                  width: 14,
                  height: 14,
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
                    color: canRedeem ? Colors.orange : AppTheme.slate600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: canRedeem
                    ? AppTheme.primaryColor
                    : AppTheme.slate600.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                canRedeem ? 'استبدال' : 'غير كافٍ',
                style: TextStyle(
                  color: canRedeem ? Colors.white : AppTheme.slate600,
                  fontSize: 11,
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
        const Text(
          'سجل المعاملات',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        _formatDate(transaction.date),
        style: TextStyle(fontSize: 12, color: AppTheme.slate600),
      ),
      trailing: Text(
        '${isPositive ? '+' : '-'}${transaction.amount}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 16,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('كيف تكسب النقاط؟'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _HelpItem(
                iconPath: AppIcons.cart,
                title: 'المبيعات',
                description: 'اكسب 1 نقطة عن كل ريال مبيعات',
              ),
              SizedBox(height: 12),
              _HelpItem(
                iconPath: AppIcons.add,
                title: 'إضافة منتجات',
                description: '30 نقطة عن كل منتج جديد',
              ),
              SizedBox(height: 12),
              _HelpItem(
                iconPath: AppIcons.checkCircle,
                title: 'التحديات اليومية',
                description: 'أكمل التحديات واكسب حتى 100 نقطة',
              ),
              SizedBox(height: 12),
              _HelpItem(
                iconPath: AppIcons.share,
                title: 'دعوة أصدقاء',
                description: '500 نقطة عن كل صديق يسجل',
              ),
              const SizedBox(height: 12),
              _HelpItem(
                iconPath: AppIcons.star,
                title: 'التقييمات',
                description: '10 نقاط عن كل تقييم 5 نجوم',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت'),
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
            width: 20,
            height: 20,
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
                style: TextStyle(fontSize: 12, color: AppTheme.slate600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// نماذج البيانات
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
