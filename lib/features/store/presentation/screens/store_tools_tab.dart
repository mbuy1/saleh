import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/skeleton_loading.dart';

/// صفحة المتجر - أدوات وخدمات التاجر
/// تصميم حديث يعرض أدوات التسويق والذكاء الاصطناعي
class StoreToolsTab extends StatefulWidget {
  const StoreToolsTab({super.key});

  @override
  State<StoreToolsTab> createState() => _StoreToolsTabState();
}

class _StoreToolsTabState extends State<StoreToolsTab> {
  bool _isLoading = false;

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: _isLoading
            ? const SkeletonMarketingScreen()
            : RefreshIndicator(
                onRefresh: _refreshData,
                color: AppTheme.accentColor,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Header مع تصميم حديث
                    SliverToBoxAdapter(child: _buildHeader(context)),
                    // بطاقة الترحيب
                    SliverToBoxAdapter(child: _buildWelcomeCard()),
                    // إحصائيات سريعة
                    SliverToBoxAdapter(child: _buildQuickStats()),
                    // قسم التسويق
                    SliverToBoxAdapter(
                      child: _buildSectionHeader(
                        '🚀 التسويق',
                        'أدوات لزيادة مبيعاتك',
                      ),
                    ),
                    SliverToBoxAdapter(child: _buildMarketingSection()),
                    // قسم الذكاء الاصطناعي
                    SliverToBoxAdapter(
                      child: _buildSectionHeader(
                        '✨ الذكاء الاصطناعي',
                        'قوة AI في متجرك',
                      ),
                    ),
                    SliverToBoxAdapter(child: _buildAISection()),
                    // قسم التحليلات
                    SliverToBoxAdapter(
                      child: _buildSectionHeader(
                        '📊 التحليلات',
                        'اتخذ قرارات ذكية',
                      ),
                    ),
                    SliverToBoxAdapter(child: _buildAnalyticsSection()),
                    // مساحة سفلية
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                AppIcons.arrowBack,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'أدوات المتجر',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          // شريط البحث مصغر
          GestureDetector(
            onTap: _showSearchSheet,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Icon(
                Icons.search,
                size: 20,
                color: AppTheme.textHintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: 'ابحث عن أداة...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.dividerColor),
                  ),
                ),
              ),
            ),
            // يمكن إضافة نتائج البحث هنا
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طوّر متجرك',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'استخدم أدوات التسويق والذكاء الاصطناعي',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  'كوبون جديد',
                  Icons.confirmation_number_outlined,
                  () => context.push('/dashboard/coupons'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  'عرض جديد',
                  Icons.flash_on,
                  () => context.push('/dashboard/flash-sales'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'الزيارات اليوم',
              '0',
              Icons.visibility_outlined,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'معدل التحويل',
              '0%',
              Icons.trending_up,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'العروض النشطة',
              '0',
              Icons.local_offer_outlined,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppTheme.textHintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: AppTheme.textHintColor),
                ),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('عرض الكل')),
        ],
      ),
    );
  }

  Widget _buildMarketingSection() {
    final tools = [
      _ToolData(
        'الكوبونات',
        'إنشاء كوبونات خصم',
        AppIcons.discount,
        const Color(0xFF4CAF50),
        '/dashboard/coupons',
      ),
      _ToolData(
        'العروض الخاطفة',
        'عروض محدودة الوقت',
        AppIcons.flash,
        const Color(0xFFEF4444),
        '/dashboard/flash-sales',
      ),
      _ToolData(
        'السلات المتروكة',
        'استرجع عملاءك',
        AppIcons.cart,
        const Color(0xFFE91E63),
        '/dashboard/abandoned-cart',
      ),
      _ToolData(
        'برنامج الإحالة',
        'عملاء يجلبون عملاء',
        AppIcons.share,
        const Color(0xFF10B981),
        '/dashboard/referral',
      ),
      _ToolData(
        'برنامج الولاء',
        'كافئ عملاءك',
        AppIcons.loyalty,
        const Color(0xFF00BCD4),
        '/dashboard/loyalty-program',
      ),
      _ToolData(
        'التسعير الذكي',
        'أسعار ديناميكية',
        AppIcons.dollar,
        const Color(0xFFFF9800),
        '/dashboard/smart-pricing',
      ),
    ];

    return _buildToolsHorizontalList(tools);
  }

  Widget _buildAISection() {
    final tools = [
      _ToolData(
        'استوديو AI',
        'توليد صور ونصوص',
        AppIcons.sparkle,
        const Color(0xFFA855F7),
        '/dashboard/studio',
        badge: 'AI',
      ),
      _ToolData(
        'أدوات AI',
        'أدوات متقدمة',
        AppIcons.tools,
        const Color(0xFF7C3AED),
        '/dashboard/tools',
        badge: 'AI',
      ),
      _ToolData(
        'مساعد AI',
        'مساعدك الذكي',
        AppIcons.chat,
        const Color(0xFF06B6D4),
        '/dashboard/ai-assistant',
        badge: 'AI',
      ),
      _ToolData(
        'مولد المحتوى',
        'محتوى تسويقي',
        AppIcons.document,
        const Color(0xFF0EA5E9),
        '/dashboard/content-generator',
        badge: 'AI',
      ),
    ];

    return _buildToolsHorizontalList(tools);
  }

  Widget _buildAnalyticsSection() {
    final tools = [
      _ToolData(
        'تحليلات ذكية',
        'بيانات مفصلة',
        AppIcons.analytics,
        const Color(0xFF4F46E5),
        '/dashboard/smart-analytics',
      ),
      _ToolData(
        'تقارير تلقائية',
        'تقارير دورية',
        AppIcons.document,
        const Color(0xFF14B8A6),
        '/dashboard/auto-reports',
      ),
      _ToolData(
        'خريطة الحرارة',
        'سلوك العملاء',
        AppIcons.grid,
        const Color(0xFFEC4899),
        '/dashboard/heatmap',
      ),
    ];

    return _buildToolsHorizontalList(tools);
  }

  Widget _buildToolsHorizontalList(List<_ToolData> tools) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: tools.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final tool = tools[index];
          return _buildToolCard(tool);
        },
      ),
    );
  }

  Widget _buildToolCard(_ToolData tool) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(tool.route);
      },
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: tool.color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tool.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    tool.iconPath,
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(tool.color, BlendMode.srcIn),
                  ),
                ),
                if (tool.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tool.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              tool.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              tool.subtitle,
              style: TextStyle(fontSize: 10, color: AppTheme.textHintColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolData {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color color;
  final String route;
  final String? badge;

  const _ToolData(
    this.title,
    this.subtitle,
    this.iconPath,
    this.color,
    this.route, {
    this.badge,
  });
}
