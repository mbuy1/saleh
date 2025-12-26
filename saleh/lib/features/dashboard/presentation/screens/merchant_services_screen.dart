import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/exports.dart';
import '../../../merchant/data/merchant_store_provider.dart';
import '../../../auth/data/auth_controller.dart';

class MerchantServicesScreen extends ConsumerStatefulWidget {
  const MerchantServicesScreen({super.key});

  @override
  ConsumerState<MerchantServicesScreen> createState() =>
      _MerchantServicesScreenState();
}

class _MerchantServicesScreenState
    extends ConsumerState<MerchantServicesScreen> {
  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    await ref.read(merchantStoreControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final storeAsync = ref.watch(merchantStoreControllerProvider);
    final store = storeAsync.hasValue ? storeAsync.value : null;

    // التحقق من وجود متجر
    if (store == null && !storeAsync.isLoading) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store_outlined,
                        size: AppDimensions.iconDisplay,
                        color: AppTheme.textHintColor,
                      ),
                      const SizedBox(height: AppDimensions.spacing16),
                      const Text(
                        'لا يوجد متجر',
                        style: TextStyle(
                          fontSize: AppDimensions.fontDisplay3,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      const Text(
                        'يرجى إنشاء متجر أولاً',
                        style: TextStyle(
                          fontSize: AppDimensions.fontBody,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing24),
                      ElevatedButton(
                        onPressed: () =>
                            context.push('/dashboard/store/create-store'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('إنشاء متجر'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppTheme.accentColor,
          child: storeAsync.isLoading
              ? const SkeletonMerchantServices()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppDimensions.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 20),
                      _buildQuickTabs(),
                      const SizedBox(height: 24),
                      const MbuySectionTitle(title: 'إعدادات المتجر'),
                      const SizedBox(height: 12),
                      _buildSettingsList(),
                      const SizedBox(height: 24),
                      const MbuySectionTitle(title: 'الحساب'),
                      const SizedBox(height: 12),
                      _buildLogoutCard(),
                      const SizedBox(height: 12),
                      _buildDeleteStoreCard(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.pop();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: AppDimensions.iconS,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        const Expanded(
          child: Text(
            'إدارة المتجر',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontDisplay3,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTabs() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickTabItem(
            icon: Icons.info_outline,
            label: 'معلومات المتجر',
            color: AppTheme.primaryColor,
            onTap: () => context.push('/dashboard/store/create-store'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickTabItem(
            icon: Icons.palette_outlined,
            label: 'مظهر المتجر',
            color: Colors.blue,
            onTap: () => context.push('/dashboard/webstore'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickTabItem(
            icon: Icons.notifications_outlined,
            label: 'الإشعارات',
            color: Colors.orange,
            onTap: () => context.push('/notification-settings'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTabItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: AppDimensions.iconM),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimensions.fontLabel,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    final settings = [
      {
        'icon': Icons.info_outline,
        'title': 'معلومات المتجر',
        'subtitle': 'الاسم، الوصف، المدينة',
        'onTap': () => context.push('/dashboard/store/create-store'),
        'enabled': true,
      },
      {
        'icon': Icons.palette_outlined,
        'title': 'تخصيص المتجر',
        'subtitle': 'الثيمات والصفحات والبانرات',
        'onTap': () => context.push('/dashboard/webstore'),
        'enabled': true,
      },
      {
        'icon': Icons.local_shipping_outlined,
        'title': 'إعدادات الشحن',
        'subtitle': 'المناطق، الأسعار، الشركات',
        'onTap': () => context.push('/dashboard/shipping'),
        'enabled': true,
      },
      {
        'icon': Icons.payment_outlined,
        'title': 'طرق الدفع',
        'subtitle': 'البطاقات، التحويل، الدفع عند الاستلام',
        'onTap': () => context.push('/dashboard/payment-methods'),
        'enabled': true,
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'إعدادات الإشعارات',
        'subtitle': 'إدارة التنبيهات والإشعارات الواردة',
        'onTap': () => context.push('/notification-settings'),
        'enabled': true,
      },
      {
        'icon': Icons.palette_outlined,
        'title': 'إعدادات المظهر',
        'subtitle': 'تخصيص الثيم والألوان واللغة',
        'onTap': () => context.push('/appearance-settings'),
        'enabled': true,
      },
      {
        'icon': Icons.person_outline,
        'title': 'إعدادات الحساب',
        'subtitle': 'إدارة معلومات الحساب والأمان',
        'onTap': () => context.push('/settings'),
        'enabled': true,
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: settings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final setting = settings[index];
        return _buildSettingItem(
          icon: setting['icon'] as IconData,
          title: setting['title'] as String,
          subtitle: setting['subtitle'] as String,
          onTap: setting['onTap'] as VoidCallback,
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: AppDimensions.iconS,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSubtitle,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppDimensions.fontBody2,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _showLogoutDialog();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.logout_outlined,
                  color: Colors.orange,
                  size: AppDimensions.iconM,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontSize: AppDimensions.fontTitle,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing2),
                    Text(
                      'الخروج من الحساب الحالي',
                      style: TextStyle(
                        fontSize: AppDimensions.fontBody2,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left, color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteStoreCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _showDeleteStoreDialog();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                  size: AppDimensions.iconM,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'حذف المتجر',
                      style: TextStyle(
                        fontSize: AppDimensions.fontTitle,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing2),
                    Text(
                      'حذف المتجر وجميع البيانات نهائياً',
                      style: TextStyle(
                        fontSize: AppDimensions.fontBody2,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authControllerProvider.notifier).logout();
              if (mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  void _showDeleteStoreDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('حذف المتجر'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من حذف المتجر؟\n\nهذا الإجراء لا يمكن التراجع عنه وسيتم حذف جميع البيانات.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              // TODO: تنفيذ حذف المتجر
              MbuySnackBar.show(
                context,
                message: 'سيتم تفعيل هذه الميزة قريباً',
                type: MbuySnackBarType.info,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف نهائياً'),
          ),
        ],
      ),
    );
  }
}
