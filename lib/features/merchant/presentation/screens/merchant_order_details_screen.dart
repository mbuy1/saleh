import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/services/order_service.dart';

class MerchantOrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String storeId;

  const MerchantOrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.storeId,
  });

  @override
  State<MerchantOrderDetailsScreen> createState() =>
      _MerchantOrderDetailsScreenState();
}

class _MerchantOrderDetailsScreenState
    extends State<MerchantOrderDetailsScreen> {
  Map<String, dynamic>? _orderDetails;
  List<Map<String, dynamic>> _storeItems = [];
  double _storeTotal = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // جلب تفاصيل الطلب
      final orderDetails = await OrderService.getOrderDetails(widget.orderId);

      // جلب order_items مع products للمتجر فقط
      final orderItems = orderDetails?['order_items'] as List<dynamic>? ?? [];

      // تصفية العناصر الخاصة بهذا المتجر فقط
      final storeItems = <Map<String, dynamic>>[];
      double storeTotal = 0.0;

      for (var item in orderItems) {
        final product = item['products'] as Map<String, dynamic>?;
        if (product != null && product['store_id'] == widget.storeId) {
          final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
          final price = (item['price'] as num?)?.toDouble() ?? 0;
          storeTotal += quantity * price;
          storeItems.add(item);
        }
      }

      // جلب معلومات العميل
      final customerId = orderDetails?['customer_id'] as String?;
      Map<String, dynamic>? customerInfo;
      if (customerId != null) {
        try {
          final customerResponse = await supabaseClient
              .from('user_profiles')
              .select('display_name')
              .eq('id', customerId)
              .maybeSingle();
          customerInfo = customerResponse;
        } catch (e) {
          // تجاهل الخطأ
        }
      }

      setState(() {
        _orderDetails = orderDetails;
        _storeItems = storeItems;
        _storeTotal = storeTotal;
        if (customerInfo != null) {
          _orderDetails!['customer_name'] = customerInfo['display_name'];
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب تفاصيل الطلب: ${e.toString()}'),
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
    return orderId.length > 8 ? orderId.substring(orderId.length - 8) : orderId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب #${_formatOrderId(widget.orderId)}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orderDetails == null
          ? const Center(
              child: Text(
                'لا توجد تفاصيل',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معلومات الطلب
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_orderDetails!['customer_name'] != null) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'اسم العميل:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _orderDetails!['customer_name'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'حالة الطلب:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Chip(
                                label: Text(
                                  _getStatusText(_orderDetails!['status']),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: _getStatusColor(
                                  _orderDetails!['status'],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'تاريخ الطلب:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _orderDetails!['created_at'] != null
                                    ? _orderDetails!['created_at']
                                          .toString()
                                          .substring(0, 10)
                                    : 'غير متوفر',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // قائمة المنتجات من هذا المتجر فقط
                  const Text(
                    'منتجات متجري:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _storeItems.isEmpty
                      ? const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('لا توجد منتجات من متجري في هذا الطلب'),
                          ),
                        )
                      : Column(
                          children: _storeItems.map((item) {
                            final product =
                                item['products'] as Map<String, dynamic>?;
                            final quantity =
                                (item['quantity'] as num?)?.toInt() ?? 0;
                            final price =
                                (item['price'] as num?)?.toDouble() ?? 0;
                            final total = quantity * price;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag,
                                    color: Colors.grey,
                                  ),
                                ),
                                title: Text(product?['name'] ?? 'منتج'),
                                subtitle: Text(
                                  'الكمية: $quantity × ${price.toStringAsFixed(2)} ر.س',
                                ),
                                trailing: Text(
                                  '${total.toStringAsFixed(2)} ر.س',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 16),
                  // المجموع الكلي للمنتجات من هذا المتجر فقط
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'المجموع (منتجات متجري فقط):',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_storeTotal.toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
