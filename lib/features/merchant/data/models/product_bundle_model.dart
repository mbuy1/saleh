/// نموذج باقة المنتجات (Product Bundle)
/// TODO: إكمال التنفيذ عند الحاجة
class ProductBundleModel {
  final String id;
  final String storeId;
  final String name;
  final String? description;
  final List<BundleItem> items; // المنتجات في الباقة
  final double? bundlePrice; // سعر الباقة (اختياري - يمكن حسابها تلقائياً)
  final double discountPercentage; // نسبة الخصم على الباقة
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductBundleModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.description,
    required this.items,
    this.bundlePrice,
    this.discountPercentage = 0,
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductBundleModel.fromJson(Map<String, dynamic> json) {
    return ProductBundleModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => BundleItem.fromJson(item))
              .toList() ??
          [],
      bundlePrice: json['bundle_price'] != null
          ? (json['bundle_price'] as num).toDouble()
          : null,
      discountPercentage: json['discount_percentage'] != null
          ? (json['discount_percentage'] as num).toDouble()
          : 0,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
      'bundle_price': bundlePrice,
      'discount_percentage': discountPercentage,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// حساب السعر الإجمالي للباقة
  double calculateTotalPrice() {
    double total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  /// حساب السعر بعد الخصم
  double calculateDiscountedPrice() {
    final total = calculateTotalPrice();
    return total - (total * discountPercentage / 100);
  }
}

/// عنصر في الباقة
class BundleItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  BundleItem({
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
  });

  factory BundleItem.fromJson(Map<String, dynamic> json) {
    return BundleItem(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int? ?? 1,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
    };
  }
}

