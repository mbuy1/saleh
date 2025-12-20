// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Scene _$SceneFromJson(Map<String, dynamic> json) => _Scene(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
  sceneType:
      $enumDecodeNullable(_$SceneTypeEnumMap, json['sceneType']) ??
      SceneType.image,
  prompt: json['prompt'] as String?,
  imagePrompt: json['imagePrompt'] as String?,
  scriptText: json['scriptText'] as String?,
  durationMs: (json['durationMs'] as num?)?.toInt() ?? 5000,
  generatedImageUrl: json['generatedImageUrl'] as String?,
  generatedVideoUrl: json['generatedVideoUrl'] as String?,
  generatedAudioUrl: json['generatedAudioUrl'] as String?,
  status:
      $enumDecodeNullable(_$SceneStatusEnumMap, json['status']) ??
      SceneStatus.pending,
  errorMessage: json['errorMessage'] as String?,
  layers:
      (json['layers'] as List<dynamic>?)
          ?.map((e) => Layer.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  transitionIn:
      $enumDecodeNullable(_$TransitionTypeEnumMap, json['transitionIn']) ??
      TransitionType.fade,
  transitionOut:
      $enumDecodeNullable(_$TransitionTypeEnumMap, json['transitionOut']) ??
      TransitionType.fade,
  textOverlay: json['textOverlay'] as String?,
  narration: json['narration'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SceneToJson(_Scene instance) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'orderIndex': instance.orderIndex,
  'sceneType': _$SceneTypeEnumMap[instance.sceneType]!,
  'prompt': instance.prompt,
  'imagePrompt': instance.imagePrompt,
  'scriptText': instance.scriptText,
  'durationMs': instance.durationMs,
  'generatedImageUrl': instance.generatedImageUrl,
  'generatedVideoUrl': instance.generatedVideoUrl,
  'generatedAudioUrl': instance.generatedAudioUrl,
  'status': _$SceneStatusEnumMap[instance.status]!,
  'errorMessage': instance.errorMessage,
  'layers': instance.layers,
  'transitionIn': _$TransitionTypeEnumMap[instance.transitionIn]!,
  'transitionOut': _$TransitionTypeEnumMap[instance.transitionOut]!,
  'textOverlay': instance.textOverlay,
  'narration': instance.narration,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
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

const _$SceneStatusEnumMap = {
  SceneStatus.draft: 'draft',
  SceneStatus.pending: 'pending',
  SceneStatus.generating: 'generating',
  SceneStatus.ready: 'ready',
  SceneStatus.failed: 'failed',
  SceneStatus.error: 'error',
};

const _$TransitionTypeEnumMap = {
  TransitionType.fade: 'fade',
  TransitionType.slideLeft: 'slide_left',
  TransitionType.slideRight: 'slide_right',
  TransitionType.zoom: 'zoom',
  TransitionType.none: 'none',
};
