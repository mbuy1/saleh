import '../../../../core/services/api_service.dart';

class CouponService {
  /// التحقق من صحة كوبون
  /// 
  /// Parameters:
  /// - code: كود الكوبون
  /// - storeId: معرف المتجر (اختياري) - للتحقق من store_id في الكوبون
  /// - orderAmount: مبلغ الطلب (اختياري) - للتحقق من min_order_amount
  /// 
  /// Returns: Map يحتوي على بيانات الكوبون إذا كان صالحاً
  /// Throws: Exception إذا كان الكوبون غير صالح
  static Future<Map<String, dynamic>> validateCoupon(
    String code, {
    String? storeId,
    num? orderAmount,
  }) async {
    if (code.isEmpty) {
      throw Exception('كود الكوبون مطلوب');
    }

    try {
      // استخدام Worker API للتحقق من الكوبون
      final response = await ApiService.post(
        '/secure/coupons/validate',
        data: {
          'code': code.toUpperCase().trim(),
          'store_id': storeId,
          'total_amount': orderAmount,
        },
      );

      if (response['ok'] == true) {
        return response['coupon'] as Map<String, dynamic>;
      } else {
        final errorMessage = response['error'] ?? response['message'] ?? 'كود الكوبون غير صحيح';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // إذا كانت الرسالة مخصصة، نعيدها كما هي
      if (e.toString().contains('كود') ||
          e.toString().contains('غير نشط') ||
          e.toString().contains('لم يبدأ') ||
          e.toString().contains('منتهي') ||
          e.toString().contains('غير صالح') ||
          e.toString().contains('الحد الأدنى') ||
          e.toString().contains('Invalid') ||
          e.toString().contains('expired') ||
          e.toString().contains('Minimum')) {
        rethrow;
      }
      throw Exception('خطأ في التحقق من الكوبون: ${e.toString()}');
    }
  }

  /// جلب تفاصيل كوبون (للعرض فقط)
  /// 
  /// Parameters:
  /// - code: كود الكوبون
  /// 
  /// Returns: Map يحتوي على بيانات الكوبون
  /// Throws: Exception إذا لم يوجد الكوبون
  static Future<Map<String, dynamic>> getCouponByCode(String code) async {
    try {
      // استخدام Worker API - يمكن إضافة endpoint مخصص لاحقاً
      // حالياً نستخدم validateCoupon بدون storeId و orderAmount
      return await validateCoupon(code);
    } catch (e) {
      throw Exception('خطأ في جلب الكوبون: ${e.toString()}');
    }
  }
}

