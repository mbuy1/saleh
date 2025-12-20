import 'package:flutter/material.dart';
import '../models/models.dart';

/// محرر النص للطبقات
class TextEditorPanel extends StatefulWidget {
  final TextContent content;
  final ValueChanged<TextContent> onChanged;

  const TextEditorPanel({
    super.key,
    required this.content,
    required this.onChanged,
  });

  @override
  State<TextEditorPanel> createState() => _TextEditorPanelState();
}

class _TextEditorPanelState extends State<TextEditorPanel> {
  late TextEditingController _textController;
  late TextContent _content;

  @override
  void initState() {
    super.initState();
    _content = widget.content;
    _textController = TextEditingController(text: _content.text);
  }

  @override
  void didUpdateWidget(TextEditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      _content = widget.content;
      _textController.text = _content.text;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateContent(TextContent newContent) {
    setState(() => _content = newContent);
    widget.onChanged(newContent);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حقل النص
            Text('النص', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'اكتب النص هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) {
                _updateContent(_content.copyWith(text: value));
              },
            ),
            const SizedBox(height: 16),

            // حجم الخط
            Row(
              children: [
                Text('حجم الخط', style: theme.textTheme.labelLarge),
                const Spacer(),
                Text(
                  '${_content.fontSize.round()}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            Slider(
              value: _content.fontSize,
              min: 12,
              max: 120,
              divisions: 54,
              onChanged: (value) {
                _updateContent(_content.copyWith(fontSize: value));
              },
            ),
            const SizedBox(height: 8),

            // نوع الخط
            Text('نوع الخط', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Cairo', 'Tajawal', 'Almarai', 'Roboto', 'Poppins']
                  .map((font) {
                    final isSelected = _content.fontFamily == font;
                    return FilterChip(
                      label: Text(font, style: TextStyle(fontFamily: font)),
                      selected: isSelected,
                      onSelected: (_) {
                        _updateContent(_content.copyWith(fontFamily: font));
                      },
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 16),

            // سماكة الخط
            Text('سماكة الخط', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildFontWeightButton(FontWeight.w300, 'خفيف'),
                const SizedBox(width: 8),
                _buildFontWeightButton(FontWeight.normal, 'عادي'),
                const SizedBox(width: 8),
                _buildFontWeightButton(FontWeight.w500, 'متوسط'),
                const SizedBox(width: 8),
                _buildFontWeightButton(FontWeight.bold, 'عريض'),
              ],
            ),
            const SizedBox(height: 16),

            // لون النص
            Text('لون النص', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            _buildColorPicker(),
            const SizedBox(height: 16),

            // محاذاة النص
            Text('المحاذاة', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildAlignButton(TextAlign.right, Icons.format_align_right),
                const SizedBox(width: 8),
                _buildAlignButton(TextAlign.center, Icons.format_align_center),
                const SizedBox(width: 8),
                _buildAlignButton(TextAlign.left, Icons.format_align_left),
              ],
            ),
            const SizedBox(height: 16),

            // الظل
            SwitchListTile(
              title: const Text('إضافة ظل'),
              value: _content.shadow != null,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                _updateContent(
                  _content.copyWith(
                    shadow: value
                        ? const LayerShadow(
                            color: '#00000040',
                            offsetX: 2,
                            offsetY: 2,
                            blur: 4,
                          )
                        : null,
                  ),
                );
              },
            ),

            // الحدود
            SwitchListTile(
              title: const Text('إضافة حدود'),
              value: _content.strokeWidth > 0,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                _updateContent(
                  _content.copyWith(
                    strokeWidth: value ? 2 : 0,
                    strokeColor: '#000000',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontWeightButton(FontWeight weight, String label) {
    final isSelected = _content.fontWeight == weight;
    return Expanded(
      child: InkWell(
        onTap: () => _updateContent(_content.copyWith(fontWeight: weight)),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: weight,
              fontSize: 12,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      '#FFFFFF',
      '#000000',
      '#FF0000',
      '#00FF00',
      '#0000FF',
      '#FFFF00',
      '#FF00FF',
      '#00FFFF',
      '#FF6B00',
      '#9C27B0',
      '#E91E63',
      '#607D8B',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((hexColor) {
        final isSelected = _content.color == hexColor;
        return GestureDetector(
          onTap: () => _updateContent(_content.copyWith(color: hexColor)),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hexToColor(hexColor),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: 18,
                    color: _getContrastColor(hexColor),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlignButton(TextAlign align, IconData icon) {
    final isSelected = _content.alignment == align;
    return InkWell(
      onTap: () => _updateContent(_content.copyWith(alignment: align)),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : null,
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('FF');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Color _getContrastColor(String hex) {
    final color = _hexToColor(hex);
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// نموذج إعدادات الظل
class TextShadowConfig {
  final String color;
  final double offsetX;
  final double offsetY;
  final double blur;

  const TextShadowConfig({
    required this.color,
    required this.offsetX,
    required this.offsetY,
    required this.blur,
  });

  TextShadowConfig copyWith({
    String? color,
    double? offsetX,
    double? offsetY,
    double? blur,
  }) {
    return TextShadowConfig(
      color: color ?? this.color,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
      blur: blur ?? this.blur,
    );
  }

  Map<String, dynamic> toJson() => {
    'color': color,
    'offsetX': offsetX,
    'offsetY': offsetY,
    'blur': blur,
  };

  factory TextShadowConfig.fromJson(Map<String, dynamic> json) {
    return TextShadowConfig(
      color: json['color'] ?? '#000000',
      offsetX: (json['offsetX'] ?? 2).toDouble(),
      offsetY: (json['offsetY'] ?? 2).toDouble(),
      blur: (json['blur'] ?? 4).toDouble(),
    );
  }
}
