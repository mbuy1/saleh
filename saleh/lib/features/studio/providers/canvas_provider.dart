import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// حالة المشهد المحدد
final selectedSceneIndexProvider = StateProvider<int>((ref) => 0);

/// Provider لمحرر Canvas
final canvasEditorProvider =
    StateNotifierProvider<CanvasEditorNotifier, CanvasEditorState>((ref) {
      return CanvasEditorNotifier();
    });

class CanvasEditorState {
  final List<Layer> layers;
  final String? selectedLayerId;
  final bool isEditing;
  final double zoom;
  final Offset panOffset;
  final Size canvasSize;
  final bool showGrid;
  final bool snapToGrid;
  final int gridSize;
  final List<CanvasAction> history;
  final int historyIndex;

  const CanvasEditorState({
    this.layers = const [],
    this.selectedLayerId,
    this.isEditing = false,
    this.zoom = 1.0,
    this.panOffset = Offset.zero,
    this.canvasSize = const Size(1080, 1920), // 9:16 للفيديو العمودي
    this.showGrid = false,
    this.snapToGrid = true,
    this.gridSize = 20,
    this.history = const [],
    this.historyIndex = -1,
  });

  CanvasEditorState copyWith({
    List<Layer>? layers,
    String? selectedLayerId,
    bool? isEditing,
    double? zoom,
    Offset? panOffset,
    Size? canvasSize,
    bool? showGrid,
    bool? snapToGrid,
    int? gridSize,
    List<CanvasAction>? history,
    int? historyIndex,
    bool clearSelection = false,
  }) {
    return CanvasEditorState(
      layers: layers ?? this.layers,
      selectedLayerId: clearSelection
          ? null
          : (selectedLayerId ?? this.selectedLayerId),
      isEditing: isEditing ?? this.isEditing,
      zoom: zoom ?? this.zoom,
      panOffset: panOffset ?? this.panOffset,
      canvasSize: canvasSize ?? this.canvasSize,
      showGrid: showGrid ?? this.showGrid,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      gridSize: gridSize ?? this.gridSize,
      history: history ?? this.history,
      historyIndex: historyIndex ?? this.historyIndex,
    );
  }

  Layer? get selectedLayer {
    if (selectedLayerId == null) return null;
    return layers.firstWhere(
      (l) => l.id == selectedLayerId,
      orElse: () => layers.first,
    );
  }

  bool get canUndo => historyIndex >= 0;
  bool get canRedo => historyIndex < history.length - 1;
}

class CanvasAction {
  final String type;
  final List<Layer> previousState;
  final List<Layer> newState;
  final DateTime timestamp;

  CanvasAction({
    required this.type,
    required this.previousState,
    required this.newState,
  }) : timestamp = DateTime.now();
}

class CanvasEditorNotifier extends StateNotifier<CanvasEditorState> {
  CanvasEditorNotifier() : super(const CanvasEditorState());

  /// تحميل طبقات المشهد
  void loadScene(Scene scene) {
    state = state.copyWith(
      layers: scene.layers,
      selectedLayerId: null,
      history: [],
      historyIndex: -1,
    );
  }

  /// إضافة طبقة جديدة
  void addLayer(Layer layer) {
    _saveToHistory('add_layer');

    // ترتيب الـ z-index
    final maxZ = state.layers.isEmpty
        ? 0
        : state.layers.map((l) => l.zIndex).reduce(math.max);

    final newLayer = layer.copyWith(zIndex: maxZ + 1);
    state = state.copyWith(
      layers: [...state.layers, newLayer],
      selectedLayerId: newLayer.id,
    );
  }

