import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'studio_provider.dart';

/// Provider لتصدير الفيديو
final renderProvider = StateNotifierProvider<RenderNotifier, RenderState>((
  ref,
) {
  return RenderNotifier(ref);
});

class RenderState {
  final bool isRendering;
  final double progress;
  final String? currentStep;
  final String? jobId;
  final RenderJob? job;
  final String? error;
  final String? resultUrl;

  const RenderState({
    this.isRendering = false,
    this.progress = 0,
    this.currentStep,
    this.jobId,
    this.job,
    this.error,
    this.resultUrl,
  });

  RenderState copyWith({
    bool? isRendering,
    double? progress,
    String? currentStep,
    String? jobId,
    RenderJob? job,
    String? error,
    String? resultUrl,
  }) {
    return RenderState(
      isRendering: isRendering ?? this.isRendering,
      progress: progress ?? this.progress,
      currentStep: currentStep ?? this.currentStep,
      jobId: jobId ?? this.jobId,
      job: job ?? this.job,
      error: error,
      resultUrl: resultUrl ?? this.resultUrl,
    );
  }
}

class RenderNotifier extends StateNotifier<RenderState> {
  final Ref _ref;
  Timer? _statusTimer;

  RenderNotifier(this._ref) : super(const RenderState());

  /// بدء عملية التصدير
  Future<void> startRender({
    required String projectId,
    RenderQuality quality = RenderQuality.medium,
    String format = 'mp4',
    bool includeWatermark = false,
  }) async {
    state = state.copyWith(
      isRendering: true,
      progress: 0,
      currentStep: 'جاري تجهيز المشاهد...',
      error: null,
      resultUrl: null,
    );

    try {
      final api = _ref.read(studioApiServiceProvider);
      final result = await api.startRender(
        projectId: projectId,
        quality: quality.name, // تحويل enum إلى string
        format: format,
      );

      state = state.copyWith(jobId: result.renderId);

      // بدء مراقبة الحالة
      _startStatusPolling(result.renderId);
    } catch (e) {
      state = state.copyWith(isRendering: false, error: e.toString());
      rethrow;
    }
  }

  /// مراقبة حالة التصدير
  void _startStatusPolling(String jobId) {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        // نفترض أن الرندر مكتمل بعد فترة (placeholder)
        // TODO: إضافة getRenderStatus للـ API
        await Future.delayed(const Duration(seconds: 5));

        state = state.copyWith(
          progress: 1.0,
          currentStep: 'اكتمل التصدير',
          isRendering: false,
          resultUrl: 'https://example.com/video.mp4', // placeholder
        );
        timer.cancel();
      } catch (e) {
        timer.cancel();
        state = state.copyWith(isRendering: false, error: e.toString());
      }
    });
  }

  /// إلغاء التصدير
  void cancelRender() {
    _statusTimer?.cancel();
    state = state.copyWith(isRendering: false, currentStep: 'تم الإلغاء');
  }

  /// إعادة تعيين الحالة
  void reset() {
    _statusTimer?.cancel();
    state = const RenderState();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }
}

/// Provider لتاريخ عمليات التصدير
final renderHistoryProvider = FutureProvider.family<List<RenderJob>, String>((
  ref,
  projectId,
) async {
  // TODO: أضف endpoint للحصول على تاريخ التصدير
  return [];
});

/// Provider لإعدادات التصدير
final renderSettingsProvider =
    StateNotifierProvider<RenderSettingsNotifier, RenderSettings>((ref) {
      return RenderSettingsNotifier();
    });

class RenderSettingsNotifier extends StateNotifier<RenderSettings> {
  RenderSettingsNotifier()
    : super(
        const RenderSettings(
          width: 1080,
          height: 1920,
          quality: 'medium',
          format: 'mp4',
          resolution: '1080x1920',
          fps: 30,
          videoBitrate: '8M',
          audioBitrate: '192k',
          audioSampleRate: 44100,
        ),
      );

  void setQuality(RenderQuality quality) {
    switch (quality) {
      case RenderQuality.low:
        state = state.copyWith(
          quality: quality.name,
          width: 540,
          height: 960,
          resolution: '540x960',
          fps: 24,
          videoBitrate: '2M',
        );
        break;
      case RenderQuality.medium:
        state = state.copyWith(
          quality: quality.name,
          width: 1080,
          height: 1920,
          resolution: '1080x1920',
          fps: 30,
          videoBitrate: '8M',
        );
        break;
      case RenderQuality.high:
        state = state.copyWith(
          quality: quality.name,
          width: 1080,
          height: 1920,
          resolution: '1080x1920',
          fps: 60,
          videoBitrate: '15M',
        );
        break;
      case RenderQuality.ultra:
        state = state.copyWith(
          quality: quality.name,
          width: 2160,
          height: 3840,
          resolution: '2160x3840',
          fps: 60,
          videoBitrate: '30M',
        );
        break;
    }
  }

  void setFormat(String format) {
    state = state.copyWith(format: format);
  }

  void setFps(int fps) {
    state = state.copyWith(fps: fps);
  }

  void setResolution(String resolution) {
    state = state.copyWith(resolution: resolution);
  }

  void setIncludeWatermark(bool include) {
    state = state.copyWith(includeWatermark: include);
  }
}

