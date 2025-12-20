import 'package:flutter/material.dart';
import '../models/models.dart';

/// لوحة الطبقات
class LayerPanel extends StatelessWidget {
  final List<Layer> layers;
  final String? selectedLayerId;
  final ValueChanged<String> onLayerSelected;
  final ValueChanged<String> onLayerDeleted;
  final ValueChanged<String> onLayerVisibilityToggled;
  final ValueChanged<String> onLayerLockToggled;
  final Function(int oldIndex, int newIndex) onLayerReordered;

  const LayerPanel({
    super.key,
    required this.layers,
    this.selectedLayerId,
    required this.onLayerSelected,
    required this.onLayerDeleted,
    required this.onLayerVisibilityToggled,
    required this.onLayerLockToggled,
    required this.onLayerReordered,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ترتيب الطبقات حسب z-index (عكسي للعرض)
    final sortedLayers = [...layers]
      ..sort((a, b) => b.zIndex.compareTo(a.zIndex));

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Column(
        children: [
          // العنوان
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.layers, size: 18, color: colorScheme.onSurface),
                const SizedBox(width: 8),
                Text(
                  'الطبقات',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${layers.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // قائمة الطبقات
          Expanded(
            child: sortedLayers.isEmpty
                ? _buildEmptyState(context)
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: sortedLayers.length,
                    onReorder: onLayerReordered,
                    buildDefaultDragHandles: false,
                    itemBuilder: (context, index) {
                      final layer = sortedLayers[index];
                      final isSelected = layer.id == selectedLayerId;

                      return LayerListItem(
                        key: ValueKey(layer.id),
                        layer: layer,
                        index: index,
                        isSelected: isSelected,
                        onTap: () => onLayerSelected(layer.id),
                        onDelete: () => onLayerDeleted(layer.id),
                        onVisibilityToggle: () =>
                            onLayerVisibilityToggled(layer.id),
                        onLockToggle: () => onLayerLockToggled(layer.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.layers_clear_outlined,
            size: 48,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد طبقات',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'أضف نص أو صورة للبدء',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// عنصر طبقة في القائمة
class LayerListItem extends StatelessWidget {
  final Layer layer;
  final int index;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onVisibilityToggle;
  final VoidCallback? onLockToggle;

  const LayerListItem({
    super.key,
    required this.layer,
    required this.index,
    required this.isSelected,
    this.onTap,
    this.onDelete,
    this.onVisibilityToggle,
    this.onLockToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ReorderableDragStartListener(
      index: index,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer.withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withOpacity(0.5)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // أيقونة السحب
              Icon(
                Icons.drag_indicator,
                size: 16,
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(width: 6),

              // أيقونة نوع الطبقة
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getTypeColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(_getTypeIcon(), size: 16, color: _getTypeColor()),
              ),
              const SizedBox(width: 8),

              // اسم الطبقة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLayerName(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: layer.isVisible
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getLayerType(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // أزرار التحكم
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // زر الإظهار/الإخفاء
                  IconButton(
                    icon: Icon(
                      layer.isVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 16,
                    ),
                    onPressed: onVisibilityToggle,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    color: layer.isVisible
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant.withOpacity(0.3),
                  ),

                  // زر القفل
                  IconButton(
                    icon: Icon(
                      layer.isLocked
                          ? Icons.lock_outlined
                          : Icons.lock_open_outlined,
                      size: 16,
                    ),
                    onPressed: onLockToggle,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    color: layer.isLocked
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),

                  // زر الحذف
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    color: colorScheme.error.withOpacity(0.7),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (layer.type) {
      case LayerType.text:
        return Icons.text_fields;
      case LayerType.image:
        return Icons.image_outlined;
      case LayerType.logo:
        return Icons.branding_watermark_outlined;
      case LayerType.video:
        return Icons.videocam_outlined;
      case LayerType.shape:
        return Icons.crop_square_outlined;
      case LayerType.sticker:
        return Icons.emoji_emotions_outlined;
      case LayerType.audio:
        return Icons.audiotrack_outlined;
    }
  }

  Color _getTypeColor() {
    switch (layer.type) {
      case LayerType.text:
        return Colors.blue;
      case LayerType.image:
        return Colors.green;
      case LayerType.logo:
        return Colors.indigo;
      case LayerType.video:
        return Colors.red;
      case LayerType.shape:
        return Colors.purple;
      case LayerType.sticker:
        return Colors.orange;
      case LayerType.audio:
        return Colors.teal;
    }
  }

  String _getLayerName() {
    final content = layer.content;
    if (content case TextLayerContent(:final data)) {
      return data.text.length > 20
          ? '${data.text.substring(0, 20)}...'
          : data.text;
    }
    return '${_getLayerType()} ${layer.id.split('_').last}';
  }

  String _getLayerType() {
    switch (layer.type) {
      case LayerType.text:
        return 'نص';
      case LayerType.image:
        return 'صورة';
      case LayerType.logo:
        return 'شعار';
      case LayerType.video:
        return 'فيديو';
      case LayerType.shape:
        return 'شكل';
      case LayerType.sticker:
        return 'ملصق';
      case LayerType.audio:
        return 'صوت';
    }
  }
}
