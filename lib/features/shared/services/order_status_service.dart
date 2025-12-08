import '../../../core/services/api_service.dart';
import '../../../core/services/logger_service.dart';
import '../../auth/data/auth_repository.dart';

/// Order Status Types
enum OrderStatus {
  pending('pending', 'قيد الانتظار'),
  confirmed('confirmed', 'تم التأكيد'),
  preparing('preparing', 'قيد التحضير'),
  ready('ready', 'جاهز'),
  outForDelivery('out_for_delivery', 'في الطريق'),
  delivered('delivered', 'تم التسليم'),
  cancelled('cancelled', 'ملغي');

  const OrderStatus(this.value, this.arabicName);
  final String value;
  final String arabicName;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

/// Order Status History Entry
class OrderStatusHistory {
  final String id;
  final String orderId;
  final OrderStatus status;
  final String? notes;
  final String? changedBy;
  final DateTime createdAt;

  OrderStatusHistory({
    required this.id,
    required this.orderId,
    required this.status,
    this.notes,
    this.changedBy,
    required this.createdAt,
  });

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistory(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      status: OrderStatus.fromString(json['status'] as String),
      notes: json['notes'] as String?,
      changedBy: json['changed_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Order Status Service
class OrderStatusService {
  /// Update order status
  ///
  /// Only merchants can update status for their orders
  static Future<bool> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    String? notes,
  }) async {
    try {
      logger.info(
        'Updating order $orderId status to ${newStatus.value}',
        tag: 'OrderStatus',
      );

      final userId = await AuthRepository.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Call Worker API to update order status and create history entry
      final response = await ApiService.put(
        '/secure/orders/$orderId/status',
        data: {
          'status': newStatus.value,
          'notes': notes,
        },
      );

      if (response['ok'] == true) {
        logger.info('Order status updated successfully', tag: 'OrderStatus');
        return true;
      } else {
        throw Exception(response['message'] ?? response['error'] ?? 'Failed to update order status');
      }
    } catch (e, stackTrace) {
      logger.error(
        'Failed to update order status',
        error: e,
        stackTrace: stackTrace,
        tag: 'OrderStatus',
      );
      return false;
    }
  }

  /// Get order status history
  static Future<List<OrderStatusHistory>> getOrderStatusHistory(
    String orderId,
  ) async {
    try {
      final response = await ApiService.get('/secure/orders/$orderId/status-history');

      if (response['ok'] == true && response['data'] != null) {
        final historyList = response['data'] as List;
        return historyList.map((json) => OrderStatusHistory.fromJson(json)).toList();
      } else {
        logger.warning(
          'Failed to fetch order status history: ${response['message'] ?? response['error']}',
          tag: 'OrderStatus',
        );
        return [];
      }
    } catch (e, stackTrace) {
      logger.error(
        'Failed to fetch order status history',
        error: e,
        stackTrace: stackTrace,
        tag: 'OrderStatus',
      );
      return [];
    }
  }

  /// Get current order status
  static Future<OrderStatus?> getCurrentOrderStatus(String orderId) async {
    try {
      final response = await ApiService.get('/secure/orders/$orderId/status');

      if (response['ok'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return OrderStatus.fromString(data['status'] as String);
      } else {
        logger.warning(
          'Failed to fetch current order status: ${response['message'] ?? response['error']}',
          tag: 'OrderStatus',
        );
        return null;
      }
    } catch (e) {
      logger.error(
        'Failed to fetch current order status',
        error: e,
        tag: 'OrderStatus',
      );
      return null;
    }
  }

  /// Cancel order (customer or merchant)
  static Future<bool> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    try {
      logger.info('Cancelling order $orderId', tag: 'OrderStatus');

      // Check current status - can only cancel if not delivered
      final currentStatus = await getCurrentOrderStatus(orderId);
      if (currentStatus == OrderStatus.delivered) {
        throw Exception('لا يمكن إلغاء طلب تم تسليمه');
      }

      // Call Worker API to handle cancellation + refund
      final response = await ApiService.post(
        '/secure/orders/cancel',
        data: {'order_id': orderId, 'reason': reason},
      );

      if (response['ok'] == true) {
        logger.info('Order cancelled successfully', tag: 'OrderStatus');
        return true;
      } else {
        throw Exception(response['error'] ?? 'فشل إلغاء الطلب');
      }
    } catch (e, stackTrace) {
      logger.error(
        'Failed to cancel order',
        error: e,
        stackTrace: stackTrace,
        tag: 'OrderStatus',
      );
      rethrow;
    }
  }

  /// Get status icon
  static String getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return '⏳';
      case OrderStatus.confirmed:
        return '✅';
      case OrderStatus.preparing:
        return '👨‍🍳';
      case OrderStatus.ready:
        return '📦';
      case OrderStatus.outForDelivery:
        return '🚚';
      case OrderStatus.delivered:
        return '🎉';
      case OrderStatus.cancelled:
        return '❌';
    }
  }

  /// Get status color
  static int getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0xFFFFA726; // Orange
      case OrderStatus.confirmed:
        return 0xFF42A5F5; // Blue
      case OrderStatus.preparing:
        return 0xFF9C27B0; // Purple
      case OrderStatus.ready:
        return 0xFF66BB6A; // Green
      case OrderStatus.outForDelivery:
        return 0xFF26C6DA; // Cyan
      case OrderStatus.delivered:
        return 0xFF4CAF50; // Success Green
      case OrderStatus.cancelled:
        return 0xFFEF5350; // Red
    }
  }
}
