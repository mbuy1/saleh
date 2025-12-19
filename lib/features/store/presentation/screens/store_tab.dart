import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/auth_controller.dart';

/// صفحة المتجر - Store Tab
/// تحتوي على إدارة المتجر ومظهر المتجر ورابط المتجر
class StoreTab extends ConsumerWidget {
  const StoreTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'المتجر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.fontHeadline,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppTheme.primaryColor,
          size: AppDimensions.iconM,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppDimensions.paddingM,
          children: [
            // قسم إعدادات المتجر
            _buildSectionTitle('إعدادات المتجر'),
            SizedBox(height: AppDimensions.spacing12),
            // معلومات المتجر
            _buildStoreOptionCard(
              context: context,
              icon: Icons.store_outlined,
              title: 'معلومات المتجر',
              subtitle: 'تعديل اسم ووصف المتجر',
              onTap: () => context.push('/dashboard/store/create-store'),
            ),
            SizedBox(height: AppDimensions.spacing12),
            // متجرك الإلكتروني
            _buildStoreOptionCard(
              context: context,
              icon: Icons.storefront_outlined,
              title: 'متجرك الإلكتروني',
              subtitle: 'تخصيص مظهر وتصميم المتجر',
              onTap: () => context.push('/dashboard/webstore'),
            ),
            SizedBox(height: AppDimensions.spacing24),
            // قسم خيارات إضافية
            _buildSectionTitle('خيارات إضافية'),
            SizedBox(height: AppDimensions.spacing12),
            // سجل تجاري
            _buildStoreOptionCard(
              context: context,
              icon: Icons.description_outlined,
              title: 'سجل تجاري',
              subtitle: 'إدارة وثائق السجل التجاري',
              onTap: () => context.push(
                '/dashboard/feature/${Uri.encodeComponent('سجل تجاري')}',
              ),
            ),
            SizedBox(height: AppDimensions.spacing12),
            // الدعم الفني
            _buildStoreOptionCard(
              context: context,
              icon: Icons.support_agent_outlined,
              title: 'الدعم الفني',
              subtitle: 'تواصل مع فريق الدعم',
              onTap: () => context.push(
                '/dashboard/feature/${Uri.encodeComponent('الدعم الفني')}',
              ),
            ),
            SizedBox(height: AppDimensions.spacing24),
            // قسم تسجيل الخروج
            _buildSectionTitle('الحساب'),
            SizedBox(height: AppDimensions.spacing12),
            // تسجيل الخروج
            _buildLogoutCard(context: context, ref: ref),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
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
              if (context.mounted) {
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

  Widget _buildLogoutCard({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: AppDimensions.borderRadiusM,
      child: InkWell(
        onTap: () => _showLogoutDialog(context, ref),
        borderRadius: AppDimensions.borderRadiusM,
        child: Container(
          padding: AppDimensions.paddingM,
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderRadiusM,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: AppDimensions.avatarM,
                height: AppDimensions.avatarM,
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withValues(alpha: 0.1),
                  borderRadius: AppDimensions.borderRadiusM,
                ),
                child: Icon(
                  Icons.logout_outlined,
                  size: AppDimensions.iconM,
                  color: AppTheme.warningColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSubtitle,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warningColor,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacing2),
                    Text(
                      'الخروج من الحساب الحالي',
                      style: TextStyle(
                        fontSize: AppDimensions.fontLabel,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: AppDimensions.iconXS,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: AppDimensions.fontBody,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildStoreOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: AppDimensions.borderRadiusM,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensions.borderRadiusM,
        child: Container(
          padding: AppDimensions.paddingM,
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderRadiusM,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: AppDimensions.avatarM,
                height: AppDimensions.avatarM,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: AppDimensions.borderRadiusM,
                ),
                child: Icon(
                  icon,
                  size: AppDimensions.iconM,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: AppDimensions.spacing14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (badge != null) ...[
                          SizedBox(width: AppDimensions.spacing8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing6,
                              vertical: AppDimensions.spacing2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: AppDimensions.borderRadiusXS,
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppDimensions.fontCaption - 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppDimensions.fontLabel,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: AppDimensions.iconXS,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
