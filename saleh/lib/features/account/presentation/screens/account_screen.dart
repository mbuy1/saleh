import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../core/controllers/root_controller.dart';
import '../../../../shared/widgets/coming_soon_dialog.dart';
import '../../../merchant/data/merchant_store_provider.dart';
import '../../../auth/data/auth_controller.dart';

/// صفحة الحساب - تصميم مشابه لفيسبوك
class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storeAsync = ref.watch(merchantStoreControllerProvider);
    final store = storeAsync.hasValue ? storeAsync.value : null;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundColorDark
          : const Color(0xFFF0F2F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // زر تبديل الوضع الداكن
                    _buildThemeToggle(context, isDark),
                    const Spacer(),
                    Text(
                      'الحساب',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // بطاقة الحساب الرئيسية
            SliverToBoxAdapter(
              child: _buildAccountCard(context, isDark, store),
            ),

            // القائمة الرئيسية
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildMenuGrid(context, isDark),
              ),
            ),

            // زر عرض المزيد
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildShowMoreButton(context, isDark),
              ),
            ),

            // قسم الإعدادات
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildSettingsSection(context, isDark),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, bool isDark) {
    return Tooltip(
      message: isDark ? 'تفعيل الوضع الفاتح' : 'تفعيل الوضع الداكن',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
          ref.read(preferencesStateProvider.notifier).updateThemeMode(newMode);
        },
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: isDark ? Colors.amber : AppTheme.primaryColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, bool isDark, dynamic store) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardColorDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // زر تبديل الحساب
          GestureDetector(
            onTap: () => _showAccountSwitcher(context, isDark, store),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: isDark ? Colors.white : Colors.black87,
                size: 20,
              ),
            ),
          ),
          const Spacer(),
          // اسم المتجر والصورة
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                store?.name ?? 'متجري',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // صورة الحساب
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColor, width: 2),
            ),
            child: ClipOval(
              child: store?.logoUrl != null
                  ? Image.network(
                      store!.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultAvatar(isDark),
                    )
                  : _buildDefaultAvatar(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(bool isDark) {
    return Container(
      color: isDark ? Colors.grey[700] : Colors.grey[300],
      child: Icon(
        Icons.storefront,
        color: isDark ? Colors.white54 : Colors.grey[600],
        size: 28,
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, bool isDark) {
    final items = [
      _MenuItem(
        icon: Icons.edit_outlined,
        label: 'تعديل الحساب',
        onTap: () => context.push('/settings'),
      ),
      _MenuItem(
        icon: Icons.notifications_outlined,
        label: 'الاشعارات',
        onTap: () => context.push('/notification-settings'),
      ),
      _MenuItem(
        icon: Icons.lightbulb_outline,
        label: 'الاقتراحات',
        onTap: () => ComingSoonDialog.show(
          context,
          featureName: 'الاقتراحات',
          description:
              'شاركنا أفكارك واقتراحاتك لتحسين التطبيق!\nنحن نستمع إليك دائماً.',
          icon: Icons.lightbulb_outline,
        ),
      ),
      _MenuItem(
        icon: Icons.system_update_outlined,
        label: 'تحديثات المنصة',
        onTap: () => ComingSoonDialog.show(
          context,
          featureName: 'تحديثات المنصة',
          description: 'تابع آخر التحديثات والميزات الجديدة في mbuy!',
          icon: Icons.system_update_outlined,
        ),
      ),
      _MenuItem(
        icon: Icons.bookmark_outline,
        label: 'المحفوظات',
        onTap: () => ComingSoonDialog.show(
          context,
          featureName: 'المحفوظات',
          description: 'احفظ المنتجات والعناصر المفضلة للوصول إليها بسهولة.',
          icon: Icons.bookmark_outline,
        ),
      ),
      _MenuItem(
        icon: Icons.card_membership_outlined,
        label: 'باقة المتجر',
        onTap: () => ComingSoonDialog.show(
          context,
          featureName: 'باقة المتجر',
          description: 'اختر الباقة المناسبة لمتجرك واستمتع بميزات حصرية!',
          icon: Icons.card_membership_outlined,
        ),
      ),
      _MenuItem(
        icon: Icons.stars_outlined,
        label: 'اكسب نقاط',
        onTap: () => ComingSoonDialog.show(
          context,
          featureName: 'اكسب نقاط',
          description: 'اكسب نقاط مع كل عملية واستبدلها بمكافآت رائعة!',
          icon: Icons.stars_outlined,
        ),
      ),
      _MenuItem(
        icon: Icons.groups_outlined,
        label: 'المجتمع',
        onTap: () => ComingSoonDialog.show(
          context,
          featureName: 'مجتمع mbuy',
          description:
              'انضم لمجتمع التجار وشارك خبراتك واستفد من تجارب الآخرين!',
          icon: Icons.groups_outlined,
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildMenuItem(context, isDark, item);
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, bool isDark, _MenuItem item) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        item.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardColorDark : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              item.icon,
              size: 22,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowMoreButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // عرض المزيد من الخيارات
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'عرض المزيد',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, bool isDark) {
    return Column(
      children: [
        // زر التبديل لحساب العميل
        _buildSwitchToCustomerButton(context, isDark),
        const SizedBox(height: 8),
        _buildSettingsItem(
          context,
          isDark,
          icon: Icons.help_outline,
          label: 'المساعدة والدعم',
          onTap: () => context.push('/support'),
        ),
        const SizedBox(height: 8),
        _buildSettingsItem(
          context,
          isDark,
          icon: Icons.settings_outlined,
          label: 'الإعدادات والخصوصية',
          onTap: () => context.push('/settings'),
        ),
        const SizedBox(height: 8),
        _buildSettingsItem(
          context,
          isDark,
          icon: Icons.delete_forever_outlined,
          label: 'حذف المتجر',
          onTap: () => _showDeleteStoreDialog(context, isDark),
          isDestructive: true,
        ),
        const SizedBox(height: 16),
        _buildLogoutButton(context, isDark),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final textColor = isDestructive
        ? (isDark ? Colors.red[300] : Colors.red)
        : (isDark ? Colors.white : Colors.black87);
    final iconColor = isDestructive
        ? (isDark ? Colors.red[300] : Colors.red)
        : (isDark ? Colors.white70 : Colors.black54);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardColorDark : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.keyboard_arrow_down,
              color: isDark ? Colors.white54 : Colors.grey[600],
              size: 22,
            ),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDestructive
                    ? (isDark
                          ? Colors.red.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.1))
                    : (isDark ? Colors.grey[800] : Colors.grey[100]),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }

  /// زر التبديل لحساب العميل (التسوق)
  Widget _buildSwitchToCustomerButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(rootControllerProvider.notifier).switchToCustomerApp();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
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
                    'التبديل لوضع التسوق',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'تصفح المتاجر وتسوق كعميل',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تسجيل الخروج'),
            content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );

        if (confirm == true && context.mounted) {
          await ref.read(authControllerProvider.notifier).logout();
          if (context.mounted) {
            context.go('/login');
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.red.withValues(alpha: 0.2)
              : Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.red[300] : Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.logout,
                color: isDark ? Colors.red[300] : Colors.red,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAccountSwitcher(BuildContext context, bool isDark, dynamic store) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardColorDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // الحساب الحالي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // علامة التحديد
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        store?.name ?? 'متجري',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: store?.logoUrl != null
                          ? Image.network(store!.logoUrl!, fit: BoxFit.cover)
                          : _buildDefaultAvatar(isDark),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),

            // إنشاء متجر جديد
            ListTile(
              leading: const Icon(Icons.more_horiz),
              title: const Text('إنشاء متجر جديد', textAlign: TextAlign.right),
              trailing: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add),
              ),
              onTap: () {
                Navigator.pop(context);
                // إنشاء متجر جديد
              },
            ),

            const SizedBox(height: 16),

            // انتقال إلى مركز الحسابات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // مركز الحسابات
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      'انتقال إلى مركز الحسابات',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // شعار mbuy
            Text(
              'mbuy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteStoreDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.cardColorDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'حذف المتجر',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف متجرك؟\n\nسيتم حذف جميع المنتجات والطلبات والبيانات المرتبطة بالمتجر نهائياً.\n\nهذا الإجراء لا يمكن التراجع عنه!',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ComingSoonDialog.show(
                context,
                featureName: 'حذف المتجر',
                description:
                    'ميزة حذف المتجر ستكون متاحة قريباً.\nللمساعدة تواصل مع الدعم الفني.',
                icon: Icons.delete_forever_outlined,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('حذف المتجر'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _MenuItem({required this.icon, required this.label, required this.onTap});
}
