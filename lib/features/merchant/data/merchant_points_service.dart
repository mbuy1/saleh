import '../../../core/supabase_client.dart';
import '../../../core/services/api_service.dart';

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

  /// إنشاء حساب نقاط للتاجر (إذا لم يكن موجوداً) - عبر Worker API
  static Future<void> _createPointsAccount(String userId) async {
    try {
      final response = await ApiService.post(
        '/secure/merchant/points/create-account',
        data: {'initial_balance': 0},
      );

      if (response['ok'] == true) {
        // تم الإنشاء بنجاح
      }
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
      // صرف النقاط عبر Worker API (يشمل: validate feature + check balance + update + insert transaction)
      final response = await ApiService.post(
        '/secure/merchant/points/spend',
        data: {'feature_key': featureKey, 'meta': meta ?? {}},
      );

      if (response['ok'] == true) {
        return true; // تم الصرف بنجاح
      } else {
        throw Exception(response['error'] ?? 'فشل صرف النقاط');
      }
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
      // شراء النقاط عبر Worker API (يشمل: create account if needed + update balance + insert transaction)
      final response = await ApiService.post(
        '/secure/merchant/points/purchase',
        data: {
          'points': points,
          'payment_method': 'wallet',
          'meta': meta ?? {},
        },
      );

      if (response['ok'] == true) {
        return true;
      } else {
        throw Exception(response['error'] ?? 'فشل شراء النقاط');
      }
    } catch (e) {
      throw Exception('خطأ في شراء النقاط: ${e.toString()}');
    }
  }

  /// دعم المتجر لمدة محددة (Boost Store)
  ///
  /// Parameters:
  /// - storeId: معرف المتجر
  /// - featureKey: مفتاح الميزة (افتراضي: 'boost_store_24h')
  ///
  /// Returns: true إذا تم الدعم بنجاح، false إذا لم تكن النقاط كافية
  /// Throws: Exception في حالة الفشل
  static Future<bool> boostStore(
    String storeId, {
    String featureKey = 'boost_store_24h',
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // 1. التحقق من أن المتجر يخص التاجر الحالي
      final storeResponse = await supabaseClient
          .from('stores')
          .select('id, owner_id')
          .eq('id', storeId)
          .maybeSingle();

      if (storeResponse == null) {
        throw Exception('المتجر غير موجود');
      }

      if (storeResponse['owner_id'] != user.id) {
        throw Exception('ليس لديك صلاحية لدعم هذا المتجر');
      }

      // 2. جلب معلومات الميزة من feature_actions
      final featureResponse = await supabaseClient
          .from('feature_actions')
          .select()
          .eq('key', featureKey)
          .eq('is_enabled', true)
          .maybeSingle();

      if (featureResponse == null) {
        throw Exception('الميزة غير موجودة أو غير مفعلة');
      }

      // 3. قراءة duration_hours من config (أو استخدام 24 ساعة كافتراضي)
      final config = featureResponse['config'] as Map<String, dynamic>?;
      final durationHours = (config?['duration_hours'] as num?)?.toInt() ?? 24;

      // 4. صرف النقاط باستخدام spendPointsForFeature
      final success = await spendPointsForFeature(
        featureKey,
        meta: {'store_id': storeId, 'duration_hours': durationHours},
      );

      if (!success) {
        return false; // لا توجد نقاط كافية
      }

      // 5. حساب boosted_until = now() + duration_hours
      final boostedUntil = DateTime.now().add(Duration(hours: durationHours));

      // 6. تحديث جدول stores
      await supabaseClient
          .from('stores')
          .update({'boosted_until': boostedUntil.toIso8601String()})
          .eq('id', storeId);

      return true; // تم الدعم بنجاح
    } catch (e) {
      // إذا كانت الرسالة مخصصة، نعيدها كما هي
      if (e.toString().contains('غير موجود') ||
          e.toString().contains('غير مفعلة') ||
          e.toString().contains('لا توجد نقاط') ||
          e.toString().contains('صلاحية')) {
        rethrow;
      }
      throw Exception('خطأ في دعم المتجر: ${e.toString()}');
    }
  }

  /// إبراز المتجر على الخريطة لمدة محددة (Highlight Store on Map)
  ///
  /// Parameters:
  /// - storeId: معرف المتجر
  /// - featureKey: مفتاح الميزة (افتراضي: 'map_highlight_24h')
  ///
  /// Returns: true إذا تم الإبراز بنجاح، false إذا لم تكن النقاط كافية
  /// Throws: Exception في حالة الفشل
  static Future<bool> highlightStoreOnMap(
    String storeId, {
    String featureKey = 'map_highlight_24h',
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // 1. التحقق من أن المتجر يخص التاجر الحالي
      final storeResponse = await supabaseClient
          .from('stores')
          .select('id, owner_id')
          .eq('id', storeId)
          .maybeSingle();

      if (storeResponse == null) {
        throw Exception('المتجر غير موجود');
      }

      if (storeResponse['owner_id'] != user.id) {
        throw Exception('ليس لديك صلاحية لإبراز هذا المتجر على الخريطة');
      }

      // 2. جلب معلومات الميزة من feature_actions
      final featureResponse = await supabaseClient
          .from('feature_actions')
          .select()
          .eq('key', featureKey)
          .eq('is_enabled', true)
          .maybeSingle();

      if (featureResponse == null) {
        throw Exception('الميزة غير موجودة أو غير مفعلة');
      }

      // 3. قراءة duration_hours من config (أو استخدام 24 ساعة كافتراضي)
      final config = featureResponse['config'] as Map<String, dynamic>?;
      final durationHours = (config?['duration_hours'] as num?)?.toInt() ?? 24;

      // 4. صرف النقاط باستخدام spendPointsForFeature
      final success = await spendPointsForFeature(
        featureKey,
        meta: {'store_id': storeId, 'duration_hours': durationHours},
      );

      if (!success) {
        return false; // لا توجد نقاط كافية
      }

      // 5. حساب map_highlight_until = now() + duration_hours
      final highlightUntil = DateTime.now().add(Duration(hours: durationHours));

      // 6. تحديث جدول stores
      await supabaseClient
          .from('stores')
          .update({'map_highlight_until': highlightUntil.toIso8601String()})
          .eq('id', storeId);

      return true; // تم الإبراز بنجاح
    } catch (e) {
      // إذا كانت الرسالة مخصصة، نعيدها كما هي
      if (e.toString().contains('غير موجود') ||
          e.toString().contains('غير مفعلة') ||
          e.toString().contains('لا توجد نقاط') ||
          e.toString().contains('صلاحية')) {
        rethrow;
      }
      throw Exception('خطأ في إبراز المتجر على الخريطة: ${e.toString()}');
    }
  }
}
