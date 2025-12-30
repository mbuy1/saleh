import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

/// حالة المصادقة (Worker v2.0)
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;
  final String? userType; // تغيير من userRole
  final String? userId;
  final String? userEmail;
  final String? merchantId; // جديد
  final String? displayName; // جديد

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.userType,
    this.userId,
    this.userEmail,
    this.merchantId,
    this.displayName,
  });

  /// للتوافق مع الكود القديم
  @Deprecated('Use userType instead')
  String? get userRole => userType;

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    String? userType,
    String? userId,
    String? userEmail,
    String? merchantId,
    String? displayName,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
      userType: userType ?? this.userType,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      merchantId: merchantId ?? this.merchantId,
      displayName: displayName ?? this.displayName,
    );
  }
}

/// Auth Controller - يدير حالة المصادقة باستخدام Riverpod (Worker v2.0)
class AuthController extends Notifier<AuthState> {
  late AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    // التحقق من الجلسة عند بدء التطبيق
    _checkInitialSession();
    return const AuthState();
  }

  /// التحقق من الجلسة الأولية
  Future<void> _checkInitialSession() async {
    try {
      final hasSession = await _authRepository.hasValidSession();
      if (!ref.mounted) return;

      if (hasSession) {
        final userData = await _authRepository.getAllUserData();
        if (!ref.mounted) return;

        state = state.copyWith(
          isAuthenticated: true,
          userType: userData['userType'],
          userId: userData['userId'],
          userEmail: userData['userEmail'],
          merchantId: userData['merchantId'],
          displayName: userData['displayName'],
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isAuthenticated: false);
    }
  }

  /// تسجيل حساب جديد
  ///
  /// [email] البريد الإلكتروني
  /// [password] كلمة المرور
  /// [fullName] الاسم الكامل
  /// [userType] نوع المستخدم: merchant أو customer
  Future<void> register({
    required String email,
    required String password,
    String? fullName,
    String userType = 'merchant',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        userType: userType,
      );

      if (!ref.mounted) return;

      final user = result['user'] as Map<String, dynamic>;

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
        userType: user['user_type'] as String? ?? userType,
        userId: user['id'] as String?,
        userEmail: user['email'] as String?,
        merchantId: user['merchant_id'] as String?,
        displayName: user['full_name'] as String? ?? fullName,
      );
    } on Exception catch (e) {
      if (!ref.mounted) return;
      String errorMsg = e.toString().replaceFirst('Exception: ', '');

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: errorMsg,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: 'حدث خطأ غير متوقع',
      );
    }
  }

  /// تسجيل الدخول
  ///
  /// [identifier] الإيميل
  /// [password] كلمة المرور
  /// [loginAs] اختياري: غير مستخدم (للتوافق)
  Future<void> login({
    required String identifier,
    required String password,
    String? loginAs,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _authRepository.signIn(
        identifier: identifier,
        password: password,
        loginAs: loginAs,
      );

      if (!ref.mounted) return;

      final user = result['user'] as Map<String, dynamic>;

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
        userType: user['user_type'] as String? ?? 'customer',
        userId: user['id'] as String?,
        userEmail: user['email'] as String?,
        merchantId: user['merchant_id'] as String?,
        displayName: user['full_name'] as String?,
      );
    } on Exception catch (e) {
      if (!ref.mounted) return;
      String errorMsg = e.toString().replaceFirst('Exception: ', '');

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: errorMsg,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: 'حدث خطأ غير متوقع',
      );
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      await _authRepository.signOut();
      if (!ref.mounted) return;

      state = const AuthState(isLoading: false, isAuthenticated: false);
    } catch (e) {
      if (!ref.mounted) return;
      state = const AuthState(isLoading: false, isAuthenticated: false);
    }
  }

  /// مسح رسالة الخطأ
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// إعادة التحقق من الجلسة
  Future<void> checkSession() async {
    try {
      final hasSession = await _authRepository.hasValidSession();
      if (!ref.mounted) return;

      if (hasSession) {
        final userData = await _authRepository.getAllUserData();
        if (!ref.mounted) return;

        state = state.copyWith(
          isAuthenticated: true,
          userType: userData['userType'],
          userId: userData['userId'],
          userEmail: userData['userEmail'],
          merchantId: userData['merchantId'],
          displayName: userData['displayName'],
        );
      } else {
        state = state.copyWith(isAuthenticated: false);
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isAuthenticated: false);
    }
  }
}

// ==========================================================================
// Riverpod Providers
// ==========================================================================

/// Provider لـ AuthController
final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Provider للتحقق السريع من حالة تسجيل الدخول
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isAuthenticated;
});

/// Provider للحصول على نوع المستخدم
final userTypeProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).userType;
});

/// للتوافق مع الكود القديم
@Deprecated('Use userTypeProvider instead')
final userRoleProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).userType;
});

/// Provider للحصول على إيميل المستخدم
final userEmailProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).userEmail;
});

/// Provider للحصول على معرف التاجر
final merchantIdProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).merchantId;
});

/// Provider للحصول على اسم العرض
final displayNameProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).displayName;
});
