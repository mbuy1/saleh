import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة القسائم
class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('القسائم'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCouponCard(
            code: 'SUMMER50',
            discount: 'خصم 50%',
            description: 'خصم على جميع المنتجات',
            expiryDate: '2024-12-31',
            isActive: true,
          ),
          _buildCouponCard(
            code: 'WELCOME20',
            discount: 'خصم 20%',
            description: 'خصم ترحيبي للعملاء الجدد',
            expiryDate: '2024-12-15',
            isActive: true,
          ),
          _buildCouponCard(
            code: 'FREESHIP',
            discount: 'شحن مجاني',
            description: 'شحن مجاني للطلبات فوق 100 ر.س',
            expiryDate: '2024-11-30',
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard({
    required String code,
    required String discount,
    required String description,
    required String expiryDate,
    required bool isActive,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          gradient: isActive ? MbuyColors.primaryGradient : null,
          color: isActive ? null : MbuyColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    discount,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white70 : MbuyColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: isActive ? Colors.white70 : MbuyColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ينتهي: $expiryDate',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: isActive ? Colors.white60 : MbuyColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isActive)
              ElevatedButton(
                onPressed: () {
                  // TODO: نسخ الكود
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم نسخ الكود: $code')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: MbuyColors.textPrimary,
                ),
                child: const Text('استخدام'),
              ),
          ],
        ),
      ),
    );
  }
}

