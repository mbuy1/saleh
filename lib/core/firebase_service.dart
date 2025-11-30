import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'supabase_client.dart';

/// خدمة Firebase - التحليلات والإشعارات
class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static FirebaseMessaging? _messaging;

  /// تهيئة Firebase Analytics
  static FirebaseAnalytics get analytics {
    _analytics ??= FirebaseAnalytics.instance;
    return _analytics!;
  }

  /// تهيئة Firebase Cloud Messaging
  static FirebaseMessaging get messaging {
    _messaging ??= FirebaseMessaging.instance;
    return _messaging!;
  }

  /// تتبع عرض شاشة
  static Future<void> logScreenView(String screenName) async {
    try {
      await analytics.logScreenView(screenName: screenName);
    } catch (e) {
      // تجاهل الأخطاء في التحليلات
    }
  }

  /// تتبع حدث
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await analytics.logEvent(
        name: name,
        parameters: parameters != null
            ? Map<String, Object>.from(parameters)
            : null,
      );
    } catch (e) {
      // تجاهل الأخطاء في التحليلات
    }
  }

  /// تتبع عرض منتج
  static Future<void> logViewProduct({
    required String productId,
    String? productName,
    String? category,
    double? price,
  }) async {
    await logEvent(
      name: 'view_product',
      parameters: {
        'product_id': productId,
        if (productName != null) 'product_name': productName,
        if (category != null) 'category': category,
        if (price != null) 'price': price,
      },
    );
  }

  /// تتبع إضافة منتج إلى السلة
  static Future<void> logAddToCart({
    required String productId,
    String? productName,
    double? price,
    int? quantity,
  }) async {
    await logEvent(
      name: 'add_to_cart',
      parameters: {
        'product_id': productId,
        if (productName != null) 'product_name': productName,
        if (price != null) 'price': price,
        if (quantity != null) 'quantity': quantity,
      },
    );
  }

  /// تتبع حذف منتج من السلة
  static Future<void> logRemoveFromCart({
    required String productId,
    String? productName,
  }) async {
    await logEvent(
      name: 'remove_from_cart',
      parameters: {
        'product_id': productId,
        if (productName != null) 'product_name': productName,
      },
    );
  }

  /// تتبع عرض متجر
  static Future<void> logViewStore({
    required String storeId,
    String? storeName,
  }) async {
    await logEvent(
      name: 'view_store',
      parameters: {
        'store_id': storeId,
        if (storeName != null) 'store_name': storeName,
      },
    );
  }

  /// تتبع إتمام طلب
  static Future<void> logPlaceOrder({
    required String orderId,
    double? totalAmount,
    String? couponCode,
  }) async {
    await logEvent(
      name: 'place_order',
      parameters: {
        'order_id': orderId,
        if (totalAmount != null) 'total_amount': totalAmount,
        if (couponCode != null) 'coupon_code': couponCode,
      },
    );
  }

  /// تتبع البحث
  static Future<void> logSearch({
    required String searchTerm,
    String? category,
  }) async {
    await logEvent(
      name: 'search',
      parameters: {
        'search_term': searchTerm,
        if (category != null) 'category': category,
      },
    );
  }

  /// تتبع استخدام فلتر
  static Future<void> logFilter({
    required String filterType,
    String? filterValue,
  }) async {
    await logEvent(
      name: 'filter',
      parameters: {
        'filter_type': filterType,
        if (filterValue != null) 'filter_value': filterValue,
      },
    );
  }

  /// إعداد FCM وحفظ device token
  static Future<void> setupFCM() async {
    try {
      // طلب صلاحيات الإشعارات
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // جلب device token
        String? token = await messaging.getToken();
        
        if (token != null) {
          await _saveDeviceToken(token);
        }

        // الاستماع لتحديثات token
        messaging.onTokenRefresh.listen((newToken) {
          _saveDeviceToken(newToken);
        });

        // معالجة الإشعارات في المقدمة (Foreground)
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // معالجة الإشعارات عند الضغط عليها
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
      }
    } catch (e) {
      // تجاهل الأخطاء في FCM
    }
  }

  /// حفظ device token في Supabase
  static Future<void> _saveDeviceToken(String token) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return;

      // TODO: حفظ token في جدول device_tokens في Supabase
      // await supabaseClient.from('device_tokens').upsert({
      //   'user_id': user.id,
      //   'token': token,
      //   'platform': Platform.isAndroid ? 'android' : 'ios',
      //   'updated_at': DateTime.now().toIso8601String(),
      // });
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// معالجة الإشعارات في المقدمة
  static void _handleForegroundMessage(RemoteMessage message) {
    // TODO: عرض إشعار محلي عند استلام إشعار في المقدمة
    // يمكن استخدام flutter_local_notifications
  }

  /// معالجة الإشعارات عند الضغط عليها
  static void _handleMessageOpened(RemoteMessage message) {
    // TODO: التنقل إلى الشاشة المناسبة حسب data في الإشعار
    // يمكن استخدام Navigator أو Router
  }
}

