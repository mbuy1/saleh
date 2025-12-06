import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service.dart';
import '../models/product_variant_model.dart';
import '../../../auth/data/auth_repository.dart';

/// خدمة إدارة Product Variants (المقاسات والألوان والخيارات)
class ProductVariantService {
  /// جلب جميع Variants لمنتج محدد
  static Future<List<ProductVariantModel>> getProductVariants(String productId) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    try {
      final result = await ApiService.get('/secure/merchant/products/$productId/variants');
      
      if (result['ok'] == true && result['data'] != null) {
        final List<dynamic> variants = result['data'];
        return variants.map((v) => ProductVariantModel.fromJson(v)).toList();
      }
      
      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب Variants: $e');
      return [];
    }
  }

  /// إضافة Variant جديد لمنتج
  static Future<ProductVariantModel> addVariant({
    required String productId,
    required String variantName,
    required String variantValue,
    double? priceModifier,
    int? stockQuantity,
    String? sku,
    String? imageUrl,
  }) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    final result = await ApiService.post(
      '/secure/merchant/products/$productId/variants',
      data: {
        'variant_name': variantName,
        'variant_value': variantValue,
        if (priceModifier != null) 'price_modifier': priceModifier,
        if (stockQuantity != null) 'stock_quantity': stockQuantity,
        if (sku != null && sku.isNotEmpty) 'sku': sku,
        if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
      },
    );

    if (result['ok'] == true && result['data'] != null) {
      return ProductVariantModel.fromJson(result['data']);
    }

    throw Exception(result['error'] ?? 'فشل إضافة Variant');
  }

  /// تحديث Variant موجود
  static Future<ProductVariantModel> updateVariant({
    required String variantId,
    String? variantName,
    String? variantValue,
    double? priceModifier,
    int? stockQuantity,
    String? sku,
    String? imageUrl,
    bool? isActive,
  }) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    final updateData = <String, dynamic>{};
    if (variantName != null) updateData['variant_name'] = variantName;
    if (variantValue != null) updateData['variant_value'] = variantValue;
    if (priceModifier != null) updateData['price_modifier'] = priceModifier;
    if (stockQuantity != null) updateData['stock_quantity'] = stockQuantity;
    if (sku != null) updateData['sku'] = sku;
    if (imageUrl != null) updateData['image_url'] = imageUrl;
    if (isActive != null) updateData['is_active'] = isActive;

    final result = await ApiService.put(
      '/secure/merchant/products/variants/$variantId',
      data: updateData,
    );

    if (result['ok'] == true && result['data'] != null) {
      return ProductVariantModel.fromJson(result['data']);
    }

    throw Exception(result['error'] ?? 'فشل تحديث Variant');
  }

  /// حذف Variant
  static Future<void> deleteVariant(String variantId) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    final result = await ApiService.delete('/secure/merchant/products/variants/$variantId');
    
    if (result['ok'] != true) {
      throw Exception(result['error'] ?? 'فشل حذف Variant');
    }
  }

  /// جلب Variant Options Definitions (تعريفات الخيارات)
  static Future<List<VariantOptionDefinition>> getVariantOptions(String productId) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    try {
      final result = await ApiService.get('/secure/merchant/products/$productId/variant-options');
      
      if (result['ok'] == true && result['data'] != null) {
        final List<dynamic> options = result['data'];
        return options.map((opt) {
          return VariantOptionDefinition(
            id: opt['id'] as String,
            productId: opt['product_id'] as String,
            optionName: opt['option_name'] as String,
            optionValues: List<String>.from(opt['option_values'] ?? []),
            isRequired: opt['is_required'] as bool? ?? true,
            displayOrder: opt['display_order'] as int? ?? 0,
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب Variant Options: $e');
      return [];
    }
  }
}

