import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/controllers/root_controller.dart';
import '../../../auth/data/auth_controller.dart';

/// صفحة الملف الشخصي للعميل
/// ⚠️ هذه الصفحة خاصة بتطبيق العميل فقط - لا تحتوي أي عناصر تاجر
class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final userEmail = authState.userEmail ?? 'عميل';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'حسابي',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          _buildProfileHeader(context, userEmail),
          const SizedBox(height: 24),

          // Orders Section
          _buildSectionTitle('طلباتي'),
          const SizedBox(height: 12),
          _buildOrdersRow(context),
          const SizedBox(height: 24),

          // Account Settings
          _buildSectionTitle('إعدادات الحساب'),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildSettingsTile(Icons.person_outline, 'معلوماتي الشخصية', () {}),
            _buildSettingsTile(
              Icons.location_on_outlined,
              'عناوين التوصيل',
              () {},
            ),
            _buildSettingsTile(Icons.payment_outlined, 'طرق الدفع', () {}),
            _buildSettingsTile(Icons.favorite_outline, 'المفضلة', () {}),
          ]),
          const SizedBox(height: 24),

          // Support Section
          _buildSectionTitle('الدعم'),
          const SizedBox(height: 12),
          _buildSettingsCard([
            _buildSettingsTile(Icons.help_outline, 'مركز المساعدة', () {}),
            _buildSettingsTile(Icons.chat_outlined, 'تواصل معنا', () {}),
            _buildSettingsTile(Icons.policy_outlined, 'سياسة الخصوصية', () {}),
            _buildSettingsTile(
              Icons.description_outlined,
              'الشروط والأحكام',
              () {},
            ),
          ]),
          const SizedBox(height: 24),

          // زر الرجوع للوحة التحكم - يظهر فقط إذا دخل التاجر عبر Switch
          _buildBackToMerchantButton(context, ref),

          // Logout Button - لا يوجد زر تبديل للتاجر في تطبيق العميل
          _buildLogoutButton(context, ref),
          const SizedBox(height: 32),

          // App Version
          Center(
            child: Text(
              'الإصدار 1.0.0',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String userEmail) {
    // استخراج اسم المستخدم من الإيميل
    final userName = userEmail.contains('@')
        ? userEmail.split('@').first
        : userEmail;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white24,
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً، $userName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Edit Profile
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildOrdersRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOrderStatus(
            Icons.pending_actions,
            'قيد الانتظار',
            '2',
            Colors.orange,
          ),
          _buildOrderStatus(
            Icons.local_shipping_outlined,
            'جاري التوصيل',
            '1',
            Colors.blue,
          ),
          _buildOrderStatus(
            Icons.check_circle_outline,
            'تم التسليم',
            '5',
            Colors.green,
          ),
          _buildOrderStatus(Icons.cancel_outlined, 'ملغي', '0', Colors.red),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(
    IconData icon,
    String label,
    String count,
    Color color,
  ) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 28, color: color),
                if (count != '0')
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> tiles) {
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
      child: Column(children: tiles),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.primaryColor),
          title: Text(title),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () {
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
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  // تسجيل الخروج والعودة لشاشة تسجيل الدخول
                  ref.read(authControllerProvider.notifier).logout();
                  ref.read(rootControllerProvider.notifier).reset();
                },
                child: Text('خروج', style: TextStyle(color: Colors.red[600])),
              ),
            ],
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red[600],
        side: BorderSide(color: Colors.red[300]!),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.logout),
      label: const Text('تسجيل الخروج'),
    );
  }

  /// زر الرجوع للوحة التحكم - يظهر فقط للتاجر الذي دخل عبر Switch
  Widget _buildBackToMerchantButton(BuildContext context, WidgetRef ref) {
    final canSwitchBack = ref.watch(canSwitchBackToMerchantProvider);

    // لا تعرض الزر إذا لم يأتِ من لوحة التاجر
    if (!canSwitchBack) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          ref
              .read(rootControllerProvider.notifier)
              .switchBackToMerchantDashboard();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.dashboard_outlined),
        label: const Text('العودة للوحة التحكم'),
      ),
    );
  }
}
