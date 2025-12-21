import 'package:freezed_annotation/freezed_annotation.dart';

part 'studio_tool.freezed.dart';
part 'studio_tool.g.dart';

/// أنواع أدوات التحرير
enum EditToolType {
  @JsonValue('remove_background')
  removeBackground,
  @JsonValue('enhance_quality')
  enhanceQuality,
  @JsonValue('resize')
  resize,
  @JsonValue('crop')
  crop,
  @JsonValue('add_filter')
  addFilter,
  @JsonValue('add_text')
  addText,
  @JsonValue('trim_video')
  trimVideo,
  @JsonValue('merge_videos')
  mergeVideos,
  @JsonValue('add_music')
  addMusic,
  @JsonValue('add_subtitles')
  addSubtitles,
  @JsonValue('extract_audio')
  extractAudio,
  @JsonValue('video_to_gif')
  videoToGif,
}

/// أنواع أدوات التوليد
enum GenerateToolType {
  @JsonValue('templates')
  templates,
  @JsonValue('product_images')
  productImages,
  @JsonValue('landing_page')
  landingPage,
  @JsonValue('banner')
  banner,
  @JsonValue('animated_image')
  animatedImage,
  @JsonValue('short_video')
  shortVideo,
  @JsonValue('logo')
  logo,
}

/// تعريف أداة التحرير
@freezed
abstract class EditToolDefinition with _$EditToolDefinition {
  const factory EditToolDefinition({
    required EditToolType id,
    required String name,
    required String nameAr,
    required String description,
    required String descriptionAr,
    required String icon,
    required int creditsCost,
    @Default(true) bool supportsImage,
    @Default(false) bool supportsVideo,
  }) = _EditToolDefinition;

  factory EditToolDefinition.fromJson(Map<String, dynamic> json) =>
      _$EditToolDefinitionFromJson(json);
}

/// تعريف أداة التوليد
@freezed
abstract class GenerateToolDefinition with _$GenerateToolDefinition {
  const factory GenerateToolDefinition({
    required GenerateToolType id,
    required String name,
    required String nameAr,
    required String description,
    required String descriptionAr,
    required String icon,
    required int creditsCost,
    required int estimatedTimeSeconds,
  }) = _GenerateToolDefinition;

  factory GenerateToolDefinition.fromJson(Map<String, dynamic> json) =>
      _$GenerateToolDefinitionFromJson(json);
}

/// نتيجة أداة التحرير
@freezed
abstract class EditToolResult with _$EditToolResult {
  const factory EditToolResult({
    required bool success,
    required String resultUrl,
    String? thumbnailUrl,
    int? fileSizeBytes,
    required int processingTimeMs,
    required int creditsUsed,
    String? error,
  }) = _EditToolResult;

  factory EditToolResult.fromJson(Map<String, dynamic> json) =>
      _$EditToolResultFromJson(json);
}

/// نتيجة أداة التوليد
@freezed
abstract class GenerateToolResult with _$GenerateToolResult {
  const factory GenerateToolResult({
    required bool success,
    @Default([]) List<GeneratedAsset> results,
    required int creditsUsed,
    required int processingTimeMs,
    String? jobId,
    String? error,
  }) = _GenerateToolResult;

  factory GenerateToolResult.fromJson(Map<String, dynamic> json) =>
      _$GenerateToolResultFromJson(json);
}

/// أصل مُنشأ
@freezed
abstract class GeneratedAsset with _$GeneratedAsset {
  const factory GeneratedAsset({
    required String id,
    required String url,
    String? thumbnailUrl,
    required String type,
    int? width,
    int? height,
    int? durationMs,
    int? fileSizeBytes,
    Map<String, dynamic>? metadata,
  }) = _GeneratedAsset;

  factory GeneratedAsset.fromJson(Map<String, dynamic> json) =>
      _$GeneratedAssetFromJson(json);
}

/// أصل محفوظ
@freezed
abstract class StudioAsset with _$StudioAsset {
  const factory StudioAsset({
    required String id,
    required String userId,
    String? storeId,
    String? projectId,
    String? name,
    required String assetType,
    required String source,
    required String url,
    String? thumbnailUrl,
    int? fileSizeBytes,
    String? mimeType,
    int? durationMs,
    int? width,
    int? height,
    String? aiPrompt,
    String? aiModel,
    int? aiCostCredits,
    @Default(false) bool isFavorite,
    @Default(0) int usageCount,
    required DateTime createdAt,
  }) = _StudioAsset;

  factory StudioAsset.fromJson(Map<String, dynamic> json) =>
      _$StudioAssetFromJson(json);
}

