import '../../../core/services/api_service.dart';
import '../../auth/data/auth_repository.dart';
// TODO: إزالة جميع استخدامات supabaseClient واستبدالها بـ ApiService
// سيتم إضافة endpoints في Worker للعمليات المتبقية

class MerchantPointsService {
  /// جلب رصيد نقاط التاجر الحالي
  ///
  /// Returns: رصيد النقاط (int)
  /// Throws: Exception إذا لم يكن المستخدم مسجل أو لم يوجد حساب نقاط
  static Future<int> getMerchantPointsBalance() async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // استخدام Worker API لجلب رصيد النقاط
      final response = await ApiService.get('/secure/points');

      if (response['ok'] == true && response['data'] != null) {
        final pointsData = response['data'] as Map<String, dynamic>;
        return (pointsData['points_balance'] as num?)?.toInt() ?? 0;
      } else {
        // إذا لم يوجد حساب نقاط، ننشئه تلقائياً
        await _createPointsAccount(userId);
        return 0;
      }
    } catch (e) {
      // إذا كان الخطأ بسبب عدم وجود حساب، نحاول إنشاءه
      try {
        await _createPointsAccount(userId);
        return 0;
      } catch (_) {
        throw Exception('خطأ في جلب رصيد النقاط: ${e.toString()}');
      }
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
      // استخدام Worker API - يمكن إضافة endpoint مخصص لاحقاً
      // حالياً نستخدم endpoint عام للفئات/الميزات
      final response = await ApiService.get('/secure/merchant/features');

      if (response['ok'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        // Fallback: إرجاع قائمة فارغة إذا لم يكن endpoint موجوداً
        return [];
      }
    } catch (e) {
      // إذا لم يكن endpoint موجوداً، نعيد قائمة فارغة
      // (سيتم إضافة endpoint لاحقاً في Worker)
      return [];
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
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
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
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // استخدام Worker API لجلب عمليات النقاط
      final response = await ApiService.get(
        '/secure/merchant/points/transactions?limit=$limit',
      );

      if (response['ok'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        return []; // لا توجد عمليات
      }
    } catch (e) {
      // إذا لم يكن endpoint موجوداً بعد، نعيد قائمة فارغة
      return [];
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
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
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
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // استخدام Worker API لدعم المتجر
      final response = await ApiService.post(
        '/secure/stores/$storeId/boost',
        data: {
          'feature_key': featureKey,
        },
      );

      if (response['ok'] == true) {
        return true; // تم الدعم بنجاح
      } else {
        final errorMessage = response['message'] ?? response['error'] ?? 'فشل دعم المتجر';
        throw Exception(errorMessage);
      }
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
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('المستخدم غير مسجل');
    }

    try {
      // استخدام Worker API لإبراز المتجر على الخريطة
      final response = await ApiService.post(
        '/secure/stores/$storeId/map-highlight',
        data: {
          'feature_key': featureKey,
        },
      );

      if (response['ok'] == true) {
        return true; // تم الإبراز بنجاح
      } else {
        final errorMessage = response['message'] ?? response['error'] ?? 'فشل إبراز المتجر';
        throw Exception(errorMessage);
      }
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
