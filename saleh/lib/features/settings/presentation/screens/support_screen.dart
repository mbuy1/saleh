import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';

/// شاشة الØ¯Ø¹Ù… ÙˆالÙ…Ø³Ø§Ø¹Ø¯Ø©
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Ø«Ø§Ø¨Øª ÙÙŠ الØ£على
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildHeader(context),
            ),
            const SizedBox(height: 16),
            // الÙ…Ø­ØªÙˆÙ‰ الÙ‚Ø§Ø¨Ù„ Ù„Ù„تمØ±ÙŠØ±
            Expanded(
              child: ListView(
                padding: AppDimensions.paddingM,
                children: [
                  // Ø¨Ø·Ø§Ù‚Ø© الØªØ±Ø­ÙŠØ¨
                  Container(
                    padding: AppDimensions.paddingL,
                    decoration: BoxDecoration(
                      gradient: AppTheme.metallicGradient,
                      borderRadius: AppDimensions.borderRadiusXL,
                    ),
                    child: Column(
                      children: [
                        AppIcon(
                          AppIcons.supportAgent,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'ÙƒÙŠÙ ÙŠÙ…ÙƒÙ†Ù†Ø§ Ù…Ø³Ø§Ø¹Ø¯ØªÙƒØŸ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ÙØ±ÙŠÙ‚ الØ¯Ø¹Ù… Ù…ØªØ§Ø­ على Ù…Ø¯Ø§Ø± الساعة Ù„Ù…Ø³Ø§Ø¹Ø¯ØªÙƒ',
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

                  // Ø·Ø±Ù‚ الØªÙˆØ§ØµÙ„
                  const Text(
                    'ØªÙˆØ§ØµÙ„ معÙ†Ø§',
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
                    title: 'ÙˆØ§ØªØ³Ø§Ø¨',
                    subtitle: 'Ø£Ø³Ø±Ø¹ Ø·Ø±ÙŠÙ‚Ø© Ù„Ù„ØªÙˆØ§ØµÙ„',
                    color: const Color(0xFF25D366),
                    onTap: () => _launchWhatsApp(context),
                  ),

                  const SizedBox(height: 12),

                  _buildContactCard(
                    context,
                    icon: AppIcons.email,
                    title: 'الØ¨Ø±ÙŠØ¯ الØ¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ',
                    subtitle: 'support@mbuy.app',
                    color: AppTheme.primaryColor,
                    onTap: () => _launchEmail(context),
                  ),

                  const SizedBox(height: 12),

                  _buildContactCard(
                    context,
                    icon: AppIcons.phone,
                    title: 'الÙ‡Ø§ØªÙ',
                    subtitle: '+966 50 000 0000',
                    color: AppTheme.successColor,
                    onTap: () => _launchPhone(context),
                  ),

                  const SizedBox(height: 32),

                  // الØ£Ø³Ø¦Ù„Ø© الØ´Ø§Ø¦Ø¹Ø©
                  const Text(
                    'الØ£Ø³Ø¦Ù„Ø© الØ´Ø§Ø¦Ø¹Ø©',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildFAQCard([
                    _FAQItem(
                      question: 'ÙƒÙŠÙ Ø£Ù†Ø´Ø¦ Ù…ØªØ¬Ø±ÙŠØŸ',
                      answer:
                          'Ø¨Ø¹Ø¯ ØªØ³Ø¬ÙŠÙ„ الØ¯Ø®ÙˆÙ„ØŒ Ø§Ø°Ù‡Ø¨ إلى "Ø¥Ø¯Ø§Ø±Ø© الÙ…ØªØ¬Ø±" Ø«Ù… Ø§Ø¶ØºØ· على "Ø¥Ù†Ø´Ø§Ø¡ Ù…ØªØ¬Ø±". Ø£Ø¯Ø®Ù„ Ø§Ø³Ù… الÙ…ØªØ¬Ø± ÙˆالÙˆØµÙ ÙˆالØ´Ø¹Ø§Ø±ØŒ Ø«Ù… Ø§Ø¶ØºØ· على "Ø¥Ù†Ø´Ø§Ø¡".',
                    ),
                    _FAQItem(
                      question: 'ÙƒÙŠÙ Ø£Ø¶ÙŠÙ منØªØ¬Ø§ØªØŸ',
                      answer:
                          'Ø§Ø¶ØºØ· على Ø²Ø± + ÙÙŠ الØ´Ø±ÙŠØ· الØ³ÙÙ„ÙŠØŒ Ø«Ù… Ø£Ø¯Ø®Ù„ Ø¨ÙŠØ§Ù†Ø§Øª المنØªØ¬ (الØ§Ø³Ù…ØŒ الØ³Ø¹Ø±ØŒ الØµÙˆØ±ØŒ الÙˆØµÙ) ÙˆØ§Ø¶ØºØ· على "Ø­ÙØ¸".',
                    ),
                    _FAQItem(
                      question: 'ÙƒÙŠÙ Ø£Ø´ØªØ±ÙŠ نقاطØŸ',
                      answer:
                          'Ø§Ø°Ù‡Ø¨ إلى ØµÙØ­Ø© "النقاط" من الرئيسيةØŒ Ø«Ù… Ø§Ø®ØªØ± الØ¨Ø§Ù‚Ø© المنØ§Ø³Ø¨Ø© ÙˆØ§ØªØ¨Ø¹ Ø®Ø·ÙˆØ§Øª الØ¯ÙØ¹.',
                    ),
                    _FAQItem(
                      question: 'Ù…Ø§ Ù‡ÙŠ أدوات AIØŸ',
                      answer:
                          'Ø£Ø¯ÙˆØ§Øª الØ°ÙƒØ§Ø¡ الØ§ØµØ·Ù†Ø§Ø¹ÙŠ ØªØ³Ø§Ø¹Ø¯Ùƒ ÙÙŠ ØªÙˆÙ„ÙŠØ¯ ØµÙˆØ± Ø§Ø­ØªØ±Ø§ÙÙŠØ© Ù„Ù„منØªØ¬Ø§ØªØŒ ÙˆÙƒØªØ§Ø¨Ø© Ø£ÙˆØµØ§Ù Ø¬Ø°Ø§Ø¨Ø©ØŒ ÙˆØªØ­Ø³ÙŠÙ† Ù…ØªØ¬Ø±Ùƒ.',
                    ),
                    _FAQItem(
                      question: 'ÙƒÙŠÙ Ø£Ø³Ø­Ø¨ Ø£Ø±Ø¨Ø§Ø­ÙŠØŸ',
                      answer:
                          'Ø§Ø°Ù‡Ø¨ إلى "الÙ…Ø­ÙØ¸Ø©"ØŒ Ø«Ù… Ø§Ø¶ØºØ· على "Ø³Ø­Ø¨"ØŒ Ø£Ø¯Ø®Ù„ الÙ…Ø¨Ù„Øº ÙˆØ¨ÙŠØ§Ù†Ø§Øª الØ­Ø³Ø§Ø¨ الØ¨Ù†ÙƒÙŠØŒ ÙˆØ³ÙŠتم الØªØ­ÙˆÙŠÙ„ Ø®Ù„ال 3-5 Ø£ÙŠØ§Ù… Ø¹Ù…Ù„.',
                    ),
                    _FAQItem(
                      question: 'ÙƒÙŠÙ Ø£Ù„ØºÙŠ Ø§Ø´ØªØ±Ø§ÙƒÙŠØŸ',
                      answer:
                          'Ø§Ø°Ù‡Ø¨ إلى "Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª الØ­Ø³Ø§Ø¨" Ø«Ù… "الØ§Ø´ØªØ±Ø§ÙƒØ§Øª"ØŒ ÙˆØ§Ø¶ØºØ· على "إلغاء الØ§Ø´ØªØ±Ø§Ùƒ". Ø³ÙŠØ¨Ù‚Ù‰ Ø­Ø³Ø§Ø¨Ùƒ ÙØ¹الØ§Ù‹ Ø­ØªÙ‰ Ù†Ù‡Ø§ÙŠØ© الÙØªØ±Ø© الÙ…Ø¯ÙÙˆØ¹Ø©.',
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // Ø±ÙˆØ§Ø¨Ø· Ù…ÙÙŠØ¯Ø©
                  const Text(
                    'Ø±ÙˆØ§Ø¨Ø· Ù…ÙÙŠØ¯Ø©',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildLinkTile(
                    icon: AppIcons.document,
                    title: 'Ø¯Ù„ÙŠÙ„ الÙ…Ø³ØªØ®Ø¯Ù…',
                    onTap: () {},
                  ),
                  _buildLinkTile(
                    icon: AppIcons.playCircle,
                    title: 'ÙÙŠØ¯ÙŠÙˆÙ‡Ø§Øª ØªØ¹Ù„ÙŠÙ…ÙŠØ©',
                    onTap: () {},
                  ),
                  _buildLinkTile(
                    icon: AppIcons.info,
                    title: 'Ø¹Ù† التطبيق',
                    onTap: () => context.push('/dashboard/about'),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
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
                  child: Center(child: AppIcon(icon, size: 24, color: color)),
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
    final url = Uri.parse(
      'https://wa.me/966500000000?text=مرحباًØŒ Ø£Ø­ØªØ§Ø¬ Ù…Ø³Ø§Ø¹Ø¯Ø©',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا ÙŠÙ…ÙƒÙ† ÙØªØ­ ÙˆØ§ØªØ³Ø§Ø¨'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final url = Uri.parse('mailto:support@mbuy.app?subject=طلب Ø¯Ø¹Ù…');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا ÙŠÙ…ÙƒÙ† ÙØªØ­ الØ¨Ø±ÙŠØ¯ الØ¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ'),
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
            content: Text('لا ÙŠÙ…ÙƒÙ† ÙØªØ­ ØªØ·Ø¨ÙŠÙ‚ الÙ‡Ø§ØªÙ'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
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
            'الØ¯Ø¹Ù… ÙˆالÙ…Ø³Ø§Ø¹Ø¯Ø©',
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

class _FAQItem {
  final String question;
  final String answer;

  _FAQItem({required this.question, required this.answer});
}
