// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_credits.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserCredits {

 String get id; String get userId; String? get storeId; int get balance; int get totalEarned; int get totalSpent; DateTime? get lastFreeRefill; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserCredits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCreditsCopyWith<UserCredits> get copyWith => _$UserCreditsCopyWithImpl<UserCredits>(this as UserCredits, _$identity);

  /// Serializes this UserCredits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserCredits&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.totalEarned, totalEarned) || other.totalEarned == totalEarned)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.lastFreeRefill, lastFreeRefill) || other.lastFreeRefill == lastFreeRefill)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,storeId,balance,totalEarned,totalSpent,lastFreeRefill,createdAt,updatedAt);

@override
String toString() {
  return 'UserCredits(id: $id, userId: $userId, storeId: $storeId, balance: $balance, totalEarned: $totalEarned, totalSpent: $totalSpent, lastFreeRefill: $lastFreeRefill, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserCreditsCopyWith<$Res>  {
  factory $UserCreditsCopyWith(UserCredits value, $Res Function(UserCredits) _then) = _$UserCreditsCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? storeId, int balance, int totalEarned, int totalSpent, DateTime? lastFreeRefill, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserCreditsCopyWithImpl<$Res>
    implements $UserCreditsCopyWith<$Res> {
  _$UserCreditsCopyWithImpl(this._self, this._then);

  final UserCredits _self;
  final $Res Function(UserCredits) _then;

/// Create a copy of UserCredits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? storeId = freezed,Object? balance = null,Object? totalEarned = null,Object? totalSpent = null,Object? lastFreeRefill = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,totalEarned: null == totalEarned ? _self.totalEarned : totalEarned // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as int,lastFreeRefill: freezed == lastFreeRefill ? _self.lastFreeRefill : lastFreeRefill // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserCredits].
extension UserCreditsPatterns on UserCredits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserCredits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserCredits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserCredits value)  $default,){
final _that = this;
switch (_that) {
case _UserCredits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserCredits value)?  $default,){
final _that = this;
switch (_that) {
case _UserCredits() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? storeId,  int balance,  int totalEarned,  int totalSpent,  DateTime? lastFreeRefill,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserCredits() when $default != null:
return $default(_that.id,_that.userId,_that.storeId,_that.balance,_that.totalEarned,_that.totalSpent,_that.lastFreeRefill,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? storeId,  int balance,  int totalEarned,  int totalSpent,  DateTime? lastFreeRefill,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserCredits():
return $default(_that.id,_that.userId,_that.storeId,_that.balance,_that.totalEarned,_that.totalSpent,_that.lastFreeRefill,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? storeId,  int balance,  int totalEarned,  int totalSpent,  DateTime? lastFreeRefill,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserCredits() when $default != null:
return $default(_that.id,_that.userId,_that.storeId,_that.balance,_that.totalEarned,_that.totalSpent,_that.lastFreeRefill,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserCredits extends UserCredits {
  const _UserCredits({required this.id, required this.userId, this.storeId, this.balance = 100, this.totalEarned = 100, this.totalSpent = 0, this.lastFreeRefill, required this.createdAt, required this.updatedAt}): super._();
  factory _UserCredits.fromJson(Map<String, dynamic> json) => _$UserCreditsFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? storeId;
@override@JsonKey() final  int balance;
@override@JsonKey() final  int totalEarned;
@override@JsonKey() final  int totalSpent;
@override final  DateTime? lastFreeRefill;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of UserCredits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCreditsCopyWith<_UserCredits> get copyWith => __$UserCreditsCopyWithImpl<_UserCredits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserCreditsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserCredits&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.totalEarned, totalEarned) || other.totalEarned == totalEarned)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.lastFreeRefill, lastFreeRefill) || other.lastFreeRefill == lastFreeRefill)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,storeId,balance,totalEarned,totalSpent,lastFreeRefill,createdAt,updatedAt);

@override
String toString() {
  return 'UserCredits(id: $id, userId: $userId, storeId: $storeId, balance: $balance, totalEarned: $totalEarned, totalSpent: $totalSpent, lastFreeRefill: $lastFreeRefill, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserCreditsCopyWith<$Res> implements $UserCreditsCopyWith<$Res> {
  factory _$UserCreditsCopyWith(_UserCredits value, $Res Function(_UserCredits) _then) = __$UserCreditsCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? storeId, int balance, int totalEarned, int totalSpent, DateTime? lastFreeRefill, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserCreditsCopyWithImpl<$Res>
    implements _$UserCreditsCopyWith<$Res> {
  __$UserCreditsCopyWithImpl(this._self, this._then);

  final _UserCredits _self;
  final $Res Function(_UserCredits) _then;

/// Create a copy of UserCredits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? storeId = freezed,Object? balance = null,Object? totalEarned = null,Object? totalSpent = null,Object? lastFreeRefill = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserCredits(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,totalEarned: null == totalEarned ? _self.totalEarned : totalEarned // ignore: cast_nullable_to_non_nullable
as int,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as int,lastFreeRefill: freezed == lastFreeRefill ? _self.lastFreeRefill : lastFreeRefill // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CreditTransaction {

 String get id; String get userId; int get amount; String get type;// 'deduct', 'add', 'refill'
 String? get description; String? get projectId; DateTime get createdAt;
/// Create a copy of CreditTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditTransactionCopyWith<CreditTransaction> get copyWith => _$CreditTransactionCopyWithImpl<CreditTransaction>(this as CreditTransaction, _$identity);

  /// Serializes this CreditTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,type,description,projectId,createdAt);

@override
String toString() {
  return 'CreditTransaction(id: $id, userId: $userId, amount: $amount, type: $type, description: $description, projectId: $projectId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CreditTransactionCopyWith<$Res>  {
  factory $CreditTransactionCopyWith(CreditTransaction value, $Res Function(CreditTransaction) _then) = _$CreditTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int amount, String type, String? description, String? projectId, DateTime createdAt
});




}
/// @nodoc
class _$CreditTransactionCopyWithImpl<$Res>
    implements $CreditTransactionCopyWith<$Res> {
  _$CreditTransactionCopyWithImpl(this._self, this._then);

  final CreditTransaction _self;
  final $Res Function(CreditTransaction) _then;

/// Create a copy of CreditTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? amount = null,Object? type = null,Object? description = freezed,Object? projectId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CreditTransaction].
extension CreditTransactionPatterns on CreditTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreditTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreditTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreditTransaction value)  $default,){
final _that = this;
switch (_that) {
case _CreditTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreditTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _CreditTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int amount,  String type,  String? description,  String? projectId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreditTransaction() when $default != null:
return $default(_that.id,_that.userId,_that.amount,_that.type,_that.description,_that.projectId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int amount,  String type,  String? description,  String? projectId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CreditTransaction():
return $default(_that.id,_that.userId,_that.amount,_that.type,_that.description,_that.projectId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int amount,  String type,  String? description,  String? projectId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CreditTransaction() when $default != null:
return $default(_that.id,_that.userId,_that.amount,_that.type,_that.description,_that.projectId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreditTransaction implements CreditTransaction {
  const _CreditTransaction({required this.id, required this.userId, required this.amount, required this.type, this.description, this.projectId, required this.createdAt});
  factory _CreditTransaction.fromJson(Map<String, dynamic> json) => _$CreditTransactionFromJson(json);

@override final  String id;
@override final  String userId;
@override final  int amount;
@override final  String type;
// 'deduct', 'add', 'refill'
@override final  String? description;
@override final  String? projectId;
@override final  DateTime createdAt;

/// Create a copy of CreditTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreditTransactionCopyWith<_CreditTransaction> get copyWith => __$CreditTransactionCopyWithImpl<_CreditTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreditTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreditTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,type,description,projectId,createdAt);

@override
String toString() {
  return 'CreditTransaction(id: $id, userId: $userId, amount: $amount, type: $type, description: $description, projectId: $projectId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CreditTransactionCopyWith<$Res> implements $CreditTransactionCopyWith<$Res> {
  factory _$CreditTransactionCopyWith(_CreditTransaction value, $Res Function(_CreditTransaction) _then) = __$CreditTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int amount, String type, String? description, String? projectId, DateTime createdAt
});




}
/// @nodoc
class __$CreditTransactionCopyWithImpl<$Res>
    implements _$CreditTransactionCopyWith<$Res> {
  __$CreditTransactionCopyWithImpl(this._self, this._then);

  final _CreditTransaction _self;
  final $Res Function(_CreditTransaction) _then;

/// Create a copy of CreditTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? amount = null,Object? type = null,Object? description = freezed,Object? projectId = freezed,Object? createdAt = null,}) {
  return _then(_CreditTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
