// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SceneConfig {

 SceneType get type; int get duration; String get prompt;
/// Create a copy of SceneConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneConfigCopyWith<SceneConfig> get copyWith => _$SceneConfigCopyWithImpl<SceneConfig>(this as SceneConfig, _$identity);

  /// Serializes this SceneConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneConfig&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.prompt, prompt) || other.prompt == prompt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,duration,prompt);

@override
String toString() {
  return 'SceneConfig(type: $type, duration: $duration, prompt: $prompt)';
}


}

/// @nodoc
abstract mixin class $SceneConfigCopyWith<$Res>  {
  factory $SceneConfigCopyWith(SceneConfig value, $Res Function(SceneConfig) _then) = _$SceneConfigCopyWithImpl;
@useResult
$Res call({
 SceneType type, int duration, String prompt
});




}
/// @nodoc
class _$SceneConfigCopyWithImpl<$Res>
    implements $SceneConfigCopyWith<$Res> {
  _$SceneConfigCopyWithImpl(this._self, this._then);

  final SceneConfig _self;
  final $Res Function(SceneConfig) _then;

/// Create a copy of SceneConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? duration = null,Object? prompt = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SceneType,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SceneConfig].
extension SceneConfigPatterns on SceneConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneConfig value)  $default,){
final _that = this;
switch (_that) {
case _SceneConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SceneConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SceneType type,  int duration,  String prompt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneConfig() when $default != null:
return $default(_that.type,_that.duration,_that.prompt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SceneType type,  int duration,  String prompt)  $default,) {final _that = this;
switch (_that) {
case _SceneConfig():
return $default(_that.type,_that.duration,_that.prompt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SceneType type,  int duration,  String prompt)?  $default,) {final _that = this;
switch (_that) {
case _SceneConfig() when $default != null:
return $default(_that.type,_that.duration,_that.prompt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SceneConfig implements SceneConfig {
  const _SceneConfig({this.type = SceneType.image, this.duration = 5000, this.prompt = ''});
  factory _SceneConfig.fromJson(Map<String, dynamic> json) => _$SceneConfigFromJson(json);

@override@JsonKey() final  SceneType type;
@override@JsonKey() final  int duration;
@override@JsonKey() final  String prompt;

/// Create a copy of SceneConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneConfigCopyWith<_SceneConfig> get copyWith => __$SceneConfigCopyWithImpl<_SceneConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneConfig&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.prompt, prompt) || other.prompt == prompt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,duration,prompt);

@override
String toString() {
  return 'SceneConfig(type: $type, duration: $duration, prompt: $prompt)';
}


}

/// @nodoc
abstract mixin class _$SceneConfigCopyWith<$Res> implements $SceneConfigCopyWith<$Res> {
  factory _$SceneConfigCopyWith(_SceneConfig value, $Res Function(_SceneConfig) _then) = __$SceneConfigCopyWithImpl;
@override @useResult
$Res call({
 SceneType type, int duration, String prompt
});




}
/// @nodoc
class __$SceneConfigCopyWithImpl<$Res>
    implements _$SceneConfigCopyWith<$Res> {
  __$SceneConfigCopyWithImpl(this._self, this._then);

  final _SceneConfig _self;
  final $Res Function(_SceneConfig) _then;

/// Create a copy of SceneConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? duration = null,Object? prompt = null,}) {
  return _then(_SceneConfig(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SceneType,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StudioTemplate {

 String get id; String get name; String? get nameAr; String? get description; String? get descriptionAr; TemplateCategory get category; String? get thumbnailUrl; String? get previewVideoUrl; List<SceneConfig> get scenesConfig; int get durationSeconds; String get aspectRatio; bool get isPremium; bool get isPro;// للتوافق مع template_card
 bool get isActive; int get usageCount; int get creditsCost; List<String> get tags; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudioTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioTemplateCopyWith<StudioTemplate> get copyWith => _$StudioTemplateCopyWithImpl<StudioTemplate>(this as StudioTemplate, _$identity);

  /// Serializes this StudioTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.category, category) || other.category == category)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.previewVideoUrl, previewVideoUrl) || other.previewVideoUrl == previewVideoUrl)&&const DeepCollectionEquality().equals(other.scenesConfig, scenesConfig)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,nameAr,description,descriptionAr,category,thumbnailUrl,previewVideoUrl,const DeepCollectionEquality().hash(scenesConfig),durationSeconds,aspectRatio,isPremium,isPro,isActive,usageCount,creditsCost,const DeepCollectionEquality().hash(tags),createdAt,updatedAt]);

@override
String toString() {
  return 'StudioTemplate(id: $id, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, category: $category, thumbnailUrl: $thumbnailUrl, previewVideoUrl: $previewVideoUrl, scenesConfig: $scenesConfig, durationSeconds: $durationSeconds, aspectRatio: $aspectRatio, isPremium: $isPremium, isPro: $isPro, isActive: $isActive, usageCount: $usageCount, creditsCost: $creditsCost, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudioTemplateCopyWith<$Res>  {
  factory $StudioTemplateCopyWith(StudioTemplate value, $Res Function(StudioTemplate) _then) = _$StudioTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? nameAr, String? description, String? descriptionAr, TemplateCategory category, String? thumbnailUrl, String? previewVideoUrl, List<SceneConfig> scenesConfig, int durationSeconds, String aspectRatio, bool isPremium, bool isPro, bool isActive, int usageCount, int creditsCost, List<String> tags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudioTemplateCopyWithImpl<$Res>
    implements $StudioTemplateCopyWith<$Res> {
  _$StudioTemplateCopyWithImpl(this._self, this._then);

  final StudioTemplate _self;
  final $Res Function(StudioTemplate) _then;

/// Create a copy of StudioTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameAr = freezed,Object? description = freezed,Object? descriptionAr = freezed,Object? category = null,Object? thumbnailUrl = freezed,Object? previewVideoUrl = freezed,Object? scenesConfig = null,Object? durationSeconds = null,Object? aspectRatio = null,Object? isPremium = null,Object? isPro = null,Object? isActive = null,Object? usageCount = null,Object? creditsCost = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TemplateCategory,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,previewVideoUrl: freezed == previewVideoUrl ? _self.previewVideoUrl : previewVideoUrl // ignore: cast_nullable_to_non_nullable
as String?,scenesConfig: null == scenesConfig ? _self.scenesConfig : scenesConfig // ignore: cast_nullable_to_non_nullable
as List<SceneConfig>,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as String,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StudioTemplate].
extension StudioTemplatePatterns on StudioTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioTemplate value)  $default,){
final _that = this;
switch (_that) {
case _StudioTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _StudioTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? nameAr,  String? description,  String? descriptionAr,  TemplateCategory category,  String? thumbnailUrl,  String? previewVideoUrl,  List<SceneConfig> scenesConfig,  int durationSeconds,  String aspectRatio,  bool isPremium,  bool isPro,  bool isActive,  int usageCount,  int creditsCost,  List<String> tags,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioTemplate() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.category,_that.thumbnailUrl,_that.previewVideoUrl,_that.scenesConfig,_that.durationSeconds,_that.aspectRatio,_that.isPremium,_that.isPro,_that.isActive,_that.usageCount,_that.creditsCost,_that.tags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? nameAr,  String? description,  String? descriptionAr,  TemplateCategory category,  String? thumbnailUrl,  String? previewVideoUrl,  List<SceneConfig> scenesConfig,  int durationSeconds,  String aspectRatio,  bool isPremium,  bool isPro,  bool isActive,  int usageCount,  int creditsCost,  List<String> tags,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StudioTemplate():
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.category,_that.thumbnailUrl,_that.previewVideoUrl,_that.scenesConfig,_that.durationSeconds,_that.aspectRatio,_that.isPremium,_that.isPro,_that.isActive,_that.usageCount,_that.creditsCost,_that.tags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? nameAr,  String? description,  String? descriptionAr,  TemplateCategory category,  String? thumbnailUrl,  String? previewVideoUrl,  List<SceneConfig> scenesConfig,  int durationSeconds,  String aspectRatio,  bool isPremium,  bool isPro,  bool isActive,  int usageCount,  int creditsCost,  List<String> tags,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudioTemplate() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.category,_that.thumbnailUrl,_that.previewVideoUrl,_that.scenesConfig,_that.durationSeconds,_that.aspectRatio,_that.isPremium,_that.isPro,_that.isActive,_that.usageCount,_that.creditsCost,_that.tags,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudioTemplate extends StudioTemplate {
  const _StudioTemplate({required this.id, required this.name, this.nameAr, this.description, this.descriptionAr, this.category = TemplateCategory.productAd, this.thumbnailUrl, this.previewVideoUrl, final  List<SceneConfig> scenesConfig = const [], this.durationSeconds = 30, this.aspectRatio = '9:16', this.isPremium = false, this.isPro = false, this.isActive = true, this.usageCount = 0, this.creditsCost = 10, final  List<String> tags = const [], required this.createdAt, required this.updatedAt}): _scenesConfig = scenesConfig,_tags = tags,super._();
  factory _StudioTemplate.fromJson(Map<String, dynamic> json) => _$StudioTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? nameAr;
@override final  String? description;
@override final  String? descriptionAr;
@override@JsonKey() final  TemplateCategory category;
@override final  String? thumbnailUrl;
@override final  String? previewVideoUrl;
 final  List<SceneConfig> _scenesConfig;
@override@JsonKey() List<SceneConfig> get scenesConfig {
  if (_scenesConfig is EqualUnmodifiableListView) return _scenesConfig;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scenesConfig);
}

@override@JsonKey() final  int durationSeconds;
@override@JsonKey() final  String aspectRatio;
@override@JsonKey() final  bool isPremium;
@override@JsonKey() final  bool isPro;
// للتوافق مع template_card
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  int usageCount;
@override@JsonKey() final  int creditsCost;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudioTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioTemplateCopyWith<_StudioTemplate> get copyWith => __$StudioTemplateCopyWithImpl<_StudioTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudioTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.category, category) || other.category == category)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.previewVideoUrl, previewVideoUrl) || other.previewVideoUrl == previewVideoUrl)&&const DeepCollectionEquality().equals(other._scenesConfig, _scenesConfig)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.usageCount, usageCount) || other.usageCount == usageCount)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,nameAr,description,descriptionAr,category,thumbnailUrl,previewVideoUrl,const DeepCollectionEquality().hash(_scenesConfig),durationSeconds,aspectRatio,isPremium,isPro,isActive,usageCount,creditsCost,const DeepCollectionEquality().hash(_tags),createdAt,updatedAt]);

@override
String toString() {
  return 'StudioTemplate(id: $id, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, category: $category, thumbnailUrl: $thumbnailUrl, previewVideoUrl: $previewVideoUrl, scenesConfig: $scenesConfig, durationSeconds: $durationSeconds, aspectRatio: $aspectRatio, isPremium: $isPremium, isPro: $isPro, isActive: $isActive, usageCount: $usageCount, creditsCost: $creditsCost, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudioTemplateCopyWith<$Res> implements $StudioTemplateCopyWith<$Res> {
  factory _$StudioTemplateCopyWith(_StudioTemplate value, $Res Function(_StudioTemplate) _then) = __$StudioTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? nameAr, String? description, String? descriptionAr, TemplateCategory category, String? thumbnailUrl, String? previewVideoUrl, List<SceneConfig> scenesConfig, int durationSeconds, String aspectRatio, bool isPremium, bool isPro, bool isActive, int usageCount, int creditsCost, List<String> tags, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudioTemplateCopyWithImpl<$Res>
    implements _$StudioTemplateCopyWith<$Res> {
  __$StudioTemplateCopyWithImpl(this._self, this._then);

  final _StudioTemplate _self;
  final $Res Function(_StudioTemplate) _then;

/// Create a copy of StudioTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameAr = freezed,Object? description = freezed,Object? descriptionAr = freezed,Object? category = null,Object? thumbnailUrl = freezed,Object? previewVideoUrl = freezed,Object? scenesConfig = null,Object? durationSeconds = null,Object? aspectRatio = null,Object? isPremium = null,Object? isPro = null,Object? isActive = null,Object? usageCount = null,Object? creditsCost = null,Object? tags = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudioTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TemplateCategory,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,previewVideoUrl: freezed == previewVideoUrl ? _self.previewVideoUrl : previewVideoUrl // ignore: cast_nullable_to_non_nullable
as String?,scenesConfig: null == scenesConfig ? _self._scenesConfig : scenesConfig // ignore: cast_nullable_to_non_nullable
as List<SceneConfig>,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as String,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,usageCount: null == usageCount ? _self.usageCount : usageCount // ignore: cast_nullable_to_non_nullable
as int,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
