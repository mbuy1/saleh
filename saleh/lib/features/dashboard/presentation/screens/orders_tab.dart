import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/skeleton_loading.dart';

/// Ø´Ø§Ø´Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª - Orders Tab
/// ØªØ¹Ø±Ø¶ Ù‚Ø§Ø¦Ù…Ø© Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡
class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  bool _isLoading = false;
  String _selectedFilter = 'all';
  DateTimeRange? _selectedDateRange;

  // Ø¨ÙŠØ§Ù†Ø§Øª ØªØ¬Ø±ÙŠØ¨ÙŠØ© Ù„Ù„Ø·Ù„Ø¨Ø§Øª
  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': '1001',
      'customer': 'Ø£Ø­Ù…Ø¯ Ù…Ø­Ù…Ø¯',
      'total': 250.0,
      'status': 'new',
      'date': DateTime.now(),
    },
    {
      'id': '1002',
      'customer': 'Ø³Ø§Ø±Ø© Ø¹Ù„ÙŠ',
      'total': 180.0,
      'status': 'processing',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '1003',
      'customer': 'Ø®Ø§Ù„Ø¯ Ø§Ù„Ø¹Ù…Ø±ÙŠ',
      'total': 520.0,
      'status': 'completed',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '1004',
      'customer': 'Ù†ÙˆØ±Ø© Ø§Ù„Ø³Ø§Ù„Ù…',
      'total': 95.0,
      'status': 'cancelled',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '1005',
      'customer': 'Ø¹Ø¨Ø¯Ø§Ù„Ù„Ù‡ Ø§Ù„Ø­Ø±Ø¨ÙŠ',
      'total': 340.0,
      'status': 'new',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    var orders = _allOrders.where((order) {
      // ÙÙ„ØªØ±Ø© Ø¨Ø§Ù„Ø­Ø§Ù„Ø©
      if (_selectedFilter != 'all' && order['status'] != _selectedFilter) {
        return false;
      }
      // ÙÙ„ØªØ±Ø© Ø¨Ø§Ù„ØªØ§Ø±ÙŠØ®
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
    // Ù…Ø­Ø§ÙƒØ§Ø© ØªØ­Ù…ÙŠÙ„ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª
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
        body: Column(
          children: [
            // Ø§Ù„ØªØ¨ÙˆÙŠØ¨Ø§Øª Ù…Ù„ØªØµÙ‚Ø© Ø¨Ø§Ù„Ø¨Ø§Ø± Ø§Ù„Ø¹Ù„ÙˆÙŠ
            Container(
              color: AppTheme.surfaceColor,
              child: TabBar(
                isScrollable: true,
                indicatorColor: AppTheme.primaryColor,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.textSecondaryColor,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª'),
                  Tab(text: 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª'),
                  Tab(text: 'ØªØ®ØµÙŠØµ Ø§Ù„ÙØ§ØªÙˆØ±Ø©'),
                ],
              ),
            ),
            // Ø§Ù„Ù…Ø­ØªÙˆÙ‰
            Expanded(
              child: TabBarView(
                children: [
                  // 1) Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª (Ø§Ù„Ù…Ø­ØªÙˆÙ‰ Ø§Ù„Ø£ØµÙ„ÙŠ)
                  _buildOrdersContent(),
                  // 2) Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª
                  _buildPlaceholder('Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª'),
                  // 3) ØªØ®ØµÙŠØµ Ø§Ù„ÙØ§ØªÙˆØ±Ø©
                  _buildPlaceholder('ØªØ®ØµÙŠØµ Ø§Ù„ÙØ§ØªÙˆØ±Ø©'),
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
          // Ø´Ø±ÙŠØ· Ø§Ù„ÙÙ„ØªØ± Ø§Ù„Ù…Ø®ØªØ§Ø±
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
                      'Ù…Ø³Ø­ Ø§Ù„ÙƒÙ„',
                      style: TextStyle(fontSize: AppDimensions.fontLabel),
                    ),
                  ),
                ],
              ),
            ),
          // Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª
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
                    ? 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø·Ù„Ø¨Ø§Øª Ø¨Ù‡Ø°Ù‡ Ø§Ù„Ø­Ø§Ù„Ø©'
                    : 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø·Ù„Ø¨Ø§Øª',
                style: TextStyle(
                  fontSize: AppDimensions.fontDisplay3,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                'Ø³ØªØ¸Ù‡Ø± Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ù‡Ù†Ø§ Ø¹Ù†Ø¯ Ø§Ø³ØªÙ„Ø§Ù…Ù‡Ø§',
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
                    '${order['total'].toStringAsFixed(0)} Ø±.Ø³',
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
                  'Ø·Ù„Ø¨ #${order['id']}',
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
            _buildDetailRow('Ø§Ù„Ø¹Ù…ÙŠÙ„', order['customer']),
            _buildDetailRow(
              'Ø§Ù„Ù…Ø¬Ù…ÙˆØ¹',
              '${order['total'].toStringAsFixed(0)} Ø±.Ø³',
            ),
            _buildDetailRow('Ø§Ù„ØªØ§Ø±ÙŠØ®', _formatDateTime(order['date'])),
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
                            content: Text('ØªÙ… Ù‚Ø¨ÙˆÙ„ Ø§Ù„Ø·Ù„Ø¨'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor,
                      ),
                      child: const Text(
                        'Ù‚Ø¨ÙˆÙ„ Ø§Ù„Ø·Ù„Ø¨',
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
                            content: Text('ØªÙ… Ø±ÙØ¶ Ø§Ù„Ø·Ù„Ø¨'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Ø±ÙØ¶'),
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
                        content: Text('ØªÙ… Ø¥ÙƒÙ…Ø§Ù„ Ø§Ù„Ø·Ù„Ø¨'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('ØªÙ… Ø§Ù„ØªÙˆØµÙŠÙ„'),
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
        return 'Ø¬Ø¯ÙŠØ¯Ø©';
      case 'processing':
        return 'Ù‚ÙŠØ¯ Ø§Ù„ØªÙ†ÙÙŠØ°';
      case 'completed':
        return 'Ù…ÙƒØªÙ…Ù„Ø©';
      case 'cancelled':
        return 'Ù…Ù„ØºØ§Ø©';
      default:
        return 'Ø§Ù„ÙƒÙ„';
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'new':
        return 'Ø¬Ø¯ÙŠØ¯';
      case 'processing':
        return 'Ù‚ÙŠØ¯ Ø§Ù„ØªÙ†ÙÙŠØ°';
      case 'completed':
        return 'Ù…ÙƒØªÙ…Ù„';
      case 'cancelled':
        return 'Ù…Ù„ØºÙŠ';
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
    if (title == 'Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª') {
      return _buildOrderSettingsTab();
    } else if (title == 'ØªØ®ØµÙŠØµ Ø§Ù„ÙØ§ØªÙˆØ±Ø©') {
      return _buildInvoiceCustomizationTab();
    }
    return const SizedBox();
  }

  /// ØªØ¨ÙˆÙŠØ¨ Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª
  Widget _buildOrderSettingsTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsSection('Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª', [
            _buildSwitchTile(
              'Ø¥Ø´Ø¹Ø§Ø± Ø¹Ù†Ø¯ Ø·Ù„Ø¨ Ø¬Ø¯ÙŠØ¯',
              'Ø§Ø³ØªÙ„Ø§Ù… Ø¥Ø´Ø¹Ø§Ø± ÙÙˆØ±ÙŠ Ø¹Ù†Ø¯ ÙˆØµÙˆÙ„ Ø·Ù„Ø¨ Ø¬Ø¯ÙŠØ¯',
              AppIcons.notifications,
              true,
            ),
            _buildSwitchTile(
              'Ø¥Ø´Ø¹Ø§Ø± ØµÙˆØªÙŠ',
              'ØªØ´ØºÙŠÙ„ ØµÙˆØª Ø¹Ù†Ø¯ ÙˆØµÙˆÙ„ Ø·Ù„Ø¨',
              AppIcons.mic,
              true,
            ),
            _buildSwitchTile(
              'Ø¥Ø´Ø¹Ø§Ø± Ø¨Ø±ÙŠØ¯ Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ',
              'Ø¥Ø±Ø³Ø§Ù„ Ù†Ø³Ø®Ø© Ù…Ù† Ø§Ù„Ø·Ù„Ø¨ Ù„Ù„Ø¨Ø±ÙŠØ¯',
              AppIcons.email,
              false,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSettingsSection('Ø­Ø§Ù„Ø§Øª Ø§Ù„Ø·Ù„Ø¨', [
            _buildOptionTile(
              'Ø§Ù„Ø­Ø§Ù„Ø© Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠØ© Ù„Ù„Ø·Ù„Ø¨ Ø§Ù„Ø¬Ø¯ÙŠØ¯',
              'Ù‚ÙŠØ¯ Ø§Ù„Ù…Ø±Ø§Ø¬Ø¹Ø©',
              AppIcons.orders,
            ),
            _buildOptionTile(
              'ØªØ£ÙƒÙŠØ¯ Ø§Ù„Ø·Ù„Ø¨ ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹',
              'Ù…Ø¹Ø·Ù„',
              AppIcons.checkCircle,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSettingsSection('Ø®ÙŠØ§Ø±Ø§Øª Ø§Ù„Ø¥Ù„ØºØ§Ø¡', [
            _buildSwitchTile(
              'Ø§Ù„Ø³Ù…Ø§Ø­ Ù„Ù„Ø¹Ù…ÙŠÙ„ Ø¨Ø§Ù„Ø¥Ù„ØºØ§Ø¡',
              'Ø§Ù„Ø³Ù…Ø§Ø­ Ø¨Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø·Ù„Ø¨ Ù‚Ø¨Ù„ Ø§Ù„Ø´Ø­Ù†',
              AppIcons.close,
              true,
            ),
            _buildOptionTile('Ù…Ø¯Ø© Ø§Ù„Ø³Ù…Ø§Ø­ Ø¨Ø§Ù„Ø¥Ù„ØºØ§Ø¡', '24 Ø³Ø§Ø¹Ø©', AppIcons.time),
          ]),
        ],
      ),
    );
  }

  /// ØªØ¨ÙˆÙŠØ¨ ØªØ®ØµÙŠØµ Ø§Ù„ÙØ§ØªÙˆØ±Ø©
  Widget _buildInvoiceCustomizationTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsSection('Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„ÙØ§ØªÙˆØ±Ø©', [
            _buildSwitchTile(
              'Ø¥Ø¸Ù‡Ø§Ø± Ø´Ø¹Ø§Ø± Ø§Ù„Ù…ØªØ¬Ø±',
              'Ø¹Ø±Ø¶ Ø§Ù„Ø´Ø¹Ø§Ø± ÙÙŠ Ø£Ø¹Ù„Ù‰ Ø§Ù„ÙØ§ØªÙˆØ±Ø©',
              AppIcons.store,
              true,
            ),
            _buildSwitchTile(
              'Ø¥Ø¸Ù‡Ø§Ø± Ø±Ù‚Ù… Ø§Ù„Ø¶Ø±ÙŠØ¨Ø©',
              'Ø¹Ø±Ø¶ Ø§Ù„Ø±Ù‚Ù… Ø§Ù„Ø¶Ø±ÙŠØ¨ÙŠ ÙÙŠ Ø§Ù„ÙØ§ØªÙˆØ±Ø©',
              AppIcons.document,
              false,
            ),
            _buildOptionTile('Ø¹Ù†ÙˆØ§Ù† Ø§Ù„ÙØ§ØªÙˆØ±Ø©', 'ÙØ§ØªÙˆØ±Ø© Ø¶Ø±ÙŠØ¨ÙŠØ©', AppIcons.edit),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSettingsSection('ØªÙØ§ØµÙŠÙ„ Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª', [
            _buildSwitchTile(
              'Ø¥Ø¸Ù‡Ø§Ø± ØµÙˆØ±Ø© Ø§Ù„Ù…Ù†ØªØ¬',
              'Ø¹Ø±Ø¶ ØµÙˆØ±Ø© Ù…ØµØºØ±Ø© Ù„Ù„Ù…Ù†ØªØ¬',
              AppIcons.image,
              true,
            ),
            _buildSwitchTile(
              'Ø¥Ø¸Ù‡Ø§Ø± Ø±Ù…Ø² SKU',
              'Ø¹Ø±Ø¶ Ø±Ù…Ø² Ø§Ù„Ù…Ù†ØªØ¬ ÙÙŠ Ø§Ù„ÙØ§ØªÙˆØ±Ø©',
              AppIcons.tag,
              false,
            ),
            _buildSwitchTile(
              'Ø¥Ø¸Ù‡Ø§Ø± Ø§Ù„Ø®ØµÙˆÙ…Ø§Øª',
              'Ø¹Ø±Ø¶ Ù‚ÙŠÙ…Ø© Ø§Ù„Ø®ØµÙ… Ù„ÙƒÙ„ Ù…Ù†ØªØ¬',
              AppIcons.discount,
              true,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSettingsSection('Ø§Ù„ØªØ°ÙŠÙŠÙ„', [
            _buildOptionTile(
              'Ø±Ø³Ø§Ù„Ø© Ø´ÙƒØ±',
              'Ø´ÙƒØ±Ø§Ù‹ Ù„ØªØ³ÙˆÙ‚ÙƒÙ… Ù…Ø¹Ù†Ø§!',
              AppIcons.heart,
            ),
            _buildSwitchTile(
              'Ø¥Ø¸Ù‡Ø§Ø± Ø±Ù…Ø² QR',
              'Ø±Ù…Ø² QR Ù„Ø±Ø§Ø¨Ø· Ø§Ù„Ù…ØªØ¬Ø±',
              AppIcons.qrCode,
              true,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing24),
          // Ø²Ø± Ù…Ø¹Ø§ÙŠÙ†Ø© Ø§Ù„ÙØ§ØªÙˆØ±Ø©
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeightL,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ø³ÙŠØªÙ… ÙØªØ­ Ù…Ø¹Ø§ÙŠÙ†Ø© Ø§Ù„ÙØ§ØªÙˆØ±Ø©'),
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
              label: const Text('Ù…Ø¹Ø§ÙŠÙ†Ø© Ø§Ù„ÙØ§ØªÙˆØ±Ø©'),
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
                  content: Text(newValue ? 'ØªÙ… Ø§Ù„ØªÙØ¹ÙŠÙ„' : 'ØªÙ… Ø§Ù„ØªØ¹Ø·ÙŠÙ„'),
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
            content: Text('ØªØ¹Ø¯ÙŠÙ„: $title'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }
}
