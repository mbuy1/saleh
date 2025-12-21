// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studio_tool.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditToolDefinition {

 EditToolType get id; String get name; String get nameAr; String get description; String get descriptionAr; String get icon; int get creditsCost; bool get supportsImage; bool get supportsVideo;
/// Create a copy of EditToolDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditToolDefinitionCopyWith<EditToolDefinition> get copyWith => _$EditToolDefinitionCopyWithImpl<EditToolDefinition>(this as EditToolDefinition, _$identity);

  /// Serializes this EditToolDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditToolDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.supportsImage, supportsImage) || other.supportsImage == supportsImage)&&(identical(other.supportsVideo, supportsVideo) || other.supportsVideo == supportsVideo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameAr,description,descriptionAr,icon,creditsCost,supportsImage,supportsVideo);

@override
String toString() {
  return 'EditToolDefinition(id: $id, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, icon: $icon, creditsCost: $creditsCost, supportsImage: $supportsImage, supportsVideo: $supportsVideo)';
}


}

/// @nodoc
abstract mixin class $EditToolDefinitionCopyWith<$Res>  {
  factory $EditToolDefinitionCopyWith(EditToolDefinition value, $Res Function(EditToolDefinition) _then) = _$EditToolDefinitionCopyWithImpl;
@useResult
$Res call({
 EditToolType id, String name, String nameAr, String description, String descriptionAr, String icon, int creditsCost, bool supportsImage, bool supportsVideo
});




}
/// @nodoc
class _$EditToolDefinitionCopyWithImpl<$Res>
    implements $EditToolDefinitionCopyWith<$Res> {
  _$EditToolDefinitionCopyWithImpl(this._self, this._then);

  final EditToolDefinition _self;
  final $Res Function(EditToolDefinition) _then;

/// Create a copy of EditToolDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameAr = null,Object? description = null,Object? descriptionAr = null,Object? icon = null,Object? creditsCost = null,Object? supportsImage = null,Object? supportsVideo = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as EditToolType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: null == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,supportsImage: null == supportsImage ? _self.supportsImage : supportsImage // ignore: cast_nullable_to_non_nullable
as bool,supportsVideo: null == supportsVideo ? _self.supportsVideo : supportsVideo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EditToolDefinition].
extension EditToolDefinitionPatterns on EditToolDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditToolDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditToolDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditToolDefinition value)  $default,){
final _that = this;
switch (_that) {
case _EditToolDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditToolDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _EditToolDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EditToolType id,  String name,  String nameAr,  String description,  String descriptionAr,  String icon,  int creditsCost,  bool supportsImage,  bool supportsVideo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditToolDefinition() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.creditsCost,_that.supportsImage,_that.supportsVideo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EditToolType id,  String name,  String nameAr,  String description,  String descriptionAr,  String icon,  int creditsCost,  bool supportsImage,  bool supportsVideo)  $default,) {final _that = this;
switch (_that) {
case _EditToolDefinition():
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.creditsCost,_that.supportsImage,_that.supportsVideo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EditToolType id,  String name,  String nameAr,  String description,  String descriptionAr,  String icon,  int creditsCost,  bool supportsImage,  bool supportsVideo)?  $default,) {final _that = this;
switch (_that) {
case _EditToolDefinition() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.creditsCost,_that.supportsImage,_that.supportsVideo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EditToolDefinition implements EditToolDefinition {
  const _EditToolDefinition({required this.id, required this.name, required this.nameAr, required this.description, required this.descriptionAr, required this.icon, required this.creditsCost, this.supportsImage = true, this.supportsVideo = false});
  factory _EditToolDefinition.fromJson(Map<String, dynamic> json) => _$EditToolDefinitionFromJson(json);

@override final  EditToolType id;
@override final  String name;
@override final  String nameAr;
@override final  String description;
@override final  String descriptionAr;
@override final  String icon;
@override final  int creditsCost;
@override@JsonKey() final  bool supportsImage;
@override@JsonKey() final  bool supportsVideo;

/// Create a copy of EditToolDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditToolDefinitionCopyWith<_EditToolDefinition> get copyWith => __$EditToolDefinitionCopyWithImpl<_EditToolDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditToolDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditToolDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.supportsImage, supportsImage) || other.supportsImage == supportsImage)&&(identical(other.supportsVideo, supportsVideo) || other.supportsVideo == supportsVideo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameAr,description,descriptionAr,icon,creditsCost,supportsImage,supportsVideo);

@override
String toString() {
  return 'EditToolDefinition(id: $id, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, icon: $icon, creditsCost: $creditsCost, supportsImage: $supportsImage, supportsVideo: $supportsVideo)';
}


}

/// @nodoc
abstract mixin class _$EditToolDefinitionCopyWith<$Res> implements $EditToolDefinitionCopyWith<$Res> {
  factory _$EditToolDefinitionCopyWith(_EditToolDefinition value, $Res Function(_EditToolDefinition) _then) = __$EditToolDefinitionCopyWithImpl;
@override @useResult
$Res call({
 EditToolType id, String name, String nameAr, String description, String descriptionAr, String icon, int creditsCost, bool supportsImage, bool supportsVideo
});




}
/// @nodoc
class __$EditToolDefinitionCopyWithImpl<$Res>
    implements _$EditToolDefinitionCopyWith<$Res> {
  __$EditToolDefinitionCopyWithImpl(this._self, this._then);

  final _EditToolDefinition _self;
  final $Res Function(_EditToolDefinition) _then;

/// Create a copy of EditToolDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameAr = null,Object? description = null,Object? descriptionAr = null,Object? icon = null,Object? creditsCost = null,Object? supportsImage = null,Object? supportsVideo = null,}) {
  return _then(_EditToolDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as EditToolType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: null == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,supportsImage: null == supportsImage ? _self.supportsImage : supportsImage // ignore: cast_nullable_to_non_nullable
as bool,supportsVideo: null == supportsVideo ? _self.supportsVideo : supportsVideo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$GenerateToolDefinition {

 GenerateToolType get id; String get name; String get nameAr; String get description; String get descriptionAr; String get icon; int get creditsCost; int get estimatedTimeSeconds;
/// Create a copy of GenerateToolDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerateToolDefinitionCopyWith<GenerateToolDefinition> get copyWith => _$GenerateToolDefinitionCopyWithImpl<GenerateToolDefinition>(this as GenerateToolDefinition, _$identity);

  /// Serializes this GenerateToolDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerateToolDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.estimatedTimeSeconds, estimatedTimeSeconds) || other.estimatedTimeSeconds == estimatedTimeSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameAr,description,descriptionAr,icon,creditsCost,estimatedTimeSeconds);

@override
String toString() {
  return 'GenerateToolDefinition(id: $id, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, icon: $icon, creditsCost: $creditsCost, estimatedTimeSeconds: $estimatedTimeSeconds)';
}


}

/// @nodoc
abstract mixin class $GenerateToolDefinitionCopyWith<$Res>  {
  factory $GenerateToolDefinitionCopyWith(GenerateToolDefinition value, $Res Function(GenerateToolDefinition) _then) = _$GenerateToolDefinitionCopyWithImpl;
@useResult
$Res call({
 GenerateToolType id, String name, String nameAr, String description, String descriptionAr, String icon, int creditsCost, int estimatedTimeSeconds
});




}
/// @nodoc
class _$GenerateToolDefinitionCopyWithImpl<$Res>
    implements $GenerateToolDefinitionCopyWith<$Res> {
  _$GenerateToolDefinitionCopyWithImpl(this._self, this._then);

  final GenerateToolDefinition _self;
  final $Res Function(GenerateToolDefinition) _then;

/// Create a copy of GenerateToolDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameAr = null,Object? description = null,Object? descriptionAr = null,Object? icon = null,Object? creditsCost = null,Object? estimatedTimeSeconds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as GenerateToolType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: null == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,estimatedTimeSeconds: null == estimatedTimeSeconds ? _self.estimatedTimeSeconds : estimatedTimeSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerateToolDefinition].
extension GenerateToolDefinitionPatterns on GenerateToolDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenerateToolDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenerateToolDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenerateToolDefinition value)  $default,){
final _that = this;
switch (_that) {
case _GenerateToolDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenerateToolDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _GenerateToolDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GenerateToolType id,  String name,  String nameAr,  String description,  String descriptionAr,  String icon,  int creditsCost,  int estimatedTimeSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenerateToolDefinition() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.creditsCost,_that.estimatedTimeSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GenerateToolType id,  String name,  String nameAr,  String description,  String descriptionAr,  String icon,  int creditsCost,  int estimatedTimeSeconds)  $default,) {final _that = this;
switch (_that) {
case _GenerateToolDefinition():
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.creditsCost,_that.estimatedTimeSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GenerateToolType id,  String name,  String nameAr,  String description,  String descriptionAr,  String icon,  int creditsCost,  int estimatedTimeSeconds)?  $default,) {final _that = this;
switch (_that) {
case _GenerateToolDefinition() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.creditsCost,_that.estimatedTimeSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenerateToolDefinition implements GenerateToolDefinition {
  const _GenerateToolDefinition({required this.id, required this.name, required this.nameAr, required this.description, required this.descriptionAr, required this.icon, required this.creditsCost, required this.estimatedTimeSeconds});
  factory _GenerateToolDefinition.fromJson(Map<String, dynamic> json) => _$GenerateToolDefinitionFromJson(json);

@override final  GenerateToolType id;
@override final  String name;
@override final  String nameAr;
@override final  String description;
@override final  String descriptionAr;
@override final  String icon;
@override final  int creditsCost;
@override final  int estimatedTimeSeconds;

/// Create a copy of GenerateToolDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerateToolDefinitionCopyWith<_GenerateToolDefinition> get copyWith => __$GenerateToolDefinitionCopyWithImpl<_GenerateToolDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenerateToolDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerateToolDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.estimatedTimeSeconds, estimatedTimeSeconds) || other.estimatedTimeSeconds == estimatedTimeSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameAr,description,descriptionAr,icon,creditsCost,estimatedTimeSeconds);

@override
String toString() {
  return 'GenerateToolDefinition(id: $id, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, icon: $icon, creditsCost: $creditsCost, estimatedTimeSeconds: $estimatedTimeSeconds)';
}


}

/// @nodoc
abstract mixin class _$GenerateToolDefinitionCopyWith<$Res> implements $GenerateToolDefinitionCopyWith<$Res> {
  factory _$GenerateToolDefinitionCopyWith(_GenerateToolDefinition value, $Res Function(_GenerateToolDefinition) _then) = __$GenerateToolDefinitionCopyWithImpl;
@override @useResult
$Res call({
 GenerateToolType id, String name, String nameAr, String description, String descriptionAr, String icon, int creditsCost, int estimatedTimeSeconds
});




}
/// @nodoc
class __$GenerateToolDefinitionCopyWithImpl<$Res>
    implements _$GenerateToolDefinitionCopyWith<$Res> {
  __$GenerateToolDefinitionCopyWithImpl(this._self, this._then);

  final _GenerateToolDefinition _self;
  final $Res Function(_GenerateToolDefinition) _then;

/// Create a copy of GenerateToolDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameAr = null,Object? description = null,Object? descriptionAr = null,Object? icon = null,Object? creditsCost = null,Object? estimatedTimeSeconds = null,}) {
  return _then(_GenerateToolDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as GenerateToolType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: null == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,estimatedTimeSeconds: null == estimatedTimeSeconds ? _self.estimatedTimeSeconds : estimatedTimeSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EditToolResult {

 bool get success; String get resultUrl; String? get thumbnailUrl; int? get fileSizeBytes; int get processingTimeMs; int get creditsUsed; String? get error;
/// Create a copy of EditToolResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditToolResultCopyWith<EditToolResult> get copyWith => _$EditToolResultCopyWithImpl<EditToolResult>(this as EditToolResult, _$identity);

  /// Serializes this EditToolResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditToolResult&&(identical(other.success, success) || other.success == success)&&(identical(other.resultUrl, resultUrl) || other.resultUrl == resultUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.processingTimeMs, processingTimeMs) || other.processingTimeMs == processingTimeMs)&&(identical(other.creditsUsed, creditsUsed) || other.creditsUsed == creditsUsed)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,resultUrl,thumbnailUrl,fileSizeBytes,processingTimeMs,creditsUsed,error);

@override
String toString() {
  return 'EditToolResult(success: $success, resultUrl: $resultUrl, thumbnailUrl: $thumbnailUrl, fileSizeBytes: $fileSizeBytes, processingTimeMs: $processingTimeMs, creditsUsed: $creditsUsed, error: $error)';
}


}

/// @nodoc
abstract mixin class $EditToolResultCopyWith<$Res>  {
  factory $EditToolResultCopyWith(EditToolResult value, $Res Function(EditToolResult) _then) = _$EditToolResultCopyWithImpl;
@useResult
$Res call({
 bool success, String resultUrl, String? thumbnailUrl, int? fileSizeBytes, int processingTimeMs, int creditsUsed, String? error
});




}
/// @nodoc
class _$EditToolResultCopyWithImpl<$Res>
    implements $EditToolResultCopyWith<$Res> {
  _$EditToolResultCopyWithImpl(this._self, this._then);

  final EditToolResult _self;
  final $Res Function(EditToolResult) _then;

/// Create a copy of EditToolResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? resultUrl = null,Object? thumbnailUrl = freezed,Object? fileSizeBytes = freezed,Object? processingTimeMs = null,Object? creditsUsed = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,resultUrl: null == resultUrl ? _self.resultUrl : resultUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,processingTimeMs: null == processingTimeMs ? _self.processingTimeMs : processingTimeMs // ignore: cast_nullable_to_non_nullable
as int,creditsUsed: null == creditsUsed ? _self.creditsUsed : creditsUsed // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditToolResult].
extension EditToolResultPatterns on EditToolResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditToolResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditToolResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditToolResult value)  $default,){
final _that = this;
switch (_that) {
case _EditToolResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditToolResult value)?  $default,){
final _that = this;
switch (_that) {
case _EditToolResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String resultUrl,  String? thumbnailUrl,  int? fileSizeBytes,  int processingTimeMs,  int creditsUsed,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditToolResult() when $default != null:
return $default(_that.success,_that.resultUrl,_that.thumbnailUrl,_that.fileSizeBytes,_that.processingTimeMs,_that.creditsUsed,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String resultUrl,  String? thumbnailUrl,  int? fileSizeBytes,  int processingTimeMs,  int creditsUsed,  String? error)  $default,) {final _that = this;
switch (_that) {
case _EditToolResult():
return $default(_that.success,_that.resultUrl,_that.thumbnailUrl,_that.fileSizeBytes,_that.processingTimeMs,_that.creditsUsed,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String resultUrl,  String? thumbnailUrl,  int? fileSizeBytes,  int processingTimeMs,  int creditsUsed,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _EditToolResult() when $default != null:
return $default(_that.success,_that.resultUrl,_that.thumbnailUrl,_that.fileSizeBytes,_that.processingTimeMs,_that.creditsUsed,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EditToolResult implements EditToolResult {
  const _EditToolResult({required this.success, required this.resultUrl, this.thumbnailUrl, this.fileSizeBytes, required this.processingTimeMs, required this.creditsUsed, this.error});
  factory _EditToolResult.fromJson(Map<String, dynamic> json) => _$EditToolResultFromJson(json);

@override final  bool success;
@override final  String resultUrl;
@override final  String? thumbnailUrl;
@override final  int? fileSizeBytes;
@override final  int processingTimeMs;
@override final  int creditsUsed;
@override final  String? error;

/// Create a copy of EditToolResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditToolResultCopyWith<_EditToolResult> get copyWith => __$EditToolResultCopyWithImpl<_EditToolResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditToolResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditToolResult&&(identical(other.success, success) || other.success == success)&&(identical(other.resultUrl, resultUrl) || other.resultUrl == resultUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.processingTimeMs, processingTimeMs) || other.processingTimeMs == processingTimeMs)&&(identical(other.creditsUsed, creditsUsed) || other.creditsUsed == creditsUsed)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,resultUrl,thumbnailUrl,fileSizeBytes,processingTimeMs,creditsUsed,error);

@override
String toString() {
  return 'EditToolResult(success: $success, resultUrl: $resultUrl, thumbnailUrl: $thumbnailUrl, fileSizeBytes: $fileSizeBytes, processingTimeMs: $processingTimeMs, creditsUsed: $creditsUsed, error: $error)';
}


}

/// @nodoc
abstract mixin class _$EditToolResultCopyWith<$Res> implements $EditToolResultCopyWith<$Res> {
  factory _$EditToolResultCopyWith(_EditToolResult value, $Res Function(_EditToolResult) _then) = __$EditToolResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String resultUrl, String? thumbnailUrl, int? fileSizeBytes, int processingTimeMs, int creditsUsed, String? error
});




}
/// @nodoc
class __$EditToolResultCopyWithImpl<$Res>
    implements _$EditToolResultCopyWith<$Res> {
  __$EditToolResultCopyWithImpl(this._self, this._then);

  final _EditToolResult _self;
  final $Res Function(_EditToolResult) _then;

/// Create a copy of EditToolResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? resultUrl = null,Object? thumbnailUrl = freezed,Object? fileSizeBytes = freezed,Object? processingTimeMs = null,Object? creditsUsed = null,Object? error = freezed,}) {
  return _then(_EditToolResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,resultUrl: null == resultUrl ? _self.resultUrl : resultUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,processingTimeMs: null == processingTimeMs ? _self.processingTimeMs : processingTimeMs // ignore: cast_nullable_to_non_nullable
as int,creditsUsed: null == creditsUsed ? _self.creditsUsed : creditsUsed // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GenerateToolResult {

 bool get success; List<GeneratedAsset> get results; int get creditsUsed; int get processingTimeMs; String? get jobId; String? get error;
/// Create a copy of GenerateToolResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerateToolResultCopyWith<GenerateToolResult> get copyWith => _$GenerateToolResultCopyWithImpl<GenerateToolResult>(this as GenerateToolResult, _$identity);

  /// Serializes this GenerateToolResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerateToolResult&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.creditsUsed, creditsUsed) || other.creditsUsed == creditsUsed)&&(identical(other.processingTimeMs, processingTimeMs) || other.processingTimeMs == processingTimeMs)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(results),creditsUsed,processingTimeMs,jobId,error);

@override
String toString() {
  return 'GenerateToolResult(success: $success, results: $results, creditsUsed: $creditsUsed, processingTimeMs: $processingTimeMs, jobId: $jobId, error: $error)';
}


}

/// @nodoc
abstract mixin class $GenerateToolResultCopyWith<$Res>  {
  factory $GenerateToolResultCopyWith(GenerateToolResult value, $Res Function(GenerateToolResult) _then) = _$GenerateToolResultCopyWithImpl;
@useResult
$Res call({
 bool success, List<GeneratedAsset> results, int creditsUsed, int processingTimeMs, String? jobId, String? error
});




}
/// @nodoc
class _$GenerateToolResultCopyWithImpl<$Res>
    implements $GenerateToolResultCopyWith<$Res> {
  _$GenerateToolResultCopyWithImpl(this._self, this._then);

  final GenerateToolResult _self;
  final $Res Function(GenerateToolResult) _then;

/// Create a copy of GenerateToolResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? results = null,Object? creditsUsed = null,Object? processingTimeMs = null,Object? jobId = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<GeneratedAsset>,creditsUsed: null == creditsUsed ? _self.creditsUsed : creditsUsed // ignore: cast_nullable_to_non_nullable
as int,processingTimeMs: null == processingTimeMs ? _self.processingTimeMs : processingTimeMs // ignore: cast_nullable_to_non_nullable
as int,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerateToolResult].
extension GenerateToolResultPatterns on GenerateToolResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenerateToolResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenerateToolResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenerateToolResult value)  $default,){
final _that = this;
switch (_that) {
case _GenerateToolResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenerateToolResult value)?  $default,){
final _that = this;
switch (_that) {
case _GenerateToolResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<GeneratedAsset> results,  int creditsUsed,  int processingTimeMs,  String? jobId,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenerateToolResult() when $default != null:
return $default(_that.success,_that.results,_that.creditsUsed,_that.processingTimeMs,_that.jobId,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<GeneratedAsset> results,  int creditsUsed,  int processingTimeMs,  String? jobId,  String? error)  $default,) {final _that = this;
switch (_that) {
case _GenerateToolResult():
return $default(_that.success,_that.results,_that.creditsUsed,_that.processingTimeMs,_that.jobId,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<GeneratedAsset> results,  int creditsUsed,  int processingTimeMs,  String? jobId,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _GenerateToolResult() when $default != null:
return $default(_that.success,_that.results,_that.creditsUsed,_that.processingTimeMs,_that.jobId,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenerateToolResult implements GenerateToolResult {
  const _GenerateToolResult({required this.success, final  List<GeneratedAsset> results = const [], required this.creditsUsed, required this.processingTimeMs, this.jobId, this.error}): _results = results;
  factory _GenerateToolResult.fromJson(Map<String, dynamic> json) => _$GenerateToolResultFromJson(json);

@override final  bool success;
 final  List<GeneratedAsset> _results;
@override@JsonKey() List<GeneratedAsset> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override final  int creditsUsed;
@override final  int processingTimeMs;
@override final  String? jobId;
@override final  String? error;

/// Create a copy of GenerateToolResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerateToolResultCopyWith<_GenerateToolResult> get copyWith => __$GenerateToolResultCopyWithImpl<_GenerateToolResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenerateToolResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerateToolResult&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.creditsUsed, creditsUsed) || other.creditsUsed == creditsUsed)&&(identical(other.processingTimeMs, processingTimeMs) || other.processingTimeMs == processingTimeMs)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_results),creditsUsed,processingTimeMs,jobId,error);

@override
String toString() {
  return 'GenerateToolResult(success: $success, results: $results, creditsUsed: $creditsUsed, processingTimeMs: $processingTimeMs, jobId: $jobId, error: $error)';
}


}

/// @nodoc
abstract mixin class _$GenerateToolResultCopyWith<$Res> implements $GenerateToolResultCopyWith<$Res> {
  factory _$GenerateToolResultCopyWith(_GenerateToolResult value, $Res Function(_GenerateToolResult) _then) = __$GenerateToolResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<GeneratedAsset> results, int creditsUsed, int processingTimeMs, String? jobId, String? error
});




}
/// @nodoc
class __$GenerateToolResultCopyWithImpl<$Res>
    implements _$GenerateToolResultCopyWith<$Res> {
  __$GenerateToolResultCopyWithImpl(this._self, this._then);

  final _GenerateToolResult _self;
  final $Res Function(_GenerateToolResult) _then;

/// Create a copy of GenerateToolResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? results = null,Object? creditsUsed = null,Object? processingTimeMs = null,Object? jobId = freezed,Object? error = freezed,}) {
  return _then(_GenerateToolResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<GeneratedAsset>,creditsUsed: null == creditsUsed ? _self.creditsUsed : creditsUsed // ignore: cast_nullable_to_non_nullable
as int,processingTimeMs: null == processingTimeMs ? _self.processingTimeMs : processingTimeMs // ignore: cast_nullable_to_non_nullable
as int,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GeneratedAsset {

 String get id; String get url; String? get thumbnailUrl; String get type; int? get width; int? get height; int? get durationMs; int? get fileSizeBytes; Map<String, dynamic>? get metadata;
/// Create a copy of GeneratedAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratedAssetCopyWith<GeneratedAsset> get copyWith => _$GeneratedAssetCopyWithImpl<GeneratedAsset>(this as GeneratedAsset, _$identity);

  /// Serializes this GeneratedAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratedAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,thumbnailUrl,type,width,height,durationMs,fileSizeBytes,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'GeneratedAsset(id: $id, url: $url, thumbnailUrl: $thumbnailUrl, type: $type, width: $width, height: $height, durationMs: $durationMs, fileSizeBytes: $fileSizeBytes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $GeneratedAssetCopyWith<$Res>  {
  factory $GeneratedAssetCopyWith(GeneratedAsset value, $Res Function(GeneratedAsset) _then) = _$GeneratedAssetCopyWithImpl;
@useResult
$Res call({
 String id, String url, String? thumbnailUrl, String type, int? width, int? height, int? durationMs, int? fileSizeBytes, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$GeneratedAssetCopyWithImpl<$Res>
    implements $GeneratedAssetCopyWith<$Res> {
  _$GeneratedAssetCopyWithImpl(this._self, this._then);

  final GeneratedAsset _self;
  final $Res Function(GeneratedAsset) _then;

/// Create a copy of GeneratedAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? thumbnailUrl = freezed,Object? type = null,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,Object? fileSizeBytes = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneratedAsset].
extension GeneratedAssetPatterns on GeneratedAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneratedAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneratedAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneratedAsset value)  $default,){
final _that = this;
switch (_that) {
case _GeneratedAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneratedAsset value)?  $default,){
final _that = this;
switch (_that) {
case _GeneratedAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url,  String? thumbnailUrl,  String type,  int? width,  int? height,  int? durationMs,  int? fileSizeBytes,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneratedAsset() when $default != null:
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.type,_that.width,_that.height,_that.durationMs,_that.fileSizeBytes,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url,  String? thumbnailUrl,  String type,  int? width,  int? height,  int? durationMs,  int? fileSizeBytes,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _GeneratedAsset():
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.type,_that.width,_that.height,_that.durationMs,_that.fileSizeBytes,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url,  String? thumbnailUrl,  String type,  int? width,  int? height,  int? durationMs,  int? fileSizeBytes,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _GeneratedAsset() when $default != null:
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.type,_that.width,_that.height,_that.durationMs,_that.fileSizeBytes,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneratedAsset implements GeneratedAsset {
  const _GeneratedAsset({required this.id, required this.url, this.thumbnailUrl, required this.type, this.width, this.height, this.durationMs, this.fileSizeBytes, final  Map<String, dynamic>? metadata}): _metadata = metadata;
  factory _GeneratedAsset.fromJson(Map<String, dynamic> json) => _$GeneratedAssetFromJson(json);

@override final  String id;
@override final  String url;
@override final  String? thumbnailUrl;
@override final  String type;
@override final  int? width;
@override final  int? height;
@override final  int? durationMs;
@override final  int? fileSizeBytes;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of GeneratedAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneratedAssetCopyWith<_GeneratedAsset> get copyWith => __$GeneratedAssetCopyWithImpl<_GeneratedAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratedAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneratedAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,thumbnailUrl,type,width,height,durationMs,fileSizeBytes,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'GeneratedAsset(id: $id, url: $url, thumbnailUrl: $thumbnailUrl, type: $type, width: $width, height: $height, durationMs: $durationMs, fileSizeBytes: $fileSizeBytes, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$GeneratedAssetCopyWith<$Res> implements $GeneratedAssetCopyWith<$Res> {
  factory _$GeneratedAssetCopyWith(_GeneratedAsset value, $Res Function(_GeneratedAsset) _then) = __$GeneratedAssetCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, String? thumbnailUrl, String type, int? width, int? height, int? durationMs, int? fileSizeBytes, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$GeneratedAssetCopyWithImpl<$Res>
    implements _$GeneratedAssetCopyWith<$Res> {
  __$GeneratedAssetCopyWithImpl(this._self, this._then);

  final _GeneratedAsset _self;
  final $Res Function(_GeneratedAsset) _then;

/// Create a copy of GeneratedAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? thumbnailUrl = freezed,Object? type = null,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,Object? fileSizeBytes = freezed,Object? metadata = freezed,}) {
  return _then(_GeneratedAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$StudioAsset {

 String get id; String get userId; String? get storeId; String? get projectId; String? get name; String get assetType; String get source; String get url; String? get thumbnailUrl; int? get fileSizeBytes; String? get mimeType; int? get durationMs; int? get width; int? get height; String? get aiPrompt; String? get aiModel; int? get aiCostCredits; bool get isFavorite; int get usageCount; DateTime get createdAt;
/// Create a copy of StudioAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioAssetCopyWith<StudioAsset> get copyWith => _$StudioAssetCopyWithImpl<StudioAsset>(this as StudioAsset, _$identity);

  /// Serializes this StudioAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&(identical(other.source, source) || other.source == source)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.aiPrompt, aiPrompt) || other.aiPrompt == aiPrompt)&&(identical(other.aiModel, aiModel) || other.aiModel == aiModel)&&(identical(other.aiCostCredits, aiCostCredits) || other.aiCostCredits == aiCostCredits)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,storeId,projectId,name,assetType,source,url,thumbnailUrl,fileSizeBytes,mimeType,durationMs,width,height,aiPrompt,aiModel,aiCostCredits,isFavorite,usageCount,createdAt]);

@override
String toString() {
  return 'StudioAsset(id: $id, userId: $userId, storeId: $storeId, projectId: $projectId, name: $name, assetType: $assetType, source: $source, url: $url, thumbnailUrl: $thumbnailUrl, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, durationMs: $durationMs, width: $width, height: $height, aiPrompt: $aiPrompt, aiModel: $aiModel, aiCostCredits: $aiCostCredits, isFavorite: $isFavorite, usageCount: $usageCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StudioAssetCopyWith<$Res>  {
  factory $StudioAssetCopyWith(StudioAsset value, $Res Function(StudioAsset) _then) = _$StudioAssetCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? storeId, String? projectId, String? name, String assetType, String source, String url, String? thumbnailUrl, int? fileSizeBytes, String? mimeType, int? durationMs, int? width, int? height, String? aiPrompt, String? aiModel, int? aiCostCredits, bool isFavorite, int usageCount, DateTime createdAt
});




}
/// @nodoc
class _$StudioAssetCopyWithImpl<$Res>
    implements $StudioAssetCopyWith<$Res> {
  _$StudioAssetCopyWithImpl(this._self, this._then);

  final StudioAsset _self;
  final $Res Function(StudioAsset) _then;

/// Create a copy of StudioAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? storeId = freezed,Object? projectId = freezed,Object? name = freezed,Object? assetType = null,Object? source = null,Object? url = null,Object? thumbnailUrl = freezed,Object? fileSizeBytes = freezed,Object? mimeType = freezed,Object? durationMs = freezed,Object? width = freezed,Object? height = freezed,Object? aiPrompt = freezed,Object? aiModel = freezed,Object? aiCostCredits = freezed,Object? isFavorite = null,Object? usageCount = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,aiPrompt: freezed == aiPrompt ? _self.aiPrompt : aiPrompt // ignore: cast_nullable_to_non_nullable
as String?,aiModel: freezed == aiModel ? _self.aiModel : aiModel // ignore: cast_nullable_to_non_nullable
as String?,aiCostCredits: freezed == aiCostCredits ? _self.aiCostCredits : aiCostCredits // ignore: cast_nullable_to_non_nullable
as int?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioAsset].
extension StudioAssetPatterns on StudioAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioAsset value)  $default,){
final _that = this;
switch (_that) {
case _StudioAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioAsset value)?  $default,){
final _that = this;
switch (_that) {
case _StudioAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? storeId,  String? projectId,  String? name,  String assetType,  String source,  String url,  String? thumbnailUrl,  int? fileSizeBytes,  String? mimeType,  int? durationMs,  int? width,  int? height,  String? aiPrompt,  String? aiModel,  int? aiCostCredits,  bool isFavorite,  int usageCount,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioAsset() when $default != null:
return $default(_that.id,_that.userId,_that.storeId,_that.projectId,_that.name,_that.assetType,_that.source,_that.url,_that.thumbnailUrl,_that.fileSizeBytes,_that.mimeType,_that.durationMs,_that.width,_that.height,_that.aiPrompt,_that.aiModel,_that.aiCostCredits,_that.isFavorite,_that.usageCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? storeId,  String? projectId,  String? name,  String assetType,  String source,  String url,  String? thumbnailUrl,  int? fileSizeBytes,  String? mimeType,  int? durationMs,  int? width,  int? height,  String? aiPrompt,  String? aiModel,  int? aiCostCredits,  bool isFavorite,  int usageCount,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StudioAsset():
return $default(_that.id,_that.userId,_that.storeId,_that.projectId,_that.name,_that.assetType,_that.source,_that.url,_that.thumbnailUrl,_that.fileSizeBytes,_that.mimeType,_that.durationMs,_that.width,_that.height,_that.aiPrompt,_that.aiModel,_that.aiCostCredits,_that.isFavorite,_that.usageCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? storeId,  String? projectId,  String? name,  String assetType,  String source,  String url,  String? thumbnailUrl,  int? fileSizeBytes,  String? mimeType,  int? durationMs,  int? width,  int? height,  String? aiPrompt,  String? aiModel,  int? aiCostCredits,  bool isFavorite,  int usageCount,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StudioAsset() when $default != null:
return $default(_that.id,_that.userId,_that.storeId,_that.projectId,_that.name,_that.assetType,_that.source,_that.url,_that.thumbnailUrl,_that.fileSizeBytes,_that.mimeType,_that.durationMs,_that.width,_that.height,_that.aiPrompt,_that.aiModel,_that.aiCostCredits,_that.isFavorite,_that.usageCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudioAsset implements StudioAsset {
  const _StudioAsset({required this.id, required this.userId, this.storeId, this.projectId, this.name, required this.assetType, required this.source, required this.url, this.thumbnailUrl, this.fileSizeBytes, this.mimeType, this.durationMs, this.width, this.height, this.aiPrompt, this.aiModel, this.aiCostCredits, this.isFavorite = false, this.usageCount = 0, required this.createdAt});
  factory _StudioAsset.fromJson(Map<String, dynamic> json) => _$StudioAssetFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? storeId;
@override final  String? projectId;
@override final  String? name;
@override final  String assetType;
@override final  String source;
@override final  String url;
@override final  String? thumbnailUrl;
@override final  int? fileSizeBytes;
@override final  String? mimeType;
@override final  int? durationMs;
@override final  int? width;
@override final  int? height;
@override final  String? aiPrompt;
@override final  String? aiModel;
@override final  int? aiCostCredits;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  int usageCount;
@override final  DateTime createdAt;

/// Create a copy of StudioAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioAssetCopyWith<_StudioAsset> get copyWith => __$StudioAssetCopyWithImpl<_StudioAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudioAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&(identical(other.source, source) || other.source == source)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.aiPrompt, aiPrompt) || other.aiPrompt == aiPrompt)&&(identical(other.aiModel, aiModel) || other.aiModel == aiModel)&&(identical(other.aiCostCredits, aiCostCredits) || other.aiCostCredits == aiCostCredits)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,storeId,projectId,name,assetType,source,url,thumbnailUrl,fileSizeBytes,mimeType,durationMs,width,height,aiPrompt,aiModel,aiCostCredits,isFavorite,usageCount,createdAt]);

@override
String toString() {
  return 'StudioAsset(id: $id, userId: $userId, storeId: $storeId, projectId: $projectId, name: $name, assetType: $assetType, source: $source, url: $url, thumbnailUrl: $thumbnailUrl, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, durationMs: $durationMs, width: $width, height: $height, aiPrompt: $aiPrompt, aiModel: $aiModel, aiCostCredits: $aiCostCredits, isFavorite: $isFavorite, usageCount: $usageCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StudioAssetCopyWith<$Res> implements $StudioAssetCopyWith<$Res> {
  factory _$StudioAssetCopyWith(_StudioAsset value, $Res Function(_StudioAsset) _then) = __$StudioAssetCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? storeId, String? projectId, String? name, String assetType, String source, String url, String? thumbnailUrl, int? fileSizeBytes, String? mimeType, int? durationMs, int? width, int? height, String? aiPrompt, String? aiModel, int? aiCostCredits, bool isFavorite, int usageCount, DateTime createdAt
});




}
/// @nodoc
class __$StudioAssetCopyWithImpl<$Res>
    implements _$StudioAssetCopyWith<$Res> {
  __$StudioAssetCopyWithImpl(this._self, this._then);

  final _StudioAsset _self;
  final $Res Function(_StudioAsset) _then;

/// Create a copy of StudioAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? storeId = freezed,Object? projectId = freezed,Object? name = freezed,Object? assetType = null,Object? source = null,Object? url = null,Object? thumbnailUrl = freezed,Object? fileSizeBytes = freezed,Object? mimeType = freezed,Object? durationMs = freezed,Object? width = freezed,Object? height = freezed,Object? aiPrompt = freezed,Object? aiModel = freezed,Object? aiCostCredits = freezed,Object? isFavorite = null,Object? usageCount = null,Object? createdAt = null,}) {
  return _then(_StudioAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,aiPrompt: freezed == aiPrompt ? _self.aiPrompt : aiPrompt // ignore: cast_nullable_to_non_nullable
as String?,aiModel: freezed == aiModel ? _self.aiModel : aiModel // ignore: cast_nullable_to_non_nullable
as String?,aiCostCredits: freezed == aiCostCredits ? _self.aiCostCredits : aiCostCredits // ignore: cast_nullable_to_non_nullable
as int?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
