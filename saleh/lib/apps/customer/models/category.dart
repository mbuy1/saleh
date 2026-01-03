/// Category Model - نموذج الفئة
///
/// Represents a product category in the MBUY platform
library;

class Category {
  final String id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String? imageUrl;
  final String? iconUrl;
  final String? parentId;
  final int sortOrder;
  final bool isActive;
  final int? productsCount;
  final List<Category> subcategories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.imageUrl,
    this.iconUrl,
    this.parentId,
    this.sortOrder = 0,
    this.isActive = true,
    this.productsCount,
    this.subcategories = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Create Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    List<Category> subs = [];
    if (json['subcategories'] != null && json['subcategories'] is List) {
      subs = (json['subcategories'] as List)
          .map((e) => Category.fromJson(e))
          .toList();
    }

    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      nameAr: json['name_ar'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      imageUrl: json['image_url'],
      iconUrl: json['icon_url'] ?? json['icon'],
      parentId: json['parent_id']?.toString(),
      sortOrder: json['sort_order'] ?? json['order'] ?? 0,
      isActive: json['is_active'] ?? true,
      productsCount: json['products_count'],
      subcategories: subs,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Convert Category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'image_url': imageUrl,
      'icon_url': iconUrl,
      'parent_id': parentId,
      'sort_order': sortOrder,
      'is_active': isActive,
      'products_count': productsCount,
    };
  }

  /// Check if this is a root category
  bool get isRoot => parentId == null;

  /// Check if category has subcategories
  bool get hasSubcategories => subcategories.isNotEmpty;

  /// Get display name (Arabic or English)
  String getDisplayName({bool arabic = false}) {
    if (arabic && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name;
  }

  /// Copy with modifications
  Category copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? imageUrl,
    String? iconUrl,
    String? parentId,
    int? sortOrder,
    bool? isActive,
    int? productsCount,
    List<Category>? subcategories,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      parentId: parentId ?? this.parentId,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      productsCount: productsCount ?? this.productsCount,
      subcategories: subcategories ?? this.subcategories,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Category($id: $name)';
}
