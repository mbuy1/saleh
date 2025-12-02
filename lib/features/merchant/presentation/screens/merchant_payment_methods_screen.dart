import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة طرق الدفع للتاجر
class MerchantPaymentMethodsScreen extends StatelessWidget {
  const MerchantPaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('طرق الدفع'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: فتح شاشة إضافة طريقة دفع
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة طريقة دفع جديدة قريباً')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPaymentMethodCard(
            title: 'حساب بنكي',
            details: '****1234',
            isDefault: true,
            icon: Icons.account_balance,
          ),
          _buildPaymentMethodCard(
            title: 'محفظة إلكترونية',
            details: 'محفظة mBuy',
            isDefault: false,
            icon: Icons.account_balance_wallet,
          ),
          _buildPaymentMethodCard(
            title: 'بطاقة ائتمانية',
            details: '****5678',
            isDefault: false,
            icon: Icons.credit_card,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String title,
    required String details,
    required bool isDefault,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MbuyColors.primaryIndigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: MbuyColors.primaryIndigo),
        ),
        title: Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MbuyColors.textPrimary,
          ),
        ),
        subtitle: Text(
          details,
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: MbuyColors.textSecondary,
          ),
        ),
        trailing: isDefault
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MbuyColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'افتراضي',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: MbuyColors.success,
                  ),
                ),
              )
            : null,
        onTap: () {
          // TODO: تعديل طريقة الدفع
        },
      ),
    );
  }
}

