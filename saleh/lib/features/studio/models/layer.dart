import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'layer.freezed.dart';
part 'layer.g.dart';

/// نوع الطبقة
enum LayerType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('logo')
  logo,
  @JsonValue('shape')
  shape,
  @JsonValue('video')
  video,
  @JsonValue('sticker')
  sticker,
  @JsonValue('audio')
  audio,
}

/// نوع الشكل
enum ShapeType {
  @JsonValue('rectangle')
  rectangle,
  @JsonValue('circle')
  circle,
  @JsonValue('triangle')
  triangle,
  @JsonValue('star')
  star,
  @JsonValue('arrow')
  arrow,
  @JsonValue('line')
  line,
}

/// نوع الأنيميشن
enum AnimationType {
  @JsonValue('fade')
  fade,
  @JsonValue('slide')
  slide,
  @JsonValue('zoom')
  zoom,
  @JsonValue('bounce')
  bounce,
  @JsonValue('none')
  none,
}

/// اتجاه الأنيميشن
enum AnimationDirection {
  @JsonValue('in')
  animIn,
  @JsonValue('out')
  animOut,
  @JsonValue('left')
  left,
  @JsonValue('right')
  right,
  @JsonValue('up')
  up,
  @JsonValue('down')
  down,
}

/// محول لـ FontWeight
class FontWeightConverter implements JsonConverter<FontWeight, String> {
  const FontWeightConverter();

  @override
  FontWeight fromJson(String json) {
    switch (json) {
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      case 'bold':
        return FontWeight.bold;
      case 'normal':
      default:
        return FontWeight.normal;
    }
  }

  @override
  String toJson(FontWeight object) {
    if (object == FontWeight.w100) return 'w100';
    if (object == FontWeight.w200) return 'w200';
    if (object == FontWeight.w300) return 'w300';
    if (object == FontWeight.w400) return 'w400';
    if (object == FontWeight.w500) return 'w500';
    if (object == FontWeight.w600) return 'w600';
    if (object == FontWeight.w700) return 'w700';
    if (object == FontWeight.w800) return 'w800';
    if (object == FontWeight.w900) return 'w900';
    return 'normal';
  }
}

/// محول لـ TextAlign
class TextAlignConverter implements JsonConverter<TextAlign, String> {
  const TextAlignConverter();

  @override
  TextAlign fromJson(String json) {
    switch (json) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
      default:
        return TextAlign.center;
    }
  }

  @override
  String toJson(TextAlign object) {
    switch (object) {
      case TextAlign.left:
        return 'left';
      case TextAlign.right:
        return 'right';
      case TextAlign.center:
        return 'center';
      case TextAlign.justify:
        return 'justify';
      case TextAlign.start:
        return 'start';
      case TextAlign.end:
        return 'end';
    }
  }
}

/// محول لـ BoxFit
class BoxFitConverter implements JsonConverter<BoxFit, String> {
  const BoxFitConverter();

  @override
  BoxFit fromJson(String json) {
    switch (json) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  @override
  String toJson(BoxFit object) {
    switch (object) {
      case BoxFit.fill:
        return 'fill';
      case BoxFit.contain:
        return 'contain';
      case BoxFit.cover:
        return 'cover';
      case BoxFit.fitWidth:
        return 'fitWidth';
      case BoxFit.fitHeight:
        return 'fitHeight';
      case BoxFit.none:
        return 'none';
      case BoxFit.scaleDown:
        return 'scaleDown';
    }
  }
}

/// ظل الطبقة
@freezed
abstract class LayerShadow with _$LayerShadow {
  const factory LayerShadow({
    @Default(0) double offsetX,
    @Default(2) double offsetY,
    @Default(4) double blur,
    @Default('#00000040') String color,
  }) = _LayerShadow;

  factory LayerShadow.fromJson(Map<String, dynamic> json) =>
      _$LayerShadowFromJson(json);
}

/// أنيميشن الطبقة
@freezed
abstract class LayerAnimation with _$LayerAnimation {
  const factory LayerAnimation({
    @Default(AnimationType.none) AnimationType type,
    AnimationDirection? direction,
    @Default(500) int duration,
    @Default(0) int delay,
  }) = _LayerAnimation;

  factory LayerAnimation.fromJson(Map<String, dynamic> json) =>
      _$LayerAnimationFromJson(json);
}

/// محتوى نصي
@freezed
abstract class TextContent with _$TextContent {
  const factory TextContent({
    @Default('نص جديد') String text,
    @Default('Cairo') String fontFamily,
    @Default(48) double fontSize,
    @Default('#FFFFFF') String color,
    @TextAlignConverter() @Default(TextAlign.center) TextAlign alignment,
    @FontWeightConverter() @Default(FontWeight.bold) FontWeight fontWeight,
    LayerShadow? shadow,
    @Default(0) double strokeWidth,
    @Default('#000000') String strokeColor,
  }) = _TextContent;

