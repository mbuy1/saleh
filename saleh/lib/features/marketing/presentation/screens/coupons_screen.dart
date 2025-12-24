import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// ØµÙØ­Ø© Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„ÙƒÙˆØ¨ÙˆÙ†Ø§Øª Ø§Ù„Ø°ÙƒÙŠØ©
class CouponsScreen extends ConsumerStatefulWidget {
  const CouponsScreen({super.key});

  @override
  ConsumerState<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends ConsumerState<CouponsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  bool _isLoading = true;
  List<Coupon> _coupons = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCoupons();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCoupons() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final httpResponse = await _api.get('/secure/coupons');
      final response = jsonDecode(httpResponse.body) as Map<String, dynamic>;
      if (response['ok'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        setState(() {
          _coupons = data.map((e) => Coupon.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception(response['error'] ?? 'ÙØ´Ù„ ÙÙŠ Ø¬Ù„Ø¨ Ø§Ù„ÙƒÙˆØ¨ÙˆÙ†Ø§Øª');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Coupon> get _activeCoupons =>
      _coupons.where((c) => c.isActive && !c.isExpired).toList();

  List<Coupon> get _expiredCoupons =>
      _coupons.where((c) => c.isExpired || !c.isActive).toList();

  List<Coupon> get _smartCoupons =>
      _coupons.where((c) => c.smartType != null).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('Ø§Ù„ÙƒÙˆØ¨ÙˆÙ†Ø§Øª'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showCreateCouponSheet,
            tooltip: 'Ø¥Ù†Ø´Ø§Ø¡ ÙƒÙˆØ¨ÙˆÙ†',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Ù†Ø´Ø· (${_activeCoupons.length})'),
            Tab(text: 'Ø°ÙƒÙŠ (${_smartCoupons.length})'),
            Tab(text: 'Ù…Ù†ØªÙ‡ÙŠ (${_expiredCoupons.length})'),
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
                _buildCouponsList(_activeCoupons),
                _buildSmartCouponsTab(),
                _buildCouponsList(_expiredCoupons),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateCouponSheet,
        icon: const Icon(Icons.add),
        label: const Text('ÙƒÙˆØ¨ÙˆÙ† Ø¬Ø¯ÙŠØ¯'),
        backgroundColor: AppTheme.primaryColor,
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
          Text(_error ?? 'Ø­Ø¯Ø« Ø®Ø·Ø£', style: const TextStyle(color: Colors.red)),
          SizedBox(height: AppDimensions.spacing16),
          ElevatedButton.icon(
            onPressed: _loadCoupons,
            icon: const Icon(Icons.refresh),
            label: const Text('Ø¥Ø¹Ø§Ø¯Ø© Ø§Ù„Ù…Ø­Ø§ÙˆÙ„Ø©'),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponsList(List<Coupon> coupons) {
    if (coupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: AppDimensions.spacing16),
            Text(
              'Ù„Ø§ ØªÙˆØ¬Ø¯ ÙƒÙˆØ¨ÙˆÙ†Ø§Øª',
              style: TextStyle(
                fontSize: AppDimensions.fontHeadline,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: AppDimensions.spacing8),
            const Text('Ø£Ù†Ø´Ø¦ ÙƒÙˆØ¨ÙˆÙ† Ø¬Ø¯ÙŠØ¯ Ù„Ø¬Ø°Ø¨ Ø§Ù„Ù…Ø²ÙŠØ¯ Ù…Ù† Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCoupons,
      child: ListView.builder(
        padding: AppDimensions.paddingM,
        itemCount: coupons.length,
        itemBuilder: (context, index) => _buildCouponCard(coupons[index]),
      ),
    );
  }

  Widget _buildSmartCouponsTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Smart Coupon Types
          Text(
            'Ø¥Ù†Ø´Ø§Ø¡ ÙƒÙˆØ¨ÙˆÙ† Ø°ÙƒÙŠ',
            style: TextStyle(
              fontSize: AppDimensions.fontHeadline,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),
          _buildSmartCouponOption(
            'first_order',
            'Ø®ØµÙ… Ø§Ù„ØªØ±Ø­ÙŠØ¨',
            'ÙƒÙˆØ¨ÙˆÙ† ØªÙ„Ù‚Ø§Ø¦ÙŠ Ù„Ù„Ø¹Ù…Ù„Ø§Ø¡ Ø§Ù„Ø¬Ø¯Ø¯',
            Icons.celebration_outlined,
            Colors.green,
          ),
          _buildSmartCouponOption(
            'abandoned_cart',
            'Ø§Ø³ØªØ±Ø¬Ø§Ø¹ Ø§Ù„Ø³Ù„Ø©',
            'Ø¥Ø´Ø¹Ø§Ø± Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡ Ø§Ù„Ø°ÙŠÙ† ØªØ±ÙƒÙˆØ§ Ø³Ù„ØªÙ‡Ù…',
            Icons.shopping_cart_outlined,
            Colors.orange,
          ),
          _buildSmartCouponOption(
            'win_back',
            'Ø§Ø³ØªØ±Ø¬Ø§Ø¹ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡',
            'Ø®ØµÙ… Ù„Ù„Ø¹Ù…Ù„Ø§Ø¡ Ø§Ù„Ù…Ù†Ù‚Ø·Ø¹ÙŠÙ†',
            Icons.people_outline,
            Colors.blue,
          ),
          _buildSmartCouponOption(
            'social_share',
            'Ø®ØµÙ… Ø§Ù„Ù…Ø´Ø§Ø±ÙƒØ©',
            'ÙƒÙˆØ¨ÙˆÙ† Ø¹Ù†Ø¯ Ù…Ø´Ø§Ø±ÙƒØ© Ø§Ù„Ù…ØªØ¬Ø±',
            Icons.share_outlined,
            Colors.purple,
          ),

          if (_smartCoupons.isNotEmpty) ...[
            SizedBox(height: AppDimensions.spacing24),
            Text(
              'Ø§Ù„ÙƒÙˆØ¨ÙˆÙ†Ø§Øª Ø§Ù„Ø°ÙƒÙŠØ© Ø§Ù„Ù†Ø´Ø·Ø©',
              style: TextStyle(
                fontSize: AppDimensions.fontHeadline,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppDimensions.spacing16),
            ..._smartCoupons.map((c) => _buildCouponCard(c)),
          ],
        ],
      ),
    );
  }

  Widget _buildSmartCouponOption(
    String type,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: AppTheme.primaryColor,
          onPressed: () => _createSmartCoupon(type),
        ),
      ),
    );
  }

  Widget _buildCouponCard(Coupon coupon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusM),
      child: InkWell(
        onTap: () => _showCouponDetails(coupon),
        borderRadius: AppDimensions.borderRadiusM,
        child: Padding(
          padding: AppDimensions.paddingM,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Discount Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: coupon.isExpired
                          ? Colors.grey
                          : AppTheme.primaryColor,
                      borderRadius: AppDimensions.borderRadiusXL,
                    ),
                    child: Text(
                      coupon.discountText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon.titleAr ?? coupon.code,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimensions.fontTitle,
                          ),
                        ),
                        if (coupon.smartType != null)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Ø°ÙƒÙŠ',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.purple.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Copy Code Button
                  IconButton(
                    icon: const Icon(Icons.copy_outlined),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: coupon.code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ØªÙ… Ù†Ø³Ø® Ø§Ù„ÙƒÙˆØ¯')),
                      );
                    },
                    tooltip: 'Ù†Ø³Ø® Ø§Ù„ÙƒÙˆØ¯',
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.spacing12),
              // Code Display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: AppDimensions.borderRadiusS,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: AppDimensions.iconXS,
                    ),
                    SizedBox(width: AppDimensions.spacing8),
                    Text(
                      coupon.code,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spacing12),
              // Stats Row
              Row(
                children: [
                  _buildStatChip(
                    Icons.check_circle_outline,
                    '${coupon.timesUsed}',
                    'Ø§Ø³ØªØ®Ø¯Ø§Ù…',
                  ),
                  SizedBox(width: AppDimensions.spacing12),
                  if (coupon.usageLimit != null)
                    _buildStatChip(
                      Icons.inventory_2_outlined,
                      '${coupon.usageLimit}',
                      'Ø§Ù„Ø­Ø¯',
                    ),
                  const Spacer(),
                  if (coupon.expiresAt != null)
                    Text(
                      coupon.isExpired
                          ? 'Ù…Ù†ØªÙ‡ÙŠ'
                          : 'ÙŠÙ†ØªÙ‡ÙŠ ${_formatDate(coupon.expiresAt!)}',
                      style: TextStyle(
                        fontSize: AppDimensions.fontLabel,
                        color: coupon.isExpired ? Colors.red : Colors.grey,
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

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.fontBody, color: Colors.grey.shade600),
          SizedBox(width: AppDimensions.spacing4),
          Text(
            '$value $label',
            style: TextStyle(
              fontSize: AppDimensions.fontLabel,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCreateCouponSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateCouponSheet(
        onCreated: () {
          Navigator.pop(context);
          _loadCoupons();
        },
      ),
    );
  }

  void _showCouponDetails(Coupon coupon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CouponDetailsSheet(
        coupon: coupon,
        onUpdated: () {
          Navigator.pop(context);
          _loadCoupons();
        },
        onDeleted: () {
          Navigator.pop(context);
          _loadCoupons();
        },
      ),
    );
  }

  Future<void> _createSmartCoupon(String type) async {
    // Show discount input dialog
    final discount = await showDialog<int>(
      context: context,
      builder: (context) => _DiscountInputDialog(type: type),
    );

    if (discount == null) return;

    try {
      final httpResponse = await _api.post(
        '/secure/coupons/smart',
        body: {'smart_type': type, 'discount_value': discount},
      );
      final response = jsonDecode(httpResponse.body) as Map<String, dynamic>;

      if (response['ok'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„ÙƒÙˆØ¨ÙˆÙ† Ø§Ù„Ø°ÙƒÙŠ Ø¨Ù†Ø¬Ø§Ø­'),
            backgroundColor: Colors.green,
          ),
        );
        _loadCoupons();
      } else {
        throw Exception(response['error']);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ÙØ´Ù„ ÙÙŠ Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„ÙƒÙˆØ¨ÙˆÙ†: $e')));
    }
  }
}

// ============================================================================
// Create Coupon Sheet
// ============================================================================

class _CreateCouponSheet extends StatefulWidget {
  final VoidCallback onCreated;

  const _CreateCouponSheet({required this.onCreated});

  @override
  State<_CreateCouponSheet> createState() => _CreateCouponSheetState();
}

class _CreateCouponSheetState extends State<_CreateCouponSheet> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _discountController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _maxDiscountController = TextEditingController();
  final _usageLimitController = TextEditingController();

  String _discountType = 'percentage';
  DateTime? _expiresAt;
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _discountController.dispose();
    _minOrderController.dispose();
    _maxDiscountController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }

