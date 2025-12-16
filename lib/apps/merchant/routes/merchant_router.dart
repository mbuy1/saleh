import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/go_router_refresh_stream.dart';
import '../../../core/constants/app_icons.dart';
import '../../../features/auth/data/auth_controller.dart';
import '../../../features/dashboard/presentation/screens/dashboard_shell.dart';
import '../../../features/dashboard/presentation/screens/home_tab.dart';
import '../../../features/dashboard/presentation/screens/orders_tab.dart';
import '../../../features/dashboard/presentation/screens/products_tab.dart';
import '../../../features/dashboard/presentation/screens/store_tab.dart';
import '../../../shared/widgets/base_screen.dart';
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
import '../../../features/dashboard/presentation/screens/coupons_screen.dart';
import '../../../features/dashboard/presentation/screens/flash_sales_screen.dart';
import '../../../features/merchant/screens/abandoned_cart_screen.dart';
import '../../../features/merchant/screens/referral_screen.dart';
import '../../../features/merchant/screens/smart_analytics_screen.dart';
import '../../../features/merchant/screens/auto_reports_screen.dart';
import '../../../features/merchant/screens/heatmap_screen.dart';
import '../../../features/merchant/screens/ai_assistant_screen.dart';
import '../../../features/merchant/screens/content_generator_screen.dart';
import '../../../features/merchant/screens/smart_pricing_screen.dart';
import '../../../features/merchant/screens/customer_segments_screen.dart';
import '../../../features/merchant/screens/custom_messages_screen.dart';
import '../../../features/merchant/screens/loyalty_program_screen.dart';
import '../../../features/merchant/screens/product_variants_screen.dart';
import '../../../features/merchant/screens/product_bundles_screen.dart';
import '../../../features/merchant/screens/digital_products_screen.dart';
import '../features/shipping/shipping_screen.dart';
import '../features/delivery/delivery_options_screen.dart';
import '../features/payments/payment_methods_screen.dart';
import '../features/payments/cod_settings_screen.dart';
import '../features/webstore/webstore_screen.dart';
import '../features/whatsapp/whatsapp_screen.dart';
import '../features/qrcode/qr_code_screen.dart';
import '../../../features/conversations/presentation/screens/conversations_screen.dart';
import '../../../features/products/presentation/screens/add_product_screen.dart';
import '../../../features/products/presentation/screens/product_details_screen.dart';
import '../../../features/merchant/presentation/screens/create_store_screen.dart';
import '../../../features/ai_studio/presentation/screens/ai_studio_cards_screen.dart';
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
                  builder: (context, state) => const AiStudioCardsScreen(),
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
                // ====== الميزات الجديدة ======
                // 1. الكوبونات
                GoRoute(
                  path: 'coupons',
                  name: 'coupons',
                  builder: (context, state) => const CouponsScreen(),
                ),
                // 2. العروض الخاطفة
                GoRoute(
                  path: 'flash-sales',
                  name: 'flash-sales',
                  builder: (context, state) => const FlashSalesScreen(),
                ),
                // 3-23. الميزات الأخرى (placeholder)
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
                GoRoute(
                  path: 'smart-pricing',
                  name: 'smart-pricing',
                  builder: (context, state) => const SmartPricingScreen(),
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
                  path: 'loyalty-program',
                  name: 'loyalty-program',
                  builder: (context, state) => const LoyaltyProgramScreen(),
                ),
                GoRoute(
                  path: 'product-variants',
                  name: 'product-variants',
                  builder: (context, state) => const ProductVariantsScreen(),
                ),
                GoRoute(
                  path: 'product-bundles',
                  name: 'product-bundles',
                  builder: (context, state) => const ProductBundlesScreen(),
                ),
                GoRoute(
                  path: 'digital-products',
                  name: 'digital-products',
                  builder: (context, state) => const DigitalProductsScreen(),
                ),
                GoRoute(
                  path: 'shipping-integration',
                  name: 'shipping-integration',
                  builder: (context, state) => const ShippingScreen(),
                ),
                GoRoute(
                  path: 'delivery-options',
                  name: 'delivery-options',
                  builder: (context, state) => const DeliveryOptionsScreen(),
                ),
                GoRoute(
                  path: 'payment-methods',
                  name: 'payment-methods',
                  builder: (context, state) => const PaymentMethodsScreen(),
                ),
                GoRoute(
                  path: 'cod-settings',
                  name: 'cod-settings',
                  builder: (context, state) => const CodSettingsScreen(),
                ),
                GoRoute(
                  path: 'webstore',
                  name: 'webstore',
                  builder: (context, state) => const WebstoreScreen(),
                ),
                GoRoute(
                  path: 'whatsapp-integration',
                  name: 'whatsapp-integration',
                  builder: (context, state) => const WhatsappScreen(),
                ),
                GoRoute(
                  path: 'qrcode-generator',
                  name: 'qrcode-generator',
                  builder: (context, state) => const QrCodeScreen(),
                ),
                // ====== نهاية الميزات الجديدة ======
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
                    return ComingSoonScreen(title: decodedName);
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
              SvgPicture.asset(
                AppIcons.error,
                width: 64,
                height: 64,
                colorFilter: const ColorFilter.mode(
                  Colors.red,
                  BlendMode.srcIn,
                ),
              ),
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
