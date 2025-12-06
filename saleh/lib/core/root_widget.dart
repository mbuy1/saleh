import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/presentation/screens/auth_screen.dart';
import '../core/supabase_client.dart';
import '../core/app_config.dart';
import '../core/theme/theme_provider.dart';
import '../core/firebase_service.dart';
import '../core/session/store_session.dart';
import '../shared/widgets/mbuy_loader.dart';
import '../features/customer/presentation/screens/customer_shell.dart';
import '../features/merchant/presentation/screens/merchant_home_screen.dart';
import 'services/api_service.dart';
import '../features/auth/data/auth_repository.dart';

class RootWidget extends StatefulWidget {
  final ThemeProvider themeProvider;

  const RootWidget({super.key, required this.themeProvider});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  Map<String, dynamic>? _user; // User data from MBUY Auth
  String? _userRole; // 'customer' أو 'merchant'
  bool _isLoading = true;
  bool _isGuestMode = false; // وضع الضيف
  late AppModeProvider _appModeProvider;

  @override
  void initState() {
    super.initState();
    _appModeProvider = AppModeProvider();
    _checkAuthState();

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

    // جلب المستخدم الحالي من MBUY Auth فقط
    try {
      final isLoggedIn = await AuthRepository.isLoggedIn();
      
      if (!isLoggedIn) {
        debugPrint('🔍 [MBUY Auth] User is not logged in');
        setState(() {
          _user = null;
          _userRole = null;
          _isLoading = false;
        });
        return;
      }

      // Verify token by calling /auth/me
      final isValid = await AuthRepository.verifyToken();
      if (!isValid) {
        debugPrint('⚠️ [MBUY Auth] Token is invalid, clearing...');
        setState(() {
          _user = null;
          _userRole = null;
          _isLoading = false;
        });
        return;
      }

      // Get user info
      final userData = await AuthRepository.getCurrentUser();
      final userId = await AuthRepository.getUserId();
      final userEmail = await AuthRepository.getUserEmail();

      debugPrint('🔍 [MBUY Auth] User ID: $userId, Email: $userEmail');

      if (userId != null) {
        // تعيين User ID في Analytics
        await FirebaseService.setUserId(userId);

        // جلب role من user_profiles
        try {
          final response = await supabaseClient
              .from('user_profiles')
              .select('role, display_name')
              .eq('id', userId)
              .maybeSingle();

          if (response != null) {
            final role = response['role'] as String? ?? 'customer';

            debugPrint('✅ تم جلب role: $role');
            debugPrint('✅ User ID: $userId');
            debugPrint('✅ Display Name: ${response['display_name']}');

            setState(() {
              _user = userData;
              _userRole = role;
              // تحديد AppMode بناءً على role
              if (role == 'merchant') {
                debugPrint('🛒 تم تفعيل وضع التاجر');
                _appModeProvider.setMerchantMode();
                // جلب store_id للتاجر مباشرة بعد تسجيل الدخول
                _loadMerchantStoreId();
              } else {
                debugPrint('🛍️ تم تفعيل وضع العميل');
                _appModeProvider.setCustomerMode();
              }
            });
          } else {
            // إذا لم يوجد سجل في user_profiles، أنشئه عبر Worker API
            try {
              final email = await AuthRepository.getUserEmail();
              
              await ApiService.post(
                '/secure/auth/initialize-user',
                data: {
                  'role': 'customer',
                  'display_name': email?.split('@')[0] ?? 'مستخدم',
                },
              );
              debugPrint('✅ تم إنشاء user_profile + wallet عبر Worker API');
            } catch (e) {
              debugPrint('⚠️ فشل إنشاء user_profile/wallet: $e');
            }

            setState(() {
              _user = userData;
              _userRole = 'customer';
              _appModeProvider.setCustomerMode();
            });
          }
        } catch (e) {
          debugPrint('⚠️ خطأ في جلب بيانات المستخدم: $e');
          // في حالة الخطأ، افترض customer
          setState(() {
            _user = userData;
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
    } catch (e) {
      debugPrint('⚠️ [MBUY Auth] Error checking auth state: $e');
      setState(() {
        _user = null;
        _userRole = null;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// جلب store_id للتاجر بعد تسجيل الدخول
  Future<void> _loadMerchantStoreId() async {
    try {
      final storeSession = context.read<StoreSession>();
      
      // جلب معلومات المستخدم الحالي من MBUY Auth
      final userId = await AuthRepository.getUserId();
      final userEmail = await AuthRepository.getUserEmail();
      
      debugPrint('🔍 [StoreSession] بدء جلب معلومات المتجر...');
      debugPrint('🔍 [StoreSession] User ID من Flutter: $userId');
      debugPrint('🔍 [StoreSession] User Email: ${userEmail ?? "N/A"}');
      debugPrint('🔍 [StoreSession] Timestamp: ${DateTime.now().toIso8601String()}');
      
      // إذا كان store_id محفوظاً بالفعل، لا حاجة لإعادة الجلب
      if (storeSession.hasStore) {
        debugPrint('✅ [StoreSession] Store ID موجود بالفعل: ${storeSession.storeId}');
        return;
      }

      debugPrint('🔄 [StoreSession] جاري جلب معلومات المتجر عبر Worker API...');
      
      // جلب المتجر عبر Worker API
      final result = await ApiService.get('/secure/merchant/store');
      
      debugPrint('📥 [StoreSession] استجابة API: ok=${result['ok']}, hasData=${result['data'] != null}, error=${result['error']}');

      if (result['ok'] == true && result['data'] != null) {
        final store = result['data'] as Map<String, dynamic>;
        final storeId = store['id'] as String?;
        final ownerId = store['owner_id'] as String?;
        final storeName = store['name'] as String?;
        
        debugPrint('📦 [StoreSession] بيانات المتجر: storeId=$storeId, storeName=$storeName, ownerId=$ownerId, userId=$userId, userIdMatches=${ownerId == userId}');
        
        if (storeId != null && storeId.isNotEmpty) {
          storeSession.setStoreId(storeId);
          debugPrint('✅ [StoreSession] تم حفظ Store ID بعد تسجيل الدخول: $storeId');
          debugPrint('✅ [StoreSession] Store Name: ${storeName ?? "N/A"}');
          debugPrint('✅ [StoreSession] Owner ID من DB: $ownerId');
          debugPrint('✅ [StoreSession] User ID من Flutter: $userId');
          if (ownerId != null && userId != null) {
            debugPrint('${ownerId == userId ? "✅" : "⚠️"} [StoreSession] تطابق User ID: ${ownerId == userId}');
          }
        } else {
          debugPrint('⚠️ [StoreSession] المتجر موجود لكن بدون ID');
          storeSession.clear();
        }
      } else {
        // إذا كانت الاستجابة ok لكن data = null، يعني لم يتم العثور على متجر
        // Edge Function ستحاول إنشاء متجر تلقائياً إذا كان المستخدم تاجر
        debugPrint('⚠️ [StoreSession] لم يتم العثور على متجر لهذا الحساب');
        debugPrint('⚠️ [StoreSession] Response: $result');
        debugPrint('ℹ️ [StoreSession] إذا كان المستخدم تاجر، سيتم إنشاء متجر تلقائياً في المرة القادمة');
        storeSession.clear();
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [StoreSession] خطأ في جلب Store ID بعد تسجيل الدخول: $e');
      debugPrint('❌ [StoreSession] Stack trace: $stackTrace');
      // في حالة الخطأ، لا ننظف الـ session الموجود
    }
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
