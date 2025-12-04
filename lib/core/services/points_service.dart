import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// Points Service
/// Handles all points-related operations via API Gateway
class PointsService {
  /// Get current user's points balance
  static Future<int> getBalance() async {
    try {
      final points = await ApiService.getPoints();
      if (points != null) {
        return (points['balance'] as num).toInt();
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting points balance: $e');
      return 0;
    }
  }

  /// Get full points account details
  static Future<Map<String, dynamic>?> getPointsDetails() async {
    try {
      return await ApiService.getPoints();
    } catch (e) {
      debugPrint('Error getting points details: $e');
      return null;
    }
  }

  /// Calculate points value in SAR (1 point = 0.1 SAR)
  static double pointsToSAR(int points) {
    return points * 0.1;
  }

  /// Calculate SAR to points (1 SAR = 10 points)
  static int sarToPoints(double sar) {
    return (sar * 10).round();
  }

  /// Check if user has sufficient points
  static Future<bool> hasSufficientPoints(int requiredPoints) async {
    final balance = await getBalance();
    return balance >= requiredPoints;
  }
}
