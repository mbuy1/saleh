import 'package:flutter/material.dart';
import '../../../../core/services/order_service.dart';
import '../../../../shared/widgets/skeleton/skeleton_loader.dart';

class CustomerOrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const CustomerOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<CustomerOrderDetailsScreen> createState() =>
      _CustomerOrderDetailsScreenState();
}

class _CustomerOrderDetailsScreenState
    extends State<CustomerOrderDetailsScreen> {
  Map<String, dynamic>? _orderDetails;
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
      final details = await OrderService.getOrderDetails(widget.orderId);
      setState(() {
        _orderDetails = details;
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
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Semantics(
            label: 'رجوع',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonLoader()
          : _orderDetails == null
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
                    'لا توجد تفاصيل',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ],
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
                  // قائمة المنتجات
                  const Text(
                    'المنتجات:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...(_orderDetails!['order_items'] as List<dynamic>?)?.map((
                        item,
                      ) {
                        final product =
                            item['products'] as Map<String, dynamic>?;
                        final quantity =
                            (item['quantity'] as num?)?.toInt() ?? 0;
                        final price = (item['price'] as num?)?.toDouble() ?? 0;
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product?['description'] != null)
                                  Text(
                                    product!['description'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                Text(
                                  'الكمية: $quantity × ${price.toStringAsFixed(2)} ر.س',
                                ),
                              ],
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
                      }).toList() ??
                      [],
                  const SizedBox(height: 16),
                  // المجموع الكلي
                  Card(
                    color: Colors.green[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'المجموع الكلي:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${((_orderDetails!['total_amount'] as num?)?.toDouble() ?? 0).toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
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

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton Order Status
          SkeletonLoader(
            width: 150,
            height: 30,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 24),
          // Skeleton Order Info
          ...List.generate(
            4,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: SkeletonListItem(),
            ),
          ),
          const SizedBox(height: 24),
          // Skeleton Order Items Title
          SkeletonLoader(width: 120, height: 20),
          const SizedBox(height: 12),
          // Skeleton Order Items
          ...List.generate(
            3,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: SkeletonListItem(),
            ),
          ),
        ],
      ),
    );
  }
}
