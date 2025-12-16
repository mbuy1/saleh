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

/// نموذج العميل
class CustomerItem {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? avatarUrl;
  final int totalOrders;
  final double totalSpent;
  final DateTime? lastOrderDate;
  final bool isFollower;
  final DateTime? followDate;

  CustomerItem({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.avatarUrl,
    required this.totalOrders,
    required this.totalSpent,
    this.lastOrderDate,
    required this.isFollower,
    this.followDate,
  });

  factory CustomerItem.fromJson(Map<String, dynamic> json) {
    return CustomerItem(
      id: json['customer_id'] ?? json['id'] ?? '',
      name: json['customer_name'] ?? json['name'] ?? 'عميل',
      phone: json['customer_phone'] ?? json['phone'],
      email: json['customer_email'] ?? json['email'],
      avatarUrl: json['customer_avatar'] ?? json['avatar_url'],
      totalOrders: json['total_orders'] ?? 0,
      totalSpent: (json['total_spent'] ?? 0).toDouble(),
      lastOrderDate: json['last_order_date'] != null
          ? DateTime.parse(json['last_order_date'])
          : null,
      isFollower: json['is_follower'] ?? false,
      followDate: json['follow_date'] != null
          ? DateTime.parse(json['follow_date'])
          : null,
    );
  }
}