  /// إضافة طبقة نص
  void addTextLayer({
    required String text,
    Offset? position,
    TextStyle? style,
  }) {
    final layer = Layer(
      id: 'layer_${DateTime.now().millisecondsSinceEpoch}',
      type: LayerType.text,
      x: position?.dx ?? state.canvasSize.width / 2 - 100,
      y: position?.dy ?? state.canvasSize.height / 2 - 50,
      width: 300,
      height: 100,
      content: LayerContent.text(
        TextContent(
          text: text,
          fontFamily: 'Cairo',
          fontSize: 48,
          color: '#FFFFFF',
          alignment: TextAlign.center,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    addLayer(layer);
  }

  /// إضافة طبقة صورة
  void addImageLayer({required String imageUrl, Offset? position, Size? size}) {
    final layer = Layer(
      id: 'layer_${DateTime.now().millisecondsSinceEpoch}',
      type: LayerType.image,
      x: position?.dx ?? 0,
      y: position?.dy ?? 0,
      width: size?.width ?? state.canvasSize.width,
      height: size?.height ?? state.canvasSize.height,
      content: LayerContent.image(
        ImageContent(url: imageUrl, fit: BoxFit.cover),
      ),
    );
    addLayer(layer);
  }

  /// إضافة طبقة شكل
  void addShapeLayer({
    required ShapeType shapeType,
    Offset? position,
    Size? size,
    String? color,
  }) {
    final layer = Layer(
      id: 'layer_${DateTime.now().millisecondsSinceEpoch}',
      type: LayerType.shape,
      x: position?.dx ?? state.canvasSize.width / 2 - 100,
      y: position?.dy ?? state.canvasSize.height / 2 - 100,
      width: size?.width ?? 200,
      height: size?.height ?? 200,
      content: LayerContent.shape(
        ShapeContent(
          type: shapeType,
          color: color ?? '#007AFF',
          borderRadius: 12,
        ),
      ),
    );
    addLayer(layer);
  }

  /// تحديث طبقة
  void updateLayer(String id, Layer updatedLayer) {
    _saveToHistory('update_layer');
    state = state.copyWith(
      layers: state.layers.map((l) => l.id == id ? updatedLayer : l).toList(),
    );
  }

  /// تحريك طبقة
  void moveLayer(String id, Offset newPosition) {
    final layer = state.layers.firstWhere((l) => l.id == id);

    double x = newPosition.dx;
    double y = newPosition.dy;

    // Snap to grid
    if (state.snapToGrid) {
      x = (x / state.gridSize).round() * state.gridSize.toDouble();
      y = (y / state.gridSize).round() * state.gridSize.toDouble();
    }

    updateLayer(id, layer.copyWith(x: x, y: y));
  }

  /// تغيير حجم طبقة
  void resizeLayer(String id, Size newSize) {
    final layer = state.layers.firstWhere((l) => l.id == id);

    double width = newSize.width;
    double height = newSize.height;

    // Snap to grid
    if (state.snapToGrid) {
      width = (width / state.gridSize).round() * state.gridSize.toDouble();
      height = (height / state.gridSize).round() * state.gridSize.toDouble();
    }

    updateLayer(id, layer.copyWith(width: width, height: height));
  }

  /// تدوير طبقة
  void rotateLayer(String id, double angle) {
    final layer = state.layers.firstWhere((l) => l.id == id);
    updateLayer(id, layer.copyWith(rotation: angle));
  }

  /// تغيير الشفافية
  void setLayerOpacity(String id, double opacity) {
    final layer = state.layers.firstWhere((l) => l.id == id);
    updateLayer(id, layer.copyWith(opacity: opacity));
  }

  /// حذف طبقة
  void removeLayer(String id) {
    _saveToHistory('remove_layer');
    state = state.copyWith(
      layers: state.layers.where((l) => l.id != id).toList(),
      clearSelection: state.selectedLayerId == id,
    );
  }

  /// نسخ طبقة
  void duplicateLayer(String id) {
    final layer = state.layers.firstWhere((l) => l.id == id);
    final newLayer = layer.copyWith(
      id: 'layer_${DateTime.now().millisecondsSinceEpoch}',
      x: layer.x + 20,
      y: layer.y + 20,
    );
    addLayer(newLayer);
  }

  /// تحديد طبقة
  void selectLayer(String? id) {
    state = state.copyWith(selectedLayerId: id, clearSelection: id == null);
  }

  /// إلغاء التحديد
  void clearSelection() {
    state = state.copyWith(clearSelection: true);
  }

  /// إعادة ترتيب الطبقات
  void bringToFront(String id) {
    _saveToHistory('reorder');
    final maxZ = state.layers.map((l) => l.zIndex).reduce(math.max);
    final layer = state.layers.firstWhere((l) => l.id == id);
    updateLayer(id, layer.copyWith(zIndex: maxZ + 1));
  }

  void sendToBack(String id) {
    _saveToHistory('reorder');
    final minZ = state.layers.map((l) => l.zIndex).reduce(math.min);
    final layer = state.layers.firstWhere((l) => l.id == id);
    updateLayer(id, layer.copyWith(zIndex: minZ - 1));
  }

  void bringForward(String id) {
    _saveToHistory('reorder');
    final layer = state.layers.firstWhere((l) => l.id == id);
    updateLayer(id, layer.copyWith(zIndex: layer.zIndex + 1));
  }

  void sendBackward(String id) {
    _saveToHistory('reorder');
    final layer = state.layers.firstWhere((l) => l.id == id);
    updateLayer(id, layer.copyWith(zIndex: layer.zIndex - 1));
  }

  /// التحكم في الـ zoom
  void setZoom(double zoom) {
    state = state.copyWith(zoom: zoom.clamp(0.1, 3.0));
  }

  void zoomIn() {
    setZoom(state.zoom + 0.1);
  }

  void zoomOut() {
    setZoom(state.zoom - 0.1);
  }

  void resetZoom() {
    state = state.copyWith(zoom: 1.0, panOffset: Offset.zero);
  }

  /// التحكم في الـ pan
  void setPanOffset(Offset offset) {
    state = state.copyWith(panOffset: offset);
  }

  /// إعدادات الـ grid
  void toggleGrid() {
    state = state.copyWith(showGrid: !state.showGrid);
  }

  void toggleSnapToGrid() {
    state = state.copyWith(snapToGrid: !state.snapToGrid);
  }

  void setGridSize(int size) {
    state = state.copyWith(gridSize: size);
  }

  /// تغيير حجم الـ canvas
  void setCanvasSize(Size size) {
    state = state.copyWith(canvasSize: size);
  }

  /// تغيير نسبة العرض
  void setAspectRatio(VideoAspectRatio ratio) {
    switch (ratio) {
      case VideoAspectRatio.portrait_9_16:
        state = state.copyWith(canvasSize: const Size(1080, 1920));
        break;
      case VideoAspectRatio.landscape_16_9:
        state = state.copyWith(canvasSize: const Size(1920, 1080));
        break;
      case VideoAspectRatio.square_1_1:
        state = state.copyWith(canvasSize: const Size(1080, 1080));
        break;
    }
  }

  /// حفظ في التاريخ
  void _saveToHistory(String actionType) {
    final newHistory = state.history.sublist(0, state.historyIndex + 1);
    newHistory.add(
      CanvasAction(
        type: actionType,
        previousState: state.layers,
        newState: state.layers, // سيتم تحديثها بعد الفعل
      ),
    );

    // احتفظ بآخر 50 عملية فقط
    if (newHistory.length > 50) {
      newHistory.removeAt(0);
    }

    state = state.copyWith(
      history: newHistory,
      historyIndex: newHistory.length - 1,
    );
  }

  /// تراجع
  void undo() {
    if (!state.canUndo) return;

    final action = state.history[state.historyIndex];
    state = state.copyWith(
      layers: action.previousState,
      historyIndex: state.historyIndex - 1,
    );
  }

  /// إعادة
  void redo() {
    if (!state.canRedo) return;

    final action = state.history[state.historyIndex + 1];
    state = state.copyWith(
      layers: action.newState,
      historyIndex: state.historyIndex + 1,
    );
  }

  /// تصدير الطبقات كـ JSON
  Map<String, dynamic> exportLayers() {
    return {
      'canvasSize': {
        'width': state.canvasSize.width,
        'height': state.canvasSize.height,
      },
      'layers': state.layers.map((l) => l.toJson()).toList(),
    };
  }

  /// استيراد الطبقات من JSON
  void importLayers(Map<String, dynamic> data) {
    final canvasData = data['canvasSize'] as Map<String, dynamic>?;
    final layersData = data['layers'] as List<dynamic>?;

    state = state.copyWith(
      canvasSize: canvasData != null
          ? Size(canvasData['width'], canvasData['height'])
          : state.canvasSize,
      layers: layersData?.map((l) => Layer.fromJson(l)).toList() ?? [],
    );
  }

  /// مسح كل الطبقات
  void clearAll() {
    _saveToHistory('clear_all');
    state = state.copyWith(layers: [], clearSelection: true);
  }

  /// تطبيق قالب على المشهد
  void applyTemplate(Map<String, dynamic> templateLayers) {
    _saveToHistory('apply_template');
    final layers = (templateLayers['layers'] as List<dynamic>)
        .map((l) => Layer.fromJson(l))
        .toList();
    state = state.copyWith(layers: layers);
  }
}

/// Enum لنسب العرض
enum VideoAspectRatio { portrait_9_16, landscape_16_9, square_1_1 }

/// Provider لمعاينة الفيديو
final videoPreviewProvider =
    StateNotifierProvider<VideoPreviewNotifier, VideoPreviewState>((ref) {
      return VideoPreviewNotifier();
    });

class VideoPreviewState {
  final bool isPlaying;
  final Duration currentTime;
  final Duration totalDuration;
  final int currentSceneIndex;
  final bool isLoading;

  const VideoPreviewState({
    this.isPlaying = false,
    this.currentTime = Duration.zero,
    this.totalDuration = Duration.zero,
    this.currentSceneIndex = 0,
    this.isLoading = false,
  });

  VideoPreviewState copyWith({
    bool? isPlaying,
    Duration? currentTime,
    Duration? totalDuration,
    int? currentSceneIndex,
    bool? isLoading,
  }) {
    return VideoPreviewState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentTime: currentTime ?? this.currentTime,
      totalDuration: totalDuration ?? this.totalDuration,
      currentSceneIndex: currentSceneIndex ?? this.currentSceneIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  double get progress => totalDuration.inMilliseconds > 0
      ? currentTime.inMilliseconds / totalDuration.inMilliseconds
      : 0;
}

class VideoPreviewNotifier extends StateNotifier<VideoPreviewState> {
  VideoPreviewNotifier() : super(const VideoPreviewState());

  void play() {
    state = state.copyWith(isPlaying: true);
  }

  void pause() {
    state = state.copyWith(isPlaying: false);
  }

  void toggle() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void seek(Duration time) {
    state = state.copyWith(currentTime: time);
  }

  void setProgress(double progress) {
    final time = Duration(
      milliseconds: (state.totalDuration.inMilliseconds * progress).round(),
    );
    state = state.copyWith(currentTime: time);
  }

  void setDuration(Duration duration) {
    state = state.copyWith(totalDuration: duration);
  }

  void setCurrentScene(int index) {
    state = state.copyWith(currentSceneIndex: index);
  }

  void reset() {
    state = state.copyWith(
      isPlaying: false,
      currentTime: Duration.zero,
      currentSceneIndex: 0,
    );
  }
}
