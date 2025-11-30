import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/presentation/screens/auth_screen.dart';
import '../core/supabase_client.dart';
import '../core/app_config.dart';
import '../features/customer/presentation/screens/customer_shell.dart';
import '../features/merchant/presentation/screens/merchant_dashboard_screen.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  User? _user;
  String? _userRole; // 'customer' أو 'merchant'
  bool _isLoading = true;
  late AppModeProvider _appModeProvider;

  @override
  void initState() {
    super.initState();
    _appModeProvider = AppModeProvider();
    _checkAuthState();
    
    // الاستماع لتغييرات حالة Auth
    supabaseClient.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.signedOut) {
        _checkAuthState();
      }
    });

    // الاستماع لتغييرات AppMode
    _appModeProvider.addListener(_onAppModeChanged);
  }

  @override
  void dispose() {
    _appModeProvider.removeListener(_onAppModeChanged);
    _appModeProvider.dispose();
    super.dispose();
  }

  void _onAppModeChanged() {
    setState(() {
      // إعادة بناء الشاشة عند تغيير AppMode
    });
  }

  Future<void> _checkAuthState() async {
    setState(() {
      _isLoading = true;
    });

    // جلب المستخدم الحالي
    final user = supabaseClient.auth.currentUser;
    
    if (user != null) {
      // جلب role من user_profiles
      try {
        final response = await supabaseClient
            .from('user_profiles')
            .select('role')
            .eq('id', user.id)
            .single();

        final role = response['role'] as String? ?? 'customer';
        
        setState(() {
          _user = user;
          _userRole = role; // حفظ role لتمريره إلى CustomerShell
          // تحديد AppMode بناءً على role
          if (role == 'merchant') {
            _appModeProvider.setMerchantMode();
          } else {
            _appModeProvider.setCustomerMode();
          }
        });
      } catch (e) {
        // في حالة الخطأ، افترض customer
        setState(() {
          _user = user;
          _userRole = 'customer';
          _appModeProvider.setCustomerMode();
        });
      }
    } else {
      setState(() {
        _user = null;
        _userRole = null;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // إذا المستخدم غير مسجل → عرض شاشة Auth
    if (_user == null) {
      return const AuthScreen();
    }

    // إذا المستخدم مسجل → عرض الشاشة المناسبة بناءً على AppMode
    // يمكن للتاجر التبديل إلى وضع العميل (كمشاهد)
    if (_appModeProvider.mode == AppMode.merchant) {
      return MerchantDashboardScreen(appModeProvider: _appModeProvider);
    } else {
      return CustomerShell(
        appModeProvider: _appModeProvider,
        userRole: _userRole,
      );
    }
  }
}

