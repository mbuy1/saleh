import 'package:freezed_annotation/freezed_annotation.dart';

part 'studio_project.freezed.dart';
part 'studio_project.g.dart';

/// حالة المشروع
enum ProjectStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('generating')
  generating,
  @JsonValue('processing')
  processing,
  @JsonValue('rendering')
  rendering,
  @JsonValue('ready')
  ready,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('error')
  error,
}

/// نسبة العرض للارتفاع
enum AspectRatio {
  @JsonValue('9:16')
  portrait('9:16', 9 / 16),
  @JsonValue('16:9')
  landscape('16:9', 16 / 9),
  @JsonValue('1:1')
  square('1:1', 1);

  const AspectRatio(this.label, this.ratio);
  final String label;
  final double ratio;
}

/// بيانات المنتج للإعلان
@freezed
abstract class ProductData with _$ProductData {
  const factory ProductData({
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    String? currency,
    @Default([]) List<String> images,
    @Default([]) List<String> features,
  }) = _ProductData;

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);
}

/// السيناريو المولد
@freezed
abstract class ScriptData with _$ScriptData {
  const factory ScriptData({
    String? title,
    String? hook,
    String? headline, // للتوافق مع الشاشات
    @Default([]) List<GeneratedScene> scenes,
    String? cta,
    String? language,
  }) = _ScriptData;

  factory ScriptData.fromJson(Map<String, dynamic> json) =>
      _$ScriptDataFromJson(json);
}

/// مشهد مولد
@freezed
abstract class GeneratedScene with _$GeneratedScene {
  const GeneratedScene._();

  const factory GeneratedScene({
    required int index,
    required String type,
    String? visualPrompt,
    String? narration,
    String? textOverlay,
    @Default(5000) int durationMs,
  }) = _GeneratedScene;

  factory GeneratedScene.fromJson(Map<String, dynamic> json) =>
      _$GeneratedSceneFromJson(json);

  /// المدة بالثواني
  double get duration => durationMs / 1000;
}

/// إعدادات المشروع
@freezed
abstract class ProjectSettings with _$ProjectSettings {
  const factory ProjectSettings({
    @Default(AspectRatio.portrait) AspectRatio aspectRatio,
    @Default(30) int duration,
    @Default('ar') String language,
    String? voiceId,
    String? musicId,
    String? logoUrl,
    @Default('#000000') String brandColor,
  }) = _ProjectSettings;

  factory ProjectSettings.fromJson(Map<String, dynamic> json) =>
      _$ProjectSettingsFromJson(json);
}

/// مشروع الاستوديو
@freezed
abstract class StudioProject with _$StudioProject {
  const factory StudioProject({
    required String id,
    required String userId,
    String? storeId,
    String? templateId,
    String? productId,
    required String name,
    String? description,
    @Default(ProjectStatus.draft) ProjectStatus status,
    @Default(ProductData()) ProductData productData,
    @Default(ScriptData()) ScriptData scriptData,
    @Default(ProjectSettings()) ProjectSettings settings,
    String? outputUrl,
    String? outputThumbnailUrl,
    int? outputDuration,
    int? outputSizeBytes,
    @Default(0) int creditsUsed,
    String? errorMessage,
    @Default(0) int progress,
    // حقول إضافية للتوافق
    String? thumbnailUrl,
    @Default(0) int scenesCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudioProject;

  factory StudioProject.fromJson(Map<String, dynamic> json) =>
      _$StudioProjectFromJson(json);
}

/// إنشاء مشروع جديد
extension StudioProjectX on StudioProject {
  /// هل المشروع في حالة معالجة؟
  bool get isProcessing =>
      status == ProjectStatus.generating ||
      status == ProjectStatus.processing ||
      status == ProjectStatus.rendering;

  /// هل المشروع جاهز؟
  bool get isReady =>
      (status == ProjectStatus.ready || status == ProjectStatus.completed) &&
      outputUrl != null;

  /// هل يوجد خطأ؟
  bool get hasError =>
      status == ProjectStatus.failed ||
      status == ProjectStatus.error ||
      errorMessage != null;

  /// المدة الإجمالية بالثواني
  int get totalDurationSeconds =>
      scriptData.scenes.fold(0, (sum, s) => sum + s.durationMs) ~/ 1000;
}
