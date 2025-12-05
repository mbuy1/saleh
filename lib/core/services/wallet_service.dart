import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// Wallet Service
/// Handles all wallet-related operations via API Gateway
class WalletService {
  /// Get current user's wallet balance
  static Future<double> getBalance() async {
    try {
      final wallet = await ApiService.getWallet();
      if (wallet != null) {
        return (wallet['balance'] as num).toDouble();
      }
      return 0.0;
    } catch (e) {
      debugPrint('Error getting wallet balance: $e');
      return 0.0;
    }
  }

  /// Get full wallet details
  static Future<Map<String, dynamic>?> getWalletDetails() async {
    try {
      return await ApiService.getWallet();
    } catch (e) {
      debugPrint('Error getting wallet details: $e');
      return null;
    }
  }

  /// Add funds to wallet
  static Future<bool> addFunds({
    required double amount,
    required String paymentMethod,
    required String paymentReference,
  }) async {
    try {
      final result = await ApiService.addWalletFunds(
        amount: amount,
        paymentMethod: paymentMethod,
        paymentReference: paymentReference,
      );
      return result['ok'] == true;
    } catch (e) {
      debugPrint('Error adding wallet funds: $e');
      return false;
    }
  }

  /// Check if user has sufficient balance
  static Future<bool> hasSufficientBalance(double requiredAmount) async {
    final balance = await getBalance();
    return balance >= requiredAmount;
  }

  /// Get wallet transactions
  static Future<List<dynamic>?> getWalletTransactions({
    int limit = 10,
    String walletType = 'customer',
  }) async {
    try {
      final result = await ApiService.post(
        '/secure/wallet/transactions',
        data: {'limit': limit, 'wallet_type': walletType},
      );

      if (result['ok'] == true && result['data'] != null) {
        final data = result['data'];
        return (data is List) ? data : [];
      }
      return [];
    } catch (e) {
      debugPrint('Error getting wallet transactions: $e');
      return null;
    }
  }
}
