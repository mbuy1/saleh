import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

/// حالة المصادقة
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;
  final String? userRole;
  final String? userId;
  final String? userEmail;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.userRole,
    this.userId,
    this.userEmail,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    String? userRole,
    String? userId,
    String? userEmail,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
      userRole: userRole ?? this.userRole,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

/// Auth Controller - يدير حالة المصادقة باستخدام Riverpod
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AuthState()) {
    // التحقق من الجلسة عند بدء التطبيق
    _checkInitialSession();
  }

  /// التحقق من الجلسة الأولية
  Future<void> _checkInitialSession() async {
    try {
      final hasSession = await _authRepository.hasValidSession();
      if (hasSession) {
        final userRole = await _authRepository.getUserRole();
        final userId = await _authRepository.getUserId();
        final userEmail = await _authRepository.getUserEmail();

        state = state.copyWith(
          isAuthenticated: true,
          userRole: userRole,
          userId: userId,
          userEmail: userEmail,
        );
      }
    } catch (e) {
      // في حالة وجود خطأ، نعتبر المستخدم غير مسجل
      state = state.copyWith(isAuthenticated: false);
    }
  }

  /// تسجيل حساب جديد
  ///
  /// [email] البريد الإلكتروني
  /// [password] كلمة المرور
  /// [fullName] الاسم الكامل
  /// [role] الدور: merchant أو customer
  Future<void> register({
    required String email,
    required String password,
    String? fullName,
    String role = 'merchant',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );

      final user = result['user'] as Map<String, dynamic>;
      final profile = result['profile'] as Map<String, dynamic>?;

      final userRole =
          user['role'] as String? ?? profile?['role'] as String? ?? role;

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
        userRole: userRole,
        userId: user['id'] as String?,
        userEmail: user['email'] as String?,
      );
    } on Exception catch (e) {
      String errorMsg = e.toString().replaceFirst('Exception: ', '');

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: errorMsg,
      );
    } catch (e) {
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
  /// [loginAs] اختياري: "merchant" أو "customer"
  Future<void> login({
    required String identifier,
    required String password,
    String? loginAs,
  }) async {
    // تعيين حالة التحميل
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // محاولة تسجيل الدخول
      final result = await _authRepository.signIn(
        identifier: identifier,
        password: password,
        loginAs: loginAs,
      );

      // استخراج معلومات المستخدم
      final user = result['user'] as Map<String, dynamic>;

      // Profile قد يكون null
      final profile = result['profile'] != null
          ? result['profile'] as Map<String, dynamic>
          : null;

      // Role من user له الأولوية، ثم profile
      final userRole =
          user['role'] as String? ?? profile?['role'] as String? ?? 'customer';

      // تحديث الحالة - نجح تسجيل الدخول
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
        userRole: userRole,
        userId: user['id'] as String?,
        userEmail: user['email'] as String?,
      );
    } on Exception catch (e) {
      // فشل تسجيل الدخول
      String errorMsg = e.toString().replaceFirst('Exception: ', '');

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: errorMsg,
      );
    } catch (e) {
      // خطأ غير متوقع
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

      // إعادة تعيين الحالة
      state = const AuthState(isLoading: false, isAuthenticated: false);
    } catch (e) {
      // حتى لو فشل، نعتبر المستخدم خرج
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

      if (hasSession) {
        final userRole = await _authRepository.getUserRole();
        final userId = await _authRepository.getUserId();
        final userEmail = await _authRepository.getUserEmail();

        state = state.copyWith(
          isAuthenticated: true,
          userRole: userRole,
          userId: userId,
          userEmail: userEmail,
        );
      } else {
        state = state.copyWith(isAuthenticated: false);
      }
    } catch (e) {
      state = state.copyWith(isAuthenticated: false);
    }
  }
}

// ==========================================================================
// Riverpod Provider
// ==========================================================================

/// Provider لـ AuthController
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(authRepository);
  },
);

/// Provider للتحقق السريع من حالة تسجيل الدخول
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isAuthenticated;
});

/// Provider للحصول على دور المستخدم
final userRoleProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).userRole;
});

/// Provider للحصول على إيميل المستخدم
final userEmailProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).userEmail;
});
