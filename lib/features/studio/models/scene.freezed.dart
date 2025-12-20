// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scene.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Scene {

 String get id; String get projectId; int get orderIndex; SceneType get sceneType; String? get prompt; String? get imagePrompt;// للتوافق مع الشاشات
 String? get scriptText; int get durationMs; String? get generatedImageUrl; String? get generatedVideoUrl; String? get generatedAudioUrl; SceneStatus get status; String? get errorMessage; List<Layer> get layers; TransitionType get transitionIn; TransitionType get transitionOut;// حقول إضافية للتوافق مع الشاشات
 String? get textOverlay; String? get narration; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneCopyWith<Scene> get copyWith => _$SceneCopyWithImpl<Scene>(this as Scene, _$identity);

  /// Serializes this Scene to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Scene&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.sceneType, sceneType) || other.sceneType == sceneType)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.imagePrompt, imagePrompt) || other.imagePrompt == imagePrompt)&&(identical(other.scriptText, scriptText) || other.scriptText == scriptText)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.generatedImageUrl, generatedImageUrl) || other.generatedImageUrl == generatedImageUrl)&&(identical(other.generatedVideoUrl, generatedVideoUrl) || other.generatedVideoUrl == generatedVideoUrl)&&(identical(other.generatedAudioUrl, generatedAudioUrl) || other.generatedAudioUrl == generatedAudioUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.layers, layers)&&(identical(other.transitionIn, transitionIn) || other.transitionIn == transitionIn)&&(identical(other.transitionOut, transitionOut) || other.transitionOut == transitionOut)&&(identical(other.textOverlay, textOverlay) || other.textOverlay == textOverlay)&&(identical(other.narration, narration) || other.narration == narration)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,projectId,orderIndex,sceneType,prompt,imagePrompt,scriptText,durationMs,generatedImageUrl,generatedVideoUrl,generatedAudioUrl,status,errorMessage,const DeepCollectionEquality().hash(layers),transitionIn,transitionOut,textOverlay,narration,createdAt,updatedAt]);

