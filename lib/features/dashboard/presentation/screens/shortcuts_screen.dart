import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

// =============================================================================
// النصوص الثابتة (قابلة للتعديل من مكان واحد)
// =============================================================================

class ShortcutsStrings {
  static const String pageTitle = 'اختصاراتي';
  static const String editButton = 'تعديل';
  static const String saveButton = 'حفظ';
  static const String emptyStateDescription =
      'قم بتصميم لوحة اختصاراتك للوصول السريع لأهم التبويبات.';
  static const String editSheetTitle = 'تعديل اختصاراتي';
  static const String templatesTitle = 'قوالب العرض';
  static const String addedLabel = 'مضاف';
  static const String savedSuccessfully = 'تم حفظ التغييرات بنجاح';
  static const String loadError = 'حدث خطأ في تحميل البيانات';
  static const String retryButton = 'إعادة المحاولة';
}

// =============================================================================
// نموذج الاختصار
// =============================================================================

class ShortcutItem {
  final String key;
  final String title;
  final String route;
  final String iconKey;
  final String section;
  bool enabled;
  int order;

  ShortcutItem({
    required this.key,
    required this.title,
    required this.route,
    required this.iconKey,
    this.section = 'general',
    required this.enabled,
    required this.order,
  });

  factory ShortcutItem.fromJson(Map<String, dynamic> json) {
    return ShortcutItem(
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      route: json['route'] ?? '',
      iconKey: json['iconKey'] ?? json['icon_key'] ?? '',
      section: json['section'] ?? 'general',
      enabled: json['enabled'] ?? true,
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'title': title,
    'route': route,
    'iconKey': iconKey,
    'section': section,
    'enabled': enabled,
    'order': order,
  };

  IconData get icon {
    switch (iconKey) {
      case 'home':
        return Icons.home_outlined;
      case 'orders':
        return Icons.receipt_outlined;
      case 'products':
        return Icons.shopping_bag_outlined;
      case 'add_product':
        return Icons.add_box_outlined;
      case 'inventory':
        return Icons.inventory_2_outlined;
      case 'customers':
        return Icons.people_outline;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      case 'promotions':
        return Icons.trending_up_outlined;
      case 'marketing':
        return Icons.campaign_outlined;
      case 'store_management':
        return Icons.store_outlined;
      case 'notifications':
        return Icons.notifications_outlined;
      case 'conversations':
        return Icons.chat_bubble_outline;
      case 'store':
        return Icons.storefront_outlined;
      case 'studio':
        return Icons.auto_awesome_outlined;
      case 'tools':
        return Icons.build_outlined;
      case 'boost':
        return Icons.rocket_launch_outlined;
      case 'store_on_jock':
        return Icons.settings_outlined;
      case 'view_store':
        return Icons.visibility_outlined;
      case 'audit':
        return Icons.history_outlined;
      case 'points':
        return Icons.star_outline;
      case 'sales':
        return Icons.analytics_outlined;
      default:
        return Icons.apps_outlined;
    }
  }
}

// =============================================================================
// كاتالوج التبويبات الكامل (من merchant_router.dart)
// =============================================================================

/// قسم تبويبات رئيسي
class TabSection {
  final String key;
  final String title;
  final String iconKey;
  final List<ShortcutItem> subTabs;

