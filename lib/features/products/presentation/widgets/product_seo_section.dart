import 'package:flutter/material.dart';
import '../../../../shared/widgets/exports.dart';

/// قسم تحسين محركات البحث (SEO) للمنتج
class ProductSeoSection extends StatelessWidget {
  final TextEditingController slugController;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String storeDomain;

  const ProductSeoSection({
    super.key,
    required this.slugController,
    required this.nameController,
    required this.descriptionController,
    this.storeDomain = 'store.mbuy.sa',
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
              const Icon(Icons.search, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'تحسين محركات البحث (SEO)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الرابط المخصص
          TextFormField(
            controller: slugController,
            decoration: InputDecoration(
              labelText: 'الرابط المخصص (Slug)',
              hintText: 'product-name',
              prefixIcon: const Icon(Icons.link),
              prefixText: '$storeDomain/p/',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 16),

          // معاينة Google
          _buildGooglePreview(),
        ],
      ),
    );
  }

  Widget _buildGooglePreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معاينة نتيجة البحث في Google:',
            style: TextStyle(fontSize: 12, color: AppTheme.textHintColor),
          ),
          const SizedBox(height: 8),
          Text(
            nameController.text.isEmpty ? 'اسم المنتج' : nameController.text,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF1a0dab),
              decoration: TextDecoration.underline,
            ),
          ),
          Text(
            '$storeDomain/p/${slugController.text.isEmpty ? 'product-name' : slugController.text}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF006621)),
          ),
          Text(
            _truncateDescription(descriptionController.text),
            style: const TextStyle(fontSize: 13, color: Color(0xFF545454)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _truncateDescription(String text) {
    if (text.isEmpty) {
      return 'وصف المنتج سيظهر هنا...';
    }
    if (text.length > 160) {
      return '${text.substring(0, 160)}...';
    }
    return text;
  }
}
