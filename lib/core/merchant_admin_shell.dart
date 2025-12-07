import 'package:flutter/material.dart';
import '../features/merchant/presentation/screens/merchant_dashboard_screen.dart';
import '../features/customer/presentation/screens/customer_shell.dart';
import '../core/theme/theme_provider.dart';
import '../core/app_config.dart';

/// Shell خاص للتاجر/الأدمن يحتوي على:
/// - لوحة التحكم (Dashboard)
/// - واجهة التطبيق العادية (Customer view)
/// - زر تبديل في AppBar
class MerchantAdminShell extends StatefulWidget {
  final Map<String, dynamic>? userProfile;
  final String role; // 'merchant' أو 'admin'
  final AppModeProvider appModeProvider;
  final ThemeProvider themeProvider;

  const MerchantAdminShell({
    super.key,
    required this.userProfile,
    required this.role,
    required this.appModeProvider,
    required this.themeProvider,
  });

  @override
  State<MerchantAdminShell> createState() => _MerchantAdminShellState();
}

class _MerchantAdminShellState extends State<MerchantAdminShell> {
  bool _showDashboard = true; // true = Dashboard, false = Customer view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showDashboard
              ? 'لوحة التحكم'
              : 'تطبيق Mbuy',
        ),
        centerTitle: true,
        actions: [
          // زر التبديل بين Dashboard و Customer view
          IconButton(
            icon: Icon(
              _showDashboard
                  ? Icons.shopping_bag_outlined
                  : Icons.dashboard_outlined,
            ),
            tooltip: _showDashboard
                ? 'عرض التطبيق'
                : 'عرض لوحة التحكم',
            onPressed: () {
              setState(() {
                _showDashboard = !_showDashboard;
              });
            },
          ),
        ],
      ),
      body: _showDashboard
          ? MerchantDashboardScreen(
              appModeProvider: widget.appModeProvider,
            )
          : CustomerShell(
              appModeProvider: widget.appModeProvider,
              userRole: widget.role,
              themeProvider: widget.themeProvider,
            ),
    );
  }
}

