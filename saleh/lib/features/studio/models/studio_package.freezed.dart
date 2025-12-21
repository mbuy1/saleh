// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'studio_package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageDefinition {

 PackageType get id; String get name; String get nameAr; String get description; String get descriptionAr; String get icon; int get creditsCost; int get estimatedTimeMinutes; List<PackageDeliverable> get deliverables; List<String> get features; List<String> get featuresAr; bool get isPremium; bool get isPopular;
/// Create a copy of PackageDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageDefinitionCopyWith<PackageDefinition> get copyWith => _$PackageDefinitionCopyWithImpl<PackageDefinition>(this as PackageDefinition, _$identity);

  /// Serializes this PackageDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.estimatedTimeMinutes, estimatedTimeMinutes) || other.estimatedTimeMinutes == estimatedTimeMinutes)&&const DeepCollectionEquality().equals(other.deliverables, deliverables)&&const DeepCollectionEquality().equals(other.features, features)&&const DeepCollectionEquality().equals(other.featuresAr, featuresAr)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameAr,description,descriptionAr,icon,creditsCost,estimatedTimeMinutes,const DeepCollectionEquality().hash(deliverables),const DeepCollectionEquality().hash(features),const DeepCollectionEquality().hash(featuresAr),isPremium,isPopular);

@override
String toString() {
  return 'PackageDefinition(id: $id, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, icon: $icon, creditsCost: $creditsCost, estimatedTimeMinutes: $estimatedTimeMinutes, deliverables: $deliverables, features: $features, featuresAr: $featuresAr, isPremium: $isPremium, isPopular: $isPopular)';
}


}

/// @nodoc
abstract mixin class $PackageDefinitionCopyWith<$Res>  {
  factory $PackageDefinitionCopyWith(PackageDefinition value, $Res Function(PackageDefinition) _then) = _$PackageDefinitionCopyWithImpl;
@useResult
$Res call({
 PackageType id, String name, String nameAr, String description, String descriptionAr, String icon, int creditsCost, int estimatedTimeMinutes, List<PackageDeliverable> deliverables, List<String> features, List<String> featuresAr, bool isPremium, bool isPopular
});




}
/// @nodoc
class _$PackageDefinitionCopyWithImpl<$Res>
    implements $PackageDefinitionCopyWith<$Res> {
  _$PackageDefinitionCopyWithImpl(this._self, this._then);

  final PackageDefinition _self;
  final $Res Function(PackageDefinition) _then;

/// Create a copy of PackageDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameAr = null,Object? description = null,Object? descriptionAr = null,Object? icon = null,Object? creditsCost = null,Object? estimatedTimeMinutes = null,Object? deliverables = null,Object? features = null,Object? featuresAr = null,Object? isPremium = null,Object? isPopular = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PackageType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: null == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,estimatedTimeMinutes: null == estimatedTimeMinutes ? _self.estimatedTimeMinutes : estimatedTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,deliverables: null == deliverables ? _self.deliverables : deliverables // ignore: cast_nullable_to_non_nullable
as List<PackageDeliverable>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,featuresAr: null == featuresAr ? _self.featuresAr : featuresAr // ignore: cast_nullable_to_non_nullable
as List<String>,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PackageDefinition].
extension PackageDefinitionPatterns on PackageDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageDefinition value)  $default,){
final _that = this;
switch (_that) {
case _PackageDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _PackageDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PackageType id,  String name,  String nameAr,  String description,  String descriptionAr,  String icon,  int creditsCost,  int estimatedTimeMinutes,  List<PackageDeliverable> deliverables,  List<String> features,  List<String> featuresAr,  bool isPremium,  bool isPopular)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageDefinition() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.creditsCost,_that.estimatedTimeMinutes,_that.deliverables,_that.features,_that.featuresAr,_that.isPremium,_that.isPopular);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PackageType id,  String name,  String nameAr,  String description,  String descriptionAr,  String icon,  int creditsCost,  int estimatedTimeMinutes,  List<PackageDeliverable> deliverables,  List<String> features,  List<String> featuresAr,  bool isPremium,  bool isPopular)  $default,) {final _that = this;
switch (_that) {
case _PackageDefinition():
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.creditsCost,_that.estimatedTimeMinutes,_that.deliverables,_that.features,_that.featuresAr,_that.isPremium,_that.isPopular);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PackageType id,  String name,  String nameAr,  String description,  String descriptionAr,  String icon,  int creditsCost,  int estimatedTimeMinutes,  List<PackageDeliverable> deliverables,  List<String> features,  List<String> featuresAr,  bool isPremium,  bool isPopular)?  $default,) {final _that = this;
switch (_that) {
case _PackageDefinition() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.icon,_that.creditsCost,_that.estimatedTimeMinutes,_that.deliverables,_that.features,_that.featuresAr,_that.isPremium,_that.isPopular);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageDefinition implements PackageDefinition {
  const _PackageDefinition({required this.id, required this.name, required this.nameAr, required this.description, required this.descriptionAr, required this.icon, required this.creditsCost, required this.estimatedTimeMinutes, required final  List<PackageDeliverable> deliverables, required final  List<String> features, required final  List<String> featuresAr, this.isPremium = false, this.isPopular = false}): _deliverables = deliverables,_features = features,_featuresAr = featuresAr;
  factory _PackageDefinition.fromJson(Map<String, dynamic> json) => _$PackageDefinitionFromJson(json);

@override final  PackageType id;
@override final  String name;
@override final  String nameAr;
@override final  String description;
@override final  String descriptionAr;
@override final  String icon;
@override final  int creditsCost;
@override final  int estimatedTimeMinutes;
 final  List<PackageDeliverable> _deliverables;
@override List<PackageDeliverable> get deliverables {
  if (_deliverables is EqualUnmodifiableListView) return _deliverables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deliverables);
}

 final  List<String> _features;
@override List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

 final  List<String> _featuresAr;
@override List<String> get featuresAr {
  if (_featuresAr is EqualUnmodifiableListView) return _featuresAr;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featuresAr);
}

@override@JsonKey() final  bool isPremium;
@override@JsonKey() final  bool isPopular;

/// Create a copy of PackageDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageDefinitionCopyWith<_PackageDefinition> get copyWith => __$PackageDefinitionCopyWithImpl<_PackageDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.estimatedTimeMinutes, estimatedTimeMinutes) || other.estimatedTimeMinutes == estimatedTimeMinutes)&&const DeepCollectionEquality().equals(other._deliverables, _deliverables)&&const DeepCollectionEquality().equals(other._features, _features)&&const DeepCollectionEquality().equals(other._featuresAr, _featuresAr)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameAr,description,descriptionAr,icon,creditsCost,estimatedTimeMinutes,const DeepCollectionEquality().hash(_deliverables),const DeepCollectionEquality().hash(_features),const DeepCollectionEquality().hash(_featuresAr),isPremium,isPopular);

