import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

final mbuyStudioServiceProvider = Provider<MbuyStudioService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MbuyStudioService(apiService);
});

class MbuyStudioService {
  final ApiService _api;

  MbuyStudioService(this._api);

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body, {
    Duration timeout = const Duration(seconds: 60),
  }) async {
    debugPrint(
      '[MbuyStudioService] POST $path (timeout: ${timeout.inSeconds}s)',
    );
    debugPrint('[MbuyStudioService] Body: $body');

    // Debug: Check if we have valid tokens
    final hasTokens = await _api.hasValidTokens();
    debugPrint('[MbuyStudioService] Has valid tokens: $hasTokens');

    final response = await _api.post(path, body: body, timeout: timeout);
    debugPrint('[MbuyStudioService] Status: ${response.statusCode}');
    debugPrint('[MbuyStudioService] Response: ${response.body}');

    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data is Map<String, dynamic> ? data : {'data': data};
    }

    // Better error handling with Arabic messages
    String errorMessage = 'فشل الطلب';
    if (response.statusCode == 401) {
      errorMessage = 'يرجى تسجيل الدخول أولاً لاستخدام أدوات AI';
    } else if (response.statusCode == 403) {
      errorMessage = 'ليس لديك صلاحية للوصول لهذه الميزة';
    } else if (response.statusCode == 500) {
      // Show server error details for debugging
      if (data is Map) {
        final detail = data['detail'] ?? data['error'] ?? data['message'];
        errorMessage = 'خطأ في الخادم: ${detail ?? response.body}';
      } else {
        errorMessage = 'خطأ في الخادم: ${response.body}';
      }
    } else if (data is Map) {
      final msg = data['detail'] ?? data['error'] ?? data['message'];
      if (msg != null) {
        // Translate common error messages
        if (msg.toString().contains('unauthorized') ||
            msg.toString().contains('Missing authentication')) {
          errorMessage = 'يرجى تسجيل الدخول أولاً لاستخدام أدوات AI';
        } else if (msg.toString().contains('prompt is required')) {
          errorMessage = 'يرجى إدخال وصف للمحتوى المطلوب';
        } else {
          errorMessage = msg.toString();
        }
      }
    }
    throw Exception(errorMessage);
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String>? query,
  }) async {
    debugPrint('[MbuyStudioService] GET $path');

    final response = await _api.get(path, queryParams: query);
    debugPrint('[MbuyStudioService] Status: ${response.statusCode}');

    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data is Map<String, dynamic> ? data : {'data': data};
    }

    String errorMessage = 'Request failed';
    if (data is Map) {
      errorMessage =
          data['detail'] ??
          data['error'] ??
          data['message'] ??
          'Request failed';
    }
    throw Exception(errorMessage);
  }

  Future<Map<String, dynamic>> generateText(String prompt) =>
      _post('/secure/ai/generate/text', {'prompt': prompt});

  Future<Map<String, dynamic>> generateImage(
    String prompt, {
    String? style,
    String? size,
  }) => _post('/secure/ai/generate/image', {
    'prompt': prompt,
    if (style != null) 'style': style,
    if (size != null) 'size': size,
  });

  Future<Map<String, dynamic>> generateBanner(
    String prompt, {
    String? placement,
    String? sizePreset,
  }) => _post('/secure/ai/generate/banner', {
    'prompt': prompt,
    if (placement != null) 'placement': placement,
    if (sizePreset != null) 'sizePreset': sizePreset,
  });

  Future<Map<String, dynamic>> generateVideo(
    String prompt, {
    int? duration,
    String? aspect,
  }) => _post('/secure/ai/generate/video', {
    'prompt': prompt,
    if (duration != null) 'duration': duration,
    if (aspect != null) 'aspect': aspect,
  });

  Future<Map<String, dynamic>> generateAudio(
    String text, {
    String? voice,
    String? language,
  }) => _post('/secure/ai/generate/audio', {
    'text': text,
    if (voice != null) 'voice_type': voice,
    if (language != null) 'language': language,
  });

  Future<Map<String, dynamic>> generateProductDescription({
    required String prompt,
    String? productId,
    String? language,
    String? tone,
  }) => _post('/secure/ai/generate/product-description', {
    'prompt': prompt,
    if (productId != null) 'product_id': productId,
    if (language != null) 'language': language,
    if (tone != null) 'tone': tone,
  });

  Future<Map<String, dynamic>> generateKeywords({
    required String prompt,
    String? productId,
    String? language,
  }) => _post('/secure/ai/generate/keywords', {
    'prompt': prompt,
    if (productId != null) 'product_id': productId,
    if (language != null) 'language': language,
  });

  Future<Map<String, dynamic>> generateLogo({
    required String brandName,
    String? style,
    String? colors,
    String? prompt,
  }) => _post('/secure/ai/generate/logo', {
    'brand_name': brandName,
    if (style != null) 'style': style,
    if (colors != null) 'colors': colors,
    if (prompt != null) 'prompt': prompt,
  }, timeout: const Duration(seconds: 120)); // 3 صور تحتاج وقت أطول

  Future<Map<String, dynamic>> getLibrary(String type) =>
      _get('/secure/ai/library', query: {'type': type});

  Future<Map<String, dynamic>> getJob(String jobId) =>
      _get('/secure/ai/jobs/$jobId');

  // Legacy compatibility helpers
  Future<Map<String, dynamic>> generateDesign({
    required String tier,
    required String productName,
    String? prompt,
    String? action,
    String? designType,
  }) {
    // Map banners to banner endpoint, otherwise image
    if ((designType ?? '').contains('banner')) {
      return generateBanner(prompt ?? productName);
    }
    return generateImage(prompt ?? productName);
  }

  Future<Map<String, dynamic>> getTask(String taskId) => getJob(taskId);

  Future<Map<String, dynamic>> getAnalytics(String type) =>
      _get('/secure/analytics', query: {'type': type});

  Future<Map<String, dynamic>> generateCloudflareContent({
    required String taskType,
    required String prompt,
    String? imageBase64,
  }) => _post('/secure/ai/cloudflare/generate', {
    'taskType': taskType,
    'prompt': prompt,
    if (imageBase64 != null) 'image': imageBase64,
  });
}
