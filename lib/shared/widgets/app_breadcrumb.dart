import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_dimensions.dart';
import 'app_icon.dart';

/// مكون Breadcrumb للتنقل في الشاشات العميقة
/// يظهر مسار التنقل ويسمح بالعودة لأي مستوى
class AppBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final bool showHomeIcon;

  const AppBreadcrumb({
    super.key,
    required this.items,
    this.showHomeIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showHomeIcon) ...[
              _BreadcrumbChip(
                item: const BreadcrumbItem(
                  label: 'الرئيسية',
                  route: '/dashboard',
                  icon: AppIcons.home,
                ),
                isLast: items.isEmpty,
              ),
              if (items.isNotEmpty) _buildSeparator(),
            ],
            for (int i = 0; i < items.length; i++) ...[
              _BreadcrumbChip(item: items[i], isLast: i == items.length - 1),
              if (i < items.length - 1) _buildSeparator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AppIcon(AppIcons.chevronLeft, size: 14, color: Colors.grey[400]),
    );
  }
}

class _BreadcrumbChip extends StatelessWidget {
  final BreadcrumbItem item;
  final bool isLast;

  const _BreadcrumbChip({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLast
            ? null
            : () {
                HapticFeedback.lightImpact();
                context.go(item.route);
              },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isLast
                ? AppTheme.primaryColor.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                AppIcon(
                  item.icon!,
                  size: 14,
                  color: isLast ? AppTheme.primaryColor : Colors.grey[600],
                ),
                const SizedBox(width: 4),
              ],
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                  color: isLast ? AppTheme.primaryColor : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// عنصر في مسار التنقل
class BreadcrumbItem {
  final String label;
  final String route;
  final String? icon;

  const BreadcrumbItem({required this.label, required this.route, this.icon});
}

/// AppBar مع Breadcrumb مدمج
class BreadcrumbAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<BreadcrumbItem> breadcrumbs;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;

  const BreadcrumbAppBar({
    super.key,
    required this.title,
    required this.breadcrumbs,
    this.actions,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط العنوان
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  if (showBackButton)
                    IconButton(
                      icon: AppIcon(
                        AppIcons.arrowBack,
                        color: AppTheme.primaryColor,
                      ),
                      onPressed: onBack ?? () => context.pop(),
                    ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontDisplay3,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                      textAlign: showBackButton
                          ? TextAlign.start
                          : TextAlign.center,
                    ),
                  ),
                  if (actions != null) ...actions!,
                  if (actions == null && showBackButton)
                    const SizedBox(width: 48),
                ],
              ),
            ),
            // شريط Breadcrumb
            AppBreadcrumb(items: breadcrumbs),
          ],
        ),
      ),
    );
  }
}

/// Helper لبناء breadcrumbs من المسار الحالي
class BreadcrumbHelper {
  static final Map<String, BreadcrumbItem> _routeMap = {
    '/dashboard': const BreadcrumbItem(
      label: 'الرئيسية',
      route: '/dashboard',
      icon: AppIcons.home,
    ),
    '/dashboard/marketing': const BreadcrumbItem(
      label: 'التسويق',
      route: '/dashboard/marketing',
      icon: AppIcons.megaphone,
    ),
    '/dashboard/coupons': const BreadcrumbItem(
      label: 'الكوبونات',
      route: '/dashboard/coupons',
      icon: AppIcons.discount,
    ),
    '/dashboard/flash-sales': const BreadcrumbItem(
      label: 'العروض الخاطفة',
      route: '/dashboard/flash-sales',
      icon: AppIcons.flash,
    ),
    '/dashboard/abandoned-cart': const BreadcrumbItem(
      label: 'السلات المتروكة',
      route: '/dashboard/abandoned-cart',
      icon: AppIcons.cart,
    ),
    '/dashboard/referral': const BreadcrumbItem(
      label: 'برنامج الإحالة',
      route: '/dashboard/referral',
      icon: AppIcons.share,
    ),
    '/dashboard/loyalty-program': const BreadcrumbItem(
      label: 'برنامج الولاء',
      route: '/dashboard/loyalty-program',
      icon: AppIcons.loyalty,
    ),
    '/dashboard/customer-segments': const BreadcrumbItem(
      label: 'شرائح العملاء',
      route: '/dashboard/customer-segments',
      icon: AppIcons.users,
    ),
    '/dashboard/custom-messages': const BreadcrumbItem(
      label: 'رسائل مخصصة',
      route: '/dashboard/custom-messages',
      icon: AppIcons.chat,
    ),
    '/dashboard/smart-pricing': const BreadcrumbItem(
      label: 'التسعير الذكي',
      route: '/dashboard/smart-pricing',
      icon: AppIcons.dollar,
    ),
    '/dashboard/orders': const BreadcrumbItem(
      label: 'الطلبات',
      route: '/dashboard/orders',
      icon: AppIcons.orders,
    ),
    '/dashboard/products': const BreadcrumbItem(
      label: 'المنتجات',
      route: '/dashboard/products',
      icon: AppIcons.product,
    ),
    '/dashboard/shortcuts': const BreadcrumbItem(
      label: 'اختصاراتي',
      route: '/dashboard/shortcuts',
      icon: AppIcons.shortcuts,
    ),
    '/dashboard/reports': const BreadcrumbItem(
      label: 'التقارير',
      route: '/dashboard/reports',
      icon: AppIcons.assessment,
    ),
    '/dashboard/wallet': const BreadcrumbItem(
      label: 'المحفظة',
      route: '/dashboard/wallet',
      icon: AppIcons.wallet,
    ),
    '/dashboard/points': const BreadcrumbItem(
      label: 'النقاط',
      route: '/dashboard/points',
      icon: AppIcons.points,
    ),
    '/dashboard/sales': const BreadcrumbItem(
      label: 'المبيعات',
      route: '/dashboard/sales',
      icon: AppIcons.chart,
    ),
    '/dashboard/customers': const BreadcrumbItem(
      label: 'العملاء',
      route: '/dashboard/customers',
      icon: AppIcons.people,
    ),
    '/dashboard/dropshipping': const BreadcrumbItem(
      label: 'دروب شيبنج',
      route: '/dashboard/dropshipping',
      icon: AppIcons.shipping,
    ),
    '/dashboard/inventory': const BreadcrumbItem(
      label: 'المخزون',
      route: '/dashboard/inventory',
      icon: AppIcons.inventory,
    ),
  };

  /// بناء قائمة breadcrumbs من المسار
  static List<BreadcrumbItem> fromRoute(String currentRoute) {
    final List<BreadcrumbItem> breadcrumbs = [];

    // تحديد المسار الأب
    if (currentRoute.contains('/dashboard/marketing') ||
        currentRoute == '/dashboard/coupons' ||
        currentRoute == '/dashboard/flash-sales' ||
        currentRoute == '/dashboard/abandoned-cart' ||
        currentRoute == '/dashboard/referral' ||
        currentRoute == '/dashboard/loyalty-program' ||
        currentRoute == '/dashboard/customer-segments' ||
        currentRoute == '/dashboard/custom-messages' ||
        currentRoute == '/dashboard/smart-pricing') {
      // شاشات التسويق
      breadcrumbs.add(_routeMap['/dashboard/marketing']!);
    }

    // إضافة العنصر الحالي
    if (_routeMap.containsKey(currentRoute) &&
        currentRoute != '/dashboard/marketing') {
      breadcrumbs.add(_routeMap[currentRoute]!);
    }

    return breadcrumbs;
  }
}
