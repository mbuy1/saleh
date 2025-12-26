import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/data/auth_controller.dart';
// Routes
import 'routes/auth_routes.dart';
import 'routes/settings_routes.dart';
import 'routes/dashboard_routes.dart';

/// Helper class to refresh GoRouter when auth state changes
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(WidgetRef ref) {
    // Listen to auth state changes
    // When authControllerProvider changes, notify listeners
    ref.listenManual(authControllerProvider, (previous, next) {
      notifyListeners();
    });
  }
}

/// App Router - Manages navigation throughout the application
/// Uses go_router for declarative routing with authentication protection
///
/// الحماية:
/// - صفحة Dashboard محمية وتتطلب تسجيل دخول + دور merchant
/// - المستخدمون المسجلين لا يمكنهم الوصول لصفحة تسجيل الدخول
/// - يتم إعادة توجيه المستخدمين تلقائياً بناءً على حالة المصادقة والدور
///
/// الوضع الوحيد:
/// - وضع التاجر فقط: /dashboard/*
class AppRouter {
  /// إنشاء GoRouter مع ref للوصول إلى Riverpod
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/login',

      // التحقق من حالة المصادقة والدور عند كل تنقل
      redirect: (context, state) {
        final authState = ref.read(authControllerProvider);
        final isAuthenticated = authState.isAuthenticated;
        final userRole = authState.userRole;
        final isLoggingIn = state.matchedLocation == '/login';
        final isDashboardRoute = state.matchedLocation.startsWith('/dashboard');

        // إذا المستخدم غير مسجل ويحاول الوصول لصفحة محمية
        if (!isAuthenticated && !isLoggingIn) {
          return '/login';
        }

        // Role-based protection: فقط merchant يمكنه الوصول لـ dashboard
        if (isAuthenticated && isDashboardRoute && userRole != 'merchant') {
          // إذا كان المستخدم ليس merchant، نعيده لصفحة تسجيل الدخول
          return '/login';
        }

        // إذا المستخدم مسجل ويحاول الوصول لصفحة تسجيل الدخول
        if (isAuthenticated && isLoggingIn) {
          // توجيه لـ dashboard (merchant فقط)
          return '/dashboard';
        }

        // لا يوجد إعادة توجيه
        return null;
      },

      // الاستماع لتغييرات حالة المصادقة
      refreshListenable: _AuthRefreshNotifier(ref),

      routes: [
        // Auth Routes (login, register, forgot-password, onboarding)
        ...authRoutes,

        // Settings Routes (outside Dashboard Shell)
        ...settingsRoutes,

        // Dashboard Shell Route (protected) - all merchant screens
        dashboardShellRoute,
      ],

      // Error handler
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text(
            'خطأ في التنقل: ${state.error}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
