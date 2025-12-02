import 'package:flutter/material.dart';

/// نظام التوجيه المركزي للتطبيق
/// يوفر مسارات موحدة لجميع صفحات التطبيق
class AppRouter {
  // Customer Screens
  static const String home = '/';
  static const String explore = '/explore';
  static const String stores = '/stores';
  static const String categories = '/categories';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String favorites = '/favorites';
  static const String browseHistory = '/browse-history';
  static const String coupons = '/coupons';
  static const String orders = '/orders';
  static const String wallet = '/wallet';
  static const String points = '/points';
  static const String productDetails = '/product-details';
  static const String storeDetails = '/store-details';
  static const String allProducts = '/all-products';
  static const String allStores = '/all-stores';
  static const String changePassword = '/change-password';
  static const String privacySecurity = '/privacy-security';
  static const String terms = '/terms';
  static const String helpSupport = '/help-support';

  // Merchant Screens
  static const String merchantDashboard = '/merchant/dashboard';
  static const String merchantProducts = '/merchant/products';
  static const String merchantOrders = '/merchant/orders';
  static const String merchantWallet = '/merchant/wallet';
  static const String merchantPoints = '/merchant/points';
  static const String merchantStoreSetup = '/merchant/store-setup';
  static const String merchantMessages = '/merchant/messages';
  static const String merchantPromotions = '/merchant/promotions';
  static const String merchantStories = '/merchant/stories';
  static const String merchantCatalog = '/merchant/catalog';
  static const String merchantReviews = '/merchant/reviews';
  static const String merchantAnalytics = '/merchant/analytics';
  static const String merchantFollowers = '/merchant/followers';
  static const String merchantCommunity = '/merchant/community';
  static const String merchantProfile = '/merchant/profile';
  static const String merchantHelpCenter = '/merchant/help-center';
  static const String merchantTechnicalSupport = '/merchant/technical-support';
  static const String merchantPolicies = '/merchant/policies';
  static const String merchantInvoices = '/merchant/invoices';
  static const String merchantPaymentMethods = '/merchant/payment-methods';
  static const String merchantTransactions = '/merchant/transactions';

  /// Helper method to navigate to a route
  static void navigateTo(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  /// Helper method to navigate and replace current route
  static void navigateToReplacement(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  /// Helper method to navigate and remove all previous routes
  static void navigateToAndRemoveUntil(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Helper method to go back
  static void goBack(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }
}
