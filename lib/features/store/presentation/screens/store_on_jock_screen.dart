import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../merchant/data/merchant_store_provider.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    ⚠️ تحذير مهم - DESIGN FROZEN ⚠️                        ║
// ║                                                                           ║
// ║   صفحة متجرك على جوك - التصميم مثبت ومعتمد                              ║
// ║   تاريخ التثبيت: 14 ديسمبر 2025                                           ║
// ║                                                                           ║
// ║   العناصر المثبتة:                                                        ║
// ║   • رابط المتجر                                                            ║
// ║   • إعدادات المظهر                                                         ║
// ║   • إعدادات المحادثات                                                       ║
// ║                                                                           ║
// ║   ⛔ ممنوع تعديل التصميم إلا بطلب صريح وواضح من المالك                     ║
// ║   ⛔ DO NOT MODIFY design without EXPLICIT owner request                  ║
// ║                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// شاشة متجرك على جوك - إعدادات المتجر الإلكتروني
///
/// 🔒 LOCKED DESIGN - تصميم مثبت
/// Last updated: 2025-12-14
class StoreOnJockScreen extends ConsumerStatefulWidget {
  const StoreOnJockScreen({super.key});

  @override
  ConsumerState<StoreOnJockScreen> createState() => _StoreOnJockScreenState();
}

class _StoreOnJockScreenState extends ConsumerState<StoreOnJockScreen> {
  @override
  Widget build(BuildContext context) {
    final storeState = ref.watch(merchantStoreControllerProvider);
    final settings = storeState.store?.settings ?? {};

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppTheme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'متجرك على جوك',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor, size: 24),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        children: [
          _buildCustomizationItem(
            context,
            '1. تخصيص الخيارات الأساسية',
            'customize_basic_options',
            [
              'show_subcategory_field',
              'show_weight_field',
              'show_preparation_time_field',
              'show_seo_keywords_field',
            ],
            [
              'إظهار التصنيف الفرعي',
              'إظهار الوزن',
              'إظهار مدة التجهيز',
              'إظهار الكلمات المفتاحية',
            ],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '2. تخصيص الشحن',
            'customize_shipping',
            ['enable_shipping_customization', 'default_shipping_weight'],
            ['تفعيل تخصيص الشحن', 'الوزن الافتراضي للشحن'],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '3. تخصيص التصنيفات',
            'customize_categories',
            ['multi_category_display'],
            ['عرض المنتج بعدة تصنيفات'],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '4. تخصيص الدفع',
            'customize_payment',
            ['enable_payment_customization', 'hide_cod_previous_customers'],
            ['تفعيل تخصيص الدفع', 'إخفاء الدفع عند الاستلام لعملاء سابقين'],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '5. تخصيص الجملة',
            'customize_wholesale',
            ['show_wholesale_price', 'apply_discount_to_wholesale'],
            ['عرض سعر الجملة', 'تطبيق الخصم على الجملة'],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '6. تخصيص المميزات المتقدمة',
            'customize_advanced_features',
            ['show_advanced_options_field', 'enable_order_customization'],
            ['إظهار الخيارات المتقدمة', 'تفعيل تخصيص الطلب'],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '7. تخصيص زر إضافة منتج',
            'customize_add_product_button',
            [
              'allow_physical_product',
              'allow_service_product',
              'allow_food_product',
              'allow_digital_product',
              'allow_bundle_product',
              'allow_booking_product',
              'allow_import_export_product',
            ],
            [
              'منتج ملموس',
              'خدمة حسب الطلب',
              'أكل ومشروبات',
              'منتج رقمي',
              'مجموعة منتجات',
              'حجوزات',
              'استيراد وتصدير',
            ],
            settings,
            isProductTypes: true,
          ),
          _buildCustomizationItem(
            context,
            '8. تخصيص الخصومات',
            'customize_discounts',
            ['enable_cashback', 'coupon_bundles'],
            ['تفعيل الكاش باك', 'مجموعة كوبونات'],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '9. تخصيص الإشعارات',
            'customize_notifications',
            ['enable_notification_customization', 'notify_when_available'],
            ['تخصيص الإشعارات', 'إشعار التوفر'],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '10. تخصيص خدمات الذكاء الاصطناعي',
            'customize_ai_services',
            ['ai_description_seo', 'ai_ad_filtering'],
            ['توليد الوصف و SEO', 'فلترة الإعلان'],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '11. تخصيص الشريط العلوي في صفحة المنتجات',
            'customize_top_bar',
            ['show_search_bar', 'show_filter_button'],
            ['إظهار شريط البحث', 'إظهار زر الفلترة'],
            settings,
          ),
          _buildCustomizationItem(
            context,
            '12. متجرك على جوك',
            'customize_jock_identity',
            ['show_jock_badge'],
            ['إظهار شعار جوك'],
            settings,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationItem(
    BuildContext context,
    String title,
    String key,
    List<String> optionKeys,
    List<String> optionLabels,
    Map<String, dynamic> settings, {
    bool isProductTypes = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        side: BorderSide(color: AppTheme.dividerColor),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: ElevatedButton(
          onPressed: () {
            _showChecklistDialog(
              context,
              title,
              optionKeys,
              optionLabels,
              settings,
              isProductTypes: isProductTypes,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
          ),
          child: const Text('خيارات'),
        ),
      ),
    );
  }

  void _showChecklistDialog(
    BuildContext context,
    String title,
    List<String> keys,
    List<String> labels,
    Map<String, dynamic> settings, {
    bool isProductTypes = false,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(keys.length, (index) {
                    final key = keys[index];
                    final label = labels[index];
                    final isChecked = settings[key] ?? true; // Default to true

                    return CheckboxListTile(
                      title: Text(label),
                      value: isChecked,
                      onChanged: (val) {
                        if (isProductTypes && val == false) {
                          // Check if this is the last enabled product type
                          int enabledCount = 0;
                          for (var k in keys) {
                            if (settings[k] ?? true) enabledCount++;
                          }
                          if (enabledCount <= 1 && isChecked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يجب إبقاء نوع واحد على الأقل'),
                              ),
                            );
                            return;
                          }
                        }

                        setState(() {
                          // Update local state for dialog
                          // In a real app, we might want to update the provider immediately or on save
                          // Here we update the provider immediately for simplicity
                          ref
                              .read(merchantStoreControllerProvider.notifier)
                              .updateStoreSettings({key: val});
                        });
                      },
                    );
                  }),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إغلاق'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
