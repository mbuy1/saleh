/// نموذج الفئة من قاعدة البيانات
class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final int displayOrder;
  final bool isActive;
  final int? productsCount;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    required this.displayOrder,
    required this.isActive,
    this.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      displayOrder: json['display_order'] as int,
      isActive: json['is_active'] as bool,
      productsCount: json['products_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'display_order': displayOrder,
      'is_active': isActive,
      'products_count': productsCount,
    };
  }
}
