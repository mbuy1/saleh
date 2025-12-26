import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../../core/services/api_service.dart';

// ignore_for_file: unused_field

// ============================================================================
// Models
// ============================================================================

class AbandonedCart {
  final String id;
  final String storeId;
  final String? customerId;
  final String? customerEmail;
  final String? customerPhone;
  final String? customerName;
  final List<CartItem> cartItems;
  final double cartTotal;
  final int itemsCount;
  final String status;
  final DateTime? abandonedAt;
  final int reminderCount;
  final DateTime? reminderSentAt;
  final String? lastReminderType;
  final String? convertedOrderId;
  final DateTime? convertedAt;

  AbandonedCart({
    required this.id,
    required this.storeId,
    this.customerId,
    this.customerEmail,
    this.customerPhone,
    this.customerName,
    required this.cartItems,
    required this.cartTotal,
    required this.itemsCount,
    required this.status,
    this.abandonedAt,
    required this.reminderCount,
    this.reminderSentAt,
    this.lastReminderType,
    this.convertedOrderId,
    this.convertedAt,
  });

  factory AbandonedCart.fromJson(Map<String, dynamic> json) {
    List<CartItem> items = [];
    if (json['cart_items'] != null) {
      items = (json['cart_items'] as List)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return AbandonedCart(
      id: json['id'] ?? '',
      storeId: json['store_id'] ?? '',
      customerId: json['customer_id'],
      customerEmail: json['customer_email'],
      customerPhone: json['customer_phone'],
      customerName: json['customer_name'],
      cartItems: items,
      cartTotal: (json['cart_total'] ?? 0).toDouble(),
      itemsCount: json['items_count'] ?? 0,
      status: json['status'] ?? 'abandoned',
      abandonedAt: json['abandoned_at'] != null
          ? DateTime.parse(json['abandoned_at'])
          : null,
      reminderCount: json['reminder_count'] ?? 0,
      reminderSentAt: json['reminder_sent_at'] != null
          ? DateTime.parse(json['reminder_sent_at'])
          : null,
      lastReminderType: json['last_reminder_type'],
      convertedOrderId: json['converted_order_id'],
      convertedAt: json['converted_at'] != null
          ? DateTime.parse(json['converted_at'])
          : null,
    );
  }

  String get displayName {
    if (customerName != null && customerName!.isNotEmpty) return customerName!;
    if (customerEmail != null && customerEmail!.isNotEmpty) {
      return customerEmail!;
    }
    if (customerPhone != null && customerPhone!.isNotEmpty) {
      return customerPhone!;
    }
    return 'زائر';
  }

  String get timeSinceAbandoned {
    if (abandonedAt == null) return '';
    final diff = DateTime.now().difference(abandonedAt!);
    if (diff.inMinutes < 60) return '${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return '${diff.inHours} ساعة';
    return '${diff.inDays} يوم';
  }
}

class CartItem {
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      productImage: json['product_image'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}

class RecoverySettings {
  final String id;
  final String storeId;
  final bool autoRemindersEnabled;
  final int firstReminderDelay; // minutes
  final int secondReminderDelay;
  final int thirdReminderDelay;
  final bool includeDiscount;
  final double discountPercentage;
  final String reminderMessage;
  final int totalAbandoned;
  final int totalRecovered;
  final double totalRevenueRecovered;

  RecoverySettings({
    required this.id,
    required this.storeId,
    required this.autoRemindersEnabled,
    required this.firstReminderDelay,
    required this.secondReminderDelay,
    required this.thirdReminderDelay,
    required this.includeDiscount,
    required this.discountPercentage,
    required this.reminderMessage,
    required this.totalAbandoned,
    required this.totalRecovered,
    required this.totalRevenueRecovered,
  });

  factory RecoverySettings.fromJson(Map<String, dynamic> json) {
    return RecoverySettings(
      id: json['id'] ?? '',
      storeId: json['store_id'] ?? '',
      autoRemindersEnabled: json['auto_reminders_enabled'] ?? false,
      firstReminderDelay: json['first_reminder_delay'] ?? 60,
      secondReminderDelay: json['second_reminder_delay'] ?? 1440,
      thirdReminderDelay: json['third_reminder_delay'] ?? 4320,
      includeDiscount: json['include_discount'] ?? false,
      discountPercentage: (json['discount_percentage'] ?? 10).toDouble(),
      reminderMessage:
          json['reminder_message'] ?? 'لا تنسَ سلة التسوق الخاصة بك!',
      totalAbandoned: json['total_abandoned'] ?? 0,
      totalRecovered: json['total_recovered'] ?? 0,
      totalRevenueRecovered: (json['total_revenue_recovered'] ?? 0).toDouble(),
    );
  }
}

class AbandonedCartStats {
  final int totalAbandoned;
  final int totalRecovered;
  final double totalRevenueRecovered;
  final int recoveryRate;
  final int pendingCarts;
  final double totalPendingValue;

