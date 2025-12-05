import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class ProtectionBanner extends StatelessWidget {
  const ProtectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MbuyColors.borderLight),
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
          Row(
            children: [
              const Icon(
                Icons.security,
                color: MbuyColors.primaryMaroon,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'حماية الطلبات من mBuy',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MbuyColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem(Icons.headset_mic_outlined, 'دعم 24/7'),
              _buildItem(Icons.currency_exchange, 'استرداد المبلغ'),
              _buildItem(Icons.local_shipping_outlined, 'توصيل مضمون'),
              _buildItem(Icons.lock_outline, 'دفع آمن'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MbuyColors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: MbuyColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: GoogleFonts.cairo(
            fontSize: 10,
            color: MbuyColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
