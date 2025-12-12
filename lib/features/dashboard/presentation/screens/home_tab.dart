import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/skeleton_loading.dart';
import '../../../merchant/data/merchant_store_provider.dart';
import '../../../merchant/domain/models/store.dart';

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
                      // 3. القائمة الرئيسية (صف واحد)
                      SizedBox(height: 90, child: _buildMainMenu(context)),
                      const SizedBox(height: 12),
                      // 4. الصف السفلي (3 تبويبات)
                      _buildBottomRow(context),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.store,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'متجري',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 2),
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
                  ],
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
                  icon: Icons.palette_outlined,
                  label: 'مظهر المتجر',
                  onTap: () => context.push(
                    '/dashboard/feature/${Uri.encodeComponent('مظهر المتجر')}',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLinkActionButton(
                  icon: Icons.visibility_outlined,
                  label: 'عرض متجري',
                  onTap: () => context.push(
                    '/dashboard/feature/${Uri.encodeComponent('عرض متجري')}',
                  ),
                ),
              ),
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
                title: 'المتابعين',
                value: '${store?.followersCount ?? 0}',
                suffix: 'متابع',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.star_outline,
                title: 'التقييم',
                value: store?.rating?.toStringAsFixed(1) ?? '0.0',
                suffix: '/ 5',
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 18,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// القائمة الرئيسية - صف واحد
  Widget _buildMainMenu(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMenuCard(
            context: context,
            icon: Icons.campaign_outlined,
            label: 'التسويق',
            screen: 'Marketing',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMenuCard(
            context: context,
            icon: Icons.inventory_2_outlined,
            label: 'المنتجات',
            screen: 'Products',
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String screen,
    Color? iconColor,
  }) {
    final color = iconColor ?? AppTheme.primaryColor;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => _navigateToScreen(context, screen, label),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 26, color: color),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// الصف السفلي - 3 تبويبات
  Widget _buildBottomRow(BuildContext context) {
    return SizedBox(
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 26, color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
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
      default:
        context.push('/dashboard/feature/${Uri.encodeComponent(label)}');
    }
  }
}
