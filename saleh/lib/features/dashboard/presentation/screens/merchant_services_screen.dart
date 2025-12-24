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

    // Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† ÙˆØ¬ÙˆØ¯ Ù…ØªØ¬Ø±
    if (store == null && !storeState.isLoading && !_isLoading) {
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
                        'Ù„Ø§ ÙŠÙˆØ¬Ø¯ Ù…ØªØ¬Ø±',
                        style: TextStyle(
                          fontSize: AppDimensions.fontDisplay3,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      const Text(
                        'ÙŠØ±Ø¬Ù‰ Ø¥Ù†Ø´Ø§Ø¡ Ù…ØªØ¬Ø± Ø£ÙˆÙ„Ø§Ù‹',
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
                        child: const Text('Ø¥Ù†Ø´Ø§Ø¡ Ù…ØªØ¬Ø±'),
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
                      const MbuySectionTitle(title: 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ù…ØªØ¬Ø±'),
                      const SizedBox(height: 12),
                      _buildSettingsList(),
                      const SizedBox(height: 24),
                      const MbuySectionTitle(title: 'Ø®Ø¯Ù…Ø§Øª Ø¥Ø¶Ø§ÙÙŠØ©'),
                      const SizedBox(height: 12),
                      _buildServicesGrid(),
                      const SizedBox(height: 24),
                      const MbuySectionTitle(title: 'Ø§Ù„Ø­Ø³Ø§Ø¨'),
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
            'Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ù…ØªØ¬Ø±',
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
            label: 'Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ù…ØªØ¬Ø±',
            color: AppTheme.primaryColor,
            onTap: () => context.push('/dashboard/store/create-store'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickTabItem(
            icon: Icons.palette_outlined,
            label: 'Ù…Ø¸Ù‡Ø± Ø§Ù„Ù…ØªØ¬Ø±',
            color: Colors.blue,
            onTap: () => context.push('/dashboard/webstore'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickTabItem(
            icon: Icons.notifications_outlined,
            label: 'Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª',
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
        'title': 'Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ù…ØªØ¬Ø±',
        'subtitle': 'Ø§Ù„Ø§Ø³Ù…ØŒ Ø§Ù„ÙˆØµÙØŒ Ø§Ù„Ù…Ø¯ÙŠÙ†Ø©',
        'onTap': () => context.push('/dashboard/store/create-store'),
        'enabled': true,
      },
      {
        'icon': Icons.palette_outlined,
        'title': 'ØªØ®ØµÙŠØµ Ø§Ù„Ù…ØªØ¬Ø±',
        'subtitle': 'Ø§Ù„Ø«ÙŠÙ…Ø§Øª ÙˆØ§Ù„ØµÙØ­Ø§Øª ÙˆØ§Ù„Ø¨Ø§Ù†Ø±Ø§Øª',
        'onTap': () => context.push('/dashboard/webstore'),
        'enabled': true,
      },
      {
        'icon': Icons.local_shipping_outlined,
        'title': 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø´Ø­Ù†',
        'subtitle': 'Ø§Ù„Ù…Ù†Ø§Ø·Ù‚ØŒ Ø§Ù„Ø£Ø³Ø¹Ø§Ø±ØŒ Ø§Ù„Ø´Ø±ÙƒØ§Øª',
        'onTap': () => context.push('/dashboard/shipping'),
        'enabled': true,
      },
      {
        'icon': Icons.payment_outlined,
        'title': 'Ø·Ø±Ù‚ Ø§Ù„Ø¯ÙØ¹',
        'subtitle': 'Ø§Ù„Ø¨Ø·Ø§Ù‚Ø§ØªØŒ Ø§Ù„ØªØ­ÙˆÙŠÙ„ØŒ Ø§Ù„Ø¯ÙØ¹ Ø¹Ù†Ø¯ Ø§Ù„Ø§Ø³ØªÙ„Ø§Ù…',
        'onTap': () => context.push('/dashboard/payment-methods'),
        'enabled': true,
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª',
        'subtitle': 'ØªÙ†Ø¨ÙŠÙ‡Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª ÙˆØ§Ù„Ø±Ø³Ø§Ø¦Ù„',
        'onTap': () => context.push('/notification-settings'),
        'enabled': true,
      },
      {
        'icon': Icons.palette_outlined,
        'title': 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ù…Ø¸Ù‡Ø±',
        'subtitle': 'Ø§Ù„Ù„ØºØ© ÙˆØ§Ù„Ø«ÙŠÙ… ÙˆØ§Ù„Ø£Ù„ÙˆØ§Ù†',
        'onTap': () => context.push('/appearance-settings'),
        'enabled': true,
      },
      {
        'icon': Icons.person_outline,
        'title': 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø­Ø³Ø§Ø¨',
        'subtitle': 'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ ÙˆÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±',
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
        'title': 'Ø§Ù„ØªÙ…ÙˆÙŠÙ„',
        'color': const Color(0xFF4CAF50),
        'route': '/dashboard/wallet',
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': 'Ø§Ù„Ø¯Ø¹Ù…',
        'color': const Color(0xFF2196F3),
        'route': '/dashboard/support',
      },
      {
        'icon': Icons.analytics_outlined,
        'title': 'Ø§Ù„ØªØ­Ù„ÙŠÙ„Ø§Øª',
        'color': const Color(0xFF9C27B0),
        'route': '/dashboard/reports',
      },
      {
        'icon': Icons.school_outlined,
        'title': 'Ø§Ù„ØªØ¯Ø±ÙŠØ¨',
        'color': const Color(0xFFFF9800),
        'route': null, // Ù‚Ø±ÙŠØ¨Ø§Ù‹
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
                      'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬',
                      style: TextStyle(
                        fontSize: AppDimensions.fontTitle,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing2),
                    Text(
                      'Ø§Ù„Ø®Ø±ÙˆØ¬ Ù…Ù† Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ø­Ø§Ù„ÙŠ',
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
                      'Ø­Ø°Ù Ø§Ù„Ù…ØªØ¬Ø±',
                      style: TextStyle(
                        fontSize: AppDimensions.fontTitle,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing2),
                    Text(
                      'Ø­Ø°Ù Ø§Ù„Ù…ØªØ¬Ø± ÙˆØ¬Ù…ÙŠØ¹ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ù†Ù‡Ø§Ø¦ÙŠØ§Ù‹',
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
        title: const Text('ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬'),
        content: const Text('Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬ØŸ'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
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
            child: const Text('ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬'),
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
            Text('Ø­Ø°Ù Ø§Ù„Ù…ØªØ¬Ø±'),
          ],
        ),
        content: const Text(
          'Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† Ø­Ø°Ù Ø§Ù„Ù…ØªØ¬Ø±ØŸ\n\nÙ‡Ø°Ø§ Ø§Ù„Ø¥Ø¬Ø±Ø§Ø¡ Ù„Ø§ ÙŠÙ…ÙƒÙ† Ø§Ù„ØªØ±Ø§Ø¬Ø¹ Ø¹Ù†Ù‡ ÙˆØ³ÙŠØªÙ… Ø­Ø°Ù Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              // TODO: ØªÙ†ÙÙŠØ° Ø­Ø°Ù Ø§Ù„Ù…ØªØ¬Ø±
              MbuySnackBar.show(
                context,
                message: 'Ø³ÙŠØªÙ… ØªÙØ¹ÙŠÙ„ Ù‡Ø°Ù‡ Ø§Ù„Ù…ÙŠØ²Ø© Ù‚Ø±ÙŠØ¨Ø§Ù‹',
                type: MbuySnackBarType.info,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ø­Ø°Ù Ù†Ù‡Ø§Ø¦ÙŠØ§Ù‹'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    MbuySnackBar.show(
      context,
      message: '$feature - Ù‚Ø±ÙŠØ¨Ø§Ù‹',
      type: MbuySnackBarType.info,
    );
  }
}
