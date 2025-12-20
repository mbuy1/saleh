import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// خدمة API للاستوديو
class StudioApiService {
  final String baseUrl;
  final String Function() getAuthToken;

  StudioApiService({required this.baseUrl, required this.getAuthToken});

  /// الحصول على headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${getAuthToken()}',
  };

  // =====================================================
  // Credits
  // =====================================================

  /// الحصول على رصيد المستخدم
  Future<UserCredits> getCredits() async {
    final response = await http.get(
      Uri.parse('$baseUrl/studio/credits'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في جلب الرصيد', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return UserCredits.fromJson({
      'id': '',
      'userId': '',
      'balance': data['balance'],
      'totalEarned': data['total_earned'],
      'totalSpent': data['total_spent'],
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // =====================================================
  // Templates
  // =====================================================

  /// الحصول على القوالب
  Future<List<StudioTemplate>> getTemplates({String? category}) async {
    var url = '$baseUrl/studio/templates';
    if (category != null) {
      url += '?category=$category';
    }

    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode != 200) {
      throw ApiException('فشل في جلب القوالب', response.statusCode);
    }

    final data = jsonDecode(response.body);
    final templates = (data['templates'] as List)
        .map((t) => StudioTemplate.fromJson(_normalizeTemplate(t)))
        .toList();

    return templates;
  }

  /// الحصول على قالب محدد
  Future<StudioTemplate> getTemplate(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/studio/templates/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('القالب غير موجود', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return StudioTemplate.fromJson(_normalizeTemplate(data['template']));
  }

  // =====================================================
  // Projects
  // =====================================================

  /// إنشاء مشروع جديد
  Future<StudioProject> createProject({
    required String name,
    String? templateId,
    String? productId,
    ProductData? productData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/studio/projects'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'template_id': templateId,
        'product_id': productId,
        'product_data': productData?.toJson(),
      }),
    );

    if (response.statusCode != 201) {
      throw ApiException('فشل في إنشاء المشروع', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return StudioProject.fromJson(_normalizeProject(data['project']));
  }

  /// الحصول على مشاريع المستخدم
  Future<List<StudioProject>> getProjects({String? status}) async {
    var url = '$baseUrl/studio/projects';
    if (status != null) {
      url += '?status=$status';
    }

    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode != 200) {
      throw ApiException('فشل في جلب المشاريع', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (data['projects'] as List)
        .map((p) => StudioProject.fromJson(_normalizeProject(p)))
        .toList();
  }

  /// الحصول على مشروع مع المشاهد
  Future<({StudioProject project, List<Scene> scenes})> getProject(
    String id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/studio/projects/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('المشروع غير موجود', response.statusCode);
    }

    final data = jsonDecode(response.body);
    final project = StudioProject.fromJson(_normalizeProject(data['project']));
    final scenes = (data['scenes'] as List)
        .map((s) => Scene.fromJson(_normalizeScene(s)))
        .toList();

    return (project: project, scenes: scenes);
  }

  /// تحديث مشروع
  Future<StudioProject> updateProject(
    String id, {
    String? name,
    ProjectSettings? settings,
    ScriptData? scriptData,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/studio/projects/$id'),
      headers: _headers,
      body: jsonEncode({
        if (name != null) 'name': name,
        if (settings != null) 'settings': settings.toJson(),
        if (scriptData != null) 'script_data': scriptData.toJson(),
      }),
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في تحديث المشروع', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return StudioProject.fromJson(_normalizeProject(data['project']));
  }

  /// حذف مشروع
  Future<void> deleteProject(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/studio/projects/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في حذف المشروع', response.statusCode);
    }
  }

  // =====================================================
  // AI Generation
  // =====================================================

  /// توليد سيناريو
  Future<({ScriptData script, int creditsUsed})> generateScript({
    required ProductData productData,
    String? templateId,
    String language = 'ar',
    String tone = 'professional',
    int durationSeconds = 30,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/studio/generate/script'),
      headers: _headers,
      body: jsonEncode({
        'product_data': productData.toJson(),
        'template_id': templateId,
        'language': language,
        'tone': tone,
        'duration_seconds': durationSeconds,
      }),
    );

    if (response.statusCode == 402) {
      final data = jsonDecode(response.body);
      throw InsufficientCreditsException(
        data['required'] ?? 5,
        data['balance'] ?? 0,
      );
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في توليد السيناريو', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      script: ScriptData.fromJson(data['script']),
      creditsUsed: (data['credits_used'] ?? 0) as int,
    );
  }

  /// توليد صورة
  Future<({String imageUrl, int creditsUsed})> generateImage({
    required String prompt,
    String? style,
    String aspectRatio = '9:16',
    String? projectId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/studio/generate/image'),
      headers: _headers,
      body: jsonEncode({
        'prompt': prompt,
        'style': style,
        'aspect_ratio': aspectRatio,
        'project_id': projectId,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(2, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في توليد الصورة', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      imageUrl: data['image_url'] as String,
      creditsUsed: (data['credits_used'] ?? 2) as int,
    );
  }

  /// توليد صوت
  Future<({String audioUrl, int durationMs, int creditsUsed})> generateVoice({
    required String text,
    String? voiceId,
    String language = 'ar',
    String? projectId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/studio/generate/voice'),
      headers: _headers,
      body: jsonEncode({
        'text': text,
        'voice_id': voiceId,
        'language': language,
        'project_id': projectId,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(1, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في توليد الصوت', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      audioUrl: data['audio_url'] as String,
      durationMs: (data['duration_ms'] ?? 0) as int,
      creditsUsed: (data['credits_used'] ?? 1) as int,
    );
  }

  /// توليد فيديو UGC
  Future<({String talkId, int creditsUsed})> generateUGC({
    required String script,
    String? avatarId,
    String? voiceId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/studio/generate/ugc'),
      headers: _headers,
      body: jsonEncode({
        'script': script,
        'avatar_id': avatarId,
        'voice_id': voiceId,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(10, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في توليد الفيديو', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      talkId: data['talk_id'] as String,
      creditsUsed: (data['credits_used'] ?? 10) as int,
    );
  }

  /// التحقق من حالة فيديو UGC
  Future<({String status, String? resultUrl})> getUGCStatus(
    String talkId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/studio/generate/ugc/$talkId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في جلب حالة الفيديو', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      status: data['status'] as String,
      resultUrl: data['result_url'] as String?,
    );
  }

  // =====================================================
  // Scenes
  // =====================================================

  /// إضافة مشاهد للمشروع
  Future<List<Scene>> addScenes(String projectId, List<Scene> scenes) async {
    final response = await http.post(
      Uri.parse('$baseUrl/studio/projects/$projectId/scenes'),
      headers: _headers,
      body: jsonEncode(scenes.map((s) => s.toJson()).toList()),
    );

    if (response.statusCode != 201) {
      throw ApiException('فشل في إضافة المشاهد', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (data['scenes'] as List)
        .map((s) => Scene.fromJson(_normalizeScene(s)))
        .toList();
  }

  /// تحديث مشهد
  Future<Scene> updateScene(
    String sceneId,
    Map<String, dynamic> updates,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/studio/scenes/$sceneId'),
      headers: _headers,
      body: jsonEncode(updates),
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في تحديث المشهد', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return Scene.fromJson(_normalizeScene(data['scene']));
  }

  // =====================================================
  // Render
  // =====================================================

  /// بدء الرندر
  Future<({String renderId, RenderManifest manifest, int creditsCost})>
  startRender({
    required String projectId,
    String quality = 'medium',
    String format = 'mp4',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/studio/render'),
      headers: _headers,
      body: jsonEncode({
        'project_id': projectId,
        'quality': quality,
        'format': format,
      }),
    );

    if (response.statusCode == 402) {
      final data = jsonDecode(response.body);
      throw InsufficientCreditsException(
        data['required'] ?? 10,
        data['balance'] ?? 0,
      );
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في بدء الرندر', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      renderId: data['render_id'] as String,
      manifest: RenderManifest.fromJson(data['manifest']),
      creditsCost: (data['credits_cost'] ?? 10) as int,
    );
  }

  /// إكمال الرندر
  Future<void> completeRender(
    String renderId, {
    required String status,
    String? outputUrl,
    int? outputSizeBytes,
    String? errorMessage,
  }) async {
    await http.patch(
      Uri.parse('$baseUrl/studio/render/$renderId/complete'),
      headers: _headers,
      body: jsonEncode({
        'status': status,
        'output_url': outputUrl,
        'output_size_bytes': outputSizeBytes,
        'error_message': errorMessage,
      }),
    );
  }

  // =====================================================
  // Voices & Avatars
  // =====================================================

  /// الحصول على الأصوات المتاحة
  Future<List<Map<String, dynamic>>> getVoices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/studio/voices'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['recommended'] ?? []);
  }

  /// الحصول على الأفاتارات
  Future<List<Map<String, dynamic>>> getAvatars() async {
    final response = await http.get(
      Uri.parse('$baseUrl/studio/avatars'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['avatars'] ?? []);
  }

  // =====================================================
  // Helpers
  // =====================================================

  Map<String, dynamic> _normalizeProject(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'userId': data['user_id'],
      'storeId': data['store_id'],
      'templateId': data['template_id'],
      'productId': data['product_id'],
      'name': data['name'],
      'description': data['description'],
      'status': data['status'],
      'productData': data['product_data'] ?? {},
      'scriptData': data['script_data'] ?? {},
      'settings': data['settings'] ?? {},
      'outputUrl': data['output_url'],
      'outputThumbnailUrl': data['output_thumbnail_url'],
      'outputDuration': data['output_duration'],
      'outputSizeBytes': data['output_size_bytes'],
      'creditsUsed': data['credits_used'] ?? 0,
      'errorMessage': data['error_message'],
      'progress': data['progress'] ?? 0,
      'createdAt': data['created_at'],
      'updatedAt': data['updated_at'],
    };
  }

  Map<String, dynamic> _normalizeScene(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'projectId': data['project_id'],
      'orderIndex': data['order_index'] ?? 0,
      'sceneType': data['scene_type'] ?? 'image',
      'prompt': data['prompt'],
      'scriptText': data['script_text'],
      'durationMs': data['duration_ms'] ?? 5000,
      'generatedImageUrl': data['generated_image_url'],
      'generatedVideoUrl': data['generated_video_url'],
      'generatedAudioUrl': data['generated_audio_url'],
      'status': data['status'] ?? 'pending',
      'errorMessage': data['error_message'],
      'layers': data['layers'] ?? [],
      'transitionIn': data['transition_in'] ?? 'fade',
      'transitionOut': data['transition_out'] ?? 'fade',
      'createdAt': data['created_at'],
      'updatedAt': data['updated_at'],
    };
  }

  Map<String, dynamic> _normalizeTemplate(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'name': data['name'],
      'nameAr': data['name_ar'],
      'description': data['description'],
      'descriptionAr': data['description_ar'],
      'category': data['category'] ?? 'product_ad',
      'thumbnailUrl': data['thumbnail_url'],
      'previewVideoUrl': data['preview_video_url'],
      'scenesConfig': data['scenes_config'] ?? [],
      'durationSeconds': data['duration_seconds'] ?? 30,
      'aspectRatio': data['aspect_ratio'] ?? '9:16',
      'isPremium': data['is_premium'] ?? false,
      'isActive': data['is_active'] ?? true,
      'usageCount': data['usage_count'] ?? 0,
      'creditsCost': data['credits_cost'] ?? 10,
      'tags': data['tags'] ?? [],
      'createdAt': data['created_at'],
      'updatedAt': data['updated_at'],
    };
  }
}

/// استثناء API
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// استثناء نقص الرصيد
class InsufficientCreditsException implements Exception {
  final int required;
  final int balance;

  InsufficientCreditsException(this.required, this.balance);

  @override
  String toString() => 'رصيدك غير كافي. مطلوب: $required، المتوفر: $balance';
}
