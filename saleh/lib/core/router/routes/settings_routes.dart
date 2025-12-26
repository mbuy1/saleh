import 'package:go_router/go_router.dart';
import '../../../features/settings/presentation/screens/account_settings_screen.dart';
import '../../../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../../../features/settings/presentation/screens/terms_screen.dart';
import '../../../features/settings/presentation/screens/support_screen.dart';
import '../../../features/settings/presentation/screens/notification_settings_screen.dart';
import '../../../features/settings/presentation/screens/appearance_settings_screen.dart';

/// Settings Routes - مسارات الإعدادات
/// صفحات الإعدادات خارج Dashboard Shell
List<GoRoute> settingsRoutes = [
  GoRoute(
    path: '/settings',
    name: 'settings',
    builder: (context, state) => const AccountSettingsScreen(),
  ),
  GoRoute(
    path: '/privacy-policy',
    name: 'privacy-policy',
    builder: (context, state) => const PrivacyPolicyScreen(),
  ),
  GoRoute(
    path: '/terms',
    name: 'terms',
    builder: (context, state) => const TermsScreen(),
  ),
  GoRoute(
    path: '/support',
    name: 'support',
    builder: (context, state) => const SupportScreen(),
  ),
  GoRoute(
    path: '/notification-settings',
    name: 'notification-settings',
    builder: (context, state) => const NotificationSettingsScreen(),
  ),
  GoRoute(
    path: '/appearance-settings',
    name: 'appearance-settings',
    builder: (context, state) => const AppearanceSettingsScreen(),
  ),
];
