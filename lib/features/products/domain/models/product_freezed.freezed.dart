// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_freezed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductMediaFreezed {

 String get id;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'media_type') String get mediaType; String get url;@JsonKey(name: 'sort_order') int get sortOrder;@JsonKey(name: 'is_main') bool get isMain;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of ProductMediaFreezed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductMediaFreezedCopyWith<ProductMediaFreezed> get copyWith => _$ProductMediaFreezedCopyWithImpl<ProductMediaFreezed>(this as ProductMediaFreezed, _$identity);

  /// Serializes this ProductMediaFreezed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductMediaFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.url, url) || other.url == url)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,mediaType,url,sortOrder,isMain,createdAt);

@override
String toString() {
  return 'ProductMediaFreezed(id: $id, productId: $productId, mediaType: $mediaType, url: $url, sortOrder: $sortOrder, isMain: $isMain, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProductMediaFreezedCopyWith<$Res>  {
  factory $ProductMediaFreezedCopyWith(ProductMediaFreezed value, $Res Function(ProductMediaFreezed) _then) = _$ProductMediaFreezedCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'media_type') String mediaType, String url,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_main') bool isMain,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ProductMediaFreezedCopyWithImpl<$Res>
    implements $ProductMediaFreezedCopyWith<$Res> {
  _$ProductMediaFreezedCopyWithImpl(this._self, this._then);

  final ProductMediaFreezed _self;
  final $Res Function(ProductMediaFreezed) _then;

/// Create a copy of ProductMediaFreezed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? mediaType = null,Object? url = null,Object? sortOrder = null,Object? isMain = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductMediaFreezed].
extension ProductMediaFreezedPatterns on ProductMediaFreezed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductMediaFreezed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductMediaFreezed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductMediaFreezed value)  $default,){
final _that = this;
switch (_that) {
case _ProductMediaFreezed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductMediaFreezed value)?  $default,){
final _that = this;
switch (_that) {
case _ProductMediaFreezed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'media_type')  String mediaType,  String url, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_main')  bool isMain, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductMediaFreezed() when $default != null:
return $default(_that.id,_that.productId,_that.mediaType,_that.url,_that.sortOrder,_that.isMain,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'media_type')  String mediaType,  String url, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_main')  bool isMain, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProductMediaFreezed():
return $default(_that.id,_that.productId,_that.mediaType,_that.url,_that.sortOrder,_that.isMain,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'media_type')  String mediaType,  String url, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_main')  bool isMain, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductMediaFreezed() when $default != null:
return $default(_that.id,_that.productId,_that.mediaType,_that.url,_that.sortOrder,_that.isMain,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductMediaFreezed extends ProductMediaFreezed {
  const _ProductMediaFreezed({required this.id, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'media_type') this.mediaType = 'image', required this.url, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'is_main') this.isMain = false, @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _ProductMediaFreezed.fromJson(Map<String, dynamic> json) => _$ProductMediaFreezedFromJson(json);

@override final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'media_type') final  String mediaType;
@override final  String url;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey(name: 'is_main') final  bool isMain;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of ProductMediaFreezed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductMediaFreezedCopyWith<_ProductMediaFreezed> get copyWith => __$ProductMediaFreezedCopyWithImpl<_ProductMediaFreezed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductMediaFreezedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductMediaFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.url, url) || other.url == url)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,mediaType,url,sortOrder,isMain,createdAt);

