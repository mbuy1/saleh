import 'package:flutter_test/flutter_test.dart';
import 'package:saleh/core/services/order_service.dart';

void main() {
  group('OrderService Tests', () {
    test('calculateOrderSummary should calculate correctly', () {
      final items = [
        {'price': 100.0, 'quantity': 2},
        {'price': 50.0, 'quantity': 1},
      ];

      final summary = OrderService.calculateOrderSummary(
        items: items,
        pointsToUse: 10,
        couponDiscount: 5.0,
      );

      expect(summary['subtotal'], equals(250.0));
      expect(summary['pointsDiscount'], equals(1.0)); // 10 points * 0.1
      expect(summary['couponDiscount'], equals(5.0));
      expect(summary['total'], equals(244.0));
    });

    test('calculateOrderSummary should handle empty items', () {
      final summary = OrderService.calculateOrderSummary(
        items: [],
      );

      expect(summary['subtotal'], equals(0.0));
      expect(summary['total'], equals(0.0));
    });

    test('validateCart should return false for empty cart', () async {
      final isValid = await OrderService.validateCart([]);
      expect(isValid, false);
    });

    test('validateCart should return true for valid cart', () async {
      final items = [
        {'product_id': 'test-id', 'quantity': 1, 'price': 100.0},
      ];
      final isValid = await OrderService.validateCart(items);
      expect(isValid, true);
    });
  });
}

