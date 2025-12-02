import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة الطلبات
class OrdersScreen extends StatelessWidget {
  final String? status;

  const OrdersScreen({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOrderCard(
            orderNumber: 'ORD-2024-001',
            date: '2024-12-01',
            total: 250.00,
            status: status ?? 'pending_payment',
          ),
          _buildOrderCard(
            orderNumber: 'ORD-2024-002',
            date: '2024-12-05',
            total: 150.00,
            status: status ?? 'shipping',
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (status) {
      case 'pending_payment':
        return 'قيد الدفع';
      case 'shipping':
        return 'قيد الشحن';
      case 'delivered':
        return 'قيد الاستلام';
      case 'pending_review':
        return 'قيد التقييم';
      default:
        return 'طلباتي';
    }
  }

  Widget _buildOrderCard({
    required String orderNumber,
    required String date,
    required double total,
    required String status,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          orderNumber,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MbuyColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: MbuyColors.textSecondary,
              ),
            ),
            Text(
              '${total.toStringAsFixed(2)} ر.س',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MbuyColors.textPrimary,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: عرض تفاصيل الطلب
        },
      ),
    );
  }
}

