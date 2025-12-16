import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';

/// شاشة الدعم والمساعدة
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
          'الدعم والمساعدة',
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
          // بطاقة الترحيب
          Container(
            padding: AppDimensions.paddingL,
            decoration: BoxDecoration(
              gradient: AppTheme.metallicGradient,
              borderRadius: AppDimensions.borderRadiusXL,
            ),
            child: Column(
              children: [
                AppIcon(AppIcons.supportAgent, size: 48, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'كيف يمكننا مساعدتك؟',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'فريق الدعم متاح على مدار الساعة لمساعدتك',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // طرق التواصل
          const Text(
            'تواصل معنا',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),

          _buildContactCard(
            context,
            icon: AppIcons.chat,
            title: 'واتساب',
            subtitle: 'أسرع طريقة للتواصل',
            color: const Color(0xFF25D366),
            onTap: () => _launchWhatsApp(context),
          ),

          const SizedBox(height: 12),

          _buildContactCard(
            context,
            icon: AppIcons.email,
            title: 'البريد الإلكتروني',
            subtitle: 'support@mbuy.app',
            color: AppTheme.primaryColor,
            onTap: () => _launchEmail(context),
          ),

          const SizedBox(height: 12),

          _buildContactCard(
            context,
            icon: AppIcons.phone,
            title: 'الهاتف',
            subtitle: '+966 50 000 0000',
            color: AppTheme.successColor,
            onTap: () => _launchPhone(context),
          ),

          const SizedBox(height: 32),

          // الأسئلة الشائعة
          const Text(
            'الأسئلة الشائعة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),

          _buildFAQCard([
            _FAQItem(
              question: 'كيف أنشئ متجري؟',
              answer:
                  'بعد تسجيل الدخول، اذهب إلى "إدارة المتجر" ثم اضغط على "إنشاء متجر". أدخل اسم المتجر والوصف والشعار، ثم اضغط على "إنشاء".',
            ),
            _FAQItem(
              question: 'كيف أضيف منتجات؟',
              answer:
                  'اضغط على زر + في الشريط السفلي، ثم أدخل بيانات المنتج (الاسم، السعر، الصور، الوصف) واضغط على "حفظ".',
            ),
            _FAQItem(
              question: 'كيف أشتري نقاط؟',
              answer:
                  'اذهب إلى صفحة "النقاط" من الرئيسية، ثم اختر الباقة المناسبة واتبع خطوات الدفع.',
            ),
            _FAQItem(
              question: 'ما هي أدوات AI؟',
              answer:
                  'أدوات الذكاء الاصطناعي تساعدك في توليد صور احترافية للمنتجات، وكتابة أوصاف جذابة، وتحسين متجرك.',
            ),
            _FAQItem(
              question: 'كيف أسحب أرباحي؟',
              answer:
                  'اذهب إلى "المحفظة"، ثم اضغط على "سحب"، أدخل المبلغ وبيانات الحساب البنكي، وسيتم التحويل خلال 3-5 أيام عمل.',
            ),
            _FAQItem(
              question: 'كيف ألغي اشتراكي؟',
              answer:
                  'اذهب إلى "إعدادات الحساب" ثم "الاشتراكات"، واضغط على "إلغاء الاشتراك". سيبقى حسابك فعالاً حتى نهاية الفترة المدفوعة.',
            ),
          ]),

          const SizedBox(height: 32),

          // روابط مفيدة
          const Text(
            'روابط مفيدة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),

          _buildLinkTile(
            icon: AppIcons.document,
            title: 'دليل المستخدم',
            onTap: () {},
          ),
          _buildLinkTile(
            icon: AppIcons.playCircle,
            title: 'فيديوهات تعليمية',
            onTap: () {},
          ),
          _buildLinkTile(
            icon: AppIcons.info,
            title: 'عن التطبيق',
            onTap: () => context.push('/about'),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: AppDimensions.borderRadiusL,
          child: Padding(
            padding: AppDimensions.paddingM,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.mutedSlate,
                        ),
                      ),
                    ],
                  ),
                ),
                AppIcon(AppIcons.chevronLeft, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQCard(List<_FAQItem> items) {
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
      child: Column(
        children: items.map((item) => _buildFAQTile(item)).toList(),
      ),
    );
  }

  Widget _buildFAQTile(_FAQItem item) {
    return ExpansionTile(
      title: Text(
        item.question,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      iconColor: AppTheme.primaryColor,
      collapsedIconColor: Colors.grey,
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        Text(
          item.answer,
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.mutedSlate,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusM,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: AppIcon(icon, size: 22, color: AppTheme.primaryColor),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: AppIcon(AppIcons.chevronLeft, size: 16, color: Colors.grey),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
      ),
    );
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final url = Uri.parse('https://wa.me/966500000000?text=مرحباً، أحتاج مساعدة');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا يمكن فتح واتساب'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final url = Uri.parse('mailto:support@mbuy.app?subject=طلب دعم');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا يمكن فتح البريد الإلكتروني'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _launchPhone(BuildContext context) async {
    final url = Uri.parse('tel:+966500000000');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا يمكن فتح تطبيق الهاتف'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}

class _FAQItem {
  final String question;
  final String answer;

  _FAQItem({required this.question, required this.answer});
}
