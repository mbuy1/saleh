// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studio_project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductData {

 String? get name; String? get nameAr; String? get description; String? get descriptionAr; double? get price; String? get currency; List<String> get images; List<String> get features;
/// Create a copy of ProductData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDataCopyWith<ProductData> get copyWith => _$ProductDataCopyWithImpl<ProductData>(this as ProductData, _$identity);

  /// Serializes this ProductData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductData&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.features, features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,nameAr,description,descriptionAr,price,currency,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(features));

@override
String toString() {
  return 'ProductData(name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, price: $price, currency: $currency, images: $images, features: $features)';
}


}

/// @nodoc
abstract mixin class $ProductDataCopyWith<$Res>  {
  factory $ProductDataCopyWith(ProductData value, $Res Function(ProductData) _then) = _$ProductDataCopyWithImpl;
@useResult
$Res call({
 String? name, String? nameAr, String? description, String? descriptionAr, double? price, String? currency, List<String> images, List<String> features
});




}
/// @nodoc
class _$ProductDataCopyWithImpl<$Res>
    implements $ProductDataCopyWith<$Res> {
  _$ProductDataCopyWithImpl(this._self, this._then);

  final ProductData _self;
  final $Res Function(ProductData) _then;

/// Create a copy of ProductData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? nameAr = freezed,Object? description = freezed,Object? descriptionAr = freezed,Object? price = freezed,Object? currency = freezed,Object? images = null,Object? features = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductData].
extension ProductDataPatterns on ProductData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductData value)  $default,){
final _that = this;
switch (_that) {
case _ProductData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductData value)?  $default,){
final _that = this;
switch (_that) {
case _ProductData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? nameAr,  String? description,  String? descriptionAr,  double? price,  String? currency,  List<String> images,  List<String> features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductData() when $default != null:
return $default(_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.price,_that.currency,_that.images,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? nameAr,  String? description,  String? descriptionAr,  double? price,  String? currency,  List<String> images,  List<String> features)  $default,) {final _that = this;
switch (_that) {
case _ProductData():
return $default(_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.price,_that.currency,_that.images,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? nameAr,  String? description,  String? descriptionAr,  double? price,  String? currency,  List<String> images,  List<String> features)?  $default,) {final _that = this;
switch (_that) {
case _ProductData() when $default != null:
return $default(_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.price,_that.currency,_that.images,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductData implements ProductData {
  const _ProductData({this.name, this.nameAr, this.description, this.descriptionAr, this.price, this.currency, final  List<String> images = const [], final  List<String> features = const []}): _images = images,_features = features;
  factory _ProductData.fromJson(Map<String, dynamic> json) => _$ProductDataFromJson(json);

@override final  String? name;
@override final  String? nameAr;
@override final  String? description;
@override final  String? descriptionAr;
@override final  double? price;
@override final  String? currency;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  List<String> _features;
@override@JsonKey() List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}


/// Create a copy of ProductData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDataCopyWith<_ProductData> get copyWith => __$ProductDataCopyWithImpl<_ProductData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductData&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,nameAr,description,descriptionAr,price,currency,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_features));

@override
String toString() {
  return 'ProductData(name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, price: $price, currency: $currency, images: $images, features: $features)';
}


}

/// @nodoc
abstract mixin class _$ProductDataCopyWith<$Res> implements $ProductDataCopyWith<$Res> {
  factory _$ProductDataCopyWith(_ProductData value, $Res Function(_ProductData) _then) = __$ProductDataCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? nameAr, String? description, String? descriptionAr, double? price, String? currency, List<String> images, List<String> features
});




}
/// @nodoc
class __$ProductDataCopyWithImpl<$Res>
    implements _$ProductDataCopyWith<$Res> {
  __$ProductDataCopyWithImpl(this._self, this._then);

  final _ProductData _self;
  final $Res Function(_ProductData) _then;

/// Create a copy of ProductData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? nameAr = freezed,Object? description = freezed,Object? descriptionAr = freezed,Object? price = freezed,Object? currency = freezed,Object? images = null,Object? features = null,}) {
  return _then(_ProductData(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ScriptData {

 String? get title; String? get hook; String? get headline;// للتوافق مع الشاشات
 List<GeneratedScene> get scenes; String? get cta; String? get language;
/// Create a copy of ScriptData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptDataCopyWith<ScriptData> get copyWith => _$ScriptDataCopyWithImpl<ScriptData>(this as ScriptData, _$identity);

  /// Serializes this ScriptData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScriptData&&(identical(other.title, title) || other.title == title)&&(identical(other.hook, hook) || other.hook == hook)&&(identical(other.headline, headline) || other.headline == headline)&&const DeepCollectionEquality().equals(other.scenes, scenes)&&(identical(other.cta, cta) || other.cta == cta)&&(identical(other.language, language) || other.language == language));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,hook,headline,const DeepCollectionEquality().hash(scenes),cta,language);

@override
String toString() {
  return 'ScriptData(title: $title, hook: $hook, headline: $headline, scenes: $scenes, cta: $cta, language: $language)';
}


}

/// @nodoc
abstract mixin class $ScriptDataCopyWith<$Res>  {
  factory $ScriptDataCopyWith(ScriptData value, $Res Function(ScriptData) _then) = _$ScriptDataCopyWithImpl;
@useResult
$Res call({
 String? title, String? hook, String? headline, List<GeneratedScene> scenes, String? cta, String? language
});




}
/// @nodoc
class _$ScriptDataCopyWithImpl<$Res>
    implements $ScriptDataCopyWith<$Res> {
  _$ScriptDataCopyWithImpl(this._self, this._then);

  final ScriptData _self;
  final $Res Function(ScriptData) _then;

/// Create a copy of ScriptData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? hook = freezed,Object? headline = freezed,Object? scenes = null,Object? cta = freezed,Object? language = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,hook: freezed == hook ? _self.hook : hook // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,scenes: null == scenes ? _self.scenes : scenes // ignore: cast_nullable_to_non_nullable
as List<GeneratedScene>,cta: freezed == cta ? _self.cta : cta // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScriptData].
extension ScriptDataPatterns on ScriptData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScriptData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScriptData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScriptData value)  $default,){
final _that = this;
switch (_that) {
case _ScriptData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScriptData value)?  $default,){
final _that = this;
switch (_that) {
case _ScriptData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? hook,  String? headline,  List<GeneratedScene> scenes,  String? cta,  String? language)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScriptData() when $default != null:
return $default(_that.title,_that.hook,_that.headline,_that.scenes,_that.cta,_that.language);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? hook,  String? headline,  List<GeneratedScene> scenes,  String? cta,  String? language)  $default,) {final _that = this;
switch (_that) {
case _ScriptData():
return $default(_that.title,_that.hook,_that.headline,_that.scenes,_that.cta,_that.language);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? hook,  String? headline,  List<GeneratedScene> scenes,  String? cta,  String? language)?  $default,) {final _that = this;
switch (_that) {
case _ScriptData() when $default != null:
return $default(_that.title,_that.hook,_that.headline,_that.scenes,_that.cta,_that.language);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScriptData implements ScriptData {
  const _ScriptData({this.title, this.hook, this.headline, final  List<GeneratedScene> scenes = const [], this.cta, this.language}): _scenes = scenes;
  factory _ScriptData.fromJson(Map<String, dynamic> json) => _$ScriptDataFromJson(json);

@override final  String? title;
@override final  String? hook;
@override final  String? headline;
// للتوافق مع الشاشات
 final  List<GeneratedScene> _scenes;
// للتوافق مع الشاشات
@override@JsonKey() List<GeneratedScene> get scenes {
  if (_scenes is EqualUnmodifiableListView) return _scenes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scenes);
}

@override final  String? cta;
@override final  String? language;

/// Create a copy of ScriptData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScriptDataCopyWith<_ScriptData> get copyWith => __$ScriptDataCopyWithImpl<_ScriptData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScriptDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScriptData&&(identical(other.title, title) || other.title == title)&&(identical(other.hook, hook) || other.hook == hook)&&(identical(other.headline, headline) || other.headline == headline)&&const DeepCollectionEquality().equals(other._scenes, _scenes)&&(identical(other.cta, cta) || other.cta == cta)&&(identical(other.language, language) || other.language == language));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,hook,headline,const DeepCollectionEquality().hash(_scenes),cta,language);

@override
String toString() {
  return 'ScriptData(title: $title, hook: $hook, headline: $headline, scenes: $scenes, cta: $cta, language: $language)';
}


}

/// @nodoc
abstract mixin class _$ScriptDataCopyWith<$Res> implements $ScriptDataCopyWith<$Res> {
  factory _$ScriptDataCopyWith(_ScriptData value, $Res Function(_ScriptData) _then) = __$ScriptDataCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? hook, String? headline, List<GeneratedScene> scenes, String? cta, String? language
});




}
/// @nodoc
class __$ScriptDataCopyWithImpl<$Res>
    implements _$ScriptDataCopyWith<$Res> {
  __$ScriptDataCopyWithImpl(this._self, this._then);

  final _ScriptData _self;
  final $Res Function(_ScriptData) _then;

/// Create a copy of ScriptData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? hook = freezed,Object? headline = freezed,Object? scenes = null,Object? cta = freezed,Object? language = freezed,}) {
  return _then(_ScriptData(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,hook: freezed == hook ? _self.hook : hook // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,scenes: null == scenes ? _self._scenes : scenes // ignore: cast_nullable_to_non_nullable
as List<GeneratedScene>,cta: freezed == cta ? _self.cta : cta // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GeneratedScene {

 int get index; String get type; String? get visualPrompt; String? get narration; String? get textOverlay; int get durationMs;
/// Create a copy of GeneratedScene
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratedSceneCopyWith<GeneratedScene> get copyWith => _$GeneratedSceneCopyWithImpl<GeneratedScene>(this as GeneratedScene, _$identity);

  /// Serializes this GeneratedScene to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratedScene&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.visualPrompt, visualPrompt) || other.visualPrompt == visualPrompt)&&(identical(other.narration, narration) || other.narration == narration)&&(identical(other.textOverlay, textOverlay) || other.textOverlay == textOverlay)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,type,visualPrompt,narration,textOverlay,durationMs);

@override
String toString() {
  return 'GeneratedScene(index: $index, type: $type, visualPrompt: $visualPrompt, narration: $narration, textOverlay: $textOverlay, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class $GeneratedSceneCopyWith<$Res>  {
  factory $GeneratedSceneCopyWith(GeneratedScene value, $Res Function(GeneratedScene) _then) = _$GeneratedSceneCopyWithImpl;
@useResult
$Res call({
 int index, String type, String? visualPrompt, String? narration, String? textOverlay, int durationMs
});




}
/// @nodoc
class _$GeneratedSceneCopyWithImpl<$Res>
    implements $GeneratedSceneCopyWith<$Res> {
  _$GeneratedSceneCopyWithImpl(this._self, this._then);

  final GeneratedScene _self;
  final $Res Function(GeneratedScene) _then;

/// Create a copy of GeneratedScene
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? type = null,Object? visualPrompt = freezed,Object? narration = freezed,Object? textOverlay = freezed,Object? durationMs = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,visualPrompt: freezed == visualPrompt ? _self.visualPrompt : visualPrompt // ignore: cast_nullable_to_non_nullable
as String?,narration: freezed == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String?,textOverlay: freezed == textOverlay ? _self.textOverlay : textOverlay // ignore: cast_nullable_to_non_nullable
as String?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneratedScene].
extension GeneratedScenePatterns on GeneratedScene {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneratedScene value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneratedScene() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneratedScene value)  $default,){
final _that = this;
switch (_that) {
case _GeneratedScene():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneratedScene value)?  $default,){
final _that = this;
switch (_that) {
case _GeneratedScene() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String type,  String? visualPrompt,  String? narration,  String? textOverlay,  int durationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneratedScene() when $default != null:
return $default(_that.index,_that.type,_that.visualPrompt,_that.narration,_that.textOverlay,_that.durationMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String type,  String? visualPrompt,  String? narration,  String? textOverlay,  int durationMs)  $default,) {final _that = this;
switch (_that) {
case _GeneratedScene():
return $default(_that.index,_that.type,_that.visualPrompt,_that.narration,_that.textOverlay,_that.durationMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String type,  String? visualPrompt,  String? narration,  String? textOverlay,  int durationMs)?  $default,) {final _that = this;
switch (_that) {
case _GeneratedScene() when $default != null:
return $default(_that.index,_that.type,_that.visualPrompt,_that.narration,_that.textOverlay,_that.durationMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneratedScene extends GeneratedScene {
  const _GeneratedScene({required this.index, required this.type, this.visualPrompt, this.narration, this.textOverlay, this.durationMs = 5000}): super._();
  factory _GeneratedScene.fromJson(Map<String, dynamic> json) => _$GeneratedSceneFromJson(json);

@override final  int index;
@override final  String type;
@override final  String? visualPrompt;
@override final  String? narration;
@override final  String? textOverlay;
@override@JsonKey() final  int durationMs;

/// Create a copy of GeneratedScene
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneratedSceneCopyWith<_GeneratedScene> get copyWith => __$GeneratedSceneCopyWithImpl<_GeneratedScene>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratedSceneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneratedScene&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.visualPrompt, visualPrompt) || other.visualPrompt == visualPrompt)&&(identical(other.narration, narration) || other.narration == narration)&&(identical(other.textOverlay, textOverlay) || other.textOverlay == textOverlay)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,type,visualPrompt,narration,textOverlay,durationMs);

@override
String toString() {
  return 'GeneratedScene(index: $index, type: $type, visualPrompt: $visualPrompt, narration: $narration, textOverlay: $textOverlay, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class _$GeneratedSceneCopyWith<$Res> implements $GeneratedSceneCopyWith<$Res> {
  factory _$GeneratedSceneCopyWith(_GeneratedScene value, $Res Function(_GeneratedScene) _then) = __$GeneratedSceneCopyWithImpl;
@override @useResult
$Res call({
 int index, String type, String? visualPrompt, String? narration, String? textOverlay, int durationMs
});




}
/// @nodoc
class __$GeneratedSceneCopyWithImpl<$Res>
    implements _$GeneratedSceneCopyWith<$Res> {
  __$GeneratedSceneCopyWithImpl(this._self, this._then);

  final _GeneratedScene _self;
  final $Res Function(_GeneratedScene) _then;

/// Create a copy of GeneratedScene
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? type = null,Object? visualPrompt = freezed,Object? narration = freezed,Object? textOverlay = freezed,Object? durationMs = null,}) {
  return _then(_GeneratedScene(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,visualPrompt: freezed == visualPrompt ? _self.visualPrompt : visualPrompt // ignore: cast_nullable_to_non_nullable
as String?,narration: freezed == narration ? _self.narration : narration // ignore: cast_nullable_to_non_nullable
as String?,textOverlay: freezed == textOverlay ? _self.textOverlay : textOverlay // ignore: cast_nullable_to_non_nullable
as String?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectSettings {

 AspectRatio get aspectRatio; int get duration; String get language; String? get voiceId; String? get musicId; String? get logoUrl; String get brandColor;
/// Create a copy of ProjectSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSettingsCopyWith<ProjectSettings> get copyWith => _$ProjectSettingsCopyWithImpl<ProjectSettings>(this as ProjectSettings, _$identity);

  /// Serializes this ProjectSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSettings&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.language, language) || other.language == language)&&(identical(other.voiceId, voiceId) || other.voiceId == voiceId)&&(identical(other.musicId, musicId) || other.musicId == musicId)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aspectRatio,duration,language,voiceId,musicId,logoUrl,brandColor);

@override
String toString() {
  return 'ProjectSettings(aspectRatio: $aspectRatio, duration: $duration, language: $language, voiceId: $voiceId, musicId: $musicId, logoUrl: $logoUrl, brandColor: $brandColor)';
}


}

/// @nodoc
abstract mixin class $ProjectSettingsCopyWith<$Res>  {
  factory $ProjectSettingsCopyWith(ProjectSettings value, $Res Function(ProjectSettings) _then) = _$ProjectSettingsCopyWithImpl;
@useResult
$Res call({
 AspectRatio aspectRatio, int duration, String language, String? voiceId, String? musicId, String? logoUrl, String brandColor
});




}
/// @nodoc
class _$ProjectSettingsCopyWithImpl<$Res>
    implements $ProjectSettingsCopyWith<$Res> {
  _$ProjectSettingsCopyWithImpl(this._self, this._then);

  final ProjectSettings _self;
  final $Res Function(ProjectSettings) _then;

/// Create a copy of ProjectSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aspectRatio = null,Object? duration = null,Object? language = null,Object? voiceId = freezed,Object? musicId = freezed,Object? logoUrl = freezed,Object? brandColor = null,}) {
  return _then(_self.copyWith(
aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as AspectRatio,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,voiceId: freezed == voiceId ? _self.voiceId : voiceId // ignore: cast_nullable_to_non_nullable
as String?,musicId: freezed == musicId ? _self.musicId : musicId // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,brandColor: null == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSettings].
extension ProjectSettingsPatterns on ProjectSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSettings value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AspectRatio aspectRatio,  int duration,  String language,  String? voiceId,  String? musicId,  String? logoUrl,  String brandColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSettings() when $default != null:
return $default(_that.aspectRatio,_that.duration,_that.language,_that.voiceId,_that.musicId,_that.logoUrl,_that.brandColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AspectRatio aspectRatio,  int duration,  String language,  String? voiceId,  String? musicId,  String? logoUrl,  String brandColor)  $default,) {final _that = this;
switch (_that) {
case _ProjectSettings():
return $default(_that.aspectRatio,_that.duration,_that.language,_that.voiceId,_that.musicId,_that.logoUrl,_that.brandColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AspectRatio aspectRatio,  int duration,  String language,  String? voiceId,  String? musicId,  String? logoUrl,  String brandColor)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSettings() when $default != null:
return $default(_that.aspectRatio,_that.duration,_that.language,_that.voiceId,_that.musicId,_that.logoUrl,_that.brandColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSettings implements ProjectSettings {
  const _ProjectSettings({this.aspectRatio = AspectRatio.portrait, this.duration = 30, this.language = 'ar', this.voiceId, this.musicId, this.logoUrl, this.brandColor = '#000000'});
  factory _ProjectSettings.fromJson(Map<String, dynamic> json) => _$ProjectSettingsFromJson(json);

@override@JsonKey() final  AspectRatio aspectRatio;
@override@JsonKey() final  int duration;
@override@JsonKey() final  String language;
@override final  String? voiceId;
@override final  String? musicId;
@override final  String? logoUrl;
@override@JsonKey() final  String brandColor;

/// Create a copy of ProjectSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSettingsCopyWith<_ProjectSettings> get copyWith => __$ProjectSettingsCopyWithImpl<_ProjectSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSettings&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.language, language) || other.language == language)&&(identical(other.voiceId, voiceId) || other.voiceId == voiceId)&&(identical(other.musicId, musicId) || other.musicId == musicId)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.brandColor, brandColor) || other.brandColor == brandColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aspectRatio,duration,language,voiceId,musicId,logoUrl,brandColor);

@override
String toString() {
  return 'ProjectSettings(aspectRatio: $aspectRatio, duration: $duration, language: $language, voiceId: $voiceId, musicId: $musicId, logoUrl: $logoUrl, brandColor: $brandColor)';
}


}

/// @nodoc
abstract mixin class _$ProjectSettingsCopyWith<$Res> implements $ProjectSettingsCopyWith<$Res> {
  factory _$ProjectSettingsCopyWith(_ProjectSettings value, $Res Function(_ProjectSettings) _then) = __$ProjectSettingsCopyWithImpl;
@override @useResult
$Res call({
 AspectRatio aspectRatio, int duration, String language, String? voiceId, String? musicId, String? logoUrl, String brandColor
});




}
/// @nodoc
class __$ProjectSettingsCopyWithImpl<$Res>
    implements _$ProjectSettingsCopyWith<$Res> {
  __$ProjectSettingsCopyWithImpl(this._self, this._then);

  final _ProjectSettings _self;
  final $Res Function(_ProjectSettings) _then;

/// Create a copy of ProjectSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aspectRatio = null,Object? duration = null,Object? language = null,Object? voiceId = freezed,Object? musicId = freezed,Object? logoUrl = freezed,Object? brandColor = null,}) {
  return _then(_ProjectSettings(
aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as AspectRatio,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,voiceId: freezed == voiceId ? _self.voiceId : voiceId // ignore: cast_nullable_to_non_nullable
as String?,musicId: freezed == musicId ? _self.musicId : musicId // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,brandColor: null == brandColor ? _self.brandColor : brandColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StudioProject {

 String get id; String get userId; String? get storeId; String? get templateId; String? get productId; String get name; String? get description; ProjectStatus get status; ProductData get productData; ScriptData get scriptData; ProjectSettings get settings; String? get outputUrl; String? get outputThumbnailUrl; int? get outputDuration; int? get outputSizeBytes; int get creditsUsed; String? get errorMessage; int get progress;// حقول إضافية للتوافق
 String? get thumbnailUrl; int get scenesCount; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudioProjectCopyWith<StudioProject> get copyWith => _$StudioProjectCopyWithImpl<StudioProject>(this as StudioProject, _$identity);

  /// Serializes this StudioProject to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudioProject&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.productData, productData) || other.productData == productData)&&(identical(other.scriptData, scriptData) || other.scriptData == scriptData)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.outputUrl, outputUrl) || other.outputUrl == outputUrl)&&(identical(other.outputThumbnailUrl, outputThumbnailUrl) || other.outputThumbnailUrl == outputThumbnailUrl)&&(identical(other.outputDuration, outputDuration) || other.outputDuration == outputDuration)&&(identical(other.outputSizeBytes, outputSizeBytes) || other.outputSizeBytes == outputSizeBytes)&&(identical(other.creditsUsed, creditsUsed) || other.creditsUsed == creditsUsed)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.scenesCount, scenesCount) || other.scenesCount == scenesCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,storeId,templateId,productId,name,description,status,productData,scriptData,settings,outputUrl,outputThumbnailUrl,outputDuration,outputSizeBytes,creditsUsed,errorMessage,progress,thumbnailUrl,scenesCount,createdAt,updatedAt]);

@override
String toString() {
  return 'StudioProject(id: $id, userId: $userId, storeId: $storeId, templateId: $templateId, productId: $productId, name: $name, description: $description, status: $status, productData: $productData, scriptData: $scriptData, settings: $settings, outputUrl: $outputUrl, outputThumbnailUrl: $outputThumbnailUrl, outputDuration: $outputDuration, outputSizeBytes: $outputSizeBytes, creditsUsed: $creditsUsed, errorMessage: $errorMessage, progress: $progress, thumbnailUrl: $thumbnailUrl, scenesCount: $scenesCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudioProjectCopyWith<$Res>  {
  factory $StudioProjectCopyWith(StudioProject value, $Res Function(StudioProject) _then) = _$StudioProjectCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? storeId, String? templateId, String? productId, String name, String? description, ProjectStatus status, ProductData productData, ScriptData scriptData, ProjectSettings settings, String? outputUrl, String? outputThumbnailUrl, int? outputDuration, int? outputSizeBytes, int creditsUsed, String? errorMessage, int progress, String? thumbnailUrl, int scenesCount, DateTime createdAt, DateTime updatedAt
});


$ProductDataCopyWith<$Res> get productData;$ScriptDataCopyWith<$Res> get scriptData;$ProjectSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$StudioProjectCopyWithImpl<$Res>
    implements $StudioProjectCopyWith<$Res> {
  _$StudioProjectCopyWithImpl(this._self, this._then);

  final StudioProject _self;
  final $Res Function(StudioProject) _then;

/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? storeId = freezed,Object? templateId = freezed,Object? productId = freezed,Object? name = null,Object? description = freezed,Object? status = null,Object? productData = null,Object? scriptData = null,Object? settings = null,Object? outputUrl = freezed,Object? outputThumbnailUrl = freezed,Object? outputDuration = freezed,Object? outputSizeBytes = freezed,Object? creditsUsed = null,Object? errorMessage = freezed,Object? progress = null,Object? thumbnailUrl = freezed,Object? scenesCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,productData: null == productData ? _self.productData : productData // ignore: cast_nullable_to_non_nullable
as ProductData,scriptData: null == scriptData ? _self.scriptData : scriptData // ignore: cast_nullable_to_non_nullable
as ScriptData,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ProjectSettings,outputUrl: freezed == outputUrl ? _self.outputUrl : outputUrl // ignore: cast_nullable_to_non_nullable
as String?,outputThumbnailUrl: freezed == outputThumbnailUrl ? _self.outputThumbnailUrl : outputThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,outputDuration: freezed == outputDuration ? _self.outputDuration : outputDuration // ignore: cast_nullable_to_non_nullable
as int?,outputSizeBytes: freezed == outputSizeBytes ? _self.outputSizeBytes : outputSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,creditsUsed: null == creditsUsed ? _self.creditsUsed : creditsUsed // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,scenesCount: null == scenesCount ? _self.scenesCount : scenesCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDataCopyWith<$Res> get productData {
  
  return $ProductDataCopyWith<$Res>(_self.productData, (value) {
    return _then(_self.copyWith(productData: value));
  });
}/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScriptDataCopyWith<$Res> get scriptData {
  
  return $ScriptDataCopyWith<$Res>(_self.scriptData, (value) {
    return _then(_self.copyWith(scriptData: value));
  });
}/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSettingsCopyWith<$Res> get settings {
  
  return $ProjectSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [StudioProject].
extension StudioProjectPatterns on StudioProject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudioProject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudioProject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudioProject value)  $default,){
final _that = this;
switch (_that) {
case _StudioProject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudioProject value)?  $default,){
final _that = this;
switch (_that) {
case _StudioProject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? storeId,  String? templateId,  String? productId,  String name,  String? description,  ProjectStatus status,  ProductData productData,  ScriptData scriptData,  ProjectSettings settings,  String? outputUrl,  String? outputThumbnailUrl,  int? outputDuration,  int? outputSizeBytes,  int creditsUsed,  String? errorMessage,  int progress,  String? thumbnailUrl,  int scenesCount,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudioProject() when $default != null:
return $default(_that.id,_that.userId,_that.storeId,_that.templateId,_that.productId,_that.name,_that.description,_that.status,_that.productData,_that.scriptData,_that.settings,_that.outputUrl,_that.outputThumbnailUrl,_that.outputDuration,_that.outputSizeBytes,_that.creditsUsed,_that.errorMessage,_that.progress,_that.thumbnailUrl,_that.scenesCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? storeId,  String? templateId,  String? productId,  String name,  String? description,  ProjectStatus status,  ProductData productData,  ScriptData scriptData,  ProjectSettings settings,  String? outputUrl,  String? outputThumbnailUrl,  int? outputDuration,  int? outputSizeBytes,  int creditsUsed,  String? errorMessage,  int progress,  String? thumbnailUrl,  int scenesCount,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StudioProject():
return $default(_that.id,_that.userId,_that.storeId,_that.templateId,_that.productId,_that.name,_that.description,_that.status,_that.productData,_that.scriptData,_that.settings,_that.outputUrl,_that.outputThumbnailUrl,_that.outputDuration,_that.outputSizeBytes,_that.creditsUsed,_that.errorMessage,_that.progress,_that.thumbnailUrl,_that.scenesCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? storeId,  String? templateId,  String? productId,  String name,  String? description,  ProjectStatus status,  ProductData productData,  ScriptData scriptData,  ProjectSettings settings,  String? outputUrl,  String? outputThumbnailUrl,  int? outputDuration,  int? outputSizeBytes,  int creditsUsed,  String? errorMessage,  int progress,  String? thumbnailUrl,  int scenesCount,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudioProject() when $default != null:
return $default(_that.id,_that.userId,_that.storeId,_that.templateId,_that.productId,_that.name,_that.description,_that.status,_that.productData,_that.scriptData,_that.settings,_that.outputUrl,_that.outputThumbnailUrl,_that.outputDuration,_that.outputSizeBytes,_that.creditsUsed,_that.errorMessage,_that.progress,_that.thumbnailUrl,_that.scenesCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudioProject implements StudioProject {
  const _StudioProject({required this.id, required this.userId, this.storeId, this.templateId, this.productId, required this.name, this.description, this.status = ProjectStatus.draft, this.productData = const ProductData(), this.scriptData = const ScriptData(), this.settings = const ProjectSettings(), this.outputUrl, this.outputThumbnailUrl, this.outputDuration, this.outputSizeBytes, this.creditsUsed = 0, this.errorMessage, this.progress = 0, this.thumbnailUrl, this.scenesCount = 0, required this.createdAt, required this.updatedAt});
  factory _StudioProject.fromJson(Map<String, dynamic> json) => _$StudioProjectFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? storeId;
@override final  String? templateId;
@override final  String? productId;
@override final  String name;
@override final  String? description;
@override@JsonKey() final  ProjectStatus status;
@override@JsonKey() final  ProductData productData;
@override@JsonKey() final  ScriptData scriptData;
@override@JsonKey() final  ProjectSettings settings;
@override final  String? outputUrl;
@override final  String? outputThumbnailUrl;
@override final  int? outputDuration;
@override final  int? outputSizeBytes;
@override@JsonKey() final  int creditsUsed;
@override final  String? errorMessage;
@override@JsonKey() final  int progress;
// حقول إضافية للتوافق
@override final  String? thumbnailUrl;
@override@JsonKey() final  int scenesCount;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudioProjectCopyWith<_StudioProject> get copyWith => __$StudioProjectCopyWithImpl<_StudioProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudioProjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudioProject&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.productData, productData) || other.productData == productData)&&(identical(other.scriptData, scriptData) || other.scriptData == scriptData)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.outputUrl, outputUrl) || other.outputUrl == outputUrl)&&(identical(other.outputThumbnailUrl, outputThumbnailUrl) || other.outputThumbnailUrl == outputThumbnailUrl)&&(identical(other.outputDuration, outputDuration) || other.outputDuration == outputDuration)&&(identical(other.outputSizeBytes, outputSizeBytes) || other.outputSizeBytes == outputSizeBytes)&&(identical(other.creditsUsed, creditsUsed) || other.creditsUsed == creditsUsed)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.scenesCount, scenesCount) || other.scenesCount == scenesCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,storeId,templateId,productId,name,description,status,productData,scriptData,settings,outputUrl,outputThumbnailUrl,outputDuration,outputSizeBytes,creditsUsed,errorMessage,progress,thumbnailUrl,scenesCount,createdAt,updatedAt]);

@override
String toString() {
  return 'StudioProject(id: $id, userId: $userId, storeId: $storeId, templateId: $templateId, productId: $productId, name: $name, description: $description, status: $status, productData: $productData, scriptData: $scriptData, settings: $settings, outputUrl: $outputUrl, outputThumbnailUrl: $outputThumbnailUrl, outputDuration: $outputDuration, outputSizeBytes: $outputSizeBytes, creditsUsed: $creditsUsed, errorMessage: $errorMessage, progress: $progress, thumbnailUrl: $thumbnailUrl, scenesCount: $scenesCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudioProjectCopyWith<$Res> implements $StudioProjectCopyWith<$Res> {
  factory _$StudioProjectCopyWith(_StudioProject value, $Res Function(_StudioProject) _then) = __$StudioProjectCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? storeId, String? templateId, String? productId, String name, String? description, ProjectStatus status, ProductData productData, ScriptData scriptData, ProjectSettings settings, String? outputUrl, String? outputThumbnailUrl, int? outputDuration, int? outputSizeBytes, int creditsUsed, String? errorMessage, int progress, String? thumbnailUrl, int scenesCount, DateTime createdAt, DateTime updatedAt
});


@override $ProductDataCopyWith<$Res> get productData;@override $ScriptDataCopyWith<$Res> get scriptData;@override $ProjectSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$StudioProjectCopyWithImpl<$Res>
    implements _$StudioProjectCopyWith<$Res> {
  __$StudioProjectCopyWithImpl(this._self, this._then);

  final _StudioProject _self;
  final $Res Function(_StudioProject) _then;

/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? storeId = freezed,Object? templateId = freezed,Object? productId = freezed,Object? name = null,Object? description = freezed,Object? status = null,Object? productData = null,Object? scriptData = null,Object? settings = null,Object? outputUrl = freezed,Object? outputThumbnailUrl = freezed,Object? outputDuration = freezed,Object? outputSizeBytes = freezed,Object? creditsUsed = null,Object? errorMessage = freezed,Object? progress = null,Object? thumbnailUrl = freezed,Object? scenesCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudioProject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,productData: null == productData ? _self.productData : productData // ignore: cast_nullable_to_non_nullable
as ProductData,scriptData: null == scriptData ? _self.scriptData : scriptData // ignore: cast_nullable_to_non_nullable
as ScriptData,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ProjectSettings,outputUrl: freezed == outputUrl ? _self.outputUrl : outputUrl // ignore: cast_nullable_to_non_nullable
as String?,outputThumbnailUrl: freezed == outputThumbnailUrl ? _self.outputThumbnailUrl : outputThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,outputDuration: freezed == outputDuration ? _self.outputDuration : outputDuration // ignore: cast_nullable_to_non_nullable
as int?,outputSizeBytes: freezed == outputSizeBytes ? _self.outputSizeBytes : outputSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,creditsUsed: null == creditsUsed ? _self.creditsUsed : creditsUsed // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,scenesCount: null == scenesCount ? _self.scenesCount : scenesCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductDataCopyWith<$Res> get productData {
  
  return $ProductDataCopyWith<$Res>(_self.productData, (value) {
    return _then(_self.copyWith(productData: value));
  });
}/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScriptDataCopyWith<$Res> get scriptData {
  
  return $ScriptDataCopyWith<$Res>(_self.scriptData, (value) {
    return _then(_self.copyWith(scriptData: value));
  });
}/// Create a copy of StudioProject
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSettingsCopyWith<$Res> get settings {
  
  return $ProjectSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
