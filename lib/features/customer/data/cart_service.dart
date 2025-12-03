import '../../../../core/supabase_client.dart';
import '../../../../core/permissions_helper.dart';

class CartService {
  /// جلب أو إنشاء سلة نشطة للمستخدم الحالي
  /// 
  /// Returns: ID السلة النشطة
  /// Throws: Exception إذا كان المستخدم ليس customer
  static Future<String> getOrCreateActiveCart() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    // التحقق من الصلاحيات: فقط customer يمكنه استخدام السلة
    final canAdd = await PermissionsHelper.canAddToCart();
    if (!canAdd) {
      throw Exception('غير مسموح: التاجر لا يمكنه استخدام سلة العميل');
    }

    // البحث عن سلة نشطة موجودة
    final existingCart = await supabaseClient
        .from('carts')
        .select('id')
        .eq('user_id', user.id)
        .maybeSingle();

    if (existingCart != null) {
      return existingCart['id'] as String;
    }

    // إنشاء سلة جديدة
    final newCart = await supabaseClient
        .from('carts')
        .insert({
          'user_id': user.id,
        })
        .select('id')
        .single();

    return newCart['id'] as String;
  }

  /// إضافة منتج إلى السلة
  /// 
  /// إذا كان المنتج موجود في السلة → يزيد الكمية
  /// إذا لم يكن موجود → يضيف عنصر جديد
  /// 
  /// Throws: Exception إذا كان المستخدم ليس customer
  static Future<void> addToCart(String productId, {int quantity = 1}) async {
    // التحقق من الصلاحيات: فقط customer يمكنه إضافة للسلة
    final canAdd = await PermissionsHelper.canAddToCart();
    if (!canAdd) {
      throw Exception('غير مسموح: التاجر لا يمكنه إضافة منتجات إلى سلة العميل');
    }

    final cartId = await getOrCreateActiveCart();

    // التحقق إذا كان المنتج موجود في السلة
    final existingItem = await supabaseClient
        .from('cart_items')
        .select('id, quantity')
        .eq('cart_id', cartId)
        .eq('product_id', productId)
        .maybeSingle();

    if (existingItem != null) {
      // زيادة الكمية
      final newQuantity = (existingItem['quantity'] as int) + quantity;
      await supabaseClient
          .from('cart_items')
          .update({'quantity': newQuantity})
          .eq('id', existingItem['id']);
    } else {
      // إضافة عنصر جديد
      await supabaseClient.from('cart_items').insert({
        'cart_id': cartId,
        'product_id': productId,
        'quantity': quantity,
      });
    }
  }

  /// تحديث كمية عنصر في السلة
  /// 
  /// Throws: Exception إذا كان المستخدم ليس customer
  static Future<void> updateCartItemQuantity(
    String cartItemId,
    int newQuantity,
  ) async {
    // التحقق من الصلاحيات: فقط customer يمكنه تعديل السلة
    final canAdd = await PermissionsHelper.canAddToCart();
    if (!canAdd) {
      throw Exception('غير مسموح: التاجر لا يمكنه تعديل سلة العميل');
    }

    if (newQuantity <= 0) {
      // إذا كانت الكمية 0 أو أقل، احذف العنصر
      await removeFromCart(cartItemId);
      return;
    }

    await supabaseClient
        .from('cart_items')
        .update({'quantity': newQuantity})
        .eq('id', cartItemId);
  }

  /// حذف عنصر من السلة
  /// 
  /// Throws: Exception إذا كان المستخدم ليس customer
  static Future<void> removeFromCart(String cartItemId) async {
    // التحقق من الصلاحيات: فقط customer يمكنه حذف من السلة
    final canAdd = await PermissionsHelper.canAddToCart();
    if (!canAdd) {
      throw Exception('غير مسموح: التاجر لا يمكنه حذف من سلة العميل');
    }

    await supabaseClient.from('cart_items').delete().eq('id', cartItemId);
  }

  /// جلب عناصر السلة مع معلومات المنتجات
  /// 
  /// Returns: List of cart items with product details
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      return [];
    }

    // جلب السلة النشطة
    final cart = await supabaseClient
        .from('carts')
        .select('id')
        .eq('user_id', user.id)
        .maybeSingle();

    if (cart == null) {
      return [];
    }

    final cartId = cart['id'] as String;

    // جلب عناصر السلة مع معلومات المنتجات
    final response = await supabaseClient
        .from('cart_items')
        .select('''
          *,
          products (
            id,
            name,
            description,
            price,
            stock
          )
        ''')
        .eq('cart_id', cartId);

    return List<Map<String, dynamic>>.from(response);
  }

  /// حساب المجموع الكلي للسلة
  static Future<double> getCartTotal() async {
    final items = await getCartItems();
    double total = 0;

    for (var item in items) {
      final product = item['products'] as Map<String, dynamic>?;
      if (product != null) {
        final price = (product['price'] as num?)?.toDouble() ?? 0;
        final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
        total += price * quantity;
      }
    }

    return total;
  }
}

