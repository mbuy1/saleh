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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      iconUrl: json['icon_url']?.toString(),
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      productsCount: (json['products_count'] as num?)?.toInt(),
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
