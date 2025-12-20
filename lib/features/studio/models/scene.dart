import 'package:freezed_annotation/freezed_annotation.dart';
import 'layer.dart';

part 'scene.freezed.dart';
part 'scene.g.dart';

/// نوع المشهد
enum SceneType {
  @JsonValue('intro')
  intro,
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('ugc')
  ugc,
  @JsonValue('text')
  text,
  @JsonValue('transition')
  transition,
  @JsonValue('cta')
  cta,
  @JsonValue('product')
  product,
  @JsonValue('features')
  features,
  @JsonValue('outro')
  outro,
}

/// حالة المشهد
enum SceneStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('pending')
  pending,
  @JsonValue('generating')
  generating,
  @JsonValue('ready')
  ready,
  @JsonValue('failed')
  failed,
  @JsonValue('error')
  error,
}

/// نوع الانتقال
enum TransitionType {
  @JsonValue('fade')
  fade,
  @JsonValue('slide_left')
  slideLeft,
  @JsonValue('slide_right')
  slideRight,
  @JsonValue('zoom')
  zoom,
  @JsonValue('none')
  none,
}

/// المشهد
@freezed
abstract class Scene with _$Scene {
  const Scene._();

  const factory Scene({
    required String id,
    required String projectId,
    @Default(0) int orderIndex,
    @Default(SceneType.image) SceneType sceneType,
    String? prompt,
    String? imagePrompt, // للتوافق مع الشاشات
    String? scriptText,
    @Default(5000) int durationMs,
    String? generatedImageUrl,
    String? generatedVideoUrl,
    String? generatedAudioUrl,
    @Default(SceneStatus.pending) SceneStatus status,
    String? errorMessage,
    @Default([]) List<Layer> layers,
    @Default(TransitionType.fade) TransitionType transitionIn,
    @Default(TransitionType.fade) TransitionType transitionOut,
    // حقول إضافية للتوافق مع الشاشات
    String? textOverlay,
    String? narration,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Scene;

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

  /// المدة بالثواني (alias لـ durationMs)
  double get duration => durationMs / 1000;

  /// هل المشهد جاهز؟
  bool get isReady => status == SceneStatus.ready;

  /// هل يوجد وسائط مولدة؟
  bool get hasMedia =>
      generatedImageUrl != null ||
      generatedVideoUrl != null ||
      generatedAudioUrl != null;

  /// هل يوجد صوت؟
  bool get hasAudio => generatedAudioUrl != null;

  /// المدة بالثواني
  double get durationSeconds => durationMs / 1000;

  /// رابط الوسائط الرئيسية
  String? get mediaUrl => generatedVideoUrl ?? generatedImageUrl;

  /// هل هو مشهد فيديو؟
  bool get isVideo =>
      sceneType == SceneType.video ||
      sceneType == SceneType.ugc ||
      generatedVideoUrl != null;

  /// نسخة محدثة مع حالة جديدة
  Scene withStatus(SceneStatus newStatus, {String? error}) {
    return copyWith(
      status: newStatus,
      errorMessage: error,
      updatedAt: DateTime.now(),
    );
  }

  /// نسخة مع وسائط جديدة
  Scene withMedia({String? imageUrl, String? videoUrl, String? audioUrl}) {
    return copyWith(
      generatedImageUrl: imageUrl ?? generatedImageUrl,
      generatedVideoUrl: videoUrl ?? generatedVideoUrl,
      generatedAudioUrl: audioUrl ?? generatedAudioUrl,
      status: SceneStatus.ready,
      updatedAt: DateTime.now(),
    );
  }
}

/// إنشاء مشهد جديد
Scene createNewScene({
  required String projectId,
  required int orderIndex,
  SceneType type = SceneType.image,
  String? prompt,
  int durationMs = 5000,
}) {
  final now = DateTime.now();
  return Scene(
    id: 'temp_${now.millisecondsSinceEpoch}',
    projectId: projectId,
    orderIndex: orderIndex,
    sceneType: type,
    prompt: prompt,
    durationMs: durationMs,
    status: SceneStatus.pending,
    createdAt: now,
    updatedAt: now,
  );
}
