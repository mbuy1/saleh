/// نموذج المنتج من قاعدة البيانات
class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? discountPrice;
  final String? imageUrl;
  final String storeId;
  final String? storeName;
  final String? categoryId;
  final String? categoryName;
  final int stockQuantity;
  final bool isActive;
  final double? rating;
  final int? reviewsCount;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.discountPrice,
    this.imageUrl,
    required this.storeId,
    this.storeName,
    this.categoryId,
    this.categoryName,
    required this.stockQuantity,
    required this.isActive,
    this.rating,
    this.reviewsCount,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] as num).toDouble()
          : null,
      imageUrl: json['image_url']?.toString(),
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString(),
      categoryId: json['category_id']?.toString(),
      categoryName: json['category_name']?.toString(),
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      reviewsCount: (json['reviews_count'] as num?)?.toInt(),
      createdAt: DateTime.parse(
        json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'image_url': imageUrl,
      'store_id': storeId,
      'store_name': storeName,
      'category_id': categoryId,
      'category_name': categoryName,
      'stock_quantity': stockQuantity,
      'is_active': isActive,
      'rating': rating,
      'reviews_count': reviewsCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // حساب نسبة الخصم
  int? get discountPercentage {
    if (discountPrice == null || discountPrice! >= price) return null;
    return (((price - discountPrice!) / price) * 100).round();
  }

  // السعر النهائي
  double get finalPrice => discountPrice ?? price;

  // هل المنتج متوفر؟
  bool get isAvailable => isActive && stockQuantity > 0;
}
