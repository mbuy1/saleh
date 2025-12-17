import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/exports.dart';
import '../../../merchant/data/merchant_store_provider.dart';

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
                        size: 64,
                        color: AppTheme.textHintColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'لا يوجد متجر',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'يرجى إنشاء متجر أولاً',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
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
                      const SizedBox(height: 16),
                      _buildStoreInfoCard(store),
                      const SizedBox(height: 20),
                      _buildQuickStats(store),
                      const SizedBox(height: 24),
                      const MbuySectionTitle(title: 'إعدادات المتجر'),
                      const SizedBox(height: 12),
                      _buildSettingsList(),
                      const SizedBox(height: 24),
                      const MbuySectionTitle(title: 'خدمات إضافية'),
                      const SizedBox(height: 12),
                      _buildServicesGrid(),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
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
              fontSize: 20,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _showSettingsSheet(context);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.more_vert,
              size: 20,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreInfoCard(dynamic store) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.store, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store?.name ?? 'متجري',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: store?.isActive == true
                                ? Colors.green.withValues(alpha: 0.2)
                                : Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            store?.isActive == true ? 'نشط' : 'غير نشط',
                            style: TextStyle(
                              color: store?.isActive == true
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (store?.isVerified == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.lightBlueAccent,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'موثق',
                                  style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white70,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    store?.city ?? 'لم يتم تحديد المدينة',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: () => _editStoreInfo(context),
                  child: const Text(
                    'تعديل',
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

  Widget _buildQuickStats(dynamic store) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.star_outline,
            value: store?.rating?.toStringAsFixed(1) ?? '0.0',
            label: 'التقييم',
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            icon: Icons.people_outline,
            value: '${store?.followersCount ?? 0}',
            label: 'المتابعين',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            icon: Icons.inventory_2_outlined,
            value: '0',
            label: 'المنتجات',
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
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
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    final settings = [
      {
        'icon': Icons.info_outline,
        'title': 'معلومات المتجر',
        'subtitle': 'الاسم، الوصف، المدينة',
        'onTap': () => _editStoreInfo(context),
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
        'title': 'الإشعارات',
        'subtitle': 'تنبيهات الطلبات والرسائل',
        'onTap': () => context.push('/dashboard/notifications'),
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
                child: Icon(icon, color: AppTheme.primaryColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
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
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service['title'] as String,
                  style: TextStyle(
                    fontSize: 12,
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
        return Padding(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('مشاركة المتجر'),
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon('مشاركة المتجر');
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('رمز QR'),
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon('رمز QR');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.pause_circle_outline,
                  color: Colors.orange[700],
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
            ],
          ),
        );
      },
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
