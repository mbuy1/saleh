import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// خدمة إدارة الاشتراكات
class SubscriptionService {
  final http.Client _client;
  final FlutterSecureStorage _storage;
  static const String _baseUrl =
      'https://misty-mode-b68b.baharista1.workers.dev';

  SubscriptionService({http.Client? client, FlutterSecureStorage? storage})
    : _client = client ?? http.Client(),
      _storage = storage ?? const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'access_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// جلب الباقات المتاحة
  Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/secure/subscriptions/plans'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ok'] == true) {
          final List<dynamic> plans = data['data'];
          return plans.map((e) => SubscriptionPlan.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// جلب الاشتراك الحالي
  Future<Subscription?> getCurrentSubscription() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/secure/subscription'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ok'] == true) {
          return Subscription.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// إنشاء اشتراك جديد
  Future<SubscriptionResult> createSubscription({
    required String planId,
    required String storeId,
    String? paymentMethod,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/secure/subscription'),
        headers: await _getHeaders(),
        body: json.encode({
          'plan_id': planId,
          'store_id': storeId,
          'payment_method': paymentMethod,
        }),
      );

      final data = json.decode(response.body);
      if (data['ok'] == true) {
        return SubscriptionResult(
          success: true,
          subscription: Subscription.fromJson(data['data']),
          message: data['message'],
        );
      }
      return SubscriptionResult(
        success: false,
        error: data['error'] ?? 'فشل في إنشاء الاشتراك',
      );
    } catch (e) {
      return SubscriptionResult(success: false, error: 'حدث خطأ في الاتصال');
    }
  }

  /// استخدام رصيد AI
  Future<AiCreditResult> useAiCredits({required String type}) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/secure/subscription/use-ai'),
        headers: await _getHeaders(),
        body: json.encode({'type': type}),
      );

      final data = json.decode(response.body);
      if (data['ok'] == true) {
        return AiCreditResult(canUse: true, remaining: data['remaining'] ?? 0);
      }
      return AiCreditResult(
        canUse: false,
        error: data['error'] ?? 'لا يمكن استخدام الرصيد',
        limit: data['limit'],
        used: data['used'],
      );
    } catch (e) {
      return AiCreditResult(canUse: false, error: 'حدث خطأ في الاتصال');
    }
  }

  /// إلغاء الاشتراك
  Future<bool> cancelSubscription() async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/secure/subscription/cancel'),
        headers: await _getHeaders(),
      );
      final data = json.decode(response.body);
      return data['ok'] == true;
    } catch (e) {
      return false;
    }
  }

  /// جلب سجل الاشتراكات
  Future<List<Subscription>> getSubscriptionHistory() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/secure/subscription/history'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ok'] == true) {
          final List<dynamic> subs = data['data'];
          return subs.map((e) => Subscription.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

// ============================================================================
// Models
// ============================================================================

/// نموذج خطة الاشتراك
class SubscriptionPlan {
  final String id;
  final String name;
  final String nameEn;
  final double price;
  final int aiImagesLimit;
  final int aiVideosLimit;
  final int productsLimit;
  final List<String> features;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.price,
    required this.aiImagesLimit,
    required this.aiVideosLimit,
    required this.productsLimit,
    required this.features,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['name_en'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      aiImagesLimit: json['ai_images_limit'] ?? 0,
      aiVideosLimit: json['ai_videos_limit'] ?? 0,
      productsLimit: json['products_limit'] ?? 0,
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  bool get isFree => price == 0;
  bool get isUnlimited => productsLimit >= 999999;
}

/// نموذج الاشتراك
class Subscription {
  final String? id;
  final String planId;
  final String planName;
  final String status;
  final double price;
  final String currency;
  final int aiImagesLimit;
  final int aiImagesUsed;
  final int aiVideosLimit;
  final int aiVideosUsed;
  final int productsLimit;
  final int productsUsed;
  final DateTime? expiresAt;
  final bool isFree;

  Subscription({
    this.id,
    required this.planId,
    required this.planName,
    required this.status,
    required this.price,
    required this.currency,
    required this.aiImagesLimit,
    required this.aiImagesUsed,
    required this.aiVideosLimit,
    required this.aiVideosUsed,
    required this.productsLimit,
    required this.productsUsed,
    this.expiresAt,
    this.isFree = false,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      planId: json['plan_id'] ?? 'starter',
      planName: json['plan_name'] ?? 'باقة البداية',
      status: json['status'] ?? 'active',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'SAR',
      aiImagesLimit: json['ai_images_limit'] ?? 3,
      aiImagesUsed: json['ai_images_used'] ?? 0,
      aiVideosLimit: json['ai_videos_limit'] ?? 0,
      aiVideosUsed: json['ai_videos_used'] ?? 0,
      productsLimit: json['products_limit'] ?? 50,
      productsUsed: json['products_used'] ?? 0,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
      isFree: json['is_free'] ?? false,
    );
  }

  int get aiImagesRemaining => aiImagesLimit - aiImagesUsed;
  int get aiVideosRemaining => aiVideosLimit - aiVideosUsed;
  bool get isActive => status == 'active';
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());

  double get aiImagesProgress =>
      aiImagesLimit > 0 ? aiImagesUsed / aiImagesLimit : 0;
  double get aiVideosProgress =>
      aiVideosLimit > 0 ? aiVideosUsed / aiVideosLimit : 0;
}

/// نتيجة إنشاء الاشتراك
class SubscriptionResult {
  final bool success;
  final Subscription? subscription;
  final String? message;
  final String? error;

  SubscriptionResult({
    required this.success,
    this.subscription,
    this.message,
    this.error,
  });
}

/// نتيجة استخدام رصيد AI
class AiCreditResult {
  final bool canUse;
  final int? remaining;
  final int? limit;
  final int? used;
  final String? error;

  AiCreditResult({
    required this.canUse,
    this.remaining,
    this.limit,
    this.used,
    this.error,
  });
}