  const TabSection({
    required this.key,
    required this.title,
    required this.iconKey,
    required this.subTabs,
  });
}

/// كاتالوج جميع تبويبات تطبيق التاجر
/// مستخرج من merchant_router.dart و dashboard_shell.dart
class MerchantTabsCatalog {
  static List<TabSection> getAllSections() {
    return [
      // 1. الصفحة الرئيسية
      TabSection(
        key: 'home',
        title: 'الصفحة الرئيسية',
        iconKey: 'home',
        subTabs: [
          ShortcutItem(
            key: 'home_main',
            title: 'الرئيسية',
            route: '/dashboard',
            iconKey: 'home',
            section: 'home',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'home_studio',
            title: 'توليد الذكاء الاصطناعي',
            route: '/dashboard/studio',
            iconKey: 'studio',
            section: 'home',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'home_tools',
            title: 'أدوات الذكاء الاصطناعي',
            route: '/dashboard/tools',
            iconKey: 'tools',
            section: 'home',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'home_marketing',
            title: 'التسويق',
            route: '/dashboard/marketing',
            iconKey: 'marketing',
            section: 'home',
            enabled: true,
            order: 0,
          ),
          /* تم تعطيل ضاعف ظهورك وارفع مبيعاتك
          ShortcutItem(
            key: 'home_promotions',
            title: 'ضاعف ظهورك',
            route: '/dashboard/promotions',
            iconKey: 'promotions',
            section: 'home',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'home_boost',
            title: 'ارفع مبيعاتك',
            route: '/dashboard/boost-sales',
            iconKey: 'boost',
            section: 'home',
            enabled: true,
            order: 0,
          ),
          */
          ShortcutItem(
            key: 'home_wallet',
            title: 'المحفظة',
            route: '/dashboard/wallet',
            iconKey: 'wallet',
            section: 'home',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'home_points',
            title: 'النقاط',
            route: '/dashboard/points',
            iconKey: 'points',
            section: 'home',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'home_sales',
            title: 'المبيعات',
            route: '/dashboard/sales',
            iconKey: 'sales',
            section: 'home',
            enabled: true,
            order: 0,
          ),
        ],
      ),

      // 2. الطلبات
      TabSection(
        key: 'orders',
        title: 'الطلبات',
        iconKey: 'orders',
        subTabs: [
          ShortcutItem(
            key: 'orders_all',
            title: 'جميع الطلبات',
            route: '/dashboard/orders',
            iconKey: 'orders',
            section: 'orders',
            enabled: true,
            order: 0,
          ),
        ],
      ),

      // 3. المنتجات
      TabSection(
        key: 'products',
        title: 'المنتجات',
        iconKey: 'products',
        subTabs: [
          ShortcutItem(
            key: 'products_all',
            title: 'جميع المنتجات',
            route: '/dashboard/products',
            iconKey: 'products',
            section: 'products',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'products_add',
            title: 'إضافة منتج',
            route: '/dashboard/products/add',
            iconKey: 'add_product',
            section: 'products',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'products_inventory',
            title: 'المخزون',
            route: '/dashboard/inventory',
            iconKey: 'inventory',
            section: 'products',
            enabled: true,
            order: 0,
          ),
        ],
      ),

      // 4. المحادثات
      TabSection(
        key: 'conversations',
        title: 'المحادثات',
        iconKey: 'conversations',
        subTabs: [
          ShortcutItem(
            key: 'conversations_all',
            title: 'جميع المحادثات',
            route: '/dashboard/conversations',
            iconKey: 'conversations',
            section: 'conversations',
            enabled: true,
            order: 0,
          ),
        ],
      ),

      // 5. إدارة المتجر
      TabSection(
        key: 'store_management',
        title: 'إدارة المتجر',
        iconKey: 'store_management',
        subTabs: [
          ShortcutItem(
            key: 'mgmt_services',
            title: 'إدارة المتجر',
            route: '/dashboard/store-management',
            iconKey: 'store_management',
            section: 'management',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'mgmt_store_on_jock',
            title: 'تخصيص المتجر',
            route: '/dashboard/store-on-jock',
            iconKey: 'store_on_jock',
            section: 'management',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'mgmt_view_store',
            title: 'عرض متجري',
            route: '/dashboard/view-store',
            iconKey: 'view_store',
            section: 'management',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'mgmt_customers',
            title: 'العملاء',
            route: '/dashboard/customers',
            iconKey: 'customers',
            section: 'management',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'mgmt_notifications',
            title: 'الإشعارات',
            route: '/dashboard/notifications',
            iconKey: 'notifications',
            section: 'management',
            enabled: true,
            order: 0,
          ),
          ShortcutItem(
            key: 'mgmt_audit',
            title: 'سجل العمليات',
            route: '/dashboard/audit-logs',
            iconKey: 'audit',
            section: 'management',
            enabled: true,
            order: 0,
          ),
        ],
      ),

      // 6. المتجر
      TabSection(
        key: 'store',
        title: 'المتجر',
        iconKey: 'store',
        subTabs: [
          ShortcutItem(
            key: 'store_main',
            title: 'صفحة المتجر',
            route: '/dashboard/store',
            iconKey: 'store',
            section: 'store',
            enabled: true,
            order: 0,
          ),
        ],
      ),
    ];
  }
}

// =============================================================================
// أنماط عرض الاختصارات (6 قوالب)
// =============================================================================

enum ShortcutLayoutStyle {
  grid2x3, // شبكة 2 أعمدة
  grid3x2, // شبكة 3 أعمدة
  compactGrid, // شبكة 4 أعمدة مضغوطة
  list, // قائمة عمودية
  largeCards, // بطاقات كبيرة
  chips, // رقائق
}

extension ShortcutLayoutStyleExtension on ShortcutLayoutStyle {
  String get label {
    switch (this) {
      case ShortcutLayoutStyle.grid2x3:
        return 'شبكة 2×3';
      case ShortcutLayoutStyle.grid3x2:
        return 'شبكة 3×2';
      case ShortcutLayoutStyle.compactGrid:
        return 'مضغوط';
      case ShortcutLayoutStyle.list:
        return 'قائمة';
      case ShortcutLayoutStyle.largeCards:
        return 'بطاقات';
      case ShortcutLayoutStyle.chips:
        return 'رقائق';
    }
  }

