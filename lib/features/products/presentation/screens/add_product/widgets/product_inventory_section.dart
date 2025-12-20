import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../shared/widgets/exports.dart';

/// قسم المخزون في نموذج إضافة المنتج
class ProductInventorySection extends StatelessWidget {
  final TextEditingController stockController;
  final TextEditingController lowStockAlertController;
  final VoidCallback? onChanged;

  const ProductInventorySection({
    super.key,
    required this.stockController,
    required this.lowStockAlertController,
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
          _buildStockRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(Icons.inventory_2, color: AppTheme.primaryColor, size: 20),
        SizedBox(width: 8),
        Text(
          'المخزون',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildStockRow() {
    return Row(
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
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => onChanged?.call(),
          ),
        ),
        const SizedBox(width: 12),
        // تنبيه نفاد المخزون
        Expanded(
          child: TextFormField(
            controller: lowStockAlertController,
            decoration: InputDecoration(
              labelText: 'تنبيه عند',
              hintText: '5',
              prefixIcon: const Icon(Icons.notifications_active),
              suffixText: 'قطعة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => onChanged?.call(),
          ),
        ),
      ],
    );
  }
}