/// الأدوات الافتراضية للتحرير
List<EditToolDefinition> getDefaultEditTools() => const [
  EditToolDefinition(
    id: EditToolType.removeBackground,
    name: 'Remove Background',
    nameAr: 'إزالة الخلفية',
    description: 'Remove background from images',
    descriptionAr: 'إزالة الخلفية من الصور',
    icon: 'content_cut',
    creditsCost: 1,
    supportsImage: true,
    supportsVideo: false,
  ),
  EditToolDefinition(
    id: EditToolType.enhanceQuality,
    name: 'Enhance Quality',
    nameAr: 'تحسين الجودة',
    description: 'Improve image or video quality',
    descriptionAr: 'تحسين جودة الصورة أو الفيديو',
    icon: 'auto_fix_high',
    creditsCost: 2,
    supportsImage: true,
    supportsVideo: true,
  ),
  EditToolDefinition(
    id: EditToolType.resize,
    name: 'Resize',
    nameAr: 'تغيير الحجم',
    description: 'Resize image or video',
    descriptionAr: 'تغيير حجم الصورة أو الفيديو',
    icon: 'aspect_ratio',
    creditsCost: 1,
    supportsImage: true,
    supportsVideo: true,
  ),
  EditToolDefinition(
    id: EditToolType.addFilter,
    name: 'Add Filter',
    nameAr: 'إضافة فلتر',
    description: 'Apply visual filters',
    descriptionAr: 'تطبيق فلاتر بصرية',
    icon: 'filter_vintage',
    creditsCost: 1,
    supportsImage: true,
    supportsVideo: true,
  ),
  EditToolDefinition(
    id: EditToolType.trimVideo,
    name: 'Trim Video',
    nameAr: 'قص الفيديو',
    description: 'Cut video to specific duration',
    descriptionAr: 'قص الفيديو لمدة محددة',
    icon: 'content_cut',
    creditsCost: 1,
    supportsImage: false,
    supportsVideo: true,
  ),
  EditToolDefinition(
    id: EditToolType.mergeVideos,
    name: 'Merge Videos',
    nameAr: 'دمج الفيديوهات',
    description: 'Combine multiple videos',
    descriptionAr: 'دمج عدة فيديوهات معاً',
    icon: 'merge',
    creditsCost: 3,
    supportsImage: false,
    supportsVideo: true,
  ),
  EditToolDefinition(
    id: EditToolType.addMusic,
    name: 'Add Music',
    nameAr: 'إضافة موسيقى',
    description: 'Add background music to video',
    descriptionAr: 'إضافة موسيقى خلفية للفيديو',
    icon: 'music_note',
    creditsCost: 2,
    supportsImage: false,
    supportsVideo: true,
  ),
  EditToolDefinition(
    id: EditToolType.addSubtitles,
    name: 'Add Subtitles',
    nameAr: 'إضافة ترجمة',
    description: 'Add subtitles to video',
    descriptionAr: 'إضافة ترجمة للفيديو',
    icon: 'subtitles',
    creditsCost: 3,
    supportsImage: false,
    supportsVideo: true,
  ),
  EditToolDefinition(
    id: EditToolType.videoToGif,
    name: 'Video to GIF',
    nameAr: 'فيديو إلى GIF',
    description: 'Convert video to animated GIF',
    descriptionAr: 'تحويل الفيديو إلى GIF متحرك',
    icon: 'gif',
    creditsCost: 2,
    supportsImage: false,
    supportsVideo: true,
  ),
];

/// الأدوات الافتراضية للتوليد
List<GenerateToolDefinition> getDefaultGenerateTools() => const [
  GenerateToolDefinition(
    id: GenerateToolType.templates,
    name: 'Templates',
    nameAr: 'قوالب جاهزة',
    description: 'Ready-to-use design templates',
    descriptionAr: 'قوالب تصميم جاهزة للاستخدام',
    icon: 'dashboard',
    creditsCost: 0,
    estimatedTimeSeconds: 5,
  ),
  GenerateToolDefinition(
    id: GenerateToolType.productImages,
    name: 'Product Images',
    nameAr: 'صور المنتجات',
    description: 'Generate professional product photos',
    descriptionAr: 'توليد صور احترافية للمنتجات',
    icon: 'shopping_bag',
    creditsCost: 3,
    estimatedTimeSeconds: 30,
  ),
  GenerateToolDefinition(
    id: GenerateToolType.landingPage,
    name: 'Landing Page',
    nameAr: 'صفحة هبوط',
    description: 'Generate product landing page',
    descriptionAr: 'توليد صفحة هبوط للمنتج',
    icon: 'web',
    creditsCost: 10,
    estimatedTimeSeconds: 60,
  ),
  GenerateToolDefinition(
    id: GenerateToolType.banner,
    name: 'Banner',
    nameAr: 'بانر',
    description: 'Generate promotional banners',
    descriptionAr: 'توليد بانرات ترويجية',
    icon: 'image',
    creditsCost: 2,
    estimatedTimeSeconds: 15,
  ),
  GenerateToolDefinition(
    id: GenerateToolType.animatedImage,
    name: 'Animated Image',
    nameAr: 'صور متحركة',
    description: 'Create animated GIFs and images',
    descriptionAr: 'إنشاء صور متحركة وGIF',
    icon: 'gif',
    creditsCost: 3,
    estimatedTimeSeconds: 20,
  ),
  GenerateToolDefinition(
    id: GenerateToolType.shortVideo,
    name: 'Short Video',
    nameAr: 'فيديو قصير',
    description: 'Generate short product videos',
    descriptionAr: 'توليد فيديوهات قصيرة للمنتجات',
    icon: 'videocam',
    creditsCost: 8,
    estimatedTimeSeconds: 45,
  ),
  GenerateToolDefinition(
    id: GenerateToolType.logo,
    name: 'Logo',
    nameAr: 'شعار',
    description: 'Generate brand logos',
    descriptionAr: 'توليد شعارات للعلامة التجارية',
    icon: 'star',
    creditsCost: 5,
    estimatedTimeSeconds: 25,
  ),
];
