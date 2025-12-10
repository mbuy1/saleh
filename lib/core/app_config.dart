/// MBUY Application Configuration
/// Contains all app-wide constants and environment-specific settings
class AppConfig {
  // ============================================================================
  // API Configuration
  // ============================================================================

  /// Cloudflare Worker Base URL
  /// TODO: Update this to your actual Cloudflare Worker URL
  static const String apiBaseUrl =
      'https://misty-mode-b68b.baharista1.workers.dev';

  // ============================================================================
  // App Metadata
  // ============================================================================

  static const String appName = 'MBUY Merchant';
  static const String appVersion = '1.0.0';

  // ============================================================================
  // Storage Keys
  // ============================================================================

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';

  // ============================================================================
  // API Endpoints
  // ============================================================================

  // Auth
  static const String loginEndpoint = '/auth/login';
  static const String refreshEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';

  // Merchant
  static const String merchantStoreEndpoint = '/secure/merchant/store';
  static const String merchantProductsEndpoint = '/secure/merchant/products';
  static const String merchantOrdersEndpoint = '/secure/merchant/orders';

  // Public
  static const String categoriesEndpoint = '/public/categories';
  static const String productsEndpoint = '/public/products';
}
