import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

/// حالة المصادقة
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;
  final String? userRole;
  final String? userId;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.userRole,
    this.userId,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    String? userRole,
    String? userId,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
      userRole: userRole ?? this.userRole,
      userId: userId ?? this.userId,
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

        state = state.copyWith(
          isAuthenticated: true,
          userRole: userRole,
          userId: userId,
        );
      }
    } catch (e) {
      // في حالة وجود خطأ، نعتبر المستخدم غير مسجل
      state = state.copyWith(isAuthenticated: false);
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
      final profile = result['profile'] as Map<String, dynamic>;
      final user = result['user'] as Map<String, dynamic>;

      // تحديث الحالة - نجح تسجيل الدخول
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
        userRole: profile['role'] as String?,
        userId: user['id'] as String?,
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

        state = state.copyWith(
          isAuthenticated: true,
          userRole: userRole,
          userId: userId,
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
