import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// نموذج سجل التدقيق
class AuditLogEntry {
  final String id;
  final String storeId;
  final String? actorUserId;
  final String? actorName;
  final String action;
  final String entityType;
  final String? entityId;
  final String severity;
  final Map<String, dynamic>? changes;
  final Map<String, dynamic>? meta;
  final DateTime createdAt;

  AuditLogEntry({
    required this.id,
    required this.storeId,
    this.actorUserId,
    this.actorName,
    required this.action,
    required this.entityType,
    this.entityId,
    required this.severity,
    this.changes,
    this.meta,
    required this.createdAt,
  });

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) {
    return AuditLogEntry(
      id: json['id'] ?? '',
      storeId: json['store_id'] ?? '',
      actorUserId: json['actor_user_id'],
      actorName: json['user_profiles']?['full_name'] ?? 'مستخدم',
      action: json['action'] ?? '',
      entityType: json['entity_type'] ?? '',
      entityId: json['entity_id'],
      severity: json['severity'] ?? 'info',
      changes: json['changes'],
      meta: json['meta'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  String get actionText {
    switch (action) {
      // المنتجات
      case 'product_create':
        return 'إنشاء منتج';
      case 'product_update':
        return 'تعديل منتج';
      case 'product_delete':
        return 'حذف منتج';
      case 'product_stock_change':
        return 'تغيير المخزون';
      case 'product_price_change':
        return 'تغيير السعر';

      // الطلبات
      case 'order_create':
        return 'طلب جديد';
      case 'order_status_change':
        return 'تغيير حالة الطلب';
      case 'order_cancel':
        return 'إلغاء طلب';

      // المتجر
      case 'store_update':
        return 'تحديث المتجر';
      case 'store_settings_change':
        return 'تغيير الإعدادات';

      // الاختصارات
      case 'shortcut_add':
        return 'إضافة اختصار';
      case 'shortcut_remove':
        return 'حذف اختصار';
      case 'shortcut_reorder':
        return 'إعادة ترتيب الاختصارات';

      // الحملات
      case 'promotion_create':
        return 'إنشاء حملة';
      case 'promotion_end':
        return 'إنهاء حملة';

      // المالية
      case 'points_add':
        return 'إضافة نقاط';
      case 'points_spend':
        return 'صرف نقاط';

      default:
        return action;
    }
  }

  String get entityTypeText {
    switch (entityType) {
      case 'product':
        return 'منتج';
      case 'order':
        return 'طلب';
      case 'store':
        return 'متجر';
      case 'shortcut':
        return 'اختصار';
      case 'promotion':
        return 'حملة';
      case 'inventory':
        return 'مخزون';
      case 'settings':
        return 'إعدادات';
      default:
        return entityType;
    }
  }

  IconData get actionIcon {
    if (action.startsWith('product_')) return Icons.inventory_2;
    if (action.startsWith('order_')) return Icons.receipt_long;
    if (action.startsWith('store_')) return Icons.store;
    if (action.startsWith('shortcut_')) return Icons.bolt;
    if (action.startsWith('promotion_')) return Icons.campaign;
    if (action.startsWith('points_')) return Icons.stars;
    return Icons.history;
  }

  Color get severityColor {
    switch (severity) {
      case 'critical':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color get actionColor {
    if (action.contains('delete') || action.contains('cancel')) {
      return Colors.red;
    }
    if (action.contains('create') || action.contains('add')) {
      return Colors.green;
    }
    if (action.contains('update') || action.contains('change')) {
      return Colors.orange;
    }
    return Colors.blue;
  }
}

/// شاشة سجلات التدقيق
class AuditLogsScreen extends ConsumerStatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  ConsumerState<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends ConsumerState<AuditLogsScreen> {
  final ApiService _api = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<AuditLogEntry> _logs = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  // فلاتر
  String? _selectedEntityType;
  String? _selectedAction;
  DateTime? _startDate;
  DateTime? _endDate;

  int _offset = 0;
  final int _limit = 30;
  bool _hasMore = true;

  final List<String> _entityTypes = [
    'product',
    'order',
    'store',
    'shortcut',
    'promotion',
    'inventory',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _offset = 0;
      _logs = [];
    });

    await _fetchLogs();
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await _fetchLogs(isLoadMore: true);
    setState(() => _isLoadingMore = false);
  }

  Future<void> _fetchLogs({bool isLoadMore = false}) async {
    try {
      final queryParams = <String, String>{
        'limit': _limit.toString(),
        'offset': _offset.toString(),
      };

      if (_selectedEntityType != null) {
        queryParams['entity_type'] = _selectedEntityType!;
      }
      if (_selectedAction != null) {
        queryParams['action'] = _selectedAction!;
      }
      if (_startDate != null) {
        queryParams['start_date'] = _startDate!.toIso8601String();
      }
      if (_endDate != null) {
        queryParams['end_date'] = _endDate!.toIso8601String();
      }

      final response = await _api.get(
        '/secure/audit-logs',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          final newLogs = (data['data'] as List)
              .map((item) => AuditLogEntry.fromJson(item))
              .toList();

          setState(() {
            if (isLoadMore) {
              _logs.addAll(newLogs);
            } else {
              _logs = newLogs;
            }
            _offset += newLogs.length;
            _hasMore = newLogs.length >= _limit;
          });
        }
      }
    } catch (e) {
      if (!isLoadMore) {
        _error = 'حدث خطأ في تحميل البيانات';
      }
    }

    if (mounted && !isLoadMore) {
      setState(() => _isLoading = false);
    }
  }

  void _showFiltersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FiltersSheet(
        selectedEntityType: _selectedEntityType,
        startDate: _startDate,
        endDate: _endDate,
        entityTypes: _entityTypes,
        onApply: (entityType, startDate, endDate) {
          setState(() {
            _selectedEntityType = entityType;
            _startDate = startDate;
            _endDate = endDate;
          });
          _loadData();
        },
      ),
    );
  }

  void _showLogDetails(AuditLogEntry log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LogDetailsSheet(log: log),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'سجلات النشاط',
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
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (_selectedEntityType != null || _startDate != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFiltersSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorView()
          : _buildContent(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(_error!, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا توجد سجلات',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            if (_selectedEntityType != null || _startDate != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedEntityType = null;
                    _selectedAction = null;
                    _startDate = null;
                    _endDate = null;
                  });
                  _loadData();
                },
                child: const Text('إزالة الفلاتر'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _logs.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _logs.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return _buildLogCard(_logs[index]);
        },
      ),
    );
  }

  Widget _buildLogCard(AuditLogEntry log) {
    return GestureDetector(
      onTap: () => _showLogDetails(log),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: log.actionColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(log.actionIcon, color: log.actionColor, size: 22),
              ),
              const SizedBox(width: 12),
              // المحتوى
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            log.actionText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: log.severityColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            log.entityTypeText,
                            style: TextStyle(
                              color: log.severityColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'بواسطة: ${log.actorName ?? 'النظام'}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('yyyy/MM/dd - HH:mm').format(log.createdAt),
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),
              // سهم التفاصيل
              Icon(Icons.chevron_left, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// نافذة الفلاتر
class _FiltersSheet extends StatefulWidget {
  final String? selectedEntityType;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> entityTypes;
  final Function(String?, DateTime?, DateTime?) onApply;

  const _FiltersSheet({
    required this.selectedEntityType,
    required this.startDate,
    required this.endDate,
    required this.entityTypes,
    required this.onApply,
  });

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  String? _entityType;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _entityType = widget.selectedEntityType;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  String _entityTypeText(String type) {
    switch (type) {
      case 'product':
        return 'منتج';
      case 'order':
        return 'طلب';
      case 'store':
        return 'متجر';
      case 'shortcut':
        return 'اختصار';
      case 'promotion':
        return 'حملة';
      case 'inventory':
        return 'مخزون';
      default:
        return type;
    }
  }

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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

            const Text(
              'فلترة السجلات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // نوع الكيان
            const Text(
              'نوع السجل',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('الكل'),
                  selected: _entityType == null,
                  onSelected: (_) => setState(() => _entityType = null),
                ),
                ...widget.entityTypes.map(
                  (type) => FilterChip(
                    label: Text(_entityTypeText(type)),
                    selected: _entityType == type,
                    onSelected: (_) => setState(() => _entityType = type),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // التاريخ
            const Text(
              'الفترة الزمنية',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(true),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      _startDate != null
                          ? DateFormat('yyyy/MM/dd').format(_startDate!)
                          : 'من',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(false),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      _endDate != null
                          ? DateFormat('yyyy/MM/dd').format(_endDate!)
                          : 'إلى',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // الأزرار
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _entityType = null;
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                    child: const Text('إعادة تعيين'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_entityType, _startDate, _endDate);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text('تطبيق'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// نافذة تفاصيل السجل
class _LogDetailsSheet extends StatelessWidget {
  final AuditLogEntry log;

  const _LogDetailsSheet({required this.log});

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

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: log.actionColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(log.actionIcon, color: log.actionColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.actionText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        log.entityTypeText,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // التفاصيل
            _buildDetailRow('المستخدم', log.actorName ?? 'النظام'),
            _buildDetailRow(
              'التاريخ',
              DateFormat('yyyy/MM/dd HH:mm:ss').format(log.createdAt),
            ),
            _buildDetailRow('مستوى الخطورة', log.severity),
            if (log.entityId != null)
              _buildDetailRow('معرف الكيان', log.entityId!),

            // التغييرات
            if (log.changes != null && log.changes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'التغييرات',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (log.changes!['before'] != null)
                      _buildChangeSection('قبل', log.changes!['before']),
                    if (log.changes!['before'] != null &&
                        log.changes!['after'] != null)
                      const Divider(),
                    if (log.changes!['after'] != null)
                      _buildChangeSection('بعد', log.changes!['after']),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeSection(String title, dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        if (data is Map)
          ...data.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 4),
              child: Text(
                '${e.key}: ${e.value}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          )
        else
          Text(data.toString(), style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
