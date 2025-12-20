// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LayerShadow _$LayerShadowFromJson(Map<String, dynamic> json) => _LayerShadow(
  offsetX: (json['offsetX'] as num?)?.toDouble() ?? 0,
  offsetY: (json['offsetY'] as num?)?.toDouble() ?? 2,
  blur: (json['blur'] as num?)?.toDouble() ?? 4,
  color: json['color'] as String? ?? '#00000040',
);

Map<String, dynamic> _$LayerShadowToJson(_LayerShadow instance) =>
    <String, dynamic>{
      'offsetX': instance.offsetX,
      'offsetY': instance.offsetY,
      'blur': instance.blur,
      'color': instance.color,
    };

_LayerAnimation _$LayerAnimationFromJson(Map<String, dynamic> json) =>
    _LayerAnimation(
      type:
          $enumDecodeNullable(_$AnimationTypeEnumMap, json['type']) ??
          AnimationType.none,
      direction: $enumDecodeNullable(
        _$AnimationDirectionEnumMap,
        json['direction'],
      ),
      duration: (json['duration'] as num?)?.toInt() ?? 500,
      delay: (json['delay'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LayerAnimationToJson(_LayerAnimation instance) =>
    <String, dynamic>{
      'type': _$AnimationTypeEnumMap[instance.type]!,
      'direction': _$AnimationDirectionEnumMap[instance.direction],
      'duration': instance.duration,
      'delay': instance.delay,
    };

const _$AnimationTypeEnumMap = {
  AnimationType.fade: 'fade',
  AnimationType.slide: 'slide',
  AnimationType.zoom: 'zoom',
  AnimationType.bounce: 'bounce',
  AnimationType.none: 'none',
};

const _$AnimationDirectionEnumMap = {
  AnimationDirection.animIn: 'in',
  AnimationDirection.animOut: 'out',
  AnimationDirection.left: 'left',
  AnimationDirection.right: 'right',
  AnimationDirection.up: 'up',
  AnimationDirection.down: 'down',
};

_TextContent _$TextContentFromJson(Map<String, dynamic> json) => _TextContent(
  text: json['text'] as String? ?? 'نص جديد',
  fontFamily: json['fontFamily'] as String? ?? 'Cairo',
  fontSize: (json['fontSize'] as num?)?.toDouble() ?? 48,
  color: json['color'] as String? ?? '#FFFFFF',
  alignment: json['alignment'] == null
      ? TextAlign.center
      : const TextAlignConverter().fromJson(json['alignment'] as String),
  fontWeight: json['fontWeight'] == null
      ? FontWeight.bold
      : const FontWeightConverter().fromJson(json['fontWeight'] as String),
  shadow: json['shadow'] == null
      ? null
      : LayerShadow.fromJson(json['shadow'] as Map<String, dynamic>),
  strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 0,
  strokeColor: json['strokeColor'] as String? ?? '#000000',
);

Map<String, dynamic> _$TextContentToJson(_TextContent instance) =>
    <String, dynamic>{
      'text': instance.text,
      'fontFamily': instance.fontFamily,
      'fontSize': instance.fontSize,
      'color': instance.color,
      'alignment': const TextAlignConverter().toJson(instance.alignment),
      'fontWeight': const FontWeightConverter().toJson(instance.fontWeight),
      'shadow': instance.shadow,
      'strokeWidth': instance.strokeWidth,
      'strokeColor': instance.strokeColor,
    };

_ImageContent _$ImageContentFromJson(Map<String, dynamic> json) =>
    _ImageContent(
      url: json['url'] as String,
      fit: json['fit'] == null
          ? BoxFit.cover
          : const BoxFitConverter().fromJson(json['fit'] as String),
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$ImageContentToJson(_ImageContent instance) =>
    <String, dynamic>{
      'url': instance.url,
      'fit': const BoxFitConverter().toJson(instance.fit),
      'borderRadius': instance.borderRadius,
      'opacity': instance.opacity,
    };

_ShapeContent _$ShapeContentFromJson(Map<String, dynamic> json) =>
    _ShapeContent(
      type:
          $enumDecodeNullable(_$ShapeTypeEnumMap, json['type']) ??
          ShapeType.rectangle,
      color: json['color'] as String? ?? '#007AFF',
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 0,
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 0,
      strokeColor: json['strokeColor'] as String? ?? '#000000',
    );

Map<String, dynamic> _$ShapeContentToJson(_ShapeContent instance) =>
    <String, dynamic>{
      'type': _$ShapeTypeEnumMap[instance.type]!,
      'color': instance.color,
      'borderRadius': instance.borderRadius,
      'strokeWidth': instance.strokeWidth,
      'strokeColor': instance.strokeColor,
    };

const _$ShapeTypeEnumMap = {
  ShapeType.rectangle: 'rectangle',
  ShapeType.circle: 'circle',
  ShapeType.triangle: 'triangle',
  ShapeType.star: 'star',
  ShapeType.arrow: 'arrow',
  ShapeType.line: 'line',
};

_VideoContent _$VideoContentFromJson(Map<String, dynamic> json) =>
    _VideoContent(
      url: json['url'] as String,
      fit: json['fit'] == null
          ? BoxFit.cover
          : const BoxFitConverter().fromJson(json['fit'] as String),
      loop: json['loop'] as bool? ?? true,
      autoplay: json['autoplay'] as bool? ?? true,
      muted: json['muted'] as bool? ?? false,
    );

Map<String, dynamic> _$VideoContentToJson(_VideoContent instance) =>
    <String, dynamic>{
      'url': instance.url,
      'fit': const BoxFitConverter().toJson(instance.fit),
      'loop': instance.loop,
      'autoplay': instance.autoplay,
      'muted': instance.muted,
    };

TextLayerContent _$TextLayerContentFromJson(Map<String, dynamic> json) =>
    TextLayerContent(
      TextContent.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$TextLayerContentToJson(TextLayerContent instance) =>
    <String, dynamic>{'data': instance.data, 'runtimeType': instance.$type};

ImageLayerContent _$ImageLayerContentFromJson(Map<String, dynamic> json) =>
    ImageLayerContent(
      ImageContent.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ImageLayerContentToJson(ImageLayerContent instance) =>
    <String, dynamic>{'data': instance.data, 'runtimeType': instance.$type};

ShapeLayerContent _$ShapeLayerContentFromJson(Map<String, dynamic> json) =>
    ShapeLayerContent(
      ShapeContent.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ShapeLayerContentToJson(ShapeLayerContent instance) =>
    <String, dynamic>{'data': instance.data, 'runtimeType': instance.$type};

VideoLayerContent _$VideoLayerContentFromJson(Map<String, dynamic> json) =>
    VideoLayerContent(
      VideoContent.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$VideoLayerContentToJson(VideoLayerContent instance) =>
    <String, dynamic>{'data': instance.data, 'runtimeType': instance.$type};

EmptyLayerContent _$EmptyLayerContentFromJson(Map<String, dynamic> json) =>
    EmptyLayerContent($type: json['runtimeType'] as String?);

Map<String, dynamic> _$EmptyLayerContentToJson(EmptyLayerContent instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

_Layer _$LayerFromJson(Map<String, dynamic> json) => _Layer(
  id: json['id'] as String,
  type: $enumDecodeNullable(_$LayerTypeEnumMap, json['type']) ?? LayerType.text,
  x: (json['x'] as num?)?.toDouble() ?? 0,
  y: (json['y'] as num?)?.toDouble() ?? 0,
  width: (json['width'] as num?)?.toDouble() ?? 100,
  height: (json['height'] as num?)?.toDouble() ?? 50,
  rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
  opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
  content: json['content'] == null
      ? const LayerContent.empty()
      : LayerContent.fromJson(json['content'] as Map<String, dynamic>),
  animation: json['animation'] == null
      ? null
      : LayerAnimation.fromJson(json['animation'] as Map<String, dynamic>),
  isVisible: json['isVisible'] as bool? ?? true,
  isLocked: json['isLocked'] as bool? ?? false,
  zIndex: (json['zIndex'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LayerToJson(_Layer instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$LayerTypeEnumMap[instance.type]!,
  'x': instance.x,
  'y': instance.y,
  'width': instance.width,
  'height': instance.height,
  'rotation': instance.rotation,
  'opacity': instance.opacity,
  'content': instance.content,
  'animation': instance.animation,
  'isVisible': instance.isVisible,
  'isLocked': instance.isLocked,
  'zIndex': instance.zIndex,
};

const _$LayerTypeEnumMap = {
  LayerType.text: 'text',
  LayerType.image: 'image',
  LayerType.logo: 'logo',
  LayerType.shape: 'shape',
  LayerType.video: 'video',
  LayerType.sticker: 'sticker',
  LayerType.audio: 'audio',
};
