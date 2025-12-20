// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_freezed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductMediaFreezed _$ProductMediaFreezedFromJson(Map<String, dynamic> json) =>
    _ProductMediaFreezed(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      mediaType: json['media_type'] as String? ?? 'image',
      url: json['url'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isMain: json['is_main'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ProductMediaFreezedToJson(
  _ProductMediaFreezed instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'media_type': instance.mediaType,
  'url': instance.url,
  'sort_order': instance.sortOrder,
  'is_main': instance.isMain,
  'created_at': instance.createdAt?.toIso8601String(),
};

_ProductFreezed _$ProductFreezedFromJson(Map<String, dynamic> json) =>
    _ProductFreezed(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as String?,
      subCategoryId: json['sub_category_id'] as String?,
      storeId: json['store_id'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      media:
          (json['media'] as List<dynamic>?)
              ?.map(
                (e) => ProductMediaFreezed.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      extraData: json['extra_data'] as Map<String, dynamic>?,
      weight: (json['weight'] as num?)?.toDouble(),
      preparationTime: (json['preparation_time'] as num?)?.toInt(),
      seoKeywords: (json['seo_keywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      costPrice: (json['cost_price'] as num?)?.toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      lowStockAlert: (json['low_stock_alert'] as num?)?.toInt(),
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      productType: json['product_type'] as String? ?? 'physical',
      showInStore: json['show_in_store'] as bool? ?? true,
      showInMbuyApp: json['show_in_mbuy_app'] as bool? ?? true,
      showInDropshipping: json['show_in_dropshipping'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductFreezedToJson(_ProductFreezed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'stock': instance.stock,
      'image_url': instance.imageUrl,
      'category_id': instance.categoryId,
      'sub_category_id': instance.subCategoryId,
      'store_id': instance.storeId,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'media': instance.media,
      'extra_data': instance.extraData,
      'weight': instance.weight,
      'preparation_time': instance.preparationTime,
      'seo_keywords': instance.seoKeywords,
      'cost_price': instance.costPrice,
      'original_price': instance.originalPrice,
      'discount_percentage': instance.discountPercentage,
      'low_stock_alert': instance.lowStockAlert,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'product_type': instance.productType,
      'show_in_store': instance.showInStore,
      'show_in_mbuy_app': instance.showInMbuyApp,
      'show_in_dropshipping': instance.showInDropshipping,
    };

_ProductCategoryFreezed _$ProductCategoryFreezedFromJson(
  Map<String, dynamic> json,
) => _ProductCategoryFreezed(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  imageUrl: json['image_url'] as String?,
  storeId: json['store_id'] as String,
  parentId: json['parent_id'] as String?,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? true,
  productsCount: (json['products_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProductCategoryFreezedToJson(
  _ProductCategoryFreezed instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'image_url': instance.imageUrl,
  'store_id': instance.storeId,
  'parent_id': instance.parentId,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
  'products_count': instance.productsCount,
};

_ProductVariantFreezed _$ProductVariantFreezedFromJson(
  Map<String, dynamic> json,
) => _ProductVariantFreezed(
  id: json['id'] as String,
  productId: json['product_id'] as String,
  name: json['name'] as String,
  optionValues:
      (json['option_values'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  price: (json['price'] as num).toDouble(),
  stock: (json['stock'] as num?)?.toInt() ?? 0,
  sku: json['sku'] as String?,
  imageUrl: json['image_url'] as String?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$ProductVariantFreezedToJson(
  _ProductVariantFreezed instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'name': instance.name,
  'option_values': instance.optionValues,
  'price': instance.price,
  'stock': instance.stock,
  'sku': instance.sku,
  'image_url': instance.imageUrl,
  'is_active': instance.isActive,
};
