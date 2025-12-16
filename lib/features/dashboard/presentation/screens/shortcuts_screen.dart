import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// صفحة اختصاراتي المُعاد تصميمها
/// - صفحة فارغة مع نص توضيحي في البداية
/// - إضافة اختصارات كمربعات أيقونات بنفس مقاس الصفحة الرئيسية
/// - حفظ التعديلات تلقائياً
/// - بدون خلفية بيضاء خلف الأيقونات
class ShortcutsScreen extends StatefulWidget {
  const ShortcutsScreen({super.key});

  @override
  State<ShortcutsScreen> createState() => _ShortcutsScreenState();
}

class _ShortcutsScreenState extends State<ShortcutsScreen> {
  List<ShortcutItemData> _savedShortcuts = [];
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadShortcuts();
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
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'اختصاراتي',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_isEditing) {
                // عند الضغط على "تم" - احفظ وخرج من وضع التعديل
                _saveShortcuts();
              }
              setState(() => _isEditing = !_isEditing);
            },
            child: Text(
              _isEditing ? 'تم' : 'تعديل',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedShortcuts.isEmpty && !_isEditing
          ? _buildEmptyState()
          : _buildShortcutsGrid(),
      floatingActionButton: _isEditing
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
            const Text(
              'لا توجد اختصارات',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'أضف اختصاراتك المفضلة للوصول السريع\nإلى أهم الصفحات والأدوات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'اضغط على الاختصار لحذفه أو أضف اختصارات جديدة',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 أعمدة مثل الصفحة الرئيسية
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95, // نفس نسبة الصفحة الرئيسية
              ),
              itemCount: _savedShortcuts.length,
              itemBuilder: (context, index) {
                final shortcut = _savedShortcuts[index];
                return _buildShortcutItem(shortcut);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// بناء عنصر الاختصار - بنفس تصميم الصفحة الرئيسية بدون خلفية بيضاء
  Widget _buildShortcutItem(ShortcutItemData shortcut) {
    return GestureDetector(
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
                    style: const TextStyle(
                      fontSize: 12,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              fontSize: 16,
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
                        fontSize: 10,
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
final List<ShortcutItemData> _availableShortcuts = [
  // الرئيسية
  const ShortcutItemData(
    key: 'home',
    title: 'الرئيسية',
    route: '/dashboard',
    icon: Icons.home_outlined,
    color: Color(0xFF2563EB),
  ),
  const ShortcutItemData(
    key: 'orders',
    title: 'الطلبات',
    route: '/dashboard/orders',
    icon: Icons.receipt_long_outlined,
    color: Color(0xFFF59E0B),
  ),
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
  const ShortcutItemData(
    key: 'conversations',
    title: 'المحادثات',
    route: '/dashboard/conversations',
    icon: Icons.chat_bubble_outline,
    color: Color(0xFF3B82F6),
  ),
  // المتجر
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
final List<ShortcutCategory> _shortcutCategories = [
  ShortcutCategory(
    title: 'الأساسية',
    shortcuts: _availableShortcuts
        .where(
          (s) => [
            'home',
            'orders',
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
            'conversations',
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
