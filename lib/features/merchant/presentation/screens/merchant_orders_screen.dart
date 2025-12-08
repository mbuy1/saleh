import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/order_service.dart';
import '../../../../core/session/store_session.dart';
import 'merchant_order_details_screen.dart';
import '../../../auth/data/auth_repository.dart';

class MerchantOrdersScreen extends StatefulWidget {
  const MerchantOrdersScreen({super.key});

  @override
  State<MerchantOrdersScreen> createState() => _MerchantOrdersScreenState();
}

class _MerchantOrdersScreenState extends State<MerchantOrdersScreen> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    _loadStoreAndOrders();
  }

  Future<void> _loadStoreAndOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await AuthRepository.getUserId();
      if (userId == null || !mounted) return;

      // جلب store_id من StoreSession Provider
      final storeSession = context.read<StoreSession>();
      final storeId = storeSession.storeId;

      if (storeId == null || storeId.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لم يتم العثور على متجر لهذا الحساب. يرجى إنشاء متجر أولاً'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      _storeId = storeId;

      // جلب طلبات المتجر
      final orders = await OrderService.getStoreOrders(_storeId!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات المتجر')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadStoreAndOrders,
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
    final storeTotal = (order['store_total'] as num?)?.toDouble() ?? 0;
    final createdAt = order['created_at'] as String?;
    final customerInfo = order['user_profiles'] as Map<String, dynamic>?;
    final customerName = customerInfo?['display_name'] as String?;
    final formattedOrderId = _formatOrderId(orderId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: const Icon(Icons.receipt_long, color: Colors.blue, size: 32),
        title: Text('طلب #$formattedOrderId'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (customerName != null) Text('العميل: $customerName'),
            if (createdAt != null) Text('تاريخ: ${createdAt.substring(0, 10)}'),
            Text(
              '${storeTotal.toStringAsFixed(2)} ر.س (منتجات متجري)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
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
              builder: (context) => MerchantOrderDetailsScreen(
                orderId: orderId,
                storeId: _storeId!,
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatOrderId(String? orderId) {
    if (orderId == null) return 'غير معروف';
    return orderId.length > 8 ? orderId.substring(orderId.length - 8) : orderId;
  }
}
