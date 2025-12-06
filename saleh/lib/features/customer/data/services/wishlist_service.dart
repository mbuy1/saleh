import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service.dart';
import '../models/wishlist_model.dart';
import '../../../auth/data/auth_repository.dart';

/// خدمة قائمة الأمنيات (Wishlist)
/// مختلف عن Favorites - قائمة أمنيات مستقلة
class WishlistService {
  /// جلب جميع المنتجات في قائمة الأمنيات
  static Future<List<WishlistItem>> getWishlist() async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    try {
      final result = await ApiService.get('/secure/customer/wishlist');
      
      if (result['ok'] == true && result['data'] != null) {
        final List<dynamic> items = result['data'];
        return items.map((item) {
          return WishlistItem(
            wishlist: WishlistModel.fromJson(item['wishlist']),
            product: item['product'] as Map<String, dynamic>,
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب قائمة الأمنيات: $e');
      return [];
    }
  }

  /// إضافة منتج إلى قائمة الأمنيات
  static Future<void> addToWishlist(String productId) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    final result = await ApiService.post(
      '/secure/customer/wishlist',
      data: {'product_id': productId},
    );

    if (result['ok'] != true) {
      throw Exception(result['error'] ?? 'فشل إضافة المنتج إلى قائمة الأمنيات');
    }
  }

  /// إزالة منتج من قائمة الأمنيات
  static Future<void> removeFromWishlist(String wishlistId) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    final result = await ApiService.delete('/secure/customer/wishlist/$wishlistId');
    
    if (result['ok'] != true) {
      throw Exception(result['error'] ?? 'فشل إزالة المنتج من قائمة الأمنيات');
    }
  }

  /// التحقق إذا كان المنتج في قائمة الأمنيات
  static Future<bool> isInWishlist(String productId) async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) return false;

    try {
      final result = await ApiService.get('/secure/customer/wishlist/check/$productId');
      return result['ok'] == true && result['is_in_wishlist'] == true;
    } catch (e) {
      return false;
    }
  }

  /// تبديل حالة المنتج في قائمة الأمنيات
  static Future<bool> toggleWishlist(String productId) async {
    final isIn = await isInWishlist(productId);

    if (isIn) {
      // نحتاج جلب wishlist ID أولاً
      final wishlist = await getWishlist();
      final item = wishlist.firstWhere(
        (item) => item.wishlist.productId == productId,
        orElse: () => throw Exception('المنتج غير موجود في قائمة الأمنيات'),
      );
      await removeFromWishlist(item.wishlist.id);
      return false;
    } else {
      await addToWishlist(productId);
      return true;
    }
  }

  /// جلب عدد المنتجات في قائمة الأمنيات
  static Future<int> getWishlistCount() async {
    final wishlist = await getWishlist();
    return wishlist.length;
  }

  /// حذف جميع المنتجات من قائمة الأمنيات
  static Future<void> clearWishlist() async {
    final userId = await AuthRepository.getUserId();
    if (userId == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    final result = await ApiService.delete('/secure/customer/wishlist/clear');
    
    if (result['ok'] != true) {
      throw Exception(result['error'] ?? 'فشل حذف قائمة الأمنيات');
    }
  }
}

