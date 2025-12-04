import '../../../../core/services/api_service.dart';
import '../../../../core/supabase_client.dart';

class FavoritesService {
  /// التحقق إذا كان المنتج في المفضلة
  static Future<bool> isFavorite(String productId) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return false;

    try {
      final result = await ApiService.get('/favorites/check/$productId');
      return result['ok'] == true && result['isFavorite'] == true;
    } catch (e) {
      return false;
    }
  }

  /// إضافة منتج للمفضلة
  static Future<void> addToFavorites(String productId) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    final result = await ApiService.post(
      '/favorites',
      data: {'product_id': productId},
    );

    if (result['ok'] != true) {
      throw Exception(result['error'] ?? 'فشل إضافة المنتج للمفضلة');
    }
  }

  /// إزالة منتج من المفضلة
  static Future<void> removeFromFavorites(String favoriteId) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return;

    await ApiService.delete('/favorites/$favoriteId');
  }

  /// تبديل حالة المفضلة (إضافة أو إزالة)
  static Future<bool> toggleFavorite(String productId) async {
    final isFav = await isFavorite(productId);

    if (isFav) {
      // نحتاج أولاً جلب الـ favorite ID
      final favorites = await getFavorites();
      final favorite = favorites.firstWhere(
        (f) => f['product_id'] == productId,
        orElse: () => {},
      );

      if (favorite.isNotEmpty) {
        await removeFromFavorites(favorite['id']);
      }
      return false;
    } else {
      await addToFavorites(productId);
      return true;
    }
  }

  /// جلب المنتجات المفضلة
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return [];

    try {
      final result = await ApiService.get('/favorites');

      if (result['ok'] == true && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// جلب عدد المنتجات المفضلة
  static Future<int> getFavoritesCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }
}
