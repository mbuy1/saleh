import '../../../../core/supabase_client.dart';

class PointsService {
  /// جلب نقاط المستخدم الحالي
  /// 
  /// Returns: Map يحتوي على بيانات حساب النقاط (user_id, points_balance)
  /// Throws: Exception إذا لم يكن المستخدم مسجل أو لم يوجد حساب نقاط
  static Future<Map<String, dynamic>> getPointsForCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      final response = await supabaseClient
          .from('points_accounts')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        throw Exception('حساب النقاط غير موجود');
      }

      return response;
    } catch (e) {
      throw Exception('خطأ في جلب النقاط: ${e.toString()}');
    }
  }

  /// جلب آخر عمليات النقاط للمستخدم الحالي
  /// 
  /// Parameters:
  /// - limit: عدد العمليات المطلوبة (افتراضي: 10)
  /// 
  /// Returns: List من عمليات النقاط مرتبة حسب التاريخ (الأحدث أولاً)
  /// Throws: Exception إذا لم يكن المستخدم مسجل
  static Future<List<Map<String, dynamic>>> getLastPointsTransactions({
    int limit = 10,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // جلب points_account أولاً
      final pointsAccount = await getPointsForCurrentUser();
      final pointsAccountId = pointsAccount['id'] as String;

      // جلب العمليات المرتبطة بهذا الحساب
      final response = await supabaseClient
          .from('points_transactions')
          .select()
          .eq('points_account_id', pointsAccountId)
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('خطأ في جلب عمليات النقاط: ${e.toString()}');
    }
  }
}

