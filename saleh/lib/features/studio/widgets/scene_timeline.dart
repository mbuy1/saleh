import 'package:flutter/material.dart';
import '../models/models.dart';

/// خط الزمن للمشاهد
class SceneTimeline extends StatefulWidget {
  final List<Scene> scenes;
  final int selectedIndex;
  final ValueChanged<int> onSceneSelected;
  final ValueChanged<int>? onSceneReordered;
  final VoidCallback? onAddScene;

  const SceneTimeline({
    super.key,
    required this.scenes,
    required this.selectedIndex,
    required this.onSceneSelected,
    this.onSceneReordered,
    this.onAddScene,
  });

  @override
  State<SceneTimeline> createState() => _SceneTimelineState();
}

class _SceneTimelineState extends State<SceneTimeline> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          // مقبض سحب للتمرير
          Container(width: 4, color: colorScheme.primary.withOpacity(0.3)),

          // قائمة المشاهد
          Expanded(
            child: ReorderableListView.builder(
              scrollController: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: widget.scenes.length + 1,
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < widget.scenes.length &&
                    newIndex < widget.scenes.length) {
                  widget.onSceneReordered?.call(newIndex);
                }
              },
              itemBuilder: (context, index) {
                if (index == widget.scenes.length) {
                  // زر إضافة مشهد
                  return AddSceneButton(
                    key: const ValueKey('add_scene'),
                    onTap: widget.onAddScene,
                  );
                }

                final scene = widget.scenes[index];
                final isSelected = index == widget.selectedIndex;

                return ReorderableDragStartListener(
                  key: ValueKey(scene.id),
                  index: index,
                  child: SceneThumbnail(
                    scene: scene,
                    index: index,
                    isSelected: isSelected,
                    onTap: () => widget.onSceneSelected(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// صورة مصغرة للمشهد
class SceneThumbnail extends StatelessWidget {
  final Scene scene;
  final int index;
  final bool isSelected;
  final VoidCallback? onTap;

  const SceneThumbnail({
    super.key,
    required this.scene,
    required this.index,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // صورة المشهد
              if (scene.generatedImageUrl != null)
                Image.network(
                  scene.generatedImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                )
              else
                _buildPlaceholder(),

              // التدرج السفلي
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${scene.duration}ث',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // أيقونة حالة المشهد
              Positioned(top: 4, right: 4, child: _buildStatusIcon()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Icon(_getTypeIcon(), size: 24, color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (scene.status) {
      case SceneStatus.generating:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.white,
            ),
          ),
        );
      case SceneStatus.ready:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 12, color: Colors.white),
        );
      case SceneStatus.error:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.error_outline, size: 12, color: Colors.white),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  IconData _getTypeIcon() {
    switch (scene.sceneType) {
      case SceneType.intro:
        return Icons.play_arrow;
      case SceneType.product:
        return Icons.shopping_bag;
      case SceneType.features:
        return Icons.star;
      case SceneType.ugc:
        return Icons.person;
      case SceneType.cta:
        return Icons.touch_app;
      case SceneType.outro:
        return Icons.stop;
      case SceneType.image:
      case SceneType.video:
      case SceneType.text:
      case SceneType.transition:
        return Icons.image;
    }
  }
}

/// زر إضافة مشهد
class AddSceneButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AddSceneButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
          color: colorScheme.surface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 28,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              'إضافة',
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// معلومات الوقت الإجمالي
class TimelineInfo extends StatelessWidget {
  final List<Scene> scenes;

  const TimelineInfo({super.key, required this.scenes});

  @override
  Widget build(BuildContext context) {
    final totalDuration = scenes.fold<double>(
      0,
      (sum, scene) => sum + scene.duration,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDuration(totalDuration),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.layers_outlined,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            '${scenes.length}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(double seconds) {
    final mins = (seconds / 60).floor();
    final secs = (seconds % 60).round();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
