import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_config.dart';

/// API Service - Handles all HTTP communication with Cloudflare Worker
///
/// This service:
/// - Manages all HTTP requests (GET, POST, PUT, DELETE)
/// - Handles authentication via Bearer tokens
/// - Automatic retry logic for failed requests
/// - Token refresh on 401 responses
class ApiService {
  final String baseUrl;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  // ==========================================================================
  // Public HTTP Methods
  // ==========================================================================

  /// GET request
  Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);
    final mergedHeaders = await _withAuthHeaders(headers);

    return _makeRequest(() async {
      return await http.get(uri, headers: mergedHeaders);
    });
  }

  /// POST request
  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = _buildUri(path, null);
    final mergedHeaders = await _withAuthHeaders(headers);
    mergedHeaders['Content-Type'] = 'application/json';

    return _makeRequest(() async {
      return await http.post(
        uri,
        headers: mergedHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    });
  }

  /// PUT request
  Future<http.Response> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = _buildUri(path, null);
    final mergedHeaders = await _withAuthHeaders(headers);
    mergedHeaders['Content-Type'] = 'application/json';

    return _makeRequest(() async {
      return await http.put(
        uri,
        headers: mergedHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    });
  }

  /// DELETE request
  Future<http.Response> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, null);
    final mergedHeaders = await _withAuthHeaders(headers);

    return _makeRequest(() async {
      return await http.delete(uri, headers: mergedHeaders);
    });
  }

  // ==========================================================================
  // Helper Methods
  // ==========================================================================

  /// Build URI with query parameters
  Uri _buildUri(String path, Map<String, String>? queryParams) {
    final fullPath = path.startsWith('/') ? path : '/$path';
    final url = '$baseUrl$fullPath';

    if (queryParams != null && queryParams.isNotEmpty) {
      return Uri.parse(url).replace(queryParameters: queryParams);
    }

    return Uri.parse(url);
  }

  /// Add authentication headers
  Future<Map<String, String>> _withAuthHeaders(
    Map<String, String>? headers,
  ) async {
    final Map<String, String> result = {};

    if (headers != null) {
      result.addAll(headers);
    }

    // Add Authorization header if token exists
    final token = await _secureStorage.read(key: AppConfig.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      result['Authorization'] = 'Bearer $token';
    }

    return result;
  }

  /// Make HTTP request with retry logic
  Future<http.Response> _makeRequest(
    Future<http.Response> Function() requestFunction,
  ) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      attempts++;

      try {
        final response = await requestFunction().timeout(
          const Duration(seconds: 30),
        );

        // Handle 401 Unauthorized - attempt token refresh
        if (response.statusCode == 401 && attempts == 1) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry request with new token
            continue;
          }
        }

        return response;
      } on SocketException catch (_) {
        if (attempts >= maxRetries) {
          rethrow;
        }
        await Future.delayed(retryDelay * attempts);
      } on HttpException catch (_) {
        if (attempts >= maxRetries) {
          rethrow;
        }
        await Future.delayed(retryDelay * attempts);
      } catch (e) {
        rethrow;
      }
    }

    throw Exception('Max retries exceeded');
  }

  /// Refresh authentication token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: AppConfig.refreshTokenKey,
      );

      if (refreshToken == null) {
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl${AppConfig.refreshEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['ok'] == true && data['token'] != null) {
          await _secureStorage.write(
            key: AppConfig.accessTokenKey,
            value: data['token'],
          );

          if (data['refresh_token'] != null) {
            await _secureStorage.write(
              key: AppConfig.refreshTokenKey,
              value: data['refresh_token'],
            );
          }

          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // ==========================================================================
  // Utility Methods
  // ==========================================================================

  /// Parse JSON response
  Map<String, dynamic> parseResponse(http.Response response) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Check if response is successful
  bool isSuccessful(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}

/// Riverpod Provider للوصول لـ ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
