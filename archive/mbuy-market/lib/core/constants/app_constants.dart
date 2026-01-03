/// MBUY Market App Constants
class AppConstants {
  // App Info
  static const String appName = 'MBUY';
  static const String appNameAr = 'MBUY';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.mbuy.com';
  static const int apiTimeout = 30000; // 30 seconds

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Cache
  static const int cacheMaxAge = 3600; // 1 hour in seconds

  // Animation Durations
  static const int animationDurationFast = 200;
  static const int animationDurationNormal = 300;
  static const int animationDurationSlow = 500;

  // Image Placeholders
  static const String productPlaceholder = 'assets/images/product_placeholder.png';
  static const String storePlaceholder = 'assets/images/store_placeholder.png';
  static const String avatarPlaceholder = 'assets/images/avatar_placeholder.png';

  // SharedPreferences Keys
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserType = 'user_type';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyRecentSearches = 'recent_searches';
  static const String keyCartItems = 'cart_items';
}

/// Route Names
class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String home = '/home';
  static const String media = '/media';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String account = '/account';
  static const String product = '/product';
  static const String store = '/store';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String notifications = '/notifications';
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String addresses = '/addresses';
  static const String settings = '/settings';
}

/// Media Tab Types
class MediaTabs {
  static const String forYou = 'for_you';
  static const String latest = 'latest';
  static const String videos = 'videos';
  static const String posts = 'posts';
  static const String live = 'live';
  static const String history = 'history';
  static const String following = 'following';
}

/// Store Tab Types
class StoreTabs {
  static const String home = 'home';
  static const String products = 'products';
  static const String offers = 'offers';
  static const String reviews = 'reviews';
}
