/// MBUY Application Configuration
/// Contains all app-wide constants and environment-specific settings
class AppConfig {
  // ============================================================================
  // API Configuration
  // ============================================================================

  /// Cloudflare Worker Base URL
  static const String apiBaseUrl =
      'https://misty-mode-b68b.baharista1.workers.dev';

  // ============================================================================
  // App Metadata
  // ============================================================================

  static const String appName = 'MBUY Merchant';
  static const String appVersion = '2.0.0';

  // ============================================================================
  // Storage Keys
  // ============================================================================

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userTypeKey = 'user_type';
  static const String merchantIdKey = 'merchant_id';

  // ============================================================================
  // Auth API Endpoints (NEW - Custom JWT from Worker)
  // ============================================================================

  /// Login - POST /auth/login
  /// Request: { "email": "...", "password": "..." }
  /// Response: { "success": true, "access_token": "...", "user": {...} }
  static const String loginEndpoint = '/auth/login';

  /// Register - POST /auth/register
  /// Request: { "email": "...", "password": "...", "user_type": "merchant|customer" }
  static const String registerEndpoint = '/auth/register';

  /// Refresh Token - POST /auth/refresh
  static const String refreshEndpoint = '/auth/refresh';

  /// Logout - POST /auth/logout
  static const String logoutEndpoint = '/auth/logout';

  /// Get Current User - GET /auth/me
  static const String meEndpoint = '/auth/me';

  /// Forgot Password - POST /auth/forgot-password
  static const String forgotPasswordEndpoint = '/auth/forgot-password';

  // ============================================================================
  // Merchant API Endpoints (Protected - requires JWT)
  // ============================================================================

  /// Products CRUD - /api/merchant/products
  static const String merchantProductsEndpoint = '/api/merchant/products';

  /// Orders - /api/merchant/orders
  static const String merchantOrdersEndpoint = '/api/merchant/orders';

  /// Categories - /api/merchant/categories
  static const String merchantCategoriesEndpoint = '/api/merchant/categories';

  /// Inventory - /api/merchant/inventory
  static const String merchantInventoryEndpoint = '/api/merchant/inventory';

  // ============================================================================
  // Public API Endpoints (No auth required)
  // ============================================================================

  /// Public Products - /api/public/products
  static const String publicProductsEndpoint = '/api/public/products';

  /// Public Categories - /api/public/categories
  static const String publicCategoriesEndpoint = '/api/public/categories';

  // ============================================================================
  // Customer API Endpoints
  // ============================================================================

  /// Customer Orders - /api/customer/orders
  static const String customerOrdersEndpoint = '/api/customer/orders';
}
