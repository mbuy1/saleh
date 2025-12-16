import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// صفحة إدارة العروض الخاطفة
class FlashSalesScreen extends ConsumerStatefulWidget {
  const FlashSalesScreen({super.key});

  @override
  ConsumerState<FlashSalesScreen> createState() => _FlashSalesScreenState();
}

class _FlashSalesScreenState extends ConsumerState<FlashSalesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  bool _isLoading = true;
  List<FlashSale> _flashSales = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFlashSales();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFlashSales() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final httpResponse = await _api.get('/secure/flash-sales');
      final response = jsonDecode(httpResponse.body) as Map<String, dynamic>;
      if (response['ok'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        setState(() {
          _flashSales = data.map((e) => FlashSale.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception(response['error'] ?? 'فشل في جلب العروض');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<FlashSale> get _activeSales =>
      _flashSales.where((s) => s.status == 'active').toList();

  List<FlashSale> get _scheduledSales => _flashSales
      .where((s) => s.status == 'scheduled' || s.status == 'draft')
      .toList();

  List<FlashSale> get _endedSales => _flashSales
      .where((s) => s.status == 'ended' || s.status == 'cancelled')
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('العروض الخاطفة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showCreateFlashSaleSheet,
            tooltip: 'إنشاء عرض',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.flash_on, size: 20),
              text: 'نشط (${_activeSales.length})',
            ),
            Tab(
              icon: const Icon(Icons.schedule, size: 20),
              text: 'مجدول (${_scheduledSales.length})',
            ),
            Tab(
              icon: const Icon(Icons.history, size: 20),
              text: 'منتهي (${_endedSales.length})',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSalesList(_activeSales, showTimer: true),
                _buildSalesList(_scheduledSales),
                _buildSalesList(_endedSales),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateFlashSaleSheet,
        icon: const Icon(Icons.flash_on),
        label: const Text('عرض جديد'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          SizedBox(height: AppDimensions.spacing16),
          Text(_error ?? 'حدث خطأ', style: const TextStyle(color: Colors.red)),
          SizedBox(height: AppDimensions.spacing16),
          ElevatedButton.icon(
            onPressed: _loadFlashSales,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesList(List<FlashSale> sales, {bool showTimer = false}) {
    if (sales.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flash_off_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: AppDimensions.spacing16),
            Text(
              'لا توجد عروض',
              style: TextStyle(
                fontSize: AppDimensions.fontHeadline,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: AppDimensions.spacing8),
            const Text('أنشئ عرضاً خاطفاً لزيادة مبيعاتك'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFlashSales,
      child: ListView.builder(
        padding: AppDimensions.paddingM,
        itemCount: sales.length,
        itemBuilder: (context, index) =>
            _buildFlashSaleCard(sales[index], showTimer: showTimer),
      ),
    );
  }

  Widget _buildFlashSaleCard(FlashSale sale, {bool showTimer = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showFlashSaleDetails(sale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image or Gradient
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: sale.status == 'active'
                      ? [Colors.orange.shade400, Colors.red.shade400]
                      : [Colors.grey.shade400, Colors.grey.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  if (sale.coverImage != null)
                    Positioned.fill(
                      child: Image.network(
                        sale.coverImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
                    ),
                  // Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  // Status Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(sale.status),
                        borderRadius: AppDimensions.borderRadiusXL,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(sale.status),
                            size: AppDimensions.fontBody,
                            color: Colors.white,
                          ),
                          SizedBox(width: AppDimensions.spacing4),
                          Text(
                            _getStatusText(sale.status),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDimensions.fontLabel,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Timer
                  if (showTimer && sale.status == 'active')
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: _CountdownTimer(endsAt: sale.endsAt),
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: AppDimensions.paddingM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sale.titleAr ?? sale.title,
                    style: TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: AppDimensions.iconXS,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: AppDimensions.spacing4),
                      Text(
                        '${sale.productsCount} منتج',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      SizedBox(width: AppDimensions.spacing16),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: AppDimensions.iconXS,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: AppDimensions.spacing4),
                      Text(
                        _formatDateRange(sale.startsAt, sale.endsAt),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  if (sale.isFeatured) ...[
                    SizedBox(height: AppDimensions.spacing8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: AppDimensions.borderRadiusS,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: AppDimensions.fontBody,
                            color: Colors.amber.shade700,
                          ),
                          SizedBox(width: AppDimensions.spacing4),
                          Text(
                            'عرض مميز',
                            style: TextStyle(
                              fontSize: AppDimensions.fontLabel,
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'draft':
        return Colors.grey;
      case 'ended':
        return Colors.grey.shade700;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.flash_on;
      case 'scheduled':
        return Icons.schedule;
      case 'draft':
        return Icons.edit_outlined;
      case 'ended':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'نشط';
      case 'scheduled':
        return 'مجدول';
      case 'draft':
        return 'مسودة';
      case 'ended':
        return 'منتهي';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  String _formatDateRange(DateTime start, DateTime end) {
    return '${start.day}/${start.month} - ${end.day}/${end.month}';
  }

  void _showCreateFlashSaleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateFlashSaleSheet(
        onCreated: () {
          Navigator.pop(context);
          _loadFlashSales();
        },
      ),
    );
  }

  void _showFlashSaleDetails(FlashSale sale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FlashSaleDetailsSheet(
        sale: sale,
        onUpdated: () {
          Navigator.pop(context);
          _loadFlashSales();
        },
      ),
    );
  }
}

// ============================================================================
// Countdown Timer Widget
// ============================================================================

class _CountdownTimer extends StatefulWidget {
  final DateTime endsAt;

  const _CountdownTimer({required this.endsAt});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateRemaining(),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    final now = DateTime.now();
    setState(() {
      _remaining = widget.endsAt.difference(now);
      if (_remaining.isNegative) _remaining = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: AppDimensions.borderRadiusS,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            color: Colors.white,
            size: AppDimensions.iconXS,
          ),
          SizedBox(width: AppDimensions.spacing8),
          Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Create Flash Sale Sheet
// ============================================================================

class _CreateFlashSaleSheet extends StatefulWidget {
  final VoidCallback onCreated;

  const _CreateFlashSaleSheet({required this.onCreated});

  @override
  State<_CreateFlashSaleSheet> createState() => _CreateFlashSaleSheetState();
}

class _CreateFlashSaleSheetState extends State<_CreateFlashSaleSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _discountController = TextEditingController(text: '20');

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 24));
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool _isFeatured = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _createFlashSale() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final startsAt = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );

      final endsAt = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      final api = ApiService();
      final httpResponse = await api.post(
        '/secure/flash-sales',
        body: {
          'title': _titleController.text,
          'title_ar': _titleController.text,
          'starts_at': startsAt.toIso8601String(),
          'ends_at': endsAt.toIso8601String(),
          'default_discount_type': 'percentage',
          'default_discount_value': double.parse(_discountController.text),
          'is_featured': _isFeatured,
        },
      );
      final response = jsonDecode(httpResponse.body) as Map<String, dynamic>;

      if (response['ok'] == true) {
        widget.onCreated();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء العرض بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception(response['error']);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'إنشاء عرض خاطف',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'اسم العرض *',
                        hintText: 'مثال: تخفيضات نهاية الأسبوع',
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _discountController,
                      decoration: const InputDecoration(
                        labelText: 'نسبة الخصم الافتراضية',
                        suffixText: '%',
                        prefixIcon: Icon(Icons.discount_outlined),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'وقت البداية',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setState(() => _startDate = date);
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _startTime,
                              );
                              if (time != null) {
                                setState(() => _startTime = time);
                              }
                            },
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              '${_startTime.hour}:${_startTime.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'وقت النهاية',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) setState(() => _endDate = date);
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _endTime,
                              );
                              if (time != null) setState(() => _endTime = time);
                            },
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              '${_endTime.hour}:${_endTime.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: _isFeatured,
                      onChanged: (v) => setState(() => _isFeatured = v),
                      title: const Text('عرض مميز'),
                      subtitle: const Text('يظهر في أعلى الصفحة الرئيسية'),
                      secondary: const Icon(Icons.star_outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createFlashSale,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('إنشاء العرض'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Flash Sale Details Sheet
// ============================================================================

class _FlashSaleDetailsSheet extends StatelessWidget {
  final FlashSale sale;
  final VoidCallback onUpdated;

  const _FlashSaleDetailsSheet({required this.sale, required this.onUpdated});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  sale.titleAr ?? sale.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow('الحالة', sale.status),
                  _buildInfoRow(
                    'البداية',
                    '${sale.startsAt.day}/${sale.startsAt.month}/${sale.startsAt.year}',
                  ),
                  _buildInfoRow(
                    'النهاية',
                    '${sale.endsAt.day}/${sale.endsAt.month}/${sale.endsAt.year}',
                  ),
                  _buildInfoRow('عدد المنتجات', '${sale.productsCount}'),
                  _buildInfoRow('المشاهدات', '${sale.viewsCount}'),
                  const SizedBox(height: 24),
                  const Text(
                    'المنتجات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (sale.products.isEmpty)
                    const Text('لا توجد منتجات - أضف منتجات للعرض')
                  else
                    ...sale.products.map((p) => _buildProductTile(p)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (sale.status == 'draft' || sale.status == 'scheduled')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _activateSale(context),
                      icon: const Icon(Icons.flash_on),
                      label: const Text('تفعيل العرض'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                if (sale.status == 'active') ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _endSale(context),
                      icon: const Icon(Icons.stop),
                      label: const Text('إنهاء العرض'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildProductTile(FlashSaleProduct product) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(product.productName ?? 'منتج'),
      subtitle: Row(
        children: [
          Text(
            '${product.originalPrice} ر.س',
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${product.salePrice} ر.س',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '-${product.discountPercentage.toInt()}%',
          style: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _activateSale(BuildContext context) async {
    try {
      final api = ApiService();
      await api.post('/secure/flash-sales/${sale.id}/activate', body: {});
      onUpdated();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل: $e')));
    }
  }

  Future<void> _endSale(BuildContext context) async {
    try {
      final api = ApiService();
      await api.patch(
        '/secure/flash-sales/${sale.id}',
        body: {'status': 'ended'},
      );
      onUpdated();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل: $e')));
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العرض'),
        content: const Text('هل أنت متأكد من حذف هذا العرض؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final api = ApiService();
        await api.delete('/secure/flash-sales/${sale.id}');
        onUpdated();
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل: $e')));
      }
    }
  }
}

// ============================================================================
// Flash Sale Model
// ============================================================================

class FlashSale {
  final String id;
  final String title;
  final String? titleAr;
  final String? description;
  final String? coverImage;
  final DateTime startsAt;
  final DateTime endsAt;
  final String status;
  final bool isFeatured;
  final int viewsCount;
  final int ordersCount;
  final int productsCount;
  final List<FlashSaleProduct> products;

  FlashSale({
    required this.id,
    required this.title,
    this.titleAr,
    this.description,
    this.coverImage,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.isFeatured,
    required this.viewsCount,
    required this.ordersCount,
    required this.productsCount,
    required this.products,
  });

  factory FlashSale.fromJson(Map<String, dynamic> json) {
    final productsList = json['flash_sale_products'] as List<dynamic>? ?? [];
    return FlashSale(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      titleAr: json['title_ar'],
      description: json['description'],
      coverImage: json['cover_image'],
      startsAt: DateTime.parse(json['starts_at']),
      endsAt: DateTime.parse(json['ends_at']),
      status: json['status'] ?? 'draft',
      isFeatured: json['is_featured'] ?? false,
      viewsCount: json['views_count'] ?? 0,
      ordersCount: json['orders_count'] ?? 0,
      productsCount: productsList.length,
      products: productsList.map((p) => FlashSaleProduct.fromJson(p)).toList(),
    );
  }
}

class FlashSaleProduct {
  final String id;
  final String productId;
  final double originalPrice;
  final double salePrice;
  final double discountPercentage;
  final int? quantityLimit;
  final int quantitySold;
  final String? productName;

  FlashSaleProduct({
    required this.id,
    required this.productId,
    required this.originalPrice,
    required this.salePrice,
    required this.discountPercentage,
    this.quantityLimit,
    required this.quantitySold,
    this.productName,
  });

  factory FlashSaleProduct.fromJson(Map<String, dynamic> json) {
    final product = json['products'] as Map<String, dynamic>?;
    return FlashSaleProduct(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      originalPrice: (json['original_price'] ?? 0).toDouble(),
      salePrice: (json['sale_price'] ?? 0).toDouble(),
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      quantityLimit: json['quantity_limit'],
      quantitySold: json['quantity_sold'] ?? 0,
      productName: product?['name_ar'] ?? product?['name'],
    );
  }
}
