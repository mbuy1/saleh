import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/data.dart';
import '../../models/models.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Load orders on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).loadOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'قيد المعالجة'),
            Tab(text: 'قيد الشحن'),
            Tab(text: 'تم التوصيل'),
          ],
        ),
      ),
      body: ordersState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ordersState.error != null
          ? _buildErrorState(ordersState.error!)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(ordersState.orders, null),
                _buildOrdersList(ordersState.orders, OrderStatus.processing),
                _buildOrdersList(ordersState.orders, OrderStatus.shipping),
                _buildOrdersList(ordersState.orders, OrderStatus.delivered),
              ],
            ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(ordersProvider.notifier).loadOrders();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders, OrderStatus? filterStatus) {
    final filteredOrders = filterStatus == null
        ? orders
        : orders.where((o) => o.status == filterStatus).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'لا توجد طلبات',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(ordersProvider.notifier).loadOrders();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(filteredOrders[index]);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.store, size: 20),
                const SizedBox(width: 8),
                Text(
                  order.storeName ?? 'متجر',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _buildStatusChip(order.status),
              ],
            ),
          ),

          // Items
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ...order.items.take(2).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl ?? 'https://picsum.photos/100',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image, size: 20),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'x${item.quantity}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${(item.price * item.quantity).toStringAsFixed(0)} ر.س',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (order.items.length > 2)
                  Text(
                    '+${order.items.length - 2} منتجات أخرى',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رقم الطلب: ${order.orderNumber}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الإجمالي: ${order.totalAmount.toStringAsFixed(0)} ر.س',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                if (order.status == OrderStatus.delivered)
                  OutlinedButton(
                    onPressed: () {
                      // Reorder logic
                    },
                    child: const Text('إعادة الطلب'),
                  )
                else if (order.status == OrderStatus.pending ||
                    order.status == OrderStatus.processing)
                  OutlinedButton(
                    onPressed: () {
                      _showCancelDialog(order);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('إلغاء الطلب'),
                  )
                else
                  OutlinedButton(
                    onPressed: () {
                      // Track order
                      context.push('/order/${order.id}');
                    },
                    child: const Text('تتبع الطلب'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: Text('هل أنت متأكد من إلغاء الطلب ${order.orderNumber}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('تراجع'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(ordersProvider.notifier).cancelOrder(order.id);
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('تم إلغاء الطلب')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.grey;
        text = 'معلق';
        break;
      case OrderStatus.confirmed:
        color = Colors.blue;
        text = 'مؤكد';
        break;
      case OrderStatus.processing:
        color = Colors.orange;
        text = 'قيد المعالجة';
        break;
      case OrderStatus.shipped:
      case OrderStatus.shipping:
        color = Colors.blue;
        text = 'قيد الشحن';
        break;
      case OrderStatus.outForDelivery:
        color = Colors.teal;
        text = 'في الطريق';
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        text = 'تم التوصيل';
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        text = 'ملغي';
        break;
      case OrderStatus.refunded:
        color = Colors.purple;
        text = 'مسترجع';
        break;
      case OrderStatus.failed:
        color = Colors.red[900]!;
        text = 'فشل';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
