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

  /// Use points in an order
  /// 
  /// Parameters:
  /// - pointsToUse: عدد النقاط المراد استخدامها
  /// - orderId: معرف الطلب (اختياري)
  /// 
  /// Returns: Map with points usage confirmation
  static Future<Map<String, dynamic>> usePoints({
    required int pointsToUse,
    String? orderId,
  }) async {
    try {
      debugPrint('[PointsService] Using $pointsToUse points');
      
      final response = await ApiService.post(
        '/secure/points/use',
        data: {
          'points': pointsToUse,
          if (orderId != null) 'order_id': orderId,
        },
      );

      if (response['ok'] == true) {
        return {
          'points_used': response['data']?['points_used'],
          'discount_amount': response['data']?['discount_amount'],
          'remaining_balance': response['data']?['remaining_balance'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل استخدام النقاط');
      }
    } catch (e) {
      debugPrint('[PointsService] Error using points: $e');
      rethrow;
    }
  }

  /// Get points transactions history
  /// 
  /// Parameters:
  /// - limit: عدد المعاملات (افتراضي: 50)
  /// 
  /// Returns: List of points transactions
  static Future<List<Map<String, dynamic>>> getTransactions({
    int limit = 50,
  }) async {
    try {
      debugPrint('[PointsService] Fetching points transactions');
      
      final response = await ApiService.get(
        '/secure/points/transactions?limit=$limit',
      );

      if (response['ok'] == true) {
        return List<Map<String, dynamic>>.from(
          response['data']?['transactions'] ?? [],
        );
      } else {
        throw Exception(response['message'] ?? 'فشل جلب معاملات النقاط');
      }
    } catch (e) {
      debugPrint('[PointsService] Error fetching transactions: $e');
      rethrow;
    }
  }
}
