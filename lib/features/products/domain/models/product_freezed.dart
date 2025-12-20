import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_freezed.freezed.dart';
part 'product_freezed.g.dart';

/// ============================================================================
/// Product Media - وسائط المنتج (صور/فيديو)
/// ============================================================================
@freezed
abstract class ProductMediaFreezed with _$ProductMediaFreezed {
  const ProductMediaFreezed._();

  const factory ProductMediaFreezed({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'media_type') @Default('image') String mediaType,
    required String url,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_main') @Default(false) bool isMain,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ProductMediaFreezed;

  factory ProductMediaFreezed.fromJson(Map<String, dynamic> json) =>
      _$ProductMediaFreezedFromJson(json);

  /// هل هذه صورة؟
  bool get isImage => mediaType == 'image';

  /// هل هذا فيديو؟
  bool get isVideo => mediaType == 'video';
}

/// ============================================================================
/// Product - نموذج المنتج
/// ============================================================================
@freezed
abstract class ProductFreezed with _$ProductFreezed {
  const ProductFreezed._();

  const factory ProductFreezed({
    required String id,
    required String name,
    String? description,
    required double price,
    @Default(0) int stock,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'sub_category_id') String? subCategoryId,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default([]) List<ProductMediaFreezed> media,
    @JsonKey(name: 'extra_data') Map<String, dynamic>? extraData,
    double? weight,
    @JsonKey(name: 'preparation_time') int? preparationTime,
    @JsonKey(name: 'seo_keywords') List<String>? seoKeywords,
    // التسعير
    @JsonKey(name: 'cost_price') double? costPrice,
    @JsonKey(name: 'original_price') double? originalPrice,
    @JsonKey(name: 'discount_percentage') double? discountPercentage,
    // المخزون
    @JsonKey(name: 'low_stock_alert') int? lowStockAlert,
    String? sku,
    String? barcode,
    // النوع
    @JsonKey(name: 'product_type') @Default('physical') String productType,
    // الإعدادات
    @JsonKey(name: 'show_in_store') @Default(true) bool showInStore,
    @JsonKey(name: 'show_in_mbuy_app') @Default(true) bool showInMbuyApp,
    @JsonKey(name: 'show_in_dropshipping')
    @Default(false)
    bool showInDropshipping,
  }) = _ProductFreezed;

  factory ProductFreezed.fromJson(Map<String, dynamic> json) =>
      _$ProductFreezedFromJson(json);

  /// الصورة الرئيسية
  String? get mainImageUrl {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl;
    }
    final mainMedia = media.where((m) => m.isMain && m.isImage).firstOrNull;
    if (mainMedia != null) {
      return mainMedia.url;
    }
    return media.where((m) => m.isImage).firstOrNull?.url;
  }

  /// جميع الصور
  List<String> get imageUrls {
    final urls = <String>[];
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      urls.add(imageUrl!);
    }
    for (final m in media.where((m) => m.isImage)) {
      if (!urls.contains(m.url)) {
        urls.add(m.url);
      }
    }
    return urls;
  }

  /// رابط الفيديو
  String? get videoUrl {
    return media.where((m) => m.isVideo).firstOrNull?.url;
  }

  /// هل المنتج منخفض المخزون؟
  bool get isLowStock {
    if (lowStockAlert == null) return false;
    return stock <= lowStockAlert!;
  }

  /// هل المنتج نفذ؟
  bool get isOutOfStock => stock <= 0;

  /// هامش الربح
  double? get profitMargin {
    if (costPrice == null || costPrice == 0) return null;
    return ((price - costPrice!) / costPrice!) * 100;
  }

  /// قيمة الربح
  double? get profitAmount {
    if (costPrice == null) return null;
    return price - costPrice!;
  }

  /// نسبة الخصم الفعلية
  double? get effectiveDiscount {
    if (originalPrice == null || originalPrice! <= price) return null;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }
}

/// ============================================================================
/// Product Category - تصنيف المنتج
/// ============================================================================
@freezed
abstract class ProductCategoryFreezed with _$ProductCategoryFreezed {
  const factory ProductCategoryFreezed({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'products_count') @Default(0) int productsCount,
  }) = _ProductCategoryFreezed;

  factory ProductCategoryFreezed.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFreezedFromJson(json);
}

/// ============================================================================
/// Product Variant - نسخة المنتج
/// ============================================================================
@freezed
abstract class ProductVariantFreezed with _$ProductVariantFreezed {
  const ProductVariantFreezed._();

  const factory ProductVariantFreezed({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    required String name,
    @JsonKey(name: 'option_values')
    @Default({})
    Map<String, String> optionValues,
    required double price,
    @Default(0) int stock,
    String? sku,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ProductVariantFreezed;

  factory ProductVariantFreezed.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFreezedFromJson(json);

  /// وصف الخيارات
  String get optionsDescription {
    return optionValues.values.join(' - ');
  }
}