@override
String toString() {
  return 'Scene(id: $id, projectId: $projectId, orderIndex: $orderIndex, sceneType: $sceneType, prompt: $prompt, imagePrompt: $imagePrompt, scriptText: $scriptText, durationMs: $durationMs, generatedImageUrl: $generatedImageUrl, generatedVideoUrl: $generatedVideoUrl, generatedAudioUrl: $generatedAudioUrl, status: $status, errorMessage: $errorMessage, layers: $layers, transitionIn: $transitionIn, transitionOut: $transitionOut, textOverlay: $textOverlay, narration: $narration, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SceneCopyWith<$Res>  {
  factory $SceneCopyWith(Scene value, $Res Function(Scene) _then) = _$SceneCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, int orderIndex, SceneType sceneType, String? prompt, String? imagePrompt, String? scriptText, int durationMs, String? generatedImageUrl, String? generatedVideoUrl, String? generatedAudioUrl, SceneStatus status, String? errorMessage, List<Layer> layers, TransitionType transitionIn, TransitionType transitionOut, String? textOverlay, String? narration, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SceneCopyWithImpl<$Res>
    implements $SceneCopyWith<$Res> {
  _$SceneCopyWithImpl(this._self, this._then);

  final Scene _self;
  final $Res Function(Scene) _then;

/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? orderIndex = null,Object? sceneType = null,Object? prompt = freezed,Object? imagePrompt = freezed,Object? scriptText = freezed,Object? durationMs = null,Object? generatedImageUrl = freezed,Object? generatedVideoUrl = freezed,Object? generatedAudioUrl = freezed,Object? status = null,Object? errorMessage = freezed,Object? layers = null,Object? transitionIn = null,Object? transitionOut = null,Object? textOverlay = freezed,Object? narration = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,sceneType: null == sceneType ? _self.sceneType : sceneType // ignore: cast_nullable_to_non_nullable
as SceneType,prompt: freezed == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String?,imagePrompt: freezed == imagePrompt ? _self.imagePrompt : imagePrompt // ignore: cast_nullable_to_non_nullable
as String?,scriptText: freezed == scriptText ? _self.scriptText : scriptText // ignore: cast_nullable_to_non_nullable
as String?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,generatedImageUrl: freezed == generatedImageUrl ? _self.generatedImageUrl : generatedImageUrl // ignore: cast_nullable_to_non_nullable
as String?,generatedVideoUrl: freezed == generatedVideoUrl ? _self.generatedVideoUrl : generatedVideoUrl // ignore: cast_nullable_to_non_nullable
as String?,generatedAudioUrl: freezed == generatedAudioUrl ? _self.generatedAudioUrl : generatedAudioUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SceneStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,layers: null == layers ? _self.layers : layers // ignore: cast_nullable_to_non_nullable
as List<Layer>,transitionIn: null == transitionIn ? _self.transitionIn : transitionIn // ignore: cast_nullable_to_non_nullable
as TransitionType,transitionOut: null == transitionOut ? _self.transitionOut : transitionOut // ignore: cast_nullable_to_non_nullable
as TransitionType,textOverlay: freezed == textOverlay ? _self.textOverlay : textOverlay // ignore: cast_nullable_to_non_nullable
as String?,narration: freezed == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Scene].
extension ScenePatterns on Scene {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Scene value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Scene() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Scene value)  $default,){
final _that = this;
switch (_that) {
case _Scene():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Scene value)?  $default,){
final _that = this;
switch (_that) {
case _Scene() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  int orderIndex,  SceneType sceneType,  String? prompt,  String? imagePrompt,  String? scriptText,  int durationMs,  String? generatedImageUrl,  String? generatedVideoUrl,  String? generatedAudioUrl,  SceneStatus status,  String? errorMessage,  List<Layer> layers,  TransitionType transitionIn,  TransitionType transitionOut,  String? textOverlay,  String? narration,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Scene() when $default != null:
return $default(_that.id,_that.projectId,_that.orderIndex,_that.sceneType,_that.prompt,_that.imagePrompt,_that.scriptText,_that.durationMs,_that.generatedImageUrl,_that.generatedVideoUrl,_that.generatedAudioUrl,_that.status,_that.errorMessage,_that.layers,_that.transitionIn,_that.transitionOut,_that.textOverlay,_that.narration,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  int orderIndex,  SceneType sceneType,  String? prompt,  String? imagePrompt,  String? scriptText,  int durationMs,  String? generatedImageUrl,  String? generatedVideoUrl,  String? generatedAudioUrl,  SceneStatus status,  String? errorMessage,  List<Layer> layers,  TransitionType transitionIn,  TransitionType transitionOut,  String? textOverlay,  String? narration,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Scene():
return $default(_that.id,_that.projectId,_that.orderIndex,_that.sceneType,_that.prompt,_that.imagePrompt,_that.scriptText,_that.durationMs,_that.generatedImageUrl,_that.generatedVideoUrl,_that.generatedAudioUrl,_that.status,_that.errorMessage,_that.layers,_that.transitionIn,_that.transitionOut,_that.textOverlay,_that.narration,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  int orderIndex,  SceneType sceneType,  String? prompt,  String? imagePrompt,  String? scriptText,  int durationMs,  String? generatedImageUrl,  String? generatedVideoUrl,  String? generatedAudioUrl,  SceneStatus status,  String? errorMessage,  List<Layer> layers,  TransitionType transitionIn,  TransitionType transitionOut,  String? textOverlay,  String? narration,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Scene() when $default != null:
return $default(_that.id,_that.projectId,_that.orderIndex,_that.sceneType,_that.prompt,_that.imagePrompt,_that.scriptText,_that.durationMs,_that.generatedImageUrl,_that.generatedVideoUrl,_that.generatedAudioUrl,_that.status,_that.errorMessage,_that.layers,_that.transitionIn,_that.transitionOut,_that.textOverlay,_that.narration,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Scene extends Scene {
  const _Scene({required this.id, required this.projectId, this.orderIndex = 0, this.sceneType = SceneType.image, this.prompt, this.imagePrompt, this.scriptText, this.durationMs = 5000, this.generatedImageUrl, this.generatedVideoUrl, this.generatedAudioUrl, this.status = SceneStatus.pending, this.errorMessage, final  List<Layer> layers = const [], this.transitionIn = TransitionType.fade, this.transitionOut = TransitionType.fade, this.textOverlay, this.narration, required this.createdAt, required this.updatedAt}): _layers = layers,super._();
  factory _Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

@override final  String id;
@override final  String projectId;
@override@JsonKey() final  int orderIndex;
@override@JsonKey() final  SceneType sceneType;
@override final  String? prompt;
@override final  String? imagePrompt;
// للتوافق مع الشاشات
@override final  String? scriptText;
@override@JsonKey() final  int durationMs;
@override final  String? generatedImageUrl;
@override final  String? generatedVideoUrl;
@override final  String? generatedAudioUrl;
@override@JsonKey() final  SceneStatus status;
@override final  String? errorMessage;
 final  List<Layer> _layers;
@override@JsonKey() List<Layer> get layers {
  if (_layers is EqualUnmodifiableListView) return _layers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_layers);
}

@override@JsonKey() final  TransitionType transitionIn;
@override@JsonKey() final  TransitionType transitionOut;
// حقول إضافية للتوافق مع الشاشات
@override final  String? textOverlay;
@override final  String? narration;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneCopyWith<_Scene> get copyWith => __$SceneCopyWithImpl<_Scene>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Scene&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.sceneType, sceneType) || other.sceneType == sceneType)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.imagePrompt, imagePrompt) || other.imagePrompt == imagePrompt)&&(identical(other.scriptText, scriptText) || other.scriptText == scriptText)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.generatedImageUrl, generatedImageUrl) || other.generatedImageUrl == generatedImageUrl)&&(identical(other.generatedVideoUrl, generatedVideoUrl) || other.generatedVideoUrl == generatedVideoUrl)&&(identical(other.generatedAudioUrl, generatedAudioUrl) || other.generatedAudioUrl == generatedAudioUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._layers, _layers)&&(identical(other.transitionIn, transitionIn) || other.transitionIn == transitionIn)&&(identical(other.transitionOut, transitionOut) || other.transitionOut == transitionOut)&&(identical(other.textOverlay, textOverlay) || other.textOverlay == textOverlay)&&(identical(other.narration, narration) || other.narration == narration)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,projectId,orderIndex,sceneType,prompt,imagePrompt,scriptText,durationMs,generatedImageUrl,generatedVideoUrl,generatedAudioUrl,status,errorMessage,const DeepCollectionEquality().hash(_layers),transitionIn,transitionOut,textOverlay,narration,createdAt,updatedAt]);

