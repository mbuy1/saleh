import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// صفحة المتجر - Store Tab
/// تحتوي على إدارة المتجر ومظهر المتجر ورابط المتجر
class StoreTab extends StatelessWidget {
  const StoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'المتجر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor, size: 24),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // قسم إعدادات المتجر
            _buildSectionTitle('إعدادات المتجر'),
            const SizedBox(height: 12),
            // معلومات المتجر
            _buildStoreOptionCard(
              context: context,
              icon: Icons.store_outlined,
              title: 'معلومات المتجر',
              subtitle: 'تعديل اسم ووصف المتجر',
              onTap: () => context.push('/dashboard/store/create-store'),
            ),
            const SizedBox(height: 12),
            // متجرك على جوك
            _buildStoreOptionCard(
              context: context,
              icon: Icons.storefront_outlined,
              title: 'متجرك على جوك',
              subtitle: 'تخصيص مظهر وإعدادات المتجر',
              onTap: () => context.push('/dashboard/store-on-jock'),
            ),
            const SizedBox(height: 24),
            // قسم خيارات إضافية
            _buildSectionTitle('خيارات إضافية'),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
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
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 24, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
