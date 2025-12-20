import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/exports.dart';

/// قسم الأسعار - محسّن مع حساب الربح
class ProductPricingSection extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController costPriceController;
  final TextEditingController originalPriceController;
  final TextEditingController wholesalePriceController;
  final VoidCallback onChanged;

  const ProductPricingSection({
    super.key,
    required this.priceController,
    required this.costPriceController,
    required this.originalPriceController,
    required this.wholesalePriceController,
    required this.onChanged,
  });

  /// حساب نسبة الربح
  double? get profitPercentage {
    final sellPrice = double.tryParse(priceController.text);
    final costPrice = double.tryParse(costPriceController.text);

    if (sellPrice != null && costPrice != null && costPrice > 0) {
      return ((sellPrice - costPrice) / costPrice) * 100;
    }
    return null;
  }

  /// حساب مبلغ الربح
  double? get profitAmount {
    final sellPrice = double.tryParse(priceController.text);
    final costPrice = double.tryParse(costPriceController.text);

    if (sellPrice != null && costPrice != null) {
      return sellPrice - costPrice;
    }
    return null;
  }

  /// حساب نسبة الخصم
  double? get discountPercentage {
    final sellPrice = double.tryParse(priceController.text);
    final originalPrice = double.tryParse(originalPriceController.text);

    if (sellPrice != null &&
        originalPrice != null &&
        originalPrice > sellPrice) {
      return ((originalPrice - sellPrice) / originalPrice) * 100;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MbuyCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.monetization_on,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'الأسعار',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // صف الأسعار الرئيسية
          Row(
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
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
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
                  onChanged: (_) => onChanged(),
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
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
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
                  onChanged: (_) => onChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // السعر الأصلي وسعر الجملة
          Row(
            children: [
              // السعر الأصلي (قبل الخصم)
              Expanded(
                child: TextFormField(
                  controller: originalPriceController,
                  decoration: InputDecoration(
                    labelText: 'السعر قبل الخصم',
                    hintText: '0.00',
                    suffixText: 'ر.س',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
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
                  onChanged: (_) => onChanged(),
                ),
              ),
              const SizedBox(width: 12),
              // سعر الجملة
              Expanded(
                child: TextFormField(
                  controller: wholesalePriceController,
                  decoration: InputDecoration(
                    labelText: 'سعر الجملة',
                    hintText: '0.00',
                    suffixText: 'ر.س',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
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
                  onChanged: (_) => onChanged(),
                ),
              ),
            ],
          ),

          // عرض نسبة الربح والخصم
          if (profitPercentage != null || discountPercentage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Column(
                children: [
                  if (profitPercentage != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'هامش الربح:',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${profitAmount?.toStringAsFixed(2)} ر.س',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: (profitAmount ?? 0) >= 0
                                    ? AppTheme.successColor
                                    : AppTheme.errorColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (profitPercentage ?? 0) >= 0
                                    ? AppTheme.successColor.withValues(
                                        alpha: 0.1,
                                      )
                                    : AppTheme.errorColor.withValues(
                                        alpha: 0.1,
                                      ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${profitPercentage?.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: (profitPercentage ?? 0) >= 0
                                      ? AppTheme.successColor
                                      : AppTheme.errorColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  if (discountPercentage != null) ...[
                    if (profitPercentage != null) const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'نسبة الخصم:',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${discountPercentage?.toStringAsFixed(0)}% خصم',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
