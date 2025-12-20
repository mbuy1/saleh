import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../shared/widgets/exports.dart';

/// قسم الأسعار في نموذج إضافة المنتج
class ProductPricingSection extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController costPriceController;
  final TextEditingController originalPriceController;
  final double? profitMargin;
  final double? profitAmount;
  final double? discountPercentage;
  final VoidCallback? onChanged;

  const ProductPricingSection({
    super.key,
    required this.priceController,
    required this.costPriceController,
    required this.originalPriceController,
    this.profitMargin,
    this.profitAmount,
    this.discountPercentage,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MbuyCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildPriceRow(),
          const SizedBox(height: 12),
          _buildOriginalPriceField(),
          if (profitMargin != null || discountPercentage != null) ...[
            const SizedBox(height: 16),
            _buildProfitInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(Icons.monetization_on, color: AppTheme.primaryColor, size: 20),
        SizedBox(width: 8),
        Text(
          'الأسعار',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      children: [
        // سعر البيع
        Expanded(
          child: TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'سعر البيع *',
              hintText: '0.00',
              suffixText: 'ر.س',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'مطلوب';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'غير صالح';
              }
              return null;
            },
            onChanged: (_) => onChanged?.call(),
          ),
        ),
        const SizedBox(width: 12),
        // سعر التكلفة
        Expanded(
          child: TextFormField(
            controller: costPriceController,
            decoration: InputDecoration(
              labelText: 'سعر التكلفة',
              hintText: '0.00',
              suffixText: 'ر.س',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            onChanged: (_) => onChanged?.call(),
          ),
        ),
      ],
    );
  }

  Widget _buildOriginalPriceField() {
    return TextFormField(
      controller: originalPriceController,
      decoration: InputDecoration(
        labelText: 'السعر قبل الخصم (اختياري)',
        hintText: 'اتركه فارغاً إذا لم يكن هناك خصم',
        suffixText: 'ر.س',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      onChanged: (_) => onChanged?.call(),
    );
  }

  Widget _buildProfitInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.slate100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          if (profitMargin != null && profitAmount != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      profitMargin! >= 20 ? Icons.trending_up : Icons.warning,
                      size: 16,
                      color: profitMargin! >= 20
                          ? AppTheme.successColor
                          : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    const Text('هامش الربح:'),
                  ],
                ),
                Text(
                  '${profitMargin!.toStringAsFixed(1)}% (${profitAmount!.toStringAsFixed(2)} ر.س)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: profitMargin! >= 20
                        ? AppTheme.successColor
                        : profitMargin! >= 10
                        ? Colors.orange
                        : AppTheme.errorColor,
                  ),
                ),
              ],
            ),
            if (profitMargin! < 10)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '⚠️ هامش الربح منخفض جداً!',
                  style: TextStyle(
                    fontSize: AppDimensions.fontCaption,
                    color: AppTheme.errorColor,
                  ),
                ),
              ),
          ],
          if (discountPercentage != null) ...[
            if (profitMargin != null) const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_offer, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text('نسبة الخصم:'),
                  ],
                ),
                Text(
                  '${discountPercentage!.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
