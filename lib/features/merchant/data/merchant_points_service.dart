/// خدمة Merchant Points - إدارة نقاط التاجر
/// 
/// تحتوي على:
/// - getMerchantPointsBalance: جلب رصيد نقاط التاجر
/// - getAvailableFeatureActions: جلب قائمة الميزات المتاحة
/// - spendPointsForFeature: صرف نقاط لاستخدام ميزة
/// - getMerchantPointsTransactions: جلب عمليات نقاط التاجر
/// 
/// ملاحظات:
/// - النقاط للتاجر فقط (merchant_points)
/// - النقاط هي "رصيد خدمات" لتفعيل مميزات داخل التطبيق
/// - جميع تكاليف الميزات تأتي من جدول feature_actions (لا قيم ثابتة في الكود)

import '../../../core/supabase_client.dart';

class MerchantPointsService {
  /// جلب رصيد نقاط التاجر الحالي
  /// 
  /// Returns: رصيد النقاط (int)
  /// Throws: Exception إذا لم يكن المستخدم مسجل أو لم يوجد حساب نقاط
  static Future<int> getMerchantPointsBalance() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      final response = await supabaseClient
          .from('points_accounts')
          .select('points_balance')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        // إذا لم يوجد حساب نقاط، ننشئه تلقائياً
        await _createPointsAccount(user.id);
        return 0;
      }

      return (response['points_balance'] as num?)?.toInt() ?? 0;
    } catch (e) {
      throw Exception('خطأ في جلب رصيد النقاط: ${e.toString()}');
    }
  }

  /// إنشاء حساب نقاط للتاجر (إذا لم يكن موجوداً)
  static Future<void> _createPointsAccount(String userId) async {
    try {
      await supabaseClient.from('points_accounts').insert({
        'user_id': userId,
        'points_balance': 0,
      });
    } catch (e) {
      // قد يكون الحساب موجوداً بالفعل، نتجاهل الخطأ
    }
  }

  /// جلب قائمة الميزات المتاحة للتاجر
  /// 
  /// Returns: List من الميزات (feature_actions) حيث is_enabled = true
  /// Throws: Exception في حالة الفشل
  static Future<List<Map<String, dynamic>>> getAvailableFeatureActions() async {
    try {
      final response = await supabaseClient
          .from('feature_actions')
          .select()
          .eq('is_enabled', true)
          .order('key');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('خطأ في جلب الميزات المتاحة: ${e.toString()}');
    }
  }

  /// صرف نقاط لاستخدام ميزة
  /// 
  /// Parameters:
  /// - featureKey: مفتاح الميزة (مثل 'boost_store', 'explore_video')
  /// - meta: بيانات إضافية (اختياري) - مثل store_id, product_id
  /// 
  /// Returns: true إذا تم الصرف بنجاح، false إذا لم تكن النقاط كافية
  /// Throws: Exception في حالة الفشل
  static Future<bool> spendPointsForFeature(
    String featureKey, {
    Map<String, dynamic>? meta,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // 1. جلب حساب نقاط التاجر
      final pointsAccountResponse = await supabaseClient
          .from('points_accounts')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (pointsAccountResponse == null) {
        // إنشاء حساب نقاط إذا لم يكن موجوداً
        await _createPointsAccount(user.id);
        throw Exception('لا توجد نقاط كافية');
      }

      final pointsAccountId = pointsAccountResponse['id'] as String;
      final currentBalance = (pointsAccountResponse['points_balance'] as num?)?.toInt() ?? 0;

      // 2. جلب سجل feature_actions للـ featureKey
      final featureResponse = await supabaseClient
          .from('feature_actions')
          .select()
          .eq('key', featureKey)
          .eq('is_enabled', true)
          .maybeSingle();

      if (featureResponse == null) {
        throw Exception('الميزة غير موجودة أو غير مفعلة');
      }

      final cost = (featureResponse['default_cost'] as num?)?.toInt() ?? 0;

      // 3. التحقق أن balance >= cost
      if (currentBalance < cost) {
        return false; // لا توجد نقاط كافية
      }

      // 4. خصم النقاط (update points_accounts.balance)
      final newBalance = currentBalance - cost;
      await supabaseClient
          .from('points_accounts')
          .update({'points_balance': newBalance})
          .eq('id', pointsAccountId);

      // 5. إضافة سجل في points_transactions
      await supabaseClient.from('points_transactions').insert({
        'points_account_id': pointsAccountId,
        'type': 'spend_feature',
        'feature_key': featureKey,
        'points_change': -cost,
        'meta': meta ?? {},
      });

      return true; // تم الصرف بنجاح
    } catch (e) {
      // إذا كانت الرسالة مخصصة، نعيدها كما هي
      if (e.toString().contains('غير موجودة') ||
          e.toString().contains('غير مفعلة') ||
          e.toString().contains('لا توجد نقاط')) {
        rethrow;
      }
      throw Exception('خطأ في صرف النقاط: ${e.toString()}');
    }
  }

  /// جلب عمليات نقاط التاجر
  /// 
  /// Parameters:
  /// - limit: عدد العمليات المطلوبة (افتراضي: 20)
  /// 
  /// Returns: List من عمليات النقاط مرتبة حسب التاريخ (الأحدث أولاً)
  /// Throws: Exception إذا لم يكن المستخدم مسجل
  static Future<List<Map<String, dynamic>>> getMerchantPointsTransactions({
    int limit = 20,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // جلب points_account أولاً
      final pointsAccountResponse = await supabaseClient
          .from('points_accounts')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (pointsAccountResponse == null) {
        return []; // لا يوجد حساب نقاط، لا توجد عمليات
      }

      final pointsAccountId = pointsAccountResponse['id'] as String;

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

  /// شراء نقاط (للتاجر)
  /// 
  /// Parameters:
  /// - points: عدد النقاط المراد شراؤها
  /// - meta: بيانات إضافية (مثل payment_id)
  /// 
  /// Returns: true إذا تم الشراء بنجاح
  /// Throws: Exception في حالة الفشل
  static Future<bool> purchasePoints(
    int points, {
    Map<String, dynamic>? meta,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    if (points <= 0) {
      throw Exception('عدد النقاط يجب أن يكون أكبر من صفر');
    }

    try {
      // جلب أو إنشاء حساب نقاط
      final pointsAccountResponse = await supabaseClient
          .from('points_accounts')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      String pointsAccountId;
      int currentBalance;

      if (pointsAccountResponse == null) {
        // إنشاء حساب نقاط جديد
        final createResponse = await supabaseClient
            .from('points_accounts')
            .insert({
              'user_id': user.id,
              'points_balance': points,
            })
            .select()
            .single();
        pointsAccountId = createResponse['id'] as String;
        currentBalance = points;
      } else {
        pointsAccountId = pointsAccountResponse['id'] as String;
        currentBalance = (pointsAccountResponse['points_balance'] as num?)?.toInt() ?? 0;

        // زيادة الرصيد
        await supabaseClient
            .from('points_accounts')
            .update({'points_balance': currentBalance + points})
            .eq('id', pointsAccountId);
      }

      // إضافة سجل في points_transactions
      await supabaseClient.from('points_transactions').insert({
        'points_account_id': pointsAccountId,
        'type': 'purchase',
        'feature_key': null,
        'points_change': points,
        'meta': meta ?? {},
      });

      return true;
    } catch (e) {
      throw Exception('خطأ في شراء النقاط: ${e.toString()}');
    }
  }
}