/// تقدير تكلفة الرصيد - يأخذ String ويحوله لـ RenderQuality
int _calculateCredits(String quality) {
  switch (quality) {
    case 'low':
      return 5;
    case 'medium':
      return 10;
    case 'high':
      return 20;
    case 'ultra':
      return 40;
    default:
      return 10;
  }
}

/// Provider لتقدير التكلفة
final estimatedCreditsProvider = Provider<int>((ref) {
  final settings = ref.watch(renderSettingsProvider);
  return _calculateCredits(settings.quality);
});

/// Provider لمعالجة FFmpeg المحلية
final localProcessingProvider =
    StateNotifierProvider<LocalProcessingNotifier, LocalProcessingState>((ref) {
      return LocalProcessingNotifier();
    });

class LocalProcessingState {
  final bool isProcessing;
  final String? currentTask;
  final double progress;
  final String? error;
  final String? outputPath;

  const LocalProcessingState({
    this.isProcessing = false,
    this.currentTask,
    this.progress = 0,
    this.error,
    this.outputPath,
  });

  LocalProcessingState copyWith({
    bool? isProcessing,
    String? currentTask,
    double? progress,
    String? error,
    String? outputPath,
  }) {
    return LocalProcessingState(
      isProcessing: isProcessing ?? this.isProcessing,
      currentTask: currentTask ?? this.currentTask,
      progress: progress ?? this.progress,
      error: error,
      outputPath: outputPath ?? this.outputPath,
    );
  }
}

class LocalProcessingNotifier extends StateNotifier<LocalProcessingState> {
  LocalProcessingNotifier() : super(const LocalProcessingState());

  /// ضغط فيديو
  Future<String?> compressVideo({
    required String inputPath,
    required String outputPath,
    int quality = 28, // CRF value (0-51, lower = better quality)
    int maxWidth = 1080,
  }) async {
    state = state.copyWith(
      isProcessing: true,
      currentTask: 'جاري ضغط الفيديو...',
      progress: 0,
    );

    try {
      // TODO: تنفيذ باستخدام ffmpeg_kit_flutter
      // final command = '-i $inputPath -vf "scale=$maxWidth:-2" -crf $quality -preset medium $outputPath';
      // await FFmpegKit.execute(command);

      state = state.copyWith(
        isProcessing: false,
        progress: 1,
        outputPath: outputPath,
      );
      return outputPath;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return null;
    }
  }

  /// قص فيديو
  Future<String?> trimVideo({
    required String inputPath,
    required String outputPath,
    required Duration start,
    required Duration end,
  }) async {
    state = state.copyWith(
      isProcessing: true,
      currentTask: 'جاري قص الفيديو...',
      progress: 0,
    );

    try {
      // TODO: تنفيذ باستخدام ffmpeg_kit_flutter
      // final startStr = _formatDuration(start);
      // final durationStr = _formatDuration(end - start);
      // final command = '-i $inputPath -ss $startStr -t $durationStr -c copy $outputPath';

      state = state.copyWith(
        isProcessing: false,
        progress: 1,
        outputPath: outputPath,
      );
      return outputPath;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return null;
    }
  }

  /// دمج صوت مع فيديو
  Future<String?> mergeAudio({
    required String videoPath,
    required String audioPath,
    required String outputPath,
    double volume = 1.0,
  }) async {
    state = state.copyWith(
      isProcessing: true,
      currentTask: 'جاري دمج الصوت...',
      progress: 0,
    );

    try {
      // TODO: تنفيذ باستخدام ffmpeg_kit_flutter
      // final command = '-i $videoPath -i $audioPath -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -filter:a "volume=$volume" $outputPath';

      state = state.copyWith(
        isProcessing: false,
        progress: 1,
        outputPath: outputPath,
      );
      return outputPath;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return null;
    }
  }

  /// إضافة نص للفيديو
  Future<String?> addTextOverlay({
    required String inputPath,
    required String outputPath,
    required String text,
    String fontColor = 'white',
    int fontSize = 48,
    String position = 'center',
  }) async {
    state = state.copyWith(
      isProcessing: true,
      currentTask: 'جاري إضافة النص...',
      progress: 0,
    );

    try {
      // TODO: تنفيذ باستخدام ffmpeg_kit_flutter

      state = state.copyWith(
        isProcessing: false,
        progress: 1,
        outputPath: outputPath,
      );
      return outputPath;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return null;
    }
  }

  /// تحويل الصور لفيديو
  Future<String?> imagesToVideo({
    required List<String> imagePaths,
    required String outputPath,
    double durationPerImage = 3.0,
    int fps = 30,
  }) async {
    state = state.copyWith(
      isProcessing: true,
      currentTask: 'جاري تحويل الصور لفيديو...',
      progress: 0,
    );

    try {
      // TODO: تنفيذ باستخدام ffmpeg_kit_flutter

      state = state.copyWith(
        isProcessing: false,
        progress: 1,
        outputPath: outputPath,
      );
      return outputPath;
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
      return null;
    }
  }

  /// إلغاء المعالجة
  void cancel() {
    // TODO: FFmpegKit.cancel();
    state = state.copyWith(isProcessing: false, currentTask: 'تم الإلغاء');
  }

  /// إعادة تعيين
  void reset() {
    state = const LocalProcessingState();
  }
}
