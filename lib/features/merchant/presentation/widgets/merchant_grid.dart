import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class MerchantGrid extends StatelessWidget {
  final Function(String) onItemTap;

  const MerchantGrid({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.receipt_long_outlined, 'label': 'الطلبات', 'id': 'orders'},
      {'icon': Icons.campaign_outlined, 'label': 'التسويق', 'id': 'marketing'},
      {
        'icon': Icons.storefront_outlined,
        'label': 'إدارة المتجر',
        'id': 'store_mgmt',
      },
      {
        'icon': Icons.palette_outlined,
        'label': 'مظهر المتجر',
        'id': 'appearance',
      },
      {'icon': Icons.trending_up, 'label': 'ضاعف ظهورك', 'id': 'boost'},
      {'icon': Icons.info_outline, 'label': 'من نحن', 'id': 'about'},
      {
        'icon': Icons.camera_enhance_outlined,
        'label': 'mBuy Studio',
        'id': 'studio',
      },
      {'icon': Icons.loyalty_outlined, 'label': 'الولاء', 'id': 'loyalty'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildGridItem(
            item['label'] as String,
            item['icon'] as IconData,
            () => onItemTap(item['id'] as String),
          );
        },
      ),
    );
  }

  Widget _buildGridItem(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MbuyColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MbuyColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: MbuyColors.primaryPurple, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: MbuyColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
