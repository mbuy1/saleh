import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// Order Service
/// Handles all order-related operations via API Gateway
class OrderService {
  /// Create new order
  static Future<Map<String, dynamic>?> createOrder({
    required List<Map<String, dynamic>> cartItems,
    required String deliveryAddress,
    required String paymentMethod,
    int? pointsToUse,
    String? couponCode,
  }) async {
    try {
      // Convert cart items to products format
      final products = cartItems.map((item) {
        return {
          'product_id': item['product_id'] ?? item['id'],
          'quantity': item['quantity'] ?? 1,
          'price': (item['price'] as num).toDouble(),
        };
      }).toList();

      final result = await ApiService.createOrder(
        products: products,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        pointsToUse: pointsToUse,
        couponCode: couponCode,
      );

      return result;
    } catch (e) {
      debugPrint('Error creating order: $e');
      return null;
    }
  }

  /// Calculate order summary
  static Map<String, double> calculateOrderSummary({
    required List<Map<String, dynamic>> items,
    int? pointsToUse,
    double? couponDiscount,
  }) {
    double subtotal = 0;

    for (var item in items) {
      final price = (item['price'] as num).toDouble();
      final quantity = (item['quantity'] as num).toInt();
      subtotal += price * quantity;
    }

    // Points discount (1 point = 0.1 SAR)
    final pointsDiscount = pointsToUse != null ? pointsToUse * 0.1 : 0.0;

    // Coupon discount
    final coupon = couponDiscount ?? 0.0;

    // Total
    final total = subtotal - pointsDiscount - coupon;

    return {
      'subtotal': subtotal,
      'pointsDiscount': pointsDiscount,
      'couponDiscount': coupon,
      'total': total > 0 ? total : 0,
    };
  }

  /// Validate cart before checkout
  static Future<bool> validateCart(List<Map<String, dynamic>> items) async {
    if (items.isEmpty) {
      return false;
    }

    // Additional validation can be added here
    // For example: check stock availability via API

    return true;
  }

  /// Get customer orders via API Gateway
  static Future<List<Map<String, dynamic>>> getCustomerOrders() async {
    try {
      final result = await ApiService.get('/secure/orders');
      if (result['orders'] != null) {
        return List<Map<String, dynamic>>.from(result['orders']);
      }
      return [];
    } catch (e) {
      debugPrint('Error getting customer orders: $e');
      return [];
    }
  }

  /// Get order details via API Gateway
  static Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      final result = await ApiService.post(
        '/secure/orders/details',
        data: {'order_id': orderId},
      );
      return result;
    } catch (e) {
      debugPrint('Error getting order details: $e');
      return null;
    }
  }

  /// Get store orders for merchant via API Gateway
  static Future<List<Map<String, dynamic>>> getStoreOrders(
    String storeId,
  ) async {
    try {
      final result = await ApiService.post(
        '/secure/orders/store',
        data: {'store_id': storeId},
      );
      if (result['orders'] != null) {
        return List<Map<String, dynamic>>.from(result['orders']);
      }
      return [];
    } catch (e) {
      debugPrint('Error getting store orders: $e');
      return [];
    }
  }
}
