import '../../../../core/supabase_client.dart';

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
      // جلب الكوبون من قاعدة البيانات
      final response = await supabaseClient
          .from('coupons')
          .select()
          .eq('code', code.toUpperCase().trim())
          .maybeSingle();

      if (response == null) {
        throw Exception('كود الكوبون غير صحيح');
      }

      final coupon = response;

      // التحقق من is_active
      final isActive = coupon['is_active'] as bool? ?? false;
      if (!isActive) {
        throw Exception('هذا الكوبون غير نشط');
      }

      // التحقق من التاريخ (starts_at)
      final startsAt = coupon['starts_at'] as String?;
      if (startsAt != null) {
        final startDate = DateTime.parse(startsAt);
        if (DateTime.now().isBefore(startDate)) {
          throw Exception('هذا الكوبون لم يبدأ بعد');
        }
      }

      // التحقق من التاريخ (expires_at)
      final expiresAt = coupon['expires_at'] as String?;
      if (expiresAt != null) {
        final expireDate = DateTime.parse(expiresAt);
        if (DateTime.now().isAfter(expireDate)) {
          throw Exception('هذا الكوبون منتهي الصلاحية');
        }
      }

      // التحقق من store_id (إذا تم تمريره)
      if (storeId != null) {
        final couponStoreId = coupon['store_id'] as String?;
        if (couponStoreId != null && couponStoreId != storeId) {
          throw Exception('هذا الكوبون غير صالح لهذا المتجر');
        }
      }

      // التحقق من min_order_amount (إذا تم تمريره)
      if (orderAmount != null) {
        final minOrderAmount = coupon['min_order_amount'] as num?;
        if (minOrderAmount != null && orderAmount < minOrderAmount) {
          throw Exception(
              'الحد الأدنى للطلب هو ${minOrderAmount.toStringAsFixed(2)} ر.س');
        }
      }

      // الكوبون صالح
      return coupon;
    } catch (e) {
      // إذا كانت الرسالة مخصصة، نعيدها كما هي
      if (e.toString().contains('كود') ||
          e.toString().contains('غير نشط') ||
          e.toString().contains('لم يبدأ') ||
          e.toString().contains('منتهي') ||
          e.toString().contains('غير صالح') ||
          e.toString().contains('الحد الأدنى')) {
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
      final response = await supabaseClient
          .from('coupons')
          .select()
          .eq('code', code.toUpperCase().trim())
          .maybeSingle();

      if (response == null) {
        throw Exception('كود الكوبون غير موجود');
      }

      return response;
    } catch (e) {
      throw Exception('خطأ في جلب الكوبون: ${e.toString()}');
    }
  }
}

