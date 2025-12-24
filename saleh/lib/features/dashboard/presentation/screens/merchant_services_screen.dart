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
  bool _isLoading = false;

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
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

    // التحقق من وجود متجر
    if (store == null && !storeState.isLoading && !_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
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
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppTheme.accentColor,
          child: _isLoading
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
                      const MbuySectionTitle(title: 'خدمات إضافية'),
                      const SizedBox(height: 12),
                      _buildServicesGrid(),
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
        'subtitle': 'تنبيهات الطلبات والرسائل',
        'onTap': () => context.push('/notification-settings'),
        'enabled': true,
      },
      {
        'icon': Icons.palette_outlined,
        'title': 'إعدادات المظهر',
        'subtitle': 'اللغة والثيم والألوان',
        'onTap': () => context.push('/appearance-settings'),
        'enabled': true,
      },
      {
        'icon': Icons.person_outline,
        'title': 'إعدادات الحساب',
        'subtitle': 'البريد الإلكتروني وكلمة المرور',
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

  Widget _buildServicesGrid() {
    final services = [
      {
        'icon': Icons.account_balance_outlined,
        'title': 'التمويل',
        'color': const Color(0xFF4CAF50),
        'route': '/dashboard/wallet',
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': 'الدعم',
        'color': const Color(0xFF2196F3),
        'route': '/dashboard/support',
      },
      {
        'icon': Icons.analytics_outlined,
        'title': 'التحليلات',
        'color': const Color(0xFF9C27B0),
        'route': '/dashboard/reports',
      },
      {
        'icon': Icons.school_outlined,
        'title': 'التدريب',
        'color': const Color(0xFFFF9800),
        'route': null, // قريباً
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final route = service['route'] as String?;
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            if (route != null) {
              context.push(route);
            } else {
              _showComingSoon(service['title'] as String);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (service['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    service['icon'] as IconData,
                    color: service['color'] as Color,
                    size: AppDimensions.iconM,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  service['title'] as String,
                  style: TextStyle(
                    fontSize: AppDimensions.fontLabel,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  void _editStoreInfo(BuildContext context) {
    final store = ref.read(merchantStoreControllerProvider).store;
    final nameController = TextEditingController(text: store?.name ?? '');
    final descController = TextEditingController(
      text: store?.description ?? '',
    );
    final cityController = TextEditingController(text: store?.city ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
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
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'تعديل معلومات المتجر',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المتجر',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'وصف المتجر',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'المدينة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (store != null) {
                      await ref
                          .read(merchantStoreControllerProvider.notifier)
                          .updateStoreInfo(
                            storeId: store.id,
                            name: nameController.text,
                            description: descController.text,
                            city: cityController.text,
                          );
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                      MbuySnackBar.show(
                        context,
                        message: 'تم تحديث معلومات المتجر',
                        type: MbuySnackBarType.success,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'حفظ التغييرات',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.share_outlined, size: 22),
                title: const Text('مشاركة المتجر'),
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon('مشاركة المتجر');
                },
              ),
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.qr_code, size: 22),
                title: const Text('رمز QR'),
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon('رمز QR');
                },
              ),
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  Icons.pause_circle_outline,
                  color: Colors.orange[700],
                  size: 22,
                ),
                title: Text(
                  'إيقاف المتجر مؤقتاً',
                  style: TextStyle(color: Colors.orange[700]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon('إيقاف المتجر');
                },
              ),
              const Divider(height: 1),
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: const Icon(
                  Icons.logout_outlined,
                  color: Colors.orange,
                  size: 22,
                ),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: Colors.orange),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog();
                },
              ),
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                  size: 22,
                ),
                title: const Text(
                  'حذف المتجر',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteStoreDialog();
                },
              ),
            ],
          ),
        );
      },
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

  void _showComingSoon(String feature) {
    MbuySnackBar.show(
      context,
      message: '$feature - قريباً',
      type: MbuySnackBarType.info,
    );
  }
}
