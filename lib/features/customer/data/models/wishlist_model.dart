/// نموذج قائمة الأمنيات (Wishlist)
/// مختلف عن Favorites - قائمة أمنيات مستقلة
class WishlistModel {
  final String id;
  final String userId;
  final String productId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Product data (joined)
  final Map<String, dynamic>? product;

  WishlistModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      product: json['product'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      if (product != null) 'product': product,
    };
  }
}

/// عنصر في قائمة الأمنيات مع بيانات المنتج
class WishlistItem {
  final WishlistModel wishlist;
  final Map<String, dynamic> product;

  WishlistItem({
    required this.wishlist,
    required this.product,
  });
}

