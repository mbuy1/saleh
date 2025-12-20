// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_credits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserCredits _$UserCreditsFromJson(Map<String, dynamic> json) => _UserCredits(
  id: json['id'] as String,
  userId: json['userId'] as String,
  storeId: json['storeId'] as String?,
  balance: (json['balance'] as num?)?.toInt() ?? 100,
  totalEarned: (json['totalEarned'] as num?)?.toInt() ?? 100,
  totalSpent: (json['totalSpent'] as num?)?.toInt() ?? 0,
  lastFreeRefill: json['lastFreeRefill'] == null
      ? null
      : DateTime.parse(json['lastFreeRefill'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserCreditsToJson(_UserCredits instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'storeId': instance.storeId,
      'balance': instance.balance,
      'totalEarned': instance.totalEarned,
      'totalSpent': instance.totalSpent,
      'lastFreeRefill': instance.lastFreeRefill?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_CreditTransaction _$CreditTransactionFromJson(Map<String, dynamic> json) =>
    _CreditTransaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toInt(),
      type: json['type'] as String,
      description: json['description'] as String?,
      projectId: json['projectId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CreditTransactionToJson(_CreditTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'type': instance.type,
      'description': instance.description,
      'projectId': instance.projectId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