  IconData get icon {
    switch (this) {
      case ShortcutLayoutStyle.grid2x3:
        return Icons.grid_view;
      case ShortcutLayoutStyle.grid3x2:
        return Icons.grid_3x3;
      case ShortcutLayoutStyle.compactGrid:
        return Icons.apps;
      case ShortcutLayoutStyle.list:
        return Icons.list;
      case ShortcutLayoutStyle.largeCards:
        return Icons.view_agenda;
      case ShortcutLayoutStyle.chips:
        return Icons.label;
    }
  }
}

// =============================================================================
// شاشة اختصاراتي
// =============================================================================

class ShortcutsScreen extends ConsumerStatefulWidget {
  const ShortcutsScreen({super.key});

  @override
  ConsumerState<ShortcutsScreen> createState() => _ShortcutsScreenState();
}

class _ShortcutsScreenState extends ConsumerState<ShortcutsScreen> {
  final ApiService _api = ApiService();
  static const String _shortcutsKey = 'merchant_shortcuts';
  static const String _layoutKey = 'shortcuts_layout';

  List<ShortcutItem> _myShortcuts = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  bool _hasChanges = false;
  ShortcutLayoutStyle _layoutStyle = ShortcutLayoutStyle.grid2x3;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// تحميل البيانات المحفوظة
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedShortcuts = prefs.getString(_shortcutsKey);
      final savedLayout = prefs.getInt(_layoutKey);

      if (savedLayout != null &&
          savedLayout < ShortcutLayoutStyle.values.length) {
        _layoutStyle = ShortcutLayoutStyle.values[savedLayout];
      }

      if (savedShortcuts != null && savedShortcuts.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(savedShortcuts);
        _myShortcuts = decoded
            .map((item) => ShortcutItem.fromJson(item))
            .toList();
        _myShortcuts.sort((a, b) => a.order.compareTo(b.order));
      }
      // إذا لم يوجد شيء محفوظ، تبقى القائمة فارغة (أول مرة)

