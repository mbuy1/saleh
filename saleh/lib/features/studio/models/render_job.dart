import 'package:freezed_annotation/freezed_annotation.dart';

part 'render_job.freezed.dart';
part 'render_job.g.dart';

/// حالة الرندر
enum RenderStatus {
  @JsonValue('queued')
  queued,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}

/// جودة الرندر
enum RenderQuality {
  low('720p', 720, 1280),
  medium('1080p', 1080, 1920),
  high('1080p 60fps', 1080, 1920),
  ultra('4K', 2160, 3840);

  const RenderQuality(this.label, this.height, this.width);
  final String label;
  final int width;
  final int height;
}

/// مهمة الرندر
@freezed
abstract class RenderJob with _$RenderJob {
  const RenderJob._();

  const factory RenderJob({
    required String id,
    required String projectId,
    required String userId,
    @Default(RenderStatus.queued) RenderStatus status,
    @Default(0) int progress,
    @Default('mp4') String format,
    @Default('1080p') String resolution,
    @Default('medium') String quality,
    String? outputUrl,
    int? outputSizeBytes,
    int? renderTimeSeconds,
    @Default(5) int creditsCost,
    String? errorMessage,
    String? errorCode,
    @Default(0) int retryCount,
    DateTime? startedAt,
    DateTime? completedAt,
    required DateTime createdAt,
  }) = _RenderJob;

  factory RenderJob.fromJson(Map<String, dynamic> json) =>
      _$RenderJobFromJson(json);

  /// هل الرندر قيد التنفيذ؟
  bool get isProcessing =>
      status == RenderStatus.queued || status == RenderStatus.processing;

  /// هل الرندر مكتمل؟
  bool get isCompleted => status == RenderStatus.completed && outputUrl != null;

  /// هل فشل الرندر؟
  bool get isFailed => status == RenderStatus.failed;

  /// حجم الملف بصيغة مقروءة
  String get formattedSize {
    if (outputSizeBytes == null) return '';
    final mb = outputSizeBytes! / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  /// وقت الرندر بصيغة مقروءة
  String get formattedRenderTime {
    if (renderTimeSeconds == null) return '';
    if (renderTimeSeconds! < 60) return '${renderTimeSeconds}ث';
    final minutes = renderTimeSeconds! ~/ 60;
    final seconds = renderTimeSeconds! % 60;
    return '${minutes}د ${seconds}ث';
  }
}

/// Manifest للرندر (يُرسل لـ Flutter للمعالجة)
@freezed
abstract class RenderManifest with _$RenderManifest {
  const factory RenderManifest({
    required List<RenderScene> scenes,
    required RenderSettings settings,
    RenderOverlays? overlays,
  }) = _RenderManifest;

  factory RenderManifest.fromJson(Map<String, dynamic> json) =>
      _$RenderManifestFromJson(json);
}

/// مشهد للرندر
@freezed
abstract class RenderScene with _$RenderScene {
  const factory RenderScene({
    required int index,
    required String type, // 'image' | 'video'
    required String url,
    required int duration, // بالمللي ثانية
    String? audioUrl,
    required String transition,
    @Default([]) List<Map<String, dynamic>> layers,
  }) = _RenderScene;

  factory RenderScene.fromJson(Map<String, dynamic> json) =>
      _$RenderSceneFromJson(json);
}

/// إعدادات الرندر
@freezed
abstract class RenderSettings with _$RenderSettings {
  const RenderSettings._();

  const factory RenderSettings({
    required int width,
    required int height,
    required int fps,
    required String format,
    required String quality,
    // حقول إضافية للتوافق
    String? resolution,
    String? videoBitrate,
    String? audioBitrate,
    int? audioSampleRate,
    bool? includeWatermark,
  }) = _RenderSettings;

  factory RenderSettings.fromJson(Map<String, dynamic> json) =>
      _$RenderSettingsFromJson(json);

  /// حساب resolution من width/height
  String get calculatedResolution => '${width}x$height';
}

/// العناصر المركبة
@freezed
abstract class RenderOverlays with _$RenderOverlays {
  const factory RenderOverlays({RenderLogo? logo, RenderWatermark? watermark}) =
      _RenderOverlays;

  factory RenderOverlays.fromJson(Map<String, dynamic> json) =>
      _$RenderOverlaysFromJson(json);
}

@freezed
abstract class RenderLogo with _$RenderLogo {
  const factory RenderLogo({
    required String url,
    @Default('bottom-right') String position,
  }) = _RenderLogo;

  factory RenderLogo.fromJson(Map<String, dynamic> json) =>
      _$RenderLogoFromJson(json);
}

@freezed
abstract class RenderWatermark with _$RenderWatermark {
  const factory RenderWatermark({
    required String text,
    @Default('bottom-center') String position,
  }) = _RenderWatermark;

  factory RenderWatermark.fromJson(Map<String, dynamic> json) =>
      _$RenderWatermarkFromJson(json);
}
