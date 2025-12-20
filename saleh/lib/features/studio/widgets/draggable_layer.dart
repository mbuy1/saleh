import 'package:flutter/material.dart';
import '../models/models.dart';

/// طبقة قابلة للسحب والتحجيم
class DraggableLayer extends StatefulWidget {
  final Layer layer;
  final bool isSelected;
  final double canvasScale;
  final VoidCallback? onTap;
  final ValueChanged<Offset>? onPositionChanged;
  final ValueChanged<Size>? onSizeChanged;
  final ValueChanged<double>? onRotationChanged;

  const DraggableLayer({
    super.key,
    required this.layer,
    this.isSelected = false,
    this.canvasScale = 1.0,
    this.onTap,
    this.onPositionChanged,
    this.onSizeChanged,
    this.onRotationChanged,
  });

  @override
  State<DraggableLayer> createState() => _DraggableLayerState();
}

class _DraggableLayerState extends State<DraggableLayer> {
  late Offset _position;
  late Size _size;
  late double _rotation;
  bool _isDragging = false;
  _ResizeHandle? _activeHandle;

  @override
  void initState() {
    super.initState();
    _initFromLayer();
  }

  @override
  void didUpdateWidget(DraggableLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layer != widget.layer && !_isDragging) {
      _initFromLayer();
    }
  }

  void _initFromLayer() {
    _position = Offset(widget.layer.x, widget.layer.y);
    _size = Size(widget.layer.width, widget.layer.height);
    _rotation = widget.layer.rotation;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.layer.isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Transform.rotate(
        angle: _rotation * 3.14159 / 180,
        child: GestureDetector(
          onTap: widget.layer.isLocked ? null : widget.onTap,
          onPanStart: widget.layer.isLocked ? null : _onPanStart,
          onPanUpdate: widget.layer.isLocked ? null : _onPanUpdate,
          onPanEnd: widget.layer.isLocked ? null : _onPanEnd,
          child: Opacity(
            opacity: widget.layer.opacity,
            child: Stack(
              children: [
                // محتوى الطبقة
                SizedBox(
                  width: _size.width,
                  height: _size.height,
                  child: _buildLayerContent(),
                ),

                // إطار التحديد
                if (widget.isSelected && !widget.layer.isLocked)
                  ..._buildSelectionHandles(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayerContent() {
    final content = widget.layer.content;

    return switch (content) {
      TextLayerContent(:final data) => _buildTextContent(data),
      ImageLayerContent(:final data) => _buildImageContent(data),
      ShapeLayerContent(:final data) => _buildShapeContent(data),
      VideoLayerContent(:final data) => _buildVideoContent(data),
      EmptyLayerContent() => Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    };
  }

  Widget _buildTextContent(TextContent content) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        content.text,
        style: TextStyle(
          fontFamily: content.fontFamily,
          fontSize: content.fontSize,
          color: _hexToColor(content.color),
          fontWeight: content.fontWeight,
          shadows: content.shadow != null
              ? [
                  Shadow(
                    color: _hexToColor(content.shadow!.color),
                    offset: Offset(
                      content.shadow!.offsetX,
                      content.shadow!.offsetY,
                    ),
                    blurRadius: content.shadow!.blur,
                  ),
                ]
              : null,
        ),
        textAlign: content.alignment,
      ),
    );
  }

  Widget _buildImageContent(ImageContent content) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(content.borderRadius),
      child: Image.network(
        content.url,
        fit: content.fit,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildShapeContent(ShapeContent content) {
    final color = _hexToColor(content.color);

    switch (content.type) {
      case ShapeType.rectangle:
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(content.borderRadius),
            border: content.strokeWidth > 0
                ? Border.all(
                    color: _hexToColor(content.strokeColor),
                    width: content.strokeWidth,
                  )
                : null,
          ),
        );
      case ShapeType.circle:
        return Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: content.strokeWidth > 0
                ? Border.all(
                    color: _hexToColor(content.strokeColor),
                    width: content.strokeWidth,
                  )
                : null,
          ),
        );
      case ShapeType.triangle:
        return CustomPaint(painter: TrianglePainter(color: color));
      case ShapeType.star:
        return CustomPaint(painter: StarPainter(color: color));
      case ShapeType.arrow:
        return CustomPaint(painter: ArrowPainter(color: color));
      case ShapeType.line:
        return CustomPaint(
          painter: LinePainter(
            color: color,
            strokeWidth: content.strokeWidth > 0 ? content.strokeWidth : 2,
          ),
        );
    }
  }

  Widget _buildVideoContent(VideoContent content) {
    // معاينة الفيديو كصورة
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder for video
          Container(color: Colors.grey[900]),
          const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSelectionHandles() {
    const handleSize = 12.0;
    final borderColor = Theme.of(context).colorScheme.primary;

    return [
      // إطار التحديد
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
          ),
        ),
      ),

      // مقابض التحجيم
      _buildHandle(_ResizeHandle.topLeft, -handleSize / 2, -handleSize / 2),
      _buildHandle(
        _ResizeHandle.topRight,
        _size.width - handleSize / 2,
        -handleSize / 2,
      ),
      _buildHandle(
        _ResizeHandle.bottomLeft,
        -handleSize / 2,
        _size.height - handleSize / 2,
      ),
      _buildHandle(
        _ResizeHandle.bottomRight,
        _size.width - handleSize / 2,
        _size.height - handleSize / 2,
      ),

      // مقبض التدوير
      Positioned(
        left: _size.width / 2 - handleSize / 2,
        top: -30,
        child: GestureDetector(
          onPanUpdate: _onRotate,
          child: Container(
            width: handleSize,
            height: handleSize,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.rotate_right, size: 8, color: Colors.white),
          ),
        ),
      ),
    ];
  }

  Widget _buildHandle(_ResizeHandle handle, double left, double top) {
    const handleSize = 12.0;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onPanStart: (_) => _activeHandle = handle,
        onPanUpdate: (details) => _onResize(details, handle),
        onPanEnd: (_) => _activeHandle = null,
        child: Container(
          width: handleSize,
          height: handleSize,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.layer.isLocked) return;
    setState(() => _isDragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.layer.isLocked || _activeHandle != null) return;

    setState(() {
      _position += details.delta / widget.canvasScale;
    });
    widget.onPositionChanged?.call(_position);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() => _isDragging = false);
    widget.onPositionChanged?.call(_position);
  }

  void _onResize(DragUpdateDetails details, _ResizeHandle handle) {
    if (widget.layer.isLocked) return;

    final delta = details.delta / widget.canvasScale;
    var newWidth = _size.width;
    var newHeight = _size.height;
    var newX = _position.dx;
    var newY = _position.dy;

    switch (handle) {
      case _ResizeHandle.topLeft:
        newWidth -= delta.dx;
        newHeight -= delta.dy;
        newX += delta.dx;
        newY += delta.dy;
        break;
      case _ResizeHandle.topRight:
        newWidth += delta.dx;
        newHeight -= delta.dy;
        newY += delta.dy;
        break;
      case _ResizeHandle.bottomLeft:
        newWidth -= delta.dx;
        newHeight += delta.dy;
        newX += delta.dx;
        break;
      case _ResizeHandle.bottomRight:
        newWidth += delta.dx;
        newHeight += delta.dy;
        break;
    }

    // الحد الأدنى للحجم
    if (newWidth >= 20 && newHeight >= 20) {
      setState(() {
        _size = Size(newWidth, newHeight);
        _position = Offset(newX, newY);
      });
      widget.onSizeChanged?.call(_size);
      widget.onPositionChanged?.call(_position);
    }
  }

  void _onRotate(DragUpdateDetails details) {
    if (widget.layer.isLocked) return;

    setState(() {
      _rotation += details.delta.dx * 0.5;
    });
    widget.onRotationChanged?.call(_rotation);
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('FF');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

enum _ResizeHandle { topLeft, topRight, bottomLeft, bottomRight }

// رسامين للأشكال
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    const points = 5;

    for (int i = 0; i < points * 2; i++) {
      if (i == 0) {
        path.moveTo(cx + r * 0, cy - r);
      }
    }

    // رسم نجمة بسيطة
    final starPath = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * 3.14159 / 5) - 3.14159 / 2;
      final x = cx + r * 0.9 * (angle).cos;
      final y = cy + r * 0.9 * (angle).sin;
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();

    canvas.drawPath(starPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ArrowPainter extends CustomPainter {
  final Color color;

  ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width * 0.6, size.height * 0.3)
      ..lineTo(size.width * 0.6, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width * 0.6, size.height)
      ..lineTo(size.width * 0.6, size.height * 0.7)
      ..lineTo(0, size.height * 0.7)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  LinePainter({required this.color, this.strokeWidth = 2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// إضافة extension لـ cos و sin
extension on double {
  double get cos => this.abs() < 1.57
      ? 1 - (this * this) / 2
      : -(1 -
            ((this.abs() - 3.14159).abs() * (this.abs() - 3.14159).abs()) / 2);

  double get sin => this.abs() < 1.57
      ? this - (this * this * this) / 6
      : (this > 0 ? 1 : -1) *
            (3.14159 -
                this.abs() -
                ((3.14159 - this.abs()) *
                        (3.14159 - this.abs()) *
                        (3.14159 - this.abs())) /
                    6);
}
