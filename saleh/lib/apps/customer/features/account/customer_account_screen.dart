import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/controllers/root_controller.dart';

class CustomerAccountScreen extends ConsumerWidget {
  const CustomerAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual user data from API
    final user = CustomerUser(
      name: 'محمد أحمد',
      email: 'mohamed@example.com',
      phone: '+966512345678',
      avatarUrl: 'https://picsum.photos/100?random=90',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // User Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(user.avatarUrl),
                  onBackgroundImageError: (_, _) {},
                  child: user.avatarUrl.isEmpty
                      ? Text(user.name[0], style: const TextStyle(fontSize: 24))
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // Navigate to edit profile
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Switch to Merchant Account
          Container(
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.store, color: Colors.white),
              ),
              title: const Text(
                'التبديل لحساب التاجر',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('إدارة متجرك ومنتجاتك'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Switch to merchant app
                ref.read(rootControllerProvider.notifier).switchToMerchantApp();
              },
            ),
          ),
          const SizedBox(height: 24),

          // Menu Sections
          _buildMenuSection(
            context,
            title: 'طلباتي',
            items: [
              _MenuItem(
                icon: Icons.local_shipping,
                title: 'طلباتي',
                subtitle: 'تتبع طلباتك الحالية والسابقة',
                onTap: () => context.push('/orders'),
              ),
              _MenuItem(
                icon: Icons.favorite,
                title: 'المفضلة',
                subtitle: 'المنتجات التي أعجبتك',
                onTap: () => context.push('/favorites'),
              ),
              _MenuItem(
                icon: Icons.rate_review,
                title: 'تقييماتي',
                subtitle: 'تقييمات المنتجات التي اشتريتها',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildMenuSection(
            context,
            title: 'العناوين والدفع',
            items: [
              _MenuItem(
                icon: Icons.location_on,
                title: 'عناويني',
                subtitle: 'إدارة عناوين التوصيل',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.credit_card,
                title: 'وسائل الدفع',
                subtitle: 'البطاقات المحفوظة',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildMenuSection(
            context,
            title: 'الإعدادات',
            items: [
              _MenuItem(
                icon: Icons.notifications,
                title: 'الإشعارات',
                subtitle: 'إدارة تفضيلات الإشعارات',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.language,
                title: 'اللغة',
                subtitle: 'العربية',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.help,
                title: 'المساعدة والدعم',
                subtitle: 'الأسئلة الشائعة وتواصل معنا',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.info,
                title: 'عن التطبيق',
                subtitle: 'الإصدار 1.0.0',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog(context, ref);
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          ...items.map((item) => _buildMenuItem(item)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(item.icon, size: 20, color: Colors.grey[700]),
      ),
      title: Text(item.title),
      subtitle: Text(
        item.subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: item.onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(rootControllerProvider.notifier).reset();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class CustomerUser {
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;

  CustomerUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
  });
}
