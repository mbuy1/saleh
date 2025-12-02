import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة إدارة الفواتير للتاجر
class MerchantInvoicesScreen extends StatelessWidget {
  const MerchantInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('إدارة الفواتير'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInvoiceCard(
            context: context,
            invoiceNumber: 'INV-2024-001',
            amount: 1250.00,
            date: '2024-12-01',
            status: 'مدفوعة',
            isPaid: true,
          ),
          _buildInvoiceCard(
            context: context,
            invoiceNumber: 'INV-2024-002',
            amount: 890.50,
            date: '2024-12-05',
            status: 'معلقة',
            isPaid: false,
          ),
          _buildInvoiceCard(
            context: context,
            invoiceNumber: 'INV-2024-003',
            amount: 2100.00,
            date: '2024-12-10',
            status: 'مدفوعة',
            isPaid: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard({
    required BuildContext context,
    required String invoiceNumber,
    required double amount,
    required String date,
    required String status,
    required bool isPaid,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    invoiceNumber,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? MbuyColors.success.withValues(alpha: 0.1)
                        : MbuyColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isPaid ? MbuyColors.success : MbuyColors.warning,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPaid ? MbuyColors.success : MbuyColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${amount.toStringAsFixed(2)} ر.س',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MbuyColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  date,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: MbuyColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                // TODO: عرض تفاصيل الفاتورة
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم إضافة عرض الفاتورة قريباً')),
                );
              },
              child: const Text('عرض التفاصيل'),
            ),
          ],
        ),
      ),
    );
  }
}

