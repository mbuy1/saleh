import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/skeleton_loading.dart';
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      // 1. بار رابط متجري
                      _buildStoreLinkCard(
                        context,
                        storeName: store?.name ?? 'متجري',
                        isLoading: storeState.isLoading,
                      ),
                      const SizedBox(height: 12),
                      // 2. الإحصائيات الأربعة
                      _buildStatsGrid(context, store: store),
                      const SizedBox(height: 12),
                      // 3. شبكة الأيقونات (4 أيقونات)
                      _buildIconsGrid(context),
                      const SizedBox(height: 12),
                      // 4. زر تجربة العميل (تمت إزالته)
                      // _buildCustomerModeButton(context),
                      const SizedBox(height: 8),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: AppTheme.darkSlate, // Dark Slate for icons
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                          Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: AppTheme.mutedSlate,
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
              // زر الإشعارات
              Semantics(
                label: 'الإشعارات',
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    context.push('/dashboard/notifications');
                  },
                  color: AppTheme.darkSlate, // Dark Slate for icons
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // أزرار إدارة المتجر
          Row(
            children: [
              Expanded(
                child: _buildLinkActionButton(
                  icon: Icons.settings_outlined,
                  label: 'إدارة المتجر',
                  onTap: () => context.push('/dashboard/store-management'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLinkActionButton(
                  icon: Icons.storefront_outlined,
                  label: 'تخصيص المتجر',
                  onTap: () => context.push('/dashboard/store-on-jock'),
                ),
              ),
              // تم نقل زر عرض متجري للأعلى
            ],
          ),
          const SizedBox(height: 12),
          // رابط المتجر مع زر نسخ - Recessed Metal Look
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppTheme.recessedMetalGradient,
              borderRadius: BorderRadius.circular(8),
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
                Icon(
                  Icons.link,
                  size: 16,
                  color: AppTheme.darkSlate, // Dark Slate for icons
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
                const SizedBox(width: 8),
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
                      child: const Text(
                        'نسخ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
                      child: const Icon(
                        Icons.share_outlined,
                        size: 16,
                        color: AppTheme.primaryColor,
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
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: AppTheme.cardGradient,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor, width: 1),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppTheme
                      .darkSlate, // Dark Slate (#0F172A) for icons from image
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
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
                icon: Icons.account_balance_wallet_outlined,
                title: 'الرصيد',
                value: '0.00',
                suffix: 'ر.س',
                color: Colors.green,
                onTap: () => context.push('/dashboard/wallet'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.stars_outlined,
                title: 'النقاط',
                value: '0',
                suffix: 'نقطة',
                color: Colors.orange,
                onTap: () => context.push('/dashboard/points'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // الصف الثاني: العملاء + المبيعات
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.people_outline,
                title: 'العملاء',
                value: '${store?.followersCount ?? 0}',
                suffix: 'متابع',
                color: Colors.blue,
                onTap: () => context.push('/dashboard/customers'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.star_outline,
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
    required IconData icon,
    required String title,
    required String value,
    required String suffix,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: AppTheme.cardGradient,
            borderRadius: BorderRadius.circular(16),
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
                        fontSize: 20,
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
                      fontSize: 12,
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
                  icon: Icons.bolt_outlined,
                  label: 'اختصاراتي',
                  screen: 'Shortcuts',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  icon: Icons.description_outlined,
                  label: 'السجلات والتقارير',
                  screen: 'Reports',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  icon: Icons.campaign_outlined,
                  label: 'التسويق',
                  screen: 'Marketing',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // الصف الثاني: أدوات AI، توليد AI، حزم التوفير
        SizedBox(
          height: 110,
          child: Row(
            children: [
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  icon: Icons.build_outlined,
                  label: 'أدوات AI',
                  screen: 'MbuyTools',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  icon: Icons.auto_awesome_outlined,
                  label: 'توليد AI',
                  screen: 'MbuyStudio',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  icon: Icons.card_giftcard_outlined,
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
    required IconData icon,
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
                      child: Icon(
                        icon,
                        size: 36,
                        color: AppTheme
                            .darkSlate, // Dark Slate for feature icons from image
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
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
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
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
                    icon: Icons.lock_outline,
                    title: 'تغيير كلمة السر',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        '/dashboard/feature/${Uri.encodeComponent('تغيير كلمة السر')}',
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.edit_outlined,
                    title: 'تعديل معلومات الحساب',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        '/dashboard/feature/${Uri.encodeComponent('تعديل معلومات الحساب')}',
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.lightbulb_outline,
                    title: 'الاقتراحات',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        '/dashboard/feature/${Uri.encodeComponent('الاقتراحات')}',
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.delete_outline,
                    title: 'حذف المتجر',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        '/dashboard/feature/${Uri.encodeComponent('حذف المتجر')}',
                      );
                    },
                    textColor: Colors.red,
                    iconColor: Colors.red,
                  ),
                  const Divider(),
                  _buildDrawerItem(
                    icon: Icons.share_outlined,
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
                  _buildDrawerItem(
                    icon: Icons.description_outlined,
                    title: 'الشروط و الأحكام',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        '/dashboard/feature/${Uri.encodeComponent('الشروط و الأحكام')}',
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.card_membership_outlined,
                    title: 'باقة المتجر',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        '/dashboard/feature/${Uri.encodeComponent('باقة المتجر')}',
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.support_agent_outlined,
                    title: 'اتصل بنا',
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        '/dashboard/feature/${Uri.encodeComponent('اتصل بنا')}',
                      );
                    },
                  ),
                  const Divider(),
                  _buildDrawerItem(
                    icon: Icons.logout,
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
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppTheme.darkSlate, // Dark Slate for icons
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppTheme.darkSlate, // Dark Slate for text
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppTheme.mutedSlate, // Muted Slate for inactive elements
      ),
    );
  }
}
