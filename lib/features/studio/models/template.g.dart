// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SceneConfig _$SceneConfigFromJson(Map<String, dynamic> json) => _SceneConfig(
  type:
      $enumDecodeNullable(_$SceneTypeEnumMap, json['type']) ?? SceneType.image,
  duration: (json['duration'] as num?)?.toInt() ?? 5000,
  prompt: json['prompt'] as String? ?? '',
);

Map<String, dynamic> _$SceneConfigToJson(_SceneConfig instance) =>
    <String, dynamic>{
      'type': _$SceneTypeEnumMap[instance.type]!,
      'duration': instance.duration,
      'prompt': instance.prompt,
    };

const _$SceneTypeEnumMap = {
  SceneType.intro: 'intro',
  SceneType.image: 'image',
  SceneType.video: 'video',
  SceneType.ugc: 'ugc',
  SceneType.text: 'text',
  SceneType.transition: 'transition',
  SceneType.cta: 'cta',
  SceneType.product: 'product',
  SceneType.features: 'features',
  SceneType.outro: 'outro',
};

_StudioTemplate _$StudioTemplateFromJson(Map<String, dynamic> json) =>
    _StudioTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      category:
          $enumDecodeNullable(_$TemplateCategoryEnumMap, json['category']) ??
          TemplateCategory.productAd,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      previewVideoUrl: json['previewVideoUrl'] as String?,
      scenesConfig:
          (json['scenesConfig'] as List<dynamic>?)
              ?.map((e) => SceneConfig.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 30,
      aspectRatio: json['aspectRatio'] as String? ?? '9:16',
      isPremium: json['isPremium'] as bool? ?? false,
      isPro: json['isPro'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
      creditsCost: (json['creditsCost'] as num?)?.toInt() ?? 10,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StudioTemplateToJson(_StudioTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'description': instance.description,
      'descriptionAr': instance.descriptionAr,
      'category': _$TemplateCategoryEnumMap[instance.category]!,
      'thumbnailUrl': instance.thumbnailUrl,
      'previewVideoUrl': instance.previewVideoUrl,
      'scenesConfig': instance.scenesConfig,
      'durationSeconds': instance.durationSeconds,
      'aspectRatio': instance.aspectRatio,
      'isPremium': instance.isPremium,
      'isPro': instance.isPro,
      'isActive': instance.isActive,
      'usageCount': instance.usageCount,
      'creditsCost': instance.creditsCost,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TemplateCategoryEnumMap = {
  TemplateCategory.productAd: 'product_ad',
  TemplateCategory.ugc: 'ugc',
  TemplateCategory.promo: 'promo',
  TemplateCategory.story: 'story',
};
