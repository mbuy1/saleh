import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_credits.freezed.dart';
part 'user_credits.g.dart';

/// رصيد المستخدم
@freezed
abstract class UserCredits with _$UserCredits {
  const UserCredits._();

  const factory UserCredits({
    required String id,
    required String userId,
    String? storeId,
    @Default(100) int balance,
    @Default(100) int totalEarned,
    @Default(0) int totalSpent,
    DateTime? lastFreeRefill,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserCredits;

  factory UserCredits.fromJson(Map<String, dynamic> json) =>
      _$UserCreditsFromJson(json);

  /// هل يوجد رصيد كافي؟
  bool hasEnoughCredits(int required) => balance >= required;

  /// نسبة الرصيد المستخدم
  double get usagePercentage {
    if (totalEarned == 0) return 0;
    return totalSpent / totalEarned;
  }

  /// هل يستحق إعادة تعبئة مجانية؟
  bool get eligibleForFreeRefill {
    if (lastFreeRefill == null) return true;
    final daysSinceRefill = DateTime.now().difference(lastFreeRefill!).inDays;
    return daysSinceRefill >= 30 && balance < 20;
  }
}

/// سجل استخدام الرصيد
@freezed
abstract class CreditTransaction with _$CreditTransaction {
  const factory CreditTransaction({
    required String id,
    required String userId,
    required int amount,
    required String type, // 'deduct', 'add', 'refill'
    String? description,
    String? projectId,
    required DateTime createdAt,
  }) = _CreditTransaction;

  factory CreditTransaction.fromJson(Map<String, dynamic> json) =>
      _$CreditTransactionFromJson(json);
}

/// باقات الشراء
class CreditPackage {
  final String id;
  final int credits;
  final double price;
  final String currency;
  final int? bonusCredits;
  final bool isPopular;

  const CreditPackage({
    required this.id,
    required this.credits,
    required this.price,
    this.currency = 'SAR',
    this.bonusCredits,
    this.isPopular = false,
  });

  /// الإجمالي مع البونص
  int get totalCredits => credits + (bonusCredits ?? 0);

  /// السعر لكل credit
  double get pricePerCredit => price / totalCredits;
}

/// الباقات المتاحة
List<CreditPackage> getAvailablePackages() {
  return const [
    CreditPackage(id: 'pack_100', credits: 100, price: 19),
    CreditPackage(
      id: 'pack_300',
      credits: 300,
      price: 49,
      bonusCredits: 50,
      isPopular: true,
    ),
    CreditPackage(id: 'pack_500', credits: 500, price: 79, bonusCredits: 100),
    CreditPackage(
      id: 'pack_1000',
      credits: 1000,
      price: 149,
      bonusCredits: 250,
    ),
  ];
}
