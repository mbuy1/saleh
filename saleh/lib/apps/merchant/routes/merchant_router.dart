import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/data/auth_controller.dart';
import '../../../features/dashboard/presentation/screens/dashboard_shell.dart';
import '../../../features/dashboard/presentation/screens/home_tab.dart';
import '../../../features/dashboard/presentation/screens/orders_tab.dart';
import '../../../features/dashboard/presentation/screens/products_tab.dart';
import '../../../features/dashboard/presentation/screens/store_tab.dart';
import '../../../features/dashboard/presentation/screens/placeholder_screen.dart';
import '../../../features/dashboard/presentation/screens/merchant_services_screen.dart';
import '../../../features/dashboard/presentation/screens/mbuy_tools_screen.dart';
import '../../../features/dashboard/presentation/screens/store_on_jock_screen.dart';
import '../../../features/dashboard/presentation/screens/shortcuts_screen.dart';
import '../../../features/dashboard/presentation/screens/inventory_screen.dart';
import '../../../features/dashboard/presentation/screens/audit_logs_screen.dart';
import '../../../features/dashboard/presentation/screens/view_my_store_screen.dart';
import '../../../features/dashboard/presentation/screens/notifications_screen.dart';
import '../../../features/dashboard/presentation/screens/customers_screen.dart';
import '../../../features/dashboard/presentation/screens/wallet_screen.dart';
import '../../../features/dashboard/presentation/screens/points_screen.dart';
import '../../../features/dashboard/presentation/screens/sales_screen.dart';
import '../../../features/conversations/presentation/screens/conversations_screen.dart';
import '../../../features/products/presentation/screens/add_product_screen.dart';
import '../../../features/products/presentation/screens/product_details_screen.dart';
import '../../../features/merchant/presentation/screens/create_store_screen.dart';
import '../../../features/ai_studio/presentation/screens/mbuy_studio_screen.dart';
import '../../../features/marketing/presentation/screens/marketing_screen.dart';

/// Router خاص بتطبيق التاجر فقط
/// لا يحتوي أي مسارات للعميل
class MerchantRouter {
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/dashboard',

      // حماية المسارات
      redirect: (context, state) {
        final authState = ref.read(authControllerProvider);
        final isAuthenticated = authState.isAuthenticated;

        // إذا المستخدم غير مسجل
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
        // Merchant Dashboard Shell Routes - لوحة تحكم التاجر
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
                  redirect: (context, state) => '/dashboard',
                ),
                GoRoute(
                  path: 'store-on-jock',
                  name: 'store-on-jock',
                  builder: (context, state) => const StoreOnJockScreen(),
                ),
                // الشاشات الجديدة v2.0
                GoRoute(
                  path: 'shortcuts',
                  name: 'shortcuts',
                  builder: (context, state) => const ShortcutsScreen(),
                ),
                GoRoute(
                  path: 'promotions',
                  name: 'promotions',
                  redirect: (context, state) => '/dashboard',
                ),
                GoRoute(
                  path: 'inventory',
                  name: 'inventory',
                  builder: (context, state) => const InventoryScreen(),
                ),
                GoRoute(
                  path: 'audit-logs',
                  name: 'audit-logs',
                  builder: (context, state) => const AuditLogsScreen(),
                ),
                GoRoute(
                  path: 'view-store',
                  name: 'view-store',
                  builder: (context, state) => const ViewMyStoreScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  name: 'notifications',
                  builder: (context, state) => const NotificationsScreen(),
                ),
                GoRoute(
                  path: 'customers',
                  name: 'customers',
                  builder: (context, state) => const CustomersScreen(),
                ),
                // صفحات الإحصائيات (بطاقات الرصيد/النقاط/المبيعات)
                GoRoute(
                  path: 'wallet',
                  name: 'wallet',
                  builder: (context, state) => const WalletScreen(),
                ),
                GoRoute(
                  path: 'points',
                  name: 'points',
                  builder: (context, state) => const PointsScreen(),
                ),
                GoRoute(
                  path: 'sales',
                  name: 'sales',
                  builder: (context, state) => const SalesScreen(),
                ),
                GoRoute(
                  path: 'feature/:name',
                  name: 'feature',
                  builder: (context, state) {
                    final name = state.pathParameters['name'] ?? '';
                    String decodedName;
                    try {
                      decodedName = Uri.decodeComponent(name);
                    } catch (e) {
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
                onPressed: () => context.go('/dashboard'),
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
