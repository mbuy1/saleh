import 'package:flutter_test/flutter_test.dart';
import 'package:saleh/core/services/points_service.dart';

void main() {
  group('PointsService Tests', () {
    test('pointsToSAR should convert correctly', () {
      expect(PointsService.pointsToSAR(10), equals(1.0));
      expect(PointsService.pointsToSAR(100), equals(10.0));
      expect(PointsService.pointsToSAR(0), equals(0.0));
    });

    test('sarToPoints should convert correctly', () {
      expect(PointsService.sarToPoints(1.0), equals(10));
      expect(PointsService.sarToPoints(10.0), equals(100));
      expect(PointsService.sarToPoints(0.0), equals(0));
    });

    test('getBalance should return a number', () async {
      // Note: This test requires a valid Supabase connection
      // In a real scenario, you would mock the API calls
      final balance = await PointsService.getBalance();
      expect(balance, isA<int>());
      expect(balance, greaterThanOrEqualTo(0));
    });

    test('hasSufficientPoints should return boolean', () async {
      // Mock scenario
      final hasSufficient = await PointsService.hasSufficientPoints(100);
      expect(hasSufficient, isA<bool>());
    });
  });
}

