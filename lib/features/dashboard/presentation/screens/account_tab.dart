import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/data/auth_controller.dart';

/// شاشة الحساب - Account Tab
/// تعرض معلومات المستخدم وإعدادات الحساب
class AccountTab extends ConsumerWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // معلومات المستخدم
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  authState.userRole ?? 'مستخدم',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (authState.userId != null)
                  Text(
                    'ID: ${authState.userId}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // الإعدادات
        Text(
          'الإعدادات',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              _AccountMenuItem(
                icon: Icons.person_outline,
                title: 'الملف الشخصي',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('قريباً: الملف الشخصي')),
                  );
                },
              ),
              const Divider(height: 1),
              _AccountMenuItem(
                icon: Icons.store_outlined,
                title: 'إعدادات المتجر',
                onTap: () {
                  // الانتقال لشاشة إدارة المتجر
                  context.push('/create-store');
                },
              ),
              const Divider(height: 1),
              _AccountMenuItem(
                icon: Icons.notifications_outlined,
                title: 'الإشعارات',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('قريباً: الإشعارات')),
                  );
                },
              ),
              const Divider(height: 1),
              _AccountMenuItem(
                icon: Icons.language,
                title: 'اللغة',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('قريباً: تغيير اللغة')),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // الدعم
        Text(
          'الدعم',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              _AccountMenuItem(
                icon: Icons.help_outline,
                title: 'المساعدة والدعم',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('قريباً: المساعدة والدعم')),
                  );
                },
              ),
              const Divider(height: 1),
              _AccountMenuItem(
                icon: Icons.info_outline,
                title: 'حول التطبيق',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'MBUY Merchant',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2025 MBUY',
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // زر تسجيل الخروج
        FilledButton.icon(
          onPressed: () async {
            // تأكيد تسجيل الخروج
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('تسجيل الخروج'),
                content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('إلغاء'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('تسجيل الخروج'),
                  ),
                ],
              ),
            );

            if (shouldLogout == true) {
              // تسجيل الخروج
              await ref.read(authControllerProvider.notifier).logout();

              // الانتقال إلى صفحة تسجيل الدخول
              if (context.mounted) {
                context.go('/login');
              }
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('تسجيل الخروج'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

/// عنصر قائمة في شاشة الحساب
class _AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AccountMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
