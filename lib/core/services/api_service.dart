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
  // PRODUCTS OPERATIONS (PUBLIC)
  // ============================================================================

  /// Get products with optional filters (public - no auth required)
  static Future<Map<String, dynamic>> getProducts({
    int? limit,
    int? offset,
    String? categoryId,
    String? storeId,
    String? status,
    String? sortBy,
    bool? descending,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (storeId != null) queryParams['store_id'] = storeId;
      if (status != null) queryParams['status'] = status;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (descending != null) queryParams['desc'] = descending.toString();

      final uri = Uri.parse(
        '$baseUrl/public/products',
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await http.get(uri);
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getProducts Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Get featured products (with discounts)
  static Future<Map<String, dynamic>> getFeaturedProducts({
    int limit = 10,
  }) async {
    return getProducts(limit: limit, sortBy: 'discount', descending: true);
  }

  /// Get new arrivals
  static Future<Map<String, dynamic>> getNewArrivals({int limit = 10}) async {
    return getProducts(limit: limit, sortBy: 'created_at', descending: true);
  }

  /// Get best sellers
  static Future<Map<String, dynamic>> getBestSellers({int limit = 10}) async {
    return getProducts(limit: limit, sortBy: 'sales_count', descending: true);
  }

  /// Get product by ID (public)
  static Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/public/products/$productId'),
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getProductById Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  // ============================================================================
  // STORES OPERATIONS (PUBLIC)
  // ============================================================================

  /// Get all stores (public - no auth required)
  static Future<Map<String, dynamic>> getStores({
    int? limit,
    int? offset,
    String? city,
    bool? isVerified,
    bool? isBoosted,
    String? sortBy,
    bool? descending,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
      if (city != null) queryParams['city'] = city;
      if (isVerified != null) {
        queryParams['is_verified'] = isVerified.toString();
      }
      if (isBoosted != null) queryParams['is_boosted'] = isBoosted.toString();
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (descending != null) queryParams['desc'] = descending.toString();

      final uri = Uri.parse(
        '$baseUrl/public/stores',
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await http.get(uri);
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getStores Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Get store by ID (public)
  static Future<Map<String, dynamic>> getStoreById(String storeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/public/stores/$storeId'),
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getStoreById Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Get store products (public)
  static Future<Map<String, dynamic>> getStoreProducts(
    String storeId, {
    int? limit,
    int? offset,
  }) async {
    return getProducts(storeId: storeId, limit: limit, offset: offset);
  }

  // ============================================================================
  // CATEGORIES OPERATIONS (PUBLIC)
  // ============================================================================

  /// Get all categories (public)
  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/public/categories'));
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getCategories Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Get category products (public)
  static Future<Map<String, dynamic>> getCategoryProducts(
    String categoryId, {
    int? limit,
    int? offset,
  }) async {
    return getProducts(categoryId: categoryId, limit: limit, offset: offset);
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

  // ============================================================================
  // MERCHANT ANALYTICS
  // ============================================================================

  /// Get product analytics for merchant
  static Future<Map<String, dynamic>> getProductAnalytics({
    String period = '30d',
  }) async {
    try {
      final response = await _makeAuthRequest(
        'GET',
        '/secure/merchant/analytics/products?period=$period',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getProductAnalytics Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Get order analytics for merchant
  static Future<Map<String, dynamic>> getOrderAnalytics({
    String period = '30d',
  }) async {
    try {
      final response = await _makeAuthRequest(
        'GET',
        '/secure/merchant/analytics/orders?period=$period',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getOrderAnalytics Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Get customer analytics for merchant
  static Future<Map<String, dynamic>> getCustomerAnalytics({
    String period = '30d',
  }) async {
    try {
      final response = await _makeAuthRequest(
        'GET',
        '/secure/merchant/analytics/customers?period=$period',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getCustomerAnalytics Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Get revenue analytics for merchant
  static Future<Map<String, dynamic>> getRevenueAnalytics({
    String period = '30d',
  }) async {
    try {
      final response = await _makeAuthRequest(
        'GET',
        '/secure/merchant/analytics/revenue?period=$period',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getRevenueAnalytics Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  // ============================================================================
  // MERCHANT REVIEWS
  // ============================================================================

  /// Get merchant reviews
  static Future<Map<String, dynamic>> getMerchantReviews({
    int? limit,
    int? offset,
    int? rating,
    bool? hasReply,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
      if (rating != null) queryParams['rating'] = rating.toString();
      if (hasReply != null) queryParams['has_reply'] = hasReply.toString();

      final uri = Uri.parse(
        '$baseUrl/secure/merchant/reviews',
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await _makeAuthRequest(
        'GET',
        uri.path + (uri.query.isNotEmpty ? '?${uri.query}' : ''),
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getMerchantReviews Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Reply to a review
  static Future<Map<String, dynamic>> replyToReview(
    String reviewId,
    String reply,
  ) async {
    try {
      final response = await _makeAuthRequest(
        'POST',
        '/secure/merchant/reviews/$reviewId/reply',
        body: {'reply': reply},
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ replyToReview Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  // ============================================================================
  // MERCHANT COUPONS
  // ============================================================================

  /// Get merchant coupons
  static Future<Map<String, dynamic>> getMerchantCoupons() async {
    try {
      final response = await _makeAuthRequest(
        'GET',
        '/secure/merchant/coupons',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getMerchantCoupons Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Create a new coupon
  static Future<Map<String, dynamic>> createCoupon(
    Map<String, dynamic> couponData,
  ) async {
    try {
      final response = await _makeAuthRequest(
        'POST',
        '/secure/merchant/coupons',
        body: couponData,
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ createCoupon Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Update a coupon
  static Future<Map<String, dynamic>> updateCoupon(
    String couponId,
    Map<String, dynamic> couponData,
  ) async {
    try {
      final response = await _makeAuthRequest(
        'PUT',
        '/secure/merchant/coupons/$couponId',
        body: couponData,
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ updateCoupon Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Delete a coupon
  static Future<Map<String, dynamic>> deleteCoupon(String couponId) async {
    try {
      final response = await _makeAuthRequest(
        'DELETE',
        '/secure/merchant/coupons/$couponId',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ deleteCoupon Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Apply coupon code
  static Future<Map<String, dynamic>> applyCoupon(
    String couponCode,
    double orderTotal,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/public/coupons/apply'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'code': couponCode, 'order_total': orderTotal}),
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ applyCoupon Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  // ============================================================================
  // MERCHANT BANNERS
  // ============================================================================

  /// Get merchant banners
  static Future<Map<String, dynamic>> getMerchantBanners() async {
    try {
      final response = await _makeAuthRequest(
        'GET',
        '/secure/merchant/banners',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getMerchantBanners Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Create a new banner
  static Future<Map<String, dynamic>> createBanner(
    Map<String, dynamic> bannerData,
  ) async {
    try {
      final response = await _makeAuthRequest(
        'POST',
        '/secure/merchant/banners',
        body: bannerData,
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ createBanner Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Update a banner
  static Future<Map<String, dynamic>> updateBanner(
    String bannerId,
    Map<String, dynamic> bannerData,
  ) async {
    try {
      final response = await _makeAuthRequest(
        'PUT',
        '/secure/merchant/banners/$bannerId',
        body: bannerData,
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ updateBanner Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Delete a banner
  static Future<Map<String, dynamic>> deleteBanner(String bannerId) async {
    try {
      final response = await _makeAuthRequest(
        'DELETE',
        '/secure/merchant/banners/$bannerId',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ deleteBanner Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Reorder banners
  static Future<Map<String, dynamic>> reorderBanners(
    List<String> bannerIds,
  ) async {
    try {
      final response = await _makeAuthRequest(
        'POST',
        '/secure/merchant/banners/reorder',
        body: {'order': bannerIds},
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ reorderBanners Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Get public banners
  static Future<Map<String, dynamic>> getPublicBanners({
    String? storeId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (storeId != null) queryParams['store_id'] = storeId;

      final uri = Uri.parse(
        '$baseUrl/public/banners',
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await http.get(uri);
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getPublicBanners Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  // ============================================================================
  // MERCHANT VIDEOS
  // ============================================================================

  /// Get merchant videos
  static Future<Map<String, dynamic>> getMerchantVideos() async {
    try {
      final response = await _makeAuthRequest('GET', '/secure/merchant/videos');
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getMerchantVideos Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Delete a video
  static Future<Map<String, dynamic>> deleteVideo(String videoId) async {
    try {
      final response = await _makeAuthRequest(
        'DELETE',
        '/secure/merchant/videos/$videoId',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ deleteVideo Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Get public videos (feed)
  static Future<Map<String, dynamic>> getPublicVideos({
    int? limit,
    int? offset,
    String? storeId,
    String? productId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
      if (storeId != null) queryParams['store_id'] = storeId;
      if (productId != null) queryParams['product_id'] = productId;

      final uri = Uri.parse(
        '$baseUrl/public/videos',
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await http.get(uri);
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ getPublicVideos Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Like a video
  static Future<Map<String, dynamic>> likeVideo(String videoId) async {
    try {
      final response = await _makeAuthRequest(
        'POST',
        '/secure/videos/$videoId/like',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ likeVideo Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Share a video
  static Future<Map<String, dynamic>> shareVideo(String videoId) async {
    try {
      final response = await _makeAuthRequest(
        'POST',
        '/secure/videos/$videoId/share',
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ shareVideo Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Record video view
  static Future<Map<String, dynamic>> recordVideoView(String videoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/public/videos/$videoId/view'),
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ recordVideoView Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }

  // ============================================================================
  // GLOBAL SEARCH
  // ============================================================================

  /// Global search across products, stores, and videos
  static Future<Map<String, dynamic>> globalSearch(
    String query, {
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/public/search?q=${Uri.encodeComponent(query)}&limit=$limit',
        ),
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('❌ globalSearch Error: $e');
      return {'ok': false, 'error': e.toString()};
    }
  }
}
