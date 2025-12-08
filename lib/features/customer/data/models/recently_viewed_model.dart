/// نموذج المنتجات التي تم عرضها مؤخراً
class RecentlyViewedModel {
  final String id;
  final String userId;
  final String productId;
  final DateTime viewedAt;
  final int viewCount;
  
  // Product data (joined)
  final Map<String, dynamic>? product;

  RecentlyViewedModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.viewedAt,
    this.viewCount = 1,
    this.product,
  });

  factory RecentlyViewedModel.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      viewedAt: DateTime.parse(json['viewed_at'] as String),
      viewCount: json['view_count'] as int? ?? 1,
      product: json['product'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'viewed_at': viewedAt.toIso8601String(),
      'view_count': viewCount,
      if (product != null) 'product': product,
    };
  }
}

/// عنصر في قائمة المنتجات المعروضة مؤخراً
class RecentlyViewedItem {
  final RecentlyViewedModel recentlyViewed;
  final Map<String, dynamic> product;

  RecentlyViewedItem({
    required this.recentlyViewed,
    required this.product,
  });
}

