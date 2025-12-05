import '../../../../core/supabase_client.dart';
import '../../../../core/permissions_helper.dart';
import '../../../../core/services/api_service.dart';
import 'services/cart_service.dart';

class OrderService {
  /// تحويل السلة إلى طلب
  ///
  /// يقوم بـ:
  /// 1. جلب عناصر السلة
  /// 2. إنشاء طلب جديد في orders
  /// 3. إنشاء order_items لكل عنصر في السلة
  /// 4. تحديث حالة السلة إلى 'converted_to_order'
  ///
  /// Returns: ID الطلب الجديد
  /// Throws: Exception إذا كان المستخدم ليس customer
  static Future<String> createOrderFromCart() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('المستخدم غير مسجل');
    }

    // التحقق من الصلاحيات: فقط customer يمكنه إنشاء طلب
    final canCreate = await PermissionsHelper.canCreateOrder();
    if (!canCreate) {
      throw Exception('غير مسموح: التاجر لا يمكنه إنشاء طلبات كعميل');
    }

    // جلب عناصر السلة
    final cartItems = await CartService.getCartItems();
    if (cartItems.isEmpty) {
      throw Exception('السلة فارغة');
    }

    // جلب السلة النشطة
    final cart = await supabaseClient
        .from('carts')
        .select('id')
        .eq('user_id', user.id)
        .single();

    final cartId = cart['id'] as String;

    // حساب المجموع الكلي باستخدام calculateTotal
    final total = CartService.calculateTotal(cartItems);

    // إنشاء الطلب عبر Worker API (يشمل: create order + bulk insert items + delete cart)
    final response = await ApiService.post(
      '/secure/orders/create-from-cart',
      data: {
        'cart_id': cartId,
        'delivery_address': 'عنوان التوصيل', // TODO: جلب من إعدادات المستخدم
        'payment_method': 'wallet', // TODO: السماح للمستخدم باختيار طريقة الدفع
        'total_amount': total,
      },
    );

    if (response['ok'] == true) {
      final orderId = response['data']?['order_id'] as String?;
      if (orderId == null) {
        throw Exception('فشل في الحصول على رقم الطلب');
      }
      return orderId;
    } else {
      throw Exception(response['error'] ?? 'فشل في إنشاء الطلب');
    }
  }

  /// جلب طلبات العميل
  ///
  /// Returns: List of orders
  static Future<List<Map<String, dynamic>>> getCustomerOrders() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      return [];
    }

    try {
      final result = await ApiService.get('/secure/orders');
      if (result['ok'] == true && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
      return [];
    } catch (e) {
      throw Exception('خطأ في جلب الطلبات: ${e.toString()}');
    }
  }

  /// جلب تفاصيل طلب مع order_items
  ///
  /// Returns: Order with order_items and products
  static Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      final result = await ApiService.post(
        '/secure/orders/details',
        data: {'order_id': orderId},
      );

      if (result['ok'] == true && result['data'] != null) {
        return result['data'];
      }
      throw Exception('لم يتم العثور على الطلب');
    } catch (e) {
      throw Exception('خطأ في جلب تفاصيل الطلب: ${e.toString()}');
    }
  }

  /// جلب طلبات متجر معين (للتاجر)
  ///
  /// Returns: List of orders for a specific store with customer info and store total
  static Future<List<Map<String, dynamic>>> getStoreOrders(
    String storeId,
  ) async {
    try {
      final result = await ApiService.post(
        '/secure/orders/store',
        data: {'store_id': storeId},
      );

      if (result['ok'] == true && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
      return [];
    } catch (e) {
      throw Exception('خطأ في جلب طلبات المتجر: ${e.toString()}');
    }
  }
}
