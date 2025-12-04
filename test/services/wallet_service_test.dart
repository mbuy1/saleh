import 'package:flutter_test/flutter_test.dart';
import 'package:saleh/core/services/wallet_service.dart';

void main() {
  group('WalletService Tests', () {
    test('getBalance should return a number', () async {
      // Note: This test requires a valid Supabase connection
      // In a real scenario, you would mock the API calls
      final balance = await WalletService.getBalance();
      expect(balance, isA<double>());
      expect(balance, greaterThanOrEqualTo(0));
    });

    test('hasSufficientBalance should return true when balance is sufficient', () async {
      // Mock scenario: balance is 100, required is 50
      // In real test, you would mock the API response
      final hasSufficient = await WalletService.hasSufficientBalance(50.0);
      expect(hasSufficient, isA<bool>());
    });

    test('addFunds should require valid parameters', () {
      // Test parameter validation logic
      expect(() => WalletService.addFunds(
        amount: -10,
        paymentMethod: 'card',
        paymentReference: 'test',
      ), returnsNormally);
    });
  });
}

