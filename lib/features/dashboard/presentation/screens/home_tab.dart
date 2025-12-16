import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/skeleton_loading.dart';
import '../../../../shared/widgets/app_search_delegate.dart';
import '../../../onboarding/presentation/widgets/feature_spotlight.dart';
import '../../../merchant/data/merchant_store_provider.dart';
import '../../../merchant/domain/models/store.dart';
import '../../../auth/data/auth_controller.dart';

// هذا نص واضح يسمح بالتعديل على التصميم

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   الصفحة الرئيسية - التصميم مثبت ومعتمد                                   ║
// ║   تاريخ التثبيت: 15 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   العناصر المثبتة:                                                        ║
// ║   • بطاقات الإحصائيات (4 بطاقات بدون أيقونات)                             ║
// ║   • شبكة الأيقونات: اختصاراتي، السجلات والتقارير، التسويق                ║
// ║   • الصف الثاني: أدوات AI (3D)، توليد AI (3D)، حزم التوفير              ║
// ║   • زر "متجرك على جوك"                                                    ║
// ║   • تم التبديل: اختصاراتي في مكان دروب شوبينقنا                           ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل التصميم إلا بطلب صريح وواضح من المالك                     ║
// ║   ⛔ DO NOT MODIFY design without EXPLICIT owner request                  ║
// ║                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// الصفحة الرئيسية للتاجر
/// 🔒 LOCKED DESIGN - تصميم مثبت
/// Last updated: 2025-12-15
/// تم التبديل بين دروب شوبينقنا واختصاراتي - التصميم مثبت الآن
class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openProfileDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _openSearch(BuildContext context) {
    HapticFeedback.lightImpact();
    showSearch(context: context, delegate: AppSearchDelegate());
  }

  @override
  void initState() {
    super.initState();
    // تحميل بيانات المتجر عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await ref
        .read(merchantStoreControllerProvider.notifier)
        .loadMerchantStore();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeState = ref.watch(merchantStoreControllerProvider);
    final store = storeState.store;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundColor, // Slate-100
      endDrawer: _buildProfileDrawer(context, ref),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppTheme.accentColor,
          child: _isLoading
              ? const SkeletonHomeDashboard()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppDimensions.paddingS,
                  child: Column(
                    children: [
                      // 1. بار رابط متجري
                      _buildStoreLinkCard(
                        context,
                        storeName: store?.name ?? 'متجري',
                        isLoading: storeState.isLoading,
                      ),
                      SizedBox(height: AppDimensions.spacing12),
                      // 2. الإحصائيات الأربعة
                      _buildStatsGrid(context, store: store),
                      SizedBox(height: AppDimensions.spacing12),
                      // 3. شبكة الأيقونات (4 أيقونات)
                      _buildIconsGrid(context),
                      SizedBox(height: AppDimensions.spacing12),
                      // 4. زر تجربة العميل (تمت إزالته)
                      // _buildCustomerModeButton(context),
                      SizedBox(height: AppDimensions.spacing8),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /// بار رابط متجري - نُقل من صفحة المتجر
  Widget _buildStoreLinkCard(
    BuildContext context, {
    required String storeName,
    bool isLoading = false,
  }) {
    final storeSlug = storeName.replaceAll(' ', '-');
    final storeUrl = 'tabayu.com/$storeSlug';

    return Container(
      padding: AppDimensions.paddingM,
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: AppDimensions.borderRadiusXL,
        border: Border.all(
          color: AppTheme.borderColor, // Metallic edge
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _openProfileDrawer,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.store,
                    width: AppDimensions.iconXL,
                    height: AppDimensions.iconXL,
                    colorFilter: ColorFilter.mode(
                      AppTheme.darkSlate,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading
                        ? Container(
                            width: 80,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                        : Text(
                            storeName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color:
                                  AppTheme.darkSlate, // Dark Slate for headings
                            ),
                          ),
                    const SizedBox(height: 4),
                    // زر عرض متجري (منقول)
                    InkWell(
                      onTap: () => context.push('/dashboard/view-store'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppIcons.eye,
                            width: AppDimensions.iconXS,
                            height: AppDimensions.iconXS,
                            colorFilter: ColorFilter.mode(
                              AppTheme.mutedSlate,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'عرض متجري',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  AppTheme.mutedSlate, // Muted Slate for body
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // زر البحث مع Spotlight
              FeatureSpotlight(
                featureId: 'global_search',
                title: 'البحث السريع ✨',
                description:
                    'ابحث في جميع ميزات التطبيق بنقرة واحدة! جرب البحث عن "كوبونات" أو "منتجات"',
                position: SpotlightPosition.bottom,
                child: Semantics(
                  label: 'البحث في التطبيق',
                  button: true,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      AppIcons.search,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppTheme.darkSlate,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => _openSearch(context),
                  ),
                ),
              ),
              // زر الإشعارات
              Semantics(
                label: 'الإشعارات',
                button: true,
                child: IconButton(
                  icon: SvgPicture.asset(
                    AppIcons.notifications,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppTheme.darkSlate,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    context.push('/dashboard/notifications');
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),
          // أزرار إدارة المتجر
          Row(
            children: [
              Expanded(
                child: _buildLinkActionButton(
                  iconPath: AppIcons.settings,
                  label: 'إدارة المتجر',
                  onTap: () => context.push('/dashboard/store-management'),
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildLinkActionButton(
                  iconPath: AppIcons.storefront,
                  label: 'تخصيص المتجر',
                  onTap: () => context.push('/dashboard/store-on-jock'),
                ),
              ),
              // تم نقل زر عرض متجري للأعلى
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          // رابط المتجر مع زر نسخ - Recessed Metal Look
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppTheme.recessedMetalGradient,
              borderRadius: AppDimensions.borderRadiusS,
              border: Border.all(
                color: AppTheme.slate300.withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.link,
                  width: AppDimensions.iconXS,
                  height: AppDimensions.iconXS,
                  colorFilter: ColorFilter.mode(
                    AppTheme.darkSlate,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    storeUrl,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.darkSlate,
                      fontWeight: FontWeight.w500,
                    ),
                    textDirection: TextDirection.ltr,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppDimensions.spacing8),
                // زر النسخ
                Semantics(
                  label: 'نسخ رابط المتجر',
                  button: true,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(ClipboardData(text: storeUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('تم نسخ الرابط'),
                          backgroundColor: AppTheme.successColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'نسخ',
                        style: TextStyle(
                          fontSize: AppDimensions.fontLabel,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.spacing8),
                // زر المشاركة
                Semantics(
                  label: 'مشاركة رابط المتجر',
                  button: true,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      SharePlus.instance.share(
                        ShareParams(
                          text: 'تفضل بزيارة متجري على: $storeUrl',
                          subject: 'رابط متجري',
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SvgPicture.asset(
                        AppIcons.share,
                        width: AppDimensions.iconXS,
                        height: AppDimensions.iconXS,
                        colorFilter: ColorFilter.mode(
                          AppTheme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkActionButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppDimensions.borderRadiusM,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDimensions.borderRadiusM,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: AppTheme.cardGradient,
              borderRadius: AppDimensions.borderRadiusM,
              border: Border.all(color: AppTheme.borderColor, width: 1),
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: AppDimensions.iconS,
                  height: AppDimensions.iconS,
                  colorFilter: ColorFilter.mode(
                    AppTheme.darkSlate,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppDimensions.fontLabel,
                    color: AppTheme
                        .mutedSlate, // Muted Slate (#64748B) for labels from image
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// شبكة الإحصائيات الأربعة - قابلة للنقر
  Widget _buildStatsGrid(BuildContext context, {Store? store}) {
    return Column(
      children: [
        // الصف الأول: الرصيد + النقاط
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                iconPath: AppIcons.wallet,
                title: 'الرصيد',
                value: '0.00',
                suffix: 'ر.س',
                color: Colors.green,
                onTap: () => context.push('/dashboard/wallet'),
              ),
            ),
            SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: _buildStatCard(
                iconPath: AppIcons.points,
                title: 'النقاط',
                value: '0',
                suffix: 'نقطة',
                color: Colors.orange,
                onTap: () => context.push('/dashboard/points'),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spacing12),
        // الصف الثاني: العملاء + المبيعات
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                iconPath: AppIcons.users,
                title: 'العملاء',
                value: '${store?.followersCount ?? 0}',
                suffix: 'متابع',
                color: Colors.blue,
                onTap: () => context.push('/dashboard/customers'),
              ),
            ),
            SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: _buildStatCard(
                iconPath: AppIcons.star,
                title: 'المبيعات',
                value: '0',
                suffix: ' ',
                color: Colors.amber,
                onTap: () => context.push('/dashboard/sales'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String iconPath,
    required String title,
    required String value,
    required String suffix,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppDimensions.borderRadiusL,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensions.borderRadiusL,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: AppTheme.cardGradient,
            borderRadius: AppDimensions.borderRadiusL,
            border: Border.all(
              color: AppTheme.borderColor, // Metallic edge
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: AppDimensions.fontDisplay3,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkSlate, // Dark Slate for headings
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    suffix,
                    style: TextStyle(
                      fontSize: AppDimensions.fontLabel,
                      color: AppTheme.mutedSlate, // Muted Slate for body
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.mutedSlate, // Muted Slate for body
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// شبكة الأيقونات (6 أيقونات)
  /// 🔒 LOCKED - تم التثبيت بعد التبديل
  /// الترتيب: الصف الأول: اختصاراتي، السجلات والتقارير، التسويق | الصف الثاني: أدوات AI (3D)، توليد AI (3D)، حزم التوفير
  Widget _buildIconsGrid(BuildContext context) {
    return Column(
      children: [
        // الصف الأول: دروب شوبينق، السجلات والتقارير، التسويق
        SizedBox(
          height: 110,
          child: Row(
            children: [
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  iconPath: AppIcons.flash,
                  label: 'اختصاراتي',
                  screen: 'Shortcuts',
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  iconPath: AppIcons.document,
                  label: 'السجلات والتقارير',
                  screen: 'Reports',
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  iconPath: AppIcons.megaphone,
                  label: 'التسويق',
                  screen: 'Marketing',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacing12),
        // الصف الثاني: أدوات AI، توليد AI، حزم التوفير
        SizedBox(
          height: 110,
          child: Row(
            children: [
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  iconPath: AppIcons.tools,
                  label: 'أدوات AI',
                  screen: 'MbuyTools',
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  iconPath: AppIcons.sparkle,
                  label: 'توليد AI',
                  screen: 'MbuyStudio',
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  iconPath: AppIcons.gift,
                  label: 'حزم التوفير',
                  screen: 'MbuyPackage',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCard({
    required BuildContext context,
    required String iconPath,
    required String label,
    required String screen,
  }) {
    return Semantics(
      button: true,
      label: label,
      hint: 'انقر للانتقال إلى $label',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () => _navigateToScreen(context, screen, label),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.cardGradient,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppTheme.borderColor, // Metallic edge
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withValues(alpha: 0.1),
                          AppTheme.primaryLight.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(17),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconPath,
                        width: 36,
                        height: 36,
                        colorFilter: ColorFilter.mode(
                          AppTheme.darkSlate,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: AppDimensions.fontLabel,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkSlate, // Dark Slate for headings
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String screen, String label) {
    switch (screen) {
      case 'MbuyStudio':
        context.push('/dashboard/studio');
        break;
      case 'MbuyTools':
        context.push('/dashboard/tools');
        break;
      case 'Marketing':
        context.push('/dashboard/marketing');
        break;
      case 'Products':
        context.push('/dashboard/products');
        break;
      case 'EarnMore':
        context.push('/dashboard/feature/${Uri.encodeComponent('اربح أكثر')}');
        break;
      case 'BoostSales':
        context.push('/dashboard/boost-sales');
        break;
      case 'Shortcuts':
        context.push('/dashboard/shortcuts');
        break;
      case 'DoubleExposure':
        context.push('/dashboard/promotions');
        break;
      case 'MbuyPackage':
        // صفحة حزم التوفير
        context.push('/dashboard/packages');
        break;
      case 'DropShipping':
        context.push('/dashboard/dropshipping');
        break;
      case 'Reports':
        // صفحة التقارير والسجلات
        context.push('/dashboard/reports');
      default:
        context.push('/dashboard/feature/${Uri.encodeComponent(label)}');
    }
  }

  /// Drawer إعدادات الملف الشخصي
  Widget _buildProfileDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
              ),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.person,
                        width: 40,
                        height: 40,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'إعدادات الحساب',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    iconPath: AppIcons.settings,
                    title: 'إعدادات الحساب',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/settings');
                    },
                  ),
                  _buildDrawerItem(
                    iconPath: AppIcons.supportAgent,
                    title: 'الدعم والمساعدة',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/support');
                    },
                  ),
                  _buildDrawerItem(
                    iconPath: AppIcons.info,
                    title: 'عن التطبيق',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/about');
                    },
                  ),
                  const Divider(height: 32),
                  _buildDrawerItem(
                    iconPath: AppIcons.document,
                    title: 'سياسة الخصوصية',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/privacy-policy');
                    },
                  ),
                  _buildDrawerItem(
                    iconPath: AppIcons.document,
                    title: 'شروط الاستخدام',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/terms');
                    },
                  ),
                  const Divider(height: 32),
                  _buildDrawerItem(
                    iconPath: AppIcons.share,
                    title: 'شارك التطبيق',
                    onTap: () {
                      Navigator.pop(context);
                      SharePlus.instance.share(
                        ShareParams(
                          text: 'جرب تطبيق MBUY لإدارة متجرك الإلكتروني',
                          subject: 'تطبيق MBUY',
                        ),
                      );
                    },
                  ),
                  const Divider(height: 32),
                  _buildDrawerItem(
                    iconPath: AppIcons.logout,
                    title: 'تسجيل الخروج',
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(authControllerProvider.notifier).logout();
                    },
                    textColor: Colors.red,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          iconColor ?? AppTheme.darkSlate,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppTheme.darkSlate, // Dark Slate for text
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      trailing: SvgPicture.asset(
        AppIcons.chevronRight,
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(AppTheme.mutedSlate, BlendMode.srcIn),
      ),
    );
  }
}
