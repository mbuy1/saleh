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
  });

  /// تحويل من JSON إلى Object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as String?,
      storeId: json['store_id'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
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
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, stock: $stock)';
  }
}
