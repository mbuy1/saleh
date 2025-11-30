import '../../../../core/supabase_client.dart';

class WalletService {
  /// جلب محفظة المستخدم الحالي
  /// 
  /// Returns: Map يحتوي على بيانات المحفظة (user_id, account_type, balance)
  /// Throws: Exception إذا لم يكن المستخدم مسجل أو لم توجد محفظة
  static Future<Map<String, dynamic>> getWalletForCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      final response = await supabaseClient
          .from('wallet_accounts')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        throw Exception('المحفظة غير موجودة');
      }

      return response;
    } catch (e) {
      throw Exception('خطأ في جلب المحفظة: ${e.toString()}');
    }
  }

  /// جلب عمليات المحفظة للمستخدم الحالي
  /// 
  /// Parameters:
  /// - limit: عدد العمليات المطلوبة (افتراضي: 10)
  /// 
  /// Returns: List من عمليات المحفظة مرتبة حسب التاريخ (الأحدث أولاً)
  /// Throws: Exception إذا لم يكن المستخدم مسجل
  static Future<List<Map<String, dynamic>>> getWalletTransactionsForCurrentUser({
    int limit = 10,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // جلب wallet_account أولاً
      final wallet = await getWalletForCurrentUser();
      final walletId = wallet['id'] as String;

      // جلب العمليات المرتبطة بهذه المحفظة
      final response = await supabaseClient
          .from('wallet_transactions')
          .select()
          .eq('wallet_account_id', walletId)
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('خطأ في جلب عمليات المحفظة: ${e.toString()}');
    }
  }

  /// جلب محفظة التاجر الحالي
  /// 
  /// Returns: Map يحتوي على بيانات محفظة التاجر
  /// Throws: Exception إذا لم يكن المستخدم مسجل أو لم توجد محفظة merchant
  static Future<Map<String, dynamic>> getMerchantWallet() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      final response = await supabaseClient
          .from('wallet_accounts')
          .select()
          .eq('user_id', user.id)
          .eq('account_type', 'merchant')
          .maybeSingle();

      if (response == null) {
        throw Exception('محفظة التاجر غير موجودة');
      }

      return response;
    } catch (e) {
      throw Exception('خطأ في جلب محفظة التاجر: ${e.toString()}');
    }
  }

  /// جلب عمليات محفظة التاجر المرتبطة بالطلبات
  /// 
  /// Parameters:
  /// - limit: عدد العمليات المطلوبة (افتراضي: 10)
  /// 
  /// Returns: List من عمليات المحفظة مرتبة حسب التاريخ (الأحدث أولاً)
  /// Throws: Exception إذا لم يكن المستخدم مسجل
  static Future<List<Map<String, dynamic>>> getMerchantWalletTransactions({
    int limit = 10,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // جلب wallet_account للتاجر
      final wallet = await getMerchantWallet();
      final walletId = wallet['id'] as String;

      // جلب العمليات المرتبطة بهذه المحفظة
      final response = await supabaseClient
          .from('wallet_transactions')
          .select()
          .eq('wallet_account_id', walletId)
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('خطأ في جلب عمليات محفظة التاجر: ${e.toString()}');
    }
  }
}

