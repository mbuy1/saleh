/// Order Models - نماذج الطلبات
///
/// Represents orders and order items in the MBUY platform

/// Order Status Enum
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  shipping, // alias for shipped
  outForDelivery,
  delivered,
  cancelled,
  refunded,
  failed;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
      case OrderStatus.shipping:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
      case OrderStatus.failed:
        return 'Failed';
    }
  }

  String get displayNameAr {
    switch (this) {
      case OrderStatus.pending:
        return 'قيد الانتظار';
      case OrderStatus.confirmed:
        return 'مؤكد';
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.shipped:
      case OrderStatus.shipping:
        return 'تم الشحن';
      case OrderStatus.outForDelivery:
        return 'في الطريق للتوصيل';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغي';
      case OrderStatus.refunded:
        return 'مسترد';
      case OrderStatus.failed:
        return 'فشل';
    }
  }

  bool get isActive =>
      this != OrderStatus.cancelled &&
      this != OrderStatus.refunded &&
      this != OrderStatus.failed;

  bool get canCancel =>
      this == OrderStatus.pending || this == OrderStatus.confirmed;

  static OrderStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
      case 'shipping':
        return OrderStatus.shipped;
      case 'out_for_delivery':
      case 'outfordelivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      case 'refunded':
        return OrderStatus.refunded;
      case 'failed':
        return OrderStatus.failed;
      default:
        return OrderStatus.pending;
    }
  }
}

/// Payment Status Enum
enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
  partiallyRefunded;

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.partiallyRefunded:
        return 'Partially Refunded';
    }
  }

  static PaymentStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'paid':
        return PaymentStatus.paid;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'partially_refunded':
      case 'partiallyrefunded':
        return PaymentStatus.partiallyRefunded;
      default:
        return PaymentStatus.pending;
    }
  }
}

/// Order Item Model
class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final String? productImageUrl;
  final int quantity;
  final double price;
  final double total;
  final DateTime? createdAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.quantity,
    required this.price,
    required this.total,
    this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      productImageUrl: json['product_image_url'],
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_image_url': productImageUrl,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }

  /// Alias for productImageUrl for compatibility
  String? get imageUrl => productImageUrl;
}

/// Order Model
class Order {
  final String id;
  final String orderNumber;
  final String customerId;
  final String storeId;
  final String? storeName;
  final String? storeLogo;
  final String? storePhone;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String paymentMethod;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double shippingAmount;
  final double totalAmount;
  final ShippingAddress? shippingAddress;
  final String? notes;
  final String? couponCode;
  final List<OrderItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.storeId,
    this.storeName,
    this.storeLogo,
    this.storePhone,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentMethod = 'cash',
    this.subtotal = 0,
    this.discountAmount = 0,
    this.taxAmount = 0,
    this.shippingAmount = 0,
    required this.totalAmount,
    this.shippingAddress,
    this.notes,
    this.couponCode,
    this.items = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Parse store data
    final storeData = json['stores'] ?? {};

    // Parse items
    List<OrderItem> orderItems = [];
    if (json['order_items'] != null && json['order_items'] is List) {
      orderItems = (json['order_items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList();
    }

    // Parse shipping address
    ShippingAddress? address;
    if (json['shipping_address'] != null) {
      if (json['shipping_address'] is Map) {
        address = ShippingAddress.fromJson(json['shipping_address']);
      }
    }

    return Order(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number'] ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      storeName: storeData['name'] ?? json['store_name'],
      storeLogo: storeData['logo_url'] ?? json['store_logo'],
      storePhone: storeData['phone'],
      status: OrderStatus.fromString(json['status']),
      paymentStatus: PaymentStatus.fromString(json['payment_status']),
      paymentMethod: json['payment_method'] ?? 'cash',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      shippingAmount: (json['shipping_amount'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      shippingAddress: address,
      notes: json['notes'],
      couponCode: json['coupon_code'],
      items: orderItems,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'customer_id': customerId,
      'store_id': storeId,
      'status': status.name,
      'payment_status': paymentStatus.name,
      'payment_method': paymentMethod,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'shipping_amount': shippingAmount,
      'total_amount': totalAmount,
      'shipping_address': shippingAddress?.toJson(),
      'notes': notes,
      'coupon_code': couponCode,
    };
  }

  /// Get items count
  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Check if order can be cancelled
  bool get canCancel => status.canCancel;

  /// Copy with modifications
  Order copyWith({
    String? id,
    String? orderNumber,
    String? customerId,
    String? storeId,
    String? storeName,
    String? storeLogo,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    String? paymentMethod,
    double? subtotal,
    double? discountAmount,
    double? taxAmount,
    double? shippingAmount,
    double? totalAmount,
    ShippingAddress? shippingAddress,
    String? notes,
    String? couponCode,
    List<OrderItem>? items,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerId: customerId ?? this.customerId,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      storeLogo: storeLogo ?? this.storeLogo,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      shippingAmount: shippingAmount ?? this.shippingAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      notes: notes ?? this.notes,
      couponCode: couponCode ?? this.couponCode,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Order($orderNumber: $status - $totalAmount SAR)';
}

/// Shipping Address Model
class ShippingAddress {
  final String? id;
  final String name;
  final String phone;
  final String address;
  final String? address2;
  final String city;
  final String? state;
  final String country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  ShippingAddress({
    this.id,
    required this.name,
    required this.phone,
    required this.address,
    this.address2,
    required this.city,
    this.state,
    this.country = 'Saudi Arabia',
    this.postalCode,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id']?.toString(),
      name: json['name'] ?? json['recipient_name'] ?? '',
      phone: json['phone'] ?? json['recipient_phone'] ?? '',
      address: json['address'] ?? json['street'] ?? '',
      address2: json['address2'] ?? json['street2'],
      city: json['city'] ?? '',
      state: json['state'] ?? json['region'],
      country: json['country'] ?? 'Saudi Arabia',
      postalCode: json['postal_code'] ?? json['zip_code'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'address2': address2,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }

  /// Get full address string
  String get fullAddress {
    final parts = <String>[address];
    if (address2 != null && address2!.isNotEmpty) parts.add(address2!);
    parts.add(city);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    parts.add(country);
    if (postalCode != null && postalCode!.isNotEmpty) parts.add(postalCode!);
    return parts.join(', ');
  }

  /// Alias for name as label
  String get label => name;

  ShippingAddress copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? address2,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
