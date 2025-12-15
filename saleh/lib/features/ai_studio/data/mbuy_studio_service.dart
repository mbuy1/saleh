import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

final mbuyStudioServiceProvider = Provider<MbuyStudioService>((ref) {
  return MbuyStudioService(ApiService());
});

class MbuyStudioService {
  final ApiService _apiService;

  MbuyStudioService(this._apiService);

  Future<String> generate(String prompt) async {
    final response = await _apiService.post(
      '/secure/ai/nano-banana/generate',
      body: {'prompt': prompt},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['taskId'];
    } else {
      throw Exception('Failed to start generation: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getTask(String taskId) async {
    final response = await _apiService.get(
      '/secure/ai/nano-banana/task',
      queryParams: {'taskId': taskId},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get task info: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> generateCloudflareContent({
    required String taskType,
    required String prompt,
    String? imageBase64,
  }) async {
    final response = await _apiService.post(
      '/secure/ai/cloudflare/generate',
      body: {'taskType': taskType, 'prompt': prompt, 'image': imageBase64},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to generate content: ${response.body}');
    }
  }

  /// توليد تصميم حسب tier (Pro أو Premium)
  Future<Map<String, dynamic>> generateDesign({
    required String tier, // 'pro' or 'premium'
    required String productName,
    String? prompt,
    String? action, // 'generate_design'
    String? designType, // 'product_image', 'banner', etc.
  }) async {
    final body = {
      'tier': tier,
      'productName': productName,
      'action': action ?? 'generate_design',
      'provider': tier == 'pro' ? 'cloudflare' : 'nano_banana',
    };

    if (prompt != null && prompt.isNotEmpty) {
      body['prompt'] = prompt;
    }

    if (designType != null) {
      body['designType'] = designType;
    }

    final response = await _apiService.post('/secure/ai/generate', body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorBody = response.body;
      throw Exception('Failed to generate design: $errorBody');
    }
  }

  Future<Map<String, dynamic>> getAnalytics(String type) async {
    final response = await _apiService.get(
      '/secure/analytics',
      queryParams: {'type': type},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get analytics: ${response.body}');
    }
  }
}
