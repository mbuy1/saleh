import 'package:flutter/material.dart';
import '../features/customer/presentation/screens/customer_shell.dart';
import '../core/theme/theme_provider.dart';
import '../core/app_config.dart';
import 'merchant_admin_shell.dart';

/// Root Widget موحّد يعتمد على role المستخدم
/// 
/// يعرض:
/// - customer أو null → CustomerShell (واجهة العميل فقط)
/// - merchant أو admin → MerchantAdminShell (لوحة التحكم + زر التبديل)
class RoleBasedRoot extends StatelessWidget {
  final Map<String, dynamic>? userProfile;
  final String? role;
  final ThemeProvider themeProvider;
  final AppModeProvider appModeProvider;

  const RoleBasedRoot({
    super.key,
    required this.userProfile,
    required this.role,
    required this.themeProvider,
    required this.appModeProvider,
  });

  @override
  Widget build(BuildContext context) {
    // إذا كان role == 'merchant' أو 'admin' → عرض MerchantAdminShell
    if (role == 'merchant' || role == 'admin') {
      return MerchantAdminShell(
        userProfile: userProfile,
        role: role!,
        appModeProvider: appModeProvider,
        themeProvider: themeProvider,
      );
    }

    // إذا كان role == 'customer' أو null → عرض CustomerShell فقط
    return CustomerShell(
      appModeProvider: appModeProvider,
      userRole: role,
      themeProvider: themeProvider,
    );
  }
}

