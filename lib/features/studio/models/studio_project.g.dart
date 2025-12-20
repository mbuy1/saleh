// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductData _$ProductDataFromJson(Map<String, dynamic> json) => _ProductData(
  name: json['name'] as String?,
  nameAr: json['nameAr'] as String?,
  description: json['description'] as String?,
  descriptionAr: json['descriptionAr'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  features:
      (json['features'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$ProductDataToJson(_ProductData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nameAr': instance.nameAr,
      'description': instance.description,
      'descriptionAr': instance.descriptionAr,
      'price': instance.price,
      'currency': instance.currency,
      'images': instance.images,
      'features': instance.features,
    };

_ScriptData _$ScriptDataFromJson(Map<String, dynamic> json) => _ScriptData(
  title: json['title'] as String?,
  hook: json['hook'] as String?,
  headline: json['headline'] as String?,
  scenes:
      (json['scenes'] as List<dynamic>?)
          ?.map((e) => GeneratedScene.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  cta: json['cta'] as String?,
  language: json['language'] as String?,
);

Map<String, dynamic> _$ScriptDataToJson(_ScriptData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'hook': instance.hook,
      'headline': instance.headline,
      'scenes': instance.scenes,
      'cta': instance.cta,
      'language': instance.language,
    };

_GeneratedScene _$GeneratedSceneFromJson(Map<String, dynamic> json) =>
    _GeneratedScene(
      index: (json['index'] as num).toInt(),
      type: json['type'] as String,
      visualPrompt: json['visualPrompt'] as String?,
      narration: json['narration'] as String?,
      textOverlay: json['textOverlay'] as String?,
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 5000,
    );

Map<String, dynamic> _$GeneratedSceneToJson(_GeneratedScene instance) =>
    <String, dynamic>{
      'index': instance.index,
      'type': instance.type,
      'visualPrompt': instance.visualPrompt,
      'narration': instance.narration,
      'textOverlay': instance.textOverlay,
      'durationMs': instance.durationMs,
    };

_ProjectSettings _$ProjectSettingsFromJson(Map<String, dynamic> json) =>
    _ProjectSettings(
      aspectRatio:
          $enumDecodeNullable(_$AspectRatioEnumMap, json['aspectRatio']) ??
          AspectRatio.portrait,
      duration: (json['duration'] as num?)?.toInt() ?? 30,
      language: json['language'] as String? ?? 'ar',
      voiceId: json['voiceId'] as String?,
      musicId: json['musicId'] as String?,
      logoUrl: json['logoUrl'] as String?,
      brandColor: json['brandColor'] as String? ?? '#000000',
    );

Map<String, dynamic> _$ProjectSettingsToJson(_ProjectSettings instance) =>
    <String, dynamic>{
      'aspectRatio': _$AspectRatioEnumMap[instance.aspectRatio]!,
      'duration': instance.duration,
      'language': instance.language,
      'voiceId': instance.voiceId,
      'musicId': instance.musicId,
      'logoUrl': instance.logoUrl,
      'brandColor': instance.brandColor,
    };

const _$AspectRatioEnumMap = {
  AspectRatio.portrait: '9:16',
  AspectRatio.landscape: '16:9',
  AspectRatio.square: '1:1',
};

_StudioProject _$StudioProjectFromJson(Map<String, dynamic> json) =>
    _StudioProject(
      id: json['id'] as String,
      userId: json['userId'] as String,
      storeId: json['storeId'] as String?,
      templateId: json['templateId'] as String?,
      productId: json['productId'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      status:
          $enumDecodeNullable(_$ProjectStatusEnumMap, json['status']) ??
          ProjectStatus.draft,
      productData: json['productData'] == null
          ? const ProductData()
          : ProductData.fromJson(json['productData'] as Map<String, dynamic>),
      scriptData: json['scriptData'] == null
          ? const ScriptData()
          : ScriptData.fromJson(json['scriptData'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? const ProjectSettings()
          : ProjectSettings.fromJson(json['settings'] as Map<String, dynamic>),
      outputUrl: json['outputUrl'] as String?,
      outputThumbnailUrl: json['outputThumbnailUrl'] as String?,
      outputDuration: (json['outputDuration'] as num?)?.toInt(),
      outputSizeBytes: (json['outputSizeBytes'] as num?)?.toInt(),
      creditsUsed: (json['creditsUsed'] as num?)?.toInt() ?? 0,
      errorMessage: json['errorMessage'] as String?,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      scenesCount: (json['scenesCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StudioProjectToJson(_StudioProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'storeId': instance.storeId,
      'templateId': instance.templateId,
      'productId': instance.productId,
      'name': instance.name,
      'description': instance.description,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'productData': instance.productData,
      'scriptData': instance.scriptData,
      'settings': instance.settings,
      'outputUrl': instance.outputUrl,
      'outputThumbnailUrl': instance.outputThumbnailUrl,
      'outputDuration': instance.outputDuration,
      'outputSizeBytes': instance.outputSizeBytes,
      'creditsUsed': instance.creditsUsed,
      'errorMessage': instance.errorMessage,
      'progress': instance.progress,
      'thumbnailUrl': instance.thumbnailUrl,
      'scenesCount': instance.scenesCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ProjectStatusEnumMap = {
  ProjectStatus.draft: 'draft',
  ProjectStatus.generating: 'generating',
  ProjectStatus.processing: 'processing',
  ProjectStatus.rendering: 'rendering',
  ProjectStatus.ready: 'ready',
  ProjectStatus.completed: 'completed',
  ProjectStatus.failed: 'failed',
  ProjectStatus.error: 'error',
};
