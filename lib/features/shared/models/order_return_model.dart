/// نموذج إرجاع الطلب (Order Return)
/// TODO: إكمال التنفيذ عند الحاجة
class OrderReturnModel {
  final String id;
  final String orderId;
  final String customerId;
  final String storeId;
  final String reason; // سبب الإرجاع
  final String status; // 'pending', 'approved', 'rejected', 'completed'
  final List<ReturnItem> items; // المنتجات المراد إرجاعها
  final double totalRefundAmount;
  final String? notes;
  final DateTime requestedAt;
  final DateTime? processedAt;
  final DateTime? completedAt;

  OrderReturnModel({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.storeId,
    required this.reason,
    this.status = 'pending',
    required this.items,
    required this.totalRefundAmount,
    this.notes,
    required this.requestedAt,
    this.processedAt,
    this.completedAt,
  });

  factory OrderReturnModel.fromJson(Map<String, dynamic> json) {
    return OrderReturnModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      customerId: json['customer_id'] as String,
      storeId: json['store_id'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String? ?? 'pending',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ReturnItem.fromJson(item))
              .toList() ??
          [],
      totalRefundAmount: (json['total_refund_amount'] as num).toDouble(),
      notes: json['notes'] as String?,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      processedAt: json['processed_at'] != null
          ? DateTime.parse(json['processed_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'customer_id': customerId,
      'store_id': storeId,
      'reason': reason,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
      'total_refund_amount': totalRefundAmount,
      'notes': notes,
      'requested_at': requestedAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

/// عنصر في الإرجاع
class ReturnItem {
  final String orderItemId;
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  ReturnItem({
    required this.orderItemId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      orderItemId: json['order_item_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_item_id': orderItemId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}

/// نموذج استرداد الأموال (Refund)
class RefundModel {
  final String id;
  final String returnId;
  final String orderId;
  final double amount;
  final String method; // 'wallet', 'card', 'cash', 'bank_transfer'
  final String status; // 'pending', 'processing', 'completed', 'failed'
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? transactionId;

  RefundModel({
    required this.id,
    required this.returnId,
    required this.orderId,
    required this.amount,
    required this.method,
    this.status = 'pending',
    required this.createdAt,
    this.completedAt,
    this.transactionId,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    return RefundModel(
      id: json['id'] as String,
      returnId: json['return_id'] as String,
      orderId: json['order_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      transactionId: json['transaction_id'] as String?,
    );
  }
}

