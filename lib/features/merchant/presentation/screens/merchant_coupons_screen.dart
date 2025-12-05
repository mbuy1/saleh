import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// شاشة إدارة الكوبونات للتاجر
class MerchantCouponsScreen extends StatefulWidget {
  const MerchantCouponsScreen({super.key});

  @override
  State<MerchantCouponsScreen> createState() => _MerchantCouponsScreenState();
}

class _MerchantCouponsScreenState extends State<MerchantCouponsScreen> {
  bool _isLoading = true;
  List<dynamic> _coupons = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.get('/secure/merchant/coupons');

      if (result['ok'] == true) {
        final data = result['data'];
        _coupons = (data is List) ? data : [];
      } else {
        _error = result['error'] ?? 'فشل في تحميل الكوبونات';
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteCoupon(String couponId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('حذف الكوبون', style: GoogleFonts.cairo()),
        content: Text(
          'هل أنت متأكد من حذف هذا الكوبون؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: MbuyColors.error),
            child: Text('حذف', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final result = await ApiService.delete(
        '/secure/merchant/coupons/$couponId',
      );
      if (result['ok'] == true) {
        _loadCoupons();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم حذف الكوبون', style: GoogleFonts.cairo()),
            ),
          );
        }
      }
    }
  }

  Future<void> _toggleCouponStatus(String couponId, bool isActive) async {
    final result = await ApiService.put(
      '/secure/merchant/coupons/$couponId',
      data: {'is_active': !isActive},
    );

    if (result['ok'] == true) {
      _loadCoupons();
    }
  }

  void _showAddCouponDialog([Map<String, dynamic>? coupon]) {
    final isEditing = coupon != null;
    final codeController = TextEditingController(text: coupon?['code'] ?? '');
    final descController = TextEditingController(
      text: coupon?['description'] ?? '',
    );
    final valueController = TextEditingController(
      text: coupon?['discount_value']?.toString() ?? '',
    );
    final maxDiscountController = TextEditingController(
      text: coupon?['max_discount']?.toString() ?? '',
    );
    final minOrderController = TextEditingController(
      text: coupon?['min_order_amount']?.toString() ?? '',
    );
    final maxUsesController = TextEditingController(
      text: coupon?['max_uses']?.toString() ?? '',
    );

    String discountType = coupon?['discount_type'] ?? 'percentage';
    DateTime expiresAt = coupon?['expires_at'] != null
        ? DateTime.parse(coupon!['expires_at'])
        : DateTime.now().add(const Duration(days: 30));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MbuyColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'تعديل الكوبون' : 'إضافة كوبون جديد',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'كود الكوبون',
                    labelStyle: GoogleFonts.cairo(),
                    hintText: 'مثال: SAVE20',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'وصف الكوبون',
                    labelStyle: GoogleFonts.cairo(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('نوع الخصم:', style: GoogleFonts.cairo()),
                    const SizedBox(width: 16),
                    ChoiceChip(
                      label: Text('نسبة %', style: GoogleFonts.cairo()),
                      selected: discountType == 'percentage',
                      onSelected: (selected) {
                        if (selected) {
                          setModalState(() => discountType = 'percentage');
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('مبلغ ثابت', style: GoogleFonts.cairo()),
                      selected: discountType == 'fixed',
                      onSelected: (selected) {
                        if (selected) {
                          setModalState(() => discountType = 'fixed');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: valueController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: discountType == 'percentage'
                              ? 'نسبة الخصم %'
                              : 'قيمة الخصم (ر.س)',
                          labelStyle: GoogleFonts.cairo(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    if (discountType == 'percentage') ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: maxDiscountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'الحد الأقصى (ر.س)',
                            labelStyle: GoogleFonts.cairo(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minOrderController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'الحد الأدنى للطلب',
                          labelStyle: GoogleFonts.cairo(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: maxUsesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'الحد الأقصى للاستخدام',
                          labelStyle: GoogleFonts.cairo(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: expiresAt,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setModalState(() => expiresAt = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: MbuyColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: MbuyColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تاريخ الانتهاء',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: MbuyColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${expiresAt.day}/${expiresAt.month}/${expiresAt.year}',
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (codeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'أدخل كود الكوبون',
                              style: GoogleFonts.cairo(),
                            ),
                          ),
                        );
                        return;
                      }
                      if (valueController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'أدخل قيمة الخصم',
                              style: GoogleFonts.cairo(),
                            ),
                          ),
                        );
                        return;
                      }

                      final data = {
                        'code': codeController.text.toUpperCase(),
                        'description': descController.text,
                        'discount_type': discountType,
                        'discount_value':
                            double.tryParse(valueController.text) ?? 0,
                        'max_discount': maxDiscountController.text.isNotEmpty
                            ? double.tryParse(maxDiscountController.text)
                            : null,
                        'min_order_amount': minOrderController.text.isNotEmpty
                            ? double.tryParse(minOrderController.text)
                            : null,
                        'max_uses': maxUsesController.text.isNotEmpty
                            ? int.tryParse(maxUsesController.text)
                            : null,
                        'expires_at': expiresAt.toIso8601String(),
                      };

                      Navigator.pop(ctx);

                      final result = isEditing
                          ? await ApiService.put(
                              '/secure/merchant/coupons/${coupon['id']}',
                              data: data,
                            )
                          : await ApiService.post(
                              '/secure/merchant/coupons',
                              data: data,
                            );

                      if (result['ok'] == true) {
                        _loadCoupons();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isEditing
                                    ? 'تم تحديث الكوبون'
                                    : 'تم إنشاء الكوبون',
                                style: GoogleFonts.cairo(),
                              ),
                            ),
                          );
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result['error'] ?? 'حدث خطأ',
                                style: GoogleFonts.cairo(),
                              ),
                              backgroundColor: MbuyColors.error,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MbuyColors.primaryIndigo,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'تحديث الكوبون' : 'إنشاء الكوبون',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: Text(
          'إدارة الكوبونات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadCoupons),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCouponDialog(),
        backgroundColor: MbuyColors.primaryIndigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'إضافة كوبون',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorState()
          : _coupons.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadCoupons,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _coupons.length,
                itemBuilder: (ctx, index) => _buildCouponCard(_coupons[index]),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 80,
            color: MbuyColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد كوبونات',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أنشئ كوبونات خصم لجذب المزيد من العملاء',
            style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddCouponDialog(),
            icon: const Icon(Icons.add),
            label: Text('إنشاء كوبون', style: GoogleFonts.cairo()),
            style: ElevatedButton.styleFrom(
              backgroundColor: MbuyColors.primaryIndigo,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: MbuyColors.error),
          const SizedBox(height: 16),
          Text(
            _error ?? 'حدث خطأ',
            style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadCoupons,
            child: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon) {
    final isActive = coupon['is_active'] ?? true;
    final isExpired =
        coupon['expires_at'] != null &&
        DateTime.parse(coupon['expires_at']).isBefore(DateTime.now());
    final discountType = coupon['discount_type'] ?? 'percentage';
    final discountValue = coupon['discount_value'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: MbuyColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpired
              ? MbuyColors.error.withValues(alpha: 0.3)
              : !isActive
              ? MbuyColors.textSecondary.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: MbuyColors.primaryIndigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    coupon['code'] ?? '',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.primaryIndigo,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isExpired
                        ? MbuyColors.error.withValues(alpha: 0.1)
                        : isActive
                        ? MbuyColors.success.withValues(alpha: 0.1)
                        : MbuyColors.textSecondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isExpired
                        ? 'منتهي'
                        : isActive
                        ? 'نشط'
                        : 'معطل',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isExpired
                          ? MbuyColors.error
                          : isActive
                          ? MbuyColors.success
                          : MbuyColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  discountType == 'percentage'
                      ? Icons.percent
                      : Icons.attach_money,
                  size: 20,
                  color: MbuyColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  discountType == 'percentage'
                      ? 'خصم $discountValue%'
                      : 'خصم $discountValue ر.س',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (coupon['max_discount'] != null &&
                    discountType == 'percentage') ...[
                  const SizedBox(width: 8),
                  Text(
                    '(حد أقصى ${coupon['max_discount']} ر.س)',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: MbuyColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            if (coupon['description']?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                coupon['description'],
                style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (coupon['min_order_amount'] != null) ...[
                  _buildInfoChip(
                    icon: Icons.shopping_cart,
                    label: 'حد أدنى ${coupon['min_order_amount']} ر.س',
                  ),
                  const SizedBox(width: 8),
                ],
                if (coupon['max_uses'] != null) ...[
                  _buildInfoChip(
                    icon: Icons.people,
                    label: '${coupon['used_count'] ?? 0}/${coupon['max_uses']}',
                  ),
                  const SizedBox(width: 8),
                ],
                if (coupon['expires_at'] != null) ...[
                  _buildInfoChip(
                    icon: Icons.calendar_today,
                    label: _formatDate(coupon['expires_at']),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isExpired)
                  TextButton.icon(
                    onPressed: () =>
                        _toggleCouponStatus(coupon['id'], isActive),
                    icon: Icon(
                      isActive ? Icons.pause : Icons.play_arrow,
                      size: 18,
                    ),
                    label: Text(
                      isActive ? 'تعطيل' : 'تفعيل',
                      style: GoogleFonts.cairo(),
                    ),
                  ),
                TextButton.icon(
                  onPressed: () => _showAddCouponDialog(coupon),
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text('تعديل', style: GoogleFonts.cairo()),
                ),
                TextButton.icon(
                  onPressed: () => _deleteCoupon(coupon['id']),
                  icon: Icon(Icons.delete, size: 18, color: MbuyColors.error),
                  label: Text(
                    'حذف',
                    style: GoogleFonts.cairo(color: MbuyColors.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: MbuyColors.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: MbuyColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 11,
              color: MbuyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }
}
