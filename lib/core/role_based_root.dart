import 'package:flutter/material.dart';
import '../features/customer/presentation/screens/customer_shell.dart';
import '../core/theme/theme_provider.dart';
import '../core/app_config.dart';
import '../core/services/secure_storage_service.dart';
import 'merchant_admin_shell.dart';

/// Root Widget موحّد يعتمد على role المستخدم و login_as
/// 
/// يعرض:
/// - إذا role == 'customer' أو null → CustomerShell دائماً
/// - إذا role == 'merchant' أو 'admin':
///   - إذا login_as == 'merchant' → MerchantAdminShell (لوحة التحكم)
///   - إذا login_as == 'customer' أو null → CustomerShell (تجربة كعميل)
class RoleBasedRoot extends StatefulWidget {
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
  State<RoleBasedRoot> createState() => _RoleBasedRootState();
}

class _RoleBasedRootState extends State<RoleBasedRoot> {
  String? _loginAs;

  @override
  void initState() {
    super.initState();
    _loadLoginAs();
  }

  Future<void> _loadLoginAs() async {
    final loginAs = await SecureStorageService.getString('login_as');
    setState(() {
      _loginAs = loginAs;
    });
  }

  @override
  Widget build(BuildContext context) {
    // إذا كان role == 'customer' أو null → عرض CustomerShell دائماً
    if (widget.role != 'merchant' && widget.role != 'admin') {
      return CustomerShell(
        appModeProvider: widget.appModeProvider,
        userRole: widget.role,
        themeProvider: widget.themeProvider,
      );
    }

    // إذا كان role == 'merchant' أو 'admin'
    // إذا login_as == 'merchant' → عرض MerchantAdminShell (لوحة التحكم)
    if (_loginAs == 'merchant') {
      return MerchantAdminShell(
        userProfile: widget.userProfile,
        role: widget.role!,
        appModeProvider: widget.appModeProvider,
        themeProvider: widget.themeProvider,
      );
    }

    // إذا login_as == 'customer' أو null → عرض CustomerShell (تجربة كعميل)
    return CustomerShell(
      appModeProvider: widget.appModeProvider,
      userRole: widget.role,
      themeProvider: widget.themeProvider,
    );
  }
}

