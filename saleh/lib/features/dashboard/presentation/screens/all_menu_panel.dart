import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/auth_controller.dart';

/// قائمة "الكل" - صفحة كاملة مع تبويبات على اليمين وخيارات على اليسار
class AllMenuPanel extends ConsumerStatefulWidget {
  final VoidCallback? onClose;

  const AllMenuPanel({super.key, this.onClose});

  @override
  ConsumerState<AllMenuPanel> createState() => _AllMenuPanelState();
}

class _AllMenuPanelState extends ConsumerState<AllMenuPanel> {
  String _selectedTab = 'المتجر الإلكتروني';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'القائمة الرئيسية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
            onPressed: () {
              widget.onClose?.call();
              Navigator.of(context).pop();
            },
            padding: EdgeInsets.zero,
          ),
        ],
      ),
      body: Row(
        textDirection: TextDirection.rtl,
        children: [
          // التبويبات على اليمين (البداية في RTL)
          SizedBox(width: 180, child: _buildTabsSection()),
          // خط فاصل
          Container(width: 1, color: Colors.grey.withValues(alpha: 0.2)),
          // الخيارات على اليسار (النهاية في RTL)
          Expanded(child: _buildOptionsSection()),
        ],
      ),
    );
  }

  /// قسم التبويبات على اليمين
  Widget _buildTabsSection() {
    final tabs = _getAllSections();

    return ListView.builder(
      itemCount: tabs.length + 1, // +1 لزر تسجيل الخروج
      itemBuilder: (context, index) {
        if (index == tabs.length) {
          // زر تسجيل الخروج في الأسفل
          return _buildLogoutTab();
        }

        final tab = tabs[index];
        final isSelected = _selectedTab == tab.title;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedTab = tab.title;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border(
                right: BorderSide(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Text(
                    tab.title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  tab.icon,
                  size: 20,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// زر تسجيل الخروج في التبويبات
  Widget _buildLogoutTab() {
    return InkWell(
      onTap: () async {
        HapticFeedback.mediumImpact();
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تسجيل الخروج'),
            content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                ),
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        );

        if (confirm == true && mounted) {
          widget.onClose?.call();
          await ref.read(authControllerProvider.notifier).logout();
          if (mounted) {
            context.go('/login');
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withValues(alpha: 0.1),
          border: const Border(
            right: BorderSide(color: AppTheme.errorColor, width: 3),
          ),
        ),
        child: const Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: Text(
                'تسجيل الخروج',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.errorColor,
                ),
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.logout, size: 20, color: AppTheme.errorColor),
          ],
        ),
      ),
    );
  }

  /// قسم الخيارات على اليسار (حسب التبويب المحدد)
  Widget _buildOptionsSection() {
    final section = _getAllSections().firstWhere(
      (s) => s.title == _selectedTab,
      orElse: () => _getAllSections().first,
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: section.items.length,
      itemBuilder: (context, index) {
        final item = section.items[index];

        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onClose?.call();
            context.push(item.route);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.chevron_left,
                  size: 18,
                  color: AppTheme.textHintColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// الحصول على جميع الأقسام مع بياناتها
  List<_TabSection> _getAllSections() {
    return [
      _TabSection(
        title: 'المتجر الإلكتروني',
        icon: Icons.store,
        items: [
          _MenuItem('معلومات المتجر', '/dashboard/store-management'),
          _MenuItem('تصميم المتجر', '/dashboard/webstore'),
          _MenuItem('الثيم', '/dashboard/feature/الثيم'),
          _MenuItem('دومين المتجر', '/dashboard/feature/دومين المتجر'),
          _MenuItem(
            'الصفحات التعريفية',
            '/dashboard/feature/الصفحات التعريفية',
          ),
          _MenuItem('SEO', '/dashboard/feature/SEO'),
          _MenuItem('المشاريع', '/dashboard/projects'),
          _MenuItem('الإشعارات', '/dashboard/inbox'),
          _MenuItem('إعدادات الإشعارات', '/notification-settings'),
          _MenuItem('إعدادات المظهر', '/appearance-settings'),
          _MenuItem('إعدادات الحساب', '/settings'),
        ],
      ),
      _TabSection(
        title: 'الطلبات',
        icon: Icons.receipt_long,
        items: [
          _MenuItem('إدارة الطلبات', '/dashboard/orders'),
          _MenuItem('إعدادات الطلبات', '/dashboard/feature/إعدادات الطلبات'),
          _MenuItem('حالات الطلبات', '/dashboard/feature/حالات الطلبات'),
          _MenuItem('تخصيص الفاتورة', '/dashboard/feature/تخصيص الفاتورة'),
          _MenuItem('الطلبات المحذوفة', '/dashboard/feature/الطلبات المحذوفة'),
        ],
      ),
      _TabSection(
        title: 'المنتجات',
        icon: Icons.inventory_2,
        items: [
          _MenuItem('إدارة المنتجات', '/dashboard/products'),
          _MenuItem('إعدادات المنتجات', '/dashboard/feature/إعدادات المنتجات'),
          _MenuItem('التصنيفات', '/dashboard/feature/التصنيفات'),
          _MenuItem('تحرير المنتجات', '/dashboard/products/add'),
          _MenuItem('المخزون', '/dashboard/inventory'),
          _MenuItem(
            'الاستيراد والتصدير',
            '/dashboard/feature/الاستيراد والتصدير',
          ),
        ],
      ),
      _TabSection(
        title: 'التسويق',
        icon: Icons.campaign,
        items: [
          _MenuItem('الكوبونات', '/dashboard/coupons'),
          _MenuItem('السلات المتروكة', '/dashboard/abandoned-cart'),
          _MenuItem('أدوات التتبع', '/dashboard/feature/أدوات التتبع'),
          _MenuItem('العروض الخاصة', '/dashboard/flash-sales'),
          _MenuItem('الحملات التسويقية', '/dashboard/marketing'),
          _MenuItem('كاش باك', '/dashboard/feature/كاش باك'),
          _MenuItem('الولاء', '/dashboard/loyalty-program'),
          _MenuItem('دعم الظهور', '/dashboard/boost-sales'),
          _MenuItem(
            'تحسين محركات البحث',
            '/dashboard/feature/تحسين محركات البحث',
          ),
        ],
      ),
      _TabSection(
        title: 'العملاء',
        icon: Icons.people,
        items: [
          _MenuItem('إدارة العملاء', '/dashboard/customers'),
          _MenuItem('إعدادات العملاء', '/dashboard/feature/إعدادات العملاء'),
          _MenuItem('إدارة المجموعات', '/dashboard/customer-segments'),
          _MenuItem('الموظفين', '/dashboard/feature/الموظفين'),
        ],
      ),
      _TabSection(
        title: 'التقارير',
        icon: Icons.insert_chart,
        items: [
          _MenuItem('أداء المتجر', '/dashboard/sales'),
          _MenuItem('التحليلات الذكية', '/dashboard/smart-analytics'),
          _MenuItem('التقارير', '/dashboard/reports'),
          _MenuItem('السجلات', '/dashboard/audit-logs'),
        ],
      ),
      _TabSection(
        title: 'الدفع والشحن',
        icon: Icons.local_shipping,
        items: [
          _MenuItem('طرق الدفع', '/dashboard/payment-methods'),
          _MenuItem('المحفظة والفواتير', '/dashboard/wallet'),
          _MenuItem('قيود الدفع', '/dashboard/feature/قيود الدفع'),
          _MenuItem(
            'ضريبة القيمة المضافة',
            '/dashboard/feature/ضريبة القيمة المضافة',
          ),
          _MenuItem('العمليات', '/dashboard/feature/العمليات'),
          _MenuItem('الشحن والتوصيل', '/dashboard/shipping'),
          _MenuItem('إعدادات الشحن', '/dashboard/feature/إعدادات الشحن'),
        ],
      ),
      _TabSection(
        title: 'الأدوات الذكية',
        icon: Icons.auto_awesome,
        items: [
          _MenuItem('الأدوات الذكية', '/dashboard/tools'),
          _MenuItem('المساعد الذكي', '/dashboard/ai-assistant'),
          _MenuItem('مولد المحتوى', '/dashboard/content-generator'),
          _MenuItem('التسعير الذكي', '/dashboard/smart-pricing'),
          _MenuItem('الخرائط الحرارية', '/dashboard/heatmap'),
          _MenuItem('التقارير التلقائية', '/dashboard/auto-reports'),
        ],
      ),
      _TabSection(
        title: 'الاستديو',
        icon: Icons.video_library,
        items: [
          _MenuItem('استديو المحتوى', '/dashboard/studio'),
          _MenuItem('مولد السكريبت', '/dashboard/studio/script-generator'),
          _MenuItem('محرر المشاهد', '/dashboard/studio/editor'),
          _MenuItem('محرر الكانفاس', '/dashboard/studio/canvas'),
          _MenuItem('التصدير', '/dashboard/studio/export'),
        ],
      ),
      _TabSection(
        title: 'الدعم',
        icon: Icons.support_agent,
        items: [
          _MenuItem('الدعم الفني', '/support'),
          _MenuItem('سياسة الخصوصية', '/privacy-policy'),
          _MenuItem('الشروط والأحكام', '/terms'),
          _MenuItem('عن التطبيق', '/dashboard/about'),
        ],
      ),
    ];
  }
}

/// قسم في التبويبات مع عنوان وأيقونة وعناصر
class _TabSection {
  final String title;
  final IconData icon;
  final List<_MenuItem> items;

  _TabSection({required this.title, required this.icon, required this.items});
}

/// عنصر في القائمة
class _MenuItem {
  final String title;
  final String route;

  _MenuItem(this.title, this.route);
}
