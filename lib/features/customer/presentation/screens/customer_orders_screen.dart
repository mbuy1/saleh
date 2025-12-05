import 'package:flutter/material.dart';
import '../../../../core/services/order_service.dart';
import '../../../../shared/widgets/skeleton/skeleton_loader.dart';
import 'customer_order_details_screen.dart';

class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // جلب طلبات العميل من جدول orders
      final orders = await OrderService.getCustomerOrders();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب الطلبات: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'في الانتظار';
      case 'confirmed':
        return 'مؤكد';
      case 'processing':
        return 'قيد المعالجة';
      case 'shipped':
        return 'تم الشحن';
      case 'delivered':
        return 'تم التسليم';
      case 'cancelled':
        return 'ملغي';
      default:
        return status ?? 'غير معروف';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatOrderId(String? orderId) {
    if (orderId == null) return 'غير معروف';
    // عرض آخر 8 أحرف من ID
    return orderId.length > 8 ? orderId.substring(orderId.length - 8) : orderId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'طلباتي',
          header: true,
          child: const Text('طلباتي'),
        ),
      ),
      body: _isLoading
          ? _buildSkeletonLoader()
          : _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ابدأ التسوق الآن',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadOrders,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(_orders[index]);
                },
              ),
            ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderId = order['id'] as String? ?? 'غير معروف';
    final status = order['status'] as String?;
    final totalAmount = (order['total_amount'] as num?)?.toDouble() ?? 0;
    final createdAt = order['created_at'] as String?;
    final formattedOrderId = _formatOrderId(orderId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: const Icon(Icons.receipt_long, color: Colors.blue, size: 32),
        title: Text('طلب #$formattedOrderId'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (createdAt != null) Text('تاريخ: ${createdAt.substring(0, 10)}'),
            Text(
              '${totalAmount.toStringAsFixed(2)} ر.س',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(
                _getStatusText(status),
                style: const TextStyle(fontSize: 11, color: Colors.white),
              ),
              backgroundColor: _getStatusColor(status),
              padding: EdgeInsets.zero,
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          // الانتقال إلى شاشة التفاصيل
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CustomerOrderDetailsScreen(orderId: orderId),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: List.generate(5, (index) => const SkeletonListItem()),
    );
  }
}
