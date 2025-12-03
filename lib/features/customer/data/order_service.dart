import '../../../../core/supabase_client.dart';
import '../../../../core/permissions_helper.dart';
import 'cart_service.dart';

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

    // حساب المجموع الكلي
    final total = await CartService.getCartTotal();

    // إنشاء طلب جديد
    final order = await supabaseClient
        .from('orders')
        .insert({
          'customer_id': user.id,
          'total_amount': total,
          'status': 'pending', // حالة أولية: في الانتظار
        })
        .select('id')
        .single();

    final orderId = order['id'] as String;

    // إنشاء order_items لكل عنصر في السلة
    for (var cartItem in cartItems) {
      final product = cartItem['products'] as Map<String, dynamic>?;
      if (product != null) {
        await supabaseClient.from('order_items').insert({
          'order_id': orderId,
          'product_id': product['id'],
          'quantity': cartItem['quantity'],
          'price': product['price'], // حفظ السعر وقت الطلب
        });
      }
    }

    // حذف عناصر السلة بعد تحويلها إلى طلب
    // (لا نحتاج تحديث status لأن جدول carts لا يحتوي على status)
    await supabaseClient
        .from('cart_items')
        .delete()
        .eq('cart_id', cartId);

    return orderId;
  }

  /// جلب طلبات العميل
  /// 
  /// Returns: List of orders
  static Future<List<Map<String, dynamic>>> getCustomerOrders() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      return [];
    }

    final response = await supabaseClient
        .from('orders')
        .select()
        .eq('customer_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// جلب تفاصيل طلب مع order_items
  /// 
  /// Returns: Order with order_items and products
  static Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final response = await supabaseClient
        .from('orders')
        .select('''
          *,
          order_items (
            *,
            products (
              id,
              name,
              description,
              price
            )
          )
        ''')
        .eq('id', orderId)
        .single();

    return response;
  }

  /// جلب طلبات متجر معين (للتاجر)
  /// 
  /// Returns: List of orders for a specific store with customer info and store total
  static Future<List<Map<String, dynamic>>> getStoreOrders(String storeId) async {
    // جلب طلبات المتجر من خلال order_items -> products -> store_id
    final response = await supabaseClient
        .from('order_items')
        .select('''
          *,
          orders (*),
          products (
            id,
            name,
            store_id
          )
        ''')
        .eq('products.store_id', storeId);

    // تجميع الطلبات حسب order_id
    final Map<String, Map<String, dynamic>> ordersMap = {};
    final Set<String> customerIds = {};
    
    for (var item in response) {
      final order = item['orders'] as Map<String, dynamic>?;
      if (order != null) {
        final orderId = order['id'] as String;
        final customerId = order['customer_id'] as String?;
        if (customerId != null) {
          customerIds.add(customerId);
        }
        
        if (!ordersMap.containsKey(orderId)) {
          ordersMap[orderId] = {
            ...order,
            'items': <Map<String, dynamic>>[],
            'store_total': 0.0, // سيتم حسابه لاحقاً
          };
        }
        ordersMap[orderId]!['items'].add(item);
      }
    }

    // جلب معلومات العملاء
    final Map<String, String> customerNames = {};
    if (customerIds.isNotEmpty) {
      for (var customerId in customerIds) {
        try {
          final customerResponse = await supabaseClient
              .from('user_profiles')
              .select('display_name')
              .eq('id', customerId)
              .maybeSingle();
          if (customerResponse != null) {
            customerNames[customerId] = customerResponse['display_name'] ?? '';
          }
        } catch (e) {
          // تجاهل الخطأ
        }
      }
    }

    // حساب المجموع الكلي للمنتجات من هذا المتجر فقط لكل طلب
    // وإضافة اسم العميل
    for (var orderEntry in ordersMap.entries) {
      double storeTotal = 0.0;
      for (var item in orderEntry.value['items'] as List<dynamic>) {
        final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
        final price = (item['price'] as num?)?.toDouble() ?? 0;
        storeTotal += quantity * price;
      }
      orderEntry.value['store_total'] = storeTotal;
      
      // إضافة اسم العميل
      final customerId = orderEntry.value['customer_id'] as String?;
      if (customerId != null && customerNames.containsKey(customerId)) {
        orderEntry.value['user_profiles'] = {
          'display_name': customerNames[customerId],
        };
      }
    }

    return ordersMap.values.toList();
  }
}

