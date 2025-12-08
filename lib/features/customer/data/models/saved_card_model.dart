/// نموذج البطاقة المحفوظة (Saved Card)
/// TODO: إكمال التنفيذ عند الحاجة
class SavedCardModel {
  final String id;
  final String userId;
  final String cardType; // 'visa', 'mastercard', 'mada'
  final String lastFourDigits; // آخر 4 أرقام
  final String cardholderName;
  final DateTime expiryDate;
  final bool isDefault;
  final String? provider; // 'stripe', 'tap', etc.
  final String? token; // Token من مقدم الخدمة
  final DateTime createdAt;
  final DateTime? deletedAt;

  SavedCardModel({
    required this.id,
    required this.userId,
    required this.cardType,
    required this.lastFourDigits,
    required this.cardholderName,
    required this.expiryDate,
    this.isDefault = false,
    this.provider,
    this.token,
    required this.createdAt,
    this.deletedAt,
  });

  factory SavedCardModel.fromJson(Map<String, dynamic> json) {
    return SavedCardModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      cardType: json['card_type'] as String,
      lastFourDigits: json['last_four_digits'] as String,
      cardholderName: json['cardholder_name'] as String,
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      isDefault: json['is_default'] as bool? ?? false,
      provider: json['provider'] as String?,
      token: json['token'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'card_type': cardType,
      'last_four_digits': lastFourDigits,
      'cardholder_name': cardholderName,
      'expiry_date': expiryDate.toIso8601String(),
      'is_default': isDefault,
      'provider': provider,
      'token': token,
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// الحصول على اسم البطاقة مع آخر 4 أرقام
  String get displayName => '$cardType •••• $lastFourDigits';
}

