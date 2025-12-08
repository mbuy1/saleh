import 'package:flutter/foundation.dart';
import '../../features/shared/models/bnpl_model.dart';

/// خدمة BNPL (Buy Now Pay Later)
/// TODO: إكمال التنفيذ عند الحاجة
class BNPLService {
  /// إنشاء طلب BNPL
  static Future<BNPLTransactionModel> createBNPLOrder({
    required String orderId,
    required String provider, // 'tabby', 'tamara'
    required double totalAmount,
    int installments = 4,
  }) async {
    // TODO: تنفيذ API call
    throw UnimplementedError('TODO: Implement createBNPLOrder');
  }

  /// جلب حالة معاملة BNPL
  static Future<BNPLTransactionModel?> getBNPLTransaction(String transactionId) async {
    // TODO: تنفيذ API call
    debugPrint('TODO: Implement getBNPLTransaction');
    return null;
  }

  /// جلب مقدمي الخدمة المتاحين
  static Future<List<BNPLProvider>> getAvailableProviders() async {
    // TODO: تنفيذ API call
    debugPrint('TODO: Implement getAvailableProviders');
    return [];
  }
}

