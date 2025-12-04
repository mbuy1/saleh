import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'supabase_client.dart';

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
  // MEDIA UPLOADS
  // ============================================================================

  /// Get upload URL for image
  static Future<Map<String, dynamic>> getImageUploadUrl(String filename) async {
    final response = await http.post(
      Uri.parse('$baseUrl/media/image'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'filename': filename}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get image upload URL: ${response.body}');
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
    // 1. Get upload URL
    final uploadData = await getImageUploadUrl(filePath.split('/').last);
    final uploadUrl = uploadData['uploadURL'];
    final viewUrl = uploadData['viewURL'];

    // 2. Upload file
    final file = await http.MultipartFile.fromPath('file', filePath);
    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files.add(file);

    final response = await request.send();

    if (response.statusCode == 200) {
      return viewUrl;
    } else {
      throw Exception('Failed to upload image');
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
