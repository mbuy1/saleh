import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// أنواع المنتجات المتاحة
enum ProductType {
  physical, // منتج مادي عادي
  digital, // منتج رقمي
  service, // خدمة حسب الطلب
  foodAndBeverage, // أكل ومشروبات
  subscription, // اشتراك
  ticket, // تذكرة/حجز
  customizable, // منتج قابل للتخصيص
}

/// معلومات نوع المنتج
class ProductTypeInfo {
  final ProductType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> specificFields;
  final bool hasStock;
  final bool hasWeight;
  final bool hasDelivery;
  final bool hasPrepTime;
  final bool hasDigitalFile;
  final bool hasVariants;

  const ProductTypeInfo({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.specificFields,
    this.hasStock = true,
    this.hasWeight = false,
    this.hasDelivery = true,
    this.hasPrepTime = false,
    this.hasDigitalFile = false,
    this.hasVariants = false,
  });
}

/// تعريفات أنواع المنتجات
const Map<ProductType, ProductTypeInfo> productTypes = {
  ProductType.physical: ProductTypeInfo(
    type: ProductType.physical,
    name: 'منتج مادي',
    description: 'منتج يتم شحنه للعميل',
    icon: Icons.inventory_2,
    color: Color(0xFF2196F3),
    specificFields: ['weight', 'dimensions', 'shipping'],
    hasStock: true,
    hasWeight: true,
    hasDelivery: true,
    hasVariants: true,
  ),
  ProductType.digital: ProductTypeInfo(
    type: ProductType.digital,
    name: 'منتج رقمي',
    description: 'ملفات، برامج، كتب إلكترونية',
    icon: Icons.cloud_download,
    color: Color(0xFF9C27B0),
    specificFields: ['file_url', 'file_type', 'download_limit'],
    hasStock: false,
    hasWeight: false,
    hasDelivery: false,
    hasDigitalFile: true,
  ),
  ProductType.service: ProductTypeInfo(
    type: ProductType.service,
    name: 'خدمة حسب الطلب',
    description: 'خدمات مثل التصميم، البرمجة، الاستشارات',
    icon: Icons.handyman,
    color: Color(0xFF4CAF50),
    specificFields: ['duration', 'delivery_time', 'revisions'],
    hasStock: false,
    hasWeight: false,
    hasDelivery: false,
    hasPrepTime: true,
  ),
  ProductType.foodAndBeverage: ProductTypeInfo(
    type: ProductType.foodAndBeverage,
    name: 'أكل ومشروبات',
    description: 'وجبات، حلويات، مشروبات',
    icon: Icons.restaurant,
    color: Color(0xFFFF9800),
    specificFields: ['prep_time', 'calories', 'ingredients', 'allergens'],
    hasStock: true,
    hasWeight: true,
    hasDelivery: true,
    hasPrepTime: true,
    hasVariants: true,
  ),
  ProductType.subscription: ProductTypeInfo(
    type: ProductType.subscription,
    name: 'اشتراك',
    description: 'اشتراكات شهرية أو سنوية',
    icon: Icons.autorenew,
    color: Color(0xFF00BCD4),
    specificFields: ['billing_cycle', 'trial_days', 'features'],
    hasStock: false,
    hasWeight: false,
    hasDelivery: false,
  ),
  ProductType.ticket: ProductTypeInfo(
    type: ProductType.ticket,
    name: 'تذكرة / حجز',
    description: 'فعاليات، حجوزات، مواعيد',
    icon: Icons.confirmation_number,
    color: Color(0xFFE91E63),
    specificFields: ['event_date', 'location', 'seats', 'time_slots'],
    hasStock: true,
    hasWeight: false,
    hasDelivery: false,
  ),
  ProductType.customizable: ProductTypeInfo(
    type: ProductType.customizable,
    name: 'منتج قابل للتخصيص',
    description: 'منتجات يمكن للعميل تخصيصها',
    icon: Icons.tune,
    color: Color(0xFF795548),
    specificFields: ['customization_options', 'preview_enabled'],
    hasStock: true,
    hasWeight: true,
    hasDelivery: true,
    hasPrepTime: true,
    hasVariants: true,
  ),
};

/// حالة نموذج إضافة المنتج
class ProductFormState {
  // Basic Info
  final String name;
  final String description;
  final double? price;
  final double? costPrice;
  final double? originalPrice;
  final int? stock;
  final int? lowStockAlert;
  final String? sku;
  final String? barcode;
  final String? slug;
  final String? brand;

  // Categories
  final String? categoryId;
  final String? mbuyCategoryId;
  final String? wholesaleCategoryId;
  final String? subCategory;

  // Media
  final List<XFile> images;
  final XFile? video;
  final List<String> mediaUrls;
  final int mainImageIndex;

  // Product Type
  final ProductType productType;

  // Digital Product
  final String? fileUrl;
  final String? fileType;
  final int? downloadLimit;

  // Service
  final String? serviceDuration;
  final String? deliveryTime;
  final int? revisions;

  // Food
  final int? calories;
  final String? ingredients;
  final List<String> allergens;

  // Subscription
  final String billingCycle;
  final int? trialDays;
  final List<String> subscriptionFeatures;

  // Ticket
  final DateTime? eventDate;
  final TimeOfDay? eventTime;
  final String? location;
  final int? seats;

  // Customizable
  final List<Map<String, dynamic>> customizationOptions;
  final bool previewEnabled;

  // Display Channels
  final bool showInStore;
  final bool showInMbuyApp;
  final bool showInDropshipping;

  // SEO
  final List<String> keywords;
  final double? wholesalePrice;
  final int? slaDays;

