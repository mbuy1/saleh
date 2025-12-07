import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/session/store_session.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/cloudflare_images_service.dart';
import 'core/services/preferences_service.dart';
import 'core/firebase_service.dart';
import 'core/root_widget.dart' as app;
import 'core/app_router.dart';
import 'core/app_config.dart';
import 'features/common/splash_screen.dart';

// Customer Screens
import 'features/customer/presentation/screens/explore_screen.dart';
import 'features/customer/presentation/screens/stores_screen.dart';
import 'features/customer/presentation/screens/categories_screen.dart';
import 'features/customer/presentation/screens/profile_screen.dart';
import 'features/customer/presentation/screens/settings_screen.dart';
import 'features/customer/presentation/screens/favorites_screen.dart';
import 'features/customer/presentation/screens/wishlist_screen.dart';
import 'features/customer/presentation/screens/recently_viewed_screen.dart';
import 'features/customer/presentation/screens/browse_history_screen.dart';
import 'features/customer/presentation/screens/coupons_screen.dart';
import 'features/customer/presentation/screens/customer_wallet_screen.dart';
import 'features/customer/presentation/screens/customer_points_screen.dart';
import 'features/customer/presentation/screens/product_details_screen.dart';
import 'features/customer/presentation/screens/store_details_screen.dart';
import 'features/customer/presentation/screens/all_products_screen.dart';
import 'features/customer/presentation/screens/all_stores_screen.dart';
import 'features/customer/presentation/screens/change_password_screen.dart';
import 'features/customer/presentation/screens/privacy_security_screen.dart';
import 'features/customer/presentation/screens/terms_screen.dart';
import 'features/customer/presentation/screens/help_support_screen.dart';
import 'features/customer/presentation/screens/cart_screen.dart';
import 'features/customer/presentation/screens/customer_orders_screen.dart';
import 'features/customer/presentation/screens/customer_order_details_screen.dart';
import 'features/customer/presentation/screens/category_products_screen.dart';
import 'features/customer/presentation/screens/map_screen.dart';
import 'features/customer/presentation/screens/packages_screen.dart';

// Merchant Screens
import 'features/merchant/presentation/screens/merchant_dashboard_screen.dart';
import 'features/merchant/presentation/screens/merchant_products_screen.dart';
import 'features/merchant/presentation/screens/merchant_orders_screen.dart';
import 'features/merchant/presentation/screens/merchant_wallet_screen.dart';
import 'features/merchant/presentation/screens/merchant_points_screen.dart';
import 'features/merchant/presentation/screens/merchant_store_setup_screen.dart';
import 'features/merchant/presentation/screens/merchant_messages_screen.dart';
import 'features/merchant/presentation/screens/merchant_promotions_screen.dart';
import 'features/merchant/presentation/screens/merchant_stories_screen.dart';
import 'features/merchant/presentation/screens/merchant_catalog_screen.dart';
import 'features/merchant/presentation/screens/merchant_reviews_screen.dart';
import 'features/merchant/presentation/screens/merchant_analytics_screen.dart';
import 'features/merchant/presentation/screens/merchant_followers_screen.dart';
import 'features/merchant/presentation/screens/merchant_community_screen.dart';
import 'features/merchant/presentation/screens/merchant_profile_screen.dart';
import 'features/merchant/presentation/screens/merchant_help_center_screen.dart';
import 'features/merchant/presentation/screens/merchant_technical_support_screen.dart';
import 'features/merchant/presentation/screens/merchant_policies_screen.dart';
import 'features/merchant/presentation/screens/merchant_invoices_screen.dart';
import 'features/merchant/presentation/screens/merchant_payment_methods_screen.dart';
import 'features/merchant/presentation/screens/merchant_transactions_screen.dart';
import 'features/merchant/presentation/screens/merchant_order_details_screen.dart';
import 'features/merchant/presentation/screens/product_variants_screen.dart';
import 'features/merchant/presentation/screens/bulk_operations_screen.dart';
import 'features/merchant/presentation/screens/ai_tools_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تحميل متغيرات البيئة من ملف .env
  await dotenv.load(fileName: ".env");

  // تهيئة PreferencesService
  try {
    await PreferencesService.initialize();
    debugPrint('✅ تم تهيئة PreferencesService بنجاح');
  } catch (e) {
    debugPrint('⚠️ خطأ في تهيئة PreferencesService: $e');
  }

  // تهيئة Firebase
  try {
    await Firebase.initializeApp();
    FirebaseService.initAnalytics();
    await FirebaseService.initLocalNotifications();
    await FirebaseService.setupFCM();
    debugPrint('✅ تم تهيئة Firebase بنجاح');
  } catch (e) {
    debugPrint('⚠️ خطأ في تهيئة Firebase: $e');
  }

  // تهيئة Supabase (للوصول إلى Database فقط - لا Auth)
  // Note: Supabase Auth is disabled, we use MBUY Custom Auth only
  try {
    await initSupabase();
    debugPrint('✅ تم تهيئة Supabase (Database only - Auth disabled)');
  } catch (e) {
    // إذا فشل تهيئة Supabase، نتابع بدونها (للتطوير فقط)
    // في الإنتاج يجب إيقاف التطبيق إذا فشل Supabase
    debugPrint('⚠️ خطأ في تهيئة Supabase: $e');
  }

  // تهيئة Cloudflare Images عبر Worker API
  try {
    await CloudflareImagesService.initialize();
    debugPrint('✅ تم تهيئة Cloudflare Images عبر Worker بنجاح');
  } catch (e) {
    debugPrint('⚠️ خطأ في تهيئة Cloudflare Images: $e');
  }

  // تهيئة Theme Provider
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode();

  // تهيئة App Mode Provider
  final appModeProvider = AppModeProvider();

  runApp(MyApp(themeProvider: themeProvider, appModeProvider: appModeProvider));
}

