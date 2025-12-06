import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service.dart';
import '../models/recently_viewed_model.dart';
import '../../../auth/data/auth_repository.dart';

/// خدمة المنتجات التي تم عرضها مؤخراً
class RecentlyViewedService {
  /// تسجيل عرض منتج
  static Future<void> recordView(String productId) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) return; // لا نسجل إذا لم يكن المستخدم مسجلاً

    try {
      await ApiService.post(
        '/secure/customer/recently-viewed',
        data: {'product_id': productId},
      );
    } catch (e) {
      debugPrint('❌ خطأ في تسجيل عرض المنتج: $e');
      // لا نرمي خطأ - هذه عملية ثانوية
    }
  }

  /// جلب المنتجات المعروضة مؤخراً
  static Future<List<RecentlyViewedItem>> getRecentlyViewed({int limit = 20}) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) return [];

    try {
      final result = await ApiService.get('/secure/customer/recently-viewed?limit=$limit');
      
      if (result['ok'] == true && result['data'] != null) {
        final List<dynamic> items = result['data'];
        return items.map((item) {
          return RecentlyViewedItem(
            recentlyViewed: RecentlyViewedModel.fromJson(item['recently_viewed']),
            product: item['product'] as Map<String, dynamic>,
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب المنتجات المعروضة مؤخراً: $e');
      return [];
    }
  }

  /// حذف منتج من قائمة المعروضة مؤخراً
  static Future<void> removeFromRecentlyViewed(String recentlyViewedId) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) return;

    try {
      await ApiService.delete('/secure/customer/recently-viewed/$recentlyViewedId');
    } catch (e) {
      debugPrint('❌ خطأ في حذف المنتج من المعروضة مؤخراً: $e');
    }
  }

  /// حذف جميع المنتجات المعروضة مؤخراً
  static Future<void> clearRecentlyViewed() async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) return;

    try {
      await ApiService.delete('/secure/customer/recently-viewed/clear');
    } catch (e) {
      debugPrint('❌ خطأ في حذف جميع المنتجات المعروضة مؤخراً: $e');
    }
  }

  /// جلب عدد المنتجات المعروضة مؤخراً
  static Future<int> getRecentlyViewedCount() async {
    final items = await getRecentlyViewed();
    return items.length;
  }
}

