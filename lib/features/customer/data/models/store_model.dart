/// نموذج المتجر من قاعدة البيانات
class StoreModel {
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? bannerUrl;
  final String merchantId;
  final bool isActive;
  final double? rating;
  final int? productsCount;
  final DateTime createdAt;

  StoreModel({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    this.bannerUrl,
    required this.merchantId,
    required this.isActive,
    this.rating,
    this.productsCount,
    required this.createdAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      merchantId: json['merchant_id'] as String,
      isActive: json['is_active'] as bool,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      productsCount: json['products_count'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo_url': logoUrl,
      'banner_url': bannerUrl,
      'merchant_id': merchantId,
      'is_active': isActive,
      'rating': rating,
      'products_count': productsCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
