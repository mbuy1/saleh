import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/exports.dart';

/// نموذج أداة التسويق
class MarketingTool {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final Color color;
  final String route;
  final String? badge;
  final bool isNew;
  final bool isPopular;

  const MarketingTool({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.color,
    required this.route,
    this.badge,
    this.isNew = false,
    this.isPopular = false,
  });
}

/// شاشة التسويق المحسنة
class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _hasError = false;
  late AnimationController _animationController;

  // إحصائيات التسويق
  final Map<String, dynamic> _stats = {
    'active_campaigns': 3,
    'active_coupons': 12,
    'recovery_rate': 27,
    'loyalty_members': 156,
  };

  // قائمة أدوات التسويق
  final List<MarketingTool> _tools = const [
    MarketingTool(
      id: 'coupons',
      title: 'الكوبونات',
      description: 'إنشاء وإدارة كوبونات الخصم',
      iconPath: AppIcons.discount,
      color: Color(0xFF4CAF50),
      route: '/dashboard/coupons',
      badge: '12',
    ),
    MarketingTool(
      id: 'flash_sales',
      title: 'العروض الخاطفة',
      description: 'عروض محدودة الوقت',
      iconPath: AppIcons.flash,
      color: Color(0xFFEF4444),
      route: '/dashboard/flash-sales',
      isPopular: true,
    ),
    MarketingTool(
      id: 'abandoned_cart',
      title: 'السلات المتروكة',
      description: 'استرداد العملاء المترددين',
      iconPath: AppIcons.cart,
      color: Color(0xFFE91E63),
      route: '/dashboard/abandoned-cart',
      badge: '8',
    ),
    MarketingTool(
      id: 'referral',
      title: 'برنامج الإحالة',
      description: 'كافئ العملاء على الإحالات',
      iconPath: AppIcons.share,
      color: Color(0xFF10B981),
      route: '/dashboard/referral',
    ),
    MarketingTool(
      id: 'loyalty',
      title: 'برنامج الولاء',
      description: 'نقاط ومكافآت للعملاء',
      iconPath: AppIcons.loyalty,
      color: Color(0xFF00BCD4),
      route: '/dashboard/loyalty-program',
      isPopular: true,
    ),
    MarketingTool(
      id: 'segments',
      title: 'شرائح العملاء',
      description: 'تصنيف واستهداف العملاء',
      iconPath: AppIcons.users,
      color: Color(0xFF3B82F6),
      route: '/dashboard/customer-segments',
      isNew: true,
    ),
    MarketingTool(
      id: 'messages',
      title: 'رسائل مخصصة',
      description: 'إشعارات وحملات بريدية',
      iconPath: AppIcons.chat,
      color: Color(0xFF22C55E),
      route: '/dashboard/custom-messages',
    ),
    MarketingTool(
      id: 'pricing',
      title: 'التسعير الذكي',
      description: 'تسعير ديناميكي ومرن',
      iconPath: AppIcons.dollar,
      color: Color(0xFFFF9800),
      route: '/dashboard/smart-pricing',
      isNew: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // محاكاة تحميل البيانات
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _isLoading = false);
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    _animationController.reset();
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _hasError
                  ? _buildErrorState()
                  : RefreshIndicator(
                      onRefresh: _refreshData,
                      color: AppTheme.accentColor,
                      child: _isLoading
                          ? _buildSkeletonContent()
                          : _buildContent(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء الهيدر المحسن
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.spacing16,
        AppDimensions.spacing8,
        AppDimensions.spacing16,
        AppDimensions.spacing16,
      ),
      child: Column(
        children: [
          // صف العنوان
          Row(
            children: [
              _buildBackButton(context),
              Expanded(
                child: Text(
                  'مركز التسويق',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontDisplay2,
                    color: AppTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildInfoButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pop();
      },
      child: Container(
        padding: AppDimensions.paddingS,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: AppDimensions.borderRadiusM,
        ),
        child: AppIcon(
          AppIcons.arrowBack,
          size: AppDimensions.iconS,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showMarketingTips();
      },
      child: Container(
        padding: AppDimensions.paddingS,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: AppDimensions.borderRadiusM,
        ),
        child: Icon(
          Icons.lightbulb_outline,
          size: AppDimensions.iconS,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  /// إحصائيات سريعة
  Widget _buildQuickStats() {
    return Container(
      padding: AppDimensions.paddingM,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.accentColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            '${_stats['active_campaigns']}',
            'حملات نشطة',
            Icons.campaign_outlined,
            const Color(0xFF4CAF50),
          ),
          _buildStatDivider(),
          _buildStatItem(
            '${_stats['active_coupons']}',
            'كوبون فعال',
            Icons.local_offer_outlined,
            const Color(0xFFEF4444),
          ),
          _buildStatDivider(),
          _buildStatItem(
            '${_stats['recovery_rate']}%',
            'استرداد',
            Icons.restore_outlined,
            const Color(0xFFE91E63),
          ),
          _buildStatDivider(),
          _buildStatItem(
            '${_stats['loyalty_members']}',
            'عضو ولاء',
            Icons.card_membership_outlined,
            const Color(0xFF00BCD4),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: AppDimensions.iconS),
        SizedBox(height: AppDimensions.spacing4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.fontTitle,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: AppDimensions.fontCaption,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppTheme.dividerColor.withValues(alpha: 0.3),
    );
  }

  /// المحتوى الرئيسي
  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppDimensions.paddingHorizontalM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.spacing8),
          // إحصائيات سريعة
          _buildQuickStats(),
          SizedBox(height: AppDimensions.spacing20),
          // الأدوات الشائعة
          _buildSectionTitle('⭐ الأدوات الشائعة'),
          SizedBox(height: AppDimensions.spacing12),
          _buildPopularTools(),
          SizedBox(height: AppDimensions.spacing24),
          // جميع الأدوات
          _buildSectionTitle('🛠️ جميع الأدوات'),
          SizedBox(height: AppDimensions.spacing12),
          _buildToolsGrid(),
          SizedBox(height: AppDimensions.spacing24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: AppDimensions.fontTitle,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  /// الأدوات الشائعة (أفقي)
  Widget _buildPopularTools() {
    final popularTools = _tools.where((t) => t.isPopular).toList();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: popularTools.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: AppDimensions.spacing12),
        itemBuilder: (context, index) {
          final tool = popularTools[index];
          return _buildHorizontalToolCard(tool);
        },
      ),
    );
  }

  Widget _buildHorizontalToolCard(MarketingTool tool) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(tool.route);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        padding: AppDimensions.paddingS,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [tool.color, tool.color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppDimensions.borderRadiusL,
          boxShadow: [
            BoxShadow(
              color: tool.color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: AppDimensions.paddingXS,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                  child: AppIcon(
                    tool.iconPath,
                    size: AppDimensions.iconS,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: AppDimensions.fontBody,
                  color: Colors.white70,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tool.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontBody,
                    color: Colors.white,
                  ),
                ),
                Text(
                  tool.description,
                  style: TextStyle(
                    fontSize: AppDimensions.fontCaption,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// شبكة الأدوات
  Widget _buildToolsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppDimensions.spacing12,
        crossAxisSpacing: AppDimensions.spacing12,
        childAspectRatio: 0.85,
      ),
      itemCount: _tools.length,
      itemBuilder: (context, index) {
        return _buildToolCard(_tools[index], index);
      },
    );
  }

  Widget _buildToolCard(MarketingTool tool, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.08;
        final progress = ((_animationController.value - delay) / (1.0 - delay))
            .clamp(0.0, 1.0);
        final animationValue = Curves.easeOutBack.transform(progress);

        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue),
          child: Opacity(opacity: progress, child: child),
        );
      },
      child: _MarketingToolCard(
        tool: tool,
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(tool.route);
        },
      ),
    );
  }

  /// حالة الخطأ
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: AppDimensions.paddingXXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppDimensions.paddingXL,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: AppDimensions.iconHero,
                color: Colors.red,
              ),
            ),
            SizedBox(height: AppDimensions.spacing24),
            Text(
              'حدث خطأ في تحميل البيانات',
              style: TextStyle(
                fontSize: AppDimensions.fontHeadline,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            SizedBox(height: AppDimensions.spacing8),
            Text(
              'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
              style: TextStyle(
                fontSize: AppDimensions.fontBody,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spacing24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing24,
                  vertical: AppDimensions.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Skeleton للتحميل
  Widget _buildSkeletonContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton للإحصائيات
          ShimmerEffect(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: AppDimensions.borderRadiusL,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing20),
          // Skeleton للأدوات الشائعة
          ShimmerEffect(
            child: Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: AppDimensions.borderRadiusXS,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) =>
                  SizedBox(width: AppDimensions.spacing12),
              itemBuilder: (context, index) => ShimmerEffect(
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: AppDimensions.borderRadiusL,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing24),
          // Skeleton للشبكة
          ShimmerEffect(
            child: Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: AppDimensions.borderRadiusXS,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppDimensions.spacing12,
            crossAxisSpacing: AppDimensions.spacing12,
            childAspectRatio: 0.85,
            children: List.generate(
              8,
              (_) => ShimmerEffect(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: AppDimensions.borderRadiusL,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// عرض نصائح التسويق
  void _showMarketingTips() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: AppDimensions.paddingXL,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.spacing24),
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
                  color: Colors.grey[300],
                  borderRadius: AppDimensions.borderRadiusXS,
                ),
              ),
            ),
            SizedBox(height: AppDimensions.spacing20),
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber),
                SizedBox(width: AppDimensions.spacing8),
                Text(
                  'نصائح تسويقية',
                  style: TextStyle(
                    fontSize: AppDimensions.fontDisplay3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacing16),
            _buildTipItem(
              '💡',
              'استخدم الكوبونات بحكمة',
              'لا تفرط في الخصومات، اجعلها مميزة ومحدودة',
            ),
            _buildTipItem(
              '⏰',
              'العروض الخاطفة فعالة',
              'الإلحاح يدفع العملاء لاتخاذ قرار الشراء',
            ),
            _buildTipItem(
              '🎯',
              'استهدف الشرائح الصحيحة',
              'رسائل مخصصة لكل فئة تزيد التحويل',
            ),
            _buildTipItem(
              '❤️',
              'كافئ العملاء المخلصين',
              'برنامج الولاء يزيد المبيعات المتكررة',
            ),
            SizedBox(height: AppDimensions.spacing16),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String title, String description) {
    return Padding(
      padding: AppDimensions.paddingVerticalXS,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: AppDimensions.fontDisplay2)),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontBody,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppDimensions.fontLabel,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة أداة التسويق
class _MarketingToolCard extends StatefulWidget {
  final MarketingTool tool;
  final VoidCallback onTap;

  const _MarketingToolCard({required this.tool, required this.onTap});

  @override
  State<_MarketingToolCard> createState() => _MarketingToolCardState();
}

class _MarketingToolCardState extends State<_MarketingToolCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: AppDimensions.paddingM,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppDimensions.borderRadiusL,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الأيقونة مع الشارة
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: AppDimensions.paddingS,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.tool.color,
                          widget.tool.color.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppDimensions.borderRadiusM,
                      boxShadow: [
                        BoxShadow(
                          color: widget.tool.color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AppIcon(
                      widget.tool.iconPath,
                      size: AppDimensions.iconL,
                      color: Colors.white,
                    ),
                  ),
                  // شارة العدد
                  if (widget.tool.badge != null)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing6,
                          vertical: AppDimensions.spacing2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: AppDimensions.borderRadiusS,
                        ),
                        child: Text(
                          widget.tool.badge!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimensions.fontCaption,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // شارة جديد
                  if (widget.tool.isNew)
                    Positioned(
                      top: -6,
                      left: -6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing6,
                          vertical: AppDimensions.spacing2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: AppDimensions.borderRadiusS,
                        ),
                        child: Text(
                          'جديد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimensions.fontCaption - 3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppDimensions.spacing12),
              // العنوان
              Text(
                widget.tool.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.fontBody,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spacing4),
              // الوصف
              Text(
                widget.tool.description,
                style: TextStyle(
                  fontSize: AppDimensions.fontCaption,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
