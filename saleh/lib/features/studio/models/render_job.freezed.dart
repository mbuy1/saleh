// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'render_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RenderJob {

 String get id; String get projectId; String get userId; RenderStatus get status; int get progress; String get format; String get resolution; String get quality; String? get outputUrl; int? get outputSizeBytes; int? get renderTimeSeconds; int get creditsCost; String? get errorMessage; String? get errorCode; int get retryCount; DateTime? get startedAt; DateTime? get completedAt; DateTime get createdAt;
/// Create a copy of RenderJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderJobCopyWith<RenderJob> get copyWith => _$RenderJobCopyWithImpl<RenderJob>(this as RenderJob, _$identity);

  /// Serializes this RenderJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderJob&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.format, format) || other.format == format)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.outputUrl, outputUrl) || other.outputUrl == outputUrl)&&(identical(other.outputSizeBytes, outputSizeBytes) || other.outputSizeBytes == outputSizeBytes)&&(identical(other.renderTimeSeconds, renderTimeSeconds) || other.renderTimeSeconds == renderTimeSeconds)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,userId,status,progress,format,resolution,quality,outputUrl,outputSizeBytes,renderTimeSeconds,creditsCost,errorMessage,errorCode,retryCount,startedAt,completedAt,createdAt);

@override
String toString() {
  return 'RenderJob(id: $id, projectId: $projectId, userId: $userId, status: $status, progress: $progress, format: $format, resolution: $resolution, quality: $quality, outputUrl: $outputUrl, outputSizeBytes: $outputSizeBytes, renderTimeSeconds: $renderTimeSeconds, creditsCost: $creditsCost, errorMessage: $errorMessage, errorCode: $errorCode, retryCount: $retryCount, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RenderJobCopyWith<$Res>  {
  factory $RenderJobCopyWith(RenderJob value, $Res Function(RenderJob) _then) = _$RenderJobCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String userId, RenderStatus status, int progress, String format, String resolution, String quality, String? outputUrl, int? outputSizeBytes, int? renderTimeSeconds, int creditsCost, String? errorMessage, String? errorCode, int retryCount, DateTime? startedAt, DateTime? completedAt, DateTime createdAt
});




}
/// @nodoc
class _$RenderJobCopyWithImpl<$Res>
    implements $RenderJobCopyWith<$Res> {
  _$RenderJobCopyWithImpl(this._self, this._then);

  final RenderJob _self;
  final $Res Function(RenderJob) _then;

/// Create a copy of RenderJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? userId = null,Object? status = null,Object? progress = null,Object? format = null,Object? resolution = null,Object? quality = null,Object? outputUrl = freezed,Object? outputSizeBytes = freezed,Object? renderTimeSeconds = freezed,Object? creditsCost = null,Object? errorMessage = freezed,Object? errorCode = freezed,Object? retryCount = null,Object? startedAt = freezed,Object? completedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RenderStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,resolution: null == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String,outputUrl: freezed == outputUrl ? _self.outputUrl : outputUrl // ignore: cast_nullable_to_non_nullable
as String?,outputSizeBytes: freezed == outputSizeBytes ? _self.outputSizeBytes : outputSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,renderTimeSeconds: freezed == renderTimeSeconds ? _self.renderTimeSeconds : renderTimeSeconds // ignore: cast_nullable_to_non_nullable
as int?,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderJob].
extension RenderJobPatterns on RenderJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderJob value)  $default,){
final _that = this;
switch (_that) {
case _RenderJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderJob value)?  $default,){
final _that = this;
switch (_that) {
case _RenderJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String userId,  RenderStatus status,  int progress,  String format,  String resolution,  String quality,  String? outputUrl,  int? outputSizeBytes,  int? renderTimeSeconds,  int creditsCost,  String? errorMessage,  String? errorCode,  int retryCount,  DateTime? startedAt,  DateTime? completedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderJob() when $default != null:
return $default(_that.id,_that.projectId,_that.userId,_that.status,_that.progress,_that.format,_that.resolution,_that.quality,_that.outputUrl,_that.outputSizeBytes,_that.renderTimeSeconds,_that.creditsCost,_that.errorMessage,_that.errorCode,_that.retryCount,_that.startedAt,_that.completedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String userId,  RenderStatus status,  int progress,  String format,  String resolution,  String quality,  String? outputUrl,  int? outputSizeBytes,  int? renderTimeSeconds,  int creditsCost,  String? errorMessage,  String? errorCode,  int retryCount,  DateTime? startedAt,  DateTime? completedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RenderJob():
return $default(_that.id,_that.projectId,_that.userId,_that.status,_that.progress,_that.format,_that.resolution,_that.quality,_that.outputUrl,_that.outputSizeBytes,_that.renderTimeSeconds,_that.creditsCost,_that.errorMessage,_that.errorCode,_that.retryCount,_that.startedAt,_that.completedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String userId,  RenderStatus status,  int progress,  String format,  String resolution,  String quality,  String? outputUrl,  int? outputSizeBytes,  int? renderTimeSeconds,  int creditsCost,  String? errorMessage,  String? errorCode,  int retryCount,  DateTime? startedAt,  DateTime? completedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RenderJob() when $default != null:
return $default(_that.id,_that.projectId,_that.userId,_that.status,_that.progress,_that.format,_that.resolution,_that.quality,_that.outputUrl,_that.outputSizeBytes,_that.renderTimeSeconds,_that.creditsCost,_that.errorMessage,_that.errorCode,_that.retryCount,_that.startedAt,_that.completedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderJob extends RenderJob {
  const _RenderJob({required this.id, required this.projectId, required this.userId, this.status = RenderStatus.queued, this.progress = 0, this.format = 'mp4', this.resolution = '1080p', this.quality = 'medium', this.outputUrl, this.outputSizeBytes, this.renderTimeSeconds, this.creditsCost = 5, this.errorMessage, this.errorCode, this.retryCount = 0, this.startedAt, this.completedAt, required this.createdAt}): super._();
  factory _RenderJob.fromJson(Map<String, dynamic> json) => _$RenderJobFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  String userId;
@override@JsonKey() final  RenderStatus status;
@override@JsonKey() final  int progress;
@override@JsonKey() final  String format;
@override@JsonKey() final  String resolution;
@override@JsonKey() final  String quality;
@override final  String? outputUrl;
@override final  int? outputSizeBytes;
@override final  int? renderTimeSeconds;
@override@JsonKey() final  int creditsCost;
@override final  String? errorMessage;
@override final  String? errorCode;
@override@JsonKey() final  int retryCount;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;

/// Create a copy of RenderJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderJobCopyWith<_RenderJob> get copyWith => __$RenderJobCopyWithImpl<_RenderJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderJobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderJob&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.format, format) || other.format == format)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.outputUrl, outputUrl) || other.outputUrl == outputUrl)&&(identical(other.outputSizeBytes, outputSizeBytes) || other.outputSizeBytes == outputSizeBytes)&&(identical(other.renderTimeSeconds, renderTimeSeconds) || other.renderTimeSeconds == renderTimeSeconds)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,userId,status,progress,format,resolution,quality,outputUrl,outputSizeBytes,renderTimeSeconds,creditsCost,errorMessage,errorCode,retryCount,startedAt,completedAt,createdAt);

@override
String toString() {
  return 'RenderJob(id: $id, projectId: $projectId, userId: $userId, status: $status, progress: $progress, format: $format, resolution: $resolution, quality: $quality, outputUrl: $outputUrl, outputSizeBytes: $outputSizeBytes, renderTimeSeconds: $renderTimeSeconds, creditsCost: $creditsCost, errorMessage: $errorMessage, errorCode: $errorCode, retryCount: $retryCount, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RenderJobCopyWith<$Res> implements $RenderJobCopyWith<$Res> {
  factory _$RenderJobCopyWith(_RenderJob value, $Res Function(_RenderJob) _then) = __$RenderJobCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String userId, RenderStatus status, int progress, String format, String resolution, String quality, String? outputUrl, int? outputSizeBytes, int? renderTimeSeconds, int creditsCost, String? errorMessage, String? errorCode, int retryCount, DateTime? startedAt, DateTime? completedAt, DateTime createdAt
});




}
/// @nodoc
class __$RenderJobCopyWithImpl<$Res>
    implements _$RenderJobCopyWith<$Res> {
  __$RenderJobCopyWithImpl(this._self, this._then);

  final _RenderJob _self;
  final $Res Function(_RenderJob) _then;

/// Create a copy of RenderJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? userId = null,Object? status = null,Object? progress = null,Object? format = null,Object? resolution = null,Object? quality = null,Object? outputUrl = freezed,Object? outputSizeBytes = freezed,Object? renderTimeSeconds = freezed,Object? creditsCost = null,Object? errorMessage = freezed,Object? errorCode = freezed,Object? retryCount = null,Object? startedAt = freezed,Object? completedAt = freezed,Object? createdAt = null,}) {
  return _then(_RenderJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RenderStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,resolution: null == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String,outputUrl: freezed == outputUrl ? _self.outputUrl : outputUrl // ignore: cast_nullable_to_non_nullable
as String?,outputSizeBytes: freezed == outputSizeBytes ? _self.outputSizeBytes : outputSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,renderTimeSeconds: freezed == renderTimeSeconds ? _self.renderTimeSeconds : renderTimeSeconds // ignore: cast_nullable_to_non_nullable
as int?,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$RenderManifest {

 List<RenderScene> get scenes; RenderSettings get settings; RenderOverlays? get overlays;
/// Create a copy of RenderManifest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderManifestCopyWith<RenderManifest> get copyWith => _$RenderManifestCopyWithImpl<RenderManifest>(this as RenderManifest, _$identity);

  /// Serializes this RenderManifest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderManifest&&const DeepCollectionEquality().equals(other.scenes, scenes)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.overlays, overlays) || other.overlays == overlays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(scenes),settings,overlays);

@override
String toString() {
  return 'RenderManifest(scenes: $scenes, settings: $settings, overlays: $overlays)';
}


}

/// @nodoc
abstract mixin class $RenderManifestCopyWith<$Res>  {
  factory $RenderManifestCopyWith(RenderManifest value, $Res Function(RenderManifest) _then) = _$RenderManifestCopyWithImpl;
@useResult
$Res call({
 List<RenderScene> scenes, RenderSettings settings, RenderOverlays? overlays
});


$RenderSettingsCopyWith<$Res> get settings;$RenderOverlaysCopyWith<$Res>? get overlays;

}
/// @nodoc
class _$RenderManifestCopyWithImpl<$Res>
    implements $RenderManifestCopyWith<$Res> {
  _$RenderManifestCopyWithImpl(this._self, this._then);

  final RenderManifest _self;
  final $Res Function(RenderManifest) _then;

/// Create a copy of RenderManifest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scenes = null,Object? settings = null,Object? overlays = freezed,}) {
  return _then(_self.copyWith(
scenes: null == scenes ? _self.scenes : scenes // ignore: cast_nullable_to_non_nullable
as List<RenderScene>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as RenderSettings,overlays: freezed == overlays ? _self.overlays : overlays // ignore: cast_nullable_to_non_nullable
as RenderOverlays?,
  ));
}
/// Create a copy of RenderManifest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderSettingsCopyWith<$Res> get settings {
  
  return $RenderSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of RenderManifest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderOverlaysCopyWith<$Res>? get overlays {
    if (_self.overlays == null) {
    return null;
  }

  return $RenderOverlaysCopyWith<$Res>(_self.overlays!, (value) {
    return _then(_self.copyWith(overlays: value));
  });
}
}


/// Adds pattern-matching-related methods to [RenderManifest].
extension RenderManifestPatterns on RenderManifest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderManifest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderManifest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderManifest value)  $default,){
final _that = this;
switch (_that) {
case _RenderManifest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderManifest value)?  $default,){
final _that = this;
switch (_that) {
case _RenderManifest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RenderScene> scenes,  RenderSettings settings,  RenderOverlays? overlays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderManifest() when $default != null:
return $default(_that.scenes,_that.settings,_that.overlays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RenderScene> scenes,  RenderSettings settings,  RenderOverlays? overlays)  $default,) {final _that = this;
switch (_that) {
case _RenderManifest():
return $default(_that.scenes,_that.settings,_that.overlays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RenderScene> scenes,  RenderSettings settings,  RenderOverlays? overlays)?  $default,) {final _that = this;
switch (_that) {
case _RenderManifest() when $default != null:
return $default(_that.scenes,_that.settings,_that.overlays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderManifest implements RenderManifest {
  const _RenderManifest({required final  List<RenderScene> scenes, required this.settings, this.overlays}): _scenes = scenes;
  factory _RenderManifest.fromJson(Map<String, dynamic> json) => _$RenderManifestFromJson(json);

 final  List<RenderScene> _scenes;
@override List<RenderScene> get scenes {
  if (_scenes is EqualUnmodifiableListView) return _scenes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scenes);
}

@override final  RenderSettings settings;
@override final  RenderOverlays? overlays;

/// Create a copy of RenderManifest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderManifestCopyWith<_RenderManifest> get copyWith => __$RenderManifestCopyWithImpl<_RenderManifest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderManifestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderManifest&&const DeepCollectionEquality().equals(other._scenes, _scenes)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.overlays, overlays) || other.overlays == overlays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_scenes),settings,overlays);

@override
String toString() {
  return 'RenderManifest(scenes: $scenes, settings: $settings, overlays: $overlays)';
}


}

/// @nodoc
abstract mixin class _$RenderManifestCopyWith<$Res> implements $RenderManifestCopyWith<$Res> {
  factory _$RenderManifestCopyWith(_RenderManifest value, $Res Function(_RenderManifest) _then) = __$RenderManifestCopyWithImpl;
@override @useResult
$Res call({
 List<RenderScene> scenes, RenderSettings settings, RenderOverlays? overlays
});


@override $RenderSettingsCopyWith<$Res> get settings;@override $RenderOverlaysCopyWith<$Res>? get overlays;

}
/// @nodoc
class __$RenderManifestCopyWithImpl<$Res>
    implements _$RenderManifestCopyWith<$Res> {
  __$RenderManifestCopyWithImpl(this._self, this._then);

  final _RenderManifest _self;
  final $Res Function(_RenderManifest) _then;

/// Create a copy of RenderManifest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scenes = null,Object? settings = null,Object? overlays = freezed,}) {
  return _then(_RenderManifest(
scenes: null == scenes ? _self._scenes : scenes // ignore: cast_nullable_to_non_nullable
as List<RenderScene>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as RenderSettings,overlays: freezed == overlays ? _self.overlays : overlays // ignore: cast_nullable_to_non_nullable
as RenderOverlays?,
  ));
}

/// Create a copy of RenderManifest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderSettingsCopyWith<$Res> get settings {
  
  return $RenderSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of RenderManifest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderOverlaysCopyWith<$Res>? get overlays {
    if (_self.overlays == null) {
    return null;
  }

  return $RenderOverlaysCopyWith<$Res>(_self.overlays!, (value) {
    return _then(_self.copyWith(overlays: value));
  });
}
}


/// @nodoc
mixin _$RenderScene {

 int get index; String get type;// 'image' | 'video'
 String get url; int get duration;// بالمللي ثانية
 String? get audioUrl; String get transition; List<Map<String, dynamic>> get layers;
/// Create a copy of RenderScene
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderSceneCopyWith<RenderScene> get copyWith => _$RenderSceneCopyWithImpl<RenderScene>(this as RenderScene, _$identity);

  /// Serializes this RenderScene to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderScene&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.transition, transition) || other.transition == transition)&&const DeepCollectionEquality().equals(other.layers, layers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,type,url,duration,audioUrl,transition,const DeepCollectionEquality().hash(layers));

@override
String toString() {
  return 'RenderScene(index: $index, type: $type, url: $url, duration: $duration, audioUrl: $audioUrl, transition: $transition, layers: $layers)';
}


}

/// @nodoc
abstract mixin class $RenderSceneCopyWith<$Res>  {
  factory $RenderSceneCopyWith(RenderScene value, $Res Function(RenderScene) _then) = _$RenderSceneCopyWithImpl;
@useResult
$Res call({
 int index, String type, String url, int duration, String? audioUrl, String transition, List<Map<String, dynamic>> layers
});




}
/// @nodoc
class _$RenderSceneCopyWithImpl<$Res>
    implements $RenderSceneCopyWith<$Res> {
  _$RenderSceneCopyWithImpl(this._self, this._then);

  final RenderScene _self;
  final $Res Function(RenderScene) _then;

/// Create a copy of RenderScene
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? type = null,Object? url = null,Object? duration = null,Object? audioUrl = freezed,Object? transition = null,Object? layers = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,transition: null == transition ? _self.transition : transition // ignore: cast_nullable_to_non_nullable
as String,layers: null == layers ? _self.layers : layers // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderScene].
extension RenderScenePatterns on RenderScene {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderScene value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderScene() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderScene value)  $default,){
final _that = this;
switch (_that) {
case _RenderScene():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderScene value)?  $default,){
final _that = this;
switch (_that) {
case _RenderScene() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String type,  String url,  int duration,  String? audioUrl,  String transition,  List<Map<String, dynamic>> layers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderScene() when $default != null:
return $default(_that.index,_that.type,_that.url,_that.duration,_that.audioUrl,_that.transition,_that.layers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String type,  String url,  int duration,  String? audioUrl,  String transition,  List<Map<String, dynamic>> layers)  $default,) {final _that = this;
switch (_that) {
case _RenderScene():
return $default(_that.index,_that.type,_that.url,_that.duration,_that.audioUrl,_that.transition,_that.layers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String type,  String url,  int duration,  String? audioUrl,  String transition,  List<Map<String, dynamic>> layers)?  $default,) {final _that = this;
switch (_that) {
case _RenderScene() when $default != null:
return $default(_that.index,_that.type,_that.url,_that.duration,_that.audioUrl,_that.transition,_that.layers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderScene implements RenderScene {
  const _RenderScene({required this.index, required this.type, required this.url, required this.duration, this.audioUrl, required this.transition, final  List<Map<String, dynamic>> layers = const []}): _layers = layers;
  factory _RenderScene.fromJson(Map<String, dynamic> json) => _$RenderSceneFromJson(json);

@override final  int index;
@override final  String type;
// 'image' | 'video'
@override final  String url;
@override final  int duration;
// بالمللي ثانية
@override final  String? audioUrl;
@override final  String transition;
 final  List<Map<String, dynamic>> _layers;
@override@JsonKey() List<Map<String, dynamic>> get layers {
  if (_layers is EqualUnmodifiableListView) return _layers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_layers);
}


/// Create a copy of RenderScene
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderSceneCopyWith<_RenderScene> get copyWith => __$RenderSceneCopyWithImpl<_RenderScene>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderSceneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderScene&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.transition, transition) || other.transition == transition)&&const DeepCollectionEquality().equals(other._layers, _layers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,type,url,duration,audioUrl,transition,const DeepCollectionEquality().hash(_layers));

@override
String toString() {
  return 'RenderScene(index: $index, type: $type, url: $url, duration: $duration, audioUrl: $audioUrl, transition: $transition, layers: $layers)';
}


}

/// @nodoc
abstract mixin class _$RenderSceneCopyWith<$Res> implements $RenderSceneCopyWith<$Res> {
  factory _$RenderSceneCopyWith(_RenderScene value, $Res Function(_RenderScene) _then) = __$RenderSceneCopyWithImpl;
@override @useResult
$Res call({
 int index, String type, String url, int duration, String? audioUrl, String transition, List<Map<String, dynamic>> layers
});




}
/// @nodoc
class __$RenderSceneCopyWithImpl<$Res>
    implements _$RenderSceneCopyWith<$Res> {
  __$RenderSceneCopyWithImpl(this._self, this._then);

  final _RenderScene _self;
  final $Res Function(_RenderScene) _then;

/// Create a copy of RenderScene
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? type = null,Object? url = null,Object? duration = null,Object? audioUrl = freezed,Object? transition = null,Object? layers = null,}) {
  return _then(_RenderScene(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,transition: null == transition ? _self.transition : transition // ignore: cast_nullable_to_non_nullable
as String,layers: null == layers ? _self._layers : layers // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}


/// @nodoc
mixin _$RenderSettings {

 int get width; int get height; int get fps; String get format; String get quality;// حقول إضافية للتوافق
 String? get resolution; String? get videoBitrate; String? get audioBitrate; int? get audioSampleRate; bool? get includeWatermark;
/// Create a copy of RenderSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderSettingsCopyWith<RenderSettings> get copyWith => _$RenderSettingsCopyWithImpl<RenderSettings>(this as RenderSettings, _$identity);

  /// Serializes this RenderSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderSettings&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.fps, fps) || other.fps == fps)&&(identical(other.format, format) || other.format == format)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&(identical(other.videoBitrate, videoBitrate) || other.videoBitrate == videoBitrate)&&(identical(other.audioBitrate, audioBitrate) || other.audioBitrate == audioBitrate)&&(identical(other.audioSampleRate, audioSampleRate) || other.audioSampleRate == audioSampleRate)&&(identical(other.includeWatermark, includeWatermark) || other.includeWatermark == includeWatermark));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,fps,format,quality,resolution,videoBitrate,audioBitrate,audioSampleRate,includeWatermark);

@override
String toString() {
  return 'RenderSettings(width: $width, height: $height, fps: $fps, format: $format, quality: $quality, resolution: $resolution, videoBitrate: $videoBitrate, audioBitrate: $audioBitrate, audioSampleRate: $audioSampleRate, includeWatermark: $includeWatermark)';
}


}

/// @nodoc
abstract mixin class $RenderSettingsCopyWith<$Res>  {
  factory $RenderSettingsCopyWith(RenderSettings value, $Res Function(RenderSettings) _then) = _$RenderSettingsCopyWithImpl;
@useResult
$Res call({
 int width, int height, int fps, String format, String quality, String? resolution, String? videoBitrate, String? audioBitrate, int? audioSampleRate, bool? includeWatermark
});




}
/// @nodoc
class _$RenderSettingsCopyWithImpl<$Res>
    implements $RenderSettingsCopyWith<$Res> {
  _$RenderSettingsCopyWithImpl(this._self, this._then);

  final RenderSettings _self;
  final $Res Function(RenderSettings) _then;

/// Create a copy of RenderSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,Object? fps = null,Object? format = null,Object? quality = null,Object? resolution = freezed,Object? videoBitrate = freezed,Object? audioBitrate = freezed,Object? audioSampleRate = freezed,Object? includeWatermark = freezed,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,fps: null == fps ? _self.fps : fps // ignore: cast_nullable_to_non_nullable
as int,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,videoBitrate: freezed == videoBitrate ? _self.videoBitrate : videoBitrate // ignore: cast_nullable_to_non_nullable
as String?,audioBitrate: freezed == audioBitrate ? _self.audioBitrate : audioBitrate // ignore: cast_nullable_to_non_nullable
as String?,audioSampleRate: freezed == audioSampleRate ? _self.audioSampleRate : audioSampleRate // ignore: cast_nullable_to_non_nullable
as int?,includeWatermark: freezed == includeWatermark ? _self.includeWatermark : includeWatermark // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderSettings].
extension RenderSettingsPatterns on RenderSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderSettings value)  $default,){
final _that = this;
switch (_that) {
case _RenderSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderSettings value)?  $default,){
final _that = this;
switch (_that) {
case _RenderSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int width,  int height,  int fps,  String format,  String quality,  String? resolution,  String? videoBitrate,  String? audioBitrate,  int? audioSampleRate,  bool? includeWatermark)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderSettings() when $default != null:
return $default(_that.width,_that.height,_that.fps,_that.format,_that.quality,_that.resolution,_that.videoBitrate,_that.audioBitrate,_that.audioSampleRate,_that.includeWatermark);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int width,  int height,  int fps,  String format,  String quality,  String? resolution,  String? videoBitrate,  String? audioBitrate,  int? audioSampleRate,  bool? includeWatermark)  $default,) {final _that = this;
switch (_that) {
case _RenderSettings():
return $default(_that.width,_that.height,_that.fps,_that.format,_that.quality,_that.resolution,_that.videoBitrate,_that.audioBitrate,_that.audioSampleRate,_that.includeWatermark);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int width,  int height,  int fps,  String format,  String quality,  String? resolution,  String? videoBitrate,  String? audioBitrate,  int? audioSampleRate,  bool? includeWatermark)?  $default,) {final _that = this;
switch (_that) {
case _RenderSettings() when $default != null:
return $default(_that.width,_that.height,_that.fps,_that.format,_that.quality,_that.resolution,_that.videoBitrate,_that.audioBitrate,_that.audioSampleRate,_that.includeWatermark);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderSettings extends RenderSettings {
  const _RenderSettings({required this.width, required this.height, required this.fps, required this.format, required this.quality, this.resolution, this.videoBitrate, this.audioBitrate, this.audioSampleRate, this.includeWatermark}): super._();
  factory _RenderSettings.fromJson(Map<String, dynamic> json) => _$RenderSettingsFromJson(json);

@override final  int width;
@override final  int height;
@override final  int fps;
@override final  String format;
@override final  String quality;
// حقول إضافية للتوافق
@override final  String? resolution;
@override final  String? videoBitrate;
@override final  String? audioBitrate;
@override final  int? audioSampleRate;
@override final  bool? includeWatermark;

/// Create a copy of RenderSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderSettingsCopyWith<_RenderSettings> get copyWith => __$RenderSettingsCopyWithImpl<_RenderSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderSettings&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.fps, fps) || other.fps == fps)&&(identical(other.format, format) || other.format == format)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&(identical(other.videoBitrate, videoBitrate) || other.videoBitrate == videoBitrate)&&(identical(other.audioBitrate, audioBitrate) || other.audioBitrate == audioBitrate)&&(identical(other.audioSampleRate, audioSampleRate) || other.audioSampleRate == audioSampleRate)&&(identical(other.includeWatermark, includeWatermark) || other.includeWatermark == includeWatermark));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,fps,format,quality,resolution,videoBitrate,audioBitrate,audioSampleRate,includeWatermark);

@override
String toString() {
  return 'RenderSettings(width: $width, height: $height, fps: $fps, format: $format, quality: $quality, resolution: $resolution, videoBitrate: $videoBitrate, audioBitrate: $audioBitrate, audioSampleRate: $audioSampleRate, includeWatermark: $includeWatermark)';
}


}

/// @nodoc
abstract mixin class _$RenderSettingsCopyWith<$Res> implements $RenderSettingsCopyWith<$Res> {
  factory _$RenderSettingsCopyWith(_RenderSettings value, $Res Function(_RenderSettings) _then) = __$RenderSettingsCopyWithImpl;
@override @useResult
$Res call({
 int width, int height, int fps, String format, String quality, String? resolution, String? videoBitrate, String? audioBitrate, int? audioSampleRate, bool? includeWatermark
});




}
/// @nodoc
class __$RenderSettingsCopyWithImpl<$Res>
    implements _$RenderSettingsCopyWith<$Res> {
  __$RenderSettingsCopyWithImpl(this._self, this._then);

  final _RenderSettings _self;
  final $Res Function(_RenderSettings) _then;

/// Create a copy of RenderSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,Object? fps = null,Object? format = null,Object? quality = null,Object? resolution = freezed,Object? videoBitrate = freezed,Object? audioBitrate = freezed,Object? audioSampleRate = freezed,Object? includeWatermark = freezed,}) {
  return _then(_RenderSettings(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,fps: null == fps ? _self.fps : fps // ignore: cast_nullable_to_non_nullable
as int,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,videoBitrate: freezed == videoBitrate ? _self.videoBitrate : videoBitrate // ignore: cast_nullable_to_non_nullable
as String?,audioBitrate: freezed == audioBitrate ? _self.audioBitrate : audioBitrate // ignore: cast_nullable_to_non_nullable
as String?,audioSampleRate: freezed == audioSampleRate ? _self.audioSampleRate : audioSampleRate // ignore: cast_nullable_to_non_nullable
as int?,includeWatermark: freezed == includeWatermark ? _self.includeWatermark : includeWatermark // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$RenderOverlays {

 RenderLogo? get logo; RenderWatermark? get watermark;
/// Create a copy of RenderOverlays
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderOverlaysCopyWith<RenderOverlays> get copyWith => _$RenderOverlaysCopyWithImpl<RenderOverlays>(this as RenderOverlays, _$identity);

  /// Serializes this RenderOverlays to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderOverlays&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.watermark, watermark) || other.watermark == watermark));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logo,watermark);

@override
String toString() {
  return 'RenderOverlays(logo: $logo, watermark: $watermark)';
}


}

/// @nodoc
abstract mixin class $RenderOverlaysCopyWith<$Res>  {
  factory $RenderOverlaysCopyWith(RenderOverlays value, $Res Function(RenderOverlays) _then) = _$RenderOverlaysCopyWithImpl;
@useResult
$Res call({
 RenderLogo? logo, RenderWatermark? watermark
});


$RenderLogoCopyWith<$Res>? get logo;$RenderWatermarkCopyWith<$Res>? get watermark;

}
/// @nodoc
class _$RenderOverlaysCopyWithImpl<$Res>
    implements $RenderOverlaysCopyWith<$Res> {
  _$RenderOverlaysCopyWithImpl(this._self, this._then);

  final RenderOverlays _self;
  final $Res Function(RenderOverlays) _then;

/// Create a copy of RenderOverlays
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logo = freezed,Object? watermark = freezed,}) {
  return _then(_self.copyWith(
logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as RenderLogo?,watermark: freezed == watermark ? _self.watermark : watermark // ignore: cast_nullable_to_non_nullable
as RenderWatermark?,
  ));
}
/// Create a copy of RenderOverlays
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderLogoCopyWith<$Res>? get logo {
    if (_self.logo == null) {
    return null;
  }

  return $RenderLogoCopyWith<$Res>(_self.logo!, (value) {
    return _then(_self.copyWith(logo: value));
  });
}/// Create a copy of RenderOverlays
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderWatermarkCopyWith<$Res>? get watermark {
    if (_self.watermark == null) {
    return null;
  }

  return $RenderWatermarkCopyWith<$Res>(_self.watermark!, (value) {
    return _then(_self.copyWith(watermark: value));
  });
}
}


/// Adds pattern-matching-related methods to [RenderOverlays].
extension RenderOverlaysPatterns on RenderOverlays {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderOverlays value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderOverlays() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderOverlays value)  $default,){
final _that = this;
switch (_that) {
case _RenderOverlays():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderOverlays value)?  $default,){
final _that = this;
switch (_that) {
case _RenderOverlays() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RenderLogo? logo,  RenderWatermark? watermark)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderOverlays() when $default != null:
return $default(_that.logo,_that.watermark);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RenderLogo? logo,  RenderWatermark? watermark)  $default,) {final _that = this;
switch (_that) {
case _RenderOverlays():
return $default(_that.logo,_that.watermark);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RenderLogo? logo,  RenderWatermark? watermark)?  $default,) {final _that = this;
switch (_that) {
case _RenderOverlays() when $default != null:
return $default(_that.logo,_that.watermark);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderOverlays implements RenderOverlays {
  const _RenderOverlays({this.logo, this.watermark});
  factory _RenderOverlays.fromJson(Map<String, dynamic> json) => _$RenderOverlaysFromJson(json);

@override final  RenderLogo? logo;
@override final  RenderWatermark? watermark;

/// Create a copy of RenderOverlays
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderOverlaysCopyWith<_RenderOverlays> get copyWith => __$RenderOverlaysCopyWithImpl<_RenderOverlays>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderOverlaysToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderOverlays&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.watermark, watermark) || other.watermark == watermark));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logo,watermark);

@override
String toString() {
  return 'RenderOverlays(logo: $logo, watermark: $watermark)';
}


}

/// @nodoc
abstract mixin class _$RenderOverlaysCopyWith<$Res> implements $RenderOverlaysCopyWith<$Res> {
  factory _$RenderOverlaysCopyWith(_RenderOverlays value, $Res Function(_RenderOverlays) _then) = __$RenderOverlaysCopyWithImpl;
@override @useResult
$Res call({
 RenderLogo? logo, RenderWatermark? watermark
});


@override $RenderLogoCopyWith<$Res>? get logo;@override $RenderWatermarkCopyWith<$Res>? get watermark;

}
/// @nodoc
class __$RenderOverlaysCopyWithImpl<$Res>
    implements _$RenderOverlaysCopyWith<$Res> {
  __$RenderOverlaysCopyWithImpl(this._self, this._then);

  final _RenderOverlays _self;
  final $Res Function(_RenderOverlays) _then;

/// Create a copy of RenderOverlays
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logo = freezed,Object? watermark = freezed,}) {
  return _then(_RenderOverlays(
logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as RenderLogo?,watermark: freezed == watermark ? _self.watermark : watermark // ignore: cast_nullable_to_non_nullable
as RenderWatermark?,
  ));
}

/// Create a copy of RenderOverlays
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderLogoCopyWith<$Res>? get logo {
    if (_self.logo == null) {
    return null;
  }

  return $RenderLogoCopyWith<$Res>(_self.logo!, (value) {
    return _then(_self.copyWith(logo: value));
  });
}/// Create a copy of RenderOverlays
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderWatermarkCopyWith<$Res>? get watermark {
    if (_self.watermark == null) {
    return null;
  }

  return $RenderWatermarkCopyWith<$Res>(_self.watermark!, (value) {
    return _then(_self.copyWith(watermark: value));
  });
}
}


/// @nodoc
mixin _$RenderLogo {

 String get url; String get position;
/// Create a copy of RenderLogo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderLogoCopyWith<RenderLogo> get copyWith => _$RenderLogoCopyWithImpl<RenderLogo>(this as RenderLogo, _$identity);

  /// Serializes this RenderLogo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderLogo&&(identical(other.url, url) || other.url == url)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,position);

@override
String toString() {
  return 'RenderLogo(url: $url, position: $position)';
}


}

/// @nodoc
abstract mixin class $RenderLogoCopyWith<$Res>  {
  factory $RenderLogoCopyWith(RenderLogo value, $Res Function(RenderLogo) _then) = _$RenderLogoCopyWithImpl;
@useResult
$Res call({
 String url, String position
});




}
/// @nodoc
class _$RenderLogoCopyWithImpl<$Res>
    implements $RenderLogoCopyWith<$Res> {
  _$RenderLogoCopyWithImpl(this._self, this._then);

  final RenderLogo _self;
  final $Res Function(RenderLogo) _then;

/// Create a copy of RenderLogo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? position = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderLogo].
extension RenderLogoPatterns on RenderLogo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderLogo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderLogo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderLogo value)  $default,){
final _that = this;
switch (_that) {
case _RenderLogo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderLogo value)?  $default,){
final _that = this;
switch (_that) {
case _RenderLogo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderLogo() when $default != null:
return $default(_that.url,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String position)  $default,) {final _that = this;
switch (_that) {
case _RenderLogo():
return $default(_that.url,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String position)?  $default,) {final _that = this;
switch (_that) {
case _RenderLogo() when $default != null:
return $default(_that.url,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderLogo implements RenderLogo {
  const _RenderLogo({required this.url, this.position = 'bottom-right'});
  factory _RenderLogo.fromJson(Map<String, dynamic> json) => _$RenderLogoFromJson(json);

@override final  String url;
@override@JsonKey() final  String position;

/// Create a copy of RenderLogo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderLogoCopyWith<_RenderLogo> get copyWith => __$RenderLogoCopyWithImpl<_RenderLogo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderLogoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderLogo&&(identical(other.url, url) || other.url == url)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,position);

@override
String toString() {
  return 'RenderLogo(url: $url, position: $position)';
}


}

/// @nodoc
abstract mixin class _$RenderLogoCopyWith<$Res> implements $RenderLogoCopyWith<$Res> {
  factory _$RenderLogoCopyWith(_RenderLogo value, $Res Function(_RenderLogo) _then) = __$RenderLogoCopyWithImpl;
@override @useResult
$Res call({
 String url, String position
});




}
/// @nodoc
class __$RenderLogoCopyWithImpl<$Res>
    implements _$RenderLogoCopyWith<$Res> {
  __$RenderLogoCopyWithImpl(this._self, this._then);

  final _RenderLogo _self;
  final $Res Function(_RenderLogo) _then;

/// Create a copy of RenderLogo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? position = null,}) {
  return _then(_RenderLogo(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RenderWatermark {

 String get text; String get position;
/// Create a copy of RenderWatermark
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderWatermarkCopyWith<RenderWatermark> get copyWith => _$RenderWatermarkCopyWithImpl<RenderWatermark>(this as RenderWatermark, _$identity);

  /// Serializes this RenderWatermark to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderWatermark&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,position);

@override
String toString() {
  return 'RenderWatermark(text: $text, position: $position)';
}


}

/// @nodoc
abstract mixin class $RenderWatermarkCopyWith<$Res>  {
  factory $RenderWatermarkCopyWith(RenderWatermark value, $Res Function(RenderWatermark) _then) = _$RenderWatermarkCopyWithImpl;
@useResult
$Res call({
 String text, String position
});




}
/// @nodoc
class _$RenderWatermarkCopyWithImpl<$Res>
    implements $RenderWatermarkCopyWith<$Res> {
  _$RenderWatermarkCopyWithImpl(this._self, this._then);

  final RenderWatermark _self;
  final $Res Function(RenderWatermark) _then;

/// Create a copy of RenderWatermark
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? position = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderWatermark].
extension RenderWatermarkPatterns on RenderWatermark {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderWatermark value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderWatermark() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderWatermark value)  $default,){
final _that = this;
switch (_that) {
case _RenderWatermark():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderWatermark value)?  $default,){
final _that = this;
switch (_that) {
case _RenderWatermark() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderWatermark() when $default != null:
return $default(_that.text,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String position)  $default,) {final _that = this;
switch (_that) {
case _RenderWatermark():
return $default(_that.text,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String position)?  $default,) {final _that = this;
switch (_that) {
case _RenderWatermark() when $default != null:
return $default(_that.text,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderWatermark implements RenderWatermark {
  const _RenderWatermark({required this.text, this.position = 'bottom-center'});
  factory _RenderWatermark.fromJson(Map<String, dynamic> json) => _$RenderWatermarkFromJson(json);

@override final  String text;
@override@JsonKey() final  String position;

/// Create a copy of RenderWatermark
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderWatermarkCopyWith<_RenderWatermark> get copyWith => __$RenderWatermarkCopyWithImpl<_RenderWatermark>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderWatermarkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderWatermark&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,position);

@override
String toString() {
  return 'RenderWatermark(text: $text, position: $position)';
}


}

/// @nodoc
abstract mixin class _$RenderWatermarkCopyWith<$Res> implements $RenderWatermarkCopyWith<$Res> {
  factory _$RenderWatermarkCopyWith(_RenderWatermark value, $Res Function(_RenderWatermark) _then) = __$RenderWatermarkCopyWithImpl;
@override @useResult
$Res call({
 String text, String position
});




}
/// @nodoc
class __$RenderWatermarkCopyWithImpl<$Res>
    implements _$RenderWatermarkCopyWith<$Res> {
  __$RenderWatermarkCopyWithImpl(this._self, this._then);

  final _RenderWatermark _self;
  final $Res Function(_RenderWatermark) _then;

/// Create a copy of RenderWatermark
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? position = null,}) {
  return _then(_RenderWatermark(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
