import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/skeleton_loading.dart';

/// صفحة المتجر الجديدة - تدمج أدوات AI والتسويق
/// تحل محل تبويب أدوات AI في الصفحة الرئيسية
class StoreToolsTab extends StatefulWidget {
  const StoreToolsTab({super.key});

  @override
  State<StoreToolsTab> createState() => _StoreToolsTabState();
}

class _StoreToolsTabState extends State<StoreToolsTab> {
  bool _isLoading = false;
  String _searchQuery = '';

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
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // شريط البحث
            _buildSearchBar(),
            // المحتوى
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                color: AppTheme.accentColor,
                child: _isLoading
                    ? const SkeletonMarketingScreen()
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // قسم التسويق
                            _buildSectionTitle('التسويق'),
                            _buildMarketingGrid(),
                            const SizedBox(height: AppDimensions.spacing24),
                            // قسم أدوات AI
                            _buildSectionTitle('أدوات الذكاء الاصطناعي'),
                            _buildAIToolsGrid(),
                            const SizedBox(height: AppDimensions.spacing24),
                            // قسم التحليلات
                            _buildSectionTitle('التحليلات والتقارير'),
                            _buildAnalyticsGrid(),
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
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
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
          const Spacer(),
          const Text(
            'المتجر',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          const SizedBox(width: AppDimensions.iconM + AppDimensions.spacing16),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
          decoration: InputDecoration(
            hintText: 'البحث في الأدوات...',
            hintStyle: TextStyle(color: AppTheme.textHintColor),
            prefixIcon: Icon(Icons.search, color: AppTheme.textHintColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppDimensions.fontTitle,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildMarketingGrid() {
    final items = [
      _ToolItem(
        title: 'الكوبونات',
        iconPath: AppIcons.discount,
        color: const Color(0xFF4CAF50),
        route: '/dashboard/coupons',
      ),
      _ToolItem(
        title: 'العروض الخاطفة',
        iconPath: AppIcons.flash,
        color: const Color(0xFFEF4444),
        route: '/dashboard/flash-sales',
      ),
      _ToolItem(
        title: 'السلات المتروكة',
        iconPath: AppIcons.cart,
        color: const Color(0xFFE91E63),
        route: '/dashboard/abandoned-cart',
      ),
      _ToolItem(
        title: 'برنامج الإحالة',
        iconPath: AppIcons.share,
        color: const Color(0xFF10B981),
        route: '/dashboard/referral',
      ),
      _ToolItem(
        title: 'برنامج الولاء',
        iconPath: AppIcons.loyalty,
        color: const Color(0xFF00BCD4),
        route: '/dashboard/loyalty-program',
      ),
      _ToolItem(
        title: 'شرائح العملاء',
        iconPath: AppIcons.users,
        color: const Color(0xFF3B82F6),
        route: '/dashboard/customer-segments',
      ),
      _ToolItem(
        title: 'رسائل مخصصة',
        iconPath: AppIcons.chat,
        color: const Color(0xFF22C55E),
        route: '/dashboard/custom-messages',
      ),
      _ToolItem(
        title: 'التسعير الذكي',
        iconPath: AppIcons.dollar,
        color: Colors.orange,
        route: '/dashboard/smart-pricing',
      ),
    ];

    return _buildToolsGrid(items);
  }

  Widget _buildAIToolsGrid() {
    final items = [
      _ToolItem(
        title: 'توليد AI',
        iconPath: AppIcons.sparkle,
        color: const Color(0xFFA855F7),
        route: '/dashboard/studio',
        badge: 'AI',
      ),
      _ToolItem(
        title: 'أدوات AI',
        iconPath: AppIcons.tools,
        color: const Color(0xFF7C3AED),
        route: '/dashboard/tools',
        badge: 'AI',
      ),
      _ToolItem(
        title: 'مساعد AI',
        iconPath: AppIcons.chat,
        color: const Color(0xFF06B6D4),
        route: '/dashboard/ai-assistant',
        badge: 'AI',
      ),
      _ToolItem(
        title: 'مولد المحتوى',
        iconPath: AppIcons.document,
        color: const Color(0xFF0EA5E9),
        route: '/dashboard/content-generator',
        badge: 'AI',
      ),
    ];

    return _buildToolsGrid(items);
  }

  Widget _buildAnalyticsGrid() {
    final items = [
      _ToolItem(
        title: 'تحليلات ذكية',
        iconPath: AppIcons.analytics,
        color: const Color(0xFF4F46E5),
        route: '/dashboard/smart-analytics',
      ),
      _ToolItem(
        title: 'تقارير تلقائية',
        iconPath: AppIcons.document,
        color: const Color(0xFF14B8A6),
        route: '/dashboard/auto-reports',
      ),
      _ToolItem(
        title: 'خريطة الحرارة',
        iconPath: AppIcons.grid,
        color: const Color(0xFFEC4899),
        route: '/dashboard/heatmap',
      ),
    ];

    return _buildToolsGrid(items);
  }

  Widget _buildToolsGrid(List<_ToolItem> items) {
    // فلترة حسب البحث
    final filteredItems = _searchQuery.isEmpty
        ? items
        : items.where((item) => item.title.contains(_searchQuery)).toList();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      mainAxisSpacing: AppDimensions.spacing16,
      crossAxisSpacing: AppDimensions.spacing16,
      childAspectRatio: 0.95,
      children: filteredItems.map((item) {
        return _buildToolCard(item);
      }).toList(),
    );
  }

  Widget _buildToolCard(_ToolItem item) {
    return GlassCard.withSvgIcon(
      iconPath: item.iconPath,
      iconBackgroundColor: item.color,
      iconSize: AppDimensions.iconXL,
      onTap: () => context.push(item.route),
      child: Stack(
        children: [
          Center(
            child: Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontTitle,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (item.badge != null)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToolItem {
  final String title;
  final String iconPath;
  final Color color;
  final String route;
  final String? badge;

  const _ToolItem({
    required this.title,
    required this.iconPath,
    required this.color,
    required this.route,
    this.badge,
  });
}
