import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/exports.dart';

/// قسم المخزون للمنتج
class ProductInventorySection extends StatelessWidget {
  final TextEditingController stockController;
  final TextEditingController lowStockAlertController;

  const ProductInventorySection({
    super.key,
    required this.stockController,
    required this.lowStockAlertController,
  });

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
                Icons.inventory_2,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'المخزون',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // الكمية المتوفرة
              Expanded(
                child: TextFormField(
                  controller: stockController,
                  decoration: InputDecoration(
                    labelText: 'الكمية المتوفرة',
                    hintText: '0',
                    prefixIcon: const Icon(Icons.inventory),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 12),
              // تنبيه نفاد المخزون
              Expanded(
                child: TextFormField(
                  controller: lowStockAlertController,
                  decoration: InputDecoration(
                    labelText: 'تنبيه عند الكمية',
                    hintText: '5',
                    prefixIcon: const Icon(Icons.notification_important),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم إرسال تنبيه عندما تصل الكمية للحد المحدد',
            style: TextStyle(
              fontSize: AppDimensions.fontCaption,
              color: AppTheme.textHintColor,
            ),
          ),
        ],
      ),
    );
  }
}
