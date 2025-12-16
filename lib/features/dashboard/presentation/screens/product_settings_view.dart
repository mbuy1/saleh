import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../merchant/data/merchant_store_provider.dart';

class ProductSettingsView extends ConsumerStatefulWidget {
  const ProductSettingsView({super.key});

  @override
  ConsumerState<ProductSettingsView> createState() =>
      _ProductSettingsViewState();
}

class _ProductSettingsViewState extends ConsumerState<ProductSettingsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSetting(String key, dynamic value) {
    ref.read(merchantStoreControllerProvider.notifier).updateStoreSettings({
      key: value,
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeState = ref.watch(merchantStoreControllerProvider);
    final settings = storeState.store?.settings ?? {};

    if (storeState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // A) عناصر عامة - شريط البحث
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'البحث عن منتج...',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  AppIcons.search,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: AppDimensions.borderRadiusM,
              ),
              filled: true,
              fillColor: AppTheme.surfaceColor,
            ),
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
            ),
            children: [
              // تمت إزالة قسم "متجرك على جوك" من هنا حسب الطلب
              _buildSectionHeader('الإعدادات العامة'),
              _buildListTileAction('تخصيص التصنيفات', AppIcons.category, () {}),
              _buildSwitchTile(
                'تكرار المنتج',
                'allow_duplicate_product',
                settings,
                defaultValue: true,
              ),
              _buildSwitchTile(
                'عرض عدد مرات الشراء',
                'show_purchase_count',
                settings,
                subtitle: 'يمكن تخصيصه لمنتجات محددة',
              ),
              _buildSwitchTile(
                'عرض المنتجات النافدة أسفل الصفحة',
                'show_out_of_stock_at_bottom',
                settings,
              ),
              _buildSwitchTile(
                'زر "المزيد" في وصف المنتج',
                'show_read_more_button',
                settings,
              ),
              _buildExpansionOption(
                'منتجات قد تعجبك',
                'you_might_like',
                settings,
                options: ['عشوائي', 'نفس التصنيف', 'نفس العلامة', 'نفس الوسم'],
              ),
              _buildSwitchTile(
                'منتج عرض مجاني تلقائي',
                'auto_free_product',
                settings,
              ),
              _buildSwitchTile(
                'عرض الوزن',
                'show_weight',
                settings,
                subtitle: 'في صفحة المنتج، السلة، والفاتورة',
              ),
              _buildSwitchTile(
                'عرض السعر شامل الضريبة',
                'show_price_with_tax',
                settings,
              ),
              _buildTextFieldTile(
                'الوزن الافتراضي للشحن',
                'default_shipping_weight',
                settings,
                suffix: 'كجم',
              ),

              const SizedBox(height: AppDimensions.spacing24),

              // C) عرض المنتجات
              _buildSectionHeader('عرض المنتجات'),
              _buildSwitchTile(
                'عرض المنتجات النافدة',
                'show_out_of_stock_products',
                settings,
                defaultValue: true,
              ),
              _buildSwitchTile(
                'إدخال الكمية يدويًا',
                'manual_quantity_input',
                settings,
              ),
              _buildDropdownTile(
                'طريقة عرض الكمية',
                'quantity_display_mode',
                settings,
                options: ['إخفاء', 'أقل من 5', 'دائماً'],
                defaultValue: 'دائماً',
              ),

              const SizedBox(height: AppDimensions.spacing24),

              // D) خيارات متقدمة (Collapsed)
              ExpansionTile(
                title: const Text(
                  'الخيارات المتقدمة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontBody,
                  ),
                ),
                collapsedBackgroundColor: AppTheme.surfaceColor,
                backgroundColor: AppTheme.surfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  side: BorderSide(color: AppTheme.dividerColor),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  side: BorderSide(color: AppTheme.dividerColor),
                ),
                children: [
                  _buildSwitchTile(
                    'تخصيص الطلب',
                    'enable_order_customization',
                    settings,
                  ),
                  _buildSwitchTile(
                    'تخصيص الدفع',
                    'enable_payment_customization',
                    settings,
                  ),
                  _buildSwitchTile(
                    'تخصيص الشحن',
                    'enable_shipping_customization',
                    settings,
                  ),
                  _buildSwitchTile(
                    'تخصيص الإشعارات',
                    'enable_notification_customization',
                    settings,
                  ),
                  _buildSwitchTile(
                    'حماية المنتج الرقمي (PDF)',
                    'digital_product_protection',
                    settings,
                  ),
                  _buildSwitchTile('عرض SKU', 'show_sku', settings),
                  _buildSwitchTile(
                    'إشعار "أعلمني عند التوفر"',
                    'notify_when_available',
                    settings,
                  ),
                  _buildSwitchTile(
                    'التسوق حسب العلامة التجارية',
                    'shop_by_brand',
                    settings,
                    subtitle: 'مع عرض الوصف',
                  ),
                  _buildSwitchTile(
                    'عرض الصور بجودة كاملة',
                    'full_quality_images',
                    settings,
                    subtitle: 'قد يؤثر على سرعة التحميل (UX)',
                  ),
                  _buildSwitchTile(
                    'سعر الجملة في صفحة المنتج',
                    'show_wholesale_price',
                    settings,
                    subtitle: 'يظهر للعملاء المؤهلين',
                  ),
                  _buildSwitchTile(
                    'توليد الوصف و SEO بالذكاء الاصطناعي',
                    'ai_description_seo',
                    settings,
                  ),
                  _buildSwitchTile(
                    'فلترة الإعلان بالذكاء الاصطناعي',
                    'ai_ad_filtering',
                    settings,
                  ),
                  _buildExpansionOption(
                    'تخصيص الشحن المجاني',
                    'free_shipping_rules',
                    settings,
                    options: ['لمدينة محددة', 'لكمية محددة', 'لسعر محدد'],
                    isMultiSelect: true,
                  ),
                  _buildSwitchTile(
                    'إخفاء الدفع عند الاستلام لعملاء سابقين',
                    'hide_cod_previous_customers',
                    settings,
                  ),
                  _buildSwitchTile(
                    'تفعيل الكاش باك',
                    'enable_cashback',
                    settings,
                  ),
                  _buildSwitchTile(
                    'مجموعة كوبونات',
                    'coupon_bundles',
                    settings,
                  ),
                  _buildSwitchTile(
                    'عرض المنتج بعدة تصنيفات',
                    'multi_category_display',
                    settings,
                  ),
                  _buildListTileAction(
                    'استيراد/تصدير المنتجات',
                    AppIcons.importExport,
                    () {},
                  ),
                  _buildSwitchTile(
                    'إشعار التوفر + عدد العملاء',
                    'availability_notification_count',
                    settings,
                  ),
                  _buildSwitchTile(
                    'شراء مسبق + عدد العملاء',
                    'pre_order_count',
                    settings,
                  ),
                  _buildSwitchTile(
                    'إرسال رابط تقييم بعد التسليم',
                    'send_review_link',
                    settings,
                  ),
                  _buildSwitchTile(
                    'عدم الاسترجاع',
                    'no_return_policy',
                    settings,
                    subtitle: 'مع رابط وزارة التجارة',
                  ),
                  _buildSwitchTile(
                    'علامة نفذت الكمية',
                    'sold_out_badge',
                    settings,
                  ),
                  _buildSwitchTile(
                    'مواصفات + خدمات بعد البيع + نظرة عامة',
                    'extended_product_details',
                    settings,
                  ),
                  _buildSwitchTile(
                    'منتجات مماثلة',
                    'similar_products',
                    settings,
                  ),
                  _buildListTileAction(
                    'صفحة المنتجات المحذوفة',
                    AppIcons.delete,
                    () {},
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacing48),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String key,
    Map<String, dynamic> settings, {
    String? subtitle,
    bool defaultValue = false,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      value: settings[key] ?? defaultValue,
      activeTrackColor: AppTheme.accentColor,
      onChanged: (value) => _updateSetting(key, value),
    );
  }

