import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'supabase_client.dart';
import 'services/preferences_service.dart';
import 'services/api_service.dart';

/// خدمة Firebase المركزية
/// تدير Analytics و FCM (Push Notifications)
class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static FirebaseMessaging? _messaging;
  static FlutterLocalNotificationsPlugin? _localNotifications;

  /// تهيئة Firebase Analytics
  static void initAnalytics() {
    _analytics = FirebaseAnalytics.instance;
    debugPrint('✅ تم تهيئة Firebase Analytics');
  }

  /// تهيئة Local Notifications
  static Future<void> initLocalNotifications() async {
    _localNotifications = FlutterLocalNotificationsPlugin();

    // إعداد Android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // إعداد iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications!.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('🔔 تم النقر على إشعار: ${details.payload}');
        // TODO: التوجيه إلى الشاشة المناسبة بناءً على payload
      },
    );

    debugPrint('✅ تم تهيئة Local Notifications');
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
        await _saveFCMToken(token);
      }

      // الاستماع لتحديثات Token
      _messaging!.onTokenRefresh.listen((newToken) async {
        debugPrint('🔄 FCM Token تم تحديثه: $newToken');
        await _saveFCMToken(newToken);
      });

      // الاستماع للرسائل عندما يكون التطبيق في المقدمة
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        debugPrint('📬 تم استلام رسالة: ${message.notification?.title}');
        await _showLocalNotification(message);
      });

      // معالجة النقر على الإشعار عندما يكون التطبيق في الخلفية
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🔔 تم فتح التطبيق من إشعار: ${message.data}');
        _handleNotificationTap(message);
      });
    } else {
      debugPrint('⚠️ لم يتم منح أذونات الإشعارات');
    }
  }

  // ==================== Analytics Events ====================

  /// تتبع عرض شاشة
  static Future<void> logScreenView(
    String screenName, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics?.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
    if (parameters != null && parameters.isNotEmpty) {
      await _analytics?.logEvent(
        name: 'screen_view',
        parameters: {'screen_name': screenName, ...parameters},
      );
    }
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
      parameters: {'store_id': storeId, 'store_name': storeName ?? 'Unknown'},
    );
    debugPrint('📊 Analytics: عرض متجر $storeName');
  }

  /// تتبع بحث
  static Future<void> logSearch(String searchTerm) async {
    await _analytics?.logSearch(searchTerm: searchTerm);
    debugPrint('📊 Analytics: بحث عن "$searchTerm"');
  }

  /// تتبع عرض منتج
  static Future<void> logViewProduct({
    required String productId,
    String? productName,
    String? category,
    double? price,
    String? currency = 'SAR',
  }) async {
    await _analytics?.logViewItem(
      currency: currency,
      value: price ?? 0,
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName ?? 'Unknown',
          itemCategory: category,
          price: price ?? 0,
        ),
      ],
    );
    debugPrint('📊 Analytics: عرض منتج $productName');
  }

  /// تتبع إضافة للمفضلة
  static Future<void> logAddToWishlist({
    required String productId,
    String? productName,
    double? price,
  }) async {
    await _analytics?.logAddToWishlist(
      currency: 'SAR',
      value: price ?? 0,
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName ?? 'Unknown',
          price: price ?? 0,
        ),
      ],
    );
    debugPrint('📊 Analytics: إضافة للمفضلة $productName');
  }

  /// تتبع مشاركة
  static Future<void> logShare({
    required String contentType,
    String? itemId,
    String? method,
  }) async {
    await _analytics?.logShare(
      contentType: contentType,
      itemId: itemId ?? '',
      method: method ?? '',
    );
    debugPrint('📊 Analytics: مشاركة $contentType');
  }

  /// تتبع عرض كوبون
  static Future<void> logViewCoupon({
    required String couponCode,
    String? couponName,
  }) async {
    await _analytics?.logEvent(
      name: 'view_coupon',
      parameters: {
        'coupon_code': couponCode,
        if (couponName != null) 'coupon_name': couponName,
      },
    );
    debugPrint('📊 Analytics: عرض كوبون $couponCode');
  }

  /// تتبع استخدام كوبون
  static Future<void> logApplyCoupon({
    required String couponCode,
    double? discountAmount,
  }) async {
    await _analytics?.logEvent(
      name: 'apply_coupon',
      parameters: {
        'coupon_code': couponCode,
        if (discountAmount != null) 'discount_amount': discountAmount,
        'currency': 'SAR',
      },
    );
    debugPrint('📊 Analytics: استخدام كوبون $couponCode');
  }

  /// تتبع عرض المحفظة
  static Future<void> logViewWallet({double? balance}) async {
    await _analytics?.logEvent(
      name: 'view_wallet',
      parameters: {if (balance != null) 'balance': balance, 'currency': 'SAR'},
    );
    debugPrint('📊 Analytics: عرض المحفظة');
  }

  /// تتبع إضافة رصيد
  static Future<void> logAddFunds({
    required double amount,
    required String paymentMethod,
  }) async {
    await _analytics?.logEvent(
      name: 'add_funds',
      parameters: {
        'amount': amount,
        'payment_method': paymentMethod,
        'currency': 'SAR',
      },
    );
    debugPrint('📊 Analytics: إضافة رصيد $amount SAR');
  }

  /// تتبع عرض النقاط
  static Future<void> logViewPoints({int? balance}) async {
    await _analytics?.logEvent(
      name: 'view_points',
      parameters: {if (balance != null) 'points_balance': balance},
    );
    debugPrint('📊 Analytics: عرض النقاط');
  }

  /// تتبع استخدام النقاط
  static Future<void> logUsePoints({
    required int points,
    required String reason,
  }) async {
    await _analytics?.logEvent(
      name: 'use_points',
      parameters: {'points': points, 'reason': reason},
    );
    debugPrint('📊 Analytics: استخدام $points نقاط');
  }

  /// تتبع فتح التطبيق
  static Future<void> logAppOpen() async {
    await _analytics?.logAppOpen();
    debugPrint('📊 Analytics: فتح التطبيق');
  }

  /// تتبع حدث مخصص
  static Future<void> logCustomEvent(
    String eventName,
    Map<String, Object>? parameters,
  ) async {
    await _analytics?.logEvent(name: eventName, parameters: parameters);
    debugPrint('📊 Analytics: حدث مخصص $eventName');
  }

  /// تعيين User Properties
  static Future<void> setUserProperty(String name, String? value) async {
    if (value != null) {
      await _analytics?.setUserProperty(name: name, value: value);
      debugPrint('📊 Analytics: تعيين خاصية المستخدم $name = $value');
    }
  }

  /// تعيين User ID
  static Future<void> setUserId(String? userId) async {
    await _analytics?.setUserId(id: userId);
    debugPrint('📊 Analytics: تعيين User ID = $userId');
  }

  // ==================== FCM Token Management ====================

  /// حفظ FCM Token في قاعدة البيانات والتخزين المحلي
  static Future<void> _saveFCMToken(String token) async {
    try {
      // حفظ في SharedPreferences
      await PreferencesService.saveFCMToken(token);

      // حفظ في Supabase عبر Worker API (إذا كان المستخدم مسجل دخول)
      final user = supabaseClient.auth.currentUser;
      if (user != null) {
        try {
          // استخدام Worker API بدلاً من الاتصال المباشر
          final response = await ApiService.post(
            '/secure/notifications/register-token',
            data: {
              'fcm_token': token,
              'device_type': 'mobile', // يمكن تحديده بشكل أدق (android/ios)
            },
          );

          if (response['ok'] == true) {
            final action = response['data']?['action'];
            debugPrint(
              '✅ تم ${action == 'updated' ? 'تحديث' : 'حفظ'} FCM Token في قاعدة البيانات',
            );
          } else {
            debugPrint('⚠️ فشل حفظ FCM Token: ${response['error']}');
          }
        } catch (e) {
          debugPrint('⚠️ خطأ في حفظ FCM Token عبر Worker API: $e');
          // لا نوقف التطبيق إذا فشل حفظ Token
        }
      }
    } catch (e) {
      debugPrint('⚠️ خطأ في حفظ FCM Token: $e');
    }
  }

  // ==================== Local Notifications ====================

  /// عرض إشعار محلي
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    if (_localNotifications == null) {
      await initLocalNotifications();
    }

    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'mbuy_channel',
      'Mbuy Notifications',
      channelDescription: 'إشعارات من تطبيق Mbuy',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications!.show(
      notification.hashCode,
      notification.title ?? 'Mbuy',
      notification.body ?? '',
      details,
      payload: message.data.toString(),
    );
  }

  /// معالجة النقر على الإشعار
  static void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;

    // التوجيه بناءً على نوع الإشعار
    if (data.containsKey('type')) {
      final type = data['type'] as String;
      debugPrint('🔔 نوع الإشعار: $type');

      // يمكن إضافة منطق التوجيه هنا
      // مثال: إذا كان type == 'order' → التوجيه إلى شاشة الطلبات
      // يمكن استخدام Navigator أو AppRouter هنا
    }
  }
}
