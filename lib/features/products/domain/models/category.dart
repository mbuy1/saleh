/// نموذج التصنيف
/// يمثل تصنيف منتج من قاعدة البيانات
class Category {
  final String id;
  final String name;
  final String? nameAr;
  final String? slug;
  final String? parentId;

  Category({
    required this.id,
    required this.name,
    this.nameAr,
    this.slug,
    this.parentId,
  });

  /// تحويل JSON إلى Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      slug: json['slug'] as String?,
      parentId: json['parent_id'] as String?,
    );
  }

  /// تحويل Category إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (slug != null) 'slug': slug,
      if (parentId != null) 'parent_id': parentId,
    };
  }

  /// الحصول على الاسم المترجم حسب اللغة
  String getLocalizedName(String localeCode) {
    if (localeCode == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name;
  }

  @override
  String toString() => 'Category(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