  factory TextContent.fromJson(Map<String, dynamic> json) =>
      _$TextContentFromJson(json);
}

/// محتوى صورة
@freezed
abstract class ImageContent with _$ImageContent {
  const factory ImageContent({
    required String url,
    @BoxFitConverter() @Default(BoxFit.cover) BoxFit fit,
    @Default(0) double borderRadius,
    @Default(1.0) double opacity,
  }) = _ImageContent;

  factory ImageContent.fromJson(Map<String, dynamic> json) =>
      _$ImageContentFromJson(json);
}

/// محتوى شكل
@freezed
abstract class ShapeContent with _$ShapeContent {
  const factory ShapeContent({
    @Default(ShapeType.rectangle) ShapeType type,
    @Default('#007AFF') String color,
    @Default(0) double borderRadius,
    @Default(0) double strokeWidth,
    @Default('#000000') String strokeColor,
  }) = _ShapeContent;

  factory ShapeContent.fromJson(Map<String, dynamic> json) =>
      _$ShapeContentFromJson(json);
}

/// محتوى فيديو
@freezed
abstract class VideoContent with _$VideoContent {
  const factory VideoContent({
    required String url,
    @BoxFitConverter() @Default(BoxFit.cover) BoxFit fit,
    @Default(true) bool loop,
    @Default(true) bool autoplay,
    @Default(false) bool muted,
  }) = _VideoContent;

  factory VideoContent.fromJson(Map<String, dynamic> json) =>
      _$VideoContentFromJson(json);
}

/// محتوى الطبقة الموحد (sealed class)
@freezed
sealed class LayerContent with _$LayerContent {
  const factory LayerContent.text(TextContent data) = TextLayerContent;
  const factory LayerContent.image(ImageContent data) = ImageLayerContent;
  const factory LayerContent.shape(ShapeContent data) = ShapeLayerContent;
  const factory LayerContent.video(VideoContent data) = VideoLayerContent;
  const factory LayerContent.empty() = EmptyLayerContent;

  factory LayerContent.fromJson(Map<String, dynamic> json) =>
      _$LayerContentFromJson(json);
}

/// الطبقة الرئيسية
@freezed
abstract class Layer with _$Layer {
  const Layer._();

  const factory Layer({
    required String id,
    @Default(LayerType.text) LayerType type,
    @Default(0) double x,
    @Default(0) double y,
    @Default(100) double width,
    @Default(50) double height,
    @Default(0) double rotation,
    @Default(1.0) double opacity,
    @Default(LayerContent.empty()) LayerContent content,
    LayerAnimation? animation,
    @Default(true) bool isVisible,
    @Default(false) bool isLocked,
    @Default(0) int zIndex,
  }) = _Layer;

  factory Layer.fromJson(Map<String, dynamic> json) => _$LayerFromJson(json);

  /// تحويل اللون من محتوى النص
  Color get textColor {
    if (content case TextLayerContent(:final data)) {
      return _parseColor(data.color);
    }
    return Colors.white;
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    }
    return Colors.white;
  }
}

/// دوال مساعدة لإنشاء الطبقات
Layer createTextLayer({
  required String id,
  String text = 'نص جديد',
  double x = 50,
  double y = 50,
  double fontSize = 48,
  String color = '#FFFFFF',
  FontWeight fontWeight = FontWeight.bold,
}) {
  return Layer(
    id: id,
    type: LayerType.text,
    x: x,
    y: y,
    width: 300,
    height: fontSize * 1.5,
    content: LayerContent.text(
      TextContent(
        text: text,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        shadow: const LayerShadow(),
      ),
    ),
  );
}

Layer createImageLayer({
  required String id,
  required String imageUrl,
  double x = 0,
  double y = 0,
  double width = 100,
  double height = 100,
}) {
  return Layer(
    id: id,
    type: LayerType.image,
    x: x,
    y: y,
    width: width,
    height: height,
    content: LayerContent.image(ImageContent(url: imageUrl)),
  );
}

Layer createShapeLayer({
  required String id,
  ShapeType shapeType = ShapeType.rectangle,
  double x = 50,
  double y = 50,
  double width = 200,
  double height = 200,
  String color = '#007AFF',
}) {
  return Layer(
    id: id,
    type: LayerType.shape,
    x: x,
    y: y,
    width: width,
    height: height,
    content: LayerContent.shape(ShapeContent(type: shapeType, color: color)),
  );
}

Layer createLogoLayer({
  required String id,
  required String logoUrl,
  double x = 10,
  double y = 10,
  double size = 50,
}) {
  return Layer(
    id: id,
    type: LayerType.logo,
    x: x,
    y: y,
    width: size,
    height: size,
    opacity: 0.9,
    content: LayerContent.image(ImageContent(url: logoUrl)),
  );
}