@override
String toString() {
  return 'ProductMediaFreezed(id: $id, productId: $productId, mediaType: $mediaType, url: $url, sortOrder: $sortOrder, isMain: $isMain, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProductMediaFreezedCopyWith<$Res> implements $ProductMediaFreezedCopyWith<$Res> {
  factory _$ProductMediaFreezedCopyWith(_ProductMediaFreezed value, $Res Function(_ProductMediaFreezed) _then) = __$ProductMediaFreezedCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'media_type') String mediaType, String url,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_main') bool isMain,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ProductMediaFreezedCopyWithImpl<$Res>
    implements _$ProductMediaFreezedCopyWith<$Res> {
  __$ProductMediaFreezedCopyWithImpl(this._self, this._then);

  final _ProductMediaFreezed _self;
  final $Res Function(_ProductMediaFreezed) _then;

/// Create a copy of ProductMediaFreezed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? mediaType = null,Object? url = null,Object? sortOrder = null,Object? isMain = null,Object? createdAt = freezed,}) {
  return _then(_ProductMediaFreezed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ProductFreezed {

 String get id; String get name; String? get description; double get price; int get stock;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'sub_category_id') String? get subCategoryId;@JsonKey(name: 'store_id') String get storeId;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt; List<ProductMediaFreezed> get media;@JsonKey(name: 'extra_data') Map<String, dynamic>? get extraData; double? get weight;@JsonKey(name: 'preparation_time') int? get preparationTime;@JsonKey(name: 'seo_keywords') List<String>? get seoKeywords;// التسعير
@JsonKey(name: 'cost_price') double? get costPrice;@JsonKey(name: 'original_price') double? get originalPrice;@JsonKey(name: 'discount_percentage') double? get discountPercentage;// المخزون
@JsonKey(name: 'low_stock_alert') int? get lowStockAlert; String? get sku; String? get barcode;// النوع
@JsonKey(name: 'product_type') String get productType;// الإعدادات
@JsonKey(name: 'show_in_store') bool get showInStore;@JsonKey(name: 'show_in_mbuy_app') bool get showInMbuyApp;@JsonKey(name: 'show_in_dropshipping') bool get showInDropshipping;
/// Create a copy of ProductFreezed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductFreezedCopyWith<ProductFreezed> get copyWith => _$ProductFreezedCopyWithImpl<ProductFreezed>(this as ProductFreezed, _$identity);

  /// Serializes this ProductFreezed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.subCategoryId, subCategoryId) || other.subCategoryId == subCategoryId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.media, media)&&const DeepCollectionEquality().equals(other.extraData, extraData)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.preparationTime, preparationTime) || other.preparationTime == preparationTime)&&const DeepCollectionEquality().equals(other.seoKeywords, seoKeywords)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.lowStockAlert, lowStockAlert) || other.lowStockAlert == lowStockAlert)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.showInStore, showInStore) || other.showInStore == showInStore)&&(identical(other.showInMbuyApp, showInMbuyApp) || other.showInMbuyApp == showInMbuyApp)&&(identical(other.showInDropshipping, showInDropshipping) || other.showInDropshipping == showInDropshipping));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,price,stock,imageUrl,categoryId,subCategoryId,storeId,isActive,createdAt,updatedAt,const DeepCollectionEquality().hash(media),const DeepCollectionEquality().hash(extraData),weight,preparationTime,const DeepCollectionEquality().hash(seoKeywords),costPrice,originalPrice,discountPercentage,lowStockAlert,sku,barcode,productType,showInStore,showInMbuyApp,showInDropshipping]);

@override
String toString() {
  return 'ProductFreezed(id: $id, name: $name, description: $description, price: $price, stock: $stock, imageUrl: $imageUrl, categoryId: $categoryId, subCategoryId: $subCategoryId, storeId: $storeId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, media: $media, extraData: $extraData, weight: $weight, preparationTime: $preparationTime, seoKeywords: $seoKeywords, costPrice: $costPrice, originalPrice: $originalPrice, discountPercentage: $discountPercentage, lowStockAlert: $lowStockAlert, sku: $sku, barcode: $barcode, productType: $productType, showInStore: $showInStore, showInMbuyApp: $showInMbuyApp, showInDropshipping: $showInDropshipping)';
}


}

/// @nodoc
abstract mixin class $ProductFreezedCopyWith<$Res>  {
  factory $ProductFreezedCopyWith(ProductFreezed value, $Res Function(ProductFreezed) _then) = _$ProductFreezedCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, double price, int stock,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'sub_category_id') String? subCategoryId,@JsonKey(name: 'store_id') String storeId,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, List<ProductMediaFreezed> media,@JsonKey(name: 'extra_data') Map<String, dynamic>? extraData, double? weight,@JsonKey(name: 'preparation_time') int? preparationTime,@JsonKey(name: 'seo_keywords') List<String>? seoKeywords,@JsonKey(name: 'cost_price') double? costPrice,@JsonKey(name: 'original_price') double? originalPrice,@JsonKey(name: 'discount_percentage') double? discountPercentage,@JsonKey(name: 'low_stock_alert') int? lowStockAlert, String? sku, String? barcode,@JsonKey(name: 'product_type') String productType,@JsonKey(name: 'show_in_store') bool showInStore,@JsonKey(name: 'show_in_mbuy_app') bool showInMbuyApp,@JsonKey(name: 'show_in_dropshipping') bool showInDropshipping
});




}
/// @nodoc
class _$ProductFreezedCopyWithImpl<$Res>
    implements $ProductFreezedCopyWith<$Res> {
  _$ProductFreezedCopyWithImpl(this._self, this._then);

  final ProductFreezed _self;
  final $Res Function(ProductFreezed) _then;

/// Create a copy of ProductFreezed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? price = null,Object? stock = null,Object? imageUrl = freezed,Object? categoryId = freezed,Object? subCategoryId = freezed,Object? storeId = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? media = null,Object? extraData = freezed,Object? weight = freezed,Object? preparationTime = freezed,Object? seoKeywords = freezed,Object? costPrice = freezed,Object? originalPrice = freezed,Object? discountPercentage = freezed,Object? lowStockAlert = freezed,Object? sku = freezed,Object? barcode = freezed,Object? productType = null,Object? showInStore = null,Object? showInMbuyApp = null,Object? showInDropshipping = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,subCategoryId: freezed == subCategoryId ? _self.subCategoryId : subCategoryId // ignore: cast_nullable_to_non_nullable
as String?,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<ProductMediaFreezed>,extraData: freezed == extraData ? _self.extraData : extraData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,preparationTime: freezed == preparationTime ? _self.preparationTime : preparationTime // ignore: cast_nullable_to_non_nullable
as int?,seoKeywords: freezed == seoKeywords ? _self.seoKeywords : seoKeywords // ignore: cast_nullable_to_non_nullable
as List<String>?,costPrice: freezed == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as double?,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,discountPercentage: freezed == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double?,lowStockAlert: freezed == lowStockAlert ? _self.lowStockAlert : lowStockAlert // ignore: cast_nullable_to_non_nullable
as int?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,showInStore: null == showInStore ? _self.showInStore : showInStore // ignore: cast_nullable_to_non_nullable
as bool,showInMbuyApp: null == showInMbuyApp ? _self.showInMbuyApp : showInMbuyApp // ignore: cast_nullable_to_non_nullable
as bool,showInDropshipping: null == showInDropshipping ? _self.showInDropshipping : showInDropshipping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductFreezed].
extension ProductFreezedPatterns on ProductFreezed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductFreezed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductFreezed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductFreezed value)  $default,){
final _that = this;
switch (_that) {
case _ProductFreezed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductFreezed value)?  $default,){
final _that = this;
switch (_that) {
case _ProductFreezed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  double price,  int stock, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'sub_category_id')  String? subCategoryId, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  List<ProductMediaFreezed> media, @JsonKey(name: 'extra_data')  Map<String, dynamic>? extraData,  double? weight, @JsonKey(name: 'preparation_time')  int? preparationTime, @JsonKey(name: 'seo_keywords')  List<String>? seoKeywords, @JsonKey(name: 'cost_price')  double? costPrice, @JsonKey(name: 'original_price')  double? originalPrice, @JsonKey(name: 'discount_percentage')  double? discountPercentage, @JsonKey(name: 'low_stock_alert')  int? lowStockAlert,  String? sku,  String? barcode, @JsonKey(name: 'product_type')  String productType, @JsonKey(name: 'show_in_store')  bool showInStore, @JsonKey(name: 'show_in_mbuy_app')  bool showInMbuyApp, @JsonKey(name: 'show_in_dropshipping')  bool showInDropshipping)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductFreezed() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.stock,_that.imageUrl,_that.categoryId,_that.subCategoryId,_that.storeId,_that.isActive,_that.createdAt,_that.updatedAt,_that.media,_that.extraData,_that.weight,_that.preparationTime,_that.seoKeywords,_that.costPrice,_that.originalPrice,_that.discountPercentage,_that.lowStockAlert,_that.sku,_that.barcode,_that.productType,_that.showInStore,_that.showInMbuyApp,_that.showInDropshipping);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  double price,  int stock, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'sub_category_id')  String? subCategoryId, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  List<ProductMediaFreezed> media, @JsonKey(name: 'extra_data')  Map<String, dynamic>? extraData,  double? weight, @JsonKey(name: 'preparation_time')  int? preparationTime, @JsonKey(name: 'seo_keywords')  List<String>? seoKeywords, @JsonKey(name: 'cost_price')  double? costPrice, @JsonKey(name: 'original_price')  double? originalPrice, @JsonKey(name: 'discount_percentage')  double? discountPercentage, @JsonKey(name: 'low_stock_alert')  int? lowStockAlert,  String? sku,  String? barcode, @JsonKey(name: 'product_type')  String productType, @JsonKey(name: 'show_in_store')  bool showInStore, @JsonKey(name: 'show_in_mbuy_app')  bool showInMbuyApp, @JsonKey(name: 'show_in_dropshipping')  bool showInDropshipping)  $default,) {final _that = this;
switch (_that) {
case _ProductFreezed():
return $default(_that.id,_that.name,_that.description,_that.price,_that.stock,_that.imageUrl,_that.categoryId,_that.subCategoryId,_that.storeId,_that.isActive,_that.createdAt,_that.updatedAt,_that.media,_that.extraData,_that.weight,_that.preparationTime,_that.seoKeywords,_that.costPrice,_that.originalPrice,_that.discountPercentage,_that.lowStockAlert,_that.sku,_that.barcode,_that.productType,_that.showInStore,_that.showInMbuyApp,_that.showInDropshipping);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  double price,  int stock, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'sub_category_id')  String? subCategoryId, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  List<ProductMediaFreezed> media, @JsonKey(name: 'extra_data')  Map<String, dynamic>? extraData,  double? weight, @JsonKey(name: 'preparation_time')  int? preparationTime, @JsonKey(name: 'seo_keywords')  List<String>? seoKeywords, @JsonKey(name: 'cost_price')  double? costPrice, @JsonKey(name: 'original_price')  double? originalPrice, @JsonKey(name: 'discount_percentage')  double? discountPercentage, @JsonKey(name: 'low_stock_alert')  int? lowStockAlert,  String? sku,  String? barcode, @JsonKey(name: 'product_type')  String productType, @JsonKey(name: 'show_in_store')  bool showInStore, @JsonKey(name: 'show_in_mbuy_app')  bool showInMbuyApp, @JsonKey(name: 'show_in_dropshipping')  bool showInDropshipping)?  $default,) {final _that = this;
switch (_that) {
case _ProductFreezed() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.stock,_that.imageUrl,_that.categoryId,_that.subCategoryId,_that.storeId,_that.isActive,_that.createdAt,_that.updatedAt,_that.media,_that.extraData,_that.weight,_that.preparationTime,_that.seoKeywords,_that.costPrice,_that.originalPrice,_that.discountPercentage,_that.lowStockAlert,_that.sku,_that.barcode,_that.productType,_that.showInStore,_that.showInMbuyApp,_that.showInDropshipping);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductFreezed extends ProductFreezed {
  const _ProductFreezed({required this.id, required this.name, this.description, required this.price, this.stock = 0, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'sub_category_id') this.subCategoryId, @JsonKey(name: 'store_id') required this.storeId, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, final  List<ProductMediaFreezed> media = const [], @JsonKey(name: 'extra_data') final  Map<String, dynamic>? extraData, this.weight, @JsonKey(name: 'preparation_time') this.preparationTime, @JsonKey(name: 'seo_keywords') final  List<String>? seoKeywords, @JsonKey(name: 'cost_price') this.costPrice, @JsonKey(name: 'original_price') this.originalPrice, @JsonKey(name: 'discount_percentage') this.discountPercentage, @JsonKey(name: 'low_stock_alert') this.lowStockAlert, this.sku, this.barcode, @JsonKey(name: 'product_type') this.productType = 'physical', @JsonKey(name: 'show_in_store') this.showInStore = true, @JsonKey(name: 'show_in_mbuy_app') this.showInMbuyApp = true, @JsonKey(name: 'show_in_dropshipping') this.showInDropshipping = false}): _media = media,_extraData = extraData,_seoKeywords = seoKeywords,super._();
  factory _ProductFreezed.fromJson(Map<String, dynamic> json) => _$ProductFreezedFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  double price;
@override@JsonKey() final  int stock;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'sub_category_id') final  String? subCategoryId;
@override@JsonKey(name: 'store_id') final  String storeId;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
 final  List<ProductMediaFreezed> _media;
