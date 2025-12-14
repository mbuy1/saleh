import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/controllers/root_controller.dart';
import '../../../../shared/widgets/skeleton_loading.dart';
import '../../../merchant/data/merchant_store_provider.dart';
import '../../../merchant/domain/models/store.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   الصفحة الرئيسية - التصميم مثبت ومعتمد                                   ║
// ║   تاريخ التثبيت: 14 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   العناصر المثبتة:                                                        ║
// ║   • بطاقات الإحصائيات (4 بطاقات بدون أيقونات)                             ║
// ║   • شبكة الأيقونات (6 أيقونات مربعة بدون ظل)                              ║
// ║   • زر "متجرك على جوك"                                                    ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل التصميم إلا بطلب صريح وواضح من المالك                     ║
// ║   ⛔ DO NOT MODIFY design without EXPLICIT owner request                  ║
// ║                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// الصفحة الرئيسية للتاجر
/// 🔒 LOCKED DESIGN - تصميم مثبت
/// Last updated: 2025-12-14
class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  bool _isLoading = true;

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
      backgroundColor: const Color(0xFFF5F5F5),
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
                      // 3. شبكة الأيقونات (6 أيقونات)
                      _buildIconsGrid(context),
                      const SizedBox(height: 12),
                      // 4. زر تجربة العميل
                      _buildCustomerModeButton(context),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.store,
                  color: AppTheme.primaryColor,
                  size: 32,
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
                              color: AppTheme.primaryColor,
                            ),
                          ),
                    const SizedBox(height: 4),
                    // زر عرض متجري (منقول)
                    InkWell(
                      onTap: () => context.push(
                        '/dashboard/feature/${Uri.encodeComponent('عرض متجري')}',
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'عرض متجري',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
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
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  context.push(
                    '/dashboard/feature/${Uri.encodeComponent('الإشعارات')}',
                  );
                },
                color: Colors.grey[700],
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
                  label: 'متجرك على جوك',
                  onTap: () => context.push('/dashboard/store-on-jock'),
                ),
              ),
              // تم نقل زر عرض متجري للأعلى
            ],
          ),
          const SizedBox(height: 12),
          // رابط المتجر مع زر نسخ
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.link, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    storeUrl,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textDirection: TextDirection.ltr,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // زر النسخ
                GestureDetector(
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
                const SizedBox(width: 8),
                // زر المشاركة
                GestureDetector(
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
    return Material(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, size: 20, color: Colors.grey[700]),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// شبكة الإحصائيات الأربعة
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
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                suffix,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ],
      ),
    );
  }

  /// شبكة الأيقونات (6 أيقونات)
  Widget _buildIconsGrid(BuildContext context) {
    return Column(
      children: [
        // الصف الأول
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
                  icon: Icons.campaign_outlined,
                  label: 'التسويق',
                  screen: 'Marketing',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  icon: Icons.rocket_launch_outlined,
                  label: 'ارفع مبيعاتك',
                  screen: 'BoostSales',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // الصف الثاني
        SizedBox(
          height: 110,
          child: Row(
            children: [
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  icon: Icons.build_outlined,
                  label: 'Mbuy Tools',
                  screen: 'MbuyTools',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  icon: Icons.auto_awesome_outlined,
                  label: 'Mbuy Studio',
                  screen: 'MbuyStudio',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBottomCard(
                  context: context,
                  icon: Icons.trending_up_outlined,
                  label: 'ضاعف ظهورك',
                  screen: 'DoubleExposure',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// زر الانتقال لتجربة العميل
  Widget _buildCustomerModeButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          // الانتقال لتطبيق العميل - التاجر يشاهد كعميل (يمكنه الرجوع)
          ref
              .read(rootControllerProvider.notifier)
              .switchToCustomerAppFromMerchant();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.secondaryColor,
                AppTheme.secondaryColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جرب تطبيق العميل',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'شاهد متجرك كما يراه العملاء',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String screen,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: () => _navigateToScreen(context, screen, label),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Icon(icon, size: 36, color: AppTheme.primaryColor),
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
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
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
        // شاشات فارغة حالياً
        context.push('/dashboard/feature/${Uri.encodeComponent(label)}');
        break;
      default:
        context.push('/dashboard/feature/${Uri.encodeComponent(label)}');
    }
  }
}
