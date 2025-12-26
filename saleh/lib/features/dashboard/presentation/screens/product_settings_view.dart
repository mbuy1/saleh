import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../merchant/data/merchant_store_provider.dart';

/// شاشة إعدادات المنتجات - تصميم محسن
/// تم إعادة تصميمها بتقسيم واضح للأقسام مع بطاقات مميزة
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
    final storeAsync = ref.watch(merchantStoreControllerProvider);
    final store = storeAsync.hasValue ? storeAsync.value : null;
    final settings = store?.settings ?? {};

    if (storeAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط البحث
          _buildSearchBar(),
          SizedBox(height: AppDimensions.spacing16),

          // === قسم الإعدادات العامة ===
          _buildSettingsCard(
            title: 'الإعدادات العامة',
            icon: Icons.settings_outlined,
            children: [
              _buildSwitchTile(
                'تكرار المنتج',
                'allow_duplicate_product',
                settings,
                defaultValue: true,
                description: 'السماح بإضافة منتجات بنفس الاسم',
              ),
              _buildSwitchTile(
                'عرض عدد مرات الشراء',
                'show_purchase_count',
                settings,
                description: 'يظهر للعملاء عدد مرات شراء المنتج',
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
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),

          // === قسم عرض المنتجات ===
          _buildSettingsCard(
            title: 'عرض المنتجات',
            icon: Icons.grid_view_outlined,
            children: [
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
              _buildSwitchTile(
                'عرض الوزن',
                'show_weight',
                settings,
                description: 'في صفحة المنتج، السلة، والفاتورة',
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),

          // === قسم الأسعار والضرائب ===
          _buildSettingsCard(
            title: 'الأسعار والضرائب',
            icon: Icons.attach_money_outlined,
            color: Colors.green,
            children: [
              _buildSwitchTile(
                'عرض السعر شامل الضريبة',
                'show_price_with_tax',
                settings,
              ),
              _buildSwitchTile(
                'سعر الجملة في صفحة المنتج',
                'show_wholesale_price',
                settings,
                description: 'يظهر للعملاء المؤهلين فقط',
              ),
              _buildTextFieldTile(
                'الوزن الافتراضي للشحن',
                'default_shipping_weight',
                settings,
                suffix: 'كجم',
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),

          // === قسم الذكاء الاصطناعي ===
          _buildSettingsCard(
            title: 'الذكاء الاصطناعي',
            icon: Icons.auto_awesome_outlined,
            color: Colors.purple,
            children: [
              _buildSwitchTile(
                'توليد الوصف بالذكاء الاصطناعي',
                'ai_description_seo',
                settings,
                description: 'توليد وصف ومحتوى SEO تلقائياً',
              ),
              _buildSwitchTile(
                'فلترة الإعلان بالذكاء الاصطناعي',
                'ai_ad_filtering',
                settings,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),

          // === الخيارات المتقدمة ===
          _buildExpandableCard(
            title: 'الخيارات المتقدمة',
            icon: Icons.tune_outlined,
            color: Colors.blueGrey,
            children: [
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
                description: 'مع عرض الوصف',
              ),
              _buildSwitchTile(
                'عرض الصور بجودة كاملة',
                'full_quality_images',
                settings,
                description: 'قد يؤثر على سرعة التحميل',
              ),
              _buildSwitchTile('علامة نفذت الكمية', 'sold_out_badge', settings),
              _buildSwitchTile('منتجات مماثلة', 'similar_products', settings),
              _buildSwitchTile(
                'عرض المنتج بعدة تصنيفات',
                'multi_category_display',
                settings,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),

          // === إجراءات سريعة ===
          _buildSettingsCard(
            title: 'إجراءات سريعة',
            icon: Icons.flash_on_outlined,
            color: Colors.orange,
            children: [
              _buildActionTile('تخصيص التصنيفات', AppIcons.category, () {}),
              _buildActionTile(
                'استيراد/تصدير المنتجات',
                AppIcons.importExport,
                () {},
              ),
              _buildActionTile(
                'صفحة المنتجات المحذوفة',
                AppIcons.delete,
                () {},
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing48),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: 'البحث في الإعدادات...',
          hintStyle: TextStyle(color: AppTheme.textHintColor),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              AppIcons.search,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                AppTheme.textHintColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing12,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Color color = AppTheme.primaryColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: AppTheme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Container(
            padding: AppDimensions.paddingM,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusL - 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                SizedBox(width: AppDimensions.spacing12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDimensions.fontTitle,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          // الإعدادات
          ...children,
        ],
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Color color = AppTheme.primaryColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: AppTheme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: AppDimensions.spacing12),
            Text(
              title,
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusL,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusL,
        ),
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String key,
    Map<String, dynamic> settings, {
    String? description,
    bool defaultValue = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: AppDimensions.fontBody,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: AppDimensions.fontCaption,
                      color: AppTheme.textHintColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: settings[key] ?? defaultValue,
            activeThumbColor: AppTheme.accentColor,
            onChanged: (value) => _updateSetting(key, value),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldTile(
    String title,
    String key,
    Map<String, dynamic> settings, {
    String? suffix,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: AppDimensions.fontBody,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: suffix,
                isDense: true,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: AppDimensions.borderRadiusS,
                  borderSide: BorderSide(color: AppTheme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppDimensions.borderRadiusS,
                  borderSide: BorderSide(color: AppTheme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppDimensions.borderRadiusS,
                  borderSide: const BorderSide(color: AppTheme.accentColor),
                ),
              ),
              onSubmitted: (value) => _updateSetting(key, value),
              controller: TextEditingController(
                text: settings[key]?.toString() ?? '',
              ),
            ),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: AppDimensions.fontBody,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: AppDimensions.borderRadiusS,
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: settings[key] ?? defaultValue,
                isDense: true,
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => _updateSetting(key, value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String iconPath, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing14,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.dividerColor.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: AppDimensions.fontBody,
                  ),
                ),
              ),
              SvgPicture.asset(
                AppIcons.chevronRight,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  AppTheme.textHintColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
