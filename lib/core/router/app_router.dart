import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../shared/screens/login_screen.dart';
import '../../features/auth/data/auth_controller.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
// Dashboard
import '../../features/dashboard/presentation/screens/dashboard_shell.dart';
import '../../features/dashboard/presentation/screens/home_tab.dart';
import '../../features/dashboard/presentation/screens/orders_tab.dart';
import '../../features/dashboard/presentation/screens/products_tab.dart';
import '../../features/dashboard/presentation/screens/merchant_services_screen.dart';
import '../../features/dashboard/presentation/screens/mbuy_tools_screen.dart';
import '../../features/dashboard/presentation/screens/shortcuts_screen.dart';
import '../../features/dashboard/presentation/screens/audit_logs_screen.dart';
import '../../features/dashboard/presentation/screens/notifications_screen.dart';
import '../../features/dashboard/presentation/screens/customers_screen.dart';
import '../../features/dashboard/presentation/screens/mbuy_packages_screen.dart';
import '../../features/dashboard/presentation/screens/reports_screen.dart';
// Finance
import '../../features/finance/presentation/screens/wallet_screen.dart';
import '../../features/finance/presentation/screens/points_screen.dart';
import '../../features/finance/presentation/screens/sales_screen.dart';
// Store
import '../../features/store/presentation/screens/store_tab.dart';
import '../../features/store/presentation/screens/inventory_screen.dart';
import '../../features/store/presentation/screens/view_my_store_screen.dart';
import '../../features/store/presentation/screens/store_tools_tab.dart';
// Webstore & Settings
import '../../apps/merchant/features/webstore/webstore_screen.dart';
import '../../apps/merchant/features/shipping/shipping_screen.dart';
import '../../apps/merchant/features/payments/payment_methods_screen.dart';
// Dropshipping
import '../../features/dropshipping/presentation/screens/dropshipping_screen.dart';
import '../../features/dropshipping/presentation/screens/supplier_orders_screen.dart';
// Marketing
import '../../features/marketing/presentation/screens/marketing_screen.dart';
import '../../features/marketing/presentation/screens/coupons_screen.dart';
import '../../features/marketing/presentation/screens/flash_sales_screen.dart';
import '../../features/marketing/presentation/screens/boost_sales_screen.dart';
// Other features
import '../../shared/widgets/base_screen.dart';
import '../../features/conversations/presentation/screens/conversations_screen.dart';
import '../../features/products/presentation/screens/add_product_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/merchant/presentation/screens/create_store_screen.dart';
import '../../features/ai_studio/presentation/screens/mbuy_studio_screen.dart';
import '../../features/merchant/screens/abandoned_cart_screen.dart';
import '../../features/merchant/screens/referral_screen.dart';
import '../../features/merchant/screens/loyalty_program_screen.dart';
import '../../features/merchant/screens/customer_segments_screen.dart';
import '../../features/merchant/screens/custom_messages_screen.dart';
import '../../features/merchant/screens/smart_pricing_screen.dart';
import '../../features/merchant/screens/ai_assistant_screen.dart';
import '../../features/merchant/screens/content_generator_screen.dart';
import '../../features/merchant/screens/smart_analytics_screen.dart';
import '../../features/merchant/screens/auto_reports_screen.dart';
import '../../features/merchant/screens/heatmap_screen.dart';
import '../../features/settings/presentation/screens/account_settings_screen.dart';
import '../../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../../features/settings/presentation/screens/terms_screen.dart';
import '../../features/settings/presentation/screens/support_screen.dart';
import '../../features/settings/presentation/screens/about_screen.dart';
import '../../features/settings/presentation/screens/notification_settings_screen.dart';
import '../../features/settings/presentation/screens/appearance_settings_screen.dart';
import 'go_router_refresh_stream.dart';

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
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // ========================================================================
        // Settings Routes - صفحات الإعدادات (خارج Dashboard)
        // ========================================================================
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const AccountSettingsScreen(),
        ),
        GoRoute(
          path: '/privacy-policy',
          name: 'privacy-policy',
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: '/terms',
          name: 'terms',
          builder: (context, state) => const TermsScreen(),
        ),
        GoRoute(
          path: '/support',
          name: 'support',
          builder: (context, state) => const SupportScreen(),
        ),
        GoRoute(
          path: '/notification-settings',
          name: 'notification-settings',
          builder: (context, state) => const NotificationSettingsScreen(),
        ),
        GoRoute(
          path: '/appearance-settings',
          name: 'appearance-settings',
          builder: (context, state) => const AppearanceSettingsScreen(),
        ),

        // ========================================================================
        // Onboarding Route - جولة تعريفية للمستخدم الجديد
        // ========================================================================
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
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
                  path: 'webstore',
                  name: 'webstore',
                  builder: (context, state) => const WebstoreScreen(),
                ),
                GoRoute(
                  path: 'shipping',
                  name: 'shipping',
                  builder: (context, state) => const ShippingScreen(),
                ),
                GoRoute(
                  path: 'payment-methods',
                  name: 'payment-methods',
                  builder: (context, state) => const PaymentMethodsScreen(),
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
                    return ComingSoonScreen(title: decodedName);
                  },
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
                  path: 'dropshipping',
                  name: 'dropshipping',
                  builder: (context, state) => const DropshippingScreen(),
                ),
                GoRoute(
                  path: 'supplier-orders',
                  name: 'supplier-orders',
                  builder: (context, state) => const SupplierOrdersScreen(),
                ),
                GoRoute(
                  path: 'packages',
                  name: 'packages',
                  builder: (context, state) => const MbuyPackagesScreen(),
                ),
                GoRoute(
                  path: 'reports',
                  name: 'reports',
                  builder: (context, state) => const ReportsScreen(),
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
                // ====== ميزات التسويق ======
                GoRoute(
                  path: 'coupons',
                  name: 'coupons',
                  builder: (context, state) => const CouponsScreen(),
                ),
                GoRoute(
                  path: 'flash-sales',
                  name: 'flash-sales',
                  builder: (context, state) => const FlashSalesScreen(),
                ),
                GoRoute(
                  path: 'abandoned-cart',
                  name: 'abandoned-cart',
                  builder: (context, state) => const AbandonedCartScreen(),
                ),
                GoRoute(
                  path: 'referral',
                  name: 'referral',
                  builder: (context, state) => const ReferralScreen(),
                ),
                GoRoute(
                  path: 'loyalty-program',
                  name: 'loyalty-program',
                  builder: (context, state) => const LoyaltyProgramScreen(),
                ),
                GoRoute(
                  path: 'customer-segments',
                  name: 'customer-segments',
                  builder: (context, state) => const CustomerSegmentsScreen(),
                ),
                GoRoute(
                  path: 'custom-messages',
                  name: 'custom-messages',
                  builder: (context, state) => const CustomMessagesScreen(),
                ),
                GoRoute(
                  path: 'smart-pricing',
                  name: 'smart-pricing',
                  builder: (context, state) => const SmartPricingScreen(),
                ),
                // صفحة المتجر الجديدة (تسويق + أدوات AI)
                GoRoute(
                  path: 'store-tools',
                  name: 'store-tools',
                  builder: (context, state) => const StoreToolsTab(),
                ),
                // صفحة توليد AI (قديمة - للتوافق)
                GoRoute(
                  path: 'ai-generation',
                  name: 'ai-generation',
                  builder: (context, state) => const MbuyStudioScreen(),
                ),
                // ====== أدوات AI الإضافية ======
                GoRoute(
                  path: 'ai-assistant',
                  name: 'ai-assistant',
                  builder: (context, state) => const AiAssistantScreen(),
                ),
                GoRoute(
                  path: 'content-generator',
                  name: 'content-generator',
                  builder: (context, state) => const ContentGeneratorScreen(),
                ),
                // ====== التحليلات المتقدمة ======
                GoRoute(
                  path: 'smart-analytics',
                  name: 'smart-analytics',
                  builder: (context, state) => const SmartAnalyticsScreen(),
                ),
                GoRoute(
                  path: 'auto-reports',
                  name: 'auto-reports',
                  builder: (context, state) => const AutoReportsScreen(),
                ),
                GoRoute(
                  path: 'heatmap',
                  name: 'heatmap',
                  builder: (context, state) => const HeatmapScreen(),
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
                    final quickAdd = extra?['quickAdd'] as bool? ?? false;
                    final name = extra?['name'] as String?;
                    final price = extra?['price'] as String?;
                    return AddProductScreen(
                      productType: productType,
                      quickAdd: quickAdd,
                      initialName: name,
                      initialPrice: price,
                    );
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
            // صفحة من نحن داخل الـ Shell
            GoRoute(
              path: '/dashboard/about',
              name: 'about',
              builder: (context, state) => const AboutScreen(),
            ),
          ],
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
