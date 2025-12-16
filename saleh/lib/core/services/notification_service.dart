import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// خدمة الإشعارات والـ Push Notifications
class NotificationService {
  final http.Client _client;
  final FlutterSecureStorage _storage;
  static const String _baseUrl =
      'https://misty-mode-b68b.baharista1.workers.dev';

  NotificationService({http.Client? client, FlutterSecureStorage? storage})
    : _client = client ?? http.Client(),
      _storage = storage ?? const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'access_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // ============================================================================
  // Push Token Management
  // ============================================================================

  /// تسجيل توكن الإشعارات
  Future<bool> registerPushToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/secure/push/register'),
        headers: await _getHeaders(),
        body: json.encode({
          'token': token,
          'platform': platform,
          'device_id': deviceId,
          'device_name': deviceName,
        }),
      );
      final data = json.decode(response.body);
      return data['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  /// إلغاء تسجيل توكن الإشعارات
  Future<bool> unregisterPushToken(String token) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/secure/push/unregister'),
        headers: await _getHeaders(),
        body: json.encode({'token': token}),
      );
      final data = json.decode(response.body);
      return data['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  /// إرسال إشعار تجريبي
  Future<PushTestResult> testPushNotification() async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/secure/push/test'),
        headers: await _getHeaders(),
      );

      final data = json.decode(response.body);
      if (data['ok'] == true) {
        return PushTestResult(
          success: true,
          sentCount: data['sent_count'] ?? 0,
          message: data['message'],
        );
      }
      return PushTestResult(success: false, message: data['error']);
    } catch (e) {
      return PushTestResult(
        success: false,
        message: 'فشل في إرسال الإشعار التجريبي',
      );
    }
  }

  // ============================================================================
  // Notifications
  // ============================================================================

  /// جلب الإشعارات
  Future<NotificationsResult> getNotifications({
    int limit = 50,
    int offset = 0,
    bool unreadOnly = false,
  }) async {
    try {
      var uri = Uri.parse('$_baseUrl/secure/notifications').replace(
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
          if (unreadOnly) 'unread': 'true',
        },
      );

      final response = await _client.get(uri, headers: await _getHeaders());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ok'] == true) {
          final List<dynamic> notifs = data['data'];
          return NotificationsResult(
            notifications: notifs
                .map((e) => AppNotification.fromJson(e))
                .toList(),
            total: data['total'] ?? notifs.length,
            unreadCount: data['unread_count'] ?? 0,
          );
        }
      }
      return NotificationsResult(notifications: [], total: 0, unreadCount: 0);
    } catch (e) {
      return NotificationsResult(notifications: [], total: 0, unreadCount: 0);
    }
  }

  /// تعليم إشعار كمقروء
  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/secure/notifications/$notificationId/read'),
        headers: await _getHeaders(),
      );
      final data = json.decode(response.body);
      return data['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  /// تعليم جميع الإشعارات كمقروءة
  Future<bool> markAllAsRead() async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/secure/notifications/mark-all-read'),
        headers: await _getHeaders(),
      );
      final data = json.decode(response.body);
      return data['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  /// حذف إشعار
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/secure/notifications/$notificationId'),
        headers: await _getHeaders(),
      );
      final data = json.decode(response.body);
      return data['ok'] == true;
    } catch (e) {
      return false;
    }
  }
}

// ============================================================================
// Models
// ============================================================================

/// نموذج الإشعار
class AppNotification {
  final String id;
  final String title;
  final String? titleAr;
  final String body;
  final String? bodyAr;
  final String type;
  final Map<String, dynamic>? data;
  final String? actionUrl;
  final String? imageUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    this.titleAr,
    required this.body,
    this.bodyAr,
    required this.type,
    this.data,
    this.actionUrl,
    this.imageUrl,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      titleAr: json['title_ar'],
      body: json['body'] ?? '',
      bodyAr: json['body_ar'],
      type: json['type'] ?? 'general',
      data: json['data'],
      actionUrl: json['action_url'],
      imageUrl: json['image_url'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// العنوان المناسب للغة
  String get localizedTitle => titleAr ?? title;

  /// المحتوى المناسب للغة
  String get localizedBody => bodyAr ?? body;
}

/// نتيجة جلب الإشعارات
class NotificationsResult {
  final List<AppNotification> notifications;
  final int total;
  final int unreadCount;

  NotificationsResult({
    required this.notifications,
    required this.total,
    required this.unreadCount,
  });
}

/// نتيجة اختبار الإشعارات
class PushTestResult {
  final bool success;
  final int sentCount;
  final String? message;

  PushTestResult({required this.success, this.sentCount = 0, this.message});
}
