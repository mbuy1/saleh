/// Product Media Model
/// يمثل صورة أو فيديو للمنتج
class ProductMedia {
  final String id;
  final String productId;
  final String mediaType; // 'image' or 'video'
  final String url;
  final int sortOrder;
  final bool isMain;
  final DateTime? createdAt;

  ProductMedia({
    required this.id,
    required this.productId,
    required this.mediaType,
    required this.url,
    this.sortOrder = 0,
    this.isMain = false,
    this.createdAt,
  });

  factory ProductMedia.fromJson(Map<String, dynamic> json) {
    return ProductMedia(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      mediaType: json['media_type'] as String? ?? 'image',
      url: json['url'] as String,
      sortOrder: json['sort_order'] as int? ?? 0,
      isMain: json['is_main'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}

/// Product Model
/// يمثل بيانات المنتج في النظام
class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? categoryId;
  final String storeId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ProductMedia> media; // قائمة الصور والفيديوهات

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.categoryId,
    required this.storeId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.media = const [],
  });

  /// الحصول على الصورة الرئيسية
  String? get mainImageUrl {
    // أولاً: تحقق من imageUrl المباشر
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl;
    }
    // ثانياً: ابحث في media عن الصورة الرئيسية
    final mainMedia = media
        .where((m) => m.isMain && m.mediaType == 'image')
        .firstOrNull;
    if (mainMedia != null) {
      return mainMedia.url;
    }
    // ثالثاً: أول صورة في القائمة
    final firstImage = media.where((m) => m.mediaType == 'image').firstOrNull;
    return firstImage?.url;
  }

  /// الحصول على كل الصور
  List<String> get imageUrls {
    final List<String> urls = [];

    // أولاً: أضف الصورة الرئيسية إذا وجدت
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      urls.add(imageUrl!);
    }

    // ثانياً: أضف الصور من media (تجنب التكرار)
    for (final m in media.where((m) => m.mediaType == 'image')) {
      if (!urls.contains(m.url)) {
        urls.add(m.url);
      }
    }

    return urls;
  }

  /// الحصول على الفيديو
  String? get videoUrl {
    final video = media.where((m) => m.mediaType == 'video').firstOrNull;
    return video?.url;
  }

  /// تحويل من JSON إلى Object
  factory Product.fromJson(Map<String, dynamic> json) {
    // قراءة product_media إن وجد
    List<ProductMedia> mediaList = [];
    if (json['product_media'] != null && json['product_media'] is List) {
      mediaList = (json['product_media'] as List)
          .map((m) => ProductMedia.fromJson(m as Map<String, dynamic>))
          .toList();
    }

    // تحديد الصورة الرئيسية: main_image_url أو image_url
    String? mainImage =
        json['main_image_url'] as String? ?? json['image_url'] as String?;

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      imageUrl: mainImage,
      categoryId: json['category_id'] as String?,
      storeId: json['store_id'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      media: mediaList,
    );
  }

  /// تحويل من Object إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'category_id': categoryId,
      'store_id': storeId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// نسخ مع تعديل بعض الحقول
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
    String? categoryId,
    String? storeId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ProductMedia>? media,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      storeId: storeId ?? this.storeId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      media: media ?? this.media,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, stock: $stock)';
  }
}
