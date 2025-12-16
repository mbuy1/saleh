import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../auth/data/auth_controller.dart';

/// شاشة إعدادات الحساب الشخصي
class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _marketingEmails = false;
  String _selectedLanguage = 'ar';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.arrowBack, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'إعدادات الحساب',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppDimensions.paddingM,
        children: [
          // معلومات الحساب
          _buildSectionTitle('معلومات الحساب'),
          _buildSettingsCard([
            _buildInfoTile(
              icon: AppIcons.email,
              title: 'البريد الإلكتروني',
              subtitle: authState.userEmail ?? 'غير محدد',
            ),
            const Divider(height: 1),
            _buildInfoTile(
              icon: AppIcons.person,
              title: 'نوع الحساب',
              subtitle: authState.userRole == 'merchant' ? 'تاجر' : 'عميل',
            ),
          ]),

          const SizedBox(height: 24),

          // الأمان
          _buildSectionTitle('الأمان'),
          _buildSettingsCard([
            _buildActionTile(
              icon: AppIcons.lock,
              title: 'تغيير كلمة المرور',
              onTap: () => _showChangePasswordDialog(),
            ),
          ]),

          const SizedBox(height: 24),

          // الإشعارات
          _buildSectionTitle('الإشعارات'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: AppIcons.notifications,
              title: 'إشعارات التطبيق',
              subtitle: 'استلام إشعارات الطلبات والتحديثات',
              value: _notificationsEnabled,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() => _notificationsEnabled = value);
              },
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              icon: AppIcons.email,
              title: 'إشعارات البريد',
              subtitle: 'استلام تحديثات عبر البريد الإلكتروني',
              value: _emailNotifications,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() => _emailNotifications = value);
              },
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              icon: AppIcons.megaphone,
              title: 'رسائل تسويقية',
              subtitle: 'استلام عروض وأخبار Mbuy',
              value: _marketingEmails,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() => _marketingEmails = value);
              },
            ),
          ]),

          const SizedBox(height: 24),

          // اللغة والمظهر
          _buildSectionTitle('اللغة والمظهر'),
          _buildSettingsCard([
            _buildDropdownTile(
              icon: AppIcons.globe,
              title: 'اللغة',
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedLanguage = value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('سيتم تطبيق اللغة عند إعادة تشغيل التطبيق'),
                      backgroundColor: AppTheme.infoColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDimensions.borderRadiusS,
                      ),
                    ),
                  );
                }
              },
            ),
          ]),

          const SizedBox(height: 24),

          // القانوني
          _buildSectionTitle('القانوني'),
          _buildSettingsCard([
            _buildActionTile(
              icon: AppIcons.document,
              title: 'سياسة الخصوصية',
              onTap: () => context.push('/privacy-policy'),
            ),
            const Divider(height: 1),
            _buildActionTile(
              icon: AppIcons.document,
              title: 'شروط الاستخدام',
              onTap: () => context.push('/terms'),
            ),
          ]),

          const SizedBox(height: 24),

          // إجراءات الحساب
          _buildSectionTitle('إجراءات الحساب'),
          _buildSettingsCard([
            _buildActionTile(
              icon: AppIcons.logout,
              title: 'تسجيل الخروج',
              titleColor: AppTheme.warningColor,
              onTap: () => _showLogoutDialog(),
            ),
            const Divider(height: 1),
            _buildActionTile(
              icon: AppIcons.delete,
              title: 'حذف الحساب',
              titleColor: AppTheme.errorColor,
              onTap: () => _showDeleteAccountDialog(),
            ),
          ]),

          const SizedBox(height: 40),

          // معلومات التطبيق
          Center(
            child: Column(
              children: [
                Text(
                  'Mbuy v1.0.0',
                  style: TextStyle(
                    color: AppTheme.mutedSlate,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '© 2025 Mbuy. جميع الحقوق محفوظة',
                  style: TextStyle(
                    color: AppTheme.mutedSlate,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusL,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AppIcon(icon, size: 20, color: AppTheme.primaryColor),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.mutedSlate,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (titleColor ?? AppTheme.primaryColor).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AppIcon(icon, size: 20, color: titleColor ?? AppTheme.primaryColor),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppTheme.textPrimaryColor,
        ),
      ),
      trailing: AppIcon(AppIcons.chevronLeft, size: 16, color: Colors.grey),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  Widget _buildSwitchTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AppIcon(icon, size: 20, color: AppTheme.primaryColor),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.mutedSlate,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildDropdownTile<T>({
    required String icon,
    required String title,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AppIcon(icon, size: 20, color: AppTheme.primaryColor),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: AppIcon(AppIcons.chevronDown, size: 16, color: Colors.grey),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغيير كلمة المرور'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الحالية',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الجديدة',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'تأكيد كلمة المرور',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('كلمة المرور غير متطابقة'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تغيير كلمة المرور بنجاح'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('تغيير'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
              if (mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: const Text(
          'هل أنت متأكد من حذف حسابك؟\n\n'
          'هذا الإجراء لا يمكن التراجع عنه وسيتم حذف جميع بياناتك بشكل نهائي.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال طلب حذف الحساب. سيتم التواصل معك خلال 24 ساعة.'),
                  backgroundColor: AppTheme.infoColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('حذف الحساب'),
          ),
        ],
      ),
    );
  }
}
