import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

/// Payment Repository - يتعامل مع بوابة الدفع
class PaymentRepository {
  final ApiService _apiService;

  PaymentRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// الحصول على باقات النقاط
  Future<List<PointsPackage>> getPackages() async {
    try {
      final response = await _apiService.get('/payments/packages');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final packages = data['packages'] as List;
        return packages.map((p) => PointsPackage.fromJson(p)).toList();
      }

      throw Exception('فشل في جلب الباقات');
    } catch (e) {
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  /// إنشاء نية دفع
  Future<PaymentIntent> createPaymentIntent({required String packageId}) async {
    try {
      final response = await _apiService.post(
        '/payments/create-intent',
        body: {'package_id': packageId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PaymentIntent.fromJson(data);
      }

      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(errorData?['message'] ?? 'فشل في إنشاء طلب الدفع');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ أثناء إنشاء طلب الدفع');
    }
  }

  /// الحصول على حالة الدفع
  Future<PaymentStatus> getPaymentStatus({required String paymentId}) async {
    try {
      final response = await _apiService.get('/payments/status/$paymentId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PaymentStatus.fromJson(data['payment']);
      }

      throw Exception('فشل في جلب حالة الدفع');
    } catch (e) {
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  /// الحصول على سجل المدفوعات
  Future<List<PaymentRecord>> getPaymentHistory() async {
    try {
      final response = await _apiService.get('/payments/history');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final payments = data['payments'] as List;
        return payments.map((p) => PaymentRecord.fromJson(p)).toList();
      }

      throw Exception('فشل في جلب سجل المدفوعات');
    } catch (e) {
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  /// محاكاة الدفع (للتجربة)
  Future<SimulationResult> simulatePayment({required String packageId}) async {
    try {
      final response = await _apiService.post(
        '/payments/simulate',
        body: {'package_id': packageId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return SimulationResult.fromJson(data);
      }

      final errorData = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(errorData?['message'] ?? 'فشل في المحاكاة');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ أثناء المحاكاة');
    }
  }
}

// ============================================================================
// Models
// ============================================================================

class PointsPackage {
  final String id;
  final int points;
  final int bonus;
  final int totalPoints;
  final double price;
  final String currency;
  final String pricePerPoint;

  PointsPackage({
    required this.id,
    required this.points,
    required this.bonus,
    required this.totalPoints,
    required this.price,
    required this.currency,
    required this.pricePerPoint,
  });

  factory PointsPackage.fromJson(Map<String, dynamic> json) {
    return PointsPackage(
      id: json['id'] as String,
      points: json['points'] as int,
      bonus: json['bonus'] as int,
      totalPoints: json['totalPoints'] as int,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      pricePerPoint: json['pricePerPoint'] as String? ?? '0.00',
    );
  }
}

class PaymentIntent {
  final String paymentId;
  final String invoiceId;
  final String invoiceUrl;
  final double amount;
  final String currency;
  final int points;
  final int bonus;
  final int totalPoints;

  PaymentIntent({
    required this.paymentId,
    required this.invoiceId,
    required this.invoiceUrl,
    required this.amount,
    required this.currency,
    required this.points,
    required this.bonus,
    required this.totalPoints,
  });

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    final package = json['package'] as Map<String, dynamic>?;
    return PaymentIntent(
      paymentId: json['payment_id'] as String,
      invoiceId: json['invoice_id'] as String,
      invoiceUrl: json['invoice_url'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      points: package?['points'] as int? ?? 0,
      bonus: package?['bonus'] as int? ?? 0,
      totalPoints: package?['total'] as int? ?? 0,
    );
  }
}

class PaymentStatus {
  final String id;
  final String status;
  final double amount;
  final String currency;
  final int? points;
  final DateTime createdAt;
  final DateTime? completedAt;

  PaymentStatus({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    this.points,
    required this.createdAt,
    this.completedAt,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      id: json['id'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      points: json['points'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';
}

class PaymentRecord {
  final String id;
  final String status;
  final double amount;
  final String currency;
  final int? points;
  final String description;
  final DateTime createdAt;
  final DateTime? completedAt;

  PaymentRecord({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    this.points,
    required this.description,
    required this.createdAt,
    this.completedAt,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: json['id'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      points: json['points'] as int?,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }
}

class SimulationResult {
  final bool success;
  final String message;
  final int pointsAdded;

  SimulationResult({
    required this.success,
    required this.message,
    required this.pointsAdded,
  });

  factory SimulationResult.fromJson(Map<String, dynamic> json) {
    return SimulationResult(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      pointsAdded: json['points_added'] as int? ?? 0,
    );
  }
}

// ============================================================================
// Providers
// ============================================================================

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository();
});

final pointsPackagesProvider = FutureProvider<List<PointsPackage>>((ref) async {
  final repository = ref.read(paymentRepositoryProvider);
  return repository.getPackages();
});

final paymentHistoryProvider = FutureProvider<List<PaymentRecord>>((ref) async {
  final repository = ref.read(paymentRepositoryProvider);
  return repository.getPaymentHistory();
});
