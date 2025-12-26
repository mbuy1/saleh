import 'package:go_router/go_router.dart';
// Dashboard
import '../../../features/dashboard/presentation/screens/dashboard_shell.dart';
import '../../../features/dashboard/presentation/screens/home_tab.dart';
import '../../../features/dashboard/presentation/screens/orders_tab.dart';
import '../../../features/dashboard/presentation/screens/products_tab.dart';
import '../../../features/dashboard/presentation/screens/merchant_services_screen.dart';
import '../../../features/dashboard/presentation/screens/mbuy_tools_screen.dart';
import '../../../features/dashboard/presentation/screens/audit_logs_screen.dart';
import '../../../features/dashboard/presentation/screens/inbox_screen.dart';
import '../../../features/dashboard/presentation/screens/customers_screen.dart';
import '../../../features/dashboard/presentation/screens/reports_screen.dart';
import '../../../features/dashboard/presentation/screens/all_menu_panel.dart';
import '../../../features/dashboard/presentation/screens/search_panel.dart';
import '../../../features/dashboard/presentation/screens/ai_assistant_panel.dart';
import '../../../features/dashboard/presentation/screens/notifications_panel.dart';
import '../../../features/dashboard/presentation/screens/shortcuts_panel.dart';
import '../../../features/dashboard/presentation/screens/add_product_panel.dart';
// Finance
import '../../../features/finance/presentation/screens/wallet_screen.dart';
import '../../../features/finance/presentation/screens/points_screen.dart';
import '../../../features/finance/presentation/screens/sales_screen.dart';
// Projects
import '../../../features/projects/presentation/screens/projects_screen.dart';
import '../../../features/projects/presentation/screens/project_builder_screen.dart';
import '../../../features/projects/presentation/screens/project_view_screen.dart';
// Store
import '../../../features/store/presentation/screens/app_store_screen.dart';
import '../../../features/store/presentation/screens/inventory_screen.dart';
import '../../../features/store/presentation/screens/view_my_store_screen.dart';
// Webstore & Settings
import '../../../apps/merchant/features/webstore/webstore_screen.dart';
import '../../../apps/merchant/features/shipping/shipping_screen.dart';
import '../../../apps/merchant/features/payments/payment_methods_screen.dart';
// Marketing
import '../../../features/marketing/presentation/screens/marketing_screen.dart';
import '../../../features/marketing/presentation/screens/coupons_screen.dart';
import '../../../features/marketing/presentation/screens/flash_sales_screen.dart';
import '../../../features/marketing/presentation/screens/boost_sales_screen.dart';
// Products
import '../../../features/products/presentation/screens/add_product_screen.dart';
import '../../../features/products/presentation/screens/product_details_screen.dart';
// Merchant
import '../../../features/merchant/presentation/screens/create_store_screen.dart';
import '../../../features/merchant/presentation/screens/abandoned_cart_screen.dart';
import '../../../features/merchant/presentation/screens/referral_screen.dart';
import '../../../features/merchant/presentation/screens/loyalty_program_screen.dart';
import '../../../features/merchant/presentation/screens/customer_segments_screen.dart';
import '../../../features/merchant/presentation/screens/custom_messages_screen.dart';
import '../../../features/merchant/presentation/screens/smart_pricing_screen.dart';
import '../../../features/merchant/presentation/screens/content_generator_screen.dart';
import '../../../features/merchant/presentation/screens/smart_analytics_screen.dart';
import '../../../features/merchant/presentation/screens/auto_reports_screen.dart';
import '../../../features/merchant/presentation/screens/heatmap_screen.dart';
// Settings
import '../../../features/settings/presentation/screens/about_screen.dart';
// Studio
import '../../../features/studio/studio.dart';
// Shared
import '../../../shared/widgets/base_screen.dart';

/// Dashboard Shell Route - البار السفلي ثابت
/// يحتوي على جميع الصفحات الفرعية للتاجر
ShellRoute dashboardShellRoute = ShellRoute(
  builder: (context, state, child) => DashboardShell(child: child),
  routes: [
    // الصفحة الرئيسية
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const HomeTab(),
      routes: _homeSubRoutes,
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
      routes: _productsSubRoutes,
    ),
    // تبويب المتجر
    GoRoute(
      path: '/dashboard/store',
      name: 'store',
      builder: (context, state) => const AppStoreScreen(),
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
);

/// الصفحات الفرعية من الرئيسية
List<GoRoute> _homeSubRoutes = [
  // Studio
  GoRoute(
    path: 'studio',
    name: 'mbuy-studio',
    builder: (context, state) => const StudioMainPage(),
    routes: [
      GoRoute(
        path: 'script-generator',
        name: 'studio-script',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final template = extra?['template'] as StudioTemplate?;
          return ScriptGeneratorScreen(template: template);
        },
      ),
      GoRoute(
        path: 'editor',
        name: 'studio-editor',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final projectId = extra?['projectId'] as String? ?? '';
          final script = extra?['script'] as ScriptData?;
          return SceneEditorScreen(
            projectId: projectId,
            initialScript: script,
          );
        },
      ),
      GoRoute(
        path: 'canvas',
        name: 'studio-canvas',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final scene = extra?['scene'] as Scene;
          return CanvasEditorScreen(scene: scene);
        },
      ),
      GoRoute(
        path: 'export',
        name: 'studio-export',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final projectId = extra?['projectId'] as String? ?? '';
          return ExportScreen(projectId: projectId);
        },
      ),
    ],
  ),
  // Tools & Management
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
  // Webstore & Settings
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
  // Feature placeholder
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
  // Panels
  GoRoute(
    path: 'all-menu',
    name: 'all-menu',
    builder: (context, state) => const AllMenuPanel(),
  ),
  GoRoute(
    path: 'search',
    name: 'search',
    builder: (context, state) => const SearchPanel(),
  ),
  GoRoute(
    path: 'ai-assistant',
    name: 'ai-assistant',
    builder: (context, state) => const AIAssistantPanel(),
  ),
  GoRoute(
    path: 'notifications',
    name: 'notifications',
    builder: (context, state) => const NotificationsPanel(),
  ),
  GoRoute(
    path: 'shortcuts',
    name: 'shortcuts',
    builder: (context, state) => const ShortcutsPanel(),
  ),
  GoRoute(
    path: 'add-product',
    name: 'add-product-panel',
    builder: (context, state) => const AddProductPanel(),
  ),
  // Other screens
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
    path: 'inbox',
    name: 'inbox',
    builder: (context, state) => const InboxScreen(),
  ),
  // Projects
  GoRoute(
    path: 'projects',
    name: 'projects',
    builder: (context, state) => const ProjectsScreen(),
    routes: [
      GoRoute(
        path: 'new/:type',
        name: 'new-project',
        builder: (context, state) {
          final typeStr = state.pathParameters['type']!;
          return ProjectBuilderScreen(projectTypeName: typeStr);
        },
      ),
      GoRoute(
        path: 'view/:id',
        name: 'project-view',
        builder: (context, state) {
          final projectId = state.pathParameters['id']!;
          return ProjectViewScreen(projectId: projectId);
        },
      ),
    ],
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
  // Finance
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
  // Marketing features
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
  // AI Tools
  GoRoute(
    path: 'content-generator',
    name: 'content-generator',
    builder: (context, state) => const ContentGeneratorScreen(),
  ),
  // Analytics
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
];

/// Products sub-routes
List<GoRoute> _productsSubRoutes = [
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
];
