import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

/// محرر الـ Canvas للطبقات
class CanvasEditorScreen extends ConsumerStatefulWidget {
  final Scene scene;

  const CanvasEditorScreen({super.key, required this.scene});

  @override
  ConsumerState<CanvasEditorScreen> createState() => _CanvasEditorScreenState();
}

class _CanvasEditorScreenState extends ConsumerState<CanvasEditorScreen> {
  bool _showLayerPanel = true;
  bool _showPropertiesPanel = false;

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasEditorProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('محرر المشهد'),
        actions: [
          // تراجع
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: canvasState.canUndo
                ? () => ref.read(canvasEditorProvider.notifier).undo()
                : null,
            tooltip: 'تراجع',
          ),
          // إعادة
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: canvasState.canRedo
                ? () => ref.read(canvasEditorProvider.notifier).redo()
                : null,
            tooltip: 'إعادة',
          ),
          const VerticalDivider(),
          // الشبكة
          IconButton(
            icon: Icon(canvasState.showGrid ? Icons.grid_on : Icons.grid_off),
            onPressed: () =>
                ref.read(canvasEditorProvider.notifier).toggleGrid(),
            tooltip: 'الشبكة',
          ),
          // Snap to grid
          IconButton(
            icon: Icon(
              canvasState.snapToGrid ? Icons.near_me : Icons.near_me_disabled,
            ),
            onPressed: () =>
                ref.read(canvasEditorProvider.notifier).toggleSnapToGrid(),
            tooltip: 'التقاط للشبكة',
          ),
          const VerticalDivider(),
          // Zoom
          PopupMenuButton<double>(
            icon: const Icon(Icons.zoom_in),
            tooltip: 'التكبير',
            onSelected: (zoom) =>
                ref.read(canvasEditorProvider.notifier).setZoom(zoom),
            itemBuilder: (context) => [
              for (final z in [0.5, 0.75, 1.0, 1.25, 1.5, 2.0])
                PopupMenuItem(value: z, child: Text('${(z * 100).round()}%')),
            ],
          ),
          const SizedBox(width: 8),
          // حفظ
          FilledButton.icon(
            onPressed: _saveAndExit,
            icon: const Icon(Icons.check),
            label: const Text('حفظ'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // لوحة الطبقات
          if (_showLayerPanel)
            LayerPanel(
              layers: canvasState.layers,
              selectedLayerId: canvasState.selectedLayerId,
              onLayerSelected: (id) =>
                  ref.read(canvasEditorProvider.notifier).selectLayer(id),
              onLayerDeleted: (id) =>
                  ref.read(canvasEditorProvider.notifier).removeLayer(id),
              onLayerVisibilityToggled: (id) {
                final layer = canvasState.layers.firstWhere((l) => l.id == id);
                ref
                    .read(canvasEditorProvider.notifier)
                    .updateLayer(
                      id,
                      layer.copyWith(isVisible: !layer.isVisible),
                    );
              },
              onLayerLockToggled: (id) {
                final layer = canvasState.layers.firstWhere((l) => l.id == id);
                ref
                    .read(canvasEditorProvider.notifier)
                    .updateLayer(id, layer.copyWith(isLocked: !layer.isLocked));
              },
              onLayerReordered: (oldIndex, newIndex) {
                // TODO: إعادة ترتيب الطبقات
              },
            ),

          // منطقة Canvas
          Expanded(
            child: Stack(
              children: [
                // الـ Canvas
                Center(child: _buildCanvas(canvasState)),

                // شريط الأدوات السفلي
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildToolbar(),
                ),

                // معلومات الـ zoom
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(canvasState.zoom * 100).round()}%',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // لوحة الخصائص
          if (_showPropertiesPanel && canvasState.selectedLayer != null)
            _buildPropertiesPanel(canvasState.selectedLayer!),
        ],
      ),
    );
  }

  Widget _buildCanvas(CanvasEditorState state) {
    return GestureDetector(
      onTap: () => ref.read(canvasEditorProvider.notifier).clearSelection(),
      onScaleUpdate: (details) {
        if (details.scale != 1.0) {
          ref
              .read(canvasEditorProvider.notifier)
              .setZoom(state.zoom * details.scale);
        }
      },
      child: InteractiveViewer(
        transformationController: TransformationController(),
        minScale: 0.1,
        maxScale: 3.0,
        child: Container(
          width: state.canvasSize.width * state.zoom,
          height: state.canvasSize.height * state.zoom,
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20),
            ],
          ),
          child: Stack(
            children: [
              // الخلفية (صورة المشهد)
              if (widget.scene.generatedImageUrl != null)
                Positioned.fill(
                  child: Image.network(
                    widget.scene.generatedImageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),

              // الشبكة
              if (state.showGrid)
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPainter(
                      gridSize: state.gridSize.toDouble(),
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),

              // الطبقات
              ...state.layers
                  .where((l) => l.isVisible)
                  .toList()
                  .map(
                    (layer) => DraggableLayer(
                      key: ValueKey(layer.id),
                      layer: layer,
                      isSelected: layer.id == state.selectedLayerId,
                      canvasScale: state.zoom,
                      onTap: () => ref
                          .read(canvasEditorProvider.notifier)
                          .selectLayer(layer.id),
                      onPositionChanged: (pos) => ref
                          .read(canvasEditorProvider.notifier)
                          .moveLayer(layer.id, pos),
                      onSizeChanged: (size) => ref
                          .read(canvasEditorProvider.notifier)
                          .resizeLayer(layer.id, size),
                      onRotationChanged: (angle) => ref
                          .read(canvasEditorProvider.notifier)
                          .rotateLayer(layer.id, angle),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ToolButton(
            icon: Icons.text_fields,
            label: 'نص',
            onPressed: _addTextLayer,
          ),
          _ToolButton(
            icon: Icons.image,
            label: 'صورة',
            onPressed: _addImageLayer,
          ),
          _ToolButton(
            icon: Icons.crop_square,
            label: 'شكل',
            onPressed: _addShapeLayer,
          ),
          _ToolButton(
            icon: Icons.emoji_emotions,
            label: 'ملصق',
            onPressed: _addStickerLayer,
          ),
          const VerticalDivider(width: 24),
          _ToolButton(
            icon: Icons.auto_awesome,
            label: 'AI صورة',
            onPressed: _generateAIImage,
          ),
          const VerticalDivider(width: 24),
          _ToolButton(
            icon: Icons.layers,
            label: 'طبقات',
            isActive: _showLayerPanel,
            onPressed: () => setState(() => _showLayerPanel = !_showLayerPanel),
          ),
          _ToolButton(
            icon: Icons.tune,
            label: 'خصائص',
            isActive: _showPropertiesPanel,
            onPressed: () =>
                setState(() => _showPropertiesPanel = !_showPropertiesPanel),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesPanel(Layer layer) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خصائص الطبقة',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // الموقع
            _PropertySection(
              title: 'الموقع',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _PropertyField(
                        label: 'X',
                        value: layer.x.round().toString(),
                        onChanged: (v) {
                          final x = double.tryParse(v) ?? layer.x;
                          ref
                              .read(canvasEditorProvider.notifier)
                              .updateLayer(layer.id, layer.copyWith(x: x));
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PropertyField(
                        label: 'Y',
                        value: layer.y.round().toString(),
                        onChanged: (v) {
                          final y = double.tryParse(v) ?? layer.y;
                          ref
                              .read(canvasEditorProvider.notifier)
                              .updateLayer(layer.id, layer.copyWith(y: y));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // الحجم
            _PropertySection(
              title: 'الحجم',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _PropertyField(
                        label: 'العرض',
                        value: layer.width.round().toString(),
                        onChanged: (v) {
                          final w = double.tryParse(v) ?? layer.width;
                          ref
                              .read(canvasEditorProvider.notifier)
                              .updateLayer(layer.id, layer.copyWith(width: w));
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PropertyField(
                        label: 'الارتفاع',
                        value: layer.height.round().toString(),
                        onChanged: (v) {
                          final h = double.tryParse(v) ?? layer.height;
                          ref
                              .read(canvasEditorProvider.notifier)
                              .updateLayer(layer.id, layer.copyWith(height: h));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // الدوران والشفافية
            _PropertySection(
              title: 'التحويل',
              children: [
                _SliderProperty(
                  label: 'الدوران',
                  value: layer.rotation,
                  min: 0,
                  max: 360,
                  onChanged: (v) {
                    ref
                        .read(canvasEditorProvider.notifier)
                        .rotateLayer(layer.id, v);
                  },
                ),
                _SliderProperty(
                  label: 'الشفافية',
                  value: layer.opacity,
                  min: 0,
                  max: 1,
                  onChanged: (v) {
                    ref
                        .read(canvasEditorProvider.notifier)
                        .setLayerOpacity(layer.id, v);
                  },
                ),
              ],
            ),

            // خصائص النص إذا كان نص
            if (layer.type == LayerType.text &&
                layer.content is TextLayerContent)
              TextEditorPanel(
                content: (layer.content as TextLayerContent).data,
                onChanged: (content) {
                  ref
                      .read(canvasEditorProvider.notifier)
                      .updateLayer(
                        layer.id,
                        layer.copyWith(content: LayerContent.text(content)),
                      );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _addTextLayer() {
    ref.read(canvasEditorProvider.notifier).addTextLayer(text: 'نص جديد');
  }

  void _addImageLayer() async {
    // TODO: فتح منتقي الصور
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('سيتم إضافة منتقي الصور')));
  }

  void _addShapeLayer() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر شكلاً'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: ShapeType.values.map((shape) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    ref
                        .read(canvasEditorProvider.notifier)
                        .addShapeLayer(shapeType: shape);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_getShapeIcon(shape)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getShapeIcon(ShapeType shape) {
    switch (shape) {
      case ShapeType.rectangle:
        return Icons.crop_square;
      case ShapeType.circle:
        return Icons.circle_outlined;
      case ShapeType.triangle:
        return Icons.change_history;
      case ShapeType.star:
        return Icons.star_outline;
      case ShapeType.arrow:
        return Icons.arrow_forward;
      case ShapeType.line:
        return Icons.horizontal_rule;
    }
  }

  void _addStickerLayer() {
    // TODO: فتح منتقي الملصقات
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('سيتم إضافة منتقي الملصقات')));
  }

  void _generateAIImage() async {
    final promptController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('توليد صورة AI'),
        content: TextField(
          controller: promptController,
          decoration: const InputDecoration(
            hintText: 'صف الصورة التي تريدها...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, promptController.text),
            child: const Text('توليد'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final imageUrl = await ref
            .read(aiGenerationProvider.notifier)
            .generateImage(prompt: result);
        ref
            .read(canvasEditorProvider.notifier)
            .addImageLayer(imageUrl: imageUrl);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  void _saveAndExit() {
    final layers = ref.read(canvasEditorProvider).layers;
    // TODO: حفظ الطبقات في المشهد
    Navigator.pop(context, layers);
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isActive;

  const _ToolButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, maxWidth: 64),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? colorScheme.primaryContainer : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isActive ? colorScheme.primary : colorScheme.onSurface,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    color: isActive
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PropertySection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _PropertySection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }
}

class _PropertyField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _PropertyField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }
}

class _SliderProperty extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderProperty({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(
              value.toStringAsFixed(max > 1 ? 0 : 2),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}

/// رسام الشبكة
class GridPainter extends CustomPainter {
  final double gridSize;
  final Color color;

  GridPainter({required this.gridSize, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    // خطوط عمودية
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // خطوط أفقية
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
