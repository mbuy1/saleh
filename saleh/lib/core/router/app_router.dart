import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/data/auth_controller.dart';
import '../../features/dashboard/presentation/screens/boost_sales_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_shell.dart';
import '../../features/dashboard/presentation/screens/home_tab.dart';
import '../../features/dashboard/presentation/screens/orders_tab.dart';
import '../../features/dashboard/presentation/screens/products_tab.dart';
import '../../features/dashboard/presentation/screens/store_tab.dart';
import '../../features/dashboard/presentation/screens/placeholder_screen.dart';
import '../../features/dashboard/presentation/screens/merchant_services_screen.dart';
import '../../features/dashboard/presentation/screens/mbuy_tools_screen.dart';
import '../../features/dashboard/presentation/screens/store_on_jock_screen.dart';
import '../../features/conversations/presentation/screens/conversations_screen.dart';
import '../../features/products/presentation/screens/add_product_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/merchant/presentation/screens/create_store_screen.dart';
import '../../features/ai_studio/presentation/screens/mbuy_studio_screen.dart';
import '../../features/marketing/presentation/screens/marketing_screen.dart';
// Customer App Imports
import '../../features/customer_app/presentation/screens/customer_home_screen.dart';
import '../../features/customer_app/presentation/screens/categories_screen.dart';
import '../../features/customer_app/presentation/screens/stores_screen.dart';
import '../../features/customer_app/presentation/screens/media_screen.dart';
import '../../features/customer_app/presentation/screens/customer_cart_screen.dart';
import '../../features/customer_app/presentation/screens/customer_profile_screen.dart';
import '../../features/customer_app/presentation/shells/customer_shell.dart';
import '../providers/app_mode_provider.dart';

/// App Router - Manages navigation throughout the application
/// Uses go_router for declarative routing with authentication protection
///
/// الحماية:
/// - صفحة Dashboard محمية وتتطلب تسجيل دخول
/// - المستخدمون المسجلين لا يمكنهم الوصول لصفحة تسجيل الدخول
/// - يتم إعادة توجيه المستخدمين تلقائياً بناءً على حالة المصادقة
///
/// الوضع المزدوج:
/// - وضع التاجر: /dashboard/*
/// - وضع العميل: /customer/*
class AppRouter {
  /// إنشاء GoRouter مع ref للوصول إلى Riverpod
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/login',

      // التحقق من حالة المصادقة عند كل تنقل
      redirect: (context, state) {
        final authState = ref.read(authControllerProvider);
        final isAuthenticated = authState.isAuthenticated;
        final isLoggingIn = state.matchedLocation == '/login';
        final appModeState = ref.read(appModeProvider);

        // إذا المستخدم غير مسجل ويحاول الوصول لصفحة محمية
        if (!isAuthenticated && !isLoggingIn) {
          return '/login';
        }

        // إذا المستخدم مسجل ويحاول الوصول لصفحة تسجيل الدخول
        if (isAuthenticated && isLoggingIn) {
          // توجيه حسب الوضع المختار
          if (appModeState.isCustomer) {
            return '/customer/home';
          }
          return '/dashboard';
        }

        // لا يوجد إعادة توجيه
        return null;
      },

      // الاستماع لتغييرات حالة المصادقة
      refreshListenable: GoRouterRefreshStream(
        ref.read(authControllerProvider.notifier).stream,
      ),

      routes: [
        // ========================================================================
        // Auth Routes
        // ========================================================================
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),

