import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/skeleton_loading.dart';

/// شاشة الطلبات - Orders Tab
/// تعرض قائمة طلبات العملاء
class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  bool _isLoading = false;
  String _selectedFilter = 'all';
  DateTimeRange? _selectedDateRange;

  // بيانات تجريبية للطلبات
  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': '1001',
      'customer': 'أحمد محمد',
      'total': 250.0,
      'status': 'new',
      'date': DateTime.now(),
    },
    {
      'id': '1002',
      'customer': 'سارة علي',
      'total': 180.0,
      'status': 'processing',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '1003',
      'customer': 'خالد العمري',
      'total': 520.0,
      'status': 'completed',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '1004',
      'customer': 'نورة السالم',
      'total': 95.0,
      'status': 'cancelled',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '1005',
      'customer': 'عبدالله الحربي',
      'total': 340.0,
      'status': 'new',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    var orders = _allOrders.where((order) {
      // فلترة بالحالة
      if (_selectedFilter != 'all' && order['status'] != _selectedFilter) {
        return false;
      }
      // فلترة بالتاريخ
      if (_selectedDateRange != null) {
        final orderDate = order['date'] as DateTime;
        if (orderDate.isBefore(_selectedDateRange!.start) ||
            orderDate.isAfter(
              _selectedDateRange!.end.add(const Duration(days: 1)),
            )) {
          return false;
        }
      }
      return true;
    }).toList();
    return orders;
  }

  Future<void> _refreshOrders() async {
    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();
    // محاكاة تحميل البيانات
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Column(
          children: [
            // التبويبات ملتصقة بالبار العلوي
            Container(
              color: AppTheme.surfaceColor,
              child: TabBar(
                isScrollable: true,
                indicatorColor: AppTheme.primaryColor,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.textSecondaryColor,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'إدارة الطلبات'),
                  Tab(text: 'إعدادات الطلبات'),
                  Tab(text: 'تخصيص الفاتورة'),
                ],
              ),
            ),
            // المحتوى
            Expanded(
              child: TabBarView(
                children: [
                  // 1) إدارة الطلبات (المحتوى الأصلي)
                  _buildOrdersContent(),
                  // 2) إعدادات الطلبات
                  _buildPlaceholder('إعدادات الطلبات'),
                  // 3) تخصيص الفاتورة
                  _buildPlaceholder('تخصيص الفاتورة'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersContent() {
    final orders = _filteredOrders;

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      color: AppTheme.accentColor,
      child: Column(
        children: [
          // شريط الفلتر المختار
          if (_selectedFilter != 'all' || _selectedDateRange != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing16,
                vertical: AppDimensions.spacing8,
              ),
              color: AppTheme.primaryColor.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  if (_selectedFilter != 'all')
                    Chip(
                      label: Text(
                        _getFilterLabel(_selectedFilter),
                        style: TextStyle(fontSize: AppDimensions.fontLabel),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() => _selectedFilter = 'all'),
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                    ),
                  if (_selectedDateRange != null) ...[
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(
                        '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                        style: TextStyle(fontSize: AppDimensions.fontLabel),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () =>
                          setState(() => _selectedDateRange = null),
                      backgroundColor: AppTheme.accentColor.withValues(
                        alpha: 0.1,
                      ),
                    ),
                  ],
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedFilter = 'all';
                      _selectedDateRange = null;
                    }),
                    child: Text(
                      'مسح الكل',
                      style: TextStyle(fontSize: AppDimensions.fontLabel),
                    ),
                  ),
                ],
              ),
            ),
          // قائمة الطلبات
          Expanded(
            child: _isLoading
                ? const SkeletonOrdersList()
                : orders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.spacing16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) =>
                        _buildOrderCard(orders[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppDimensions.avatarProfile,
                height: AppDimensions.avatarProfile,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.orders,
                  width: AppDimensions.iconDisplay,
                  height: AppDimensions.iconDisplay,
                  colorFilter: ColorFilter.mode(
                    AppTheme.primaryColor.withValues(alpha: 0.5),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              Text(
                _selectedFilter != 'all'
                    ? 'لا توجد طلبات بهذه الحالة'
                    : 'لا توجد طلبات',
                style: TextStyle(
                  fontSize: AppDimensions.fontDisplay3,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                'ستظهر الطلبات هنا عند استلامها',
                style: TextStyle(
                  fontSize: AppDimensions.fontBody,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    order['status'],
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Icon(
                  _getStatusIcon(order['status']),
                  color: _getStatusColor(order['status']),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${order['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              order['status'],
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusLabel(order['status']),
                            style: TextStyle(
                              fontSize: AppDimensions.fontCaption - 1,
                              color: _getStatusColor(order['status']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['customer'],
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: AppDimensions.fontBody2,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${order['total'].toStringAsFixed(0)} ر.س',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(order['date']),
                    style: TextStyle(
                      fontSize: AppDimensions.fontCaption,
                      color: AppTheme.textHintColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'طلب #${order['id']}',
                  style: TextStyle(
                    fontSize: AppDimensions.fontHeadline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      order['status'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusLabel(order['status']),
                    style: TextStyle(
                      color: _getStatusColor(order['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDetailRow('العميل', order['customer']),
            _buildDetailRow(
              'المجموع',
              '${order['total'].toStringAsFixed(0)} ر.س',
            ),
            _buildDetailRow('التاريخ', _formatDateTime(order['date'])),
            const SizedBox(height: 24),
            if (order['status'] == 'new') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => order['status'] = 'processing');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم قبول الطلب'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor,
                      ),
                      child: const Text(
                        'قبول الطلب',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => order['status'] = 'cancelled');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم رفض الطلب'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('رفض'),
                    ),
                  ),
                ],
              ),
            ] else if (order['status'] == 'processing') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => order['status'] = 'completed');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إكمال الطلب'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('تم التوصيل'),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.textSecondaryColor)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getFilterLabel(String status) {
    switch (status) {
      case 'new':
        return 'جديدة';
      case 'processing':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتملة';
      case 'cancelled':
        return 'ملغاة';
      default:
        return 'الكل';
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'new':
        return 'جديد';
      case 'processing':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
        return AppTheme.accentColor;
      case 'processing':
        return AppTheme.warningColor;
      case 'completed':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'new':
        return Icons.fiber_new;
      case 'processing':
        return Icons.autorenew;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt;
    }
  }

  Widget _buildPlaceholder(String title) {
    if (title == 'إعدادات الطلبات') {
      return _buildOrderSettingsTab();
    } else if (title == 'تخصيص الفاتورة') {
      return _buildInvoiceCustomizationTab();
    }
    return const SizedBox();
  }

  /// تبويب إعدادات الطلبات
  Widget _buildOrderSettingsTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsSection('إشعارات الطلبات', [
            _buildSwitchTile(
              'إشعار عند طلب جديد',
              'استلام إشعار فوري عند وصول طلب جديد',
              AppIcons.notifications,
              true,
            ),
            _buildSwitchTile(
              'إشعار صوتي',
              'تشغيل صوت عند وصول طلب',
              AppIcons.mic,
              true,
            ),
            _buildSwitchTile(
              'إشعار بريد إلكتروني',
              'إرسال نسخة من الطلب للبريد',
              AppIcons.email,
              false,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSettingsSection('حالات الطلب', [
            _buildOptionTile(
              'الحالة الافتراضية للطلب الجديد',
              'قيد المراجعة',
              AppIcons.orders,
            ),
            _buildOptionTile(
              'تأكيد الطلب تلقائياً',
              'معطل',
              AppIcons.checkCircle,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSettingsSection('خيارات الإلغاء', [
            _buildSwitchTile(
              'السماح للعميل بالإلغاء',
              'السماح بإلغاء الطلب قبل الشحن',
              AppIcons.close,
              true,
            ),
            _buildOptionTile('مدة السماح بالإلغاء', '24 ساعة', AppIcons.time),
          ]),
        ],
      ),
    );
  }

  /// تبويب تخصيص الفاتورة
  Widget _buildInvoiceCustomizationTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsSection('معلومات الفاتورة', [
            _buildSwitchTile(
              'إظهار شعار المتجر',
              'عرض الشعار في أعلى الفاتورة',
              AppIcons.store,
              true,
            ),
            _buildSwitchTile(
              'إظهار رقم الضريبة',
              'عرض الرقم الضريبي في الفاتورة',
              AppIcons.document,
              false,
            ),
            _buildOptionTile('عنوان الفاتورة', 'فاتورة ضريبية', AppIcons.edit),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSettingsSection('تفاصيل المنتجات', [
            _buildSwitchTile(
              'إظهار صورة المنتج',
              'عرض صورة مصغرة للمنتج',
              AppIcons.image,
              true,
            ),
            _buildSwitchTile(
              'إظهار رمز SKU',
              'عرض رمز المنتج في الفاتورة',
              AppIcons.tag,
              false,
            ),
            _buildSwitchTile(
              'إظهار الخصومات',
              'عرض قيمة الخصم لكل منتج',
              AppIcons.discount,
              true,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSettingsSection('التذييل', [
            _buildOptionTile(
              'رسالة شكر',
              'شكراً لتسوقكم معنا!',
              AppIcons.heart,
            ),
            _buildSwitchTile(
              'إظهار رمز QR',
              'رمز QR لرابط المتجر',
              AppIcons.qrCode,
              true,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          // زر معاينة الفاتورة
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeightL,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('سيتم فتح معاينة الفاتورة'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
              icon: SvgPicture.asset(
                AppIcons.eye,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              label: const Text('معاينة الفاتورة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimensions.borderRadiusM,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppDimensions.fontTitle,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: AppDimensions.borderRadiusM,
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    String icon,
    bool value,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusS,
            ),
            child: SvgPicture.asset(
              icon,
              width: AppDimensions.iconS,
              height: AppDimensions.iconS,
              colorFilter: const ColorFilter.mode(
                AppTheme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: AppDimensions.fontLabel,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          trailing: Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(newValue ? 'تم التفعيل' : 'تم التعطيل'),
                  backgroundColor: AppTheme.primaryColor,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.5),
            activeThumbColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }

  Widget _buildOptionTile(String title, String value, String icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: AppDimensions.borderRadiusS,
        ),
        child: SvgPicture.asset(
          icon,
          width: AppDimensions.iconS,
          height: AppDimensions.iconS,
          colorFilter: const ColorFilter.mode(
            AppTheme.primaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: AppDimensions.fontLabel,
          color: AppTheme.secondaryColor,
        ),
      ),
      trailing: SvgPicture.asset(
        AppIcons.chevronLeft,
        width: AppDimensions.iconS,
        height: AppDimensions.iconS,
        colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعديل: $title'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }
}
