import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../auth/data/auth_controller.dart';

/// Ø´Ø§Ø´Ø© Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ø´Ø®ØµÙŠ
class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
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
      body: SafeArea(
        child: Column(
          children: [
            // Header Ø«Ø§Ø¨Øª ÙÙŠ Ø§Ù„Ø£Ø¹Ù„Ù‰
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildHeader(context),
            ),
            const SizedBox(height: 16),
            // Ø§Ù„Ù…Ø­ØªÙˆÙ‰ Ø§Ù„Ù‚Ø§Ø¨Ù„ Ù„Ù„ØªÙ…Ø±ÙŠØ±
            Expanded(
              child: ListView(
                padding: AppDimensions.paddingM,
                children: [
                  // Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ø­Ø³Ø§Ø¨
                  _buildSectionTitle('Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ø­Ø³Ø§Ø¨'),
                  _buildSettingsCard([
                    _buildInfoTile(
                      icon: AppIcons.email,
                      title: 'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ',
                      subtitle: authState.userEmail ?? 'ØºÙŠØ± Ù…Ø­Ø¯Ø¯',
                    ),
                    const Divider(height: 1),
                    _buildInfoTile(
                      icon: AppIcons.person,
                      title: 'Ù†ÙˆØ¹ Ø§Ù„Ø­Ø³Ø§Ø¨',
                      subtitle: authState.userRole == 'merchant'
                          ? 'ØªØ§Ø¬Ø±'
                          : 'Ø¹Ù…ÙŠÙ„',
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Ø§Ù„Ø£Ù…Ø§Ù†
                  _buildSectionTitle('Ø§Ù„Ø£Ù…Ø§Ù†'),
                  _buildSettingsCard([
                    _buildActionTile(
                      icon: AppIcons.lock,
                      title: 'ØªØºÙŠÙŠØ± ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±',
                      onTap: () => _showChangePasswordDialog(),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª
                  _buildSectionTitle('Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª'),
                  _buildSettingsCard([
                    _buildActionTile(
                      icon: AppIcons.notifications,
                      title: 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø§Ù„Ù…ØªÙ‚Ø¯Ù…Ø©',
                      onTap: () => context.push('/notification-settings'),
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      icon: AppIcons.notifications,
                      title: 'Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø§Ù„ØªØ·Ø¨ÙŠÙ‚',
                      subtitle: 'Ø§Ø³ØªÙ„Ø§Ù… Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª ÙˆØ§Ù„ØªØ­Ø¯ÙŠØ«Ø§Øª',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _notificationsEnabled = value);
                      },
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      icon: AppIcons.email,
                      title: 'Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø§Ù„Ø¨Ø±ÙŠØ¯',
                      subtitle: 'Ø§Ø³ØªÙ„Ø§Ù… ØªØ­Ø¯ÙŠØ«Ø§Øª Ø¹Ø¨Ø± Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ',
                      value: _emailNotifications,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _emailNotifications = value);
                      },
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      icon: AppIcons.megaphone,
                      title: 'Ø±Ø³Ø§Ø¦Ù„ ØªØ³ÙˆÙŠÙ‚ÙŠØ©',
                      subtitle: 'Ø§Ø³ØªÙ„Ø§Ù… Ø¹Ø±ÙˆØ¶ ÙˆØ£Ø®Ø¨Ø§Ø± Mbuy',
                      value: _marketingEmails,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() => _marketingEmails = value);
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Ø§Ù„Ù„ØºØ© ÙˆØ§Ù„Ù…Ø¸Ù‡Ø±
                  _buildSectionTitle('Ø§Ù„Ù„ØºØ© ÙˆØ§Ù„Ù…Ø¸Ù‡Ø±'),
                  _buildSettingsCard([
                    _buildActionTile(
                      icon: AppIcons.sun,
                      title: 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ù…Ø¸Ù‡Ø±',
                      onTap: () => context.push('/appearance-settings'),
                    ),
                    const Divider(height: 1),
                    _buildDropdownTile(
                      icon: AppIcons.globe,
                      title: 'Ø§Ù„Ù„ØºØ©',
                      value: _selectedLanguage,
                      items: const [
                        DropdownMenuItem(value: 'ar', child: Text('Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©')),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedLanguage = value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Ø³ÙŠØªÙ… ØªØ·Ø¨ÙŠÙ‚ Ø§Ù„Ù„ØºØ© Ø¹Ù†Ø¯ Ø¥Ø¹Ø§Ø¯Ø© ØªØ´ØºÙŠÙ„ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚',
                              ),
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

                  // Ø§Ù„Ù‚Ø§Ù†ÙˆÙ†ÙŠ
                  _buildSectionTitle('Ø§Ù„Ù‚Ø§Ù†ÙˆÙ†ÙŠ'),
                  _buildSettingsCard([
                    _buildActionTile(
                      icon: AppIcons.document,
                      title: 'Ø³ÙŠØ§Ø³Ø© Ø§Ù„Ø®ØµÙˆØµÙŠØ©',
                      onTap: () => context.push('/privacy-policy'),
                    ),
                    const Divider(height: 1),
                    _buildActionTile(
                      icon: AppIcons.document,
                      title: 'Ø´Ø±ÙˆØ· Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù…',
                      onTap: () => context.push('/terms'),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Ø¥Ø¬Ø±Ø§Ø¡Ø§Øª Ø§Ù„Ø­Ø³Ø§Ø¨
                  _buildSectionTitle('Ø¥Ø¬Ø±Ø§Ø¡Ø§Øª Ø§Ù„Ø­Ø³Ø§Ø¨'),
                  _buildSettingsCard([
                    _buildActionTile(
                      icon: AppIcons.logout,
                      title: 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬',
                      titleColor: AppTheme.warningColor,
                      onTap: () => _showLogoutDialog(),
                    ),
                    const Divider(height: 1),
                    _buildActionTile(
                      icon: AppIcons.delete,
                      title: 'Ø­Ø°Ù Ø§Ù„Ø­Ø³Ø§Ø¨',
                      titleColor: AppTheme.errorColor,
                      onTap: () => _showDeleteAccountDialog(),
                    ),
                  ]),

                  const SizedBox(height: 40),

                  // Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„ØªØ·Ø¨ÙŠÙ‚
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
                          'Â© 2025 Mbuy. Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø­Ù‚ÙˆÙ‚ Ù…Ø­ÙÙˆØ¸Ø©',
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
            ),
          ],
        ),
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
        style: const TextStyle(fontSize: 14, color: AppTheme.mutedSlate),
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
          child: AppIcon(
            icon,
            size: 20,
            color: titleColor ?? AppTheme.primaryColor,
          ),
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
        style: TextStyle(fontSize: 12, color: AppTheme.mutedSlate),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.5),
        activeThumbColor: AppTheme.primaryColor,
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
        title: const Text('ØªØºÙŠÙŠØ± ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø§Ù„Ø­Ø§Ù„ÙŠØ©',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø§Ù„Ø¬Ø¯ÙŠØ¯Ø©',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'ØªØ£ÙƒÙŠØ¯ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± ØºÙŠØ± Ù…ØªØ·Ø§Ø¨Ù‚Ø©'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ØªÙ… ØªØºÙŠÙŠØ± ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø¨Ù†Ø¬Ø§Ø­'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('ØªØºÙŠÙŠØ±'),
          ),
        ],
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
              if (!mounted) return;
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
            ),
            child: const Text('ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ø­Ø°Ù Ø§Ù„Ø­Ø³Ø§Ø¨'),
        content: const Text(
          'Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† Ø­Ø°Ù Ø­Ø³Ø§Ø¨ÙƒØŸ\n\n'
          'Ù‡Ø°Ø§ Ø§Ù„Ø¥Ø¬Ø±Ø§Ø¡ Ù„Ø§ ÙŠÙ…ÙƒÙ† Ø§Ù„ØªØ±Ø§Ø¬Ø¹ Ø¹Ù†Ù‡ ÙˆØ³ÙŠØªÙ… Ø­Ø°Ù Ø¬Ù…ÙŠØ¹ Ø¨ÙŠØ§Ù†Ø§ØªÙƒ Ø¨Ø´ÙƒÙ„ Ù†Ù‡Ø§Ø¦ÙŠ.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'ØªÙ… Ø¥Ø±Ø³Ø§Ù„ Ø·Ù„Ø¨ Ø­Ø°Ù Ø§Ù„Ø­Ø³Ø§Ø¨. Ø³ÙŠØªÙ… Ø§Ù„ØªÙˆØ§ØµÙ„ Ù…Ø¹Ùƒ Ø®Ù„Ø§Ù„ 24 Ø³Ø§Ø¹Ø©.',
                  ),
                  backgroundColor: AppTheme.infoColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Ø­Ø°Ù Ø§Ù„Ø­Ø³Ø§Ø¨'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusS,
            ),
            child: AppIcon(
              AppIcons.arrowBack,
              size: AppDimensions.iconS,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        const Expanded(
          child: Text(
            'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø­Ø³Ø§Ø¨',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.iconM + AppDimensions.spacing16),
      ],
    );
  }
}
