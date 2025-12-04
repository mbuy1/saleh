import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../supabase_client.dart';

/// MBUY API Service
/// Handles all API calls to Cloudflare Worker (API Gateway)
class ApiService {
  static const String baseUrl =
      'https://misty-mode-b68b.baharista1.workers.dev';

  /// Get JWT token from current session
  static Future<String?> _getJwtToken() async {
    try {
      final session = supabaseClient.auth.currentSession;
      return session?.accessToken;
    } catch (e) {
      debugPrint('Error getting JWT: $e');
      return null;
    }
  }

  /// Helper: Make authenticated request
  static Future<http.Response> _makeAuthRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final jwt = await _getJwtToken();
    if (jwt == null) {
      throw Exception('User not authenticated');
    }

    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(url, headers: headers);
      case 'POST':
        return await http.post(url, headers: headers, body: json.encode(body));
      case 'PUT':
        return await http.put(url, headers: headers, body: json.encode(body));
      case 'DELETE':
        return await http.delete(url, headers: headers);
      default:
        throw Exception('Unsupported method: $method');
    }
  }

  // ============================================================================
  // PUBLIC API METHODS
  // ============================================================================

  /// GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _makeAuthRequest('GET', endpoint);
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ GET Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _makeAuthRequest('POST', endpoint, body: data);
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ POST Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _makeAuthRequest('PUT', endpoint, body: data);
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ PUT Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _makeAuthRequest('DELETE', endpoint);
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ DELETE Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  // ============================================================================
  // MEDIA UPLOADS
  // ============================================================================

  /// Get upload URL for image
  static Future<Map<String, dynamic>> getImageUploadUrl(String filename) async {
    try {
      debugPrint('📡 طلب URL الرفع من Cloudflare Worker...');
      final response = await http.post(
        Uri.parse('$baseUrl/media/image'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'filename': filename}),
      );

      debugPrint('📥 استجابة Worker: ${response.statusCode}');
      debugPrint('📥 محتوى الاستجابة: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ تم الحصول على URL الرفع بنجاح');
        return data;
      } else {
        final errorBody = response.body;
        debugPrint('❌ فشل الحصول على URL الرفع: $errorBody');
        throw Exception(
          'فشل الحصول على URL الرفع (${response.statusCode}): $errorBody',
        );
      }
    } catch (e) {
      debugPrint('❌ خطأ في طلب URL الرفع: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('خطأ في طلب URL الرفع: ${e.toString()}');
    }
  }

  /// Get upload URL for video
  static Future<Map<String, dynamic>> getVideoUploadUrl(String filename) async {
    final response = await http.post(
      Uri.parse('$baseUrl/media/video'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'filename': filename}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get video upload URL: ${response.body}');
    }
  }

  /// Upload image file to Cloudflare Images
  static Future<String> uploadImage(String filePath) async {
    try {
      // 1. Get upload URL from Cloudflare Worker
      debugPrint('📤 طلب URL لرفع الصورة...');
      final uploadData = await getImageUploadUrl(filePath.split('/').last);

      if (uploadData['ok'] != true) {
        throw Exception(
          'فشل الحصول على URL الرفع: ${uploadData['error'] ?? 'خطأ غير معروف'}',
        );
      }

      final uploadUrl = uploadData['uploadURL'] as String?;
      final viewUrl = uploadData['viewURL'] as String?;

      if (uploadUrl == null || viewUrl == null) {
        throw Exception('لم يتم الحصول على URL الرفع من Cloudflare Worker');
      }

      debugPrint('✅ تم الحصول على URL الرفع: $uploadUrl');

      // 2. Upload file to Cloudflare Images
      debugPrint('📤 جاري رفع الصورة إلى Cloudflare Images...');
      final file = await http.MultipartFile.fromPath('file', filePath);
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(file);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📥 استجابة رفع الصورة: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ تم رفع الصورة بنجاح: $viewUrl');
        return viewUrl;
      } else {
        final errorBody = response.body;
        debugPrint('❌ فشل رفع الصورة: $errorBody');
        throw Exception('فشل رفع الصورة (${response.statusCode}): $errorBody');
      }
    } catch (e) {
      debugPrint('❌ خطأ في رفع الصورة: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('خطأ في رفع الصورة: ${e.toString()}');
    }
  }

  // ============================================================================
  // WALLET OPERATIONS
  // ============================================================================

  /// Get user wallet balance
  static Future<Map<String, dynamic>?> getWallet() async {
    final response = await _makeAuthRequest('GET', '/secure/wallet');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to get wallet: ${response.body}');
    }
  }

  /// Add funds to wallet
  static Future<Map<String, dynamic>> addWalletFunds({
    required double amount,
    required String paymentMethod,
    required String paymentReference,
  }) async {
    final response = await _makeAuthRequest(
      'POST',
      '/secure/wallet/add',
      body: {
        'amount': amount,
        'payment_method': paymentMethod,
        'payment_reference': paymentReference,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add wallet funds: ${response.body}');
    }
  }

  // ============================================================================
  // POINTS OPERATIONS
  // ============================================================================

  /// Get user points balance
  static Future<Map<String, dynamic>?> getPoints() async {
    final response = await _makeAuthRequest('GET', '/secure/points');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to get points: ${response.body}');
    }
  }

  /// Add or deduct points (admin only via server)
  static Future<Map<String, dynamic>> addPoints({
    required int points,
    required String reason,
  }) async {
    final response = await _makeAuthRequest(
      'POST',
      '/secure/points/add',
      body: {'points': points, 'reason': reason},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add points: ${response.body}');
    }
  }

  // ============================================================================
  // ORDER OPERATIONS
  // ============================================================================

  /// Create new order
  static Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> products,
    required String deliveryAddress,
    required String paymentMethod,
    int? pointsToUse,
    String? couponCode,
  }) async {
    final response = await _makeAuthRequest(
      'POST',
      '/secure/orders/create',
      body: {
        'products': products,
        'delivery_address': deliveryAddress,
        'payment_method': paymentMethod,
        if (pointsToUse != null) 'points_to_use': pointsToUse,
        if (couponCode != null) 'coupon_code': couponCode,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  // ============================================================================
  // MERCHANT REGISTRATION
  // ============================================================================

  /// Register as merchant
  static Future<Map<String, dynamic>> registerMerchant({
    required String userId,
    required String storeName,
    required String city,
    required String district,
    required String address,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/public/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'store_name': storeName,
        'city': city,
        'district': district,
        'address': address,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register merchant: ${response.body}');
    }
  }

  // ============================================================================
  // HEALTH CHECK
  // ============================================================================

  /// Check API health
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ok'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }
}