@override
String toString() {
  return 'PackageDefinition(id: $id, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, icon: $icon, creditsCost: $creditsCost, estimatedTimeMinutes: $estimatedTimeMinutes, deliverables: $deliverables, features: $features, featuresAr: $featuresAr, isPremium: $isPremium, isPopular: $isPopular)';
}


}

/// @nodoc
abstract mixin class _$PackageDefinitionCopyWith<$Res> implements $PackageDefinitionCopyWith<$Res> {
  factory _$PackageDefinitionCopyWith(_PackageDefinition value, $Res Function(_PackageDefinition) _then) = __$PackageDefinitionCopyWithImpl;
@override @useResult
$Res call({
 PackageType id, String name, String nameAr, String description, String descriptionAr, String icon, int creditsCost, int estimatedTimeMinutes, List<PackageDeliverable> deliverables, List<String> features, List<String> featuresAr, bool isPremium, bool isPopular
});




}
/// @nodoc
class __$PackageDefinitionCopyWithImpl<$Res>
    implements _$PackageDefinitionCopyWith<$Res> {
  __$PackageDefinitionCopyWithImpl(this._self, this._then);

  final _PackageDefinition _self;
  final $Res Function(_PackageDefinition) _then;

/// Create a copy of PackageDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameAr = null,Object? description = null,Object? descriptionAr = null,Object? icon = null,Object? creditsCost = null,Object? estimatedTimeMinutes = null,Object? deliverables = null,Object? features = null,Object? featuresAr = null,Object? isPremium = null,Object? isPopular = null,}) {
  return _then(_PackageDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PackageType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: null == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,estimatedTimeMinutes: null == estimatedTimeMinutes ? _self.estimatedTimeMinutes : estimatedTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,deliverables: null == deliverables ? _self._deliverables : deliverables // ignore: cast_nullable_to_non_nullable
as List<PackageDeliverable>,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,featuresAr: null == featuresAr ? _self._featuresAr : featuresAr // ignore: cast_nullable_to_non_nullable
as List<String>,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PackageDeliverable {

 String get type; String get format; int get quantity; String get description; String get descriptionAr;
/// Create a copy of PackageDeliverable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageDeliverableCopyWith<PackageDeliverable> get copyWith => _$PackageDeliverableCopyWithImpl<PackageDeliverable>(this as PackageDeliverable, _$identity);

  /// Serializes this PackageDeliverable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageDeliverable&&(identical(other.type, type) || other.type == type)&&(identical(other.format, format) || other.format == format)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,format,quantity,description,descriptionAr);

@override
String toString() {
  return 'PackageDeliverable(type: $type, format: $format, quantity: $quantity, description: $description, descriptionAr: $descriptionAr)';
}


}

/// @nodoc
abstract mixin class $PackageDeliverableCopyWith<$Res>  {
  factory $PackageDeliverableCopyWith(PackageDeliverable value, $Res Function(PackageDeliverable) _then) = _$PackageDeliverableCopyWithImpl;
@useResult
$Res call({
 String type, String format, int quantity, String description, String descriptionAr
});




}
/// @nodoc
class _$PackageDeliverableCopyWithImpl<$Res>
    implements $PackageDeliverableCopyWith<$Res> {
  _$PackageDeliverableCopyWithImpl(this._self, this._then);

  final PackageDeliverable _self;
  final $Res Function(PackageDeliverable) _then;

/// Create a copy of PackageDeliverable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? format = null,Object? quantity = null,Object? description = null,Object? descriptionAr = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: null == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PackageDeliverable].
extension PackageDeliverablePatterns on PackageDeliverable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageDeliverable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageDeliverable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageDeliverable value)  $default,){
final _that = this;
switch (_that) {
case _PackageDeliverable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageDeliverable value)?  $default,){
final _that = this;
switch (_that) {
case _PackageDeliverable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String format,  int quantity,  String description,  String descriptionAr)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageDeliverable() when $default != null:
return $default(_that.type,_that.format,_that.quantity,_that.description,_that.descriptionAr);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String format,  int quantity,  String description,  String descriptionAr)  $default,) {final _that = this;
switch (_that) {
case _PackageDeliverable():
return $default(_that.type,_that.format,_that.quantity,_that.description,_that.descriptionAr);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String format,  int quantity,  String description,  String descriptionAr)?  $default,) {final _that = this;
switch (_that) {
case _PackageDeliverable() when $default != null:
return $default(_that.type,_that.format,_that.quantity,_that.description,_that.descriptionAr);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageDeliverable implements PackageDeliverable {
  const _PackageDeliverable({required this.type, required this.format, required this.quantity, required this.description, required this.descriptionAr});
  factory _PackageDeliverable.fromJson(Map<String, dynamic> json) => _$PackageDeliverableFromJson(json);

@override final  String type;
@override final  String format;
@override final  int quantity;
@override final  String description;
@override final  String descriptionAr;

/// Create a copy of PackageDeliverable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageDeliverableCopyWith<_PackageDeliverable> get copyWith => __$PackageDeliverableCopyWithImpl<_PackageDeliverable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageDeliverableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageDeliverable&&(identical(other.type, type) || other.type == type)&&(identical(other.format, format) || other.format == format)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,format,quantity,description,descriptionAr);

@override
String toString() {
  return 'PackageDeliverable(type: $type, format: $format, quantity: $quantity, description: $description, descriptionAr: $descriptionAr)';
}


}

/// @nodoc
abstract mixin class _$PackageDeliverableCopyWith<$Res> implements $PackageDeliverableCopyWith<$Res> {
  factory _$PackageDeliverableCopyWith(_PackageDeliverable value, $Res Function(_PackageDeliverable) _then) = __$PackageDeliverableCopyWithImpl;
@override @useResult
$Res call({
 String type, String format, int quantity, String description, String descriptionAr
});




}
/// @nodoc
class __$PackageDeliverableCopyWithImpl<$Res>
    implements _$PackageDeliverableCopyWith<$Res> {
  __$PackageDeliverableCopyWithImpl(this._self, this._then);

  final _PackageDeliverable _self;
  final $Res Function(_PackageDeliverable) _then;

/// Create a copy of PackageDeliverable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? format = null,Object? quantity = null,Object? description = null,Object? descriptionAr = null,}) {
  return _then(_PackageDeliverable(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionAr: null == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PackageOrder {

 String get id; String get userId; String get storeId; PackageType get packageType; PackageStatus get status; String? get productId; Map<String, dynamic> get productData; Map<String, dynamic>? get brandData; Map<String, dynamic> get preferences; List<PackageDeliverableResult> get deliverables; int get progress; String? get currentStep; String? get errorMessage; int get creditsCost; int? get creditsRefunded; DateTime? get startedAt; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of PackageOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageOrderCopyWith<PackageOrder> get copyWith => _$PackageOrderCopyWithImpl<PackageOrder>(this as PackageOrder, _$identity);

  /// Serializes this PackageOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.packageType, packageType) || other.packageType == packageType)&&(identical(other.status, status) || other.status == status)&&(identical(other.productId, productId) || other.productId == productId)&&const DeepCollectionEquality().equals(other.productData, productData)&&const DeepCollectionEquality().equals(other.brandData, brandData)&&const DeepCollectionEquality().equals(other.preferences, preferences)&&const DeepCollectionEquality().equals(other.deliverables, deliverables)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.creditsRefunded, creditsRefunded) || other.creditsRefunded == creditsRefunded)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,storeId,packageType,status,productId,const DeepCollectionEquality().hash(productData),const DeepCollectionEquality().hash(brandData),const DeepCollectionEquality().hash(preferences),const DeepCollectionEquality().hash(deliverables),progress,currentStep,errorMessage,creditsCost,creditsRefunded,startedAt,completedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'PackageOrder(id: $id, userId: $userId, storeId: $storeId, packageType: $packageType, status: $status, productId: $productId, productData: $productData, brandData: $brandData, preferences: $preferences, deliverables: $deliverables, progress: $progress, currentStep: $currentStep, errorMessage: $errorMessage, creditsCost: $creditsCost, creditsRefunded: $creditsRefunded, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PackageOrderCopyWith<$Res>  {
  factory $PackageOrderCopyWith(PackageOrder value, $Res Function(PackageOrder) _then) = _$PackageOrderCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String storeId, PackageType packageType, PackageStatus status, String? productId, Map<String, dynamic> productData, Map<String, dynamic>? brandData, Map<String, dynamic> preferences, List<PackageDeliverableResult> deliverables, int progress, String? currentStep, String? errorMessage, int creditsCost, int? creditsRefunded, DateTime? startedAt, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PackageOrderCopyWithImpl<$Res>
    implements $PackageOrderCopyWith<$Res> {
  _$PackageOrderCopyWithImpl(this._self, this._then);

  final PackageOrder _self;
  final $Res Function(PackageOrder) _then;

/// Create a copy of PackageOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? storeId = null,Object? packageType = null,Object? status = null,Object? productId = freezed,Object? productData = null,Object? brandData = freezed,Object? preferences = null,Object? deliverables = null,Object? progress = null,Object? currentStep = freezed,Object? errorMessage = freezed,Object? creditsCost = null,Object? creditsRefunded = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,packageType: null == packageType ? _self.packageType : packageType // ignore: cast_nullable_to_non_nullable
as PackageType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PackageStatus,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productData: null == productData ? _self.productData : productData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,brandData: freezed == brandData ? _self.brandData : brandData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,deliverables: null == deliverables ? _self.deliverables : deliverables // ignore: cast_nullable_to_non_nullable
as List<PackageDeliverableResult>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,creditsRefunded: freezed == creditsRefunded ? _self.creditsRefunded : creditsRefunded // ignore: cast_nullable_to_non_nullable
as int?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PackageOrder].
extension PackageOrderPatterns on PackageOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageOrder value)  $default,){
final _that = this;
switch (_that) {
case _PackageOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PackageOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String storeId,  PackageType packageType,  PackageStatus status,  String? productId,  Map<String, dynamic> productData,  Map<String, dynamic>? brandData,  Map<String, dynamic> preferences,  List<PackageDeliverableResult> deliverables,  int progress,  String? currentStep,  String? errorMessage,  int creditsCost,  int? creditsRefunded,  DateTime? startedAt,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageOrder() when $default != null:
return $default(_that.id,_that.userId,_that.storeId,_that.packageType,_that.status,_that.productId,_that.productData,_that.brandData,_that.preferences,_that.deliverables,_that.progress,_that.currentStep,_that.errorMessage,_that.creditsCost,_that.creditsRefunded,_that.startedAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String storeId,  PackageType packageType,  PackageStatus status,  String? productId,  Map<String, dynamic> productData,  Map<String, dynamic>? brandData,  Map<String, dynamic> preferences,  List<PackageDeliverableResult> deliverables,  int progress,  String? currentStep,  String? errorMessage,  int creditsCost,  int? creditsRefunded,  DateTime? startedAt,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PackageOrder():
return $default(_that.id,_that.userId,_that.storeId,_that.packageType,_that.status,_that.productId,_that.productData,_that.brandData,_that.preferences,_that.deliverables,_that.progress,_that.currentStep,_that.errorMessage,_that.creditsCost,_that.creditsRefunded,_that.startedAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String storeId,  PackageType packageType,  PackageStatus status,  String? productId,  Map<String, dynamic> productData,  Map<String, dynamic>? brandData,  Map<String, dynamic> preferences,  List<PackageDeliverableResult> deliverables,  int progress,  String? currentStep,  String? errorMessage,  int creditsCost,  int? creditsRefunded,  DateTime? startedAt,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PackageOrder() when $default != null:
return $default(_that.id,_that.userId,_that.storeId,_that.packageType,_that.status,_that.productId,_that.productData,_that.brandData,_that.preferences,_that.deliverables,_that.progress,_that.currentStep,_that.errorMessage,_that.creditsCost,_that.creditsRefunded,_that.startedAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageOrder implements PackageOrder {
  const _PackageOrder({required this.id, required this.userId, required this.storeId, required this.packageType, required this.status, this.productId, required final  Map<String, dynamic> productData, final  Map<String, dynamic>? brandData, required final  Map<String, dynamic> preferences, final  List<PackageDeliverableResult> deliverables = const [], this.progress = 0, this.currentStep, this.errorMessage, required this.creditsCost, this.creditsRefunded, this.startedAt, this.completedAt, required this.createdAt, required this.updatedAt}): _productData = productData,_brandData = brandData,_preferences = preferences,_deliverables = deliverables;
  factory _PackageOrder.fromJson(Map<String, dynamic> json) => _$PackageOrderFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String storeId;
@override final  PackageType packageType;
@override final  PackageStatus status;
@override final  String? productId;
 final  Map<String, dynamic> _productData;
@override Map<String, dynamic> get productData {
  if (_productData is EqualUnmodifiableMapView) return _productData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_productData);
}

 final  Map<String, dynamic>? _brandData;
@override Map<String, dynamic>? get brandData {
  final value = _brandData;
  if (value == null) return null;
  if (_brandData is EqualUnmodifiableMapView) return _brandData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic> _preferences;
@override Map<String, dynamic> get preferences {
  if (_preferences is EqualUnmodifiableMapView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_preferences);
}

 final  List<PackageDeliverableResult> _deliverables;
@override@JsonKey() List<PackageDeliverableResult> get deliverables {
  if (_deliverables is EqualUnmodifiableListView) return _deliverables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deliverables);
}

@override@JsonKey() final  int progress;
@override final  String? currentStep;
@override final  String? errorMessage;
@override final  int creditsCost;
@override final  int? creditsRefunded;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of PackageOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageOrderCopyWith<_PackageOrder> get copyWith => __$PackageOrderCopyWithImpl<_PackageOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.packageType, packageType) || other.packageType == packageType)&&(identical(other.status, status) || other.status == status)&&(identical(other.productId, productId) || other.productId == productId)&&const DeepCollectionEquality().equals(other._productData, _productData)&&const DeepCollectionEquality().equals(other._brandData, _brandData)&&const DeepCollectionEquality().equals(other._preferences, _preferences)&&const DeepCollectionEquality().equals(other._deliverables, _deliverables)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.creditsCost, creditsCost) || other.creditsCost == creditsCost)&&(identical(other.creditsRefunded, creditsRefunded) || other.creditsRefunded == creditsRefunded)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,storeId,packageType,status,productId,const DeepCollectionEquality().hash(_productData),const DeepCollectionEquality().hash(_brandData),const DeepCollectionEquality().hash(_preferences),const DeepCollectionEquality().hash(_deliverables),progress,currentStep,errorMessage,creditsCost,creditsRefunded,startedAt,completedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'PackageOrder(id: $id, userId: $userId, storeId: $storeId, packageType: $packageType, status: $status, productId: $productId, productData: $productData, brandData: $brandData, preferences: $preferences, deliverables: $deliverables, progress: $progress, currentStep: $currentStep, errorMessage: $errorMessage, creditsCost: $creditsCost, creditsRefunded: $creditsRefunded, startedAt: $startedAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PackageOrderCopyWith<$Res> implements $PackageOrderCopyWith<$Res> {
  factory _$PackageOrderCopyWith(_PackageOrder value, $Res Function(_PackageOrder) _then) = __$PackageOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String storeId, PackageType packageType, PackageStatus status, String? productId, Map<String, dynamic> productData, Map<String, dynamic>? brandData, Map<String, dynamic> preferences, List<PackageDeliverableResult> deliverables, int progress, String? currentStep, String? errorMessage, int creditsCost, int? creditsRefunded, DateTime? startedAt, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PackageOrderCopyWithImpl<$Res>
    implements _$PackageOrderCopyWith<$Res> {
  __$PackageOrderCopyWithImpl(this._self, this._then);

  final _PackageOrder _self;
  final $Res Function(_PackageOrder) _then;

/// Create a copy of PackageOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? storeId = null,Object? packageType = null,Object? status = null,Object? productId = freezed,Object? productData = null,Object? brandData = freezed,Object? preferences = null,Object? deliverables = null,Object? progress = null,Object? currentStep = freezed,Object? errorMessage = freezed,Object? creditsCost = null,Object? creditsRefunded = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PackageOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,packageType: null == packageType ? _self.packageType : packageType // ignore: cast_nullable_to_non_nullable
as PackageType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PackageStatus,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productData: null == productData ? _self._productData : productData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,brandData: freezed == brandData ? _self._brandData : brandData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,preferences: null == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,deliverables: null == deliverables ? _self._deliverables : deliverables // ignore: cast_nullable_to_non_nullable
as List<PackageDeliverableResult>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,creditsCost: null == creditsCost ? _self.creditsCost : creditsCost // ignore: cast_nullable_to_non_nullable
as int,creditsRefunded: freezed == creditsRefunded ? _self.creditsRefunded : creditsRefunded // ignore: cast_nullable_to_non_nullable
as int?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PackageDeliverableResult {

 String get id; String get type; String get format; String get url; String? get thumbnailUrl; int? get fileSizeBytes; int? get durationMs; int? get width; int? get height; Map<String, dynamic>? get metadata; DateTime get createdAt;
/// Create a copy of PackageDeliverableResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageDeliverableResultCopyWith<PackageDeliverableResult> get copyWith => _$PackageDeliverableResultCopyWithImpl<PackageDeliverableResult>(this as PackageDeliverableResult, _$identity);

  /// Serializes this PackageDeliverableResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageDeliverableResult&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.format, format) || other.format == format)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,format,url,thumbnailUrl,fileSizeBytes,durationMs,width,height,const DeepCollectionEquality().hash(metadata),createdAt);

@override
String toString() {
  return 'PackageDeliverableResult(id: $id, type: $type, format: $format, url: $url, thumbnailUrl: $thumbnailUrl, fileSizeBytes: $fileSizeBytes, durationMs: $durationMs, width: $width, height: $height, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PackageDeliverableResultCopyWith<$Res>  {
  factory $PackageDeliverableResultCopyWith(PackageDeliverableResult value, $Res Function(PackageDeliverableResult) _then) = _$PackageDeliverableResultCopyWithImpl;
@useResult
$Res call({
 String id, String type, String format, String url, String? thumbnailUrl, int? fileSizeBytes, int? durationMs, int? width, int? height, Map<String, dynamic>? metadata, DateTime createdAt
});




}
/// @nodoc
class _$PackageDeliverableResultCopyWithImpl<$Res>
    implements $PackageDeliverableResultCopyWith<$Res> {
  _$PackageDeliverableResultCopyWithImpl(this._self, this._then);

  final PackageDeliverableResult _self;
  final $Res Function(PackageDeliverableResult) _then;

/// Create a copy of PackageDeliverableResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? format = null,Object? url = null,Object? thumbnailUrl = freezed,Object? fileSizeBytes = freezed,Object? durationMs = freezed,Object? width = freezed,Object? height = freezed,Object? metadata = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PackageDeliverableResult].
extension PackageDeliverableResultPatterns on PackageDeliverableResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageDeliverableResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageDeliverableResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageDeliverableResult value)  $default,){
final _that = this;
switch (_that) {
case _PackageDeliverableResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageDeliverableResult value)?  $default,){
final _that = this;
switch (_that) {
case _PackageDeliverableResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String format,  String url,  String? thumbnailUrl,  int? fileSizeBytes,  int? durationMs,  int? width,  int? height,  Map<String, dynamic>? metadata,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackageDeliverableResult() when $default != null:
return $default(_that.id,_that.type,_that.format,_that.url,_that.thumbnailUrl,_that.fileSizeBytes,_that.durationMs,_that.width,_that.height,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String format,  String url,  String? thumbnailUrl,  int? fileSizeBytes,  int? durationMs,  int? width,  int? height,  Map<String, dynamic>? metadata,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PackageDeliverableResult():
return $default(_that.id,_that.type,_that.format,_that.url,_that.thumbnailUrl,_that.fileSizeBytes,_that.durationMs,_that.width,_that.height,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String format,  String url,  String? thumbnailUrl,  int? fileSizeBytes,  int? durationMs,  int? width,  int? height,  Map<String, dynamic>? metadata,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PackageDeliverableResult() when $default != null:
return $default(_that.id,_that.type,_that.format,_that.url,_that.thumbnailUrl,_that.fileSizeBytes,_that.durationMs,_that.width,_that.height,_that.metadata,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageDeliverableResult implements PackageDeliverableResult {
  const _PackageDeliverableResult({required this.id, required this.type, required this.format, required this.url, this.thumbnailUrl, this.fileSizeBytes, this.durationMs, this.width, this.height, final  Map<String, dynamic>? metadata, required this.createdAt}): _metadata = metadata;
  factory _PackageDeliverableResult.fromJson(Map<String, dynamic> json) => _$PackageDeliverableResultFromJson(json);

@override final  String id;
@override final  String type;
@override final  String format;
@override final  String url;
@override final  String? thumbnailUrl;
@override final  int? fileSizeBytes;
@override final  int? durationMs;
@override final  int? width;
@override final  int? height;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;

/// Create a copy of PackageDeliverableResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageDeliverableResultCopyWith<_PackageDeliverableResult> get copyWith => __$PackageDeliverableResultCopyWithImpl<_PackageDeliverableResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageDeliverableResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageDeliverableResult&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.format, format) || other.format == format)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,format,url,thumbnailUrl,fileSizeBytes,durationMs,width,height,const DeepCollectionEquality().hash(_metadata),createdAt);

@override
String toString() {
  return 'PackageDeliverableResult(id: $id, type: $type, format: $format, url: $url, thumbnailUrl: $thumbnailUrl, fileSizeBytes: $fileSizeBytes, durationMs: $durationMs, width: $width, height: $height, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PackageDeliverableResultCopyWith<$Res> implements $PackageDeliverableResultCopyWith<$Res> {
  factory _$PackageDeliverableResultCopyWith(_PackageDeliverableResult value, $Res Function(_PackageDeliverableResult) _then) = __$PackageDeliverableResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String format, String url, String? thumbnailUrl, int? fileSizeBytes, int? durationMs, int? width, int? height, Map<String, dynamic>? metadata, DateTime createdAt
});




}
/// @nodoc
class __$PackageDeliverableResultCopyWithImpl<$Res>
    implements _$PackageDeliverableResultCopyWith<$Res> {
  __$PackageDeliverableResultCopyWithImpl(this._self, this._then);

  final _PackageDeliverableResult _self;
  final $Res Function(_PackageDeliverableResult) _then;

/// Create a copy of PackageDeliverableResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? format = null,Object? url = null,Object? thumbnailUrl = freezed,Object? fileSizeBytes = freezed,Object? durationMs = freezed,Object? width = freezed,Object? height = freezed,Object? metadata = freezed,Object? createdAt = null,}) {
  return _then(_PackageDeliverableResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ProductInputData {

 String get name; String? get nameAr; String? get description; String? get descriptionAr; double? get price; String? get currency; String? get category; List<String> get images; List<String> get features; String? get targetAudience; List<String> get uniqueSellingPoints;
/// Create a copy of ProductInputData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductInputDataCopyWith<ProductInputData> get copyWith => _$ProductInputDataCopyWithImpl<ProductInputData>(this as ProductInputData, _$identity);

  /// Serializes this ProductInputData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductInputData&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.features, features)&&(identical(other.targetAudience, targetAudience) || other.targetAudience == targetAudience)&&const DeepCollectionEquality().equals(other.uniqueSellingPoints, uniqueSellingPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,nameAr,description,descriptionAr,price,currency,category,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(features),targetAudience,const DeepCollectionEquality().hash(uniqueSellingPoints));

@override
String toString() {
  return 'ProductInputData(name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, price: $price, currency: $currency, category: $category, images: $images, features: $features, targetAudience: $targetAudience, uniqueSellingPoints: $uniqueSellingPoints)';
}


}

/// @nodoc
abstract mixin class $ProductInputDataCopyWith<$Res>  {
  factory $ProductInputDataCopyWith(ProductInputData value, $Res Function(ProductInputData) _then) = _$ProductInputDataCopyWithImpl;
@useResult
$Res call({
 String name, String? nameAr, String? description, String? descriptionAr, double? price, String? currency, String? category, List<String> images, List<String> features, String? targetAudience, List<String> uniqueSellingPoints
});




}
/// @nodoc
class _$ProductInputDataCopyWithImpl<$Res>
    implements $ProductInputDataCopyWith<$Res> {
  _$ProductInputDataCopyWithImpl(this._self, this._then);

  final ProductInputData _self;
  final $Res Function(ProductInputData) _then;

/// Create a copy of ProductInputData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? nameAr = freezed,Object? description = freezed,Object? descriptionAr = freezed,Object? price = freezed,Object? currency = freezed,Object? category = freezed,Object? images = null,Object? features = null,Object? targetAudience = freezed,Object? uniqueSellingPoints = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,targetAudience: freezed == targetAudience ? _self.targetAudience : targetAudience // ignore: cast_nullable_to_non_nullable
as String?,uniqueSellingPoints: null == uniqueSellingPoints ? _self.uniqueSellingPoints : uniqueSellingPoints // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductInputData].
extension ProductInputDataPatterns on ProductInputData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductInputData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductInputData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductInputData value)  $default,){
final _that = this;
switch (_that) {
case _ProductInputData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductInputData value)?  $default,){
final _that = this;
switch (_that) {
case _ProductInputData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? nameAr,  String? description,  String? descriptionAr,  double? price,  String? currency,  String? category,  List<String> images,  List<String> features,  String? targetAudience,  List<String> uniqueSellingPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductInputData() when $default != null:
return $default(_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.price,_that.currency,_that.category,_that.images,_that.features,_that.targetAudience,_that.uniqueSellingPoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? nameAr,  String? description,  String? descriptionAr,  double? price,  String? currency,  String? category,  List<String> images,  List<String> features,  String? targetAudience,  List<String> uniqueSellingPoints)  $default,) {final _that = this;
switch (_that) {
case _ProductInputData():
return $default(_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.price,_that.currency,_that.category,_that.images,_that.features,_that.targetAudience,_that.uniqueSellingPoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? nameAr,  String? description,  String? descriptionAr,  double? price,  String? currency,  String? category,  List<String> images,  List<String> features,  String? targetAudience,  List<String> uniqueSellingPoints)?  $default,) {final _that = this;
switch (_that) {
case _ProductInputData() when $default != null:
return $default(_that.name,_that.nameAr,_that.description,_that.descriptionAr,_that.price,_that.currency,_that.category,_that.images,_that.features,_that.targetAudience,_that.uniqueSellingPoints);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductInputData implements ProductInputData {
  const _ProductInputData({required this.name, this.nameAr, this.description, this.descriptionAr, this.price, this.currency, this.category, final  List<String> images = const [], final  List<String> features = const [], this.targetAudience, final  List<String> uniqueSellingPoints = const []}): _images = images,_features = features,_uniqueSellingPoints = uniqueSellingPoints;
  factory _ProductInputData.fromJson(Map<String, dynamic> json) => _$ProductInputDataFromJson(json);

@override final  String name;
@override final  String? nameAr;
@override final  String? description;
@override final  String? descriptionAr;
@override final  double? price;
@override final  String? currency;
@override final  String? category;
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

@override final  String? targetAudience;
 final  List<String> _uniqueSellingPoints;
@override@JsonKey() List<String> get uniqueSellingPoints {
  if (_uniqueSellingPoints is EqualUnmodifiableListView) return _uniqueSellingPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uniqueSellingPoints);
}


/// Create a copy of ProductInputData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductInputDataCopyWith<_ProductInputData> get copyWith => __$ProductInputDataCopyWithImpl<_ProductInputData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductInputDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductInputData&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionAr, descriptionAr) || other.descriptionAr == descriptionAr)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._features, _features)&&(identical(other.targetAudience, targetAudience) || other.targetAudience == targetAudience)&&const DeepCollectionEquality().equals(other._uniqueSellingPoints, _uniqueSellingPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,nameAr,description,descriptionAr,price,currency,category,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_features),targetAudience,const DeepCollectionEquality().hash(_uniqueSellingPoints));

@override
String toString() {
  return 'ProductInputData(name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, price: $price, currency: $currency, category: $category, images: $images, features: $features, targetAudience: $targetAudience, uniqueSellingPoints: $uniqueSellingPoints)';
}


}

/// @nodoc
abstract mixin class _$ProductInputDataCopyWith<$Res> implements $ProductInputDataCopyWith<$Res> {
  factory _$ProductInputDataCopyWith(_ProductInputData value, $Res Function(_ProductInputData) _then) = __$ProductInputDataCopyWithImpl;
@override @useResult
$Res call({
 String name, String? nameAr, String? description, String? descriptionAr, double? price, String? currency, String? category, List<String> images, List<String> features, String? targetAudience, List<String> uniqueSellingPoints
});




}
/// @nodoc
class __$ProductInputDataCopyWithImpl<$Res>
    implements _$ProductInputDataCopyWith<$Res> {
  __$ProductInputDataCopyWithImpl(this._self, this._then);

  final _ProductInputData _self;
  final $Res Function(_ProductInputData) _then;

/// Create a copy of ProductInputData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? nameAr = freezed,Object? description = freezed,Object? descriptionAr = freezed,Object? price = freezed,Object? currency = freezed,Object? category = freezed,Object? images = null,Object? features = null,Object? targetAudience = freezed,Object? uniqueSellingPoints = null,}) {
  return _then(_ProductInputData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: freezed == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionAr: freezed == descriptionAr ? _self.descriptionAr : descriptionAr // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,targetAudience: freezed == targetAudience ? _self.targetAudience : targetAudience // ignore: cast_nullable_to_non_nullable
as String?,uniqueSellingPoints: null == uniqueSellingPoints ? _self._uniqueSellingPoints : uniqueSellingPoints // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$BrandInputData {

 String get storeName; String? get storeNameAr; String? get tagline; String? get taglineAr; String? get primaryColor; String? get secondaryColor; String? get existingLogoUrl; String? get industry; List<String> get stylePreferences;
/// Create a copy of BrandInputData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandInputDataCopyWith<BrandInputData> get copyWith => _$BrandInputDataCopyWithImpl<BrandInputData>(this as BrandInputData, _$identity);

  /// Serializes this BrandInputData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandInputData&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.storeNameAr, storeNameAr) || other.storeNameAr == storeNameAr)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.taglineAr, taglineAr) || other.taglineAr == taglineAr)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.secondaryColor, secondaryColor) || other.secondaryColor == secondaryColor)&&(identical(other.existingLogoUrl, existingLogoUrl) || other.existingLogoUrl == existingLogoUrl)&&(identical(other.industry, industry) || other.industry == industry)&&const DeepCollectionEquality().equals(other.stylePreferences, stylePreferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeName,storeNameAr,tagline,taglineAr,primaryColor,secondaryColor,existingLogoUrl,industry,const DeepCollectionEquality().hash(stylePreferences));

@override
String toString() {
  return 'BrandInputData(storeName: $storeName, storeNameAr: $storeNameAr, tagline: $tagline, taglineAr: $taglineAr, primaryColor: $primaryColor, secondaryColor: $secondaryColor, existingLogoUrl: $existingLogoUrl, industry: $industry, stylePreferences: $stylePreferences)';
}


}

/// @nodoc
abstract mixin class $BrandInputDataCopyWith<$Res>  {
  factory $BrandInputDataCopyWith(BrandInputData value, $Res Function(BrandInputData) _then) = _$BrandInputDataCopyWithImpl;
@useResult
$Res call({
 String storeName, String? storeNameAr, String? tagline, String? taglineAr, String? primaryColor, String? secondaryColor, String? existingLogoUrl, String? industry, List<String> stylePreferences
});




}
/// @nodoc
class _$BrandInputDataCopyWithImpl<$Res>
    implements $BrandInputDataCopyWith<$Res> {
  _$BrandInputDataCopyWithImpl(this._self, this._then);

  final BrandInputData _self;
  final $Res Function(BrandInputData) _then;

/// Create a copy of BrandInputData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeName = null,Object? storeNameAr = freezed,Object? tagline = freezed,Object? taglineAr = freezed,Object? primaryColor = freezed,Object? secondaryColor = freezed,Object? existingLogoUrl = freezed,Object? industry = freezed,Object? stylePreferences = null,}) {
  return _then(_self.copyWith(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,storeNameAr: freezed == storeNameAr ? _self.storeNameAr : storeNameAr // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,taglineAr: freezed == taglineAr ? _self.taglineAr : taglineAr // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,secondaryColor: freezed == secondaryColor ? _self.secondaryColor : secondaryColor // ignore: cast_nullable_to_non_nullable
as String?,existingLogoUrl: freezed == existingLogoUrl ? _self.existingLogoUrl : existingLogoUrl // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,stylePreferences: null == stylePreferences ? _self.stylePreferences : stylePreferences // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BrandInputData].
extension BrandInputDataPatterns on BrandInputData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrandInputData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrandInputData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrandInputData value)  $default,){
final _that = this;
switch (_that) {
case _BrandInputData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrandInputData value)?  $default,){
final _that = this;
switch (_that) {
case _BrandInputData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeName,  String? storeNameAr,  String? tagline,  String? taglineAr,  String? primaryColor,  String? secondaryColor,  String? existingLogoUrl,  String? industry,  List<String> stylePreferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrandInputData() when $default != null:
return $default(_that.storeName,_that.storeNameAr,_that.tagline,_that.taglineAr,_that.primaryColor,_that.secondaryColor,_that.existingLogoUrl,_that.industry,_that.stylePreferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeName,  String? storeNameAr,  String? tagline,  String? taglineAr,  String? primaryColor,  String? secondaryColor,  String? existingLogoUrl,  String? industry,  List<String> stylePreferences)  $default,) {final _that = this;
switch (_that) {
case _BrandInputData():
return $default(_that.storeName,_that.storeNameAr,_that.tagline,_that.taglineAr,_that.primaryColor,_that.secondaryColor,_that.existingLogoUrl,_that.industry,_that.stylePreferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeName,  String? storeNameAr,  String? tagline,  String? taglineAr,  String? primaryColor,  String? secondaryColor,  String? existingLogoUrl,  String? industry,  List<String> stylePreferences)?  $default,) {final _that = this;
switch (_that) {
case _BrandInputData() when $default != null:
return $default(_that.storeName,_that.storeNameAr,_that.tagline,_that.taglineAr,_that.primaryColor,_that.secondaryColor,_that.existingLogoUrl,_that.industry,_that.stylePreferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BrandInputData implements BrandInputData {
  const _BrandInputData({required this.storeName, this.storeNameAr, this.tagline, this.taglineAr, this.primaryColor, this.secondaryColor, this.existingLogoUrl, this.industry, final  List<String> stylePreferences = const []}): _stylePreferences = stylePreferences;
  factory _BrandInputData.fromJson(Map<String, dynamic> json) => _$BrandInputDataFromJson(json);

@override final  String storeName;
@override final  String? storeNameAr;
@override final  String? tagline;
@override final  String? taglineAr;
@override final  String? primaryColor;
@override final  String? secondaryColor;
@override final  String? existingLogoUrl;
@override final  String? industry;
 final  List<String> _stylePreferences;
@override@JsonKey() List<String> get stylePreferences {
  if (_stylePreferences is EqualUnmodifiableListView) return _stylePreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stylePreferences);
}


/// Create a copy of BrandInputData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrandInputDataCopyWith<_BrandInputData> get copyWith => __$BrandInputDataCopyWithImpl<_BrandInputData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrandInputDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrandInputData&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.storeNameAr, storeNameAr) || other.storeNameAr == storeNameAr)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.taglineAr, taglineAr) || other.taglineAr == taglineAr)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.secondaryColor, secondaryColor) || other.secondaryColor == secondaryColor)&&(identical(other.existingLogoUrl, existingLogoUrl) || other.existingLogoUrl == existingLogoUrl)&&(identical(other.industry, industry) || other.industry == industry)&&const DeepCollectionEquality().equals(other._stylePreferences, _stylePreferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeName,storeNameAr,tagline,taglineAr,primaryColor,secondaryColor,existingLogoUrl,industry,const DeepCollectionEquality().hash(_stylePreferences));

@override
String toString() {
  return 'BrandInputData(storeName: $storeName, storeNameAr: $storeNameAr, tagline: $tagline, taglineAr: $taglineAr, primaryColor: $primaryColor, secondaryColor: $secondaryColor, existingLogoUrl: $existingLogoUrl, industry: $industry, stylePreferences: $stylePreferences)';
}


}

/// @nodoc
abstract mixin class _$BrandInputDataCopyWith<$Res> implements $BrandInputDataCopyWith<$Res> {
  factory _$BrandInputDataCopyWith(_BrandInputData value, $Res Function(_BrandInputData) _then) = __$BrandInputDataCopyWithImpl;
@override @useResult
$Res call({
 String storeName, String? storeNameAr, String? tagline, String? taglineAr, String? primaryColor, String? secondaryColor, String? existingLogoUrl, String? industry, List<String> stylePreferences
});




}
/// @nodoc
class __$BrandInputDataCopyWithImpl<$Res>
    implements _$BrandInputDataCopyWith<$Res> {
  __$BrandInputDataCopyWithImpl(this._self, this._then);

  final _BrandInputData _self;
  final $Res Function(_BrandInputData) _then;

/// Create a copy of BrandInputData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeName = null,Object? storeNameAr = freezed,Object? tagline = freezed,Object? taglineAr = freezed,Object? primaryColor = freezed,Object? secondaryColor = freezed,Object? existingLogoUrl = freezed,Object? industry = freezed,Object? stylePreferences = null,}) {
  return _then(_BrandInputData(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,storeNameAr: freezed == storeNameAr ? _self.storeNameAr : storeNameAr // ignore: cast_nullable_to_non_nullable
as String?,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,taglineAr: freezed == taglineAr ? _self.taglineAr : taglineAr // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,secondaryColor: freezed == secondaryColor ? _self.secondaryColor : secondaryColor // ignore: cast_nullable_to_non_nullable
as String?,existingLogoUrl: freezed == existingLogoUrl ? _self.existingLogoUrl : existingLogoUrl // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,stylePreferences: null == stylePreferences ? _self._stylePreferences : stylePreferences // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PackagePreferences {

 String get language; String? get tone; int? get durationSeconds; String? get aspectRatio; List<String> get platforms; String? get musicStyle; String? get voiceGender; bool get includeSubtitles; String? get customInstructions;
/// Create a copy of PackagePreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackagePreferencesCopyWith<PackagePreferences> get copyWith => _$PackagePreferencesCopyWithImpl<PackagePreferences>(this as PackagePreferences, _$identity);

  /// Serializes this PackagePreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackagePreferences&&(identical(other.language, language) || other.language == language)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&const DeepCollectionEquality().equals(other.platforms, platforms)&&(identical(other.musicStyle, musicStyle) || other.musicStyle == musicStyle)&&(identical(other.voiceGender, voiceGender) || other.voiceGender == voiceGender)&&(identical(other.includeSubtitles, includeSubtitles) || other.includeSubtitles == includeSubtitles)&&(identical(other.customInstructions, customInstructions) || other.customInstructions == customInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,tone,durationSeconds,aspectRatio,const DeepCollectionEquality().hash(platforms),musicStyle,voiceGender,includeSubtitles,customInstructions);

@override
String toString() {
  return 'PackagePreferences(language: $language, tone: $tone, durationSeconds: $durationSeconds, aspectRatio: $aspectRatio, platforms: $platforms, musicStyle: $musicStyle, voiceGender: $voiceGender, includeSubtitles: $includeSubtitles, customInstructions: $customInstructions)';
}


}

/// @nodoc
abstract mixin class $PackagePreferencesCopyWith<$Res>  {
  factory $PackagePreferencesCopyWith(PackagePreferences value, $Res Function(PackagePreferences) _then) = _$PackagePreferencesCopyWithImpl;
@useResult
$Res call({
 String language, String? tone, int? durationSeconds, String? aspectRatio, List<String> platforms, String? musicStyle, String? voiceGender, bool includeSubtitles, String? customInstructions
});




}
/// @nodoc
class _$PackagePreferencesCopyWithImpl<$Res>
    implements $PackagePreferencesCopyWith<$Res> {
  _$PackagePreferencesCopyWithImpl(this._self, this._then);

  final PackagePreferences _self;
  final $Res Function(PackagePreferences) _then;

/// Create a copy of PackagePreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? language = null,Object? tone = freezed,Object? durationSeconds = freezed,Object? aspectRatio = freezed,Object? platforms = null,Object? musicStyle = freezed,Object? voiceGender = freezed,Object? includeSubtitles = null,Object? customInstructions = freezed,}) {
  return _then(_self.copyWith(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,tone: freezed == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,aspectRatio: freezed == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as String?,platforms: null == platforms ? _self.platforms : platforms // ignore: cast_nullable_to_non_nullable
as List<String>,musicStyle: freezed == musicStyle ? _self.musicStyle : musicStyle // ignore: cast_nullable_to_non_nullable
as String?,voiceGender: freezed == voiceGender ? _self.voiceGender : voiceGender // ignore: cast_nullable_to_non_nullable
as String?,includeSubtitles: null == includeSubtitles ? _self.includeSubtitles : includeSubtitles // ignore: cast_nullable_to_non_nullable
as bool,customInstructions: freezed == customInstructions ? _self.customInstructions : customInstructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PackagePreferences].
extension PackagePreferencesPatterns on PackagePreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackagePreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackagePreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackagePreferences value)  $default,){
final _that = this;
switch (_that) {
case _PackagePreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackagePreferences value)?  $default,){
final _that = this;
switch (_that) {
case _PackagePreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String language,  String? tone,  int? durationSeconds,  String? aspectRatio,  List<String> platforms,  String? musicStyle,  String? voiceGender,  bool includeSubtitles,  String? customInstructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackagePreferences() when $default != null:
return $default(_that.language,_that.tone,_that.durationSeconds,_that.aspectRatio,_that.platforms,_that.musicStyle,_that.voiceGender,_that.includeSubtitles,_that.customInstructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String language,  String? tone,  int? durationSeconds,  String? aspectRatio,  List<String> platforms,  String? musicStyle,  String? voiceGender,  bool includeSubtitles,  String? customInstructions)  $default,) {final _that = this;
switch (_that) {
case _PackagePreferences():
return $default(_that.language,_that.tone,_that.durationSeconds,_that.aspectRatio,_that.platforms,_that.musicStyle,_that.voiceGender,_that.includeSubtitles,_that.customInstructions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String language,  String? tone,  int? durationSeconds,  String? aspectRatio,  List<String> platforms,  String? musicStyle,  String? voiceGender,  bool includeSubtitles,  String? customInstructions)?  $default,) {final _that = this;
switch (_that) {
case _PackagePreferences() when $default != null:
return $default(_that.language,_that.tone,_that.durationSeconds,_that.aspectRatio,_that.platforms,_that.musicStyle,_that.voiceGender,_that.includeSubtitles,_that.customInstructions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackagePreferences implements PackagePreferences {
  const _PackagePreferences({this.language = 'ar', this.tone, this.durationSeconds, this.aspectRatio, final  List<String> platforms = const [], this.musicStyle, this.voiceGender, this.includeSubtitles = false, this.customInstructions}): _platforms = platforms;
  factory _PackagePreferences.fromJson(Map<String, dynamic> json) => _$PackagePreferencesFromJson(json);

@override@JsonKey() final  String language;
@override final  String? tone;
@override final  int? durationSeconds;
@override final  String? aspectRatio;
 final  List<String> _platforms;
@override@JsonKey() List<String> get platforms {
  if (_platforms is EqualUnmodifiableListView) return _platforms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_platforms);
}

@override final  String? musicStyle;
@override final  String? voiceGender;
@override@JsonKey() final  bool includeSubtitles;
@override final  String? customInstructions;

/// Create a copy of PackagePreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackagePreferencesCopyWith<_PackagePreferences> get copyWith => __$PackagePreferencesCopyWithImpl<_PackagePreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackagePreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackagePreferences&&(identical(other.language, language) || other.language == language)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&const DeepCollectionEquality().equals(other._platforms, _platforms)&&(identical(other.musicStyle, musicStyle) || other.musicStyle == musicStyle)&&(identical(other.voiceGender, voiceGender) || other.voiceGender == voiceGender)&&(identical(other.includeSubtitles, includeSubtitles) || other.includeSubtitles == includeSubtitles)&&(identical(other.customInstructions, customInstructions) || other.customInstructions == customInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,tone,durationSeconds,aspectRatio,const DeepCollectionEquality().hash(_platforms),musicStyle,voiceGender,includeSubtitles,customInstructions);

@override
String toString() {
  return 'PackagePreferences(language: $language, tone: $tone, durationSeconds: $durationSeconds, aspectRatio: $aspectRatio, platforms: $platforms, musicStyle: $musicStyle, voiceGender: $voiceGender, includeSubtitles: $includeSubtitles, customInstructions: $customInstructions)';
}


}

/// @nodoc
abstract mixin class _$PackagePreferencesCopyWith<$Res> implements $PackagePreferencesCopyWith<$Res> {
  factory _$PackagePreferencesCopyWith(_PackagePreferences value, $Res Function(_PackagePreferences) _then) = __$PackagePreferencesCopyWithImpl;
@override @useResult
$Res call({
 String language, String? tone, int? durationSeconds, String? aspectRatio, List<String> platforms, String? musicStyle, String? voiceGender, bool includeSubtitles, String? customInstructions
});




}
/// @nodoc
class __$PackagePreferencesCopyWithImpl<$Res>
    implements _$PackagePreferencesCopyWith<$Res> {
  __$PackagePreferencesCopyWithImpl(this._self, this._then);

  final _PackagePreferences _self;
  final $Res Function(_PackagePreferences) _then;

/// Create a copy of PackagePreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? language = null,Object? tone = freezed,Object? durationSeconds = freezed,Object? aspectRatio = freezed,Object? platforms = null,Object? musicStyle = freezed,Object? voiceGender = freezed,Object? includeSubtitles = null,Object? customInstructions = freezed,}) {
  return _then(_PackagePreferences(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,tone: freezed == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,aspectRatio: freezed == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as String?,platforms: null == platforms ? _self._platforms : platforms // ignore: cast_nullable_to_non_nullable
as List<String>,musicStyle: freezed == musicStyle ? _self.musicStyle : musicStyle // ignore: cast_nullable_to_non_nullable
as String?,voiceGender: freezed == voiceGender ? _self.voiceGender : voiceGender // ignore: cast_nullable_to_non_nullable
as String?,includeSubtitles: null == includeSubtitles ? _self.includeSubtitles : includeSubtitles // ignore: cast_nullable_to_non_nullable
as bool,customInstructions: freezed == customInstructions ? _self.customInstructions : customInstructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