  AbandonedCartStats({
    required this.totalAbandoned,
    required this.totalRecovered,
    required this.totalRevenueRecovered,
    required this.recoveryRate,
    required this.pendingCarts,
    required this.totalPendingValue,
  });

  factory AbandonedCartStats.fromJson(Map<String, dynamic> json) {
    return AbandonedCartStats(
      totalAbandoned: json['total_abandoned'] ?? 0,
      totalRecovered: json['total_recovered'] ?? 0,
      totalRevenueRecovered: (json['total_revenue_recovered'] ?? 0).toDouble(),
      recoveryRate: json['recovery_rate'] ?? 0,
      pendingCarts: json['pending_carts'] ?? 0,
      totalPendingValue: (json['total_pending_value'] ?? 0).toDouble(),
    );
  }
}

// ============================================================================
// Main Screen
// ============================================================================

class AbandonedCartScreen extends StatefulWidget {
  const AbandonedCartScreen({super.key});

  @override
  State<AbandonedCartScreen> createState() => _AbandonedCartScreenState();
}

class _AbandonedCartScreenState extends State<AbandonedCartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();
  bool _isLoading = true;
  String? _error;
  List<AbandonedCart> _abandonedCarts = [];
  List<AbandonedCart> _convertedCarts = [];
  AbandonedCartStats? _stats;
  RecoverySettings? _settings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      // جلب البيانات من API بشكل متوازي
      final results = await Future.wait([
        _api.get('/secure/abandoned-carts?status=abandoned'),
        _api.get('/secure/abandoned-carts?status=converted'),
        _api.get('/secure/abandoned-carts/stats'),
        _api.get('/secure/abandoned-carts/settings'),
      ]);

      final abandonedResponse = json.decode(results[0].body);
      final convertedResponse = json.decode(results[1].body);
      final statsResponse = json.decode(results[2].body);
      final settingsResponse = json.decode(results[3].body);

