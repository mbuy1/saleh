import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/theme/app_theme.dart';

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
  final String? city;
  final bool isVip;
  final bool isNew;

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
    this.city,
    this.isVip = false,
    this.isNew = false,
  });

  factory CustomerItem.fromJson(Map<String, dynamic> json) {
    final createdAt = json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null;
    final isNewCustomer =
        createdAt != null && DateTime.now().difference(createdAt).inDays <= 30;

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
      city: json['city'] ?? json['customer_city'],
      isVip: (json['total_spent'] ?? 0) > 1000,
      isNew: isNewCustomer,
    );
  }
}

/// شاشة العملاء - التصميم الجديد
class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<CustomerItem> _allCustomers = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  int _selectedFilterIndex = 0;

  // إحصائيات
  int _totalCustomers = 0;
  int _newCustomersThisMonth = 0;

  // Colors - App Store Design Style

  final List<String> _filters = [
    'الكل',
    'الأكثر شراءً',
    'العملاء الجدد',
    'النشطون',
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
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

          _totalCustomers = _allCustomers.length;
          _newCustomersThisMonth = _allCustomers.where((c) => c.isNew).length;
        }
      }
    } catch (e) {
      _error = 'حدث خطأ في تحميل العملاء';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  List<CustomerItem> _getFilteredCustomers() {
    var customers = _allCustomers;

    // تطبيق فلتر البحث
    if (_searchQuery.isNotEmpty) {
      customers = customers.where((c) {
        return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (c.phone?.contains(_searchQuery) ?? false) ||
            (c.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                false);
      }).toList();
    }

    // تطبيق فلتر التصنيف
    switch (_selectedFilterIndex) {
      case 1: // الأكثر شراءً
        customers = List.from(customers)
          ..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
        break;
      case 2: // العملاء الجدد
        customers = customers.where((c) => c.isNew).toList();
        break;
      case 3: // النشطون
        customers = customers.where((c) => c.totalOrders > 0).toList();
        break;
    }

    return customers;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppTheme.backgroundColorDark
        : AppTheme.backgroundLight;
    final cardColor = isDark ? AppTheme.cardColorDark : Colors.white;
    final textColor = isDark
        ? AppTheme.textPrimaryColorDark
        : AppTheme.textPrimaryColor;
    final secondaryTextColor = isDark
        ? AppTheme.textSecondaryColorDark
        : AppTheme.textHintColorDark;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header Section
            _buildStickyHeader(
              isDark,
              textColor,
              secondaryTextColor,
              backgroundColor,
              cardColor,
            ),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : _error != null
                  ? _buildErrorState(textColor)
                  : RefreshIndicator(
                      onRefresh: _loadCustomers,
                      color: AppTheme.primaryColor,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // Stats Section
                            _buildStatsSection(
                              isDark,
                              cardColor,
                              secondaryTextColor,
                            ),
                            // Divider
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : AppTheme.textHintColorDark,
                            ),
                            const SizedBox(height: 8),
                            // Customer List
                            _buildCustomerList(
                              isDark,
                              cardColor,
                              textColor,
                              secondaryTextColor,
                            ),
                            // Loading More Indicator
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'جاري تحميل المزيد...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader(
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
    Color backgroundColor,
    Color cardColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppTheme.textHintColorDark,
          ),
        ),
      ),
      child: Column(
        children: [
          // Top App Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => context.canPop() ? context.pop() : null,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppTheme.textHintColorDark,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: textColor,
                      size: 24,
                    ),
                  ),
                ),
                // Title
                Expanded(
                  child: Text(
                    'العملاء',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                // Add Customer Button
                GestureDetector(
                  onTap: () {
                    // TODO: Add customer
                    HapticFeedback.lightImpact();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardColorDark : AppTheme.textHintColorDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.transparent),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.search,
                      color: secondaryTextColor,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'بحث بالاسم أو رقم الهاتف...',
                        hintStyle: TextStyle(
                          color: secondaryTextColor.withValues(alpha: 0.7),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Filter Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedFilterIndex = index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : (isDark
                                  ? AppTheme.cardColorDark
                                  : AppTheme.textHintColorDark),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : AppTheme.textHintColorDark),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _filters[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.backgroundColorDark
                              : secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    bool isDark,
    Color cardColor,
    Color secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // إجمالي العملاء
          Expanded(
            child: _buildStatCard(
              icon: Icons.groups,
              title: 'إجمالي العملاء',
              value: '$_totalCustomers',
              trend: '+5%',
              isDark: isDark,
              cardColor: cardColor,
              secondaryTextColor: secondaryTextColor,
            ),
          ),
          const SizedBox(width: 12),
          // جدد هذا الشهر
          Expanded(
            child: _buildStatCard(
              icon: Icons.person_add,
              title: 'جدد هذا الشهر',
              value: '$_newCustomersThisMonth',
              trend: '+2%',
              isDark: isDark,
              cardColor: cardColor,
              secondaryTextColor: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String trend,
    required bool isDark,
    required Color cardColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  AppTheme.cardColorDark,
                  AppTheme.cardColorDark.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isDark ? null : cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppTheme.textHintColorDark,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppTheme.primaryColor,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trend,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final customers = _getFilteredCustomers();

    if (customers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: secondaryTextColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'لا يوجد عملاء',
                style: TextStyle(fontSize: 18, color: secondaryTextColor),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: customers.map((customer) {
          return _buildCustomerCard(
            customer,
            isDark,
            cardColor,
            textColor,
            secondaryTextColor,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCustomerCard(
    CustomerItem customer,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    // توليد لون عشوائي للأفاتار
    final avatarColors = [
      Colors.purple,
      Colors.blue,
      Colors.teal,
      Colors.orange,
      Colors.pink,
    ];
    final colorIndex = customer.name.hashCode % avatarColors.length;
    final avatarColor = avatarColors[colorIndex.abs()];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.cardColorDark.withValues(alpha: 0.5)
            : cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        children: [
          // Customer Info Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: customer.avatarUrl == null
                      ? avatarColor.withValues(alpha: 0.2)
                      : null,
                  image: customer.avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(customer.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppTheme.textHintColorDark,
                    width: 2,
                  ),
                ),
                child: customer.avatarUrl == null
                    ? Center(
                        child: Text(
                          customer.name.isNotEmpty
                              ? customer.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: avatarColor,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Name & Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Orders & Spent
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : AppTheme.textHintColorDark,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${customer.totalOrders} طلبات',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : AppTheme.textHintColorDark,
                            ),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: secondaryTextColor.withValues(alpha: 0.3),
                          ),
                        ),
                        Text(
                          '${customer.totalSpent.toStringAsFixed(0)} ر.س',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    // Location
                    if (customer.city != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: secondaryTextColor.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${customer.city}، السعودية',
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryTextColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Badge
              if (customer.isVip)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Text(
                    'VIP',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                )
              else if (customer.isNew)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Text(
                    'جديد',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 12),
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppTheme.textHintColorDark,
          ),
          // Action Buttons
          Row(
            children: [
              // Message Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // TODO: Open chat
                  },
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppTheme.textHintColorDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 18,
                          color: textColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'مراسلة',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Call Button
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (customer.phone != null) {
                    Clipboard.setData(ClipboardData(text: customer.phone!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ الرقم')),
                    );
                  }
                },
                child: Container(
                  width: 48,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.call,
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(_error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadCustomers,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.backgroundColorDark,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}


