import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// خدمة Firebase المركزية
/// تدير Analytics و FCM (Push Notifications)
class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static FirebaseMessaging? _messaging;

  /// تهيئة Firebase Analytics
  static void initAnalytics() {
    _analytics = FirebaseAnalytics.instance;
    debugPrint('✅ تم تهيئة Firebase Analytics');
  }

  /// إعداد FCM (Firebase Cloud Messaging)
  static Future<void> setupFCM() async {
    _messaging = FirebaseMessaging.instance;

    // طلب الأذونات للإشعارات
    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ تم منح أذونات الإشعارات');
      
      // الحصول على FCM Token
      String? token = await _messaging!.getToken();
      if (token != null) {
        debugPrint('📱 FCM Token: $token');
        // TODO: حفظ Token في قاعدة البيانات لإرسال إشعارات مستقبلية
      }

      // الاستماع للرسائل عندما يكون التطبيق في المقدمة
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('📬 تم استلام رسالة: ${message.notification?.title}');
        // TODO: عرض إشعار محلي
      });

      // معالجة النقر على الإشعار عندما يكون التطبيق في الخلفية
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🔔 تم فتح التطبيق من إشعار: ${message.data}');
        // TODO: التوجيه إلى الشاشة المناسبة
      });
    } else {
      debugPrint('⚠️ لم يتم منح أذونات الإشعارات');
    }
  }

  // ==================== Analytics Events ====================

  /// تتبع عرض شاشة
  static Future<void> logScreenView(String screenName) async {
    await _analytics?.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
    debugPrint('📊 Analytics: عرض شاشة $screenName');
  }

  /// تتبع تسجيل الدخول
  static Future<void> logLogin(String method) async {
    await _analytics?.logLogin(loginMethod: method);
    debugPrint('📊 Analytics: تسجيل دخول بـ $method');
  }

  /// تتبع التسجيل
  static Future<void> logSignUp(String method) async {
    await _analytics?.logSignUp(signUpMethod: method);
    debugPrint('📊 Analytics: تسجيل جديد بـ $method');
  }

  /// تتبع إضافة منتج إلى السلة
  static Future<void> logAddToCart({
    required String productId,
    String? productName,
    double? price,
    int quantity = 1,
  }) async {
    await _analytics?.logAddToCart(
      currency: 'SAR',
      value: price ?? 0,
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName ?? 'Unknown',
          quantity: quantity,
          price: price ?? 0,
        ),
      ],
    );
    debugPrint('📊 Analytics: إضافة إلى السلة $productName');
  }

  /// تتبع حذف منتج من السلة
  static Future<void> logRemoveFromCart({
    required String productId,
    String? productName,
  }) async {
    await _analytics?.logEvent(
      name: 'remove_from_cart',
      parameters: {
        'product_id': productId,
        'product_name': productName ?? 'Unknown',
      },
    );
    debugPrint('📊 Analytics: حذف من السلة $productName');
  }

  /// تتبع إتمام طلب
  static Future<void> logPlaceOrder({
    required String orderId,
    required double totalAmount,
    String? couponCode,
  }) async {
    await _analytics?.logPurchase(
      currency: 'SAR',
      value: totalAmount,
      transactionId: orderId,
      coupon: couponCode,
    );
    debugPrint('📊 Analytics: إتمام طلب $orderId بمبلغ $totalAmount SAR');
  }

  /// تتبع عرض متجر
  static Future<void> logViewStore({
    required String storeId,
    String? storeName,
  }) async {
    await _analytics?.logEvent(
      name: 'view_store',
      parameters: {
        'store_id': storeId,
        'store_name': storeName ?? 'Unknown',
      },
    );
    debugPrint('📊 Analytics: عرض متجر $storeName');
  }

  /// تتبع بحث
  static Future<void> logSearch(String searchTerm) async {
    await _analytics?.logSearch(searchTerm: searchTerm);
    debugPrint('📊 Analytics: بحث عن "$searchTerm"');
  }

  /// تتبع حدث مخصص
  static Future<void> logCustomEvent(
    String eventName,
    Map<String, Object>? parameters,
  ) async {
    await _analytics?.logEvent(
      name: eventName,
      parameters: parameters,
    );
    debugPrint('📊 Analytics: حدث مخصص $eventName');
  }
}
