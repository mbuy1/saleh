import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_search_delegate.dart';
import '../../../merchant/data/merchant_store_provider.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   شريط التنقل السفلي + الهيدر العلوي - التصميم مثبت ومعتمد                ║
// ║   تاريخ التثبيت: 19 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   العناصر المثبتة:                                                        ║
// ║   • 5 تبويبات: الرئيسية، الطلبات، المنتجات، المحادثات، دروب شوبينقنا     ║
// ║   • الأيقونة النشطة: primaryColor (Oxford Blue #00214A)                   ║
// ║   • الهيدر العلوي الثابت مع Oxford Blue                                   ║
// ║   • شريط الحالة بأيقونات بيضاء                                            ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل التصميم إلا بطلب صريح وواضح من المالك                     ║
// ║   ⛔ DO NOT MODIFY design without EXPLICIT owner request                  ║
// ║                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// Dashboard Shell - يحتوي على البار السفلي الثابت والهيدر العلوي
/// يعرض الصفحات الفرعية داخله مع إبقاء البار السفلي والهيدر العلوي ظاهراً
/// التبويبات: الرئيسية، الطلبات، المنتجات، المحادثات، دروب شوبينقنا
///
/// 🔒 LOCKED DESIGN - تصميم مثبت
/// Last updated: 2025-12-19
/// تم إضافة الهيدر العلوي الثابت مع Oxford Blue
class DashboardShell extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  ConsumerState<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends ConsumerState<DashboardShell> {
  /// الحصول على الـ index الحالي بناءً على المسار
  /// الترتيب: الرئيسية(0)، الطلبات(1)، المنتجات(2)، المحادثات(3)، دروب شوبينقنا(4)
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/dashboard/orders')) return 1;
    if (location.startsWith('/dashboard/products')) {
      return 2; // صفحة المنتجات
    }
    if (location.startsWith('/dashboard/conversations')) return 3;
    if (location.startsWith('/dashboard/dropshipping')) {
      return 4; // دروب شوبينقنا في البار السفلي
    }
    return 0; // home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/dashboard/orders');
        break;
      case 2:
        // صفحة المنتجات
        context.go('/dashboard/products');
        break;
      case 3:
        context.go('/dashboard/conversations');
        break;
      case 4:
        // دروب شوبينقنا في البار السفلي
        context.go('/dashboard/dropshipping');
        break;
    }
  }

  void _openSearch(BuildContext context) {
    HapticFeedback.lightImpact();
    showSearch(context: context, delegate: AppSearchDelegate());
  }

  /// عرض قائمة اختيار نوع المنتج
  void _showProductTypeSelection(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // مقبض السحب
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Text(
                    'إضافة منتج جديد',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اختر نوع المنتج الذي تريد إضافته',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === خيار الإدراج السريع ===
                  _buildQuickAddOption(context),
                  const SizedBox(height: 16),

                  // فاصل مع عنوان
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'أو اختر نوع المنتج',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textHintColor,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // === أنواع المنتجات ===
                  _buildProductTypeOption(
                    context,
                    type: 'physical',
                    title: 'منتج مادي',
                    description: 'منتج يتم شحنه للعميل',
                    icon: Icons.inventory_2,
                    color: const Color(0xFF2196F3),
                  ),
                  _buildProductTypeOption(
                    context,
                    type: 'digital',
                    title: 'منتج رقمي',
                    description: 'ملفات، برامج، كتب إلكترونية',
                    icon: Icons.cloud_download,
                    color: const Color(0xFF9C27B0),
                  ),
                  _buildProductTypeOption(
                    context,
                    type: 'service',
                    title: 'خدمة حسب الطلب',
                    description: 'تصميم، برمجة، استشارات',
                    icon: Icons.handyman,
                    color: const Color(0xFF4CAF50),
                  ),
                  _buildProductTypeOption(
                    context,
                    type: 'foodAndBeverage',
                    title: 'أكل ومشروبات',
                    description: 'وجبات، حلويات، مشروبات',
                    icon: Icons.restaurant,
                    color: const Color(0xFFFF9800),
                  ),
                  _buildProductTypeOption(
                    context,
                    type: 'subscription',
                    title: 'اشتراك',
                    description: 'اشتراكات شهرية أو سنوية',
                    icon: Icons.autorenew,
                    color: const Color(0xFF00BCD4),
                  ),
                  _buildProductTypeOption(
                    context,
                    type: 'ticket',
                    title: 'تذكرة / حجز',
                    description: 'فعاليات، حجوزات، مواعيد',
                    icon: Icons.confirmation_number,
                    color: const Color(0xFFE91E63),
                  ),
                  _buildProductTypeOption(
                    context,
                    type: 'customizable',
                    title: 'منتج قابل للتخصيص',
                    description: 'منتجات يمكن للعميل تخصيصها',
                    icon: Icons.tune,
                    color: const Color(0xFF795548),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// خيار الإدراج السريع
  Widget _buildQuickAddOption(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _showQuickAddDialog(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.accentColor,
              AppTheme.accentColor.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.flash_on, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إدراج سريع ⚡',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'أضف منتج بسرعة (اسم + سعر + صورة)',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha: 0.8),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTypeOption(
    BuildContext context, {
    required String type,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor),
        ),
        trailing: Icon(Icons.chevron_left, color: AppTheme.textHintColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        onTap: () {
          Navigator.pop(context);
          context.push('/dashboard/products/add', extra: {'productType': type});
        },
      ),
    );
  }

  /// نافذة الإدراج السريع
  void _showQuickAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.flash_on,
                    color: AppTheme.accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('إدراج سريع'),
              ],
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // اسم المنتج
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم المنتج *',
                        hintText: 'مثال: هاتف آيفون 15',
                        prefixIcon: const Icon(Icons.inventory_2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال اسم المنتج';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // السعر
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'السعر *',
                        hintText: '0.00',
                        prefixIcon: const Icon(Icons.attach_money),
                        suffixText: 'ر.س',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال السعر';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'سعر غير صالح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // صورة المنتج (اختياري)
                    InkWell(
                      onTap: () async {
                        // TODO: إضافة اختيار الصورة
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('اختيار الصورة قريباً')),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 32,
                                color: AppTheme.textHintColor,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'إضافة صورة (اختياري)',
                                style: TextStyle(
                                  color: AppTheme.textHintColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    // الانتقال لصفحة إضافة منتج مع البيانات المدخلة
                    context.push(
                      '/dashboard/products/add',
                      extra: {
                        'productType': 'physical',
                        'quickAdd': true,
                        'name': nameController.text.trim(),
                        'price': priceController.text.trim(),
                      },
                    );
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('إضافة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final storeState = ref.watch(merchantStoreControllerProvider);
    final store = storeState.store;

    // جعل أيقونات شريط الحالة بيضاء (لأن الهيدر داكن)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // أيقونات بيضاء
        statusBarBrightness: Brightness.dark, // للـ iOS
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // الهيدر العلوي الثابت
          _buildPersistentHeader(context, store?.name ?? 'mbuy'),
          // المحتوى
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNav(context, currentIndex),
    );
  }

  /// الهيدر العلوي الثابت - لون بني كاكاو
  Widget _buildPersistentHeader(BuildContext context, String storeName) {
    final topPadding = MediaQuery.of(context).padding.top;

    // لون بني كاكاو للهيدر
    const Color headerColor = Color(0xFF372018);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 8,
        bottom: 12,
        left: 12,
        right: 12,
      ),
      decoration: const BoxDecoration(color: headerColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // الجانب الأيسر - أزرار الإجراءات
          Row(
            children: [
              _buildHeaderButton(Icons.search, () => _openSearch(context)),
              _buildHeaderButton(
                Icons.smart_toy_outlined,
                () => context.push('/dashboard/ai-assistant'),
              ),
              _buildHeaderButton(
                Icons.notifications_outlined,
                () => context.push('/notification-settings'),
              ),
              _buildHeaderButton(
                Icons.bolt,
                () => context.push('/dashboard/shortcuts'),
              ),
              _buildHeaderButton(
                Icons.add,
                () => _showProductTypeSelection(context),
              ),
            ],
          ),
          // الجانب الأيمن - اسم المتجر والشعار
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/dashboard/view-store'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض متجري',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.visibility,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // أيقونة المتجر - قابلة للضغط
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push('/dashboard/store-management');
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storefront,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildCustomBottomNav(BuildContext context, int currentIndex) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 70 + bottomPadding, // ارتفاع نحيف + SafeArea
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: AppIcons.home,
              label: 'الرئيسية',
              isSelected: currentIndex == 0,
              onTap: () => _onItemTapped(0, context),
            ),
            _buildNavItem(
              icon: AppIcons.orders,
              label: 'الطلبات',
              isSelected: currentIndex == 1,
              onTap: () => _onItemTapped(1, context),
            ),
            _buildNavItem(
              icon: AppIcons.product,
              label: 'المنتجات',
              isSelected: currentIndex == 2,
              onTap: () => _onItemTapped(2, context),
            ),
            _buildNavItem(
              icon: AppIcons.chat,
              label: 'المحادثات',
              isSelected: currentIndex == 3,
              onTap: () => _onItemTapped(3, context),
            ),
            _buildNavItem(
              icon: AppIcons.shipping,
              label: 'دروب شيب',
              isSelected: currentIndex == 4,
              onTap: () => _onItemTapped(4, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              size: 24,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
