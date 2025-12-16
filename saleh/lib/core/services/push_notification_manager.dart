import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

/// مدير الإشعارات الفورية (Push Notifications)
class PushNotificationManager {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationService _notificationService;

  String? _currentToken;

  PushNotificationManager({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();

  /// تهيئة الإشعارات
  Future<void> initialize() async {
    // طلب الأذونات
    await _requestPermissions();

    // الحصول على التوكن
    await _getToken();

    // الاستماع لتحديثات التوكن
    _messaging.onTokenRefresh.listen(_handleTokenRefresh);

    // التعامل مع الرسائل في الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // التعامل مع الرسائل في الواجهة
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // التعامل مع النقر على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // التحقق من إشعار فتح التطبيق
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// طلب أذونات الإشعارات
  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('[Push] Permission status: ${settings.authorizationStatus}');
  }

  /// الحصول على توكن FCM
  Future<String?> _getToken() async {
    try {
      _currentToken = await _messaging.getToken();
      debugPrint('[Push] Token: $_currentToken');

      if (_currentToken != null) {
        await _registerToken(_currentToken!);
      }

      return _currentToken;
    } catch (e) {
      debugPrint('[Push] Error getting token: $e');
      return null;
    }
  }

  /// تسجيل التوكن في الـ API
  Future<void> _registerToken(String token) async {
    final platform = Platform.isIOS ? 'ios' : 'android';

    final success = await _notificationService.registerPushToken(
      token: token,
      platform: platform,
      deviceName: await _getDeviceName(),
    );

    debugPrint('[Push] Token registered: $success');
  }

  /// الحصول على اسم الجهاز
  Future<String> _getDeviceName() async {
    if (Platform.isAndroid) {
      return 'Android Device';
    } else if (Platform.isIOS) {
      return 'iOS Device';
    }
    return 'Unknown Device';
  }

  /// التعامل مع تحديث التوكن
  Future<void> _handleTokenRefresh(String token) async {
    debugPrint('[Push] Token refreshed: $token');
    _currentToken = token;
    await _registerToken(token);
  }

  /// التعامل مع الرسائل في الواجهة
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[Push] Foreground message: ${message.notification?.title}');

    // يمكن عرض إشعار محلي هنا
    _showLocalNotification(message);
  }

  /// التعامل مع النقر على الإشعار
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('[Push] Notification tapped: ${message.data}');

    // التنقل بناءً على البيانات
    final type = message.data['type'];
    final actionUrl = message.data['action_url'];

    if (actionUrl != null) {
      // يمكن استخدام GoRouter للتنقل
      debugPrint('[Push] Navigate to: $actionUrl (type: $type)');
    }
  }

  /// عرض إشعار محلي (في الواجهة)
  void _showLocalNotification(RemoteMessage message) {
    // TODO: استخدام flutter_local_notifications لعرض إشعار
    final notification = message.notification;
    if (notification != null) {
      debugPrint('[Push] Show local: ${notification.title}');
    }
  }

  /// إلغاء تسجيل التوكن (عند تسجيل الخروج)
  Future<void> unregister() async {
    if (_currentToken != null) {
      await _notificationService.unregisterPushToken(_currentToken!);
      await _messaging.deleteToken();
      _currentToken = null;
      debugPrint('[Push] Token unregistered');
    }
  }

  /// إرسال إشعار تجريبي
  Future<PushTestResult> sendTestNotification() async {
    return await _notificationService.testPushNotification();
  }

  /// الحصول على التوكن الحالي
  String? get currentToken => _currentToken;
}

/// معالج الإشعارات في الخلفية (يجب أن يكون top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[Push] Background message: ${message.notification?.title}');
}
