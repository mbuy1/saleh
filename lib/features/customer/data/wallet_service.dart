import '../../../../core/supabase_client.dart';
import '../../../../core/services/wallet_service.dart' as api_wallet;

class WalletService {
  /// جلب محفظة العميل الحالي
  ///
  /// Returns: Map يحتوي على بيانات المحفظة (user_id, account_type, balance)
  /// Throws: Exception إذا لم يكن المستخدم مسجل أو لم توجد محفظة
  static Future<Map<String, dynamic>> getWalletForCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // استخدام API Gateway بدلاً من Supabase مباشرة
      final wallet = await api_wallet.WalletService.getWalletDetails();

      if (wallet == null) {
        // إذا لم توجد محفظة، نقوم بإنشائها تلقائياً عبر Supabase
        // (سيتم نقل هذا لاحقاً إلى API Gateway)
        final newWallet = await supabaseClient
            .from('wallets')
            .insert({'owner_id': user.id, 'type': 'customer', 'balance': 0.0})
            .select()
            .single();

        return newWallet;
      }

      return wallet;
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
  static Future<List<Map<String, dynamic>>>
  getWalletTransactionsForCurrentUser({int limit = 10}) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      final result = await api_wallet.WalletService.getWalletTransactions(
        limit: limit,
        walletType: 'customer',
      );

      return List<Map<String, dynamic>>.from(result ?? []);
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
      final wallet = await api_wallet.WalletService.getWalletDetails();
      if (wallet == null) {
        throw Exception('محفظة التاجر غير موجودة');
      }
      return wallet;
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
      final result = await api_wallet.WalletService.getWalletTransactions(
        limit: limit,
        walletType: 'merchant',
      );

      return List<Map<String, dynamic>>.from(result ?? []);
    } catch (e) {
      throw Exception('خطأ في جلب عمليات محفظة التاجر: ${e.toString()}');
    }
  }
}
