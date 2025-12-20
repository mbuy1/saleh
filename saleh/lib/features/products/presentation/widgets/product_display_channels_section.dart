import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/exports.dart';

/// معلومات قناة العرض
class DisplayChannel {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;

  const DisplayChannel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
  });

  DisplayChannel copyWith({bool? value}) {
    return DisplayChannel(
      id: id,
      title: title,
      subtitle: subtitle,
      icon: icon,
      value: value ?? this.value,
    );
  }
}

/// قسم قنوات عرض المنتج
class ProductDisplayChannelsSection extends StatelessWidget {
  final bool showInStore;
  final bool showInMbuyApp;
  final bool showInDropshipping;
  final ValueChanged<bool> onStoreChanged;
  final ValueChanged<bool> onMbuyChanged;
  final ValueChanged<bool> onDropshippingChanged;
  final TextEditingController? wholesalePriceController;
  final TextEditingController? slaDaysController;

  const ProductDisplayChannelsSection({
    super.key,
    required this.showInStore,
    required this.showInMbuyApp,
    required this.showInDropshipping,
    required this.onStoreChanged,
    required this.onMbuyChanged,
    required this.onDropshippingChanged,
    this.wholesalePriceController,
    this.slaDaysController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        side: BorderSide(color: AppTheme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.visibility, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'قنوات عرض المنتج',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'اختر أين تريد عرض منتجك',
              style: TextStyle(
                fontSize: AppDimensions.fontLabel,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildChannelOption(
              title: 'المتجر',
              subtitle: 'عرض المنتج في متجرك الإلكتروني',
              icon: Icons.storefront,
              value: showInStore,
              onChanged: (value) => onStoreChanged(value ?? true),
            ),
            const Divider(height: 1),
            _buildChannelOption(
              title: 'تطبيق mbuy',
              subtitle: 'عرض المنتج في سوق mbuy',
              icon: Icons.shopping_bag,
              value: showInMbuyApp,
              onChanged: (value) => onMbuyChanged(value ?? true),
            ),
            const Divider(height: 1),
            _buildChannelOption(
              title: 'دروب شوبينق',
              subtitle: 'السماح للتجار الآخرين ببيع هذا المنتج',
              icon: Icons.local_shipping,
              value: showInDropshipping,
              onChanged: (value) => onDropshippingChanged(value ?? false),
            ),
            // حقول إضافية عند تفعيل دروب شوبينق
            if (showInDropshipping) ...[
              const SizedBox(height: 16),
              if (wholesalePriceController != null)
                MbuyInputField(
                  controller: wholesalePriceController!,
                  label: 'سعر الجملة (ر.س)',
                  hint: '0.00',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.price_change,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                ),
              if (slaDaysController != null) ...[
                const SizedBox(height: 12),
                MbuyInputField(
                  controller: slaDaysController!,
                  label: 'مدة التجهيز بالأيام',
                  hint: 'مثال: 3',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.schedule,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChannelOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondaryColor),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: AppDimensions.fontLabel,
          color: AppTheme.textHintColor,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