        // ========================================================================
        // Dashboard Shell Route (محمية) - البار السفلي ثابت
        // ========================================================================
        ShellRoute(
          builder: (context, state, child) => DashboardShell(child: child),
          routes: [
            // الصفحة الرئيسية
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const HomeTab(),
              routes: [
                // الصفحات الفرعية من الرئيسية
                GoRoute(
                  path: 'studio',
                  name: 'mbuy-studio',
                  builder: (context, state) => const MbuyStudioScreen(),
                ),
                GoRoute(
                  path: 'tools',
                  name: 'mbuy-tools',
                  builder: (context, state) => const MbuyToolsScreen(),
                ),
                GoRoute(
                  path: 'marketing',
                  name: 'marketing',
                  builder: (context, state) => const MarketingScreen(),
                ),
                GoRoute(
                  path: 'store-management',
                  name: 'store-management',
                  builder: (context, state) => const MerchantServicesScreen(),
                ),
                GoRoute(
                  path: 'boost-sales',
                  name: 'boost-sales',
                  builder: (context, state) => const BoostSalesScreen(),
                ),
                GoRoute(
                  path: 'store-on-jock',
                  name: 'store-on-jock',
                  builder: (context, state) => const StoreOnJockScreen(),
                ),
                GoRoute(
                  path: 'feature/:name',
                  name: 'feature',
                  builder: (context, state) {
                    final name = state.pathParameters['name'] ?? '';
                    // محاولة فك تشفير النص بأمان
                    String decodedName;
                    try {
                      decodedName = Uri.decodeComponent(name);
                    } catch (e) {
                      // إذا فشل الفك، نستخدم النص كما هو
                      decodedName = name;
                    }
                    return PlaceholderScreen(title: decodedName);
                  },
                ),
              ],
            ),
            // تبويب الطلبات
            GoRoute(
              path: '/dashboard/orders',
              name: 'orders',
              builder: (context, state) => const OrdersTab(),
            ),
            // تبويب المنتجات
            GoRoute(
              path: '/dashboard/products',
              name: 'products',
              builder: (context, state) => const ProductsTab(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'add-product',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    final productType = extra?['productType'] as String?;
                    return AddProductScreen(productType: productType);
                  },
                ),
                GoRoute(
                  path: ':id',
                  name: 'product-details',
                  builder: (context, state) {
                    final productId = state.pathParameters['id']!;
                    return ProductDetailsScreen(productId: productId);
                  },
                ),
              ],
            ),
            // تبويب المحادثات
            GoRoute(
              path: '/dashboard/conversations',
              name: 'conversations',
              builder: (context, state) => const ConversationsScreen(),
            ),
            // تبويب المتجر
            GoRoute(
              path: '/dashboard/store',
              name: 'store',
              builder: (context, state) => const StoreTab(),
              routes: [
                GoRoute(
                  path: 'create-store',
                  name: 'create-store',
                  builder: (context, state) => const CreateStoreScreen(),
                ),
              ],
            ),
          ],
        ),

        // ========================================================================
        // Customer App Shell Route (محمية) - تجربة العميل
        // ========================================================================
        ShellRoute(
          builder: (context, state, child) => CustomerShell(child: child),
          routes: [
            // الصفحة الرئيسية للعميل
            GoRoute(
              path: '/customer/home',
              name: 'customer-home',
              builder: (context, state) => const CustomerHomeScreen(),
            ),
            // صفحة الميديا
            GoRoute(
              path: '/customer/media',
              name: 'customer-media',
              builder: (context, state) => const MediaScreen(),
            ),
            // صفحة التصنيفات
            GoRoute(
              path: '/customer/categories',
              name: 'customer-categories',
              builder: (context, state) => const CategoriesScreen(),
            ),
            // صفحة المتاجر
            GoRoute(
              path: '/customer/stores',
              name: 'customer-stores',
              builder: (context, state) => const StoresScreen(),
            ),
            // صفحة السلة
            GoRoute(
              path: '/customer/cart',
              name: 'customer-cart',
              builder: (context, state) => const CustomerCartScreen(),
            ),
          ],
        ),

        // ========================================================================
        // Customer Profile (خارج الـ Shell - بدون bottom navigation)
        // ========================================================================
        GoRoute(
          path: '/customer/profile',
          name: 'customer-profile',
          builder: (context, state) => const CustomerProfileScreen(),
        ),
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

/// Helper class لجعل GoRouter يستمع لتغييرات StateNotifier
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
