import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/data/auth_controller.dart';
import '../../../features/customer_app/presentation/screens/customer_home_screen.dart';
import '../../../features/customer_app/presentation/screens/categories_screen.dart';
import '../../../features/customer_app/presentation/screens/stores_screen.dart';
import '../../../features/customer_app/presentation/screens/media_screen.dart';
import '../../../features/customer_app/presentation/screens/customer_cart_screen.dart';
import '../../../features/customer_app/presentation/screens/customer_profile_screen.dart';
import '../../../features/customer_app/presentation/screens/store_details_screen.dart';
import '../../../features/customer_app/presentation/screens/product_details_screen.dart';
import '../../../features/customer_app/presentation/screens/category_products_screen.dart';
import '../../../features/customer_app/presentation/shells/customer_shell.dart';

/// Router خاص بتطبيق العميل فقط
/// لا يحتوي أي مسارات للتاجر
class CustomerRouter {
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/home',

      // حماية المسارات
      redirect: (context, state) {
        final authState = ref.read(authControllerProvider);
        final isAuthenticated = authState.isAuthenticated;

        // إذا المستخدم غير مسجل - يعود لشاشة الاختيار
        if (!isAuthenticated) {
          return null; // سيتم التعامل معه من RootController
        }

        return null;
      },

      refreshListenable: GoRouterRefreshStream(
        ref.read(authControllerProvider.notifier).stream,
      ),

      routes: [
        // ========================================================================
        // Customer Shell Routes - تجربة العميل
        // ========================================================================
        ShellRoute(
          builder: (context, state, child) => CustomerShell(child: child),
          routes: [
            // الصفحة الرئيسية
            GoRoute(
              path: '/home',
              name: 'customer-home',
              builder: (context, state) => const CustomerHomeScreen(),
            ),
            // صفحة الميديا
            GoRoute(
              path: '/media',
              name: 'customer-media',
              builder: (context, state) => const MediaScreen(),
            ),
            // صفحة التصنيفات
            GoRoute(
              path: '/categories',
              name: 'customer-categories',
              builder: (context, state) => const CategoriesScreen(),
            ),
            // صفحة المتاجر
            GoRoute(
              path: '/stores',
              name: 'customer-stores',
              builder: (context, state) => const StoresScreen(),
            ),
            // صفحة السلة
            GoRoute(
              path: '/cart',
              name: 'customer-cart',
              builder: (context, state) => const CustomerCartScreen(),
            ),
          ],
        ),

        // ========================================================================
        // صفحات خارج Shell (بدون bottom navigation)
        // ========================================================================
        GoRoute(
          path: '/profile',
          name: 'customer-profile',
          builder: (context, state) => const CustomerProfileScreen(),
        ),
        // صفحة تفاصيل المتجر
        GoRoute(
          path: '/store/:storeId',
          name: 'store-details',
          builder: (context, state) {
            final storeId = state.pathParameters['storeId'] ?? '';
            return StoreDetailsScreen(storeId: storeId);
          },
        ),
        // صفحة تفاصيل المنتج
        GoRoute(
          path: '/product/:productId',
          name: 'product-details',
          builder: (context, state) {
            final productId = state.pathParameters['productId'] ?? '';
            return ProductDetailsScreen(productId: productId);
          },
        ),
        // صفحة منتجات الفئة
        GoRoute(
          path: '/category/:categoryId',
          name: 'category-products',
          builder: (context, state) {
            final categoryId = state.pathParameters['categoryId'] ?? '';
            final categoryName = state.uri.queryParameters['name'] ?? 'فئة';
            return CategoryProductsScreen(
              categoryId: categoryId,
              categoryName: categoryName,
            );
          },
        ),
      ],

      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'الصفحة غير موجودة',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('العودة للرئيسية'),
              ),
            ],
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
