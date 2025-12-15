import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

final mbuyStudioServiceProvider = Provider<MbuyStudioService>((ref) {
  return MbuyStudioService(ApiService());
});

class MbuyStudioService {
  final ApiService _api;

  MbuyStudioService(this._api);

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _api.post(path, body: body);
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data is Map<String, dynamic> ? data : {'data': data};
    }
    throw Exception(
      data is Map && data['error'] != null ? data['error'] : 'Request failed',
    );
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String>? query,
  }) async {
    final response = await _api.get(path, queryParams: query);
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data is Map<String, dynamic> ? data : {'data': data};
    }
    throw Exception(
      data is Map && data['error'] != null ? data['error'] : 'Request failed',
    );
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
  });

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
