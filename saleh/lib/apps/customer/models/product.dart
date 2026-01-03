/// Product Model - نموذج المنتج
///
/// Represents a product in the MBUY platform
library;

class Product {
  final String id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final double price;
  final double? originalPrice;
  final double? discountPercentage;
  final int stock;
  final String? mainImageUrl;
  final List<String> images;
  final String categoryId;
  final String? categoryName;
  final String storeId;
  final String? storeName;
  final String? storeLogo;
  final String status;
  final bool isActive;
  final double? rating;
  final int? reviewCount;
  final int? views;
  final int? salesCount;
  final String? sku;
  final String? barcode;
  final Map<String, dynamic>? attributes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.stock = 0,
    this.mainImageUrl,
    this.images = const [],
    required this.categoryId,
    this.categoryName,
    required this.storeId,
    this.storeName,
    this.storeLogo,
    this.status = 'active',
    this.isActive = true,
    this.rating,
    this.reviewCount,
    this.views,
    this.salesCount,
    this.sku,
    this.barcode,
    this.attributes,
    this.createdAt,
    this.updatedAt,
  });

  /// Create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle nested store data
    final storeData = json['stores'] ?? json['merchants'] ?? {};

    // Handle nested category data
    final categoryData = json['product_categories'] ?? json['categories'] ?? {};

    // Handle images - could be array or string
    List<String> imageList = [];
    if (json['images'] != null) {
      if (json['images'] is List) {
        imageList = (json['images'] as List).map((e) => e.toString()).toList();
      } else if (json['images'] is String) {
        imageList = [json['images']];
      }
    }

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['name_ar'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['original_price']?.toDouble(),
      discountPercentage: json['discount_percentage']?.toDouble(),
      stock: json['stock'] ?? 0,
      mainImageUrl: json['main_image_url'] ?? json['image_url'],
      images: imageList,
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: categoryData['name'] ?? json['category_name'],
      storeId:
          json['store_id']?.toString() ?? json['merchant_id']?.toString() ?? '',
      storeName: storeData['name'] ?? json['store_name'],
      storeLogo: storeData['logo_url'] ?? json['store_logo'],
      status: json['status'] ?? 'active',
      isActive: json['is_active'] ?? true,
      rating: json['rating']?.toDouble(),
      reviewCount: json['review_count'],
      views: json['views'],
      salesCount: json['sales_count'],
      sku: json['sku'],
      barcode: json['barcode'],
      attributes: json['attributes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'price': price,
      'original_price': originalPrice,
      'discount_percentage': discountPercentage,
      'stock': stock,
      'main_image_url': mainImageUrl,
      'images': images,
      'category_id': categoryId,
      'store_id': storeId,
      'status': status,
      'is_active': isActive,
      'rating': rating,
      'review_count': reviewCount,
      'sku': sku,
      'barcode': barcode,
      'attributes': attributes,
    };
  }

  /// Check if product is on sale
  bool get isOnSale =>
      originalPrice != null &&
      originalPrice! > price &&
      discountPercentage != null &&
      discountPercentage! > 0;

  /// Check if product is in stock
  bool get inStock => stock > 0 && isActive && status == 'active';

  /// Get display image
  String? get displayImage =>
      mainImageUrl ?? (images.isNotEmpty ? images.first : null);

  /// Get all images including main
  List<String> get allImages {
    final all = <String>[];
    if (mainImageUrl != null) all.add(mainImageUrl!);
    for (final img in images) {
      if (!all.contains(img)) all.add(img);
    }
    return all;
  }

  /// Alias for mainImageUrl for compatibility
  String get imageUrl =>
      mainImageUrl ??
      (images.isNotEmpty ? images.first : 'https://picsum.photos/200');

  /// Alias for originalPrice for compatibility
  double? get compareAtPrice => originalPrice;

  /// Copy with modifications
  Product copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    double? originalPrice,
    double? discountPercentage,
    int? stock,
    String? mainImageUrl,
    List<String>? images,
    String? categoryId,
    String? categoryName,
    String? storeId,
    String? storeName,
    String? storeLogo,
    String? status,
    bool? isActive,
    double? rating,
    int? reviewCount,
    int? views,
    int? salesCount,
    String? sku,
    String? barcode,
    Map<String, dynamic>? attributes,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      stock: stock ?? this.stock,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      images: images ?? this.images,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      storeLogo: storeLogo ?? this.storeLogo,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      views: views ?? this.views,
      salesCount: salesCount ?? this.salesCount,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      attributes: attributes ?? this.attributes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Product($id: $name - $price SAR)';
}
