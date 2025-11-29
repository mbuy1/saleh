/// Permissions Helper - مساعد الصلاحيات
/// 
/// يحتوي على دوال مساعدة للتحقق من صلاحيات المستخدم بناءً على role
/// 
/// القواعد:
/// - admin: صلاحيات كاملة (GOD MODE)
/// - merchant: في واجهة العميل = Viewer Mode فقط (لا شراء، لا سلة، لا تعليقات/تقييمات)
/// - customer: صلاحيات كاملة للعميل (شراء، سلة، تعليقات، تقييمات)

import '../core/supabase_client.dart';

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
  /// Returns: true فقط إذا كان role == 'customer'
  static Future<bool> canAddToCart() async {
    final role = await getCurrentUserRole();
    return role == 'customer';
  }

  /// التحقق إذا كان المستخدم يمكنه إنشاء طلب
  /// 
  /// Returns: true فقط إذا كان role == 'customer'
  static Future<bool> canCreateOrder() async {
    final role = await getCurrentUserRole();
    return role == 'customer';
  }

  /// التحقق إذا كان المستخدم يمكنه إضافة تعليقات/تقييمات
  /// 
  /// Returns: true فقط إذا كان role == 'customer'
  static Future<bool> canAddReviews() async {
    final role = await getCurrentUserRole();
    return role == 'customer';
  }

  /// التحقق إذا كان المستخدم في وضع Viewer Mode (merchant في واجهة العميل)
  /// 
  /// Returns: true إذا كان role == 'merchant'
  static Future<bool> isViewerMode() async {
    final role = await getCurrentUserRole();
    return role == 'merchant';
  }

  /// التحقق إذا كان المستخدم admin
  /// 
  /// Returns: true إذا كان role == 'admin'
  static Future<bool> isAdmin() async {
    final role = await getCurrentUserRole();
    return role == 'admin';
  }
}