  Future<void> _createCoupon() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final api = ApiService();
      final httpResponse = await api.post(
        '/secure/coupons',
        body: {
          'code': _codeController.text.toUpperCase(),
          'title_ar': _titleController.text,
          'discount_type': _discountType,
          'discount_value': double.parse(_discountController.text),
          'min_order_amount': _minOrderController.text.isNotEmpty
              ? double.parse(_minOrderController.text)
              : 0,
          'max_discount': _maxDiscountController.text.isNotEmpty
              ? double.parse(_maxDiscountController.text)
              : null,
          'usage_limit': _usageLimitController.text.isNotEmpty
              ? int.parse(_usageLimitController.text)
              : null,
          'expires_at': _expiresAt?.toIso8601String(),
        },
      );
      final response = jsonDecode(httpResponse.body) as Map<String, dynamic>;

      if (response['ok'] == true) {
        widget.onCreated();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„ÙƒÙˆØ¨ÙˆÙ† Ø¨Ù†Ø¬Ø§Ø­'),
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
      ).showSnackBar(SnackBar(content: Text('ÙØ´Ù„: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Ø¥Ù†Ø´Ø§Ø¡ ÙƒÙˆØ¨ÙˆÙ† Ø¬Ø¯ÙŠØ¯',
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
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Code
                    TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'ÙƒÙˆØ¯ Ø§Ù„ÙƒÙˆØ¨ÙˆÙ† *',
                        hintText: 'Ù…Ø«Ø§Ù„: SAVE20',
                        prefixIcon: Icon(Icons.confirmation_number_outlined),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (v) => v?.isEmpty ?? true ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
                    ),
                    const SizedBox(height: 16),
                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Ø§Ø³Ù… Ø§Ù„ÙƒÙˆØ¨ÙˆÙ†',
                        hintText: 'Ù…Ø«Ø§Ù„: Ø®ØµÙ… Ø§Ù„Ø¹ÙŠØ¯',
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Discount Type
                    const Text('Ù†ÙˆØ¹ Ø§Ù„Ø®ØµÙ…'),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'percentage',
                          label: Text('Ù†Ø³Ø¨Ø© %'),
                          icon: Icon(Icons.percent),
                        ),
                        ButtonSegment(
                          value: 'fixed',
                          label: Text('Ù…Ø¨Ù„Øº Ø«Ø§Ø¨Øª'),
                          icon: Icon(Icons.attach_money),
                        ),
                      ],
                      selected: {_discountType},
                      onSelectionChanged: (v) =>
                          setState(() => _discountType = v.first),
                    ),
                    const SizedBox(height: 16),
                    // Discount Value
                    TextFormField(
                      controller: _discountController,
                      decoration: InputDecoration(
                        labelText: 'Ù‚ÙŠÙ…Ø© Ø§Ù„Ø®ØµÙ… *',
                        suffixText: _discountType == 'percentage' ? '%' : 'Ø±.Ø³',
                        prefixIcon: const Icon(Icons.discount_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty ?? true ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
                    ),
                    const SizedBox(height: 16),
                    // Max Discount (for percentage)
                    if (_discountType == 'percentage')
                      TextFormField(
                        controller: _maxDiscountController,
                        decoration: const InputDecoration(
                          labelText: 'Ø§Ù„Ø­Ø¯ Ø§Ù„Ø£Ù‚ØµÙ‰ Ù„Ù„Ø®ØµÙ… (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)',
                          suffixText: 'Ø±.Ø³',
                          prefixIcon: Icon(Icons.vertical_align_top),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    const SizedBox(height: 16),
                    // Min Order
                    TextFormField(
                      controller: _minOrderController,
                      decoration: const InputDecoration(
                        labelText: 'Ø§Ù„Ø­Ø¯ Ø§Ù„Ø£Ø¯Ù†Ù‰ Ù„Ù„Ø·Ù„Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)',
                        suffixText: 'Ø±.Ø³',
                        prefixIcon: Icon(Icons.shopping_cart_outlined),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    // Usage Limit
                    TextFormField(
                      controller: _usageLimitController,
                      decoration: const InputDecoration(
                        labelText: 'Ø¹Ø¯Ø¯ Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù…Ø§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)',
                        hintText: 'Ø§ØªØ±ÙƒÙ‡ ÙØ§Ø±ØºØ§Ù‹ Ù„ØºÙŠØ± Ù…Ø­Ø¯ÙˆØ¯',
                        prefixIcon: Icon(Icons.repeat),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    // Expiry Date
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event_outlined),
                      title: const Text('ØªØ§Ø±ÙŠØ® Ø§Ù„Ø§Ù†ØªÙ‡Ø§Ø¡'),
                      subtitle: Text(
                        _expiresAt != null
                            ? '${_expiresAt!.day}/${_expiresAt!.month}/${_expiresAt!.year}'
                            : 'ØºÙŠØ± Ù…Ø­Ø¯Ø¯',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_calendar_outlined),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() => _expiresAt = date);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Submit Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createCoupon,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryColor,
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
                    : const Text('Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„ÙƒÙˆØ¨ÙˆÙ†'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Coupon Details Sheet
// ============================================================================

class _CouponDetailsSheet extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback onUpdated;
  final VoidCallback onDeleted;

  const _CouponDetailsSheet({
    required this.coupon,
    required this.onUpdated,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
                  coupon.titleAr ?? coupon.code,
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
                  _buildDetailRow('Ø§Ù„ÙƒÙˆØ¯', coupon.code),
                  _buildDetailRow('Ø§Ù„Ø®ØµÙ…', coupon.discountText),
                  _buildDetailRow(
                    'Ø§Ù„Ø­Ø¯ Ø§Ù„Ø£Ø¯Ù†Ù‰ Ù„Ù„Ø·Ù„Ø¨',
                    '${coupon.minOrderAmount} Ø±.Ø³',
                  ),
                  _buildDetailRow(
                    'Ø¹Ø¯Ø¯ Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù…Ø§Øª',
                    '${coupon.timesUsed}${coupon.usageLimit != null ? ' / ${coupon.usageLimit}' : ''}',
                  ),
                  _buildDetailRow('Ø§Ù„Ø­Ø§Ù„Ø©', coupon.isActive ? 'Ù†Ø´Ø·' : 'Ù…Ø¹Ø·Ù„'),
                  if (coupon.expiresAt != null)
                    _buildDetailRow(
                      'ÙŠÙ†ØªÙ‡ÙŠ ÙÙŠ',
                      '${coupon.expiresAt!.day}/${coupon.expiresAt!.month}/${coupon.expiresAt!.year}',
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _toggleActive(context),
                    child: Text(coupon.isActive ? 'ØªØ¹Ø·ÙŠÙ„' : 'ØªÙØ¹ÙŠÙ„'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: coupon.code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ØªÙ… Ù†Ø³Ø® Ø§Ù„ÙƒÙˆØ¯')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Ù†Ø³Ø® Ø§Ù„ÙƒÙˆØ¯'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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

  Future<void> _toggleActive(BuildContext context) async {
    try {
      final api = ApiService();
      await api.patch(
        '/secure/coupons/${coupon.id}',
        body: {'is_active': !coupon.isActive},
      );
      onUpdated();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ÙØ´Ù„: $e')));
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ø­Ø°Ù Ø§Ù„ÙƒÙˆØ¨ÙˆÙ†'),
        content: const Text('Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† Ø­Ø°Ù Ù‡Ø°Ø§ Ø§Ù„ÙƒÙˆØ¨ÙˆÙ†ØŸ'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Ø­Ø°Ù'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final api = ApiService();
        await api.delete('/secure/coupons/${coupon.id}');
        onDeleted();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('ÙØ´Ù„: $e')));
        }
      }
    }
  }
}

// ============================================================================
// Discount Input Dialog
// ============================================================================

class _DiscountInputDialog extends StatefulWidget {
  final String type;

  const _DiscountInputDialog({required this.type});

  @override
  State<_DiscountInputDialog> createState() => _DiscountInputDialogState();
}

class _DiscountInputDialogState extends State<_DiscountInputDialog> {
  final _controller = TextEditingController(text: '10');

  String get _title {
    switch (widget.type) {
      case 'first_order':
        return 'Ø®ØµÙ… Ø§Ù„ØªØ±Ø­ÙŠØ¨';
      case 'abandoned_cart':
        return 'Ø®ØµÙ… Ø§Ø³ØªØ±Ø¬Ø§Ø¹ Ø§Ù„Ø³Ù„Ø©';
      case 'win_back':
        return 'Ø®ØµÙ… Ø§Ø³ØªØ±Ø¬Ø§Ø¹ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡';
      case 'social_share':
        return 'Ø®ØµÙ… Ø§Ù„Ù…Ø´Ø§Ø±ÙƒØ©';
      default:
        return 'ÙƒÙˆØ¨ÙˆÙ† Ø°ÙƒÙŠ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Ù†Ø³Ø¨Ø© Ø§Ù„Ø®ØµÙ…',
          suffixText: '%',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ø¥Ù„ØºØ§Ø¡'),
        ),
        ElevatedButton(
          onPressed: () {
            final value = int.tryParse(_controller.text);
            if (value != null && value > 0 && value <= 100) {
              Navigator.pop(context, value);
            }
          },
          child: const Text('Ø¥Ù†Ø´Ø§Ø¡'),
        ),
      ],
    );
  }
}

// ============================================================================
// Coupon Model
// ============================================================================

class Coupon {
  final String id;
  final String code;
  final String? title;
  final String? titleAr;
  final String discountType;
  final double discountValue;
  final double? maxDiscount;
  final double minOrderAmount;
  final int? usageLimit;
  final int? usagePerCustomer;
  final int timesUsed;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final String? smartType;
  final bool isActive;

  Coupon({
    required this.id,
    required this.code,
    this.title,
    this.titleAr,
    required this.discountType,
    required this.discountValue,
    this.maxDiscount,
    required this.minOrderAmount,
    this.usageLimit,
    this.usagePerCustomer,
    required this.timesUsed,
    this.startsAt,
    this.expiresAt,
    this.smartType,
    required this.isActive,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      title: json['title'],
      titleAr: json['title_ar'],
      discountType: json['discount_type'] ?? 'percentage',
      discountValue: (json['discount_value'] ?? 0).toDouble(),
      maxDiscount: json['max_discount']?.toDouble(),
      minOrderAmount: (json['min_order_amount'] ?? 0).toDouble(),
      usageLimit: json['usage_limit'],
      usagePerCustomer: json['usage_per_customer'],
      timesUsed: json['times_used'] ?? 0,
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'])
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
      smartType: json['smart_type'],
      isActive: json['is_active'] ?? true,
    );
  }

  String get discountText {
    if (discountType == 'percentage') {
      return '${discountValue.toInt()}%';
    } else if (discountType == 'fixed') {
      return '${discountValue.toInt()} Ø±.Ø³';
    } else if (discountType == 'free_shipping') {
      return 'Ø´Ø­Ù† Ù…Ø¬Ø§Ù†ÙŠ';
    }
    return '$discountValue';
  }

  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());
}
