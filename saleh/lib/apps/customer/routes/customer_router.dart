import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/main/customer_main_screen.dart';
import '../features/product/product_detail_screen.dart';
import '../features/store/store_page_screen.dart';
import '../features/search/search_screen.dart';
import '../features/checkout/checkout_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/favorites/favorites_screen.dart';

/// Customer Router - التنقل داخل تطبيق العميل
class CustomerRouter {
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        // الصفحة الرئيسية (Bottom Navigation)
        GoRoute(
          path: '/',
          name: 'customer-home',
          builder: (context, state) => const CustomerMainScreen(),
        ),

        // تفاصيل المنتج
        GoRoute(
          path: '/product/:id',
          name: 'product-detail',
          builder: (context, state) {
            final productId = state.pathParameters['id'] ?? '';
            return ProductDetailScreen(productId: productId);
          },
        ),

        // صفحة المتجر
        GoRoute(
          path: '/store/:id',
          name: 'store-page',
          builder: (context, state) {
            final storeId = state.pathParameters['id'] ?? '';
            return StorePageScreen(storeId: storeId);
          },
        ),

        // البحث
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) {
            final storeId = state.uri.queryParameters['store'];
            return SearchScreen(storeId: storeId);
          },
        ),

        // المفضلة
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),

        // طلباتي
        GoRoute(
          path: '/orders',
          name: 'orders',
          builder: (context, state) => const OrdersScreen(),
        ),

        // Checkout
        GoRoute(
          path: '/checkout',
          name: 'checkout',
          builder: (context, state) => const CheckoutScreen(),
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
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('العودة للرئيسية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