  Widget _buildExpansionOption(
    String title,
    String key,
    Map<String, dynamic> settings, {
    required List<String> options,
    bool isMultiSelect = false,
  }) {
    final bool isEnabled = settings['${key}_enabled'] ?? false;
    final String? selectedOption = settings['${key}_option'];
    final List<dynamic> selectedOptions = settings['${key}_options'] ?? [];

    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      leading: Switch(
        value: isEnabled,
        activeTrackColor: AppTheme.accentColor,
        onChanged: (value) => _updateSetting('${key}_enabled', value),
      ),
      children: options.map((option) {
        if (isMultiSelect) {
          final isSelected = selectedOptions.contains(option);
          return CheckboxListTile(
            title: Text(option),
            value: isSelected,
            onChanged: isEnabled
                ? (value) {
                    final newList = List.from(selectedOptions);
                    if (value == true) {
                      newList.add(option);
                    } else {
                      newList.remove(option);
                    }
                    _updateSetting('${key}_options', newList);
                  }
                : null,
          );
        } else {
          return InkWell(
            onTap: isEnabled
                ? () => _updateSetting('${key}_option', option)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // ignore: deprecated_member_use
                  Radio<String>(
                    value: option,
                    // ignore: deprecated_member_use
                    groupValue: selectedOption,
                    // ignore: deprecated_member_use
                    onChanged: isEnabled
                        ? (value) => _updateSetting('${key}_option', value)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(option)),
                ],
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  Widget _buildTextFieldTile(
    String title,
    String key,
    Map<String, dynamic> settings, {
    String? suffix,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: SizedBox(
        width: 100,
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: suffix,
            isDense: true,
            contentPadding: const EdgeInsets.all(8),
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (value) => _updateSetting(key, value),
          controller:
              TextEditingController(text: settings[key]?.toString() ?? '')
                ..selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: (settings[key]?.toString() ?? '').length,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String key,
    Map<String, dynamic> settings, {
    required List<String> options,
    required String defaultValue,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: DropdownButton<String>(
        value: settings[key] ?? defaultValue,
        underline: const SizedBox(),
        items: options.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) => _updateSetting(key, value),
      ),
    );
  }

  Widget _buildListTileAction(
    String title,
    String iconPath,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(
          AppTheme.primaryColor,
          BlendMode.srcIn,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: SvgPicture.asset(
        AppIcons.chevronRight,
        width: 16,
        height: 16,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
      onTap: onTap,
    );
  }
}
