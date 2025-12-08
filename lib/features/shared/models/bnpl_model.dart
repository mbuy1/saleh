/// نموذج BNPL (Buy Now Pay Later) - Tabby/Tamara
/// TODO: إكمال التنفيذ عند الحاجة
class BNPLProvider {
  final String id;
  final String name; // 'tabby', 'tamara'
  final String? nameAr;
  final bool isActive;
  final Map<String, dynamic>? config; // API keys, settings

  BNPLProvider({
    required this.id,
    required this.name,
    this.nameAr,
    this.isActive = false,
    this.config,
  });

  factory BNPLProvider.fromJson(Map<String, dynamic> json) {
    return BNPLProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      config: json['config'] as Map<String, dynamic>?,
    );
  }
}

/// نموذج معاملة BNPL
class BNPLTransactionModel {
  final String id;
  final String orderId;
  final String provider; // 'tabby', 'tamara'
  final String status; // 'pending', 'approved', 'rejected', 'completed', 'failed'
  final double totalAmount;
  final int installments; // عدد الأقساط
  final double installmentAmount; // قيمة القسط
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? externalTransactionId; // ID من مقدم الخدمة
  final Map<String, dynamic>? metadata;

  BNPLTransactionModel({
    required this.id,
    required this.orderId,
    required this.provider,
    this.status = 'pending',
    required this.totalAmount,
    required this.installments,
    required this.installmentAmount,
    required this.createdAt,
    this.completedAt,
    this.externalTransactionId,
    this.metadata,
  });

  factory BNPLTransactionModel.fromJson(Map<String, dynamic> json) {
    return BNPLTransactionModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      provider: json['provider'] as String,
      status: json['status'] as String? ?? 'pending',
      totalAmount: (json['total_amount'] as num).toDouble(),
      installments: json['installments'] as int,
      installmentAmount: (json['installment_amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      externalTransactionId: json['external_transaction_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

