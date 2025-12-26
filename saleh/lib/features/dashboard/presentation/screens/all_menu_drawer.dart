import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/auth_controller.dart';

/// قائمة "الكل" - تعرض جميع أقسام المتجر مع خياراتها الفرعية
/// بأسلوب سلة: عمود أيمن (اسم القسم) + عمود أيسر (الخيارات)
class AllMenuDrawer extends ConsumerWidget {
  const AllMenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppTheme.surfaceColor,
      child: SafeArea(
        child: Column(
          children: [
            // رأس القائمة
            _buildDrawerHeader(context),
            const Divider(height: 1),
            // محتوى القائمة
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildSection(
                    context,
                    title: 'المتجر الإلكتروني',
                    items: [
                      _MenuItem(
                        'معلومات المتجر',
                        '/dashboard/store-management',
                      ),
                      _MenuItem('تصميم المتجر', '/dashboard/webstore'),
                      _MenuItem('الثيم', '/dashboard/feature/الثيم'),
                      _MenuItem(
                        'دومين المتجر',
                        '/dashboard/feature/دومين المتجر',
                      ),
                      _MenuItem(
                        'الصفحات التعريفية',
                        '/dashboard/feature/الصفحات التعريفية',
                      ),
                      _MenuItem('SEO', '/dashboard/feature/SEO'),
                      _MenuItem('باقة المتجر', '/dashboard/packages'),
                      _MenuItem('الإشعارات', '/dashboard/inbox'),
                    ],
                  ),
                  _buildSection(
                    context,
                    title: 'الطلبات',
                    items: [
                      _MenuItem('إدارة الطلبات', '/dashboard/orders'),
                      _MenuItem(
                        'إعدادات الطلبات',
                        '/dashboard/feature/إعدادات الطلبات',
                      ),
                      _MenuItem(
                        'حالات الطلبات',
                        '/dashboard/feature/حالات الطلبات',
                      ),
                      _MenuItem(
                        'تخصيص الفاتورة',
                        '/dashboard/feature/تخصيص الفاتورة',
                      ),
                      _MenuItem(
                        'الطلبات المحذوفة',
                        '/dashboard/feature/الطلبات المحذوفة',
                      ),
                    ],
                  ),
                  _buildSection(
                    context,
                    title: 'المنتجات',
                    items: [
                      _MenuItem('إدارة المنتجات', '/dashboard/products'),
                      _MenuItem(
                        'إعدادات المنتجات',
                        '/dashboard/feature/إعدادات المنتجات',
                      ),
                      _MenuItem('التصنيفات', '/dashboard/feature/التصنيفات'),
                      _MenuItem('تحرير المنتجات', '/dashboard/products/add'),
                      _MenuItem('المخزون', '/dashboard/inventory'),
                      _MenuItem(
                        'الاستيراد والتصدير',
                        '/dashboard/feature/الاستيراد والتصدير',
                      ),
                    ],
                  ),
                  _buildSection(
                    context,
                    title: 'التسويق',
                    items: [
                      _MenuItem('الكوبونات', '/dashboard/coupons'),
                      _MenuItem('السلات المتروكة', '/dashboard/abandoned-cart'),
                      _MenuItem(
                        'أدوات التتبع',
                        '/dashboard/feature/أدوات التتبع',
                      ),
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
                  _buildSection(
                    context,
                    title: 'العملاء',
                    items: [
                      _MenuItem('إدارة العملاء', '/dashboard/customers'),
                      _MenuItem(
                        'إعدادات العملاء',
                        '/dashboard/feature/إعدادات العملاء',
                      ),
                      _MenuItem(
                        'إدارة المجموعات',
                        '/dashboard/customer-segments',
                      ),
                      _MenuItem('الموظفين', '/dashboard/feature/الموظفين'),
                    ],
                  ),
                  _buildSection(
                    context,
                    title: 'السجلات والتقارير',
                    items: [
                      _MenuItem('أداء المتجر', '/dashboard/sales'),
                      _MenuItem(
                        'التحليلات الذكية',
                        '/dashboard/smart-analytics',
                      ),
                      _MenuItem('التقارير', '/dashboard/reports'),
                      _MenuItem('السجلات', '/dashboard/audit-logs'),
                    ],
                  ),
                  _buildSection(
                    context,
                    title: 'الدفع والشحن',
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
                      _MenuItem(
                        'إعدادات الشحن',
                        '/dashboard/feature/إعدادات الشحن',
                      ),
                    ],
                  ),
                  _buildSection(
                    context,
                    title: 'الأدوات الذكية',
                    items: [
                      _MenuItem('الأدوات الذكية', '/dashboard/tools'),
                      _MenuItem('المساعد الذكي', '/dashboard/ai-assistant'),
                      _MenuItem('مولد المحتوى', '/dashboard/content-generator'),
                      _MenuItem('التسعير الذكي', '/dashboard/smart-pricing'),
                      _MenuItem('الخرائط الحرارية', '/dashboard/heatmap'),
                      _MenuItem(
                        'التقارير التلقائية',
                        '/dashboard/auto-reports',
                      ),
                    ],
                  ),
                  _buildSection(
                    context,
                    title: 'الاستديو',
                    items: [
                      _MenuItem('استديو المحتوى', '/dashboard/studio'),
                      _MenuItem(
                        'مولد السكريبت',
                        '/dashboard/studio/script-generator',
                      ),
                      _MenuItem('محرر المشاهد', '/dashboard/studio/editor'),
                      _MenuItem('محرر الكانفاس', '/dashboard/studio/canvas'),
                      _MenuItem('التصدير', '/dashboard/studio/export'),
                    ],
                  ),
                  _buildSection(
                    context,
                    title: 'الدعم',
                    items: [
                      _MenuItem('الدعم الفني', '/support'),
                      _MenuItem('سياسة الخصوصية', '/privacy-policy'),
                      _MenuItem('الشروط والأحكام', '/terms'),
                      _MenuItem('عن التطبيق', '/dashboard/about'),
                    ],
                  ),
                  const Divider(height: 24, thickness: 1),
                  _buildLogoutButton(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: AppTheme.primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'الكل',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48), // لموازنة زر X
        ],
      ),
    );
  }

  /// بناء القسم: عنوان القسم يليه قائمة الخيارات عمودياً
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // عنوان القسم
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // الخيارات
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  context.push(item.route);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () async {
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

          if (confirm == true && context.mounted) {
            await ref.read(authControllerProvider.notifier).logout();
            if (context.mounted) {
              context.go('/login');
            }
          }
        },
        icon: const Icon(Icons.logout),
        label: const Text('تسجيل الخروج'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final String route;

  _MenuItem(this.title, this.route);
}