@override
String toString() {
  return 'Scene(id: $id, projectId: $projectId, orderIndex: $orderIndex, sceneType: $sceneType, prompt: $prompt, imagePrompt: $imagePrompt, scriptText: $scriptText, durationMs: $durationMs, generatedImageUrl: $generatedImageUrl, generatedVideoUrl: $generatedVideoUrl, generatedAudioUrl: $generatedAudioUrl, status: $status, errorMessage: $errorMessage, layers: $layers, transitionIn: $transitionIn, transitionOut: $transitionOut, textOverlay: $textOverlay, narration: $narration, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SceneCopyWith<$Res> implements $SceneCopyWith<$Res> {
  factory _$SceneCopyWith(_Scene value, $Res Function(_Scene) _then) = __$SceneCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, int orderIndex, SceneType sceneType, String? prompt, String? imagePrompt, String? scriptText, int durationMs, String? generatedImageUrl, String? generatedVideoUrl, String? generatedAudioUrl, SceneStatus status, String? errorMessage, List<Layer> layers, TransitionType transitionIn, TransitionType transitionOut, String? textOverlay, String? narration, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SceneCopyWithImpl<$Res>
    implements _$SceneCopyWith<$Res> {
  __$SceneCopyWithImpl(this._self, this._then);

  final _Scene _self;
  final $Res Function(_Scene) _then;

/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? orderIndex = null,Object? sceneType = null,Object? prompt = freezed,Object? imagePrompt = freezed,Object? scriptText = freezed,Object? durationMs = null,Object? generatedImageUrl = freezed,Object? generatedVideoUrl = freezed,Object? generatedAudioUrl = freezed,Object? status = null,Object? errorMessage = freezed,Object? layers = null,Object? transitionIn = null,Object? transitionOut = null,Object? textOverlay = freezed,Object? narration = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Scene(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,sceneType: null == sceneType ? _self.sceneType : sceneType // ignore: cast_nullable_to_non_nullable
as SceneType,prompt: freezed == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String?,imagePrompt: freezed == imagePrompt ? _self.imagePrompt : imagePrompt // ignore: cast_nullable_to_non_nullable
as String?,scriptText: freezed == scriptText ? _self.scriptText : scriptText // ignore: cast_nullable_to_non_nullable
as String?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,generatedImageUrl: freezed == generatedImageUrl ? _self.generatedImageUrl : generatedImageUrl // ignore: cast_nullable_to_non_nullable
as String?,generatedVideoUrl: freezed == generatedVideoUrl ? _self.generatedVideoUrl : generatedVideoUrl // ignore: cast_nullable_to_non_nullable
as String?,generatedAudioUrl: freezed == generatedAudioUrl ? _self.generatedAudioUrl : generatedAudioUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SceneStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,layers: null == layers ? _self._layers : layers // ignore: cast_nullable_to_non_nullable
as List<Layer>,transitionIn: null == transitionIn ? _self.transitionIn : transitionIn // ignore: cast_nullable_to_non_nullable
as TransitionType,transitionOut: null == transitionOut ? _self.transitionOut : transitionOut // ignore: cast_nullable_to_non_nullable
as TransitionType,textOverlay: freezed == textOverlay ? _self.textOverlay : textOverlay // ignore: cast_nullable_to_non_nullable
as String?,narration: freezed == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