@override@JsonKey() List<ProductMediaFreezed> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

 final  Map<String, dynamic>? _extraData;
@override@JsonKey(name: 'extra_data') Map<String, dynamic>? get extraData {
  final value = _extraData;
  if (value == null) return null;
  if (_extraData is EqualUnmodifiableMapView) return _extraData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  double? weight;
@override@JsonKey(name: 'preparation_time') final  int? preparationTime;
 final  List<String>? _seoKeywords;
@override@JsonKey(name: 'seo_keywords') List<String>? get seoKeywords {
  final value = _seoKeywords;
  if (value == null) return null;
  if (_seoKeywords is EqualUnmodifiableListView) return _seoKeywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// التسعير
@override@JsonKey(name: 'cost_price') final  double? costPrice;
@override@JsonKey(name: 'original_price') final  double? originalPrice;
@override@JsonKey(name: 'discount_percentage') final  double? discountPercentage;
// المخزون
@override@JsonKey(name: 'low_stock_alert') final  int? lowStockAlert;
@override final  String? sku;
@override final  String? barcode;
// النوع
@override@JsonKey(name: 'product_type') final  String productType;
// الإعدادات
@override@JsonKey(name: 'show_in_store') final  bool showInStore;
@override@JsonKey(name: 'show_in_mbuy_app') final  bool showInMbuyApp;
@override@JsonKey(name: 'show_in_dropshipping') final  bool showInDropshipping;

/// Create a copy of ProductFreezed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductFreezedCopyWith<_ProductFreezed> get copyWith => __$ProductFreezedCopyWithImpl<_ProductFreezed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductFreezedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.subCategoryId, subCategoryId) || other.subCategoryId == subCategoryId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._media, _media)&&const DeepCollectionEquality().equals(other._extraData, _extraData)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.preparationTime, preparationTime) || other.preparationTime == preparationTime)&&const DeepCollectionEquality().equals(other._seoKeywords, _seoKeywords)&&(identical(other.costPrice, costPrice) || other.costPrice == costPrice)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.lowStockAlert, lowStockAlert) || other.lowStockAlert == lowStockAlert)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.showInStore, showInStore) || other.showInStore == showInStore)&&(identical(other.showInMbuyApp, showInMbuyApp) || other.showInMbuyApp == showInMbuyApp)&&(identical(other.showInDropshipping, showInDropshipping) || other.showInDropshipping == showInDropshipping));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,price,stock,imageUrl,categoryId,subCategoryId,storeId,isActive,createdAt,updatedAt,const DeepCollectionEquality().hash(_media),const DeepCollectionEquality().hash(_extraData),weight,preparationTime,const DeepCollectionEquality().hash(_seoKeywords),costPrice,originalPrice,discountPercentage,lowStockAlert,sku,barcode,productType,showInStore,showInMbuyApp,showInDropshipping]);

@override
String toString() {
  return 'ProductFreezed(id: $id, name: $name, description: $description, price: $price, stock: $stock, imageUrl: $imageUrl, categoryId: $categoryId, subCategoryId: $subCategoryId, storeId: $storeId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, media: $media, extraData: $extraData, weight: $weight, preparationTime: $preparationTime, seoKeywords: $seoKeywords, costPrice: $costPrice, originalPrice: $originalPrice, discountPercentage: $discountPercentage, lowStockAlert: $lowStockAlert, sku: $sku, barcode: $barcode, productType: $productType, showInStore: $showInStore, showInMbuyApp: $showInMbuyApp, showInDropshipping: $showInDropshipping)';
}


}

/// @nodoc
abstract mixin class _$ProductFreezedCopyWith<$Res> implements $ProductFreezedCopyWith<$Res> {
  factory _$ProductFreezedCopyWith(_ProductFreezed value, $Res Function(_ProductFreezed) _then) = __$ProductFreezedCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, double price, int stock,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'sub_category_id') String? subCategoryId,@JsonKey(name: 'store_id') String storeId,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, List<ProductMediaFreezed> media,@JsonKey(name: 'extra_data') Map<String, dynamic>? extraData, double? weight,@JsonKey(name: 'preparation_time') int? preparationTime,@JsonKey(name: 'seo_keywords') List<String>? seoKeywords,@JsonKey(name: 'cost_price') double? costPrice,@JsonKey(name: 'original_price') double? originalPrice,@JsonKey(name: 'discount_percentage') double? discountPercentage,@JsonKey(name: 'low_stock_alert') int? lowStockAlert, String? sku, String? barcode,@JsonKey(name: 'product_type') String productType,@JsonKey(name: 'show_in_store') bool showInStore,@JsonKey(name: 'show_in_mbuy_app') bool showInMbuyApp,@JsonKey(name: 'show_in_dropshipping') bool showInDropshipping
});




}
/// @nodoc
class __$ProductFreezedCopyWithImpl<$Res>
    implements _$ProductFreezedCopyWith<$Res> {
  __$ProductFreezedCopyWithImpl(this._self, this._then);

  final _ProductFreezed _self;
  final $Res Function(_ProductFreezed) _then;

/// Create a copy of ProductFreezed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? price = null,Object? stock = null,Object? imageUrl = freezed,Object? categoryId = freezed,Object? subCategoryId = freezed,Object? storeId = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? media = null,Object? extraData = freezed,Object? weight = freezed,Object? preparationTime = freezed,Object? seoKeywords = freezed,Object? costPrice = freezed,Object? originalPrice = freezed,Object? discountPercentage = freezed,Object? lowStockAlert = freezed,Object? sku = freezed,Object? barcode = freezed,Object? productType = null,Object? showInStore = null,Object? showInMbuyApp = null,Object? showInDropshipping = null,}) {
  return _then(_ProductFreezed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,subCategoryId: freezed == subCategoryId ? _self.subCategoryId : subCategoryId // ignore: cast_nullable_to_non_nullable
as String?,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<ProductMediaFreezed>,extraData: freezed == extraData ? _self._extraData : extraData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,preparationTime: freezed == preparationTime ? _self.preparationTime : preparationTime // ignore: cast_nullable_to_non_nullable
as int?,seoKeywords: freezed == seoKeywords ? _self._seoKeywords : seoKeywords // ignore: cast_nullable_to_non_nullable
as List<String>?,costPrice: freezed == costPrice ? _self.costPrice : costPrice // ignore: cast_nullable_to_non_nullable
as double?,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,discountPercentage: freezed == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double?,lowStockAlert: freezed == lowStockAlert ? _self.lowStockAlert : lowStockAlert // ignore: cast_nullable_to_non_nullable
as int?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,showInStore: null == showInStore ? _self.showInStore : showInStore // ignore: cast_nullable_to_non_nullable
as bool,showInMbuyApp: null == showInMbuyApp ? _self.showInMbuyApp : showInMbuyApp // ignore: cast_nullable_to_non_nullable
as bool,showInDropshipping: null == showInDropshipping ? _self.showInDropshipping : showInDropshipping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProductCategoryFreezed {

 String get id; String get name; String? get description;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'store_id') String get storeId;@JsonKey(name: 'parent_id') String? get parentId;@JsonKey(name: 'sort_order') int get sortOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'products_count') int get productsCount;
/// Create a copy of ProductCategoryFreezed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCategoryFreezedCopyWith<ProductCategoryFreezed> get copyWith => _$ProductCategoryFreezedCopyWithImpl<ProductCategoryFreezed>(this as ProductCategoryFreezed, _$identity);

  /// Serializes this ProductCategoryFreezed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCategoryFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.productsCount, productsCount) || other.productsCount == productsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,storeId,parentId,sortOrder,isActive,productsCount);

@override
String toString() {
  return 'ProductCategoryFreezed(id: $id, name: $name, description: $description, imageUrl: $imageUrl, storeId: $storeId, parentId: $parentId, sortOrder: $sortOrder, isActive: $isActive, productsCount: $productsCount)';
}


}

