import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/presentation/screens/auth_screen.dart';
import '../core/app_config.dart';
import '../core/theme/theme_provider.dart';
import '../core/firebase_service.dart';
import '../core/session/store_session.dart';
import '../shared/widgets/mbuy_loader.dart';
import 'services/api_service.dart';
import '../features/auth/data/auth_repository.dart';
import 'role_based_root.dart';

class RootWidget extends StatefulWidget {
  final ThemeProvider themeProvider;

  const RootWidget({super.key, required this.themeProvider});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  Map<String, dynamic>? _user; // User data from MBUY Auth
  Map<String, dynamic>? _userProfile; // User profile from user_profiles table
  String? _userRole; // 'customer' أو 'merchant' أو 'admin'
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
    // No Supabase Auth - only check for token in secure storage
    try {
      debugPrint('🔍 [RootWidget] Checking auth state...');

      final isLoggedIn = await AuthRepository.isLoggedIn();

      if (!isLoggedIn) {
        debugPrint(
          '🔍 [RootWidget] No token found in secure storage - User not logged in',
        );
        setState(() {
          _user = null;
          _userRole = null;
          _isLoading = false;
        });
        return;
      }

      debugPrint('🔍 [RootWidget] Token found, verifying with /auth/me...');

      // Verify token by calling /auth/me and get user data
      try {
        final userData = await AuthRepository.verifyAndLoadUser();
        final userId = userData['id'] as String?;
        final userEmail = userData['email'] as String?;

        debugPrint('✅ [RootWidget] Token verified successfully');
        debugPrint('🔍 [RootWidget] User ID: $userId, Email: $userEmail');

        if (userId != null) {
          // تعيين User ID في Analytics
          await FirebaseService.setUserId(userId);

          // جلب role من user_profiles عبر Worker API
          try {
            final profileResponse = await ApiService.get('/secure/users/me');

            if (profileResponse['ok'] == true &&
                profileResponse['data'] != null) {
              final profile = profileResponse['data'] as Map<String, dynamic>;
              final role = profile['role'] as String? ?? 'customer';
              final displayName = profile['display_name'] as String?;

              debugPrint('✅ تم جلب role: $role');
              debugPrint('✅ User ID: $userId');
              debugPrint('✅ Display Name: $displayName');

              // تحديد AppMode بناءً على role قبل setState
              if (role == 'merchant' || role == 'admin') {
                debugPrint('🛒 تم تفعيل وضع التاجر/الأدمن');
                _appModeProvider.setMerchantMode();
                // جلب store_id للتاجر مباشرة بعد تسجيل الدخول (admin لا يحتاج store)
                if (role == 'merchant') {
                  _loadMerchantStoreId();
                }
              } else {
                debugPrint('🛍️ تم تفعيل وضع العميل');
                _appModeProvider.setCustomerMode();
              }

              setState(() {
                _user = userData;
                _userProfile = profile;
                _userRole = role;
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
                _userProfile = null; // لم يتم إنشاء profile بعد
                _userRole = 'customer';
                _appModeProvider.setCustomerMode();
              });
            }
          } catch (e) {
            debugPrint('⚠️ خطأ في جلب بيانات المستخدم: $e');
            // في حالة الخطأ، افترض customer
            setState(() {
              _user = userData;
              _userProfile = null;
              _userRole = 'customer';
              _appModeProvider.setCustomerMode();
            });
          }
        } else {
          debugPrint('⚠️ [RootWidget] User ID is null after verification');
          setState(() {
            _user = null;
            _userRole = null;
          });
        }
      } catch (e) {
        // Token verification failed - clear token and show login screen
        debugPrint('⚠️ [RootWidget] Token verification failed: $e');
        debugPrint('⚠️ [RootWidget] Clearing token and showing login screen');

        // Token already cleared in verifyAndLoadUser, but ensure it's cleared
        await AuthRepository.logout();

        setState(() {
          _user = null;
          _userRole = null;
        });
      }
    } catch (e) {
      debugPrint('⚠️ [RootWidget] Error checking auth state: $e');
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
      debugPrint(
        '🔍 [StoreSession] Timestamp: ${DateTime.now().toIso8601String()}',
      );

      // إذا كان store_id محفوظاً بالفعل، لا حاجة لإعادة الجلب
      if (storeSession.hasStore) {
        debugPrint(
          '✅ [StoreSession] Store ID موجود بالفعل: ${storeSession.storeId}',
        );
        return;
      }

      debugPrint('🔄 [StoreSession] جاري جلب معلومات المتجر عبر Worker API...');

      // جلب المتجر عبر Worker API
      final result = await ApiService.get('/secure/merchant/store');

      debugPrint(
        '📥 [StoreSession] استجابة API: ok=${result['ok']}, hasData=${result['data'] != null}, error=${result['error']}',
      );

      if (result['ok'] == true && result['data'] != null) {
        final store = result['data'] as Map<String, dynamic>;
        final storeId = store['id'] as String?;
        final ownerId = store['owner_id'] as String?;
        final storeName = store['name'] as String?;

        debugPrint(
          '📦 [StoreSession] بيانات المتجر: storeId=$storeId, storeName=$storeName, ownerId=$ownerId, userId=$userId, userIdMatches=${ownerId == userId}',
        );

        if (storeId != null && storeId.isNotEmpty) {
          storeSession.setStoreId(storeId);
          debugPrint(
            '✅ [StoreSession] تم حفظ Store ID بعد تسجيل الدخول: $storeId',
          );
          debugPrint('✅ [StoreSession] Store Name: ${storeName ?? "N/A"}');
          debugPrint('✅ [StoreSession] Owner ID من DB: $ownerId');
          debugPrint('✅ [StoreSession] User ID من Flutter: $userId');
          if (ownerId != null && userId != null) {
            debugPrint(
              '${ownerId == userId ? "✅" : "⚠️"} [StoreSession] تطابق User ID: ${ownerId == userId}',
            );
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
        debugPrint(
          'ℹ️ [StoreSession] إذا كان المستخدم تاجر، سيتم إنشاء متجر تلقائياً في المرة القادمة',
        );
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
                      // Skip auth - enter guest mode without any Supabase Auth
                      debugPrint(
                        '⏭️ [RootWidget] Skipping auth - entering guest mode',
                      );
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

    // إذا المستخدم مسجل أو في وضع الضيف → عرض الشاشة المناسبة بناءً على role
    // استخدام RoleBasedRoot للتعامل مع جميع الحالات
    return RoleBasedRoot(
      userProfile: _userProfile,
      role: _userRole,
      themeProvider: widget.themeProvider,
      appModeProvider: _appModeProvider,
    );
  }
}
