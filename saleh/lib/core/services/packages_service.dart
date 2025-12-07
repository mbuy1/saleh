import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// خدمة الباقات
/// TODO: إكمال التنفيذ عند الحاجة
/// المفاتيح السرية يجب أن تكون في Worker Secrets، وليس هنا
class PackagesService {
  /// جلب جميع الباقات المتاحة
  /// 
  /// Returns: List of available packages
  static Future<List<Map<String, dynamic>>> getAvailablePackages() async {
    try {
      debugPrint('[PackagesService] Fetching available packages');
      
      final response = await ApiService.get(
        '/public/packages',
        requireAuth: false,
      );

      if (response['ok'] == true) {
        return List<Map<String, dynamic>>.from(
          response['data']?['packages'] ?? [],
        );
      } else {
        throw Exception(response['message'] ?? 'فشل جلب الباقات');
      }
    } catch (e) {
      debugPrint('[PackagesService] Error fetching packages: $e');
      rethrow;
    }
  }

  /// جلب باقة المستخدم الحالي
  /// 
  /// Returns: Map with user's current package
  static Future<Map<String, dynamic>?> getCurrentPackage() async {
    try {
      debugPrint('[PackagesService] Fetching current package');
      
      final response = await ApiService.get(
        '/secure/packages/current',
      );

      if (response['ok'] == true) {
        return response['data']?['package'] as Map<String, dynamic>?;
      } else {
        throw Exception(response['message'] ?? 'فشل جلب الباقة الحالية');
      }
    } catch (e) {
      debugPrint('[PackagesService] Error fetching current package: $e');
      rethrow;
    }
  }

  /// شراء باقة
  /// 
  /// Parameters:
  /// - packageId: معرف الباقة
  /// - selectedTools: قائمة الأدوات المختارة (للباقة المخصصة)
  /// 
  /// Returns: Map with purchase confirmation
  static Future<Map<String, dynamic>> purchasePackage({
    required String packageId,
    List<String>? selectedTools,
  }) async {
    try {
      debugPrint('[PackagesService] Purchasing package: $packageId');
      
      final response = await ApiService.post(
        '/secure/packages/purchase',
        data: {
          'package_id': packageId,
          if (selectedTools != null) 'selected_tools': selectedTools,
        },
      );

      if (response['ok'] == true) {
        return {
          'package_id': response['data']?['package_id'],
          'expires_at': response['data']?['expires_at'],
          'discount': response['data']?['discount'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل شراء الباقة');
      }
    } catch (e) {
      debugPrint('[PackagesService] Error purchasing package: $e');
      rethrow;
    }
  }

  /// جلب الأدوات المتاحة في الباقة المخصصة
  /// 
  /// Returns: List of available tools
  static Future<List<Map<String, dynamic>>> getCustomPackageTools() async {
    try {
      debugPrint('[PackagesService] Fetching custom package tools');
      
      final response = await ApiService.get(
        '/public/packages/custom-tools',
        requireAuth: false,
      );

      if (response['ok'] == true) {
        return List<Map<String, dynamic>>.from(
          response['data']?['tools'] ?? [],
        );
      } else {
        throw Exception(response['message'] ?? 'فشل جلب الأدوات');
      }
    } catch (e) {
      debugPrint('[PackagesService] Error fetching custom package tools: $e');
      rethrow;
    }
  }

  /// حساب السعر بعد الخصم (30% للباقة المخصصة)
  /// 
  /// Parameters:
  /// - originalPrice: السعر الأصلي
  /// - packageType: نوع الباقة ('custom' للباقة المخصصة)
  /// 
  /// Returns: السعر بعد الخصم
  static double calculateDiscountedPrice({
    required double originalPrice,
    String? packageType,
  }) {
    if (packageType == 'custom') {
      // خصم 30% للباقة المخصصة
      return originalPrice * 0.7;
    }
    return originalPrice;
  }

  /// التحقق من صلاحية الباقة
  /// 
  /// Returns: true if package is valid, false otherwise
  static Future<bool> isPackageValid() async {
    try {
      final package = await getCurrentPackage();
      if (package == null) return false;
      
      final expiresAt = package['expires_at'] as String?;
      if (expiresAt == null) return true; // لا يوجد تاريخ انتهاء
      
      final expiryDate = DateTime.parse(expiresAt);
      return DateTime.now().isBefore(expiryDate);
    } catch (e) {
      debugPrint('[PackagesService] Error checking package validity: $e');
      return false;
    }
  }
}

