// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'layer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LayerShadow {

 double get offsetX; double get offsetY; double get blur; String get color;
/// Create a copy of LayerShadow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayerShadowCopyWith<LayerShadow> get copyWith => _$LayerShadowCopyWithImpl<LayerShadow>(this as LayerShadow, _$identity);

  /// Serializes this LayerShadow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayerShadow&&(identical(other.offsetX, offsetX) || other.offsetX == offsetX)&&(identical(other.offsetY, offsetY) || other.offsetY == offsetY)&&(identical(other.blur, blur) || other.blur == blur)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,offsetX,offsetY,blur,color);

@override
String toString() {
  return 'LayerShadow(offsetX: $offsetX, offsetY: $offsetY, blur: $blur, color: $color)';
}


}

/// @nodoc
abstract mixin class $LayerShadowCopyWith<$Res>  {
  factory $LayerShadowCopyWith(LayerShadow value, $Res Function(LayerShadow) _then) = _$LayerShadowCopyWithImpl;
@useResult
$Res call({
 double offsetX, double offsetY, double blur, String color
});




}
/// @nodoc
class _$LayerShadowCopyWithImpl<$Res>
    implements $LayerShadowCopyWith<$Res> {
  _$LayerShadowCopyWithImpl(this._self, this._then);

  final LayerShadow _self;
  final $Res Function(LayerShadow) _then;

/// Create a copy of LayerShadow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? offsetX = null,Object? offsetY = null,Object? blur = null,Object? color = null,}) {
  return _then(_self.copyWith(
offsetX: null == offsetX ? _self.offsetX : offsetX // ignore: cast_nullable_to_non_nullable
as double,offsetY: null == offsetY ? _self.offsetY : offsetY // ignore: cast_nullable_to_non_nullable
as double,blur: null == blur ? _self.blur : blur // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LayerShadow].
extension LayerShadowPatterns on LayerShadow {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayerShadow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayerShadow() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayerShadow value)  $default,){
final _that = this;
switch (_that) {
case _LayerShadow():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayerShadow value)?  $default,){
final _that = this;
switch (_that) {
case _LayerShadow() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double offsetX,  double offsetY,  double blur,  String color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LayerShadow() when $default != null:
return $default(_that.offsetX,_that.offsetY,_that.blur,_that.color);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double offsetX,  double offsetY,  double blur,  String color)  $default,) {final _that = this;
switch (_that) {
case _LayerShadow():
return $default(_that.offsetX,_that.offsetY,_that.blur,_that.color);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double offsetX,  double offsetY,  double blur,  String color)?  $default,) {final _that = this;
switch (_that) {
case _LayerShadow() when $default != null:
return $default(_that.offsetX,_that.offsetY,_that.blur,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LayerShadow implements LayerShadow {
  const _LayerShadow({this.offsetX = 0, this.offsetY = 2, this.blur = 4, this.color = '#00000040'});
  factory _LayerShadow.fromJson(Map<String, dynamic> json) => _$LayerShadowFromJson(json);

@override@JsonKey() final  double offsetX;
@override@JsonKey() final  double offsetY;
@override@JsonKey() final  double blur;
@override@JsonKey() final  String color;

/// Create a copy of LayerShadow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayerShadowCopyWith<_LayerShadow> get copyWith => __$LayerShadowCopyWithImpl<_LayerShadow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LayerShadowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayerShadow&&(identical(other.offsetX, offsetX) || other.offsetX == offsetX)&&(identical(other.offsetY, offsetY) || other.offsetY == offsetY)&&(identical(other.blur, blur) || other.blur == blur)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,offsetX,offsetY,blur,color);

@override
String toString() {
  return 'LayerShadow(offsetX: $offsetX, offsetY: $offsetY, blur: $blur, color: $color)';
}


}

/// @nodoc
abstract mixin class _$LayerShadowCopyWith<$Res> implements $LayerShadowCopyWith<$Res> {
  factory _$LayerShadowCopyWith(_LayerShadow value, $Res Function(_LayerShadow) _then) = __$LayerShadowCopyWithImpl;
@override @useResult
$Res call({
 double offsetX, double offsetY, double blur, String color
});




}
/// @nodoc
class __$LayerShadowCopyWithImpl<$Res>
    implements _$LayerShadowCopyWith<$Res> {
  __$LayerShadowCopyWithImpl(this._self, this._then);

  final _LayerShadow _self;
  final $Res Function(_LayerShadow) _then;

/// Create a copy of LayerShadow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? offsetX = null,Object? offsetY = null,Object? blur = null,Object? color = null,}) {
  return _then(_LayerShadow(
offsetX: null == offsetX ? _self.offsetX : offsetX // ignore: cast_nullable_to_non_nullable
as double,offsetY: null == offsetY ? _self.offsetY : offsetY // ignore: cast_nullable_to_non_nullable
as double,blur: null == blur ? _self.blur : blur // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LayerAnimation {

 AnimationType get type; AnimationDirection? get direction; int get duration; int get delay;
/// Create a copy of LayerAnimation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayerAnimationCopyWith<LayerAnimation> get copyWith => _$LayerAnimationCopyWithImpl<LayerAnimation>(this as LayerAnimation, _$identity);

  /// Serializes this LayerAnimation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayerAnimation&&(identical(other.type, type) || other.type == type)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.delay, delay) || other.delay == delay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,direction,duration,delay);

@override
String toString() {
  return 'LayerAnimation(type: $type, direction: $direction, duration: $duration, delay: $delay)';
}


}

/// @nodoc
abstract mixin class $LayerAnimationCopyWith<$Res>  {
  factory $LayerAnimationCopyWith(LayerAnimation value, $Res Function(LayerAnimation) _then) = _$LayerAnimationCopyWithImpl;
@useResult
$Res call({
 AnimationType type, AnimationDirection? direction, int duration, int delay
});




}
/// @nodoc
class _$LayerAnimationCopyWithImpl<$Res>
    implements $LayerAnimationCopyWith<$Res> {
  _$LayerAnimationCopyWithImpl(this._self, this._then);

  final LayerAnimation _self;
  final $Res Function(LayerAnimation) _then;

/// Create a copy of LayerAnimation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? direction = freezed,Object? duration = null,Object? delay = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AnimationType,direction: freezed == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as AnimationDirection?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,delay: null == delay ? _self.delay : delay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LayerAnimation].
extension LayerAnimationPatterns on LayerAnimation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayerAnimation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayerAnimation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayerAnimation value)  $default,){
final _that = this;
switch (_that) {
case _LayerAnimation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayerAnimation value)?  $default,){
final _that = this;
switch (_that) {
case _LayerAnimation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnimationType type,  AnimationDirection? direction,  int duration,  int delay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LayerAnimation() when $default != null:
return $default(_that.type,_that.direction,_that.duration,_that.delay);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnimationType type,  AnimationDirection? direction,  int duration,  int delay)  $default,) {final _that = this;
switch (_that) {
case _LayerAnimation():
return $default(_that.type,_that.direction,_that.duration,_that.delay);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnimationType type,  AnimationDirection? direction,  int duration,  int delay)?  $default,) {final _that = this;
switch (_that) {
case _LayerAnimation() when $default != null:
return $default(_that.type,_that.direction,_that.duration,_that.delay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LayerAnimation implements LayerAnimation {
  const _LayerAnimation({this.type = AnimationType.none, this.direction, this.duration = 500, this.delay = 0});
  factory _LayerAnimation.fromJson(Map<String, dynamic> json) => _$LayerAnimationFromJson(json);

@override@JsonKey() final  AnimationType type;
@override final  AnimationDirection? direction;
@override@JsonKey() final  int duration;
@override@JsonKey() final  int delay;

/// Create a copy of LayerAnimation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayerAnimationCopyWith<_LayerAnimation> get copyWith => __$LayerAnimationCopyWithImpl<_LayerAnimation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LayerAnimationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayerAnimation&&(identical(other.type, type) || other.type == type)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.delay, delay) || other.delay == delay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,direction,duration,delay);

@override
String toString() {
  return 'LayerAnimation(type: $type, direction: $direction, duration: $duration, delay: $delay)';
}


}

/// @nodoc
abstract mixin class _$LayerAnimationCopyWith<$Res> implements $LayerAnimationCopyWith<$Res> {
  factory _$LayerAnimationCopyWith(_LayerAnimation value, $Res Function(_LayerAnimation) _then) = __$LayerAnimationCopyWithImpl;
@override @useResult
$Res call({
 AnimationType type, AnimationDirection? direction, int duration, int delay
});




}
/// @nodoc
class __$LayerAnimationCopyWithImpl<$Res>
    implements _$LayerAnimationCopyWith<$Res> {
  __$LayerAnimationCopyWithImpl(this._self, this._then);

  final _LayerAnimation _self;
  final $Res Function(_LayerAnimation) _then;

/// Create a copy of LayerAnimation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? direction = freezed,Object? duration = null,Object? delay = null,}) {
  return _then(_LayerAnimation(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AnimationType,direction: freezed == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as AnimationDirection?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,delay: null == delay ? _self.delay : delay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TextContent {

 String get text; String get fontFamily; double get fontSize; String get color;@TextAlignConverter() TextAlign get alignment;@FontWeightConverter() FontWeight get fontWeight; LayerShadow? get shadow; double get strokeWidth; String get strokeColor;
/// Create a copy of TextContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextContentCopyWith<TextContent> get copyWith => _$TextContentCopyWithImpl<TextContent>(this as TextContent, _$identity);

  /// Serializes this TextContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextContent&&(identical(other.text, text) || other.text == text)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.color, color) || other.color == color)&&(identical(other.alignment, alignment) || other.alignment == alignment)&&(identical(other.fontWeight, fontWeight) || other.fontWeight == fontWeight)&&(identical(other.shadow, shadow) || other.shadow == shadow)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.strokeColor, strokeColor) || other.strokeColor == strokeColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,fontFamily,fontSize,color,alignment,fontWeight,shadow,strokeWidth,strokeColor);

@override
String toString() {
  return 'TextContent(text: $text, fontFamily: $fontFamily, fontSize: $fontSize, color: $color, alignment: $alignment, fontWeight: $fontWeight, shadow: $shadow, strokeWidth: $strokeWidth, strokeColor: $strokeColor)';
}


}

/// @nodoc
abstract mixin class $TextContentCopyWith<$Res>  {
  factory $TextContentCopyWith(TextContent value, $Res Function(TextContent) _then) = _$TextContentCopyWithImpl;
@useResult
$Res call({
 String text, String fontFamily, double fontSize, String color,@TextAlignConverter() TextAlign alignment,@FontWeightConverter() FontWeight fontWeight, LayerShadow? shadow, double strokeWidth, String strokeColor
});


$LayerShadowCopyWith<$Res>? get shadow;

}
/// @nodoc
class _$TextContentCopyWithImpl<$Res>
    implements $TextContentCopyWith<$Res> {
  _$TextContentCopyWithImpl(this._self, this._then);

  final TextContent _self;
  final $Res Function(TextContent) _then;

/// Create a copy of TextContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? fontFamily = null,Object? fontSize = null,Object? color = null,Object? alignment = null,Object? fontWeight = null,Object? shadow = freezed,Object? strokeWidth = null,Object? strokeColor = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,alignment: null == alignment ? _self.alignment : alignment // ignore: cast_nullable_to_non_nullable
as TextAlign,fontWeight: null == fontWeight ? _self.fontWeight : fontWeight // ignore: cast_nullable_to_non_nullable
as FontWeight,shadow: freezed == shadow ? _self.shadow : shadow // ignore: cast_nullable_to_non_nullable
as LayerShadow?,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,strokeColor: null == strokeColor ? _self.strokeColor : strokeColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of TextContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LayerShadowCopyWith<$Res>? get shadow {
    if (_self.shadow == null) {
    return null;
  }

  return $LayerShadowCopyWith<$Res>(_self.shadow!, (value) {
    return _then(_self.copyWith(shadow: value));
  });
}
}


/// Adds pattern-matching-related methods to [TextContent].
extension TextContentPatterns on TextContent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextContent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextContent value)  $default,){
final _that = this;
switch (_that) {
case _TextContent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextContent value)?  $default,){
final _that = this;
switch (_that) {
case _TextContent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String fontFamily,  double fontSize,  String color, @TextAlignConverter()  TextAlign alignment, @FontWeightConverter()  FontWeight fontWeight,  LayerShadow? shadow,  double strokeWidth,  String strokeColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextContent() when $default != null:
return $default(_that.text,_that.fontFamily,_that.fontSize,_that.color,_that.alignment,_that.fontWeight,_that.shadow,_that.strokeWidth,_that.strokeColor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String fontFamily,  double fontSize,  String color, @TextAlignConverter()  TextAlign alignment, @FontWeightConverter()  FontWeight fontWeight,  LayerShadow? shadow,  double strokeWidth,  String strokeColor)  $default,) {final _that = this;
switch (_that) {
case _TextContent():
return $default(_that.text,_that.fontFamily,_that.fontSize,_that.color,_that.alignment,_that.fontWeight,_that.shadow,_that.strokeWidth,_that.strokeColor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String fontFamily,  double fontSize,  String color, @TextAlignConverter()  TextAlign alignment, @FontWeightConverter()  FontWeight fontWeight,  LayerShadow? shadow,  double strokeWidth,  String strokeColor)?  $default,) {final _that = this;
switch (_that) {
case _TextContent() when $default != null:
return $default(_that.text,_that.fontFamily,_that.fontSize,_that.color,_that.alignment,_that.fontWeight,_that.shadow,_that.strokeWidth,_that.strokeColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextContent implements TextContent {
  const _TextContent({this.text = 'نص جديد', this.fontFamily = 'Cairo', this.fontSize = 48, this.color = '#FFFFFF', @TextAlignConverter() this.alignment = TextAlign.center, @FontWeightConverter() this.fontWeight = FontWeight.bold, this.shadow, this.strokeWidth = 0, this.strokeColor = '#000000'});
  factory _TextContent.fromJson(Map<String, dynamic> json) => _$TextContentFromJson(json);

@override@JsonKey() final  String text;
@override@JsonKey() final  String fontFamily;
@override@JsonKey() final  double fontSize;
@override@JsonKey() final  String color;
@override@JsonKey()@TextAlignConverter() final  TextAlign alignment;
@override@JsonKey()@FontWeightConverter() final  FontWeight fontWeight;
@override final  LayerShadow? shadow;
@override@JsonKey() final  double strokeWidth;
@override@JsonKey() final  String strokeColor;

/// Create a copy of TextContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextContentCopyWith<_TextContent> get copyWith => __$TextContentCopyWithImpl<_TextContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextContent&&(identical(other.text, text) || other.text == text)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.color, color) || other.color == color)&&(identical(other.alignment, alignment) || other.alignment == alignment)&&(identical(other.fontWeight, fontWeight) || other.fontWeight == fontWeight)&&(identical(other.shadow, shadow) || other.shadow == shadow)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.strokeColor, strokeColor) || other.strokeColor == strokeColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,fontFamily,fontSize,color,alignment,fontWeight,shadow,strokeWidth,strokeColor);

@override
String toString() {
  return 'TextContent(text: $text, fontFamily: $fontFamily, fontSize: $fontSize, color: $color, alignment: $alignment, fontWeight: $fontWeight, shadow: $shadow, strokeWidth: $strokeWidth, strokeColor: $strokeColor)';
}


}

/// @nodoc
abstract mixin class _$TextContentCopyWith<$Res> implements $TextContentCopyWith<$Res> {
  factory _$TextContentCopyWith(_TextContent value, $Res Function(_TextContent) _then) = __$TextContentCopyWithImpl;
@override @useResult
$Res call({
 String text, String fontFamily, double fontSize, String color,@TextAlignConverter() TextAlign alignment,@FontWeightConverter() FontWeight fontWeight, LayerShadow? shadow, double strokeWidth, String strokeColor
});


@override $LayerShadowCopyWith<$Res>? get shadow;

}
/// @nodoc
class __$TextContentCopyWithImpl<$Res>
    implements _$TextContentCopyWith<$Res> {
  __$TextContentCopyWithImpl(this._self, this._then);

  final _TextContent _self;
  final $Res Function(_TextContent) _then;

/// Create a copy of TextContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? fontFamily = null,Object? fontSize = null,Object? color = null,Object? alignment = null,Object? fontWeight = null,Object? shadow = freezed,Object? strokeWidth = null,Object? strokeColor = null,}) {
  return _then(_TextContent(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,alignment: null == alignment ? _self.alignment : alignment // ignore: cast_nullable_to_non_nullable
as TextAlign,fontWeight: null == fontWeight ? _self.fontWeight : fontWeight // ignore: cast_nullable_to_non_nullable
as FontWeight,shadow: freezed == shadow ? _self.shadow : shadow // ignore: cast_nullable_to_non_nullable
as LayerShadow?,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,strokeColor: null == strokeColor ? _self.strokeColor : strokeColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of TextContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LayerShadowCopyWith<$Res>? get shadow {
    if (_self.shadow == null) {
    return null;
  }

  return $LayerShadowCopyWith<$Res>(_self.shadow!, (value) {
    return _then(_self.copyWith(shadow: value));
  });
}
}


/// @nodoc
mixin _$ImageContent {

 String get url;@BoxFitConverter() BoxFit get fit; double get borderRadius; double get opacity;
/// Create a copy of ImageContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageContentCopyWith<ImageContent> get copyWith => _$ImageContentCopyWithImpl<ImageContent>(this as ImageContent, _$identity);

  /// Serializes this ImageContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageContent&&(identical(other.url, url) || other.url == url)&&(identical(other.fit, fit) || other.fit == fit)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.opacity, opacity) || other.opacity == opacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,fit,borderRadius,opacity);

@override
String toString() {
  return 'ImageContent(url: $url, fit: $fit, borderRadius: $borderRadius, opacity: $opacity)';
}


}

/// @nodoc
abstract mixin class $ImageContentCopyWith<$Res>  {
  factory $ImageContentCopyWith(ImageContent value, $Res Function(ImageContent) _then) = _$ImageContentCopyWithImpl;
@useResult
$Res call({
 String url,@BoxFitConverter() BoxFit fit, double borderRadius, double opacity
});




}
/// @nodoc
class _$ImageContentCopyWithImpl<$Res>
    implements $ImageContentCopyWith<$Res> {
  _$ImageContentCopyWithImpl(this._self, this._then);

  final ImageContent _self;
  final $Res Function(ImageContent) _then;

/// Create a copy of ImageContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? fit = null,Object? borderRadius = null,Object? opacity = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,fit: null == fit ? _self.fit : fit // ignore: cast_nullable_to_non_nullable
as BoxFit,borderRadius: null == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageContent].
extension ImageContentPatterns on ImageContent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageContent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageContent value)  $default,){
final _that = this;
switch (_that) {
case _ImageContent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageContent value)?  $default,){
final _that = this;
switch (_that) {
case _ImageContent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url, @BoxFitConverter()  BoxFit fit,  double borderRadius,  double opacity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageContent() when $default != null:
return $default(_that.url,_that.fit,_that.borderRadius,_that.opacity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url, @BoxFitConverter()  BoxFit fit,  double borderRadius,  double opacity)  $default,) {final _that = this;
switch (_that) {
case _ImageContent():
return $default(_that.url,_that.fit,_that.borderRadius,_that.opacity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url, @BoxFitConverter()  BoxFit fit,  double borderRadius,  double opacity)?  $default,) {final _that = this;
switch (_that) {
case _ImageContent() when $default != null:
return $default(_that.url,_that.fit,_that.borderRadius,_that.opacity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageContent implements ImageContent {
  const _ImageContent({required this.url, @BoxFitConverter() this.fit = BoxFit.cover, this.borderRadius = 0, this.opacity = 1.0});
  factory _ImageContent.fromJson(Map<String, dynamic> json) => _$ImageContentFromJson(json);

@override final  String url;
@override@JsonKey()@BoxFitConverter() final  BoxFit fit;
@override@JsonKey() final  double borderRadius;
@override@JsonKey() final  double opacity;

/// Create a copy of ImageContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageContentCopyWith<_ImageContent> get copyWith => __$ImageContentCopyWithImpl<_ImageContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageContent&&(identical(other.url, url) || other.url == url)&&(identical(other.fit, fit) || other.fit == fit)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.opacity, opacity) || other.opacity == opacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,fit,borderRadius,opacity);

@override
String toString() {
  return 'ImageContent(url: $url, fit: $fit, borderRadius: $borderRadius, opacity: $opacity)';
}


}

/// @nodoc
abstract mixin class _$ImageContentCopyWith<$Res> implements $ImageContentCopyWith<$Res> {
  factory _$ImageContentCopyWith(_ImageContent value, $Res Function(_ImageContent) _then) = __$ImageContentCopyWithImpl;
@override @useResult
$Res call({
 String url,@BoxFitConverter() BoxFit fit, double borderRadius, double opacity
});




}
/// @nodoc
class __$ImageContentCopyWithImpl<$Res>
    implements _$ImageContentCopyWith<$Res> {
  __$ImageContentCopyWithImpl(this._self, this._then);

  final _ImageContent _self;
  final $Res Function(_ImageContent) _then;

/// Create a copy of ImageContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? fit = null,Object? borderRadius = null,Object? opacity = null,}) {
  return _then(_ImageContent(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,fit: null == fit ? _self.fit : fit // ignore: cast_nullable_to_non_nullable
as BoxFit,borderRadius: null == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ShapeContent {

 ShapeType get type; String get color; double get borderRadius; double get strokeWidth; String get strokeColor;
/// Create a copy of ShapeContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeContentCopyWith<ShapeContent> get copyWith => _$ShapeContentCopyWithImpl<ShapeContent>(this as ShapeContent, _$identity);

  /// Serializes this ShapeContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeContent&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.strokeColor, strokeColor) || other.strokeColor == strokeColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,color,borderRadius,strokeWidth,strokeColor);

@override
String toString() {
  return 'ShapeContent(type: $type, color: $color, borderRadius: $borderRadius, strokeWidth: $strokeWidth, strokeColor: $strokeColor)';
}


}

/// @nodoc
abstract mixin class $ShapeContentCopyWith<$Res>  {
  factory $ShapeContentCopyWith(ShapeContent value, $Res Function(ShapeContent) _then) = _$ShapeContentCopyWithImpl;
@useResult
$Res call({
 ShapeType type, String color, double borderRadius, double strokeWidth, String strokeColor
});




}
/// @nodoc
class _$ShapeContentCopyWithImpl<$Res>
    implements $ShapeContentCopyWith<$Res> {
  _$ShapeContentCopyWithImpl(this._self, this._then);

  final ShapeContent _self;
  final $Res Function(ShapeContent) _then;

/// Create a copy of ShapeContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? color = null,Object? borderRadius = null,Object? strokeWidth = null,Object? strokeColor = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ShapeType,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,borderRadius: null == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,strokeColor: null == strokeColor ? _self.strokeColor : strokeColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ShapeContent].
extension ShapeContentPatterns on ShapeContent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShapeContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShapeContent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShapeContent value)  $default,){
final _that = this;
switch (_that) {
case _ShapeContent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShapeContent value)?  $default,){
final _that = this;
switch (_that) {
case _ShapeContent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ShapeType type,  String color,  double borderRadius,  double strokeWidth,  String strokeColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShapeContent() when $default != null:
return $default(_that.type,_that.color,_that.borderRadius,_that.strokeWidth,_that.strokeColor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ShapeType type,  String color,  double borderRadius,  double strokeWidth,  String strokeColor)  $default,) {final _that = this;
switch (_that) {
case _ShapeContent():
return $default(_that.type,_that.color,_that.borderRadius,_that.strokeWidth,_that.strokeColor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ShapeType type,  String color,  double borderRadius,  double strokeWidth,  String strokeColor)?  $default,) {final _that = this;
switch (_that) {
case _ShapeContent() when $default != null:
return $default(_that.type,_that.color,_that.borderRadius,_that.strokeWidth,_that.strokeColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShapeContent implements ShapeContent {
  const _ShapeContent({this.type = ShapeType.rectangle, this.color = '#007AFF', this.borderRadius = 0, this.strokeWidth = 0, this.strokeColor = '#000000'});
  factory _ShapeContent.fromJson(Map<String, dynamic> json) => _$ShapeContentFromJson(json);

@override@JsonKey() final  ShapeType type;
@override@JsonKey() final  String color;
@override@JsonKey() final  double borderRadius;
@override@JsonKey() final  double strokeWidth;
@override@JsonKey() final  String strokeColor;

/// Create a copy of ShapeContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShapeContentCopyWith<_ShapeContent> get copyWith => __$ShapeContentCopyWithImpl<_ShapeContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShapeContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShapeContent&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.strokeColor, strokeColor) || other.strokeColor == strokeColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,color,borderRadius,strokeWidth,strokeColor);

@override
String toString() {
  return 'ShapeContent(type: $type, color: $color, borderRadius: $borderRadius, strokeWidth: $strokeWidth, strokeColor: $strokeColor)';
}


}

/// @nodoc
abstract mixin class _$ShapeContentCopyWith<$Res> implements $ShapeContentCopyWith<$Res> {
  factory _$ShapeContentCopyWith(_ShapeContent value, $Res Function(_ShapeContent) _then) = __$ShapeContentCopyWithImpl;
@override @useResult
$Res call({
 ShapeType type, String color, double borderRadius, double strokeWidth, String strokeColor
});




}
/// @nodoc
class __$ShapeContentCopyWithImpl<$Res>
    implements _$ShapeContentCopyWith<$Res> {
  __$ShapeContentCopyWithImpl(this._self, this._then);

  final _ShapeContent _self;
  final $Res Function(_ShapeContent) _then;

/// Create a copy of ShapeContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? color = null,Object? borderRadius = null,Object? strokeWidth = null,Object? strokeColor = null,}) {
  return _then(_ShapeContent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ShapeType,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,borderRadius: null == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,strokeColor: null == strokeColor ? _self.strokeColor : strokeColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$VideoContent {

 String get url;@BoxFitConverter() BoxFit get fit; bool get loop; bool get autoplay; bool get muted;
/// Create a copy of VideoContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoContentCopyWith<VideoContent> get copyWith => _$VideoContentCopyWithImpl<VideoContent>(this as VideoContent, _$identity);

  /// Serializes this VideoContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoContent&&(identical(other.url, url) || other.url == url)&&(identical(other.fit, fit) || other.fit == fit)&&(identical(other.loop, loop) || other.loop == loop)&&(identical(other.autoplay, autoplay) || other.autoplay == autoplay)&&(identical(other.muted, muted) || other.muted == muted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,fit,loop,autoplay,muted);

@override
String toString() {
  return 'VideoContent(url: $url, fit: $fit, loop: $loop, autoplay: $autoplay, muted: $muted)';
}


}

/// @nodoc
abstract mixin class $VideoContentCopyWith<$Res>  {
  factory $VideoContentCopyWith(VideoContent value, $Res Function(VideoContent) _then) = _$VideoContentCopyWithImpl;
@useResult
$Res call({
 String url,@BoxFitConverter() BoxFit fit, bool loop, bool autoplay, bool muted
});




}
/// @nodoc
class _$VideoContentCopyWithImpl<$Res>
    implements $VideoContentCopyWith<$Res> {
  _$VideoContentCopyWithImpl(this._self, this._then);

  final VideoContent _self;
  final $Res Function(VideoContent) _then;

/// Create a copy of VideoContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? fit = null,Object? loop = null,Object? autoplay = null,Object? muted = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,fit: null == fit ? _self.fit : fit // ignore: cast_nullable_to_non_nullable
as BoxFit,loop: null == loop ? _self.loop : loop // ignore: cast_nullable_to_non_nullable
as bool,autoplay: null == autoplay ? _self.autoplay : autoplay // ignore: cast_nullable_to_non_nullable
as bool,muted: null == muted ? _self.muted : muted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoContent].
extension VideoContentPatterns on VideoContent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoContent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoContent value)  $default,){
final _that = this;
switch (_that) {
case _VideoContent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoContent value)?  $default,){
final _that = this;
switch (_that) {
case _VideoContent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url, @BoxFitConverter()  BoxFit fit,  bool loop,  bool autoplay,  bool muted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoContent() when $default != null:
return $default(_that.url,_that.fit,_that.loop,_that.autoplay,_that.muted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url, @BoxFitConverter()  BoxFit fit,  bool loop,  bool autoplay,  bool muted)  $default,) {final _that = this;
switch (_that) {
case _VideoContent():
return $default(_that.url,_that.fit,_that.loop,_that.autoplay,_that.muted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url, @BoxFitConverter()  BoxFit fit,  bool loop,  bool autoplay,  bool muted)?  $default,) {final _that = this;
switch (_that) {
case _VideoContent() when $default != null:
return $default(_that.url,_that.fit,_that.loop,_that.autoplay,_that.muted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoContent implements VideoContent {
  const _VideoContent({required this.url, @BoxFitConverter() this.fit = BoxFit.cover, this.loop = true, this.autoplay = true, this.muted = false});
  factory _VideoContent.fromJson(Map<String, dynamic> json) => _$VideoContentFromJson(json);

@override final  String url;
@override@JsonKey()@BoxFitConverter() final  BoxFit fit;
@override@JsonKey() final  bool loop;
@override@JsonKey() final  bool autoplay;
@override@JsonKey() final  bool muted;

/// Create a copy of VideoContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoContentCopyWith<_VideoContent> get copyWith => __$VideoContentCopyWithImpl<_VideoContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoContent&&(identical(other.url, url) || other.url == url)&&(identical(other.fit, fit) || other.fit == fit)&&(identical(other.loop, loop) || other.loop == loop)&&(identical(other.autoplay, autoplay) || other.autoplay == autoplay)&&(identical(other.muted, muted) || other.muted == muted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,fit,loop,autoplay,muted);

@override
String toString() {
  return 'VideoContent(url: $url, fit: $fit, loop: $loop, autoplay: $autoplay, muted: $muted)';
}


}

/// @nodoc
abstract mixin class _$VideoContentCopyWith<$Res> implements $VideoContentCopyWith<$Res> {
  factory _$VideoContentCopyWith(_VideoContent value, $Res Function(_VideoContent) _then) = __$VideoContentCopyWithImpl;
@override @useResult
$Res call({
 String url,@BoxFitConverter() BoxFit fit, bool loop, bool autoplay, bool muted
});




}
/// @nodoc
class __$VideoContentCopyWithImpl<$Res>
    implements _$VideoContentCopyWith<$Res> {
  __$VideoContentCopyWithImpl(this._self, this._then);

  final _VideoContent _self;
  final $Res Function(_VideoContent) _then;

/// Create a copy of VideoContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? fit = null,Object? loop = null,Object? autoplay = null,Object? muted = null,}) {
  return _then(_VideoContent(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,fit: null == fit ? _self.fit : fit // ignore: cast_nullable_to_non_nullable
as BoxFit,loop: null == loop ? _self.loop : loop // ignore: cast_nullable_to_non_nullable
as bool,autoplay: null == autoplay ? _self.autoplay : autoplay // ignore: cast_nullable_to_non_nullable
as bool,muted: null == muted ? _self.muted : muted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

LayerContent _$LayerContentFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'text':
          return TextLayerContent.fromJson(
            json
          );
                case 'image':
          return ImageLayerContent.fromJson(
            json
          );
                case 'shape':
          return ShapeLayerContent.fromJson(
            json
          );
                case 'video':
          return VideoLayerContent.fromJson(
            json
          );
                case 'empty':
          return EmptyLayerContent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'LayerContent',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$LayerContent {



  /// Serializes this LayerContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayerContent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LayerContent()';
}


}

/// @nodoc
class $LayerContentCopyWith<$Res>  {
$LayerContentCopyWith(LayerContent _, $Res Function(LayerContent) __);
}


/// Adds pattern-matching-related methods to [LayerContent].
extension LayerContentPatterns on LayerContent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextLayerContent value)?  text,TResult Function( ImageLayerContent value)?  image,TResult Function( ShapeLayerContent value)?  shape,TResult Function( VideoLayerContent value)?  video,TResult Function( EmptyLayerContent value)?  empty,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextLayerContent() when text != null:
return text(_that);case ImageLayerContent() when image != null:
return image(_that);case ShapeLayerContent() when shape != null:
return shape(_that);case VideoLayerContent() when video != null:
return video(_that);case EmptyLayerContent() when empty != null:
return empty(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextLayerContent value)  text,required TResult Function( ImageLayerContent value)  image,required TResult Function( ShapeLayerContent value)  shape,required TResult Function( VideoLayerContent value)  video,required TResult Function( EmptyLayerContent value)  empty,}){
final _that = this;
switch (_that) {
case TextLayerContent():
return text(_that);case ImageLayerContent():
return image(_that);case ShapeLayerContent():
return shape(_that);case VideoLayerContent():
return video(_that);case EmptyLayerContent():
return empty(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextLayerContent value)?  text,TResult? Function( ImageLayerContent value)?  image,TResult? Function( ShapeLayerContent value)?  shape,TResult? Function( VideoLayerContent value)?  video,TResult? Function( EmptyLayerContent value)?  empty,}){
final _that = this;
switch (_that) {
case TextLayerContent() when text != null:
return text(_that);case ImageLayerContent() when image != null:
return image(_that);case ShapeLayerContent() when shape != null:
return shape(_that);case VideoLayerContent() when video != null:
return video(_that);case EmptyLayerContent() when empty != null:
return empty(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TextContent data)?  text,TResult Function( ImageContent data)?  image,TResult Function( ShapeContent data)?  shape,TResult Function( VideoContent data)?  video,TResult Function()?  empty,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextLayerContent() when text != null:
return text(_that.data);case ImageLayerContent() when image != null:
return image(_that.data);case ShapeLayerContent() when shape != null:
return shape(_that.data);case VideoLayerContent() when video != null:
return video(_that.data);case EmptyLayerContent() when empty != null:
return empty();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TextContent data)  text,required TResult Function( ImageContent data)  image,required TResult Function( ShapeContent data)  shape,required TResult Function( VideoContent data)  video,required TResult Function()  empty,}) {final _that = this;
switch (_that) {
case TextLayerContent():
return text(_that.data);case ImageLayerContent():
return image(_that.data);case ShapeLayerContent():
return shape(_that.data);case VideoLayerContent():
return video(_that.data);case EmptyLayerContent():
return empty();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TextContent data)?  text,TResult? Function( ImageContent data)?  image,TResult? Function( ShapeContent data)?  shape,TResult? Function( VideoContent data)?  video,TResult? Function()?  empty,}) {final _that = this;
switch (_that) {
case TextLayerContent() when text != null:
return text(_that.data);case ImageLayerContent() when image != null:
return image(_that.data);case ShapeLayerContent() when shape != null:
return shape(_that.data);case VideoLayerContent() when video != null:
return video(_that.data);case EmptyLayerContent() when empty != null:
return empty();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TextLayerContent implements LayerContent {
  const TextLayerContent(this.data, {final  String? $type}): $type = $type ?? 'text';
  factory TextLayerContent.fromJson(Map<String, dynamic> json) => _$TextLayerContentFromJson(json);

 final  TextContent data;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextLayerContentCopyWith<TextLayerContent> get copyWith => _$TextLayerContentCopyWithImpl<TextLayerContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextLayerContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextLayerContent&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'LayerContent.text(data: $data)';
}


}

/// @nodoc
abstract mixin class $TextLayerContentCopyWith<$Res> implements $LayerContentCopyWith<$Res> {
  factory $TextLayerContentCopyWith(TextLayerContent value, $Res Function(TextLayerContent) _then) = _$TextLayerContentCopyWithImpl;
@useResult
$Res call({
 TextContent data
});


$TextContentCopyWith<$Res> get data;

}
/// @nodoc
class _$TextLayerContentCopyWithImpl<$Res>
    implements $TextLayerContentCopyWith<$Res> {
  _$TextLayerContentCopyWithImpl(this._self, this._then);

  final TextLayerContent _self;
  final $Res Function(TextLayerContent) _then;

/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(TextLayerContent(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TextContent,
  ));
}

/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextContentCopyWith<$Res> get data {
  
  return $TextContentCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ImageLayerContent implements LayerContent {
  const ImageLayerContent(this.data, {final  String? $type}): $type = $type ?? 'image';
  factory ImageLayerContent.fromJson(Map<String, dynamic> json) => _$ImageLayerContentFromJson(json);

 final  ImageContent data;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageLayerContentCopyWith<ImageLayerContent> get copyWith => _$ImageLayerContentCopyWithImpl<ImageLayerContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageLayerContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageLayerContent&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'LayerContent.image(data: $data)';
}


}

/// @nodoc
abstract mixin class $ImageLayerContentCopyWith<$Res> implements $LayerContentCopyWith<$Res> {
  factory $ImageLayerContentCopyWith(ImageLayerContent value, $Res Function(ImageLayerContent) _then) = _$ImageLayerContentCopyWithImpl;
@useResult
$Res call({
 ImageContent data
});


$ImageContentCopyWith<$Res> get data;

}
/// @nodoc
class _$ImageLayerContentCopyWithImpl<$Res>
    implements $ImageLayerContentCopyWith<$Res> {
  _$ImageLayerContentCopyWithImpl(this._self, this._then);

  final ImageLayerContent _self;
  final $Res Function(ImageLayerContent) _then;

/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ImageLayerContent(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ImageContent,
  ));
}

/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageContentCopyWith<$Res> get data {
  
  return $ImageContentCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ShapeLayerContent implements LayerContent {
  const ShapeLayerContent(this.data, {final  String? $type}): $type = $type ?? 'shape';
  factory ShapeLayerContent.fromJson(Map<String, dynamic> json) => _$ShapeLayerContentFromJson(json);

 final  ShapeContent data;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeLayerContentCopyWith<ShapeLayerContent> get copyWith => _$ShapeLayerContentCopyWithImpl<ShapeLayerContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShapeLayerContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeLayerContent&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'LayerContent.shape(data: $data)';
}


}

/// @nodoc
abstract mixin class $ShapeLayerContentCopyWith<$Res> implements $LayerContentCopyWith<$Res> {
  factory $ShapeLayerContentCopyWith(ShapeLayerContent value, $Res Function(ShapeLayerContent) _then) = _$ShapeLayerContentCopyWithImpl;
@useResult
$Res call({
 ShapeContent data
});


$ShapeContentCopyWith<$Res> get data;

}
/// @nodoc
class _$ShapeLayerContentCopyWithImpl<$Res>
    implements $ShapeLayerContentCopyWith<$Res> {
  _$ShapeLayerContentCopyWithImpl(this._self, this._then);

  final ShapeLayerContent _self;
  final $Res Function(ShapeLayerContent) _then;

/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ShapeLayerContent(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ShapeContent,
  ));
}

/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShapeContentCopyWith<$Res> get data {
  
  return $ShapeContentCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class VideoLayerContent implements LayerContent {
  const VideoLayerContent(this.data, {final  String? $type}): $type = $type ?? 'video';
  factory VideoLayerContent.fromJson(Map<String, dynamic> json) => _$VideoLayerContentFromJson(json);

 final  VideoContent data;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoLayerContentCopyWith<VideoLayerContent> get copyWith => _$VideoLayerContentCopyWithImpl<VideoLayerContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoLayerContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoLayerContent&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'LayerContent.video(data: $data)';
}


}

/// @nodoc
abstract mixin class $VideoLayerContentCopyWith<$Res> implements $LayerContentCopyWith<$Res> {
  factory $VideoLayerContentCopyWith(VideoLayerContent value, $Res Function(VideoLayerContent) _then) = _$VideoLayerContentCopyWithImpl;
@useResult
$Res call({
 VideoContent data
});


$VideoContentCopyWith<$Res> get data;

}
/// @nodoc
class _$VideoLayerContentCopyWithImpl<$Res>
    implements $VideoLayerContentCopyWith<$Res> {
  _$VideoLayerContentCopyWithImpl(this._self, this._then);

  final VideoLayerContent _self;
  final $Res Function(VideoLayerContent) _then;

/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(VideoLayerContent(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as VideoContent,
  ));
}

/// Create a copy of LayerContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoContentCopyWith<$Res> get data {
  
  return $VideoContentCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class EmptyLayerContent implements LayerContent {
  const EmptyLayerContent({final  String? $type}): $type = $type ?? 'empty';
  factory EmptyLayerContent.fromJson(Map<String, dynamic> json) => _$EmptyLayerContentFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$EmptyLayerContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyLayerContent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LayerContent.empty()';
}


}





/// @nodoc
mixin _$Layer {

 String get id; LayerType get type; double get x; double get y; double get width; double get height; double get rotation; double get opacity; LayerContent get content; LayerAnimation? get animation; bool get isVisible; bool get isLocked; int get zIndex;
/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayerCopyWith<Layer> get copyWith => _$LayerCopyWithImpl<Layer>(this as Layer, _$identity);

  /// Serializes this Layer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Layer&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.content, content) || other.content == content)&&(identical(other.animation, animation) || other.animation == animation)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.zIndex, zIndex) || other.zIndex == zIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,x,y,width,height,rotation,opacity,content,animation,isVisible,isLocked,zIndex);

@override
String toString() {
  return 'Layer(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, rotation: $rotation, opacity: $opacity, content: $content, animation: $animation, isVisible: $isVisible, isLocked: $isLocked, zIndex: $zIndex)';
}


}

/// @nodoc
abstract mixin class $LayerCopyWith<$Res>  {
  factory $LayerCopyWith(Layer value, $Res Function(Layer) _then) = _$LayerCopyWithImpl;
@useResult
$Res call({
 String id, LayerType type, double x, double y, double width, double height, double rotation, double opacity, LayerContent content, LayerAnimation? animation, bool isVisible, bool isLocked, int zIndex
});


$LayerContentCopyWith<$Res> get content;$LayerAnimationCopyWith<$Res>? get animation;

}
/// @nodoc
class _$LayerCopyWithImpl<$Res>
    implements $LayerCopyWith<$Res> {
  _$LayerCopyWithImpl(this._self, this._then);

  final Layer _self;
  final $Res Function(Layer) _then;

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? rotation = null,Object? opacity = null,Object? content = null,Object? animation = freezed,Object? isVisible = null,Object? isLocked = null,Object? zIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LayerType,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as LayerContent,animation: freezed == animation ? _self.animation : animation // ignore: cast_nullable_to_non_nullable
as LayerAnimation?,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,zIndex: null == zIndex ? _self.zIndex : zIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LayerContentCopyWith<$Res> get content {
  
  return $LayerContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LayerAnimationCopyWith<$Res>? get animation {
    if (_self.animation == null) {
    return null;
  }

  return $LayerAnimationCopyWith<$Res>(_self.animation!, (value) {
    return _then(_self.copyWith(animation: value));
  });
}
}


/// Adds pattern-matching-related methods to [Layer].
extension LayerPatterns on Layer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Layer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Layer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Layer value)  $default,){
final _that = this;
switch (_that) {
case _Layer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Layer value)?  $default,){
final _that = this;
switch (_that) {
case _Layer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LayerType type,  double x,  double y,  double width,  double height,  double rotation,  double opacity,  LayerContent content,  LayerAnimation? animation,  bool isVisible,  bool isLocked,  int zIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Layer() when $default != null:
return $default(_that.id,_that.type,_that.x,_that.y,_that.width,_that.height,_that.rotation,_that.opacity,_that.content,_that.animation,_that.isVisible,_that.isLocked,_that.zIndex);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LayerType type,  double x,  double y,  double width,  double height,  double rotation,  double opacity,  LayerContent content,  LayerAnimation? animation,  bool isVisible,  bool isLocked,  int zIndex)  $default,) {final _that = this;
switch (_that) {
case _Layer():
return $default(_that.id,_that.type,_that.x,_that.y,_that.width,_that.height,_that.rotation,_that.opacity,_that.content,_that.animation,_that.isVisible,_that.isLocked,_that.zIndex);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LayerType type,  double x,  double y,  double width,  double height,  double rotation,  double opacity,  LayerContent content,  LayerAnimation? animation,  bool isVisible,  bool isLocked,  int zIndex)?  $default,) {final _that = this;
switch (_that) {
case _Layer() when $default != null:
return $default(_that.id,_that.type,_that.x,_that.y,_that.width,_that.height,_that.rotation,_that.opacity,_that.content,_that.animation,_that.isVisible,_that.isLocked,_that.zIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Layer extends Layer {
  const _Layer({required this.id, this.type = LayerType.text, this.x = 0, this.y = 0, this.width = 100, this.height = 50, this.rotation = 0, this.opacity = 1.0, this.content = const LayerContent.empty(), this.animation, this.isVisible = true, this.isLocked = false, this.zIndex = 0}): super._();
  factory _Layer.fromJson(Map<String, dynamic> json) => _$LayerFromJson(json);

@override final  String id;
@override@JsonKey() final  LayerType type;
@override@JsonKey() final  double x;
@override@JsonKey() final  double y;
@override@JsonKey() final  double width;
@override@JsonKey() final  double height;
@override@JsonKey() final  double rotation;
@override@JsonKey() final  double opacity;
@override@JsonKey() final  LayerContent content;
@override final  LayerAnimation? animation;
@override@JsonKey() final  bool isVisible;
@override@JsonKey() final  bool isLocked;
@override@JsonKey() final  int zIndex;

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayerCopyWith<_Layer> get copyWith => __$LayerCopyWithImpl<_Layer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Layer&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.content, content) || other.content == content)&&(identical(other.animation, animation) || other.animation == animation)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.zIndex, zIndex) || other.zIndex == zIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,x,y,width,height,rotation,opacity,content,animation,isVisible,isLocked,zIndex);

@override
String toString() {
  return 'Layer(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, rotation: $rotation, opacity: $opacity, content: $content, animation: $animation, isVisible: $isVisible, isLocked: $isLocked, zIndex: $zIndex)';
}


}

/// @nodoc
abstract mixin class _$LayerCopyWith<$Res> implements $LayerCopyWith<$Res> {
  factory _$LayerCopyWith(_Layer value, $Res Function(_Layer) _then) = __$LayerCopyWithImpl;
@override @useResult
$Res call({
 String id, LayerType type, double x, double y, double width, double height, double rotation, double opacity, LayerContent content, LayerAnimation? animation, bool isVisible, bool isLocked, int zIndex
});


@override $LayerContentCopyWith<$Res> get content;@override $LayerAnimationCopyWith<$Res>? get animation;

}
/// @nodoc
class __$LayerCopyWithImpl<$Res>
    implements _$LayerCopyWith<$Res> {
  __$LayerCopyWithImpl(this._self, this._then);

  final _Layer _self;
  final $Res Function(_Layer) _then;

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? rotation = null,Object? opacity = null,Object? content = null,Object? animation = freezed,Object? isVisible = null,Object? isLocked = null,Object? zIndex = null,}) {
  return _then(_Layer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LayerType,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as LayerContent,animation: freezed == animation ? _self.animation : animation // ignore: cast_nullable_to_non_nullable
as LayerAnimation?,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,zIndex: null == zIndex ? _self.zIndex : zIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LayerContentCopyWith<$Res> get content {
  
  return $LayerContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LayerAnimationCopyWith<$Res>? get animation {
    if (_self.animation == null) {
    return null;
  }

  return $LayerAnimationCopyWith<$Res>(_self.animation!, (value) {
    return _then(_self.copyWith(animation: value));
  });
}
}

// dart format on