/// شاشة العملاء
class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _api = ApiService();
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<CustomerItem> _allCustomers = [];
  List<CustomerItem> _followers = [];
  List<CustomerItem> _buyers = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  // إحصائيات
  int _totalCustomers = 0;
  int _totalFollowers = 0;
  double _totalRevenue = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCustomers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _api.get('/secure/customers');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          _allCustomers = (data['data'] as List)
              .map((item) => CustomerItem.fromJson(item))
              .toList();

          _followers = _allCustomers.where((c) => c.isFollower).toList();
          _buyers = _allCustomers.where((c) => c.totalOrders > 0).toList();

          // حساب الإحصائيات
          _totalCustomers = _allCustomers.length;
          _totalFollowers = _followers.length;
          _totalRevenue = _allCustomers.fold(0, (sum, c) => sum + c.totalSpent);
        }
      }
    } catch (e) {
      _error = 'حدث خطأ في تحميل العملاء';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  List<CustomerItem> _getFilteredCustomers(List<CustomerItem> customers) {
    if (_searchQuery.isEmpty) return customers;
    return customers.where((c) {
      return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (c.phone?.contains(_searchQuery) ?? false) ||
          (c.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'العملاء',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'بحث عن عميل...',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        AppIcons.search,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusM,
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                tabs: [
                  Tab(text: 'الكل ($_totalCustomers)'),
                  Tab(text: 'المتابعون ($_totalFollowers)'),
                  Tab(text: 'المشترون (${_buyers.length})'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorState()
          : Column(
              children: [
                // Stats
                _buildStatsBar(),
                // Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCustomersList(_getFilteredCustomers(_allCustomers)),
                      _buildCustomersList(_getFilteredCustomers(_followers)),
                      _buildCustomersList(_getFilteredCustomers(_buyers)),
                    ],
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
          SvgPicture.asset(
            AppIcons.errorOutline,
            width: 64,
            height: 64,
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
          ),
          SizedBox(height: AppDimensions.spacing16),
          Text(_error!, style: const TextStyle(color: Colors.red)),
          SizedBox(height: AppDimensions.spacing16),
          ElevatedButton(
            onPressed: _loadCustomers,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: AppDimensions.paddingM,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              iconPath: AppIcons.people,
              label: 'إجمالي العملاء',
              value: '$_totalCustomers',
              color: Colors.blue,
            ),
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: _buildStatCard(
              iconPath: AppIcons.favorite,
              label: 'المتابعون',
              value: '$_totalFollowers',
              color: Colors.red,
            ),
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: _buildStatCard(
              iconPath: AppIcons.attachMoney,
              label: 'الإيرادات',
              value: _totalRevenue.toStringAsFixed(0),
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String iconPath,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: AppDimensions.paddingS,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppDimensions.borderRadiusM,
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            width: AppDimensions.iconM,
            height: AppDimensions.iconM,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          SizedBox(height: AppDimensions.spacing4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontTitle,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersList(List<CustomerItem> customers) {
    if (customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.peopleOutline,
              width: 64,
              height: 64,
              colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
            ),
            SizedBox(height: AppDimensions.spacing16),
            Text(
              'لا يوجد عملاء',
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCustomers,
      child: ListView.separated(
        padding: AppDimensions.paddingM,
        itemCount: customers.length,
        separatorBuilder: (_, _) => SizedBox(height: AppDimensions.spacing8),
        itemBuilder: (context, index) {
          final customer = customers[index];
          return _buildCustomerCard(customer);
        },
      ),
    );
  }

  Widget _buildCustomerCard(CustomerItem customer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusM,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppDimensions.borderRadiusM,
        child: InkWell(
          onTap: () => _showCustomerDetails(customer),
          borderRadius: AppDimensions.borderRadiusM,
          child: Padding(
            padding: AppDimensions.paddingM,
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                  backgroundImage: customer.avatarUrl != null
                      ? NetworkImage(customer.avatarUrl!)
                      : null,
                  child: customer.avatarUrl == null
                      ? Text(
                          customer.name.isNotEmpty
                              ? customer.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppTheme.primaryColor,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: AppDimensions.spacing12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              customer.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (customer.isFollower)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: AppDimensions.borderRadiusS,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.favorite,
                                    width: AppDimensions.fontLabel,
                                    height: AppDimensions.fontLabel,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.red,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: AppDimensions.spacing4),
                                  Text(
                                    'متابع',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (customer.phone != null)
                        Text(
                          customer.phone!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      SizedBox(height: AppDimensions.spacing8),
                      Row(
                        children: [
                          _buildMiniStat(
                            AppIcons.shoppingBagOutlined,
                            '${customer.totalOrders} طلب',
                          ),
                          SizedBox(width: AppDimensions.spacing16),
                          _buildMiniStat(
                            AppIcons.attachMoney,
                            '${customer.totalSpent.toStringAsFixed(0)} ر.س',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow
                SvgPicture.asset(
                  AppIcons.arrowForward,
                  width: AppDimensions.iconXS,
                  height: AppDimensions.iconXS,
                  colorFilter: ColorFilter.mode(
                    Colors.grey[400]!,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String iconPath, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconPath,
          width: AppDimensions.fontBody,
          height: AppDimensions.fontBody,
          colorFilter: ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn),
        ),
        SizedBox(width: AppDimensions.spacing4),
        Text(
          text,
          style: TextStyle(
            fontSize: AppDimensions.fontLabel,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showCustomerDetails(CustomerItem customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
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
              const SizedBox(height: 24),
              // Avatar & Name
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    backgroundImage: customer.avatarUrl != null
                        ? NetworkImage(customer.avatarUrl!)
                        : null,
                    child: customer.avatarUrl == null
                        ? Text(
                            customer.name.isNotEmpty
                                ? customer.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: AppTheme.primaryColor,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if (customer.isFollower)
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.favorite,
                                width: 14,
                                height: 14,
                                colorFilter: const ColorFilter.mode(
                                  Colors.red,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'متابع للمتجر',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Contact Info
              if (customer.phone != null || customer.email != null) ...[
                const Text(
                  'معلومات التواصل',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                if (customer.phone != null)
                  _buildContactRow(
                    AppIcons.phone,
                    customer.phone!,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: customer.phone!));
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم نسخ الرقم')),
                      );
                    },
                  ),
                if (customer.email != null)
                  _buildContactRow(
                    AppIcons.email,
                    customer.email!,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: customer.email!));
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم نسخ البريد')),
                      );
                    },
                  ),
                const SizedBox(height: 24),
              ],
              // Stats
              const Text(
                'إحصائيات العميل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailStat(
                      'عدد الطلبات',
                      '${customer.totalOrders}',
                      AppIcons.shoppingBag,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailStat(
                      'إجمالي المشتريات',
                      '${customer.totalSpent.toStringAsFixed(0)} ر.س',
                      AppIcons.attachMoney,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              if (customer.lastOrderDate != null) ...[
                const SizedBox(height: 12),
                _buildDetailStat(
                  'آخر طلب',
                  DateFormat('dd/MM/yyyy').format(customer.lastOrderDate!),
                  AppIcons.calendar,
                  Colors.orange,
                  fullWidth: true,
                ),
              ],
              const SizedBox(height: 24),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to orders filtered by this customer
                        context.push(
                          '/dashboard/orders?customer=${customer.id}',
                        );
                      },
                      icon: SvgPicture.asset(
                        AppIcons.shoppingBagOutlined,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          AppTheme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: const Text('عرض الطلبات'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(String iconPath, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(Colors.grey[600]!, BlendMode.srcIn),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
            if (onTap != null)
              SvgPicture.asset(
                AppIcons.copy,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  Colors.grey[400]!,
                  BlendMode.srcIn,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailStat(
    String label,
    String value,
    String iconPath,
    Color color, {
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
