// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'render_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RenderJob _$RenderJobFromJson(Map<String, dynamic> json) => _RenderJob(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  userId: json['userId'] as String,
  status:
      $enumDecodeNullable(_$RenderStatusEnumMap, json['status']) ??
      RenderStatus.queued,
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  format: json['format'] as String? ?? 'mp4',
  resolution: json['resolution'] as String? ?? '1080p',
  quality: json['quality'] as String? ?? 'medium',
  outputUrl: json['outputUrl'] as String?,
  outputSizeBytes: (json['outputSizeBytes'] as num?)?.toInt(),
  renderTimeSeconds: (json['renderTimeSeconds'] as num?)?.toInt(),
  creditsCost: (json['creditsCost'] as num?)?.toInt() ?? 5,
  errorMessage: json['errorMessage'] as String?,
  errorCode: json['errorCode'] as String?,
  retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RenderJobToJson(_RenderJob instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'userId': instance.userId,
      'status': _$RenderStatusEnumMap[instance.status]!,
      'progress': instance.progress,
      'format': instance.format,
      'resolution': instance.resolution,
      'quality': instance.quality,
      'outputUrl': instance.outputUrl,
      'outputSizeBytes': instance.outputSizeBytes,
      'renderTimeSeconds': instance.renderTimeSeconds,
      'creditsCost': instance.creditsCost,
      'errorMessage': instance.errorMessage,
      'errorCode': instance.errorCode,
      'retryCount': instance.retryCount,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$RenderStatusEnumMap = {
  RenderStatus.queued: 'queued',
  RenderStatus.processing: 'processing',
  RenderStatus.completed: 'completed',
  RenderStatus.failed: 'failed',
};

_RenderManifest _$RenderManifestFromJson(Map<String, dynamic> json) =>
    _RenderManifest(
      scenes: (json['scenes'] as List<dynamic>)
          .map((e) => RenderScene.fromJson(e as Map<String, dynamic>))
          .toList(),
      settings: RenderSettings.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
      overlays: json['overlays'] == null
          ? null
          : RenderOverlays.fromJson(json['overlays'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RenderManifestToJson(_RenderManifest instance) =>
    <String, dynamic>{
      'scenes': instance.scenes,
      'settings': instance.settings,
      'overlays': instance.overlays,
    };

_RenderScene _$RenderSceneFromJson(Map<String, dynamic> json) => _RenderScene(
  index: (json['index'] as num).toInt(),
  type: json['type'] as String,
  url: json['url'] as String,
  duration: (json['duration'] as num).toInt(),
  audioUrl: json['audioUrl'] as String?,
  transition: json['transition'] as String,
  layers:
      (json['layers'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
);

Map<String, dynamic> _$RenderSceneToJson(_RenderScene instance) =>
    <String, dynamic>{
      'index': instance.index,
      'type': instance.type,
      'url': instance.url,
      'duration': instance.duration,
      'audioUrl': instance.audioUrl,
      'transition': instance.transition,
      'layers': instance.layers,
    };

_RenderSettings _$RenderSettingsFromJson(Map<String, dynamic> json) =>
    _RenderSettings(
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      fps: (json['fps'] as num).toInt(),
      format: json['format'] as String,
      quality: json['quality'] as String,
      resolution: json['resolution'] as String?,
      videoBitrate: json['videoBitrate'] as String?,
      audioBitrate: json['audioBitrate'] as String?,
      audioSampleRate: (json['audioSampleRate'] as num?)?.toInt(),
      includeWatermark: json['includeWatermark'] as bool?,
    );

Map<String, dynamic> _$RenderSettingsToJson(_RenderSettings instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'fps': instance.fps,
      'format': instance.format,
      'quality': instance.quality,
      'resolution': instance.resolution,
      'videoBitrate': instance.videoBitrate,
      'audioBitrate': instance.audioBitrate,
      'audioSampleRate': instance.audioSampleRate,
      'includeWatermark': instance.includeWatermark,
    };

_RenderOverlays _$RenderOverlaysFromJson(Map<String, dynamic> json) =>
    _RenderOverlays(
      logo: json['logo'] == null
          ? null
          : RenderLogo.fromJson(json['logo'] as Map<String, dynamic>),
      watermark: json['watermark'] == null
          ? null
          : RenderWatermark.fromJson(json['watermark'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RenderOverlaysToJson(_RenderOverlays instance) =>
    <String, dynamic>{'logo': instance.logo, 'watermark': instance.watermark};

_RenderLogo _$RenderLogoFromJson(Map<String, dynamic> json) => _RenderLogo(
  url: json['url'] as String,
  position: json['position'] as String? ?? 'bottom-right',
);

Map<String, dynamic> _$RenderLogoToJson(_RenderLogo instance) =>
    <String, dynamic>{'url': instance.url, 'position': instance.position};

_RenderWatermark _$RenderWatermarkFromJson(Map<String, dynamic> json) =>
    _RenderWatermark(
      text: json['text'] as String,
      position: json['position'] as String? ?? 'bottom-center',
    );

Map<String, dynamic> _$RenderWatermarkToJson(_RenderWatermark instance) =>
    <String, dynamic>{'text': instance.text, 'position': instance.position};
