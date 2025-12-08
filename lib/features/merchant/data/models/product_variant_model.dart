/// نموذج Variant للمنتج (المقاسات والألوان والخيارات)
class ProductVariantModel {
  final String id;
  final String productId;
  final String variantName; // مثال: "اللون"، "المقاس"
  final String variantValue; // مثال: "أحمر"، "كبير"
  final double? priceModifier; // تغيير السعر (+10, -5, null للاستخدام الافتراضي)
  final int? stockQuantity; // الكمية المتوفرة لهذا Variant
  final String? sku; // SKU خاص بهذا Variant
  final String? imageUrl; // صورة خاصة لهذا Variant
  final bool isActive;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductVariantModel({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.variantValue,
    this.priceModifier,
    this.stockQuantity,
    this.sku,
    this.imageUrl,
    this.isActive = true,
    this.displayOrder = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      variantName: json['variant_name'] as String,
      variantValue: json['variant_value'] as String,
      priceModifier: json['price_modifier'] != null
          ? (json['price_modifier'] as num).toDouble()
          : null,
      stockQuantity: json['stock_quantity'] as int?,
      sku: json['sku'] as String?,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
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
      'variant_name': variantName,
      'variant_value': variantValue,
      'price_modifier': priceModifier,
      'stock_quantity': stockQuantity,
      'sku': sku,
      'image_url': imageUrl,
      'is_active': isActive,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// مجموعة Variants (مثال: مقاس كبير + لون أحمر)
class ProductVariantCombination {
  final String id;
  final String productId;
  final List<ProductVariantModel> variants;
  final double? price;
  final int? stockQuantity;
  final String? sku;
  final String? imageUrl;
  final bool isActive;

  ProductVariantCombination({
    required this.id,
    required this.productId,
    required this.variants,
    this.price,
    this.stockQuantity,
    this.sku,
    this.imageUrl,
    this.isActive = true,
  });
}

/// تعريف Variant Option (مثال: "اللون" مع القيم: "أحمر، أزرق، أخضر")
class VariantOptionDefinition {
  final String id;
  final String productId;
  final String optionName; // "اللون"، "المقاس"
  final List<String> optionValues; // ["أحمر", "أزرق", "أخضر"]
  final bool isRequired;
  final int displayOrder;

  VariantOptionDefinition({
    required this.id,
    required this.productId,
    required this.optionName,
    required this.optionValues,
    this.isRequired = true,
    this.displayOrder = 0,
  });
}

