import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon.dart';

/// شاشة إعدادات المظهر
class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(preferencesStateProvider).themeMode;

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
            // المحتوى القابل للتمرير
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Ø§Ø®ØªØ± Ø§Ù„Ù…Ø¸Ù‡Ø± Ø§Ù„Ù…Ù†Ø§Ø³Ø¨ Ù„Ùƒ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _ThemeOptionCard(
                    title: 'ÙØ§ØªØ­',
                    subtitle: 'ØªØ¬Ø±Ø¨Ø© ÙƒÙ„Ø§Ø³ÙŠÙƒÙŠØ© ÙˆÙˆØ§Ø¶Ø­Ø©.',
                    icon: AppIcons.sun,
                    isSelected: currentThemeMode == ThemeMode.light,
                    onTap: () {
                      ref
                          .read(preferencesStateProvider.notifier)
                          .updateThemeMode(ThemeMode.light);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ThemeOptionCard(
                    title: 'Ø¯Ø§ÙƒÙ†',
                    subtitle: 'Ù…Ø±ÙŠØ­ Ù„Ù„Ø¹ÙŠÙ† ÙÙŠ Ø§Ù„Ø¥Ø¶Ø§Ø¡Ø© Ø§Ù„Ù…Ù†Ø®ÙØ¶Ø©.',
                    icon: AppIcons.moon,
                    isSelected: currentThemeMode == ThemeMode.dark,
                    onTap: () {
                      ref
                          .read(preferencesStateProvider.notifier)
                          .updateThemeMode(ThemeMode.dark);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ThemeOptionCard(
                    title: 'Ø§ÙØªØ±Ø§Ø¶ÙŠ Ø§Ù„Ù†Ø¸Ø§Ù…',
                    subtitle: 'ÙŠØªÙƒÙŠÙ Ù…Ø¹ Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø¬Ù‡Ø§Ø²Ùƒ.',
                    icon: AppIcons.monitor,
                    isSelected: currentThemeMode == ThemeMode.system,
                    onTap: () {
                      ref
                          .read(preferencesStateProvider.notifier)
                          .updateThemeMode(ThemeMode.system);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 1,
        shadowColor: isSelected
            ? AppTheme.primaryColor.withValues(alpha: 0.3)
            : Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? AppTheme.primaryColor
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              AppIcon(
                icon,
                size: 28,
                color: isSelected
                    ? AppTheme.primaryColor
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                AppIcon(
                  AppIcons.checkCircle,
                  color: AppTheme.successColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Row(
    children: [
      GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.spacing8),
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
      Expanded(
        child: Text(
          'Ø§Ù„Ù…Ø¸Ù‡Ø±',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.fontHeadline,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ),
      SizedBox(width: AppDimensions.iconM + AppDimensions.spacing16),
    ],
  );
}
