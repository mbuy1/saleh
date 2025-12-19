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
                  const Text(
                    'اختر نوع المنتج',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProductTypeOption(
                    context,
                    'منتج ملموس',
                    Icons.inventory_2,
                  ),
                  _buildProductTypeOption(
                    context,
                    'خدمة حسب الطلب',
                    Icons.edit,
                  ),
                  _buildProductTypeOption(
                    context,
                    'أكل ومشروبات',
                    Icons.restaurant,
                  ),
                  _buildProductTypeOption(
                    context,
                    'منتج رقمي',
                    Icons.cloud_download,
                  ),
                  _buildProductTypeOption(
                    context,
                    'حجز موعد',
                    Icons.calendar_today,
                  ),
                  _buildProductTypeOption(context, 'اشتراك', Icons.repeat),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductTypeOption(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_left),
      onTap: () {
        Navigator.pop(context);
        context.push('/dashboard/products/add', extra: {'productType': title});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final storeState = ref.watch(merchantStoreControllerProvider);
    final store = storeState.store;

    // جعل أيقونات شريط الحالة داكنة
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // أيقونات داكنة
        statusBarBrightness: Brightness.light, // للـ iOS
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

  /// الهيدر العلوي الثابت - خلفية شفافة
  Widget _buildPersistentHeader(BuildContext context, String storeName) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 8,
        bottom: 12,
        left: 12,
        right: 12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
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
                      color: AppTheme.textPrimaryColor,
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
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.visibility,
                          size: 12,
                          color: AppTheme.primaryColor,
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
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.storefront,
                    color: AppTheme.primaryColor,
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
        child: Icon(icon, color: AppTheme.primaryColor, size: 22),
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
