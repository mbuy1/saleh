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

  // =====================================================
  // Edit Tools - أدوات التحرير
  // =====================================================

  /// إزالة الخلفية
  Future<({String resultUrl, int creditsUsed})> removeBackground({
    required String imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/edit/remove-background'),
      headers: _headers,
      body: jsonEncode({'imageUrl': imageUrl}),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(3, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في إزالة الخلفية', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      resultUrl: data['resultUrl'] as String,
      creditsUsed: (data['creditsUsed'] ?? 3) as int,
    );
  }

  /// تحسين جودة الصورة
  Future<({String resultUrl, int creditsUsed})> enhanceImage({
    required String imageUrl,
    String enhanceType = 'general',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/edit/enhance-quality'),
      headers: _headers,
      body: jsonEncode({'imageUrl': imageUrl, 'enhanceType': enhanceType}),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(2, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في تحسين الصورة', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      resultUrl: data['resultUrl'] as String,
      creditsUsed: (data['creditsUsed'] ?? 2) as int,
    );
  }

  /// تغيير حجم الصورة
  Future<({String resultUrl, int creditsUsed})> resizeImage({
    required String imageUrl,
    required int width,
    required int height,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/edit/resize'),
      headers: _headers,
      body: jsonEncode({
        'imageUrl': imageUrl,
        'width': width,
        'height': height,
      }),
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في تغيير الحجم', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      resultUrl: data['resultUrl'] as String,
      creditsUsed: (data['creditsUsed'] ?? 1) as int,
    );
  }

  /// قص الفيديو
  Future<({String jobId, int creditsUsed})> trimVideo({
    required String videoUrl,
    required int startMs,
    required int endMs,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/edit/trim-video'),
      headers: _headers,
      body: jsonEncode({
        'videoUrl': videoUrl,
        'startMs': startMs,
        'endMs': endMs,
      }),
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في قص الفيديو', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      jobId: data['jobId'] as String,
      creditsUsed: (data['creditsUsed'] ?? 2) as int,
    );
  }

  /// دمج فيديوهات
  Future<({String jobId, int creditsUsed})> mergeVideos({
    required List<String> videoUrls,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/edit/merge-videos'),
      headers: _headers,
      body: jsonEncode({'videoUrls': videoUrls}),
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في دمج الفيديوهات', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      jobId: data['jobId'] as String,
      creditsUsed: (data['creditsUsed'] ?? 3) as int,
    );
  }

  /// إضافة موسيقى
  Future<({String jobId, int creditsUsed})> addMusic({
    required String videoUrl,
    required String audioUrl,
    double volume = 0.5,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/edit/add-music'),
      headers: _headers,
      body: jsonEncode({
        'videoUrl': videoUrl,
        'audioUrl': audioUrl,
        'volume': volume,
      }),
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في إضافة الموسيقى', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      jobId: data['jobId'] as String,
      creditsUsed: (data['creditsUsed'] ?? 2) as int,
    );
  }

  /// إضافة ترجمة
  Future<({String jobId, int creditsUsed})> addSubtitles({
    required String videoUrl,
    required String subtitlesText,
    String fontColor = '#FFFFFF',
    int fontSize = 24,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/edit/add-subtitles'),
      headers: _headers,
      body: jsonEncode({
        'videoUrl': videoUrl,
        'subtitlesText': subtitlesText,
        'fontColor': fontColor,
        'fontSize': fontSize,
      }),
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في إضافة الترجمة', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      jobId: data['jobId'] as String,
      creditsUsed: (data['creditsUsed'] ?? 2) as int,
    );
  }

  /// تحويل فيديو إلى GIF
  Future<({String jobId, int creditsUsed})> videoToGif({
    required String videoUrl,
    int fps = 15,
    int width = 480,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/edit/video-to-gif'),
      headers: _headers,
      body: jsonEncode({'videoUrl': videoUrl, 'fps': fps, 'width': width}),
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في التحويل', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      jobId: data['jobId'] as String,
      creditsUsed: (data['creditsUsed'] ?? 1) as int,
    );
  }

  // =====================================================
  // Generate Tools - أدوات الإنشاء
  // =====================================================

  /// إنشاء صور منتج
  Future<({List<String> imageUrls, int creditsUsed})> generateProductImages({
    required String productName,
    required String productDescription,
    String style = 'modern',
    int count = 4,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/generate/product-images'),
      headers: _headers,
      body: jsonEncode({
        'productName': productName,
        'productDescription': productDescription,
        'style': style,
        'count': count,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(8, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في إنشاء الصور', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      creditsUsed: (data['creditsUsed'] ?? 8) as int,
    );
  }

  /// إنشاء بانر
  Future<({String imageUrl, int creditsUsed})> generateBanner({
    required String title,
    String? subtitle,
    String style = 'modern',
    String size = '1200x628',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/generate/banner'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'subtitle': subtitle,
        'style': style,
        'size': size,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(3, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في إنشاء البانر', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      imageUrl: data['imageUrl'] as String,
      creditsUsed: (data['creditsUsed'] ?? 3) as int,
    );
  }

  /// إنشاء شعار
  Future<({List<String> logoUrls, int creditsUsed})> generateLogo({
    required String brandName,
    String? brandDescription,
    String style = 'modern',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/generate/logo'),
      headers: _headers,
      body: jsonEncode({
        'brandName': brandName,
        'brandDescription': brandDescription,
        'style': style,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(10, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في إنشاء الشعار', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      logoUrls: List<String>.from(data['logoUrls'] ?? []),
      creditsUsed: (data['creditsUsed'] ?? 10) as int,
    );
  }

  /// إنشاء صورة متحركة
  Future<({String videoUrl, int creditsUsed})> generateAnimatedImage({
    required String imageUrl,
    String motionType = 'zoom',
    int durationMs = 3000,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/generate/animated-image'),
      headers: _headers,
      body: jsonEncode({
        'imageUrl': imageUrl,
        'motionType': motionType,
        'durationMs': durationMs,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(5, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في إنشاء الصورة المتحركة', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      videoUrl: data['videoUrl'] as String,
      creditsUsed: (data['creditsUsed'] ?? 5) as int,
    );
  }

  /// إنشاء فيديو قصير
  Future<({String jobId, int creditsUsed})> generateShortVideo({
    required String prompt,
    int durationSeconds = 5,
    String aspectRatio = '9:16',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/generate/short-video'),
      headers: _headers,
      body: jsonEncode({
        'prompt': prompt,
        'durationSeconds': durationSeconds,
        'aspectRatio': aspectRatio,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(15, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في إنشاء الفيديو', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      jobId: data['jobId'] as String,
      creditsUsed: (data['creditsUsed'] ?? 15) as int,
    );
  }

  /// إنشاء صفحة هبوط
  Future<({String htmlContent, String previewUrl, int creditsUsed})>
  generateLandingPage({
    required String productName,
    required String productDescription,
    String? productImageUrl,
    String template = 'modern',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/tools/generate/landing-page'),
      headers: _headers,
      body: jsonEncode({
        'productName': productName,
        'productDescription': productDescription,
        'productImageUrl': productImageUrl,
        'template': template,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(20, 0);
    }

    if (response.statusCode != 200) {
      throw ApiException('فشل في إنشاء صفحة الهبوط', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      htmlContent: data['htmlContent'] as String,
      previewUrl: data['previewUrl'] as String,
      creditsUsed: (data['creditsUsed'] ?? 20) as int,
    );
  }

  // =====================================================
  // Packages - الباقات
  // =====================================================

  /// الحصول على تعريفات الباقات
  Future<List<Map<String, dynamic>>> getPackageDefinitions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/secure/studio/packages/definitions'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في جلب الباقات', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['packages'] ?? []);
  }

  /// طلب باقة
  Future<({String orderId, int creditsUsed})> orderPackage({
    required String packageType,
    required Map<String, dynamic> productData,
    Map<String, dynamic>? brandData,
    Map<String, dynamic>? preferences,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/packages/orders'),
      headers: _headers,
      body: jsonEncode({
        'packageType': packageType,
        'productData': productData,
        'brandData': brandData,
        'preferences': preferences,
      }),
    );

    if (response.statusCode == 402) {
      throw InsufficientCreditsException(50, 0);
    }

    if (response.statusCode != 201) {
      throw ApiException('فشل في طلب الباقة', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      orderId: data['orderId'] as String,
      creditsUsed: (data['creditsUsed'] ?? 50) as int,
    );
  }

  /// الحصول على حالة طلب باقة
  Future<Map<String, dynamic>> getPackageOrderStatus(String orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/secure/studio/packages/orders/$orderId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في جلب حالة الطلب', response.statusCode);
    }

    return jsonDecode(response.body);
  }

  /// الحصول على طلبات الباقات
  Future<List<Map<String, dynamic>>> getPackageOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/secure/studio/packages/orders'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في جلب الطلبات', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['orders'] ?? []);
  }

  /// تطبيق مخرجات الباقة على المتجر
  Future<void> applyPackageToStore(String orderId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/secure/studio/packages/orders/$orderId/apply'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في تطبيق الباقة', response.statusCode);
    }
  }

  // =====================================================
  // Job Status - حالة المهام
  // =====================================================

  /// التحقق من حالة مهمة
  Future<({String status, String? resultUrl, String? error})> getJobStatus(
    String jobId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/secure/studio/jobs/$jobId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('فشل في جلب حالة المهمة', response.statusCode);
    }

    final data = jsonDecode(response.body);
    return (
      status: data['status'] as String,
      resultUrl: data['resultUrl'] as String?,
      error: data['error'] as String?,
    );
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
