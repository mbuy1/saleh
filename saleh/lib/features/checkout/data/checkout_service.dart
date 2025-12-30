import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

/// Checkout Payment Service - دفع الطلبات للمتاجر
///
/// يتعامل مع نظام الدفع المتعدد البوابات:
/// - Moyasar
/// - Tap
/// - PayTabs
/// - HyperPay
class CheckoutService {
  final ApiService _apiService;

  CheckoutService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  /// إنشاء دفعة جديدة للطلب
  Future<CheckoutPaymentResult> createPayment({
    required String merchantId,
    required String orderId,
    required int amount, // بالهللة
    String currency = 'SAR',
    String? description,
    CustomerInfo? customer,
    String? preferredGateway, // اختياري - البوابة المفضلة
    String? successUrl,
    String? failureUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final body = {
        'merchant_id': merchantId,
        'order_id': orderId,
        'amount': amount,
        'currency': currency,
        if (description != null) 'description': description,
        if (customer != null) 'customer': customer.toJson(),
        if (preferredGateway != null) 'gateway': preferredGateway,
        if (successUrl != null) 'success_url': successUrl,
        if (failureUrl != null) 'failure_url': failureUrl,
        if (metadata != null) 'metadata': metadata,
      };

      final response = await _apiService.post('/pay/create', body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          return CheckoutPaymentResult.fromJson(data['data']);
        }

        throw Exception(data['error'] ?? 'فشل في إنشاء الدفعة');
      }

      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(errorData?['error'] ?? 'فشل في إنشاء طلب الدفع');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ أثناء إنشاء طلب الدفع');
    }
  }

  /// الحصول على حالة الدفع
  Future<CheckoutPaymentStatus> getPaymentStatus(String transactionId) async {
    try {
      final response = await _apiService.get('/pay/status/$transactionId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          return CheckoutPaymentStatus.fromJson(data['data']);
        }

        throw Exception(data['error'] ?? 'فشل في جلب حالة الدفع');
      }

      throw Exception('فشل في جلب حالة الدفع');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  /// طلب استرجاع
  Future<RefundResult> requestRefund({
    required String transactionId,
    int? amount, // للاسترجاع الجزئي
    String? reason,
  }) async {
    try {
      final body = {
        'transaction_id': transactionId,
        if (amount != null) 'amount': amount,
        if (reason != null) 'reason': reason,
      };

      final response = await _apiService.post('/pay/refund', body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          return RefundResult.fromJson(data['data']);
        }

        throw Exception(data['error'] ?? 'فشل في الاسترجاع');
      }

      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(errorData?['error'] ?? 'فشل في طلب الاسترجاع');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ أثناء طلب الاسترجاع');
    }
  }

  /// الحصول على البوابات المتاحة
  Future<List<PaymentGatewayInfo>> getAvailableGateways() async {
    try {
      final response = await _apiService.get('/pay/gateways');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          final gateways = data['data'] as List;
          return gateways.map((g) => PaymentGatewayInfo.fromJson(g)).toList();
        }

        throw Exception('فشل في جلب البوابات');
      }

      throw Exception('فشل في جلب البوابات المتاحة');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }
}

// ============================================================================
// Models
// ============================================================================

/// معلومات العميل
class CustomerInfo {
  final String? name;
  final String? email;
  final String? phone;

  CustomerInfo({this.name, this.email, this.phone});

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (email != null) 'email': email,
    if (phone != null) 'phone': phone,
  };
}

/// نتيجة إنشاء الدفعة
class CheckoutPaymentResult {
  final String transactionId;
  final String paymentUrl;
  final String gateway;
  final String? expiresAt;

  CheckoutPaymentResult({
    required this.transactionId,
    required this.paymentUrl,
    required this.gateway,
    this.expiresAt,
  });

  factory CheckoutPaymentResult.fromJson(Map<String, dynamic> json) {
    return CheckoutPaymentResult(
      transactionId: json['transaction_id'] as String,
      paymentUrl: json['payment_url'] as String,
      gateway: json['gateway'] as String,
      expiresAt: json['expires_at'] as String?,
    );
  }
}

/// حالة الدفع
class CheckoutPaymentStatus {
  final String transactionId;
  final String status;
  final int amount;
  final String currency;
  final String? gateway;
  final DateTime createdAt;

  CheckoutPaymentStatus({
    required this.transactionId,
    required this.status,
    required this.amount,
    required this.currency,
    this.gateway,
    required this.createdAt,
  });

  factory CheckoutPaymentStatus.fromJson(Map<String, dynamic> json) {
    return CheckoutPaymentStatus(
      transactionId: json['transaction_id'] as String,
      status: json['status'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String? ?? 'SAR',
      gateway: json['gateway'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  bool get isPaid => status == 'paid' || status == 'captured';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';
  bool get isRefunded => status == 'refunded';
  bool get isCancelled => status == 'cancelled';

  /// الحالة بالعربي
  String get statusAr {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'authorized':
        return 'تم التفويض';
      case 'paid':
      case 'captured':
        return 'تم الدفع';
      case 'failed':
        return 'فشل';
      case 'refunded':
        return 'مُسترجع';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }
}

/// نتيجة الاسترجاع
class RefundResult {
  final String refundId;
  final int amount;
  final String status;

  RefundResult({
    required this.refundId,
    required this.amount,
    required this.status,
  });

  factory RefundResult.fromJson(Map<String, dynamic> json) {
    return RefundResult(
      refundId: json['refund_id'] as String,
      amount: json['amount'] as int,
      status: json['status'] as String,
    );
  }
}

/// معلومات بوابة الدفع
class PaymentGatewayInfo {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String website;
  final List<String> supportedMethods;
  final List<String> countries;

  PaymentGatewayInfo({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.website,
    required this.supportedMethods,
    required this.countries,
  });

  factory PaymentGatewayInfo.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      description: json['description'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      website: json['website'] as String? ?? '',
      supportedMethods:
          (json['supportedMethods'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      countries:
          (json['countries'] as List?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

// ============================================================================
// Providers
// ============================================================================

final checkoutServiceProvider = Provider<CheckoutService>((ref) {
  return CheckoutService();
});

final availableGatewaysProvider = FutureProvider<List<PaymentGatewayInfo>>((
  ref,
) async {
  final service = ref.read(checkoutServiceProvider);
  return service.getAvailableGateways();
});

/// Notifier for payment status - يتم تحديثه عند إنشاء دفعة
class PaymentStatusNotifier extends Notifier<CheckoutPaymentStatus?> {
  @override
  CheckoutPaymentStatus? build() => null;

  void update(CheckoutPaymentStatus? status) {
    state = status;
  }
}

final paymentStatusProvider =
    NotifierProvider<PaymentStatusNotifier, CheckoutPaymentStatus?>(
      PaymentStatusNotifier.new,
    );

/// Notifier for current payment - يتم تحديثه عند إنشاء دفعة
class CurrentPaymentNotifier extends Notifier<CheckoutPaymentResult?> {
  @override
  CheckoutPaymentResult? build() => null;

  void update(CheckoutPaymentResult? payment) {
    state = payment;
  }
}

final currentPaymentProvider =
    NotifierProvider<CurrentPaymentNotifier, CheckoutPaymentResult?>(
      CurrentPaymentNotifier.new,
    );
