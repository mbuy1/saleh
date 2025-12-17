import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// نموذج المنتج في المخزون
class InventoryItem {
  final String productId;
  final String productName;
  final String? imageUrl;
  final int stock;
  final int lowStockThreshold;
  final String sku;
  final double price;

  InventoryItem({
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.stock,
    required this.lowStockThreshold,
    required this.sku,
    required this.price,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      productId: json['id'] ?? '',
      productName: json['name'] ?? '',
      imageUrl: json['main_image_url'] ?? json['image_url'],
      stock: json['stock'] ?? 0,
      lowStockThreshold:
          json['stock_threshold'] ?? json['low_stock_threshold'] ?? 5,
      sku: json['sku'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  bool get isLowStock => stock <= lowStockThreshold && stock > 0;
  bool get isOutOfStock => stock <= 0;

  Color get stockColor {
    if (isOutOfStock) return Colors.red;
    if (isLowStock) return Colors.orange;
    return Colors.green;
  }

  String get stockStatus {
    if (isOutOfStock) return 'نفذ';
    if (isLowStock) return 'منخفض';
    return 'متوفر';
  }
}

/// نموذج حركة المخزون
class InventoryMovement {
  final String id;
  final String productId;
  final String productName;
  final String movementType;
  final int quantity;
  final int stockBefore;
  final int stockAfter;
  final String? reason;
  final DateTime createdAt;

  InventoryMovement({
    required this.id,
    required this.productId,
    required this.productName,
    required this.movementType,
    required this.quantity,
    required this.stockBefore,
    required this.stockAfter,
    this.reason,
    required this.createdAt,
  });

  factory InventoryMovement.fromJson(Map<String, dynamic> json) {
    return InventoryMovement(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['products']?['name'] ?? json['product_name'] ?? '',
      movementType: json['movement_type'] ?? 'adjustment',
      quantity: json['quantity'] ?? 0,
      stockBefore: json['stock_before'] ?? 0,
      stockAfter: json['stock_after'] ?? 0,
      reason: json['reason'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  String get typeText {
    switch (movementType) {
      case 'sale':
        return 'بيع';
      case 'purchase':
        return 'شراء';
      case 'return':
        return 'إرجاع';
      case 'adjustment':
        return 'تعديل';
      case 'damage':
        return 'تالف';
      default:
        return movementType;
    }
  }

  String get typeIcon {
    switch (movementType) {
      case 'sale':
        return AppIcons.cart;
      case 'purchase':
        return AppIcons.cart;
      case 'return':
        return AppIcons.returnIcon;
      case 'adjustment':
        return AppIcons.edit;
      case 'damage':
        return AppIcons.warning;
      default:
        return AppIcons.sync;
    }
  }

  Color get typeColor {
    switch (movementType) {
      case 'sale':
        return Colors.blue;
      case 'purchase':
        return Colors.green;
      case 'return':
        return Colors.orange;
      case 'adjustment':
        return Colors.purple;
      case 'damage':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/// شاشة إدارة المخزون
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _api = ApiService();
  late TabController _tabController;

  List<InventoryItem> _allProducts = [];
  List<InventoryItem> _lowStockProducts = [];
  List<InventoryItem> _outOfStockProducts = [];
  List<InventoryMovement> _movements = [];
  bool _isLoading = true;
  String? _error;

  // إحصائيات
  int _totalProducts = 0;
  int _totalStock = 0;
  int _lowStockCount = 0;
  int _outOfStockCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // جلب المخزون والحركات بشكل متوازي
      final results = await Future.wait([
        _api.get('/secure/inventory'),
        _api.get('/secure/inventory/movements'),
      ]);

      final inventoryResponse = results[0];
      final movementsResponse = results[1];

      if (inventoryResponse.statusCode == 200) {
        final data = jsonDecode(inventoryResponse.body);
        if (data['ok'] == true && data['data'] != null) {
          _allProducts = (data['data'] as List)
              .map((item) => InventoryItem.fromJson(item))
              .toList();

          _lowStockProducts = _allProducts.where((p) => p.isLowStock).toList();
          _outOfStockProducts = _allProducts
              .where((p) => p.isOutOfStock)
              .toList();

          // حساب الإحصائيات
          _totalProducts = _allProducts.length;
          _totalStock = _allProducts.fold(0, (sum, p) => sum + p.stock);
          _lowStockCount = _lowStockProducts.length;
          _outOfStockCount = _outOfStockProducts.length;
        }
      }

      if (movementsResponse.statusCode == 200) {
        final data = jsonDecode(movementsResponse.body);
        if (data['ok'] == true && data['data'] != null) {
          _movements = (data['data'] as List)
              .map((item) => InventoryMovement.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      _error = 'حدث خطأ في تحميل البيانات';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _adjustStock(InventoryItem product) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AdjustStockSheet(product: product),
    );

    if (result != null) {
      setState(() => _isLoading = true);

      try {
        final response = await _api.post(
          '/secure/inventory/adjust',
          body: result,
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['ok'] == true) {
            HapticFeedback.mediumImpact();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم تحديث المخزون بنجاح'),
                  backgroundColor: AppTheme.successColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            await _loadData();
          } else {
            throw Exception(data['error'] ?? 'فشل في التحديث');
          }
        } else {
          throw Exception('فشل في الاتصال بالخادم');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ: ${e.toString()}'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'إدارة المخزون',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor, size: 24),
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppTheme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          isScrollable: true,
          tabs: [
            Tab(text: 'الكل $_totalProducts'),
            Tab(
              child: Row(
                children: [
                  const Text('منخفض'),
                  if (_lowStockCount > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$_lowStockCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  const Text('نفذ'),
                  if (_outOfStockCount > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$_outOfStockCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(text: 'الحركات'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorView()
          : Column(
              children: [
                // بطاقات الإحصائيات
                _buildStatsCards(),
                // المحتوى
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildProductsList(_allProducts),
                      _buildProductsList(_lowStockProducts),
                      _buildProductsList(_outOfStockProducts),
                      _buildMovementsList(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.error,
            width: 64,
            height: 64,
            colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
          ),
          SizedBox(height: AppDimensions.spacing16),
          Text(_error!, style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: AppDimensions.spacing16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: AppDimensions.paddingM,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              iconPath: AppIcons.inventory2,
              title: 'إجمالي المخزون',
              value: NumberFormat('#,###').format(_totalStock),
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: _buildStatCard(
              iconPath: AppIcons.warning,
              title: 'تنبيهات',
              value: '${_lowStockCount + _outOfStockCount}',
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String iconPath,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: AppDimensions.paddingM,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppDimensions.fontDisplay3,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDimensions.fontLabel,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(List<InventoryItem> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.inventory2,
              width: 64,
              height: 64,
              colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
            ),
            SizedBox(height: AppDimensions.spacing16),
            Text(
              'لا توجد منتجات',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: AppDimensions.fontTitle,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: AppDimensions.paddingM,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(InventoryItem product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: AppDimensions.paddingS,
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: AppDimensions.borderRadiusS,
          ),
          child: product.imageUrl != null
              ? ClipRRect(
                  borderRadius: AppDimensions.borderRadiusS,
                  child: Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        SvgPicture.asset(
                          AppIcons.image,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Colors.grey[400]!,
                            BlendMode.srcIn,
                          ),
                        ),
                  ),
                )
              : SvgPicture.asset(
                  AppIcons.image,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    Colors.grey[400]!,
                    BlendMode.srcIn,
                  ),
                ),
        ),
        title: Text(
          product.productName,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: product.stockColor.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Text(
                    '${product.stock} وحدة',
                    style: TextStyle(
                      color: product.stockColor,
                      fontSize: AppDimensions.fontLabel,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  product.stockStatus,
                  style: TextStyle(color: product.stockColor, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: SvgPicture.asset(
            AppIcons.edit,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppTheme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => _adjustStock(product),
        ),
      ),
    );
  }

  Widget _buildMovementsList() {
    if (_movements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.history,
              width: 64,
              height: 64,
              colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
            ),
            SizedBox(height: AppDimensions.spacing16),
            Text(
              'لا توجد حركات',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: AppDimensions.fontTitle,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: AppDimensions.paddingM,
        itemCount: _movements.length,
        itemBuilder: (context, index) {
          return _buildMovementCard(_movements[index]);
        },
      ),
    );
  }

  Widget _buildMovementCard(InventoryMovement movement) {
    final isPositive = movement.stockAfter > movement.stockBefore;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: AppDimensions.paddingS,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: movement.typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            movement.typeIcon,
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(movement.typeColor, BlendMode.srcIn),
          ),
        ),
        title: Text(
          movement.productName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  movement.typeText,
                  style: TextStyle(
                    color: movement.typeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${movement.stockBefore} → ${movement.stockAfter}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            if (movement.reason != null) ...[
              const SizedBox(height: 2),
              Text(
                movement.reason!,
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isPositive ? '+' : ''}${movement.quantity}',
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('MM/dd HH:mm').format(movement.createdAt),
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

/// نافذة تعديل المخزون
class _AdjustStockSheet extends StatefulWidget {
  final InventoryItem product;

  const _AdjustStockSheet({required this.product});

  @override
  State<_AdjustStockSheet> createState() => _AdjustStockSheetState();
}

class _AdjustStockSheetState extends State<_AdjustStockSheet> {
  String _adjustmentType = 'set'; // 'set', 'add', 'subtract'
  String _reason = 'adjustment';
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'تعديل مخزون: ${widget.product.productName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'المخزون الحالي: ${widget.product.stock} وحدة',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // نوع التعديل
            const Text(
              'نوع التعديل',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'set', label: Text('تعيين')),
                ButtonSegment(value: 'add', label: Text('إضافة')),
                ButtonSegment(value: 'subtract', label: Text('خصم')),
              ],
              selected: {_adjustmentType},
              onSelectionChanged: (selection) {
                setState(() => _adjustmentType = selection.first);
              },
            ),
            const SizedBox(height: 20),

            // الكمية
            const Text('الكمية', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: _adjustmentType == 'set'
                    ? 'المخزون الجديد'
                    : 'الكمية',
                suffixText: 'وحدة',
              ),
            ),
            const SizedBox(height: 20),

            // السبب
            const Text('السبب', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _reason,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'adjustment',
                  child: Text('تعديل يدوي'),
                ),
                DropdownMenuItem(value: 'purchase', child: Text('شراء مخزون')),
                DropdownMenuItem(value: 'return', child: Text('إرجاع عميل')),
                DropdownMenuItem(value: 'damage', child: Text('تالف')),
                DropdownMenuItem(value: 'correction', child: Text('تصحيح خطأ')),
              ],
              onChanged: (value) {
                setState(() => _reason = value ?? 'adjustment');
              },
            ),
            const SizedBox(height: 20),

            // ملاحظات
            const Text(
              'ملاحظات (اختياري)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'أضف ملاحظة...',
              ),
            ),
            const SizedBox(height: 24),

            // زر الحفظ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final quantity = int.tryParse(_quantityController.text);
                  if (quantity == null || quantity < 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('أدخل كمية صحيحة')),
                    );
                    return;
                  }

                  int newStock;
                  switch (_adjustmentType) {
                    case 'add':
                      newStock = widget.product.stock + quantity;
                      break;
                    case 'subtract':
                      newStock = widget.product.stock - quantity;
                      if (newStock < 0) newStock = 0;
                      break;
                    default:
                      newStock = quantity;
                  }

                  Navigator.pop(context, {
                    'product_id': widget.product.productId,
                    'quantity': newStock - widget.product.stock,
                    'reason': _reason,
                    'note': _noteController.text.isEmpty
                        ? null
                        : _noteController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'حفظ التغييرات',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
