import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/product_form_state.dart';
import '../../../../domain/models/category.dart';
import '../../../../data/categories_repository.dart';
import '../../../../data/products_repository.dart';

/// متحكم نموذج إضافة المنتج
class ProductFormController extends StateNotifier<ProductFormState> {
  final Ref ref;
  final ImagePicker _picker = ImagePicker();

  List<Category> categories = [];
  bool loadingCategories = false;

  ProductFormController(
    this.ref, {
    ProductType? initialType,
    String? initialName,
    double? initialPrice,
  }) : super(
         ProductFormState(
           productType: initialType ?? ProductType.physical,
           name: initialName ?? '',
           price: initialPrice,
         ),
       ) {
    _loadCategories();
  }

  // ============================================
  // التصنيفات
  // ============================================

  Future<void> _loadCategories() async {
    loadingCategories = true;
    try {
      final categoriesRepo = ref.read(categoriesRepositoryProvider);
      categories = await categoriesRepo.getCategories();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      loadingCategories = false;
    }
  }

  void setCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId, hasUnsavedChanges: true);
  }

  void setMbuyCategory(String? categoryId) {
    state = state.copyWith(mbuyCategoryId: categoryId, hasUnsavedChanges: true);
  }

  void setWholesaleCategory(String? categoryId) {
    state = state.copyWith(
      wholesaleCategoryId: categoryId,
      hasUnsavedChanges: true,
    );
  }

  void setSubCategory(String? subCategory) {
    state = state.copyWith(subCategory: subCategory, hasUnsavedChanges: true);
  }

  // ============================================
  // المعلومات الأساسية
  // ============================================

  void setName(String name) {
    final slug = _generateSlug(name);
    state = state.copyWith(name: name, slug: slug, hasUnsavedChanges: true);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description, hasUnsavedChanges: true);
  }

  void setPrice(double? price) {
    state = state.copyWith(price: price, hasUnsavedChanges: true);
  }

  void setCostPrice(double? costPrice) {
    state = state.copyWith(costPrice: costPrice, hasUnsavedChanges: true);
  }

  void setOriginalPrice(double? originalPrice) {
    state = state.copyWith(
      originalPrice: originalPrice,
      hasUnsavedChanges: true,
    );
  }

  void setStock(int? stock) {
    state = state.copyWith(stock: stock, hasUnsavedChanges: true);
  }

  void setLowStockAlert(int? alert) {
    state = state.copyWith(lowStockAlert: alert, hasUnsavedChanges: true);
  }

  void setSku(String? sku) {
    state = state.copyWith(sku: sku, hasUnsavedChanges: true);
  }

  void setBarcode(String? barcode) {
    state = state.copyWith(barcode: barcode, hasUnsavedChanges: true);
  }

  void setSlug(String? slug) {
    state = state.copyWith(slug: slug, hasUnsavedChanges: true);
  }

  void setBrand(String? brand) {
    state = state.copyWith(brand: brand, hasUnsavedChanges: true);
  }

  void setProductType(ProductType type) {
    state = state.copyWith(productType: type, hasUnsavedChanges: true);
  }

  // ============================================
  // الوسائط
  // ============================================

  Future<void> pickImages() async {
    if (state.images.length >= 4) return;

    try {
      final images = await _picker.pickMultiImage();
      final remaining = 4 - state.images.length;
      final newImages = [...state.images, ...images.take(remaining)];
      state = state.copyWith(images: newImages, hasUnsavedChanges: true);
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  Future<bool> pickVideo() async {
    if (state.video != null) return false;

    try {
      final video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        final videoFile = File(video.path);
        final videoSize = await videoFile.length();
        final videoSizeMB = videoSize / (1024 * 1024);

        if (videoSizeMB > 100) {
          return false;
        }

        state = state.copyWith(video: video, hasUnsavedChanges: true);
        return true;
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    }
    return false;
  }

  void removeImage(int index) {
    final newImages = [...state.images]..removeAt(index);
    int newMainIndex = state.mainImageIndex;

    if (newMainIndex >= newImages.length) {
      newMainIndex = newImages.isEmpty ? 0 : newImages.length - 1;
    } else if (index < newMainIndex) {
      newMainIndex--;
    } else if (index == newMainIndex && newImages.isNotEmpty) {
      newMainIndex = 0;
    }

    state = state.copyWith(
      images: newImages,
      mainImageIndex: newMainIndex,
      hasUnsavedChanges: true,
    );
  }

  void setMainImage(int index) {
    state = state.copyWith(mainImageIndex: index, hasUnsavedChanges: true);
  }

  void removeVideo() {
    state = state.copyWith(video: null, hasUnsavedChanges: true);
  }

  void addMediaUrl(String url) {
    if (url.isNotEmpty) {
      final newUrls = [...state.mediaUrls, url];
      state = state.copyWith(mediaUrls: newUrls, hasUnsavedChanges: true);
    }
  }

  void removeMediaUrl(int index) {
    final newUrls = [...state.mediaUrls]..removeAt(index);
    state = state.copyWith(mediaUrls: newUrls, hasUnsavedChanges: true);
  }

  // ============================================
  // قنوات العرض
  // ============================================

  void setShowInStore(bool value) {
    state = state.copyWith(showInStore: value, hasUnsavedChanges: true);
  }

  void setShowInMbuyApp(bool value) {
    state = state.copyWith(showInMbuyApp: value, hasUnsavedChanges: true);
  }

  void setShowInDropshipping(bool value) {
    state = state.copyWith(showInDropshipping: value, hasUnsavedChanges: true);
  }

  // ============================================
  // المنتج الرقمي
  // ============================================

  void setFileUrl(String? url) {
    state = state.copyWith(fileUrl: url, hasUnsavedChanges: true);
  }

  void setFileType(String? type) {
    state = state.copyWith(fileType: type, hasUnsavedChanges: true);
  }

  void setDownloadLimit(int? limit) {
    state = state.copyWith(downloadLimit: limit, hasUnsavedChanges: true);
  }

  // ============================================
  // الخدمات
  // ============================================

  void setServiceDuration(String? duration) {
    state = state.copyWith(serviceDuration: duration, hasUnsavedChanges: true);
  }

  void setDeliveryTime(String? time) {
    state = state.copyWith(deliveryTime: time, hasUnsavedChanges: true);
  }

  void setRevisions(int? revisions) {
    state = state.copyWith(revisions: revisions, hasUnsavedChanges: true);
  }

  // ============================================
  // الأكل والمشروبات
  // ============================================

  void setCalories(int? calories) {
    state = state.copyWith(calories: calories, hasUnsavedChanges: true);
  }

  void setIngredients(String? ingredients) {
    state = state.copyWith(ingredients: ingredients, hasUnsavedChanges: true);
  }

  void addAllergen(String allergen) {
    if (!state.allergens.contains(allergen)) {
      final newAllergens = [...state.allergens, allergen];
      state = state.copyWith(allergens: newAllergens, hasUnsavedChanges: true);
    }
  }

  void removeAllergen(String allergen) {
    final newAllergens = state.allergens.where((a) => a != allergen).toList();
    state = state.copyWith(allergens: newAllergens, hasUnsavedChanges: true);
  }

  // ============================================
  // الاشتراكات
  // ============================================

  void setBillingCycle(String cycle) {
    state = state.copyWith(billingCycle: cycle, hasUnsavedChanges: true);
  }

  void setTrialDays(int? days) {
    state = state.copyWith(trialDays: days, hasUnsavedChanges: true);
  }

  void addSubscriptionFeature(String feature) {
    if (feature.isNotEmpty && !state.subscriptionFeatures.contains(feature)) {
      final newFeatures = [...state.subscriptionFeatures, feature];
      state = state.copyWith(
        subscriptionFeatures: newFeatures,
        hasUnsavedChanges: true,
      );
    }
  }

  void removeSubscriptionFeature(String feature) {
    final newFeatures = state.subscriptionFeatures
        .where((f) => f != feature)
        .toList();
    state = state.copyWith(
      subscriptionFeatures: newFeatures,
      hasUnsavedChanges: true,
    );
  }

  // ============================================
  // التذاكر والحجوزات
  // ============================================

  void setEventDate(DateTime? date) {
    state = state.copyWith(eventDate: date, hasUnsavedChanges: true);
  }

  void setEventTime(TimeOfDay? time) {
    state = state.copyWith(eventTime: time, hasUnsavedChanges: true);
  }

  void setLocation(String? location) {
    state = state.copyWith(location: location, hasUnsavedChanges: true);
  }

  void setSeats(int? seats) {
    state = state.copyWith(seats: seats, hasUnsavedChanges: true);
  }

  // ============================================
  // المنتجات القابلة للتخصيص
  // ============================================

  void addCustomizationOption(Map<String, dynamic> option) {
    final newOptions = [...state.customizationOptions, option];
    state = state.copyWith(
      customizationOptions: newOptions,
      hasUnsavedChanges: true,
    );
  }

  void removeCustomizationOption(int index) {
    final newOptions = [...state.customizationOptions]..removeAt(index);
    state = state.copyWith(
      customizationOptions: newOptions,
      hasUnsavedChanges: true,
    );
  }

  void setPreviewEnabled(bool enabled) {
    state = state.copyWith(previewEnabled: enabled, hasUnsavedChanges: true);
  }

  // ============================================
  // الكلمات المفتاحية
  // ============================================

  void addKeyword(String keyword) {
    if (keyword.isNotEmpty && !state.keywords.contains(keyword)) {
      final newKeywords = [...state.keywords, keyword];
      state = state.copyWith(keywords: newKeywords, hasUnsavedChanges: true);
    }
  }

  void removeKeyword(String keyword) {
    final newKeywords = state.keywords.where((k) => k != keyword).toList();
    state = state.copyWith(keywords: newKeywords, hasUnsavedChanges: true);
  }

  void setWholesalePrice(double? price) {
    state = state.copyWith(wholesalePrice: price, hasUnsavedChanges: true);
  }

  void setSlaDays(int? days) {
    state = state.copyWith(slaDays: days, hasUnsavedChanges: true);
  }

  // ============================================
  // الحفظ والإرسال
  // ============================================

  Future<void> saveAsDraft() async {
    state = state.copyWith(isDraft: true, hasUnsavedChanges: false);
    // TODO: حفظ محلياً
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    state = state.copyWith(isSubmitting: true);

    try {
      final productsRepo = ref.read(productsRepositoryProvider);

      // رفع الصور أولاً
      List<String> imageUrls = [];
      for (final image in state.images) {
        // TODO: رفع الصورة والحصول على URL
        imageUrls.add(image.path); // مؤقتاً
      }

      final mainImageUrl = imageUrls.isNotEmpty
          ? imageUrls[state.mainImageIndex]
          : null;

      await productsRepo.createProduct(
        name: state.name,
        price: state.price ?? 0,
        stock: state.stock ?? 0,
        description: state.description,
        imageUrl: mainImageUrl,
        categoryId: state.categoryId,
        extraData: _buildExtraData(),
      );

      state = state.copyWith(isSubmitting: false, hasUnsavedChanges: false);
      return true;
    } catch (e) {
      debugPrint('Error submitting product: $e');
      state = state.copyWith(isSubmitting: false);
      return false;
    }
  }

  Map<String, dynamic> _buildExtraData() {
    final data = <String, dynamic>{
      'cost_price': state.costPrice,
      'original_price': state.originalPrice,
      'low_stock_alert': state.lowStockAlert,
      'sku': state.sku ?? generateSku(),
      'barcode': state.barcode,
      'slug': state.slug,
      'brand': state.brand,
      'category_id': state.categoryId,
      'mbuy_category_id': state.mbuyCategoryId,
      'wholesale_category_id': state.wholesaleCategoryId,
      'sub_category': state.subCategory,
      'product_type': state.productType.name,
      'show_in_store': state.showInStore,
      'show_in_mbuy_app': state.showInMbuyApp,
      'show_in_dropshipping': state.showInDropshipping,
      'keywords': state.keywords,
      'wholesale_price': state.wholesalePrice,
      'sla_days': state.slaDays,
    };

    // إضافة الحقول الخاصة حسب نوع المنتج
    switch (state.productType) {
      case ProductType.digital:
        data.addAll({
          'file_url': state.fileUrl,
          'file_type': state.fileType,
          'download_limit': state.downloadLimit,
        });
        break;
      case ProductType.service:
        data.addAll({
          'service_duration': state.serviceDuration,
          'delivery_time': state.deliveryTime,
          'revisions': state.revisions,
        });
        break;
      case ProductType.foodAndBeverage:
        data.addAll({
          'calories': state.calories,
          'ingredients': state.ingredients,
          'allergens': state.allergens,
        });
        break;
      case ProductType.subscription:
        data.addAll({
          'billing_cycle': state.billingCycle,
          'trial_days': state.trialDays,
          'subscription_features': state.subscriptionFeatures,
        });
        break;
      case ProductType.ticket:
        data.addAll({
          'event_date': state.eventDate?.toIso8601String(),
          'event_time': state.eventTime != null
              ? '${state.eventTime!.hour}:${state.eventTime!.minute}'
              : null,
          'location': state.location,
          'seats': state.seats,
        });
        break;
      case ProductType.customizable:
        data.addAll({
          'customization_options': state.customizationOptions,
          'preview_enabled': state.previewEnabled,
        });
        break;
      case ProductType.physical:
        // لا حقول إضافية
        break;
    }

    return data;
  }

  bool validate() {
    if (state.name.isEmpty) return false;
    if (state.price == null || state.price! <= 0) return false;
    if (state.categoryId == null) return false;

    // التحقق من الحقول الخاصة بنوع المنتج
    switch (state.productType) {
      case ProductType.digital:
        if (state.fileUrl == null || state.fileUrl!.isEmpty) return false;
        break;
      case ProductType.ticket:
        if (state.eventDate == null) return false;
        break;
      default:
        break;
    }

    return true;
  }

  void reset() {
    state = const ProductFormState();
  }

  // ============================================
  // المساعدات
  // ============================================

  String generateSku() {
    final random = Random();
    final prefix = state.categoryId?.substring(0, 3).toUpperCase() ?? 'PRD';
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(8);
    final randomNum = random.nextInt(999).toString().padLeft(3, '0');
    return '$prefix-$timestamp-$randomNum';
  }

  String _generateSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
  }
}

/// Provider للمتحكم
final productFormControllerProvider = StateNotifierProvider.autoDispose
    .family<ProductFormController, ProductFormState, ProductFormParams>((
      ref,
      params,
    ) {
      return ProductFormController(
        ref,
        initialType: params.initialType,
        initialName: params.initialName,
        initialPrice: params.initialPrice,
      );
    });

/// معاملات إنشاء المتحكم
class ProductFormParams {
  final ProductType? initialType;
  final String? initialName;
  final double? initialPrice;

  const ProductFormParams({
    this.initialType,
    this.initialName,
    this.initialPrice,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductFormParams &&
          runtimeType == other.runtimeType &&
          initialType == other.initialType &&
          initialName == other.initialName &&
          initialPrice == other.initialPrice;

  @override
  int get hashCode => Object.hash(initialType, initialName, initialPrice);
}
