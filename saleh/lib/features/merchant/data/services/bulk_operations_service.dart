import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service.dart';
import '../models/bulk_operation_model.dart';
import '../../../auth/data/auth_repository.dart';

/// خدمة العمليات المجمعة (Bulk Operations)
class BulkOperationsService {
  /// تنفيذ عملية مجمعة على المنتجات
  static Future<BulkOperationModel> executeBulkOperation({
    required String operationType, // 'update', 'delete', 'activate', 'deactivate'
    required List<String> productIds,
    Map<String, dynamic>? updateData, // For update operations
    Map<String, dynamic>? parameters,
  }) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    if (productIds.isEmpty) {
      throw Exception('يجب اختيار منتج واحد على الأقل');
    }

    final request = BulkOperationRequest(
      operationType: operationType,
      itemIds: productIds,
      updateData: updateData,
      parameters: parameters,
    );

    try {
      final result = await ApiService.post(
        '/secure/merchant/products/bulk',
        data: request.toJson(),
      );

      if (result['ok'] == true && result['data'] != null) {
        return BulkOperationModel.fromJson(result['data']);
      }

      throw Exception(result['error'] ?? 'فشل تنفيذ العملية المجمعة');
    } catch (e) {
      debugPrint('❌ خطأ في تنفيذ العملية المجمعة: $e');
      rethrow;
    }
  }

  /// جلب حالة عملية مجمعة
  static Future<BulkOperationModel?> getBulkOperationStatus(String operationId) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    try {
      final result = await ApiService.get('/secure/merchant/bulk-operations/$operationId');
      
      if (result['ok'] == true && result['data'] != null) {
        return BulkOperationModel.fromJson(result['data']);
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ خطأ في جلب حالة العملية: $e');
      return null;
    }
  }

  /// تصدير المنتجات (CSV/Excel)
  static Future<String> exportProducts({
    List<String>? productIds,
    Map<String, dynamic>? filters,
  }) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    try {
      final result = await ApiService.post(
        '/secure/merchant/products/export',
        data: {
          if (productIds != null) 'product_ids': productIds,
          if (filters != null) 'filters': filters,
        },
      );

      if (result['ok'] == true && result['data'] != null) {
        return result['data']['download_url'] as String;
      }

      throw Exception(result['error'] ?? 'فشل تصدير المنتجات');
    } catch (e) {
      debugPrint('❌ خطأ في تصدير المنتجات: $e');
      rethrow;
    }
  }

  /// استيراد المنتجات (CSV/Excel)
  static Future<BulkOperationModel> importProducts(String fileUrl) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    try {
      final result = await ApiService.post(
        '/secure/merchant/products/import',
        data: {
          'file_url': fileUrl,
        },
      );

      if (result['ok'] == true && result['data'] != null) {
        return BulkOperationModel.fromJson(result['data']);
      }

      throw Exception(result['error'] ?? 'فشل استيراد المنتجات');
    } catch (e) {
      debugPrint('❌ خطأ في استيراد المنتجات: $e');
      rethrow;
    }
  }

  /// تحديث منتجات مجمعة
  static Future<BulkOperationModel> bulkUpdateProducts({
    required List<String> productIds,
    required Map<String, dynamic> updateData,
  }) async {
    return executeBulkOperation(
      operationType: 'update',
      productIds: productIds,
      updateData: updateData,
    );
  }

  /// حذف منتجات مجمعة
  static Future<BulkOperationModel> bulkDeleteProducts({
    required List<String> productIds,
  }) async {
    return executeBulkOperation(
      operationType: 'delete',
      productIds: productIds,
    );
  }

  /// تفعيل منتجات مجمعة
  static Future<BulkOperationModel> bulkActivateProducts({
    required List<String> productIds,
  }) async {
    return executeBulkOperation(
      operationType: 'activate',
      productIds: productIds,
    );
  }

  /// إلغاء تفعيل منتجات مجمعة
  static Future<BulkOperationModel> bulkDeactivateProducts({
    required List<String> productIds,
  }) async {
    return executeBulkOperation(
      operationType: 'deactivate',
      productIds: productIds,
    );
  }
}

