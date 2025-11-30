import '../../../../core/supabase_client.dart';

class FavoritesService {
  /// التحقق إذا كان المنتج في المفضلة
  static Future<bool> isFavorite(String productId) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return false;

    try {
      final response = await supabaseClient
          .from('favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('target_type', 'product')
          .eq('target_id', productId)
          .maybeSingle();

      return response != null;
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

    await supabaseClient.from('favorites').insert({
      'user_id': user.id,
      'target_type': 'product',
      'target_id': productId,
    });
  }

  /// إزالة منتج من المفضلة
  static Future<void> removeFromFavorites(String productId) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return;

    await supabaseClient
        .from('favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('target_type', 'product')
        .eq('target_id', productId);
  }

  /// تبديل حالة المفضلة (إضافة أو إزالة)
  static Future<bool> toggleFavorite(String productId) async {
    final isFav = await isFavorite(productId);

    if (isFav) {
      await removeFromFavorites(productId);
      return false;
    } else {
      await addToFavorites(productId);
      return true;
    }
  }

  /// جلب عدد المنتجات المفضلة
  static Future<int> getFavoritesCount() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return 0;

    try {
      final response = await supabaseClient
          .from('favorites')
          .select()
          .eq('user_id', user.id)
          .eq('target_type', 'product');

      return response.length;
    } catch (e) {
      return 0;
    }
  }
}