      setState(() {
        // تحويل السلات المتروكة
        if (abandonedResponse['success'] == true &&
            abandonedResponse['data'] != null) {
          final cartsData = abandonedResponse['data'] as List? ?? [];
          _abandonedCarts = cartsData
              .map((json) => AbandonedCart.fromJson(json))
              .toList();
        }

        // تحويل السلات المحولة
        if (convertedResponse['success'] == true &&
            convertedResponse['data'] != null) {
          final convertedData = convertedResponse['data'] as List? ?? [];
          _convertedCarts = convertedData
              .map((json) => AbandonedCart.fromJson(json))
              .toList();
        }

        // تحويل الإحصائيات
        if (statsResponse['success'] == true && statsResponse['data'] != null) {
          _stats = AbandonedCartStats.fromJson(statsResponse['data']);
        }

        // تحويل الإعدادات
        if (settingsResponse['success'] == true &&
            settingsResponse['data'] != null) {
          _settings = RecoverySettings.fromJson(settingsResponse['data']);
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ في تحميل البيانات: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header ثابت مع TabBar
              Container(
                color:
                    theme.appBarTheme.backgroundColor ??
                    theme.colorScheme.primary,
                child: Column(
                  children: [
                    // Header Row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                AppIcons.arrowBack,
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'السلات المتروكة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.gear,
                              color: Colors.white,
                            ),
                            onPressed: _showSettingsSheet,
                          ),
                        ],
                      ),
                    ),
                    // TabBar
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: const [
                        Tab(
                          text: 'قيد الانتظار',
                          icon: Icon(CupertinoIcons.cart_badge_minus),
                        ),
                        Tab(
                          text: 'مستردة',
                          icon: Icon(CupertinoIcons.checkmark_circle),
                        ),
                        Tab(
                          text: 'الإحصائيات',
                          icon: Icon(CupertinoIcons.chart_bar),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Body content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildAbandonedTab(),
                          _buildRecoveredTab(),
                          _buildStatsTab(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // Abandoned Tab
  // ============================================================================

  Widget _buildAbandonedTab() {
    if (_abandonedCarts.isEmpty) {
      return _buildEmptyState(
        icon: CupertinoIcons.cart,
        title: 'لا توجد سلات متروكة',
        subtitle: 'ستظهر هنا السلات التي يتركها العملاء دون إتمام الشراء',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: AppDimensions.paddingM,
        itemCount: _abandonedCarts.length,
        itemBuilder: (context, index) {
          return _buildCartCard(_abandonedCarts[index]);
        },
      ),
    );
  }

  Widget _buildCartCard(AbandonedCart cart) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: InkWell(
        onTap: () => _showCartDetails(cart),
        borderRadius: AppDimensions.borderRadiusL,
        child: Padding(
          padding: AppDimensions.paddingM,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    child: Text(
                      cart.displayName.isNotEmpty
                          ? cart.displayName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cart.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'منذ ${cart.timeSinceAbandoned}',
                          style: TextStyle(
                            color: theme.hintColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${cart.cartTotal.toStringAsFixed(0)} ر.س',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '${cart.itemsCount} منتج',
                        style: TextStyle(color: theme.hintColor, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacing12),
              const Divider(),
              const SizedBox(height: AppDimensions.spacing8),

              // Products preview
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cart.cartItems.length.clamp(0, 4),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppDimensions.spacing8),
                  itemBuilder: (context, index) {
                    final item = cart.cartItems[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: AppDimensions.borderRadiusS,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.productName.length > 15
                                ? '${item.productName.substring(0, 15)}...'
                                : item.productName,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'x${item.quantity}',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppDimensions.spacing12),

              // Actions
              Row(
                children: [
                  // Reminder status
                  if (cart.reminderCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: AppDimensions.borderRadiusS,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            CupertinoIcons.bell_fill,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${cart.reminderCount} تذكير',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),

                  // Send reminder button
                  TextButton.icon(
                    onPressed: () => _showSendReminderSheet(cart),
                    icon: const Icon(CupertinoIcons.paperplane, size: 18),
                    label: const Text('إرسال تذكير'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // Recovered Tab
  // ============================================================================

  Widget _buildRecoveredTab() {
    if (_convertedCarts.isEmpty) {
      return _buildEmptyState(
        icon: CupertinoIcons.checkmark_circle,
        title: 'لا توجد سلات مستردة',
        subtitle: 'ستظهر هنا السلات التي تم استردادها وتحويلها لطلبات',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: AppDimensions.paddingM,
        itemCount: _convertedCarts.length,
        itemBuilder: (context, index) {
          return _buildRecoveredCard(_convertedCarts[index]);
        },
      ),
    );
  }

  Widget _buildRecoveredCard(AbandonedCart cart) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.withValues(alpha: 0.1),
                  child: const Icon(
                    CupertinoIcons.checkmark,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cart.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'طلب رقم: ${cart.convertedOrderId}',
                        style: TextStyle(color: theme.hintColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${cart.cartTotal.toStringAsFixed(0)} ر.س',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Row(
              children: [
                Icon(CupertinoIcons.bell, size: 14, color: theme.hintColor),
                const SizedBox(width: 4),
                Text(
                  '${cart.reminderCount} تذكير قبل الشراء',
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Stats Tab
  // ============================================================================

  Widget _buildStatsTab() {
    if (_stats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'السلات المتروكة',
                    _stats!.totalAbandoned.toString(),
                    CupertinoIcons.cart_badge_minus,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'تم استردادها',
                    _stats!.totalRecovered.toString(),
                    CupertinoIcons.checkmark_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'نسبة الاسترداد',
                    '${_stats!.recoveryRate}%',
                    CupertinoIcons.percent,
                    theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'الإيرادات المستردة',
                    '${_stats!.totalRevenueRecovered.toStringAsFixed(0)} ر.س',
                    CupertinoIcons.money_dollar_circle,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Pending value card
            Container(
              width: double.infinity,
              padding: AppDimensions.paddingL,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: AppDimensions.borderRadiusL,
              ),
              child: Column(
                children: [
                  const Text(
                    'قيمة السلات المنتظرة',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    '${_stats!.totalPendingValue.toStringAsFixed(0)} ر.س',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_stats!.pendingCarts} سلة بانتظار الاسترداد',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tips section
            Text(
              'نصائح لتحسين الاسترداد',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            _buildTipCard(
              CupertinoIcons.clock,
              'التوقيت المثالي',
              'أرسل أول تذكير خلال ساعة من ترك السلة',
            ),
            _buildTipCard(
              CupertinoIcons.tag,
              'قدم خصم',
              'كوبون خصم 10-15% يزيد فرص الاسترداد بنسبة 40%',
            ),
            _buildTipCard(
              CupertinoIcons.envelope,
              'رسائل متعددة',
              'لا تعتمد على تذكير واحد، استخدم 2-3 تذكيرات',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusL),
      child: Padding(
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(IconData icon, String title, String description) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppDimensions.paddingS,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppDimensions.borderRadiusM,
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: theme.hintColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Sheets & Dialogs
  // ============================================================================

  void _showCartDetails(AbandonedCart cart) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.hintColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: AppDimensions.paddingL,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        cart.displayName[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cart.displayName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (cart.customerEmail != null)
                            Text(
                              cart.customerEmail!,
                              style: TextStyle(color: theme.hintColor),
                            ),
                          if (cart.customerPhone != null)
                            Text(
                              cart.customerPhone!,
                              style: TextStyle(color: theme.hintColor),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.xmark_circle_fill),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: AppDimensions.paddingL,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cart info
                      Row(
                        children: [
                          _buildInfoChip(
                            CupertinoIcons.clock,
                            'منذ ${cart.timeSinceAbandoned}',
                          ),
                          const SizedBox(width: AppDimensions.spacing8),
                          _buildInfoChip(
                            CupertinoIcons.bell,
                            '${cart.reminderCount} تذكير',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'المنتجات في السلة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),

                      // Products list
                      ...cart.cartItems.map((item) => _buildProductItem(item)),

                      const SizedBox(height: AppDimensions.spacing16),
                      const Divider(),
                      const SizedBox(height: AppDimensions.spacing16),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الإجمالي',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${cart.cartTotal.toStringAsFixed(0)} ر.س',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Container(
                padding: AppDimensions.paddingL,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showSendReminderSheet(cart);
                        },
                        icon: const Icon(CupertinoIcons.paperplane),
                        label: const Text('إرسال تذكير'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _markAsRecovered(cart),
                        icon: const Icon(CupertinoIcons.checkmark),
                        label: const Text('تم الشراء'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppDimensions.borderRadiusXL,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.hintColor),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 13, color: theme.hintColor)),
        ],
      ),
    );
  }

  Widget _buildProductItem(CartItem item) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppDimensions.paddingS,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppDimensions.borderRadiusM,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppDimensions.borderRadiusS,
            ),
            child: const Icon(CupertinoIcons.cube_box, size: 24),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${item.price.toStringAsFixed(0)} ر.س × ${item.quantity}',
                  style: TextStyle(fontSize: 13, color: theme.hintColor),
                ),
              ],
            ),
          ),
          Text(
            '${(item.price * item.quantity).toStringAsFixed(0)} ر.س',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showSendReminderSheet(AbandonedCart cart) {
    final theme = Theme.of(context);
    bool includeCoupon = true;
    String selectedType = 'push';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: AppDimensions.paddingXL,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.hintColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'إرسال تذكير',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  'سيتم إرسال تذكير لـ ${cart.displayName}',
                  style: TextStyle(color: theme.hintColor),
                ),
                const SizedBox(height: 24),

                // Notification type
                const Text(
                  'طريقة الإرسال',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                Row(
                  children: [
                    _buildTypeOption(
                      'push',
                      selectedType,
                      CupertinoIcons.bell,
                      'إشعار',
                      setSheetState,
                      (v) => selectedType = v,
                    ),
                    const SizedBox(width: AppDimensions.spacing8),
                    _buildTypeOption(
                      'sms',
                      selectedType,
                      CupertinoIcons.chat_bubble,
                      'رسالة SMS',
                      setSheetState,
                      (v) => selectedType = v,
                    ),
                    const SizedBox(width: AppDimensions.spacing8),
                    _buildTypeOption(
                      'email',
                      selectedType,
                      CupertinoIcons.envelope,
                      'بريد',
                      setSheetState,
                      (v) => selectedType = v,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Include coupon
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('إضافة كوبون خصم'),
                  subtitle: const Text('كوبون 10% صالح لمدة 7 أيام'),
                  value: includeCoupon,
                  onChanged: (v) => setSheetState(() => includeCoupon = v),
                ),

                const SizedBox(height: 24),

                // Send button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _sendReminder(cart, selectedType, includeCoupon);
                    },
                    icon: const Icon(CupertinoIcons.paperplane_fill),
                    label: const Text('إرسال التذكير'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeOption(
    String value,
    String selected,
    IconData icon,
    String label,
    StateSetter setState,
    Function(String) onSelect,
  ) {
    final theme = Theme.of(context);
    final isSelected = value == selected;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => onSelect(value));
        },
        borderRadius: AppDimensions.borderRadiusM,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: AppDimensions.borderRadiusM,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : theme.hintColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.hintColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsSheet() {
    if (_settings == null) return;

    final theme = Theme.of(context);
    bool autoEnabled = _settings!.autoRemindersEnabled;
    bool includeDiscount = _settings!.includeDiscount;
    double discountValue = _settings!.discountPercentage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: AppDimensions.paddingXL,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.hintColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'إعدادات الاسترداد',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.xmark_circle_fill),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Auto reminders
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('التذكيرات التلقائية'),
                          subtitle: const Text(
                            'إرسال تذكيرات تلقائية للسلات المتروكة',
                          ),
                          value: autoEnabled,
                          onChanged: (v) =>
                              setSheetState(() => autoEnabled = v),
                        ),

                        if (autoEnabled) ...[
                          const SizedBox(height: AppDimensions.spacing16),
                          const Text(
                            'توقيت التذكيرات',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppDimensions.spacing12),
                          _buildTimingTile(
                            'التذكير الأول',
                            'بعد ساعة من ترك السلة',
                            CupertinoIcons.time,
                          ),
                          _buildTimingTile(
                            'التذكير الثاني',
                            'بعد 24 ساعة',
                            CupertinoIcons.time,
                          ),
                          _buildTimingTile(
                            'التذكير الثالث',
                            'بعد 3 أيام',
                            CupertinoIcons.time,
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Include discount
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('إضافة كوبون خصم'),
                          subtitle: const Text('إرفاق كوبون خصم مع التذكيرات'),
                          value: includeDiscount,
                          onChanged: (v) =>
                              setSheetState(() => includeDiscount = v),
                        ),

                        if (includeDiscount) ...[
                          const SizedBox(height: AppDimensions.spacing16),
                          Text('نسبة الخصم: ${discountValue.toInt()}%'),
                          Slider(
                            value: discountValue,
                            min: 5,
                            max: 25,
                            divisions: 4,
                            label: '${discountValue.toInt()}%',
                            onChanged: (v) =>
                                setSheetState(() => discountValue = v),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _saveSettings(
                        autoEnabled,
                        includeDiscount,
                        discountValue,
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('حفظ الإعدادات'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimingTile(String title, String subtitle, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppDimensions.paddingS,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppDimensions.borderRadiusM,
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: AppDimensions.spacing12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: theme.hintColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Empty State
  // ============================================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppDimensions.paddingXXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: theme.hintColor.withValues(alpha: 0.3)),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              subtitle,
              style: TextStyle(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Actions
  // ============================================================================

  Future<void> _sendReminder(
    AbandonedCart cart,
    String type,
    bool includeCoupon,
  ) async {
    try {
      final res = await _api.post(
        '/secure/abandoned-carts/${cart.id}/remind',
        body: {'type': type, 'include_coupon': includeCoupon},
      );
      final response = json.decode(res.body);

      if (mounted) {
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إرسال التذكير لـ ${cart.displayName}'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'فشل إرسال التذكير'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _markAsRecovered(AbandonedCart cart) async {
    Navigator.pop(context);
    try {
      final res = await _api.post(
        '/secure/abandoned-carts/${cart.id}/recover',
        body: {},
      );
      final response = json.decode(res.body);

      if (mounted) {
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث السلة كمستردة'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'فشل تحديث السلة'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _saveSettings(
    bool autoEnabled,
    bool includeDiscount,
    double discount,
  ) async {
    try {
      final res = await _api.patch(
        '/secure/abandoned-carts/settings',
        body: {
          'auto_reminders_enabled': autoEnabled,
          'include_discount': includeDiscount,
          'discount_percentage': discount,
        },
      );
      final response = json.decode(res.body);

      if (mounted) {
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ الإعدادات'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'فشل حفظ الإعدادات'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
