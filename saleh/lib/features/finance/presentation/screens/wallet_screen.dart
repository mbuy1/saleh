import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// Ø´Ø§Ø´Ø© Ù…Ø­ÙØ¸Ø© Ø§Ù„ØªØ§Ø¬Ø±
/// Ù…Ù„Ø§Ø­Ø¸Ø©: Ù…Ø·Ù„ÙˆØ¨ Ø±Ø¨Ø·Ù‡Ø§ Ø¨Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø­Ù‚ÙŠÙ‚ÙŠØ© Ù…Ù† API Ù…Ø³ØªÙ‚Ø¨Ù„Ø§Ù‹
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colors - Using AppTheme (Brand Primary #215950)
    const primaryColor = AppTheme.primaryColor;
    final backgroundColor = isDark
        ? AppTheme.backgroundColorDark
        : AppTheme.backgroundColor;
    final cardColor = isDark ? AppTheme.cardColorDark : AppTheme.cardColor;
    final textColor = isDark
        ? AppTheme.textPrimaryColorDark
        : AppTheme.textPrimaryColor;
    final secondaryTextColor = isDark
        ? AppTheme.textSecondaryColorDark
        : AppTheme.textSecondaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(
              context,
              isDark,
              textColor,
              primaryColor,
              backgroundColor,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Merchant ID
                    _buildMerchantId(isDark),

                    // Stats Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildBalanceCard(
                            isDark,
                            cardColor,
                            primaryColor,
                            textColor,
                            secondaryTextColor,
                          ),
                          const SizedBox(height: 16),
                          _buildPointsCard(
                            isDark,
                            cardColor,
                            textColor,
                            secondaryTextColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Actions
                    _buildActions(
                      isDark,
                      cardColor,
                      textColor,
                      primaryColor,
                      backgroundColor,
                    ),

                    const SizedBox(height: 8),

                    // Transactions Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ø£Ø­Ø¯Ø« Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Text(
                                  'Ø¹Ø±Ø¶ Ø§Ù„ÙƒÙ„',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Transform.rotate(
                                  angle: 3.14159,
                                  child: Icon(
                                    Icons.arrow_right_alt,
                                    color: primaryColor,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Transactions List
                    _buildTransactionsList(
                      isDark,
                      cardColor,
                      textColor,
                      secondaryTextColor,
                      primaryColor,
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color primaryColor,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
                : AppTheme.textHintColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.canPop() ? context.pop() : null,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(Icons.chevron_right, color: textColor, size: 24),
            ),
          ),
          // Title
          Expanded(
            child: Text(
              'Ø§Ù„Ù…Ø­ÙØ¸Ø©',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          // Empty space for balance
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildMerchantId(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Ù…Ø¹Ø±Ù Ø§Ù„ØªØ§Ø¬Ø±: ',
              style: TextStyle(
                color: isDark
                    ? AppTheme.textHintColorDark
                    : AppTheme.textHintColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: '8823',
              style: TextStyle(
                color: isDark
                    ? AppTheme.textHintColorDark
                    : AppTheme.textHintColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBalanceCard(
    bool isDark,
    Color cardColor,
    Color primaryColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
              : AppTheme.textHintColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Gradient
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ø§Ù„Ø±ØµÙŠØ¯ Ø§Ù„Ù…ØªØ§Ø­',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.account_balance_wallet, color: primaryColor),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '12,450.00',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ø±.Ø³',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        size: 14,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '+Ù¡Ù¢Ùª Ø¹Ù† Ø§Ù„Ø´Ù‡Ø± Ø§Ù„Ù…Ø§Ø¶ÙŠ',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
              : AppTheme.textHintColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Gradient
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ù†Ù‚Ø§Ø· Ø§Ù„ÙˆÙ„Ø§Ø¡',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.loyalty, color: Colors.blue[400]),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '530',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ù†Ù‚Ø·Ø©',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'ØªØ¹Ø§Ø¯Ù„ ',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.textHintColorDark
                            : AppTheme.textHintColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Ù¥Ù£.Ù Ù  Ø±.Ø³',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color primaryColor,
    Color bgDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              isDark: isDark,
              cardColor: cardColor,
              icon: Icons.payments,
              label: 'Ø³Ø­Ø¨ Ø§Ù„Ø±ØµÙŠØ¯',
              iconBgColor: primaryColor,
              iconColor: bgDark,
              textColor: isDark
                  ? AppTheme.textSecondaryColorDark
                  : AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              isDark: isDark,
              cardColor: cardColor,
              icon: Icons.currency_exchange,
              label: 'Ø§Ø³ØªØ¨Ø¯Ø§Ù„ Ø§Ù„Ù†Ù‚Ø§Ø·',
              iconBgColor: isDark ? AppTheme.iconBgDark : cardColor,
              iconColor: textColor,
              textColor: isDark
                  ? AppTheme.textSecondaryColorDark
                  : AppTheme.textSecondaryColor,
              hasBorder: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              isDark: isDark,
              cardColor: cardColor,
              icon: Icons.tune,
              label: 'ØªØµÙÙŠØ©',
              iconBgColor: isDark ? AppTheme.iconBgDark : cardColor,
              iconColor: textColor,
              textColor: isDark
                  ? AppTheme.textSecondaryColorDark
                  : AppTheme.textSecondaryColor,
              hasBorder: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required bool isDark,
    required Color cardColor,
    required IconData icon,
    required String label,
    required Color iconBgColor,
    required Color iconColor,
    required Color textColor,
    bool hasBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
              : AppTheme.textHintColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
              border: hasBorder
                  ? Border.all(
                      color: isDark
                          ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
                          : Colors.transparent,
                    )
                  : null,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTransactionItem(
            isDark: isDark,
            cardColor: cardColor,
            icon: Icons.shopping_cart,
            iconBgColor: primaryColor.withValues(alpha: 0.2),
            iconColor: primaryColor,
            title: 'Ø·Ù„Ø¨ #9921',
            subtitle: 'Ø§Ù„ÙŠÙˆÙ…ØŒ 10:30 Øµ',
            amount: '+ 150.00 Ø±.Ø³',
            amountColor: primaryColor,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            isDark: isDark,
            cardColor: cardColor,
            icon: Icons.percent,
            iconBgColor: Colors.red.withValues(alpha: 0.1),
            iconColor: isDark ? Colors.red[400]! : Colors.red,
            title: 'Ø±Ø³ÙˆÙ… Ø§Ù„Ù…Ù†ØµØ©',
            subtitle: 'Ø£Ù…Ø³ØŒ 04:15 Ù…',
            amount: '- 15.00 Ø±.Ø³',
            amountColor: textColor,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            isDark: isDark,
            cardColor: cardColor,
            icon: Icons.arrow_outward,
            iconBgColor: isDark
                ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
                : AppTheme.textHintColor.withValues(alpha: 0.3),
            iconColor: isDark
                ? AppTheme.textSecondaryColorDark
                : AppTheme.textSecondaryColor,
            title: 'Ø³Ø­Ø¨ Ø¥Ù„Ù‰ Ø§Ù„Ø¨Ù†Ùƒ',
            subtitle: '12 Ø£ØºØ³Ø·Ø³ØŒ 09:00 Øµ',
            amount: '- 2,500.00 Ø±.Ø³',
            amountColor: textColor,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            isDark: isDark,
            cardColor: cardColor,
            icon: Icons.star,
            iconBgColor: Colors.blue.withValues(alpha: 0.1),
            iconColor: isDark ? Colors.blue[400]! : Colors.blue,
            title: 'Ù…ÙƒØ§ÙØ£Ø© Ø£Ø¯Ø§Ø¡',
            subtitle: '10 Ø£ØºØ³Ø·Ø³',
            amount: '+ 50 Ù†Ù‚Ø·Ø©',
            amountColor: isDark ? Colors.blue[400]! : Colors.blue,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required bool isDark,
    required Color cardColor,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required Color amountColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
              : AppTheme.textHintColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Text(
            amount,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: amountColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