/// توليد المسارات ديناميكياً
Route<dynamic>? _generateRoute(
  RouteSettings settings,
  ThemeProvider themeProvider,
  AppModeProvider appModeProvider,
) {
  switch (settings.name) {
    // Splash & Home
    case '/splash':
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case '/':
      return MaterialPageRoute(
        builder: (_) => app.RootWidget(themeProvider: themeProvider),
      );

    // Customer Routes
    case AppRouter.explore:
      return MaterialPageRoute(builder: (_) => const ExploreScreen());
    case AppRouter.stores:
      return MaterialPageRoute(builder: (_) => const StoresScreen());
    case AppRouter.categories:
      return MaterialPageRoute(builder: (_) => const CategoriesScreen());
    case AppRouter.profile:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    case AppRouter.settings:
      return MaterialPageRoute(
        builder: (_) => SettingsScreen(themeProvider: themeProvider),
      );
    case AppRouter.favorites:
      return MaterialPageRoute(builder: (_) => const FavoritesScreen());
    case AppRouter.wishlist:
      return MaterialPageRoute(builder: (_) => const WishlistScreen());
    case AppRouter.recentlyViewed:
      return MaterialPageRoute(builder: (_) => const RecentlyViewedScreen());
    case AppRouter.browseHistory:
      return MaterialPageRoute(builder: (_) => const BrowseHistoryScreen());
    case AppRouter.coupons:
      return MaterialPageRoute(builder: (_) => const CouponsScreen());
    case AppRouter.orders:
      return MaterialPageRoute(builder: (_) => const CustomerOrdersScreen());
    case AppRouter.wallet:
      return MaterialPageRoute(builder: (_) => const CustomerWalletScreen());
    case AppRouter.points:
      return MaterialPageRoute(builder: (_) => const CustomerPointsScreen());
    case AppRouter.allProducts:
      return MaterialPageRoute(builder: (_) => const AllProductsScreen());
    case AppRouter.allStores:
      return MaterialPageRoute(builder: (_) => const AllStoresScreen());
    case AppRouter.changePassword:
      return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
    case AppRouter.privacySecurity:
      return MaterialPageRoute(builder: (_) => const PrivacySecurityScreen());
    case AppRouter.terms:
      return MaterialPageRoute(builder: (_) => const TermsScreen());
    case AppRouter.helpSupport:
      return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
    case '/cart':
      return MaterialPageRoute(builder: (_) => const CartScreen());
    case '/map':
      return MaterialPageRoute(builder: (_) => const MapScreen());
    case AppRouter.packages:
      return MaterialPageRoute(builder: (_) => const PackagesScreen());

    // Customer Routes with Arguments
    case AppRouter.productDetails:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) =>
            ProductDetailsScreen(productId: args?['productId'] ?? ''),
      );
    case AppRouter.storeDetails:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => StoreDetailsScreen(
          storeId: args?['storeId'] ?? '',
          storeName: args?['storeName'] ?? '',
        ),
      );
    case '/category-products':
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => CategoryProductsScreen(
          categoryId: args?['categoryId'] ?? '',
          categoryName: args?['categoryName'] ?? '',
        ),
      );
    case '/customer-order-details':
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) =>
            CustomerOrderDetailsScreen(orderId: args?['orderId'] ?? ''),
      );

    // Merchant Routes
    case AppRouter.merchantDashboard:
      return MaterialPageRoute(
        builder: (_) =>
            MerchantDashboardScreen(appModeProvider: appModeProvider),
      );
    case AppRouter.merchantProducts:
      return MaterialPageRoute(builder: (_) => const MerchantProductsScreen());
    case AppRouter.merchantOrders:
      return MaterialPageRoute(builder: (_) => const MerchantOrdersScreen());
    case AppRouter.merchantWallet:
      return MaterialPageRoute(builder: (_) => const MerchantWalletScreen());
    case AppRouter.merchantPoints:
      return MaterialPageRoute(builder: (_) => const MerchantPointsScreen());
    case AppRouter.merchantStoreSetup:
      return MaterialPageRoute(
        builder: (_) => const MerchantStoreSetupScreen(),
      );
    case AppRouter.merchantMessages:
      return MaterialPageRoute(builder: (_) => const MerchantMessagesScreen());
    case AppRouter.merchantPromotions:
      return MaterialPageRoute(
        builder: (_) => const MerchantPromotionsScreen(),
      );
    case AppRouter.merchantStories:
      return MaterialPageRoute(builder: (_) => const MerchantStoriesScreen());
    case AppRouter.merchantCatalog:
      return MaterialPageRoute(builder: (_) => const MerchantCatalogScreen());
    case AppRouter.merchantReviews:
      return MaterialPageRoute(builder: (_) => const MerchantReviewsScreen());
    case AppRouter.merchantAnalytics:
      return MaterialPageRoute(builder: (_) => const MerchantAnalyticsScreen());
    case AppRouter.merchantFollowers:
      return MaterialPageRoute(builder: (_) => const MerchantFollowersScreen());
    case AppRouter.merchantCommunity:
      return MaterialPageRoute(builder: (_) => const MerchantCommunityScreen());
    case AppRouter.merchantProfile:
      return MaterialPageRoute(builder: (_) => const MerchantProfileScreen());
    case AppRouter.merchantHelpCenter:
      return MaterialPageRoute(
        builder: (_) => const MerchantHelpCenterScreen(),
      );
    case AppRouter.merchantTechnicalSupport:
      return MaterialPageRoute(
        builder: (_) => const MerchantTechnicalSupportScreen(),
      );
    case AppRouter.merchantPolicies:
      return MaterialPageRoute(builder: (_) => const MerchantPoliciesScreen());
    case AppRouter.merchantInvoices:
      return MaterialPageRoute(builder: (_) => const MerchantInvoicesScreen());
    case AppRouter.merchantPaymentMethods:
      return MaterialPageRoute(
        builder: (_) => const MerchantPaymentMethodsScreen(),
      );
    case AppRouter.merchantAITools:
      return MaterialPageRoute(
        builder: (_) => const AIToolsScreen(),
      );
    case AppRouter.merchantTransactions:
      return MaterialPageRoute(
        builder: (_) => const MerchantTransactionsScreen(),
      );
    case AppRouter.merchantProductVariants:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => ProductVariantsScreen(
          productId: args?['productId'] ?? '',
          productName: args?['productName'],
        ),
      );
    case AppRouter.merchantBulkOperations:
      return MaterialPageRoute(
        builder: (_) => const BulkOperationsScreen(),
      );

    // Merchant Routes with Arguments
    case '/merchant-order-details':
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => MerchantOrderDetailsScreen(
          orderId: args?['orderId'] ?? '',
          storeId: args?['storeId'] ?? '',
        ),
      );

    default:
      return null;
  }
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AppModeProvider appModeProvider;

  const MyApp({
    super.key,
    required this.themeProvider,
    required this.appModeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StoreSession>(create: (_) => StoreSession()),
      ],
      child: ListenableBuilder(
        listenable: themeProvider,
        builder: (context, _) {
          return MaterialApp(
            title: 'Mbuy',
            debugShowCheckedModeBanner: false,

            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // تفعيل RTL للعربية
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'SA'), // العربية
              Locale('en', 'US'), // الإنجليزية
            ],
            locale: const Locale('ar', 'SA'),

            // إعداد المسارات (Routes)
            onGenerateRoute: (settings) =>
                _generateRoute(settings, themeProvider, appModeProvider),
            initialRoute: '/splash', // بدء التطبيق بـ Splash Screen
            // استخدام RootWidget الذي يفحص حالة المستخدم ويعرض الشاشة المناسبة
            home: app.RootWidget(themeProvider: themeProvider),
          );
        },
      ),
    );
  }
}