/// @nodoc
abstract mixin class $ProductCategoryFreezedCopyWith<$Res>  {
  factory $ProductCategoryFreezedCopyWith(ProductCategoryFreezed value, $Res Function(ProductCategoryFreezed) _then) = _$ProductCategoryFreezedCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'store_id') String storeId,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'products_count') int productsCount
});




}
/// @nodoc
class _$ProductCategoryFreezedCopyWithImpl<$Res>
    implements $ProductCategoryFreezedCopyWith<$Res> {
  _$ProductCategoryFreezedCopyWithImpl(this._self, this._then);

  final ProductCategoryFreezed _self;
  final $Res Function(ProductCategoryFreezed) _then;

/// Create a copy of ProductCategoryFreezed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? imageUrl = freezed,Object? storeId = null,Object? parentId = freezed,Object? sortOrder = null,Object? isActive = null,Object? productsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,productsCount: null == productsCount ? _self.productsCount : productsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductCategoryFreezed].
extension ProductCategoryFreezedPatterns on ProductCategoryFreezed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductCategoryFreezed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductCategoryFreezed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductCategoryFreezed value)  $default,){
final _that = this;
switch (_that) {
case _ProductCategoryFreezed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductCategoryFreezed value)?  $default,){
final _that = this;
switch (_that) {
case _ProductCategoryFreezed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'products_count')  int productsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductCategoryFreezed() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.storeId,_that.parentId,_that.sortOrder,_that.isActive,_that.productsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'products_count')  int productsCount)  $default,) {final _that = this;
switch (_that) {
case _ProductCategoryFreezed():
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.storeId,_that.parentId,_that.sortOrder,_that.isActive,_that.productsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'store_id')  String storeId, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'products_count')  int productsCount)?  $default,) {final _that = this;
switch (_that) {
case _ProductCategoryFreezed() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.storeId,_that.parentId,_that.sortOrder,_that.isActive,_that.productsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductCategoryFreezed implements ProductCategoryFreezed {
  const _ProductCategoryFreezed({required this.id, required this.name, this.description, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'store_id') required this.storeId, @JsonKey(name: 'parent_id') this.parentId, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'products_count') this.productsCount = 0});
  factory _ProductCategoryFreezed.fromJson(Map<String, dynamic> json) => _$ProductCategoryFreezedFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'store_id') final  String storeId;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'products_count') final  int productsCount;

