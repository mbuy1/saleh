import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/auth_token_storage.dart';

/// نموذج طلب التوريد
class SupplierOrder {
  final String id;
  final String orderId;
  final String supplierStoreId;
  final String resellerStoreId;
  final String dropshipProductId;
  final int quantity;
  final String supplierStatus;
  final String? trackingNumber;
  final String? shippingProvider;
  final DateTime createdAt;
  final DateTime updatedAt;

  // بيانات إضافية من JOIN
  final String? orderNumber;
  final String? orderStatus;
  final double? totalAmount;
  final String? customerName;
  final String? customerPhone;
  final Map<String, dynamic>? shippingAddress;
  final String? productTitle;
  final List<dynamic>? productMedia;
  final String? resellerStoreName;

  SupplierOrder({
    required this.id,
    required this.orderId,
    required this.supplierStoreId,
    required this.resellerStoreId,
    required this.dropshipProductId,
    required this.quantity,
    required this.supplierStatus,
    this.trackingNumber,
    this.shippingProvider,
    required this.createdAt,
    required this.updatedAt,
    this.orderNumber,
    this.orderStatus,
    this.totalAmount,
    this.customerName,
    this.customerPhone,
    this.shippingAddress,
    this.productTitle,
    this.productMedia,
    this.resellerStoreName,
  });

  factory SupplierOrder.fromJson(Map<String, dynamic> json) {
    final order = json['orders'] as Map<String, dynamic>?;
    final dropshipProduct = json['dropship_products'] as Map<String, dynamic>?;
    final resellerStore = json['stores'] as Map<String, dynamic>?;

    return SupplierOrder(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      supplierStoreId: json['supplier_store_id'] as String,
      resellerStoreId: json['reseller_store_id'] as String,
      dropshipProductId: json['dropship_product_id'] as String,
      quantity: json['quantity'] as int,
      supplierStatus: json['supplier_status'] as String? ?? 'new',
      trackingNumber: json['tracking_number'] as String?,
      shippingProvider: json['shipping_provider'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      orderNumber: order?['order_number'] as String?,
      orderStatus: order?['status'] as String?,
      totalAmount: order != null && order['total_amount'] != null
          ? (order['total_amount'] as num).toDouble()
          : null,
      customerName: order?['customer_name'] as String?,
      customerPhone: order?['customer_phone'] as String?,
      shippingAddress: order?['shipping_address'] as Map<String, dynamic>?,
      productTitle: dropshipProduct?['title'] as String?,
      productMedia: dropshipProduct?['media'] as List<dynamic>?,
      resellerStoreName: resellerStore?['name'] as String?,
    );
  }

  String? get mainImageUrl {
    if (productMedia == null || productMedia!.isEmpty) return null;
    final mainMedia = productMedia!.firstWhere(
      (m) => m['is_main'] == true && m['type'] == 'image',
      orElse: () => productMedia!.firstWhere(
        (m) => m['type'] == 'image',
        orElse: () => null,
      ),
    );
    return mainMedia?['url'] as String?;
  }
}

/// شاشة طلبات التوريد للمورد
class SupplierOrdersScreen extends ConsumerStatefulWidget {
  const SupplierOrdersScreen({super.key});

