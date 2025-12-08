/// نموذج خصائص المنتج (Product Attributes)
/// TODO: إكمال التنفيذ عند الحاجة
class ProductAttributeModel {
  final String id;
  final String productId;
  final String attributeName; // مثال: "المادة"، "الأبعاد"
  final String attributeValue; // مثال: "قطن"، "30x40 سم"
  final String? attributeType; // 'text', 'number', 'boolean', 'color'
  final bool isVisible;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductAttributeModel({
    required this.id,
    required this.productId,
    required this.attributeName,
    required this.attributeValue,
    this.attributeType,
    this.isVisible = true,
    this.displayOrder = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    return ProductAttributeModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      attributeName: json['attribute_name'] as String,
      attributeValue: json['attribute_value'] as String,
      attributeType: json['attribute_type'] as String?,
      isVisible: json['is_visible'] as bool? ?? true,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'attribute_name': attributeName,
      'attribute_value': attributeValue,
      'attribute_type': attributeType,
      'is_visible': isVisible,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// تعريف خصائص المنتج (Attribute Definitions)
class AttributeDefinition {
  final String id;
  final String name;
  final String? nameAr;
  final String type; // 'text', 'number', 'boolean', 'color'
  final List<String>? allowedValues; // للاختيار من قائمة
  final bool isRequired;
  final int displayOrder;

  AttributeDefinition({
    required this.id,
    required this.name,
    this.nameAr,
    this.type = 'text',
    this.allowedValues,
    this.isRequired = false,
    this.displayOrder = 0,
  });
}

