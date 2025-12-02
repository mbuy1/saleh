import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة سجل المعاملات للتاجر
class MerchantTransactionsScreen extends StatelessWidget {
  const MerchantTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('سجل المعاملات'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTransactionCard(
            type: 'إيداع',
            amount: 1250.00,
            date: '2024-12-01',
            description: 'دفعة من طلب #1234',
            isPositive: true,
          ),
          _buildTransactionCard(
            type: 'سحب',
            amount: 500.00,
            date: '2024-12-02',
            description: 'سحب إلى الحساب البنكي',
            isPositive: false,
          ),
          _buildTransactionCard(
            type: 'عمولة',
            amount: 45.00,
            date: '2024-12-03',
            description: 'عمولة منصة mBuy',
            isPositive: false,
          ),
          _buildTransactionCard(
            type: 'إيداع',
            amount: 890.50,
            date: '2024-12-05',
            description: 'دفعة من طلب #1235',
            isPositive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard({
    required String type,
    required double amount,
    required String date,
    required String description,
    required bool isPositive,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPositive
                    ? MbuyColors.success.withValues(alpha: 0.1)
                    : MbuyColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                color: isPositive ? MbuyColors.success : MbuyColors.error,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: MbuyColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: MbuyColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isPositive ? '+' : '-'}${amount.toStringAsFixed(2)} ر.س',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPositive ? MbuyColors.success : MbuyColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

