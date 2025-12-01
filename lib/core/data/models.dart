/// نماذج البيانات الموحدة لتطبيق mBuy
library;

/// جميع الموديلات المستخدمة في البيانات الوهمية والحقيقية
class Category {
  final String id;
  final String name;
  final String icon;
  final String? parentId;
  final int order;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.parentId,
    this.order = 0,
  });
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String categoryId;
  final String storeId;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final int stockCount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    required this.storeId,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.stockCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'image_url': imageUrl,
    'category_id': categoryId,
    'store_id': storeId,
    'rating': rating,
    'review_count': reviewCount,
  };
}

class Store {
  final String id;
  final String name;
  final String description;
  final String? logoUrl;
  final String? coverUrl;
  final double rating;
  final int followersCount;
  final bool isVerified;
  final bool isBoosted;
  final double? latitude;
  final double? longitude;
  final String? city;

  const Store({
    required this.id,
    required this.name,
    required this.description,
    this.logoUrl,
    this.coverUrl,
    this.rating = 0.0,
    this.followersCount = 0,
    this.isVerified = false,
    this.isBoosted = false,
    this.latitude,
    this.longitude,
    this.city,
  });
}

class VideoItem {
  final String id;
  final String title;
  final String userName;
  final String userAvatar;
  final int likes;
  final int dislikes;
  final int comments;
  final int shares;
  final int bookmarks;
  final String caption;
  final String? productId;
  final double? productPrice;

  const VideoItem({
    required this.id,
    required this.title,
    required this.userName,
    required this.userAvatar,
    this.likes = 0,
    this.dislikes = 0,
    this.comments = 0,
    this.shares = 0,
    this.bookmarks = 0,
    required this.caption,
    this.productId,
    this.productPrice,
  });
}