  // State
  final bool hasUnsavedChanges;
  final bool isDraft;
  final bool isSubmitting;

  const ProductFormState({
    this.name = '',
    this.description = '',
    this.price,
    this.costPrice,
    this.originalPrice,
    this.stock,
    this.lowStockAlert,
    this.sku,
    this.barcode,
    this.slug,
    this.brand,
    this.categoryId,
    this.mbuyCategoryId,
    this.wholesaleCategoryId,
    this.subCategory,
    this.images = const [],
    this.video,
    this.mediaUrls = const [],
    this.mainImageIndex = 0,
    this.productType = ProductType.physical,
    this.fileUrl,
    this.fileType = 'pdf',
    this.downloadLimit,
    this.serviceDuration,
    this.deliveryTime,
    this.revisions,
    this.calories,
    this.ingredients,
    this.allergens = const [],
    this.billingCycle = 'monthly',
    this.trialDays,
    this.subscriptionFeatures = const [],
    this.eventDate,
    this.eventTime,
    this.location,
    this.seats,
    this.customizationOptions = const [],
    this.previewEnabled = false,
    this.showInStore = true,
    this.showInMbuyApp = true,
    this.showInDropshipping = false,
    this.keywords = const [],
    this.wholesalePrice,
    this.slaDays,
    this.hasUnsavedChanges = false,
    this.isDraft = false,
    this.isSubmitting = false,
  });

  ProductFormState copyWith({
    String? name,
    String? description,
    double? price,
    double? costPrice,
    double? originalPrice,
    int? stock,
    int? lowStockAlert,
    String? sku,
    String? barcode,
    String? slug,
    String? brand,
    String? categoryId,
    String? mbuyCategoryId,
    String? wholesaleCategoryId,
    String? subCategory,
    List<XFile>? images,
    XFile? video,
    List<String>? mediaUrls,
    int? mainImageIndex,
    ProductType? productType,
    String? fileUrl,
    String? fileType,
    int? downloadLimit,
    String? serviceDuration,
    String? deliveryTime,
    int? revisions,
    int? calories,
    String? ingredients,
    List<String>? allergens,
    String? billingCycle,
    int? trialDays,
    List<String>? subscriptionFeatures,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String? location,
    int? seats,
    List<Map<String, dynamic>>? customizationOptions,
    bool? previewEnabled,
    bool? showInStore,
    bool? showInMbuyApp,
    bool? showInDropshipping,
    List<String>? keywords,
    double? wholesalePrice,
    int? slaDays,
    bool? hasUnsavedChanges,
    bool? isDraft,
    bool? isSubmitting,
  }) {
    return ProductFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      stock: stock ?? this.stock,
      lowStockAlert: lowStockAlert ?? this.lowStockAlert,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      slug: slug ?? this.slug,
      brand: brand ?? this.brand,
      categoryId: categoryId ?? this.categoryId,
      mbuyCategoryId: mbuyCategoryId ?? this.mbuyCategoryId,
      wholesaleCategoryId: wholesaleCategoryId ?? this.wholesaleCategoryId,
      subCategory: subCategory ?? this.subCategory,
      images: images ?? this.images,
      video: video ?? this.video,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mainImageIndex: mainImageIndex ?? this.mainImageIndex,
      productType: productType ?? this.productType,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      downloadLimit: downloadLimit ?? this.downloadLimit,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      revisions: revisions ?? this.revisions,
      calories: calories ?? this.calories,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      billingCycle: billingCycle ?? this.billingCycle,
      trialDays: trialDays ?? this.trialDays,
      subscriptionFeatures: subscriptionFeatures ?? this.subscriptionFeatures,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      location: location ?? this.location,
      seats: seats ?? this.seats,
      customizationOptions: customizationOptions ?? this.customizationOptions,
      previewEnabled: previewEnabled ?? this.previewEnabled,
      showInStore: showInStore ?? this.showInStore,
      showInMbuyApp: showInMbuyApp ?? this.showInMbuyApp,
      showInDropshipping: showInDropshipping ?? this.showInDropshipping,
      keywords: keywords ?? this.keywords,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      slaDays: slaDays ?? this.slaDays,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      isDraft: isDraft ?? this.isDraft,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  /// الحصول على معلومات نوع المنتج الحالي
  ProductTypeInfo get currentTypeInfo => productTypes[productType]!;

  /// حساب نسبة اكتمال النموذج
  double get completionPercentage {
    int completedFields = 0;
    int totalFields = 6;

    if (name.isNotEmpty) completedFields++;
    if (price != null) completedFields++;
    if (categoryId != null) completedFields++;
    if (images.isNotEmpty || mediaUrls.isNotEmpty) completedFields++;
    if (description.isNotEmpty) completedFields++;

    if (currentTypeInfo.hasStock) {
      totalFields++;
      if (stock != null) completedFields++;
    }

    return completedFields / totalFields;
  }

  /// حساب هامش الربح
  double? get profitMargin {
    if (price != null && costPrice != null && costPrice! > 0) {
      return ((price! - costPrice!) / costPrice!) * 100;
    }
    return null;
  }

  /// حساب قيمة الربح
  double? get profitAmount {
    if (price != null && costPrice != null) {
      return price! - costPrice!;
    }
    return null;
  }

  /// حساب نسبة الخصم
  double? get discountPercentage {
    if (originalPrice != null &&
        price != null &&
        originalPrice! > 0 &&
        originalPrice! > price!) {
      return ((originalPrice! - price!) / originalPrice!) * 100;
    }
    return null;
  }
}
