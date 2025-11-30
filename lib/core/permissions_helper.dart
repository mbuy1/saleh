import '../core/supabase_client.dart';

/// نموذج الصلاحيات (Permissions Model) للتطبيق
///
/// الأدوار المتاحة:
/// - admin: مالك التطبيق - صلاحيات كاملة (GOD MODE)
/// - merchant: التاجر - له لوحة تحكم + متجر + نقاط + محفظة تاجر
///   عند الانتقال لواجهة العميل يكون في "Viewer Mode" فقط (تصفح بدون شراء)
/// - customer: العميل - يتصفح ويشتري ويعلق ويقيّم
class PermissionsHelper {
  /// جلب role المستخدم الحالي من user_profiles
  ///
  /// Returns: 'admin', 'merchant', 'customer', أو null إذا لم يكن مسجل
  static Future<String?> getCurrentUserRole() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      final response = await supabaseClient
          .from('user_profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      return response?['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// التحقق إذا كان المستخدم يمكنه إضافة منتجات إلى السلة
  ///
  /// القواعد:
  /// - customer: يمكنه إضافة للسلة ✅
  /// - merchant: لا يمكنه (Viewer Mode فقط) ❌
  /// - admin: يمكنه (GOD MODE) ✅
  ///
  /// Returns: true فقط إذا كان role == 'customer' أو 'admin'
  static Future<bool> canAddToCart() async {
    final role = await getCurrentUserRole();
    return role == 'customer' || role == 'admin';
  }

  /// التحقق إذا كان المستخدم يمكنه إنشاء طلب
  ///
  /// القواعد:
  /// - customer: يمكنه إنشاء طلبات ✅
  /// - merchant: لا يمكنه (Viewer Mode) ❌
  /// - admin: يمكنه (GOD MODE) ✅
  ///
  /// Returns: true فقط إذا كان role == 'customer' أو 'admin'
  static Future<bool> canCreateOrder() async {
    final role = await getCurrentUserRole();
    return role == 'customer' || role == 'admin';
  }

  /// التحقق إذا كان المستخدم يمكنه إضافة تعليقات/تقييمات
  ///
  /// القواعد:
  /// - customer: يمكنه التعليق والتقييم على منتجات اشتراها فقط ✅
  /// - merchant: لا يمكنه (Viewer Mode) ❌
  /// - admin: يمكنه (GOD MODE) ✅
  ///
  /// Returns: true فقط إذا كان role == 'customer' أو 'admin'
  static Future<bool> canAddReviews() async {
    final role = await getCurrentUserRole();
    return role == 'customer' || role == 'admin';
  }

  /// التحقق إذا كان المستخدم يمكنه استخدام الكوبونات
  ///
  /// القواعد:
  /// - customer: يمكنه استخدام كوبونات الخصم ✅
  /// - merchant: لا يمكنه (Viewer Mode) ❌
  /// - admin: يمكنه (GOD MODE) ✅
  ///
  /// Returns: true فقط إذا كان role == 'customer' أو 'admin'
  static Future<bool> canUseCoupons() async {
    final role = await getCurrentUserRole();
    return role == 'customer' || role == 'admin';
  }

  /// التحقق إذا كان المستخدم يمكنه استخدام نقاط العميل
  ///
  /// القواعد:
  /// - customer: يمكنه استخدام نقاط العميل ✅
  /// - merchant: لا يمكنه (له نقاط تاجر منفصلة) ❌
  /// - admin: يمكنه (GOD MODE) ✅
  ///
  /// Returns: true فقط إذا كان role == 'customer' أو 'admin'
  static Future<bool> canUseCustomerPoints() async {
    final role = await getCurrentUserRole();
    return role == 'customer' || role == 'admin';
  }

  /// التحقق إذا كان المستخدم في وضع Viewer Mode (merchant في واجهة العميل)
  ///
  /// في هذا الوضع:
  /// - يمكنه رؤية المتاجر والمنتجات فقط
  /// - لا يمكنه الشراء أو إضافة للسلة
  /// - لا يمكنه التعليق أو التقييم
  ///
  /// Returns: true إذا كان role == 'merchant'
  static Future<bool> isViewerMode() async {
    final role = await getCurrentUserRole();
    return role == 'merchant';
  }

  /// التحقق إذا كان المستخدم admin
  ///
  /// Admin له صلاحيات كاملة (GOD MODE):
  /// - تحكم كامل بالنقاط والباقات والأسعار
  /// - تشغيل/إيقاف المتاجر والميزات
  /// - تفعيل/تعطيل الحسابات
  ///
  /// Returns: true إذا كان role == 'admin'
  static Future<bool> isAdmin() async {
    final role = await getCurrentUserRole();
    return role == 'admin';
  }

  /// التحقق إذا كان المستخدم customer
  ///
  /// Returns: true إذا كان role == 'customer'
  static Future<bool> isCustomer() async {
    final role = await getCurrentUserRole();
    return role == 'customer';
  }

  /// التحقق إذا كان المستخدم merchant
  ///
  /// Returns: true إذا كان role == 'merchant'
  static Future<bool> isMerchant() async {
    final role = await getCurrentUserRole();
    return role == 'merchant';
  }

  /// الحصول على رسالة توضيحية حسب الدور
  ///
  /// Returns: رسالة توضح حالة المستخدم الحالية
  static Future<String> getViewerModeMessage() async {
    final role = await getCurrentUserRole();

    switch (role) {
      case 'merchant':
        return 'أنت في وضع التصفح - لا يمكنك الشراء أو إضافة للسلة';
      case 'customer':
        return '';
      case 'admin':
        return 'وضع المدير - صلاحيات كاملة';
      default:
        return 'يرجى تسجيل الدخول';
    }
  }
}
