import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';

const String _lastUpdatedDate = 'Ø¯ÙŠØ³Ù…Ø¨Ø± 2025';

/// Ø´Ø§Ø´Ø© Ø³ÙŠØ§Ø³Ø© Ø§Ù„Ø®ØµÙˆØµÙŠØ©
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                padding: AppDimensions.paddingL,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ØªØ§Ø±ÙŠØ® Ø§Ù„ØªØ­Ø¯ÙŠØ«
                    Container(
                      padding: AppDimensions.paddingS,
                      decoration: BoxDecoration(
                        color: AppTheme.infoColor.withValues(alpha: 0.1),
                        borderRadius: AppDimensions.borderRadiusS,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon(
                            AppIcons.calendar,
                            size: 16,
                            color: AppTheme.infoColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ø¢Ø®Ø± ØªØ­Ø¯ÙŠØ«: $_lastUpdatedDate',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.infoColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildSection(
                      title: 'Ù…Ù‚Ø¯Ù…Ø©',
                      content: '''
Ù†Ø­Ù† ÙÙŠ Mbuy Ù†Ø­ØªØ±Ù… Ø®ØµÙˆØµÙŠØªÙƒ ÙˆÙ†Ù„ØªØ²Ù… Ø¨Ø­Ù…Ø§ÙŠØ© Ø¨ÙŠØ§Ù†Ø§ØªÙƒ Ø§Ù„Ø´Ø®ØµÙŠØ©. ØªÙˆØ¶Ø­ Ø³ÙŠØ§Ø³Ø© Ø§Ù„Ø®ØµÙˆØµÙŠØ© Ù‡Ø°Ù‡ ÙƒÙŠÙÙŠØ© Ø¬Ù…Ø¹ ÙˆØ§Ø³ØªØ®Ø¯Ø§Ù… ÙˆØ­Ù…Ø§ÙŠØ© Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„ØªÙŠ ØªÙ‚Ø¯Ù…Ù‡Ø§ Ù„Ù†Ø§ Ø¹Ù†Ø¯ Ø§Ø³ØªØ®Ø¯Ø§Ù… ØªØ·Ø¨ÙŠÙ‚Ù†Ø§.

Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù…Ùƒ Ù„ØªØ·Ø¨ÙŠÙ‚ MbuyØŒ ÙØ¥Ù†Ùƒ ØªÙˆØ§ÙÙ‚ Ø¹Ù„Ù‰ Ø¬Ù…Ø¹ ÙˆØ§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§Øª ÙˆÙÙ‚Ø§Ù‹ Ù„Ù‡Ø°Ù‡ Ø§Ù„Ø³ÙŠØ§Ø³Ø©.
''',
                    ),

                    _buildSection(
                      title: 'Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„ØªÙŠ Ù†Ø¬Ù…Ø¹Ù‡Ø§',
                      content: '''
Ù†Ù‚ÙˆÙ… Ø¨Ø¬Ù…Ø¹ Ø£Ù†ÙˆØ§Ø¹ Ù…Ø®ØªÙ„ÙØ© Ù…Ù† Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ù„Ø£ØºØ±Ø§Ø¶ Ù…ØªØ¹Ø¯Ø¯Ø©:

â€¢ **Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ø­Ø³Ø§Ø¨:** Ø§Ù„Ø§Ø³Ù…ØŒ Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØŒ Ø±Ù‚Ù… Ø§Ù„Ù‡Ø§ØªÙ
â€¢ **Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ù…ØªØ¬Ø±:** Ø§Ø³Ù… Ø§Ù„Ù…ØªØ¬Ø±ØŒ Ø§Ù„ÙˆØµÙØŒ Ø§Ù„Ø´Ø¹Ø§Ø±ØŒ Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª
â€¢ **Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª:** Ø³Ø¬Ù„ Ø§Ù„Ø·Ù„Ø¨Ø§ØªØŒ Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§ØªØŒ Ø§Ù„Ù…Ø¯ÙÙˆØ¹Ø§Øª
â€¢ **Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù…:** ÙƒÙŠÙÙŠØ© ØªÙØ§Ø¹Ù„Ùƒ Ù…Ø¹ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚
â€¢ **Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ø¬Ù‡Ø§Ø²:** Ù†ÙˆØ¹ Ø§Ù„Ø¬Ù‡Ø§Ø²ØŒ Ù†Ø¸Ø§Ù… Ø§Ù„ØªØ´ØºÙŠÙ„ØŒ Ù…Ø¹Ø±Ù Ø§Ù„Ø¬Ù‡Ø§Ø²
''',
                    ),

                    _buildSection(
                      title: 'ÙƒÙŠÙ Ù†Ø³ØªØ®Ø¯Ù… Ù…Ø¹Ù„ÙˆÙ…Ø§ØªÙƒ',
                      content: '''
Ù†Ø³ØªØ®Ø¯Ù… Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„Ù…Ø¬Ù…Ø¹Ø© Ù„Ù„Ø£ØºØ±Ø§Ø¶ Ø§Ù„ØªØ§Ù„ÙŠØ©:

â€¢ ØªÙ‚Ø¯ÙŠÙ… Ø®Ø¯Ù…Ø§Øª Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ ÙˆØªØ­Ø³ÙŠÙ†Ù‡Ø§
â€¢ Ù…Ø¹Ø§Ù„Ø¬Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª ÙˆØ§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª
â€¢ Ø¥Ø±Ø³Ø§Ù„ Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ù…Ù‡Ù…Ø© Ø­ÙˆÙ„ Ø­Ø³Ø§Ø¨Ùƒ
â€¢ ØªÙ‚Ø¯ÙŠÙ… Ø§Ù„Ø¯Ø¹Ù… Ø§Ù„ÙÙ†ÙŠ
â€¢ ØªØ­Ù„ÙŠÙ„ Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ Ù„ØªØ­Ø³ÙŠÙ† Ø§Ù„ØªØ¬Ø±Ø¨Ø©
â€¢ Ø§Ù„ÙƒØ´Ù Ø¹Ù† Ø§Ù„Ø§Ø­ØªÙŠØ§Ù„ ÙˆØ§Ù„Ø£Ù†Ø´Ø·Ø© ØºÙŠØ± Ø§Ù„Ù…ØµØ±Ø­ Ø¨Ù‡Ø§
â€¢ Ø§Ù„Ø§Ù…ØªØ«Ø§Ù„ Ù„Ù„Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„Ù‚Ø§Ù†ÙˆÙ†ÙŠØ©
''',
                    ),

                    _buildSection(
                      title: 'Ù…Ø´Ø§Ø±ÙƒØ© Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§Øª',
                      content: '''
Ù„Ø§ Ù†Ø¨ÙŠØ¹ Ø£Ùˆ Ù†Ø¤Ø¬Ø± Ù…Ø¹Ù„ÙˆÙ…Ø§ØªÙƒ Ø§Ù„Ø´Ø®ØµÙŠØ© Ù„Ø£Ø·Ø±Ø§Ù Ø«Ø§Ù„Ø«Ø©. Ù‚Ø¯ Ù†Ø´Ø§Ø±Ùƒ Ù…Ø¹Ù„ÙˆÙ…Ø§ØªÙƒ ÙÙŠ Ø§Ù„Ø­Ø§Ù„Ø§Øª Ø§Ù„ØªØ§Ù„ÙŠØ©:

â€¢ **Ù…Ø¹ Ù…Ø²ÙˆØ¯ÙŠ Ø§Ù„Ø®Ø¯Ù…Ø©:** Ø´Ø±ÙƒØ§Øª Ø§Ù„Ø¯ÙØ¹ØŒ Ø®Ø¯Ù…Ø§Øª Ø§Ù„ØªÙˆØµÙŠÙ„
â€¢ **Ù„Ù„Ø§Ù…ØªØ«Ø§Ù„ Ø§Ù„Ù‚Ø§Ù†ÙˆÙ†ÙŠ:** Ø¹Ù†Ø¯ Ø·Ù„Ø¨ Ø§Ù„Ø³Ù„Ø·Ø§Øª Ø§Ù„Ù…Ø®ØªØµØ©
â€¢ **Ù„Ø­Ù…Ø§ÙŠØ© Ø§Ù„Ø­Ù‚ÙˆÙ‚:** Ù„Ø­Ù…Ø§ÙŠØ© Ø­Ù‚ÙˆÙ‚ Mbuy ÙˆÙ…Ø³ØªØ®Ø¯Ù…ÙŠÙ‡Ø§
â€¢ **ÙÙŠ Ø¹Ù…Ù„ÙŠØ§Øª Ø§Ù„Ø¯Ù…Ø¬:** ÙÙŠ Ø­Ø§Ù„Ø© Ø§Ù†Ø¯Ù…Ø§Ø¬ Ø£Ùˆ Ø§Ø³ØªØ­ÙˆØ§Ø°
''',
                    ),

                    _buildSection(
                      title: 'Ø£Ù…Ø§Ù† Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª',
                      content: '''
Ù†ØªØ®Ø° Ø¥Ø¬Ø±Ø§Ø¡Ø§Øª Ø£Ù…Ù†ÙŠØ© Ù…Ù†Ø§Ø³Ø¨Ø© Ù„Ø­Ù…Ø§ÙŠØ© Ø¨ÙŠØ§Ù†Ø§ØªÙƒ:

â€¢ ØªØ´ÙÙŠØ± Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ø£Ø«Ù†Ø§Ø¡ Ø§Ù„Ù†Ù‚Ù„ ÙˆØ§Ù„ØªØ®Ø²ÙŠÙ† (SSL/TLS)
â€¢ Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø®ÙˆØ§Ø¯Ù… Ø¢Ù…Ù†Ø© ÙˆÙ…Ø­Ù…ÙŠØ©
â€¢ ØªÙ‚ÙŠÙŠØ¯ Ø§Ù„ÙˆØµÙˆÙ„ Ù„Ù„Ù…ÙˆØ¸ÙÙŠÙ† Ø§Ù„Ù…ØµØ±Ø­ Ù„Ù‡Ù… ÙÙ‚Ø·
â€¢ Ø§Ù„Ù…Ø±Ø§Ø¬Ø¹Ø© Ø§Ù„Ø¯ÙˆØ±ÙŠØ© Ù„Ø¥Ø¬Ø±Ø§Ø¡Ø§Øª Ø§Ù„Ø£Ù…Ø§Ù†
â€¢ Ø¹Ø¯Ù… ØªØ®Ø²ÙŠÙ† Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¨Ø·Ø§Ù‚Ø§Øª Ø§Ù„Ø¨Ù†ÙƒÙŠØ© Ø¹Ù„Ù‰ Ø®ÙˆØ§Ø¯Ù…Ù†Ø§
''',
                    ),

                    _buildSection(
                      title: 'Ø­Ù‚ÙˆÙ‚Ùƒ',
                      content: '''
Ù„Ø¯ÙŠÙƒ Ø§Ù„Ø­Ù‚ÙˆÙ‚ Ø§Ù„ØªØ§Ù„ÙŠØ© Ø¨Ø®ØµÙˆØµ Ø¨ÙŠØ§Ù†Ø§ØªÙƒ:

â€¢ **Ø§Ù„ÙˆØµÙˆÙ„:** Ø·Ù„Ø¨ Ù†Ø³Ø®Ø© Ù…Ù† Ø¨ÙŠØ§Ù†Ø§ØªÙƒ Ø§Ù„Ø´Ø®ØµÙŠØ©
â€¢ **Ø§Ù„ØªØµØ­ÙŠØ­:** ØªØ¹Ø¯ÙŠÙ„ Ø£ÙŠ Ù…Ø¹Ù„ÙˆÙ…Ø§Øª ØºÙŠØ± ØµØ­ÙŠØ­Ø©
â€¢ **Ø§Ù„Ø­Ø°Ù:** Ø·Ù„Ø¨ Ø­Ø°Ù Ø¨ÙŠØ§Ù†Ø§ØªÙƒ (Ù…Ø¹ Ø¨Ø¹Ø¶ Ø§Ù„Ø§Ø³ØªØ«Ù†Ø§Ø¡Ø§Øª)
â€¢ **Ø§Ù„Ø§Ø¹ØªØ±Ø§Ø¶:** Ø§Ù„Ø§Ø¹ØªØ±Ø§Ø¶ Ø¹Ù„Ù‰ Ù…Ø¹Ø§Ù„Ø¬Ø© Ø¨ÙŠØ§Ù†Ø§ØªÙƒ
â€¢ **Ù†Ù‚Ù„ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª:** Ø·Ù„Ø¨ Ù†Ù‚Ù„ Ø¨ÙŠØ§Ù†Ø§ØªÙƒ Ù„Ù…Ù†ØµØ© Ø£Ø®Ø±Ù‰
''',
                    ),

                    _buildSection(
                      title: 'Ù…Ù„ÙØ§Øª ØªØ¹Ø±ÙŠÙ Ø§Ù„Ø§Ø±ØªØ¨Ø§Ø· (Cookies)',
                      content: '''
Ù†Ø³ØªØ®Ø¯Ù… Ù…Ù„ÙØ§Øª ØªØ¹Ø±ÙŠÙ Ø§Ù„Ø§Ø±ØªØ¨Ø§Ø· ÙˆØªÙ‚Ù†ÙŠØ§Øª Ù…Ø´Ø§Ø¨Ù‡Ø© Ù„Ù€:

â€¢ ØªØ°ÙƒØ± ØªÙØ¶ÙŠÙ„Ø§ØªÙƒ ÙˆØ¥Ø¹Ø¯Ø§Ø¯Ø§ØªÙƒ
â€¢ ØªØ­Ù„ÙŠÙ„ Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„ØªØ·Ø¨ÙŠÙ‚
â€¢ ØªØ­Ø³ÙŠÙ† Ø£Ø¯Ø§Ø¡ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚
â€¢ ØªÙˆÙÙŠØ± ØªØ¬Ø±Ø¨Ø© Ù…Ø®ØµØµØ©

ÙŠÙ…ÙƒÙ†Ùƒ Ø§Ù„ØªØ­ÙƒÙ… ÙÙŠ Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„ÙƒÙˆÙƒÙŠØ² Ù…Ù† Ø®Ù„Ø§Ù„ Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø¬Ù‡Ø§Ø²Ùƒ.
''',
                    ),

                    _buildSection(
                      title: 'Ø§Ù„ØªØºÙŠÙŠØ±Ø§Øª Ø¹Ù„Ù‰ Ø§Ù„Ø³ÙŠØ§Ø³Ø©',
                      content: '''
Ù‚Ø¯ Ù†Ù‚ÙˆÙ… Ø¨ØªØ­Ø¯ÙŠØ« Ø³ÙŠØ§Ø³Ø© Ø§Ù„Ø®ØµÙˆØµÙŠØ© Ù…Ù† ÙˆÙ‚Øª Ù„Ø¢Ø®Ø±. Ø³Ù†Ù‚ÙˆÙ… Ø¨Ø¥Ø¹Ù„Ø§Ù…Ùƒ Ø¨Ø£ÙŠ ØªØºÙŠÙŠØ±Ø§Øª Ø¬ÙˆÙ‡Ø±ÙŠØ© Ø¹Ø¨Ø±:

â€¢ Ø¥Ø´Ø¹Ø§Ø± Ø¯Ø§Ø®Ù„ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚
â€¢ Ø¨Ø±ÙŠØ¯ Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ Ø¥Ù„Ù‰ Ø§Ù„Ø¹Ù†ÙˆØ§Ù† Ø§Ù„Ù…Ø³Ø¬Ù„
â€¢ ØªØ­Ø¯ÙŠØ« ØªØ§Ø±ÙŠØ® "Ø¢Ø®Ø± ØªØ­Ø¯ÙŠØ«"

Ù†Ù†ØµØ­Ùƒ Ø¨Ù…Ø±Ø§Ø¬Ø¹Ø© Ù‡Ø°Ù‡ Ø§Ù„Ø³ÙŠØ§Ø³Ø© Ø¨Ø´ÙƒÙ„ Ø¯ÙˆØ±ÙŠ.
''',
                    ),

                    _buildSection(
                      title: 'ØªÙˆØ§ØµÙ„ Ù…Ø¹Ù†Ø§',
                      content: '''
Ø¥Ø°Ø§ ÙƒØ§Ù† Ù„Ø¯ÙŠÙƒ Ø£ÙŠ Ø£Ø³Ø¦Ù„Ø© Ø­ÙˆÙ„ Ø³ÙŠØ§Ø³Ø© Ø§Ù„Ø®ØµÙˆØµÙŠØ©ØŒ ÙŠÙ…ÙƒÙ†Ùƒ Ø§Ù„ØªÙˆØ§ØµÙ„ Ù…Ø¹Ù†Ø§:

â€¢ Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ: privacy@mbuy.app
â€¢ Ø§Ù„Ø¯Ø¹Ù… Ø§Ù„ÙÙ†ÙŠ: support@mbuy.app
â€¢ ÙˆØ§ØªØ³Ø§Ø¨: +966 50 000 0000

Ø³Ù†Ø±Ø¯ Ø¹Ù„Ù‰ Ø§Ø³ØªÙØ³Ø§Ø±Ø§ØªÙƒ Ø®Ù„Ø§Ù„ 48 Ø³Ø§Ø¹Ø© Ø¹Ù…Ù„.
''',
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
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
        ),
        const SizedBox(height: 24),
      ],
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
            'Ø³ÙŠØ§Ø³Ø© Ø§Ù„Ø®ØµÙˆØµÙŠØ©',
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
