import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/supabase_client.dart';
import '../models/product_model.dart';

/// نموذج عنصر السلة من قاعدة البيانات
class CartItemModel {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final ProductModel? product;
  final DateTime createdAt;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.product,
    required this.createdAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      quantity: json['quantity'] as int,
      product: json['products'] != null
          ? ProductModel.fromJson(json['products'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // حساب الإجمالي للعنصر
  double get itemTotal {
    if (product == null) return 0;
    return product!.finalPrice * quantity;
  }
}

/// خدمة سلة التسوق - Cart Service
class CartService {
  /// جلب عناصر السلة للمستخدم الحالي
  static Future<List<CartItemModel>> getCartItems() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('⚠️ المستخدم غير مسجل الدخول');
        return [];
      }

      final result = await ApiService.get('/cart');

      if (result['ok'] == true && result['data'] != null) {
        final data = result['data'];
        final items = (data is List) ? data : [];
        debugPrint('✅ تم جلب ${items.length} عنصر من السلة');

        return items.map((json) {
          // معالجة بيانات المنتج
          final cartJson = Map<String, dynamic>.from(json);
          if (json['products'] != null) {
            final productJson = Map<String, dynamic>.from(json['products']);
            if (json['products']['stores'] != null) {
              productJson['store_name'] = json['products']['stores']['name'];
            }
            if (json['products']['categories'] != null) {
              productJson['category_name'] =
                  json['products']['categories']['name'];
            }
            cartJson['products'] = productJson;
          }
          return CartItemModel.fromJson(cartJson);
        }).toList();
      }

      return [];
    } catch (e) {
      debugPrint('❌ خطأ في جلب عناصر السلة: $e');
      return [];
    }
  }

  /// إضافة منتج للسلة
  static Future<bool> addToCart(
    String productId, {
    int quantity = 1,
    String? storeId,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('⚠️ المستخدم غير مسجل الدخول');
        return false;
      }

      final result = await ApiService.post(
        '/cart',
        data: {
          'product_id': productId,
          'quantity': quantity,
          'store_id': storeId,
        },
      );

      if (result['ok'] == true) {
        debugPrint('✅ تم إضافة المنتج للسلة');
        return true;
      }

      debugPrint('⚠️ فشل إضافة المنتج: ${result['error']}');
      return false;
    } catch (e) {
      debugPrint('❌ خطأ في إضافة المنتج للسلة: $e');
      return false;
    }
  }

  /// تحديث كمية منتج في السلة
  static Future<bool> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        return removeFromCart(cartItemId);
      }

      final result = await ApiService.put(
        '/cart/$cartItemId',
        data: {'quantity': newQuantity},
      );

      if (result['ok'] == true) {
        debugPrint('✅ تم تحديث الكمية');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ خطأ في تحديث الكمية: $e');
      return false;
    }
  }

  /// حذف منتج من السلة
  static Future<bool> removeFromCart(String cartItemId) async {
    try {
      final result = await ApiService.delete('/cart/$cartItemId');

      if (result['ok'] == true) {
        debugPrint('✅ تم حذف المنتج من السلة');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ خطأ في حذف المنتج: $e');
      return false;
    }
  }

  /// مسح السلة بالكامل
  static Future<bool> clearCart() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('⚠️ المستخدم غير مسجل الدخول');
        return false;
      }

      final result = await ApiService.delete('/cart');

      if (result['ok'] == true) {
        debugPrint('✅ تم مسح السلة بالكامل');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ خطأ في مسح السلة: $e');
      return false;
    }
  }

  /// حساب إجمالي السلة
  static double calculateTotal(List<CartItemModel> items) {
    return items.fold(0, (sum, item) => sum + item.itemTotal);
  }

  /// حساب عدد العناصر في السلة
  static int getTotalItems(List<CartItemModel> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
