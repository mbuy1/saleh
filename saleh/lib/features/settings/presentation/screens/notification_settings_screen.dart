import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../shared/widgets/app_icon.dart';

/// Ø´Ø§Ø´Ø© Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª
/// ØªØªÙŠØ­ Ù„Ù„Ù…Ø³ØªØ®Ø¯Ù… Ø§Ù„ØªØ­ÙƒÙ… Ø§Ù„ÙƒØ§Ù…Ù„ ÙÙŠ Ø¥Ø´Ø¹Ø§Ø±Ø§ØªÙ‡
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  late NotificationSettings _settings;
  bool _isLoading = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = ref.read(preferencesStateProvider);
    setState(() {
      _settings = prefs.notificationSettings;
      _isLoading = false;
    });
  }

  void _updateSetting(NotificationSettings newSettings) {
    setState(() {
      _settings = newSettings;
      _hasChanges = true;
    });
  }

  Future<void> _saveSettings() async {
    HapticFeedback.mediumImpact();
    await ref
        .read(preferencesStateProvider.notifier)
        .updateNotificationSettings(_settings);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              AppIcon(AppIcons.checkCircle, color: AppTheme.surfaceColor),
              SizedBox(width: 12),
              Text('ØªÙ… Ø­ÙØ¸ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª'),
            ],
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState(() => _hasChanges = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _hasChanges ? _buildSaveButton() : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkSlate.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          AppIcon.button(
            AppIcons.arrowBack,
            onTap: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
            size: 20,
            color: AppTheme.primaryColor,
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
            padding: const EdgeInsets.all(10),
          ),
          const Expanded(
            child: Text(
              'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          const SizedBox(width: 40), // Ù„Ù„ØªÙˆØ§Ø²Ù†
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ø§Ù„ØªÙØ¹ÙŠÙ„ Ø§Ù„Ø¹Ø§Ù…
          _buildMasterSwitch(),
          const SizedBox(height: 24),

          // Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª
          _buildSection(
            title: 'Ø§Ù„Ø·Ù„Ø¨Ø§Øª',
            icon: AppIcons.shoppingBagOutlined,
            color: AppTheme.primaryColor,
            children: [
              _buildSwitchTile(
                'Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø¬Ø¯ÙŠØ¯Ø©',
                'Ø¥Ø´Ø¹Ø§Ø± Ø¹Ù†Ø¯ Ø§Ø³ØªÙ„Ø§Ù… Ø·Ù„Ø¨ Ø¬Ø¯ÙŠØ¯',
                AppIcons.add, // Ø£Ùˆ Ø£ÙŠÙ‚ÙˆÙ†Ø© Ù…Ù†Ø§Ø³Ø¨Ø© Ø£Ø®Ø±Ù‰
                _settings.newOrders,
                (v) => _updateSetting(_settings.copyWith(newOrders: v)),
              ),
              _buildSwitchTile(
                'Ø­Ø§Ù„Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª',
                'ØªØ­Ø¯ÙŠØ«Ø§Øª Ø­Ø§Ù„Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª',
                AppIcons.shipping,
                _settings.orderStatus,
                (v) => _updateSetting(_settings.copyWith(orderStatus: v)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø§Ù„Ù…Ø®Ø²ÙˆÙ† ÙˆØ§Ù„Ø¹Ù…Ù„Ø§Ø¡
          _buildSection(
            title: 'Ø§Ù„Ù…Ø®Ø²ÙˆÙ† ÙˆØ§Ù„Ø¹Ù…Ù„Ø§Ø¡',
            icon: AppIcons.inventory2,
            color: AppTheme.accentColor,
            children: [
              _buildSwitchTile(
                'Ø§Ù„Ù…Ø®Ø²ÙˆÙ† Ø§Ù„Ù…Ù†Ø®ÙØ¶',
                'ØªÙ†Ø¨ÙŠÙ‡ Ø¹Ù†Ø¯ Ø§Ù†Ø®ÙØ§Ø¶ ÙƒÙ…ÙŠØ© Ù…Ù†ØªØ¬',
                AppIcons.warning,
                _settings.lowStock,
                (v) => _updateSetting(_settings.copyWith(lowStock: v)),
              ),
              _buildSwitchTile(
                'Ø±Ø³Ø§Ø¦Ù„ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡',
                'Ø¥Ø´Ø¹Ø§Ø± Ø¹Ù†Ø¯ Ø§Ø³ØªÙ„Ø§Ù… Ø±Ø³Ø§Ù„Ø© Ø¬Ø¯ÙŠØ¯Ø©',
                AppIcons.chat,
                _settings.customerMessages,
                (v) => _updateSetting(_settings.copyWith(customerMessages: v)),
              ),
              _buildSwitchTile(
                'Ø§Ù„ØªÙ‚ÙŠÙŠÙ…Ø§Øª',
                'Ø¥Ø´Ø¹Ø§Ø± Ø¹Ù†Ø¯ Ø§Ø³ØªÙ„Ø§Ù… ØªÙ‚ÙŠÙŠÙ… Ø¬Ø¯ÙŠØ¯',
                AppIcons.star,
                _settings.reviews,
                (v) => _updateSetting(_settings.copyWith(reviews: v)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø§Ù„ØªØ³ÙˆÙŠÙ‚ ÙˆØ§Ù„Ù†Ø¸Ø§Ù…
          _buildSection(
            title: 'Ø§Ù„ØªØ³ÙˆÙŠÙ‚ ÙˆØ§Ù„Ù†Ø¸Ø§Ù…',
            icon: AppIcons.campaign,
            color: AppTheme.purpleColor,
            children: [
              _buildSwitchTile(
                'Ø§Ù„Ø¹Ø±ÙˆØ¶ ÙˆØ§Ù„ØªØ±ÙˆÙŠØ¬',
                'Ù†ØµØ§Ø¦Ø­ ÙˆØ¹Ø±ÙˆØ¶ Ù„ØªØ·ÙˆÙŠØ± Ù…ØªØ¬Ø±Ùƒ',
                AppIcons.localOffer,
                _settings.promotions,
                (v) => _updateSetting(_settings.copyWith(promotions: v)),
              ),
              _buildSwitchTile(
                'ØªØ­Ø¯ÙŠØ«Ø§Øª Ø§Ù„Ù†Ø¸Ø§Ù…',
                'Ù…ÙŠØ²Ø§Øª Ø¬Ø¯ÙŠØ¯Ø© ÙˆØªØ­Ø³ÙŠÙ†Ø§Øª',
                AppIcons.sync,
                _settings.systemUpdates,
                (v) => _updateSetting(_settings.copyWith(systemUpdates: v)),
              ),
              _buildSwitchTile(
                'Ø§Ù„ØªÙ‚Ø§Ø±ÙŠØ± Ø§Ù„Ø¯ÙˆØ±ÙŠØ©',
                'Ù…Ù„Ø®Øµ Ø£Ø¯Ø§Ø¡ Ù…ØªØ¬Ø±Ùƒ',
                AppIcons.analytics,
                _settings.reports,
                (v) => _updateSetting(_settings.copyWith(reports: v)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„ØµÙˆØª ÙˆØ§Ù„Ø§Ù‡ØªØ²Ø§Ø²
          _buildSection(
            title: 'Ø§Ù„ØµÙˆØª ÙˆØ§Ù„Ø§Ù‡ØªØ²Ø§Ø²',
            icon: AppIcons.notifications, // Ø£Ùˆ Ø£ÙŠÙ‚ÙˆÙ†Ø© Ù…Ù†Ø§Ø³Ø¨Ø©
            color: AppTheme.secondaryColor,
            children: [
              _buildSwitchTile(
                'Ø§Ù„ØµÙˆØª',
                'ØªØ´ØºÙŠÙ„ ØµÙˆØª Ø¹Ù†Ø¯ Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±',
                AppIcons.notifications,
                _settings.sound,
                (v) => _updateSetting(_settings.copyWith(sound: v)),
              ),
              _buildSwitchTile(
                'Ø§Ù„Ø§Ù‡ØªØ²Ø§Ø²',
                'Ø§Ù‡ØªØ²Ø§Ø² Ø§Ù„Ø¬Ù‡Ø§Ø² Ø¹Ù†Ø¯ Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±',
                AppIcons.activity, // Ø£Ùˆ Ø£ÙŠÙ‚ÙˆÙ†Ø© Ù…Ù†Ø§Ø³Ø¨Ø©
                _settings.vibration,
                (v) => _updateSetting(_settings.copyWith(vibration: v)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ÙˆÙ‚Øª Ø§Ù„Ù‡Ø¯ÙˆØ¡
          _buildQuietModeSection(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMasterSwitch() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _settings.enabled
              ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
              : [AppTheme.slate400, AppTheme.slate500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                (_settings.enabled
                        ? const Color(0xFF667eea)
                        : AppTheme.slate500)
                    .withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: AppIcon(
              _settings.enabled ? AppIcons.notifications : AppIcons.close,
              color: AppTheme.surfaceColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª',
                  style: TextStyle(
                    color: AppTheme.surfaceColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _settings.enabled ? 'Ù…ÙØ¹Ù‘Ù„Ø©' : 'Ù…ØªÙˆÙ‚ÙØ©',
                  style: TextStyle(
                    color: AppTheme.surfaceColor.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: _settings.enabled,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                _updateSetting(_settings.copyWith(enabled: v));
              },
              activeThumbColor: AppTheme.surfaceColor,
              activeTrackColor: AppTheme.surfaceColor.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String icon,
    required Color color,
    required List<Widget> children,
  }) {
    final isEnabled = _settings.enabled;

    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppIcon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            // Children
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    String icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final isEnabled = _settings.enabled;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          AppIcon(
            icon,
            size: 22,
            color: isEnabled && value
                ? AppTheme.primaryColor
                : AppTheme.textHintColor,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: AppTheme.textHintColor),
                ),
              ],
            ),
          ),
          Switch(
            value: value && isEnabled,
            onChanged: isEnabled
                ? (v) {
                    HapticFeedback.selectionClick();
                    onChanged(v);
                  }
                : null,
            activeThumbColor: AppTheme.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildQuietModeSection() {
    final isEnabled = _settings.enabled;

    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          children: [
            // Header with switch
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.purpleColor.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.purpleColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const AppIcon(
                      AppIcons.moon,
                      color: AppTheme.purpleColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ÙˆÙ‚Øª Ø§Ù„Ù‡Ø¯ÙˆØ¡',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.purpleColor,
                          ),
                        ),
                        Text(
                          'Ø¥ÙŠÙ‚Ø§Ù Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ù…Ø¤Ù‚ØªØ§Ù‹',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _settings.quietMode && isEnabled,
                    onChanged: isEnabled
                        ? (v) {
                            HapticFeedback.lightImpact();
                            _updateSetting(_settings.copyWith(quietMode: v));
                          }
                        : null,
                    activeThumbColor: AppTheme.purpleColor,
                  ),
                ],
              ),
            ),
            // Time pickers
            if (_settings.quietMode && isEnabled)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(
                        'Ù…Ù†',
                        _settings.quietStartHour,
                        (hour) => _updateSetting(
                          _settings.copyWith(quietStartHour: hour),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AppIcon(
                        AppIcons.arrowForward,
                        color: AppTheme.textHintColor,
                      ),
                    ), // ÙŠÙ…ÙƒÙ† Ø§Ø³ØªØ¨Ø¯Ø§Ù„Ù‡Ø§ Ø¨Ù€ AppIcon Ø¥Ø°Ø§ ÙƒØ§Ù†Øª Ø¶Ù…Ù† Ø£ÙŠÙ‚ÙˆÙ†Ø§Øª SVG
                    Expanded(
                      child: _buildTimePicker(
                        'Ø¥Ù„Ù‰',
                        _settings.quietEndHour,
                        (hour) => _updateSetting(
                          _settings.copyWith(quietEndHour: hour),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, int hour, ValueChanged<int> onChanged) {
    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: hour, minute: 0),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppTheme.primaryColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          HapticFeedback.selectionClick();
          onChanged(time.hour);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: AppTheme.textHintColor),
            ),
            const SizedBox(height: 4),
            Text(
              '${hour.toString().padLeft(2, '0')}:00',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.purpleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkSlate.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _saveSettings,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            foregroundColor: AppTheme.surfaceColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(AppIcons.check, color: AppTheme.surfaceColor),
              SizedBox(width: 8),
              Text(
                'Ø­ÙØ¸ Ø§Ù„ØªØºÙŠÙŠØ±Ø§Øª',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
