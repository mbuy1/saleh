import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// خدمة Mbuy Studio (توليد المحتوى فقط)
/// TODO: إكمال التنفيذ عند الحاجة
/// المفاتيح السرية يجب أن تكون في Worker Secrets، وليس هنا
class MbuyStudioService {
  /// توليد مقطع فيديو
  /// 
  /// Parameters:
  /// - prompt: الوصف النصي للفيديو
  /// - duration: المدة بالثواني (افتراضي: 30)
  /// - style: النمط (promotional, tutorial, etc.)
  /// 
  /// Returns: Map with generated video details
  static Future<Map<String, dynamic>> generateVideo({
    required String prompt,
    int duration = 30,
    String? style,
  }) async {
    try {
      debugPrint('[MbuyStudioService] Generating video: $prompt');
      
      final response = await ApiService.post(
        '/secure/mbuy-studio/generate-video',
        data: {
          'prompt': prompt,
          'duration': duration,
          if (style != null) 'style': style,
        },
      );

      if (response['ok'] == true) {
        return {
          'video_id': response['data']?['video_id'],
          'video_url': response['data']?['video_url'],
          'thumbnail_url': response['data']?['thumbnail_url'],
          'status': response['data']?['status'],
          'estimated_time': response['data']?['estimated_time'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل توليد الفيديو');
      }
    } catch (e) {
      debugPrint('[MbuyStudioService] Error generating video: $e');
      rethrow;
    }
  }

  /// توليد صورة
  /// 
  /// Parameters:
  /// - prompt: الوصف النصي للصورة
  /// - style: النمط (realistic, artistic, etc.)
  /// - dimensions: الأبعاد (width, height)
  /// 
  /// Returns: Map with generated image details
  static Future<Map<String, dynamic>> generateImage({
    required String prompt,
    String? style,
    Map<String, int>? dimensions,
  }) async {
    try {
      debugPrint('[MbuyStudioService] Generating image: $prompt');
      
      final response = await ApiService.post(
        '/secure/mbuy-studio/generate-image',
        data: {
          'prompt': prompt,
          if (style != null) 'style': style,
          if (dimensions != null) 'dimensions': dimensions,
        },
      );

      if (response['ok'] == true) {
        return {
          'image_id': response['data']?['image_id'],
          'image_url': response['data']?['image_url'],
          'thumbnail_url': response['data']?['thumbnail_url'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل توليد الصورة');
      }
    } catch (e) {
      debugPrint('[MbuyStudioService] Error generating image: $e');
      rethrow;
    }
  }

  /// توليد صوت
  /// 
  /// Parameters:
  /// - text: النص المراد تحويله إلى صوت
  /// - voice: نوع الصوت (male, female, etc.)
  /// - language: اللغة (ar, en, etc.)
  /// 
  /// Returns: Map with generated audio details
  static Future<Map<String, dynamic>> generateAudio({
    required String text,
    String? voice,
    String language = 'ar',
  }) async {
    try {
      debugPrint('[MbuyStudioService] Generating audio from text: ${text.substring(0, 50)}...');
      
      final response = await ApiService.post(
        '/secure/mbuy-studio/generate-audio',
        data: {
          'text': text,
          if (voice != null) 'voice': voice,
          'language': language,
        },
      );

      if (response['ok'] == true) {
        return {
          'audio_id': response['data']?['audio_id'],
          'audio_url': response['data']?['audio_url'],
          'duration': response['data']?['duration'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل توليد الصوت');
      }
    } catch (e) {
      debugPrint('[MbuyStudioService] Error generating audio: $e');
      rethrow;
    }
  }

  /// جلب القوالب الجاهزة
  /// 
  /// Parameters:
  /// - type: نوع القالب (video, image, audio)
  /// - category: الفئة (promotional, tutorial, etc.)
  /// 
  /// Returns: List of available templates
  static Future<List<Map<String, dynamic>>> getTemplates({
    String? type,
    String? category,
  }) async {
    try {
      debugPrint('[MbuyStudioService] Fetching templates');
      
      String queryString = '';
      if (type != null || category != null) {
        final params = <String>[];
        if (type != null) params.add('type=$type');
        if (category != null) params.add('category=$category');
        queryString = '?${params.join('&')}';
      }
      final response = await ApiService.get(
        '/public/mbuy-studio/templates$queryString',
        requireAuth: false,
      );

      if (response['ok'] == true) {
        return List<Map<String, dynamic>>.from(
          response['data']?['templates'] ?? [],
        );
      } else {
        throw Exception(response['message'] ?? 'فشل جلب القوالب');
      }
    } catch (e) {
      debugPrint('[MbuyStudioService] Error fetching templates: $e');
      rethrow;
    }
  }

  /// جلب حالة التوليد
  /// 
  /// Parameters:
  /// - jobId: معرف المهمة
  /// 
  /// Returns: Map with generation status
  static Future<Map<String, dynamic>> getGenerationStatus({
    required String jobId,
  }) async {
    try {
      debugPrint('[MbuyStudioService] Checking generation status: $jobId');
      
      final response = await ApiService.get(
        '/secure/mbuy-studio/status/$jobId',
      );

      if (response['ok'] == true) {
        return {
          'status': response['data']?['status'], // pending, processing, completed, failed
          'progress': response['data']?['progress'] ?? 0,
          'result_url': response['data']?['result_url'],
          'error': response['data']?['error'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل جلب حالة التوليد');
      }
    } catch (e) {
      debugPrint('[MbuyStudioService] Error checking generation status: $e');
      rethrow;
    }
  }
}