/// Create a copy of ProductCategoryFreezed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCategoryFreezedCopyWith<_ProductCategoryFreezed> get copyWith => __$ProductCategoryFreezedCopyWithImpl<_ProductCategoryFreezed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductCategoryFreezedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductCategoryFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.productsCount, productsCount) || other.productsCount == productsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,storeId,parentId,sortOrder,isActive,productsCount);

@override
String toString() {
  return 'ProductCategoryFreezed(id: $id, name: $name, description: $description, imageUrl: $imageUrl, storeId: $storeId, parentId: $parentId, sortOrder: $sortOrder, isActive: $isActive, productsCount: $productsCount)';
}


}

/// @nodoc
abstract mixin class _$ProductCategoryFreezedCopyWith<$Res> implements $ProductCategoryFreezedCopyWith<$Res> {
  factory _$ProductCategoryFreezedCopyWith(_ProductCategoryFreezed value, $Res Function(_ProductCategoryFreezed) _then) = __$ProductCategoryFreezedCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'store_id') String storeId,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'products_count') int productsCount
});




}
/// @nodoc
class __$ProductCategoryFreezedCopyWithImpl<$Res>
    implements _$ProductCategoryFreezedCopyWith<$Res> {
  __$ProductCategoryFreezedCopyWithImpl(this._self, this._then);

  final _ProductCategoryFreezed _self;
  final $Res Function(_ProductCategoryFreezed) _then;

/// Create a copy of ProductCategoryFreezed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? imageUrl = freezed,Object? storeId = null,Object? parentId = freezed,Object? sortOrder = null,Object? isActive = null,Object? productsCount = null,}) {
  return _then(_ProductCategoryFreezed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,productsCount: null == productsCount ? _self.productsCount : productsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProductVariantFreezed {

 String get id;@JsonKey(name: 'product_id') String get productId; String get name;@JsonKey(name: 'option_values') Map<String, String> get optionValues; double get price; int get stock; String? get sku;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of ProductVariantFreezed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductVariantFreezedCopyWith<ProductVariantFreezed> get copyWith => _$ProductVariantFreezedCopyWithImpl<ProductVariantFreezed>(this as ProductVariantFreezed, _$identity);

  /// Serializes this ProductVariantFreezed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductVariantFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.optionValues, optionValues)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,name,const DeepCollectionEquality().hash(optionValues),price,stock,sku,imageUrl,isActive);

@override
String toString() {
  return 'ProductVariantFreezed(id: $id, productId: $productId, name: $name, optionValues: $optionValues, price: $price, stock: $stock, sku: $sku, imageUrl: $imageUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProductVariantFreezedCopyWith<$Res>  {
  factory $ProductVariantFreezedCopyWith(ProductVariantFreezed value, $Res Function(ProductVariantFreezed) _then) = _$ProductVariantFreezedCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId, String name,@JsonKey(name: 'option_values') Map<String, String> optionValues, double price, int stock, String? sku,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$ProductVariantFreezedCopyWithImpl<$Res>
    implements $ProductVariantFreezedCopyWith<$Res> {
  _$ProductVariantFreezedCopyWithImpl(this._self, this._then);

  final ProductVariantFreezed _self;
  final $Res Function(ProductVariantFreezed) _then;

/// Create a copy of ProductVariantFreezed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? name = null,Object? optionValues = null,Object? price = null,Object? stock = null,Object? sku = freezed,Object? imageUrl = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,optionValues: null == optionValues ? _self.optionValues : optionValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductVariantFreezed].
extension ProductVariantFreezedPatterns on ProductVariantFreezed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductVariantFreezed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductVariantFreezed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductVariantFreezed value)  $default,){
final _that = this;
switch (_that) {
case _ProductVariantFreezed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductVariantFreezed value)?  $default,){
final _that = this;
switch (_that) {
case _ProductVariantFreezed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId,  String name, @JsonKey(name: 'option_values')  Map<String, String> optionValues,  double price,  int stock,  String? sku, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductVariantFreezed() when $default != null:
return $default(_that.id,_that.productId,_that.name,_that.optionValues,_that.price,_that.stock,_that.sku,_that.imageUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId,  String name, @JsonKey(name: 'option_values')  Map<String, String> optionValues,  double price,  int stock,  String? sku, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProductVariantFreezed():
return $default(_that.id,_that.productId,_that.name,_that.optionValues,_that.price,_that.stock,_that.sku,_that.imageUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId,  String name, @JsonKey(name: 'option_values')  Map<String, String> optionValues,  double price,  int stock,  String? sku, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProductVariantFreezed() when $default != null:
return $default(_that.id,_that.productId,_that.name,_that.optionValues,_that.price,_that.stock,_that.sku,_that.imageUrl,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductVariantFreezed extends ProductVariantFreezed {
  const _ProductVariantFreezed({required this.id, @JsonKey(name: 'product_id') required this.productId, required this.name, @JsonKey(name: 'option_values') final  Map<String, String> optionValues = const {}, required this.price, this.stock = 0, this.sku, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'is_active') this.isActive = true}): _optionValues = optionValues,super._();
  factory _ProductVariantFreezed.fromJson(Map<String, dynamic> json) => _$ProductVariantFreezedFromJson(json);

@override final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override final  String name;
 final  Map<String, String> _optionValues;
@override@JsonKey(name: 'option_values') Map<String, String> get optionValues {
  if (_optionValues is EqualUnmodifiableMapView) return _optionValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_optionValues);
}

@override final  double price;
@override@JsonKey() final  int stock;
@override final  String? sku;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of ProductVariantFreezed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductVariantFreezedCopyWith<_ProductVariantFreezed> get copyWith => __$ProductVariantFreezedCopyWithImpl<_ProductVariantFreezed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductVariantFreezedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductVariantFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._optionValues, _optionValues)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,name,const DeepCollectionEquality().hash(_optionValues),price,stock,sku,imageUrl,isActive);

@override
String toString() {
  return 'ProductVariantFreezed(id: $id, productId: $productId, name: $name, optionValues: $optionValues, price: $price, stock: $stock, sku: $sku, imageUrl: $imageUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProductVariantFreezedCopyWith<$Res> implements $ProductVariantFreezedCopyWith<$Res> {
  factory _$ProductVariantFreezedCopyWith(_ProductVariantFreezed value, $Res Function(_ProductVariantFreezed) _then) = __$ProductVariantFreezedCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId, String name,@JsonKey(name: 'option_values') Map<String, String> optionValues, double price, int stock, String? sku,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$ProductVariantFreezedCopyWithImpl<$Res>
    implements _$ProductVariantFreezedCopyWith<$Res> {
  __$ProductVariantFreezedCopyWithImpl(this._self, this._then);

  final _ProductVariantFreezed _self;
  final $Res Function(_ProductVariantFreezed) _then;

/// Create a copy of ProductVariantFreezed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? name = null,Object? optionValues = null,Object? price = null,Object? stock = null,Object? sku = freezed,Object? imageUrl = freezed,Object? isActive = null,}) {
  return _then(_ProductVariantFreezed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,optionValues: null == optionValues ? _self._optionValues : optionValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
