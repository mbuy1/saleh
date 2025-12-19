import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../ai_studio/data/mbuy_studio_service.dart';
import '../../../auth/data/auth_controller.dart';

/// صفحة اختصاراتي المُعاد تصميمها
/// - صفحة فارغة مع نص توضيحي في البداية
/// - إضافة اختصارات كمربعات أيقونات بنفس مقاس الصفحة الرئيسية
/// - حفظ التعديلات تلقائياً
/// - بدون خلفية بيضاء خلف الأيقونات
/// - إعادة ترتيب الأيقونات بالسحب والإفلات
class ShortcutsScreen extends ConsumerStatefulWidget {
  const ShortcutsScreen({super.key});

  @override
  ConsumerState<ShortcutsScreen> createState() => _ShortcutsScreenState();
}

class _ShortcutsScreenState extends ConsumerState<ShortcutsScreen>
    with SingleTickerProviderStateMixin {
  List<ShortcutItemData> _savedShortcuts = [];
  bool _isLoading = true;
  bool _isEditing = false;
  String _searchQuery = '';

  // Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadShortcuts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadShortcuts() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedKeys = prefs.getStringList('user_shortcuts') ?? [];

      _savedShortcuts = savedKeys
          .map(
            (key) => _availableShortcuts.firstWhere(
              (s) => s.key == key,
              orElse: () => _availableShortcuts.first,
            ),
          )
          .where((s) => savedKeys.contains(s.key))
          .toList();
    } catch (e) {
      debugPrint('Error loading shortcuts: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveShortcuts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'user_shortcuts',
        _savedShortcuts.map((s) => s.key).toList(),
      );
      HapticFeedback.mediumImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ الاختصارات'),
            backgroundColor: AppTheme.accentColor,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving shortcuts: $e');
    }
  }

  void _addShortcut(ShortcutItemData shortcut) {
    if (!_savedShortcuts.any((s) => s.key == shortcut.key)) {
      setState(() {
        _savedShortcuts.add(shortcut);
      });
      _saveShortcuts();
    }
  }

  void _removeShortcut(ShortcutItemData shortcut) {
    setState(() {
      _savedShortcuts.removeWhere((s) => s.key == shortcut.key);
    });
    _saveShortcuts();
  }

  void _navigateToShortcut(ShortcutItemData shortcut) {
    if (shortcut.route.isNotEmpty) {
      context.push(shortcut.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header مخصص
            _buildHeader(context),
            // TabBar
            _buildTabBar(),
            // المحتوى
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // تبويب اختصاراتي
                  _buildShortcutsTab(),
                  // تبويب أدوات AI
                  _buildAiToolsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0 && _isEditing
          ? FloatingActionButton.extended(
              onPressed: _showAddShortcutSheet,
              backgroundColor: AppTheme.primaryColor,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'إضافة اختصار',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: SvgPicture.asset(
                AppIcons.arrowBack,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'اختصاراتي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          // زر التعديل
          GestureDetector(
            onTap: () {
              if (_isEditing) {
                _saveShortcuts();
              }
              setState(() => _isEditing = !_isEditing);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing12,
                vertical: AppDimensions.spacing8,
              ),
              decoration: BoxDecoration(
                color: _isEditing
                    ? AppTheme.accentColor
                    : AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Text(
                _isEditing ? 'تم' : 'تعديل',
                style: TextStyle(
                  color: _isEditing ? Colors.white : AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.fontBody,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (_) => setState(() {}),
        indicator: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondaryColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: const [
          Tab(text: 'اختصاراتي'),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 18),
                SizedBox(width: 4),
                Text('أدوات AI'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutsTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _savedShortcuts.isEmpty && !_isEditing
              ? _buildEmptyState()
              : _buildShortcutsGrid(),
        ),
      ],
    );
  }

  Widget _buildAiToolsTab() {
    return _AiToolsTestTab(ref: ref);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
          decoration: InputDecoration(
            hintText: 'البحث في الاختصارات...',
            hintStyle: TextStyle(color: AppTheme.textHintColor),
            prefixIcon: Icon(Icons.search, color: AppTheme.textHintColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.dashboard_customize_outlined,
                size: 60,
                color: AppTheme.primaryColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'لا توجد اختصارات',
              style: TextStyle(
                fontSize: AppDimensions.fontDisplay2,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'أضف اختصاراتك المفضلة للوصول السريع\nإلى أهم الصفحات والأدوات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _isEditing = true);
                _showAddShortcutSheet();
              },
              icon: const Icon(Icons.add),
              label: const Text('إضافة اختصار'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutsGrid() {
    // فلترة الاختصارات حسب البحث
    final filteredShortcuts = _searchQuery.isEmpty
        ? _savedShortcuts
        : _savedShortcuts
              .where(
                (s) =>
                    s.title.contains(_searchQuery) ||
                    s.key.contains(_searchQuery),
              )
              .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'اسحب الاختصار لتغيير مكانه، أو اضغط عليه لحذفه',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: AppDimensions.fontBody2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: _isEditing
                ? ReorderableGridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.95,
                        ),
                    itemCount: filteredShortcuts.length,
                    itemBuilder: (context, index) {
                      final shortcut = filteredShortcuts[index];
                      return _buildShortcutItem(
                        shortcut,
                        key: ValueKey(shortcut.key),
                      );
                    },
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = _savedShortcuts.removeAt(oldIndex);
                        _savedShortcuts.insert(newIndex, item);
                      });
                      _saveShortcuts();
                    },
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.95,
                        ),
                    itemCount: filteredShortcuts.length,
                    itemBuilder: (context, index) {
                      final shortcut = filteredShortcuts[index];
                      return _buildShortcutItem(shortcut);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// بناء عنصر الاختصار - بنفس تصميم الصفحة الرئيسية بدون خلفية بيضاء
  Widget _buildShortcutItem(ShortcutItemData shortcut, {Key? key}) {
    return GestureDetector(
      key: key,
      onTap: _isEditing
          ? () => _showDeleteDialog(shortcut)
          : () => _navigateToShortcut(shortcut),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.cardGradient,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.borderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة بنفس حجم الصفحة الرئيسية
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          shortcut.color.withValues(alpha: 0.1),
                          shortcut.color.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(17),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        shortcut.icon,
                        size: 36, // نفس حجم أيقونات الصفحة الرئيسية
                        color: AppTheme.darkSlate,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Text(
                    shortcut.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppDimensions.fontLabel,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkSlate,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isEditing)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.remove, size: 16, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteDialog(ShortcutItemData shortcut) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الاختصار'),
        content: Text('هل تريد حذف "${shortcut.title}" من اختصاراتك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeShortcut(shortcut);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showAddShortcutSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) => Container(
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
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'اختر اختصاراً',
                    style: TextStyle(
                      fontSize: AppDimensions.fontDisplay3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _shortcutCategories.length,
                    itemBuilder: (context, index) {
                      final category = _shortcutCategories[index];
                      return _buildCategorySection(category, setSheetState);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    ShortcutCategory category,
    StateSetter setSheetState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            category.title,
            style: TextStyle(
              fontSize: AppDimensions.fontTitle,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: category.shortcuts.map((shortcut) {
            final isAdded = _savedShortcuts.any((s) => s.key == shortcut.key);
            return GestureDetector(
              onTap: isAdded
                  ? null
                  : () {
                      _addShortcut(shortcut);
                      setSheetState(() {}); // تحديث حالة الـ sheet
                      setState(() {}); // تحديث حالة الشاشة الرئيسية
                      // لا نغلق الـ sheet - نسمح بإضافة المزيد
                    },
              child: Container(
                width: 80,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isAdded
                      ? Colors.grey[200]
                      : shortcut.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: isAdded
                      ? Border.all(color: AppTheme.accentColor, width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      shortcut.icon,
                      size: 28,
                      color: isAdded ? AppTheme.accentColor : shortcut.color,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shortcut.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppDimensions.fontCaption - 1,
                        fontWeight: FontWeight.w500,
                        color: isAdded
                            ? AppTheme.accentColor
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                    if (isAdded)
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.check_circle,
                          size: 14,
                          color: AppTheme.accentColor,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}

// =============================================================================
// بيانات الاختصارات
// =============================================================================

class ShortcutItemData {
  final String key;
  final String title;
  final String route;
  final IconData icon;
  final Color color;

  const ShortcutItemData({
    required this.key,
    required this.title,
    required this.route,
    required this.icon,
    required this.color,
  });
}

class ShortcutCategory {
  final String title;
  final List<ShortcutItemData> shortcuts;

  const ShortcutCategory({required this.title, required this.shortcuts});
}

// جميع الاختصارات المتاحة
// ملاحظة: تم إزالة صفحات البار السفلي (الرئيسية، الطلبات، المحادثات، دروب شيب)
final List<ShortcutItemData> _availableShortcuts = [
  const ShortcutItemData(
    key: 'products',
    title: 'المنتجات',
    route: '/dashboard/products',
    icon: Icons.shopping_bag_outlined,
    color: Color(0xFF10B981),
  ),
  const ShortcutItemData(
    key: 'add_product',
    title: 'إضافة منتج',
    route: '/dashboard/products/add',
    icon: Icons.add_box_outlined,
    color: Color(0xFF8B5CF6),
  ),
  const ShortcutItemData(
    key: 'inventory',
    title: 'المخزون',
    route: '/dashboard/inventory',
    icon: Icons.inventory_2_outlined,
    color: Color(0xFFEC4899),
  ),
  const ShortcutItemData(
    key: 'customers',
    title: 'العملاء',
    route: '/dashboard/customers',
    icon: Icons.people_outline,
    color: Color(0xFF06B6D4),
  ),
  const ShortcutItemData(
    key: 'wallet',
    title: 'المحفظة',
    route: '/dashboard/wallet',
    icon: Icons.account_balance_wallet_outlined,
    color: Color(0xFF14B8A6),
  ),
  const ShortcutItemData(
    key: 'marketing',
    title: 'التسويق',
    route: '/dashboard/marketing',
    icon: Icons.campaign_outlined,
    color: Color(0xFFEF4444),
  ),
  const ShortcutItemData(
    key: 'coupons',
    title: 'الكوبونات',
    route: '/dashboard/coupons',
    icon: Icons.local_offer_outlined,
    color: Color(0xFFF97316),
  ),
  // المتجر (تمت إزالة المحادثات - موجودة في البار السفلي)
  const ShortcutItemData(
    key: 'store_settings',
    title: 'إعدادات المتجر',
    route: '/dashboard/store-management',
    icon: Icons.store_outlined,
    color: Color(0xFF6366F1),
  ),
  const ShortcutItemData(
    key: 'webstore',
    title: 'المتجر الإلكتروني',
    route: '/dashboard/webstore',
    icon: Icons.language_outlined,
    color: Color(0xFF0EA5E9),
  ),
  const ShortcutItemData(
    key: 'whatsapp',
    title: 'واتساب',
    route: '/dashboard/whatsapp-integration',
    icon: Icons.chat_outlined,
    color: Color(0xFF22C55E),
  ),
  const ShortcutItemData(
    key: 'qrcode',
    title: 'رمز QR',
    route: '/dashboard/qrcode-generator',
    icon: Icons.qr_code_outlined,
    color: Color(0xFF64748B),
  ),
  // الشحن والدفع
  const ShortcutItemData(
    key: 'shipping',
    title: 'الشحن',
    route: '/dashboard/shipping-integration',
    icon: Icons.local_shipping_outlined,
    color: Color(0xFF8B5CF6),
  ),
  const ShortcutItemData(
    key: 'delivery',
    title: 'التوصيل',
    route: '/dashboard/delivery-options',
    icon: Icons.delivery_dining_outlined,
    color: Color(0xFFD946EF),
  ),
  const ShortcutItemData(
    key: 'payments',
    title: 'المدفوعات',
    route: '/dashboard/payment-methods',
    icon: Icons.payment_outlined,
    color: Color(0xFF059669),
  ),
  const ShortcutItemData(
    key: 'cod',
    title: 'الدفع عند الاستلام',
    route: '/dashboard/cod-settings',
    icon: Icons.attach_money_outlined,
    color: Color(0xFFCA8A04),
  ),
  // الذكاء الاصطناعي
  const ShortcutItemData(
    key: 'ai_studio',
    title: 'توليد AI',
    route: '/dashboard/studio',
    icon: Icons.auto_awesome_outlined,
    color: Color(0xFFA855F7),
  ),
  const ShortcutItemData(
    key: 'ai_tools',
    title: 'أدوات AI',
    route: '/dashboard/tools',
    icon: Icons.psychology_outlined,
    color: Color(0xFF7C3AED),
  ),
  // المنتجات الرقمية
  const ShortcutItemData(
    key: 'digital_products',
    title: 'المنتجات الرقمية',
    route: '/dashboard/digital-products',
    icon: Icons.cloud_download_outlined,
    color: Color(0xFF0891B2),
  ),
  // التقارير
  const ShortcutItemData(
    key: 'reports',
    title: 'التقارير',
    route: '/dashboard/audit-logs',
    icon: Icons.analytics_outlined,
    color: Color(0xFF4F46E5),
  ),
  const ShortcutItemData(
    key: 'sales',
    title: 'المبيعات',
    route: '/dashboard/sales',
    icon: Icons.trending_up_outlined,
    color: Color(0xFF16A34A),
  ),
  // === الاختصارات المرجعة من التسويق ===
  const ShortcutItemData(
    key: 'flash_sales',
    title: 'العروض الخاطفة',
    route: '/dashboard/flash-sales',
    icon: Icons.flash_on_outlined,
    color: Color(0xFFEF4444),
  ),
  const ShortcutItemData(
    key: 'abandoned_cart',
    title: 'السلات المتروكة',
    route: '/dashboard/abandoned-cart',
    icon: Icons.shopping_cart_outlined,
    color: Color(0xFFF59E0B),
  ),
  const ShortcutItemData(
    key: 'referral',
    title: 'برنامج الإحالة',
    route: '/dashboard/referral',
    icon: Icons.share_outlined,
    color: Color(0xFF10B981),
  ),
  const ShortcutItemData(
    key: 'loyalty_program',
    title: 'برنامج الولاء',
    route: '/dashboard/loyalty-program',
    icon: Icons.loyalty_outlined,
    color: Color(0xFF8B5CF6),
  ),
  const ShortcutItemData(
    key: 'smart_analytics',
    title: 'تحليلات ذكية',
    route: '/dashboard/smart-analytics',
    icon: Icons.insights_outlined,
    color: Color(0xFF06B6D4),
  ),
  const ShortcutItemData(
    key: 'auto_reports',
    title: 'تقارير تلقائية',
    route: '/dashboard/auto-reports',
    icon: Icons.summarize_outlined,
    color: Color(0xFF14B8A6),
  ),
  const ShortcutItemData(
    key: 'heatmap',
    title: 'خريطة الحرارة',
    route: '/dashboard/heatmap',
    icon: Icons.grid_view_outlined,
    color: Color(0xFFEC4899),
  ),
  const ShortcutItemData(
    key: 'ai_assistant',
    title: 'مساعد AI',
    route: '/dashboard/ai-assistant',
    icon: Icons.smart_toy_outlined,
    color: Color(0xFF7C3AED),
  ),
  const ShortcutItemData(
    key: 'content_generator',
    title: 'مولد المحتوى',
    route: '/dashboard/content-generator',
    icon: Icons.auto_fix_high_outlined,
    color: Color(0xFFA855F7),
  ),
  const ShortcutItemData(
    key: 'smart_pricing',
    title: 'تسعير ذكي',
    route: '/dashboard/smart-pricing',
    icon: Icons.price_change_outlined,
    color: Color(0xFF059669),
  ),
  const ShortcutItemData(
    key: 'customer_segments',
    title: 'شرائح العملاء',
    route: '/dashboard/customer-segments',
    icon: Icons.group_work_outlined,
    color: Color(0xFF3B82F6),
  ),
  const ShortcutItemData(
    key: 'custom_messages',
    title: 'رسائل مخصصة',
    route: '/dashboard/custom-messages',
    icon: Icons.message_outlined,
    color: Color(0xFF22C55E),
  ),
  const ShortcutItemData(
    key: 'product_variants',
    title: 'متغيرات المنتج',
    route: '/dashboard/product-variants',
    icon: Icons.style_outlined,
    color: Color(0xFF6366F1),
  ),
  const ShortcutItemData(
    key: 'product_bundles',
    title: 'حزم المنتجات',
    route: '/dashboard/product-bundles',
    icon: Icons.inventory_outlined,
    color: Color(0xFFD946EF),
  ),
];

// تصنيفات الاختصارات
// ملاحظة: تم إزالة صفحات البار السفلي من التصنيفات
final List<ShortcutCategory> _shortcutCategories = [
  ShortcutCategory(
    title: 'الأساسية',
    shortcuts: _availableShortcuts
        .where(
          (s) => [
            'products',
            'add_product',
            'inventory',
            'customers',
          ].contains(s.key),
        )
        .toList(),
  ),
  ShortcutCategory(
    title: 'المالية والتسويق',
    shortcuts: _availableShortcuts
        .where(
          (s) => [
            'wallet',
            'marketing',
            'coupons',
            'sales',
            'flash_sales',
            'abandoned_cart',
            'referral',
            'loyalty_program',
          ].contains(s.key),
        )
        .toList(),
  ),
  ShortcutCategory(
    title: 'المتجر والتواصل',
    shortcuts: _availableShortcuts
        .where(
          (s) => [
            'store_settings',
            'webstore',
            'whatsapp',
            'qrcode',
          ].contains(s.key),
        )
        .toList(),
  ),
  ShortcutCategory(
    title: 'الشحن والدفع',
    shortcuts: _availableShortcuts
        .where(
          (s) => ['shipping', 'delivery', 'payments', 'cod'].contains(s.key),
        )
        .toList(),
  ),
  ShortcutCategory(
    title: 'الذكاء الاصطناعي',
    shortcuts: _availableShortcuts
        .where(
          (s) => [
            'ai_studio',
            'ai_tools',
            'ai_assistant',
            'content_generator',
            'smart_pricing',
          ].contains(s.key),
        )
        .toList(),
  ),
  ShortcutCategory(
    title: 'التحليلات والتقارير',
    shortcuts: _availableShortcuts
        .where(
          (s) => [
            'smart_analytics',
            'auto_reports',
            'heatmap',
            'reports',
          ].contains(s.key),
        )
        .toList(),
  ),
  ShortcutCategory(
    title: 'إدارة العملاء',
    shortcuts: _availableShortcuts
        .where((s) => ['customer_segments', 'custom_messages'].contains(s.key))
        .toList(),
  ),
  ShortcutCategory(
    title: 'المنتجات المتقدمة',
    shortcuts: _availableShortcuts
        .where(
          (s) => [
            'digital_products',
            'product_variants',
            'product_bundles',
          ].contains(s.key),
        )
        .toList(),
  ),
];

// =============================================================================
// ReorderableGridView Widget
// =============================================================================

/// عنصر GridView قابل لإعادة الترتيب
class ReorderableGridView extends StatefulWidget {
  final SliverGridDelegate gridDelegate;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final void Function(int oldIndex, int newIndex) onReorder;

  const ReorderableGridView.builder({
    super.key,
    required this.gridDelegate,
    required this.itemCount,
    required this.itemBuilder,
    required this.onReorder,
  });

  @override
  State<ReorderableGridView> createState() => _ReorderableGridViewState();
}

class _ReorderableGridViewState extends State<ReorderableGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: widget.gridDelegate,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return LongPressDraggable<int>(
          data: index,
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Opacity(
                opacity: 0.8,
                child: widget.itemBuilder(context, index),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: widget.itemBuilder(context, index),
          ),
          onDragStarted: () {
            HapticFeedback.mediumImpact();
          },
          child: DragTarget<int>(
            onWillAcceptWithDetails: (details) => details.data != index,
            onAcceptWithDetails: (details) {
              widget.onReorder(details.data, index);
              HapticFeedback.lightImpact();
            },
            builder: (context, candidateData, rejectedData) {
              final isTarget = candidateData.isNotEmpty;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: isTarget
                      ? Border.all(color: AppTheme.primaryColor, width: 2)
                      : null,
                ),
                child: widget.itemBuilder(context, index),
              );
            },
          ),
        );
      },
    );
  }
}

// =============================================================================
// AI Tools Test Tab - تبويب اختبار أدوات الذكاء الاصطناعي
// =============================================================================

class _AiToolsTestTab extends StatefulWidget {
  final WidgetRef ref;

  const _AiToolsTestTab({required this.ref});

  @override
  State<_AiToolsTestTab> createState() => _AiToolsTestTabState();
}

class _AiToolsTestTabState extends State<_AiToolsTestTab> {
  final TextEditingController _promptController = TextEditingController();
  String _result = '';
  bool _isLoading = false;
  String _selectedTool = 'text'; // الأداة المحددة حالياً
  String? _generatedImageUrl; // رابط الصورة المولدة
  String? _currentTaskId; // معرف مهمة NanoBanana

  // إعدادات إضافية لكل أداة
  String _textTone = 'marketing'; // تسويقي / رسمي / مختصر
  String _textLength = 'medium'; // قصير / متوسط / طويل
  String _productTone = 'friendly'; // ودية / احترافية

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  bool _checkAuth() {
    final isAuthenticated = widget.ref.read(isAuthenticatedProvider);
    if (!isAuthenticated) {
      setState(() {
        _result = '❌ يجب تسجيل الدخول أولاً لاستخدام أدوات AI';
      });
      return false;
    }
    return true;
  }

  Future<void> _testGenerateText() async {
    if (!_checkAuth()) return;
    if (_promptController.text.isEmpty) {
      setState(() => _result = '⚠️ أدخل موضوع النص أولاً');
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '⏳ جاري توليد النص...';
    });

    try {
      final service = widget.ref.read(mbuyStudioServiceProvider);
      // بناء prompt مناسب لتوليد نص عام
      final toneMap = {
        'marketing': 'تسويقي جذاب',
        'formal': 'رسمي واحترافي',
        'short': 'مختصر ومباشر',
      };
      final lengthMap = {
        'short': 'جملتين',
        'medium': '3-4 جمل',
        'long': 'فقرة كاملة',
      };

      final fullPrompt =
          'اكتب نص ${toneMap[_textTone]} عن "${_promptController.text}" بطول ${lengthMap[_textLength]}';

      final response = await service.generateText(fullPrompt);
      setState(() {
        final text =
            response['text'] ?? response['content'] ?? response['data'];
        _result = '✅ النص المولّد:\n\n$text';
      });
    } catch (e) {
      setState(() {
        _result = '❌ فشل: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testGenerateProductDescription() async {
    if (!_checkAuth()) return;
    if (_promptController.text.isEmpty) {
      setState(
        () => _result =
            '⚠️ أدخل اسم المنتج ومميزاته\n(مثال: ساعة ذكية - مقاومة للماء - بطارية طويلة - شاشة AMOLED)',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '⏳ جاري توليد وصف المنتج...';
    });

    try {
      final service = widget.ref.read(mbuyStudioServiceProvider);
      final response = await service.generateProductDescription(
        prompt: _promptController.text,
        tone: _productTone,
        language: 'ar',
      );

      final description =
          response['description'] ??
          response['content'] ??
          response['text'] ??
          response['data'];
      setState(() {
        _result = '✅ وصف المنتج:\n\n$description';
      });
    } catch (e) {
      setState(() {
        _result = '❌ فشل: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testGenerateKeywords() async {
    if (!_checkAuth()) return;
    if (_promptController.text.isEmpty) {
      setState(
        () => _result = '⚠️ أدخل اسم المنتج أو الفئة\n(مثال: حقيبة جلد نسائية)',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '⏳ جاري توليد الكلمات المفتاحية...';
    });

    try {
      final service = widget.ref.read(mbuyStudioServiceProvider);
      final response = await service.generateKeywords(
        prompt: _promptController.text,
        language: 'ar',
      );

      final keywords = response['keywords'];
      setState(() {
        if (keywords is List && keywords.isNotEmpty) {
          _result =
              '✅ الكلمات المفتاحية:\n\n${keywords.map((k) => '• $k').join('\n')}';
        } else {
          _result = '✅ ${response['data'] ?? response}';
        }
      });
    } catch (e) {
      setState(() {
        _result = '❌ فشل: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ============= AI Image Generation =============
  Future<void> _testNanoBananaGenerate() async {
    if (!_checkAuth()) return;
    if (_promptController.text.isEmpty) {
      setState(
        () => _result =
            '⚠️ أدخل وصف الصورة بالإنجليزية\n(مثال: Professional product photo of a smartwatch on white background)',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '⏳ جاري توليد الصورة عبر NanoBanana...';
      _generatedImageUrl = null;
      _currentTaskId = null;
    });

    try {
      final service = widget.ref.read(mbuyStudioServiceProvider);

      // توليد الصورة
      final response = await service.nanoBananaGenerate(_promptController.text);

      // التحقق من النتيجة
      final status = response['status'];
      final imageUrl = response['image_url'] ?? response['imageUrl'];

      if (status == 'completed' && imageUrl != null) {
        setState(() {
          _generatedImageUrl = imageUrl;
          _result = '✅ تم توليد الصورة بنجاح!';
        });
      } else {
        setState(() {
          _result =
              '❌ فشل: ${response['error'] ?? response['details'] ?? 'استجابة غير متوقعة'}';
        });
      }
    } catch (e) {
      setState(() {
        _result = '❌ فشل: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ignore: unused_element - محفوظة للاستخدام المستقبلي
  Future<void> _pollTaskStatus(String taskId) async {
    final service = widget.ref.read(mbuyStudioServiceProvider);
    int attempts = 0;
    const maxAttempts = 30; // 30 محاولة × 2 ثانية = دقيقة واحدة كحد أقصى

    while (attempts < maxAttempts) {
      attempts++;
      await Future.delayed(const Duration(seconds: 2));

      try {
        final taskResponse = await service.nanoBananaGetTask(taskId);
        final status = taskResponse['status']?.toString().toLowerCase();

        if (status == 'completed' || status == 'success') {
          // البحث عن رابط الصورة في النتيجة
          final result = taskResponse['result'];
          String? imageUrl;

          if (result is List && result.isNotEmpty) {
            imageUrl = result[0]?.toString();
          } else if (result is Map) {
            imageUrl = result['url'] ?? result['image_url'] ?? result['image'];
          } else if (result is String) {
            imageUrl = result;
          }

          // أيضاً تحقق من المستوى الأعلى
          imageUrl ??=
              taskResponse['url'] ??
              taskResponse['image_url'] ??
              taskResponse['image'];

          setState(() {
            _generatedImageUrl = imageUrl;
            _result = imageUrl != null
                ? '✅ تم توليد الصورة بنجاح!'
                : '✅ اكتملت المهمة لكن لم يتم العثور على رابط الصورة\n\nالنتيجة: $taskResponse';
          });
          return;
        } else if (status == 'failed' || status == 'error') {
          final error =
              taskResponse['error'] ??
              taskResponse['message'] ??
              'خطأ غير معروف';
          setState(() {
            _result = '❌ فشلت المهمة: $error';
          });
          return;
        } else {
          // لا زالت قيد التنفيذ
          setState(() {
            _result =
                '⏳ حالة المهمة: ${status ?? 'processing'}\nالمحاولة: $attempts/$maxAttempts';
          });
        }
      } catch (e) {
        debugPrint('[NanoBanana] Poll error: $e');
        // استمر في المحاولة
      }
    }

    setState(() {
      _result = '⚠️ انتهت المهلة. يمكنك التحقق لاحقاً من المهمة: $taskId';
    });
  }

  Future<void> _checkTaskStatus() async {
    if (_currentTaskId == null) {
      setState(() => _result = '⚠️ لا توجد مهمة للتحقق منها');
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '⏳ جاري التحقق من حالة المهمة...';
    });

    try {
      final service = widget.ref.read(mbuyStudioServiceProvider);
      final response = await service.nanoBananaGetTask(_currentTaskId!);

      final status = response['status'];
      final result = response['result'];

      setState(() {
        _result =
            '📋 حالة المهمة: $status\n\nالتفاصيل:\n${_formatJson(response)}';

        // إذا اكتملت، حاول استخراج الصورة
        if (status == 'completed' || status == 'success') {
          String? imageUrl;
          if (result is List && result.isNotEmpty) {
            imageUrl = result[0]?.toString();
          } else if (result is Map) {
            imageUrl = result['url'] ?? result['image_url'];
          }
          imageUrl ??= response['url'] ?? response['image_url'];
          _generatedImageUrl = imageUrl;
        }
      });
    } catch (e) {
      setState(() => _result = '❌ فشل التحقق: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatJson(Map<String, dynamic> json) {
    try {
      return json.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    } catch (_) {
      return json.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // حالة تسجيل الدخول
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.ref.watch(isAuthenticatedProvider)
                  ? Colors.green[50]
                  : Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.ref.watch(isAuthenticatedProvider)
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.ref.watch(isAuthenticatedProvider)
                      ? Icons.check_circle
                      : Icons.error,
                  color: widget.ref.watch(isAuthenticatedProvider)
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.ref.watch(isAuthenticatedProvider)
                      ? 'تم تسجيل الدخول ✓'
                      : 'غير مسجل الدخول - سجل دخولك لاستخدام أدوات AI',
                  style: TextStyle(
                    color: widget.ref.watch(isAuthenticatedProvider)
                        ? Colors.green[800]
                        : Colors.red[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // اختيار الأداة
          Text(
            'اختر الأداة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildToolChip(
                'text',
                'توليد نص',
                Icons.text_fields,
                Colors.blue,
              ),
              _buildToolChip(
                'description',
                'وصف منتج',
                Icons.description,
                Colors.teal,
              ),
              _buildToolChip(
                'keywords',
                'كلمات مفتاحية',
                Icons.key,
                Colors.indigo,
              ),
              _buildToolChip(
                'nano_banana',
                '🍌 صورة AI',
                Icons.image,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // حقل الإدخال مع تلميح مخصص
          TextField(
            controller: _promptController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: _getInputLabel(),
              hintText: _getInputHint(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // خيارات إضافية حسب الأداة
          _buildToolOptions(),
          const SizedBox(height: 16),

          // زر التوليد
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _executeSelectedTool,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_isLoading ? 'جاري التوليد...' : 'توليد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getToolColor(),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // عرض الصورة المولدة (NanoBanana)
          if (_generatedImageUrl != null) ...[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  _generatedImageUrl!,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'فشل تحميل الصورة',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          _generatedImageUrl!,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _generatedImageUrl!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ الرابط')),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('نسخ الرابط'),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _generatedImageUrl = null;
                    _result = '';
                  }),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('إخفاء'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // زر التحقق من المهمة (NanoBanana)
          if (_selectedTool == 'nano_banana' &&
              _currentTaskId != null &&
              !_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: OutlinedButton.icon(
                onPressed: _checkTaskStatus,
                icon: const Icon(Icons.refresh),
                label: Text(
                  'تحقق من المهمة: ${_currentTaskId!.substring(0, 8)}...',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                ),
              ),
            ),

          // نتيجة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'النتيجة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SelectableText(
                  _result.isEmpty ? 'اضغط على أي أداة للتجربة' : _result,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: _result.contains('❌')
                        ? Colors.red[800]
                        : _result.contains('✅')
                        ? Colors.green[800]
                        : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دوال مساعدة للأداة المختارة
  String _getInputLabel() {
    switch (_selectedTool) {
      case 'text':
        return 'موضوع النص (عربي)';
      case 'description':
        return 'اسم المنتج ومميزاته (عربي)';
      case 'keywords':
        return 'اسم المنتج/الفئة (عربي)';
      case 'nano_banana':
        return 'وصف الصورة (إنجليزي أفضل)';
      default:
        return 'الإدخال';
    }
  }

  String _getInputHint() {
    switch (_selectedTool) {
      case 'text':
        return 'مثال: منشور ترحيبي بالعملاء الجدد';
      case 'description':
        return 'مثال: ساعة ذكية - مقاومة للماء - شاشة AMOLED';
      case 'keywords':
        return 'مثال: حقيبة جلد نسائية';
      case 'nano_banana':
        return 'مثال: Professional product photo of a smartwatch on white background';
      default:
        return '';
    }
  }

  Color _getToolColor() {
    switch (_selectedTool) {
      case 'text':
        return Colors.blue;
      case 'description':
        return Colors.teal;
      case 'keywords':
        return Colors.indigo;
      case 'nano_banana':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _executeSelectedTool() {
    switch (_selectedTool) {
      case 'text':
        _testGenerateText();
        break;
      case 'description':
        _testGenerateProductDescription();
        break;
      case 'keywords':
        _testGenerateKeywords();
        break;
      case 'nano_banana':
        _testNanoBananaGenerate();
        break;
    }
  }

  Widget _buildToolChip(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedTool == value;
    return FilterChip(
      selected: isSelected,
      onSelected: (_) => setState(() {
        _selectedTool = value;
        _result = '';
      }),
      avatar: Icon(icon, size: 18, color: isSelected ? Colors.white : color),
      label: Text(label),
      selectedColor: color,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildToolOptions() {
    switch (_selectedTool) {
      case 'text':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نوع النص:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('تسويقي'),
                  selected: _textTone == 'marketing',
                  onSelected: (_) => setState(() => _textTone = 'marketing'),
                ),
                ChoiceChip(
                  label: const Text('رسمي'),
                  selected: _textTone == 'formal',
                  onSelected: (_) => setState(() => _textTone = 'formal'),
                ),
                ChoiceChip(
                  label: const Text('مختصر'),
                  selected: _textTone == 'short',
                  onSelected: (_) => setState(() => _textTone = 'short'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('الطول:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('قصير'),
                  selected: _textLength == 'short',
                  onSelected: (_) => setState(() => _textLength = 'short'),
                ),
                ChoiceChip(
                  label: const Text('متوسط'),
                  selected: _textLength == 'medium',
                  onSelected: (_) => setState(() => _textLength = 'medium'),
                ),
                ChoiceChip(
                  label: const Text('طويل'),
                  selected: _textLength == 'long',
                  onSelected: (_) => setState(() => _textLength = 'long'),
                ),
              ],
            ),
          ],
        );
      case 'description':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نبرة الوصف:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('ودية'),
                  selected: _productTone == 'friendly',
                  onSelected: (_) => setState(() => _productTone = 'friendly'),
                ),
                ChoiceChip(
                  label: const Text('احترافية'),
                  selected: _productTone == 'professional',
                  onSelected: (_) =>
                      setState(() => _productTone = 'professional'),
                ),
                ChoiceChip(
                  label: const Text('فاخرة'),
                  selected: _productTone == 'luxury',
                  onSelected: (_) => setState(() => _productTone = 'luxury'),
                ),
              ],
            ),
          ],
        );
      case 'nano_banana':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🍌 NanoBanana',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'توليد صور بالذكاء الاصطناعي عبر OpenRouter',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
