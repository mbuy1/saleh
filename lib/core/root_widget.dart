import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/presentation/screens/auth_screen.dart';
import '../core/supabase_client.dart';
import '../core/app_config.dart';
import '../core/theme/theme_provider.dart';
import '../shared/widgets/mbuy_loader.dart';
import '../features/customer/presentation/screens/customer_shell.dart';
import '../features/merchant/presentation/screens/merchant_home_screen.dart';

class RootWidget extends StatefulWidget {
  final ThemeProvider themeProvider;

  const RootWidget({super.key, required this.themeProvider});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  User? _user;
  String? _userRole; // 'customer' أو 'merchant'
  bool _isLoading = true;
  bool _isGuestMode = false; // وضع الضيف
  late AppModeProvider _appModeProvider;

  @override
  void initState() {
    super.initState();
    _appModeProvider = AppModeProvider();
    _checkAuthState();

    // الاستماع لتغييرات حالة Auth
    supabaseClient.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      debugPrint('🔐 Auth State Changed: ${event.name}');
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.signedOut ||
          event == AuthChangeEvent.tokenRefreshed ||
          event == AuthChangeEvent.initialSession) {
        debugPrint('🔄 إعادة فحص حالة المصادقة...');
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

    // جلب المستخدم الحالي من الجلسة المحفوظة
    final session = supabaseClient.auth.currentSession;
    final user = session?.user;

    debugPrint(
      '🔍 فحص حالة المصادقة: user=${user?.email}, session=${session != null}',
    );

    if (user != null) {
      // جلب role من user_profiles
      try {
        final response = await supabaseClient
            .from('user_profiles')
            .select('role, display_name')
            .eq('id', user.id)
            .maybeSingle();

        if (response != null) {
          final role = response['role'] as String? ?? 'customer';

          setState(() {
            _user = user;
            _userRole = role;
            // تحديد AppMode بناءً على role
            if (role == 'merchant') {
              _appModeProvider.setMerchantMode();
            } else {
              _appModeProvider.setCustomerMode();
            }
          });
        } else {
          // إذا لم يوجد سجل في user_profiles، أنشئه الآن
          await supabaseClient.from('user_profiles').insert({
            'id': user.id,
            'role': 'customer',
            'display_name': user.email?.split('@')[0] ?? 'مستخدم',
          });

          // أنشئ محفظة للمستخدم
          await supabaseClient.from('wallets').insert({
            'owner_id': user.id,
            'type': 'customer',
            'balance': 0,
            'currency': 'SAR',
          });

          setState(() {
            _user = user;
            _userRole = 'customer';
            _appModeProvider.setCustomerMode();
          });
        }
      } catch (e) {
        debugPrint('⚠️ خطأ في جلب بيانات المستخدم: $e');
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
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(child: MbuyLoader()),
      );
    }

    // إذا المستخدم غير مسجل وليس في وضع الضيف → عرض شاشة Auth
    if (_user == null && !_isGuestMode) {
      return Scaffold(
        body: Stack(
          children: [
            const AuthScreen(),
            // زر تخطي عائم في أعلى اليمين
            SafeArea(
              child: Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isGuestMode = true;
                        _appModeProvider.setCustomerMode();
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black87,
                    ),
                    label: const Text(
                      'تخطي',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // إذا المستخدم مسجل أو في وضع الضيف → عرض الشاشة المناسبة بناءً على AppMode
    // يمكن للتاجر التبديل إلى وضع العميل (كمشاهد)
    if (_appModeProvider.mode == AppMode.merchant && _user != null) {
      return MerchantHomeScreen(appModeProvider: _appModeProvider);
    } else {
      return CustomerShell(
        appModeProvider: _appModeProvider,
        userRole: _userRole,
        themeProvider: widget.themeProvider,
      );
    }
  }
}
