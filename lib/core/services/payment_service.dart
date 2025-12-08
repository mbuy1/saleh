import 'package:flutter/foundation.dart';
import 'api_service.dart';

/// خدمة الدفع
/// TODO: إكمال التنفيذ عند الحاجة
/// المفاتيح السرية يجب أن تكون في Worker Secrets، وليس هنا
class PaymentService {
  /// إنشاء جلسة دفع
  /// 
  /// Parameters:
  /// - orderId: رقم الطلب
  /// - amount: المبلغ
  /// - currency: العملة (SAR, USD, etc.)
  /// - paymentMethod: طريقة الدفع (card, wallet, cash, tap, tabby, tamara)
  /// 
  /// Returns: Map with payment session details
  static Future<Map<String, dynamic>> createPaymentSession({
    required String orderId,
    required double amount,
    String currency = 'SAR',
    required String paymentMethod,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      debugPrint('[PaymentService] Creating payment session for order: $orderId');
      
      final response = await ApiService.post(
        '/secure/payment/create-session',
        data: {
          'order_id': orderId,
          'amount': amount,
          'currency': currency,
          'payment_method': paymentMethod,
          if (metadata != null) 'metadata': metadata,
        },
      );

      if (response['ok'] == true) {
        return {
          'session_id': response['data']?['session_id'],
          'payment_url': response['data']?['payment_url'],
          'payment_intent_id': response['data']?['payment_intent_id'],
          'client_secret': response['data']?['client_secret'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل إنشاء جلسة الدفع');
      }
    } catch (e) {
      debugPrint('[PaymentService] Error creating payment session: $e');
      rethrow;
    }
  }

  /// تأكيد الدفع
  /// 
  /// Parameters:
  /// - sessionId: معرف جلسة الدفع
  /// - paymentIntentId: معرف نية الدفع (للبطاقات)
  /// 
  /// Returns: Map with payment confirmation
  static Future<Map<String, dynamic>> confirmPayment({
    required String sessionId,
    String? paymentIntentId,
  }) async {
    try {
      debugPrint('[PaymentService] Confirming payment: $sessionId');
      
      final response = await ApiService.post(
        '/secure/payment/confirm',
        data: {
          'session_id': sessionId,
          if (paymentIntentId != null) 'payment_intent_id': paymentIntentId,
        },
      );

      if (response['ok'] == true) {
        return {
          'payment_id': response['data']?['payment_id'],
          'status': response['data']?['status'],
          'transaction_id': response['data']?['transaction_id'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل تأكيد الدفع');
      }
    } catch (e) {
      debugPrint('[PaymentService] Error confirming payment: $e');
      rethrow;
    }
  }

  /// جلب حالة الدفع
  /// 
  /// Parameters:
  /// - paymentId: معرف الدفع
  /// 
  /// Returns: Map with payment status
  static Future<Map<String, dynamic>> getPaymentStatus({
    required String paymentId,
  }) async {
    try {
      debugPrint('[PaymentService] Getting payment status: $paymentId');
      
      final response = await ApiService.get(
        '/secure/payment/status/$paymentId',
      );

      if (response['ok'] == true) {
        return {
          'status': response['data']?['status'],
          'amount': response['data']?['amount'],
          'currency': response['data']?['currency'],
          'payment_method': response['data']?['payment_method'],
          'transaction_id': response['data']?['transaction_id'],
          'created_at': response['data']?['created_at'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل جلب حالة الدفع');
      }
    } catch (e) {
      debugPrint('[PaymentService] Error getting payment status: $e');
      rethrow;
    }
  }

  /// جلب طرق الدفع المتاحة
  /// 
  /// Returns: List of available payment methods
  static Future<List<Map<String, dynamic>>> getAvailablePaymentMethods() async {
    try {
      debugPrint('[PaymentService] Fetching available payment methods');
      
      final response = await ApiService.get(
        '/public/payment/methods',
        requireAuth: false,
      );

      if (response['ok'] == true) {
        return List<Map<String, dynamic>>.from(
          response['data']?['methods'] ?? [],
        );
      } else {
        throw Exception(response['message'] ?? 'فشل جلب طرق الدفع');
      }
    } catch (e) {
      debugPrint('[PaymentService] Error fetching payment methods: $e');
      rethrow;
    }
  }

  /// إلغاء الدفع
  /// 
  /// Parameters:
  /// - paymentId: معرف الدفع
  /// 
  /// Returns: Map with cancellation confirmation
  static Future<Map<String, dynamic>> cancelPayment({
    required String paymentId,
  }) async {
    try {
      debugPrint('[PaymentService] Cancelling payment: $paymentId');
      
      final response = await ApiService.post(
        '/secure/payment/cancel',
        data: {
          'payment_id': paymentId,
        },
      );

      if (response['ok'] == true) {
        return {
          'status': response['data']?['status'],
          'refund_id': response['data']?['refund_id'],
        };
      } else {
        throw Exception(response['message'] ?? 'فشل إلغاء الدفع');
      }
    } catch (e) {
      debugPrint('[PaymentService] Error cancelling payment: $e');
      rethrow;
    }
  }
}

