import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';

/// شاشة من نحن
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'من نحن',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.paddingL,
        child: Column(
          children: [
            const SizedBox(height: 20),

            // الشعار
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.metallicGradient,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: AppIcon(AppIcons.store, size: 48, color: Colors.white),
              ),
            ),

            const SizedBox(height: 24),

            // اسم التطبيق
            const Text(
              'Mbuy',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),

            const SizedBox(height: 8),

            // الوصف القصير
            Text(
              'منصة التجارة الإلكترونية الذكية',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.mutedSlate,
              ),
            ),

            const SizedBox(height: 8),

            // الإصدار
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'الإصدار 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // قصتنا
            _buildSection(
              title: 'قصتنا',
              content: '''
بدأت Mbuy من فكرة بسيطة: تمكين كل شخص من امتلاك متجره الإلكتروني بسهولة.

نؤمن بأن التجارة الإلكترونية يجب أن تكون متاحة للجميع، وليس فقط للشركات الكبيرة. لذلك أنشأنا منصة تجمع بين السهولة والقوة، مع أدوات ذكاء اصطناعي متقدمة لمساعدة التجار على النجاح.

اليوم، يستخدم آلاف التجار Mbuy لإدارة متاجرهم وتنمية أعمالهم.
''',
            ),

            // رؤيتنا
            _buildSection(
              title: 'رؤيتنا',
              content: '''
أن نكون المنصة الأولى للتجارة الإلكترونية في المنطقة العربية، ونمكّن مليون تاجر من تحقيق أحلامهم التجارية بحلول 2030.
''',
            ),

            // مميزاتنا
            const Text(
              'لماذا Mbuy؟',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),

            _buildFeatureCard(
              icon: AppIcons.bot,
              title: 'ذكاء اصطناعي متقدم',
              description: 'أدوات AI لتوليد الصور والمحتوى وتحسين المبيعات',
              color: const Color(0xFF8B5CF6),
            ),
            _buildFeatureCard(
              icon: AppIcons.chart,
              title: 'تحليلات شاملة',
              description: 'رؤى عميقة لفهم عملائك وتحسين أدائك',
              color: const Color(0xFF10B981),
            ),
            _buildFeatureCard(
              icon: AppIcons.shield,
              title: 'أمان عالي',
              description: 'حماية بياناتك ومعاملاتك بأعلى المعايير',
              color: const Color(0xFFEF4444),
            ),
            _buildFeatureCard(
              icon: AppIcons.supportAgent,
              title: 'دعم متواصل',
              description: 'فريق دعم متاح 24/7 لمساعدتك',
              color: const Color(0xFF3B82F6),
            ),

            const SizedBox(height: 32),

            // تواصل معنا
            const Text(
              'تواصل معنا',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(
                  icon: AppIcons.globe,
                  label: 'الموقع',
                  onTap: () => _launchUrl('https://mbuy.app'),
                ),
                const SizedBox(width: 16),
                _buildSocialButton(
                  icon: AppIcons.chat,
                  label: 'تويتر',
                  onTap: () => _launchUrl('https://twitter.com/mbuyapp'),
                ),
                const SizedBox(width: 16),
                _buildSocialButton(
                  icon: AppIcons.camera,
                  label: 'انستقرام',
                  onTap: () => _launchUrl('https://instagram.com/mbuyapp'),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // حقوق النشر
            Text(
              '© 2025 Mbuy. جميع الحقوق محفوظة.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.mutedSlate,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'صنع بـ ❤️ في المملكة العربية السعودية',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.mutedSlate,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content.trim(),
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.mutedSlate,
            height: 1.8,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: AppDimensions.paddingM,
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: AppIcon(icon, size: 24, color: color),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.mutedSlate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            AppIcon(icon, size: 24, color: AppTheme.primaryColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.mutedSlate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