      // محاولة جلب من الـ API
      try {
        final response = await _api.get('/secure/shortcuts');
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['ok'] == true &&
              data['data'] != null &&
              (data['data'] as List).isNotEmpty) {
            _myShortcuts = (data['data'] as List)
                .map((item) => ShortcutItem.fromJson(item))
                .toList();
            _myShortcuts.sort((a, b) => a.order.compareTo(b.order));
            await _saveToLocal();
          }
        }
      } catch (_) {}
    } catch (e) {
      _error = ShortcutsStrings.loadError;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// حفظ محلي
  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _shortcutsKey,
      jsonEncode(_myShortcuts.map((s) => s.toJson()).toList()),
    );
    await prefs.setInt(_layoutKey, _layoutStyle.index);
  }

  /// حفظ التغييرات
  Future<void> _saveChanges() async {
    if (!_hasChanges) return;

    setState(() => _isSaving = true);

    try {
      for (int i = 0; i < _myShortcuts.length; i++) {
        _myShortcuts[i].order = i;
      }

      await _saveToLocal();

      try {
        await _api.put(
          '/secure/shortcuts',
          body: {'shortcuts': _myShortcuts.map((s) => s.toJson()).toList()},
        );
      } catch (_) {}

      HapticFeedback.mediumImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(ShortcutsStrings.savedSuccessfully),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _hasChanges = false);
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
      }
    }

    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  /// إضافة اختصار
  void _addShortcut(ShortcutItem shortcut) {
    if (_myShortcuts.any((s) => s.key == shortcut.key)) return;

    HapticFeedback.lightImpact();
    setState(() {
      _myShortcuts.add(
        ShortcutItem(
          key: shortcut.key,
          title: shortcut.title,
          route: shortcut.route,
          iconKey: shortcut.iconKey,
          section: shortcut.section,
          enabled: true,
          order: _myShortcuts.length,
        ),
      );
      _hasChanges = true;
    });
  }

  /// حذف اختصار
  void _removeShortcut(ShortcutItem shortcut) {
    HapticFeedback.lightImpact();
    setState(() {
      _myShortcuts.removeWhere((s) => s.key == shortcut.key);
      for (int i = 0; i < _myShortcuts.length; i++) {
        _myShortcuts[i].order = i;
      }
      _hasChanges = true;
    });
  }

  /// الانتقال للاختصار
  void _navigateToShortcut(ShortcutItem shortcut) {
    HapticFeedback.lightImpact();
    context.push(shortcut.route);
  }

  /// تغيير القالب
  void _changeLayoutStyle(ShortcutLayoutStyle style) {
    HapticFeedback.lightImpact();
    setState(() {
      _layoutStyle = style;
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          ShortcutsStrings.pageTitle,
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
          TextButton(
            onPressed: _showEditSheet,
            child: const Text(
              ShortcutsStrings.editButton,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          if (_hasChanges)
            TextButton(
              onPressed: _isSaving ? null : _saveChanges,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      ShortcutsStrings.saveButton,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorView()
          : _myShortcuts.isEmpty
          ? _buildEmptyState()
          : _buildShortcutsContent(),
    );
  }

  /// حالة الخطأ
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
            child: const Text(ShortcutsStrings.retryButton),
          ),
        ],
      ),
    );
  }

  /// حالة الصفحة الفارغة (أول مرة) - صفحة فارغة تماماً
  Widget _buildEmptyState() {
    return const SizedBox.shrink();
  }

  /// محتوى الاختصارات (عندما يوجد اختصارات)
  /// تمرير عمودي فقط - بدون zoom أو تمرير أفقي
  Widget _buildShortcutsContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: _buildLayoutByStyle(),
    );
  }

  /// بناء المحتوى حسب القالب
  Widget _buildLayoutByStyle() {
    switch (_layoutStyle) {
      case ShortcutLayoutStyle.grid2x3:
        return _buildGrid(crossAxisCount: 2, compact: false);
      case ShortcutLayoutStyle.grid3x2:
        return _buildGrid(crossAxisCount: 3, compact: false);
      case ShortcutLayoutStyle.compactGrid:
        return _buildGrid(crossAxisCount: 4, compact: true);
      case ShortcutLayoutStyle.list:
        return _buildListLayout();
      case ShortcutLayoutStyle.largeCards:
        return _buildLargeCardsLayout();
      case ShortcutLayoutStyle.chips:
        return _buildChipsLayout();
    }
  }

  /// شبكة
  Widget _buildGrid({required int crossAxisCount, required bool compact}) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _myShortcuts.map((shortcut) {
        final cardWidth = compact ? 80.0 : 110.0;
        return SizedBox(
          width: cardWidth,
          height: cardWidth,
          child: _buildShortcutCard(shortcut, compact: compact),
        );
      }).toList(),
    );
  }

  /// بطاقة اختصار
  Widget _buildShortcutCard(ShortcutItem shortcut, {bool compact = false}) {
    return GestureDetector(
      onTap: () => _navigateToShortcut(shortcut),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: compact ? 36 : 48,
              height: compact ? 36 : 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(compact ? 10 : 12),
              ),
              child: Icon(
                shortcut.icon,
                color: AppTheme.primaryColor,
                size: compact ? 18 : 24,
              ),
            ),
            SizedBox(height: compact ? 4 : 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                shortcut.title,
                style: TextStyle(
                  fontSize: compact ? 9 : 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// قائمة عمودية
  Widget _buildListLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _myShortcuts.map((shortcut) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () => _navigateToShortcut(shortcut),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(shortcut.icon, color: AppTheme.primaryColor),
            ),
            title: Text(
              shortcut.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }

  /// بطاقات كبيرة
  Widget _buildLargeCardsLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _myShortcuts.map((shortcut) {
        return GestureDetector(
          onTap: () => _navigateToShortcut(shortcut),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    shortcut.icon,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    shortcut.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// رقائق
  Widget _buildChipsLayout() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _myShortcuts.map((shortcut) {
        return GestureDetector(
          onTap: () => _navigateToShortcut(shortcut),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(shortcut.icon, color: AppTheme.primaryColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  shortcut.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// فتح شاشة التعديل
  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // المقبض
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // العنوان
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ShortcutsStrings.editSheetTitle,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                // المحتوى
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // (1) القوالب
                      _buildTemplatesSection(setSheetState),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      // (2) الأقسام والتبويبات
                      ...MerchantTabsCatalog.getAllSections().map((section) {
                        return _buildSectionWithSubTabs(section, setSheetState);
                      }),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// قسم القوالب (6 قوالب)
  Widget _buildTemplatesSection(StateSetter setSheetState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          ShortcutsStrings.templatesTitle,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final itemWidth =
                (screenWidth - 32 - 20) / 3; // 32 padding, 20 spacing
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: ShortcutLayoutStyle.values.map((style) {
                final isSelected = _layoutStyle == style;
                return GestureDetector(
                  onTap: () {
                    _changeLayoutStyle(style);
                    setSheetState(() {});
                  },
                  child: Container(
                    width: itemWidth,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          style.icon,
                          color: isSelected ? Colors.white : Colors.grey[700],
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          style.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  /// قسم تبويب رئيسي مع التبويبات الفرعية
  Widget _buildSectionWithSubTabs(
    TabSection section,
    StateSetter setSheetState,
  ) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          _getIconForKey(section.iconKey),
          color: AppTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        section.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: const Text(
        'خيارات',
        style: TextStyle(color: AppTheme.primaryColor, fontSize: 13),
      ),
      children: section.subTabs.map((tab) {
        final isAdded = _myShortcuts.any((s) => s.key == tab.key);

        return ListTile(
          contentPadding: const EdgeInsets.only(right: 56, left: 8),
          leading: Icon(
            tab.icon,
            color: isAdded ? AppTheme.successColor : Colors.grey[600],
            size: 20,
          ),
          title: Text(
            tab.title,
            style: TextStyle(
              fontSize: 14,
              color: isAdded ? AppTheme.successColor : Colors.black87,
            ),
          ),
          trailing: isAdded
              ? IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    _removeShortcut(tab);
                    setSheetState(() {});
                    setState(() {});
                  },
                )
              : IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: AppTheme.primaryColor,
                  ),
                  onPressed: () {
                    _addShortcut(tab);
                    setSheetState(() {});
                    setState(() {});
                  },
                ),
        );
      }).toList(),
    );
  }

  /// الحصول على أيقونة من المفتاح
  IconData _getIconForKey(String key) {
    switch (key) {
      case 'home':
        return Icons.home_outlined;
      case 'orders':
        return Icons.receipt_outlined;
      case 'products':
        return Icons.shopping_bag_outlined;
      case 'conversations':
        return Icons.chat_bubble_outline;
      case 'store_management':
        return Icons.store_outlined;
      case 'store':
        return Icons.storefront_outlined;
      default:
        return Icons.apps_outlined;
    }
  }
}