  @override
  ConsumerState<SupplierOrdersScreen> createState() =>
      _SupplierOrdersScreenState();
}

class _SupplierOrdersScreenState extends ConsumerState<SupplierOrdersScreen> {
  final ApiService _api = ApiService();
  List<SupplierOrder> _orders = [];
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
      final token = await ref.read(authTokenStorageProvider).getAccessToken();
      final response = await _api.get(
        '/secure/supplier/orders',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          setState(() {
            _orders = ((data['data'] as List?) ?? [])
                .map(
                  (json) =>
                      SupplierOrder.fromJson(json as Map<String, dynamic>),
                )
                .toList();
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading supplier orders: $e');
    }

    setState(() {
      _isLoading = false;
      _orders = [];
    });
  }

  Future<void> _updateOrderStatus(
    String orderId,
    String status, {
    String? trackingNumber,
    String? shippingProvider,
  }) async {
    try {
      final token = await ref.read(authTokenStorageProvider).getAccessToken();
      final body = <String, dynamic>{'supplier_status': status};
      if (trackingNumber != null) body['tracking_number'] = trackingNumber;
      if (shippingProvider != null) {
        body['shipping_provider'] = shippingProvider;
      }

      final response = await _api.patch(
        '/secure/supplier/orders/$orderId',
        body: body,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الحالة بنجاح'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        _loadOrders();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل تحديث الحالة'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _showUpdateStatusModal(SupplierOrder order) {
    final trackingController = TextEditingController(
      text: order.trackingNumber,
    );
    final shippingController = TextEditingController(
      text: order.shippingProvider,
    );
    String selectedStatus = order.supplierStatus;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'تحديث حالة الطلب',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'الحالة',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'new', child: Text('جديد')),
                          DropdownMenuItem(
                            value: 'preparing',
                            child: Text('قيد التجهيز'),
                          ),
                          DropdownMenuItem(
                            value: 'shipped',
                            child: Text('تم الشحن'),
                          ),
                          DropdownMenuItem(
                            value: 'delivered',
                            child: Text('تم التسليم'),
                          ),
                          DropdownMenuItem(
                            value: 'cancelled',
                            child: Text('ملغي'),
                          ),
                        ],
                        onChanged: (value) {
                          setModalState(() => selectedStatus = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      if (selectedStatus == 'shipped' ||
                          selectedStatus == 'delivered') ...[
                        TextField(
                          controller: trackingController,
                          decoration: const InputDecoration(
                            labelText: 'رقم التتبع',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: shippingController,
                          decoration: const InputDecoration(
                            labelText: 'شركة الشحن',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _updateOrderStatus(
                              order.id,
                              selectedStatus,
                              trackingNumber: trackingController.text.isNotEmpty
                                  ? trackingController.text
                                  : null,
                              shippingProvider:
                                  shippingController.text.isNotEmpty
                                  ? shippingController.text
                                  : null,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('حفظ'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor, size: 24),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'طلبات التوريد',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.fontHeadline,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات توريد',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadOrders,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return _buildOrderCard(order);
                },
              ),
            ),
    );
  }

  Widget _buildOrderCard(SupplierOrder order) {
    final imageUrl = order.mainImageUrl;
    final statusColors = {
      'new': Colors.blue,
      'preparing': Colors.orange,
      'shipped': Colors.purple,
      'delivered': Colors.green,
      'cancelled': Colors.red,
    };
    final statusLabels = {
      'new': 'جديد',
      'preparing': 'قيد التجهيز',
      'shipped': 'تم الشحن',
      'delivered': 'تم التسليم',
      'cancelled': 'ملغي',
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showUpdateStatusModal(order),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_outlined, size: 60),
                      ),
                    )
                  else
                    const Icon(Icons.image_outlined, size: 60),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.productTitle ?? 'منتج',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimensions.fontBody,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'الكمية: ${order.quantity}',
                          style: TextStyle(
                            fontSize: AppDimensions.fontBody2,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (order.orderNumber != null)
                          Text(
                            'رقم الطلب: ${order.orderNumber}',
                            style: TextStyle(
                              fontSize: AppDimensions.fontBody2,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (statusColors[order.supplierStatus] ?? Colors.grey)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusLabels[order.supplierStatus] ??
                          order.supplierStatus,
                      style: TextStyle(
                        color:
                            statusColors[order.supplierStatus] ?? Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (order.trackingNumber != null) ...[
                const SizedBox(height: 8),
                Text(
                  'رقم التتبع: ${order.trackingNumber}',
                  style: TextStyle(
                    fontSize: AppDimensions.fontBody2,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              if (order.customerName != null) ...[
                const SizedBox(height: 8),
                Text(
                  'العميل: ${order.customerName}',
                  style: TextStyle(
                    fontSize: AppDimensions.fontBody2,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showUpdateStatusModal(order),
                  child: const Text('تحديث الحالة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
