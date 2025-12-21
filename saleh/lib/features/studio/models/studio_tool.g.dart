// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_tool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditToolDefinition _$EditToolDefinitionFromJson(Map<String, dynamic> json) =>
    _EditToolDefinition(
      id: $enumDecode(_$EditToolTypeEnumMap, json['id']),
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String,
      icon: json['icon'] as String,
      creditsCost: (json['creditsCost'] as num).toInt(),
      supportsImage: json['supportsImage'] as bool? ?? true,
      supportsVideo: json['supportsVideo'] as bool? ?? false,
    );

Map<String, dynamic> _$EditToolDefinitionToJson(_EditToolDefinition instance) =>
    <String, dynamic>{
      'id': _$EditToolTypeEnumMap[instance.id]!,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'description': instance.description,
      'descriptionAr': instance.descriptionAr,
      'icon': instance.icon,
      'creditsCost': instance.creditsCost,
      'supportsImage': instance.supportsImage,
      'supportsVideo': instance.supportsVideo,
    };

const _$EditToolTypeEnumMap = {
  EditToolType.removeBackground: 'remove_background',
  EditToolType.enhanceQuality: 'enhance_quality',
  EditToolType.resize: 'resize',
  EditToolType.crop: 'crop',
  EditToolType.addFilter: 'add_filter',
  EditToolType.addText: 'add_text',
  EditToolType.trimVideo: 'trim_video',
  EditToolType.mergeVideos: 'merge_videos',
  EditToolType.addMusic: 'add_music',
  EditToolType.addSubtitles: 'add_subtitles',
  EditToolType.extractAudio: 'extract_audio',
  EditToolType.videoToGif: 'video_to_gif',
};

_GenerateToolDefinition _$GenerateToolDefinitionFromJson(
  Map<String, dynamic> json,
) => _GenerateToolDefinition(
  id: $enumDecode(_$GenerateToolTypeEnumMap, json['id']),
  name: json['name'] as String,
  nameAr: json['nameAr'] as String,
  description: json['description'] as String,
  descriptionAr: json['descriptionAr'] as String,
  icon: json['icon'] as String,
  creditsCost: (json['creditsCost'] as num).toInt(),
  estimatedTimeSeconds: (json['estimatedTimeSeconds'] as num).toInt(),
);

Map<String, dynamic> _$GenerateToolDefinitionToJson(
  _GenerateToolDefinition instance,
) => <String, dynamic>{
  'id': _$GenerateToolTypeEnumMap[instance.id]!,
  'name': instance.name,
  'nameAr': instance.nameAr,
  'description': instance.description,
  'descriptionAr': instance.descriptionAr,
  'icon': instance.icon,
  'creditsCost': instance.creditsCost,
  'estimatedTimeSeconds': instance.estimatedTimeSeconds,
};

const _$GenerateToolTypeEnumMap = {
  GenerateToolType.templates: 'templates',
  GenerateToolType.productImages: 'product_images',
  GenerateToolType.landingPage: 'landing_page',
  GenerateToolType.banner: 'banner',
  GenerateToolType.animatedImage: 'animated_image',
  GenerateToolType.shortVideo: 'short_video',
  GenerateToolType.logo: 'logo',
};

_EditToolResult _$EditToolResultFromJson(Map<String, dynamic> json) =>
    _EditToolResult(
      success: json['success'] as bool,
      resultUrl: json['resultUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      processingTimeMs: (json['processingTimeMs'] as num).toInt(),
      creditsUsed: (json['creditsUsed'] as num).toInt(),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$EditToolResultToJson(_EditToolResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'resultUrl': instance.resultUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'fileSizeBytes': instance.fileSizeBytes,
      'processingTimeMs': instance.processingTimeMs,
      'creditsUsed': instance.creditsUsed,
      'error': instance.error,
    };

_GenerateToolResult _$GenerateToolResultFromJson(Map<String, dynamic> json) =>
    _GenerateToolResult(
      success: json['success'] as bool,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => GeneratedAsset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      creditsUsed: (json['creditsUsed'] as num).toInt(),
      processingTimeMs: (json['processingTimeMs'] as num).toInt(),
      jobId: json['jobId'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$GenerateToolResultToJson(_GenerateToolResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'results': instance.results,
      'creditsUsed': instance.creditsUsed,
      'processingTimeMs': instance.processingTimeMs,
      'jobId': instance.jobId,
      'error': instance.error,
    };

_GeneratedAsset _$GeneratedAssetFromJson(Map<String, dynamic> json) =>
    _GeneratedAsset(
      id: json['id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      type: json['type'] as String,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      durationMs: (json['durationMs'] as num?)?.toInt(),
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$GeneratedAssetToJson(_GeneratedAsset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'type': instance.type,
      'width': instance.width,
      'height': instance.height,
      'durationMs': instance.durationMs,
      'fileSizeBytes': instance.fileSizeBytes,
      'metadata': instance.metadata,
    };

_StudioAsset _$StudioAssetFromJson(Map<String, dynamic> json) => _StudioAsset(
  id: json['id'] as String,
  userId: json['userId'] as String,
  storeId: json['storeId'] as String?,
  projectId: json['projectId'] as String?,
  name: json['name'] as String?,
  assetType: json['assetType'] as String,
  source: json['source'] as String,
  url: json['url'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
  mimeType: json['mimeType'] as String?,
  durationMs: (json['durationMs'] as num?)?.toInt(),
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  aiPrompt: json['aiPrompt'] as String?,
  aiModel: json['aiModel'] as String?,
  aiCostCredits: (json['aiCostCredits'] as num?)?.toInt(),
  isFavorite: json['isFavorite'] as bool? ?? false,
  usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$StudioAssetToJson(_StudioAsset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'storeId': instance.storeId,
      'projectId': instance.projectId,
      'name': instance.name,
      'assetType': instance.assetType,
      'source': instance.source,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'fileSizeBytes': instance.fileSizeBytes,
      'mimeType': instance.mimeType,
      'durationMs': instance.durationMs,
      'width': instance.width,
      'height': instance.height,
      'aiPrompt': instance.aiPrompt,
      'aiModel': instance.aiModel,
      'aiCostCredits': instance.aiCostCredits,
      'isFavorite': instance.isFavorite,
      'usageCount': instance.usageCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
