import 'package:flutter/material.dart';
import '../../../../core/app_config.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/auth_service.dart';
import '../screens/merchant_store_setup_screen.dart';
import '../screens/merchant_points_screen.dart';

class MerchantProfileTab extends StatefulWidget {
  final AppModeProvider appModeProvider;

  const MerchantProfileTab({super.key, required this.appModeProvider});

  @override
  State<MerchantProfileTab> createState() => _MerchantProfileTabState();
}

class _MerchantProfileTabState extends State<MerchantProfileTab> {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return;

      final response = await supabaseClient
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      setState(() {
        _userProfile = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب البيانات: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AuthService.signOut();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في تسجيل الخروج: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabaseClient.auth.currentUser;

    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text(
          'الحساب',
          style: TextStyle(color: MbuyColors.textPrimary, fontFamily: 'Arabic'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // أيقونة المستخدم
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: MbuyColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.store,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // الاسم المعروض
                  Text(
                    _userProfile?['display_name'] ?? 'تاجر',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.textPrimary,
                      fontFamily: 'Arabic',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // البريد الإلكتروني
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: MbuyColors.textSecondary,
                      fontFamily: 'Arabic',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // شارة التاجر
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: MbuyColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'حساب تاجر',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arabic',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر التبديل لوضع العميل
                  Card(
                    color: MbuyColors.surfaceLight,
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MbuyColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: MbuyColors.primaryBlue,
                        ),
                      ),
                      title: const Text(
                        'التبديل لوضع العميل',
                        style: TextStyle(
                          color: MbuyColors.textPrimary,
                          fontFamily: 'Arabic',
                        ),
                      ),
                      subtitle: const Text(
                        'اعرض التطبيق كعميل',
                        style: TextStyle(
                          color: MbuyColors.textSecondary,
                          fontFamily: 'Arabic',
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: MbuyColors.textSecondary,
                      ),
                      onTap: () {
                        widget.appModeProvider.setCustomerMode();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // إدارة المتجر والنقاط
                  Card(
                    color: MbuyColors.surfaceLight,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: MbuyColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.store, color: Colors.white),
                          ),
                          title: const Text(
                            'إدارة المتجر',
                            style: TextStyle(
                              color: MbuyColors.textPrimary,
                              fontFamily: 'Arabic',
                            ),
                          ),
                          subtitle: const Text(
                            'تعديل معلومات متجرك',
                            style: TextStyle(
                              color: MbuyColors.textSecondary,
                              fontFamily: 'Arabic',
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: MbuyColors.textSecondary,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MerchantStoreSetupScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: MbuyColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.stars, color: Colors.white),
                          ),
                          title: const Text(
                            'نقاط التاجر',
                            style: TextStyle(
                              color: MbuyColors.textPrimary,
                              fontFamily: 'Arabic',
                            ),
                          ),
                          subtitle: const Text(
                            'استخدم نقاطك للمميزات',
                            style: TextStyle(
                              color: MbuyColors.textSecondary,
                              fontFamily: 'Arabic',
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: MbuyColors.textSecondary,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MerchantPointsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // الإعدادات
                  Card(
                    color: MbuyColors.surfaceLight,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.notifications_outlined),
                          title: const Text(
                            'إعدادات الإشعارات',
                            style: TextStyle(
                              color: MbuyColors.textPrimary,
                              fontFamily: 'Arabic',
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: MbuyColors.textSecondary,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('قريباً: إعدادات الإشعارات'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.help_outline),
                          title: const Text(
                            'المساعدة والدعم',
                            style: TextStyle(
                              color: MbuyColors.textPrimary,
                              fontFamily: 'Arabic',
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: MbuyColors.textSecondary,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('قريباً: المساعدة والدعم'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text(
                            'حول التطبيق',
                            style: TextStyle(
                              color: MbuyColors.textPrimary,
                              fontFamily: 'Arabic',
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: MbuyColors.textSecondary,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('قريباً: حول التطبيق'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر تسجيل الخروج
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleSignOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Arabic',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
