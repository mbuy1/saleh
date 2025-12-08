import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة اختيار طريقة الدفع
class PaymentSelectionScreen extends StatefulWidget {
  final double totalAmount;
  final String currency;

  const PaymentSelectionScreen({
    super.key,
    required this.totalAmount,
    this.currency = 'SAR',
  });

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  List<Map<String, dynamic>> _paymentMethods = [];
  Map<String, dynamic>? _selectedMethod;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final methods = await PaymentService.getAvailablePaymentMethods();
      setState(() {
        _paymentMethods = methods;
        if (methods.isNotEmpty) {
          _selectedMethod = methods.firstWhere(
            (m) => m['id'] == 'wallet',
            orElse: () => methods.first,
          );
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  IconData _getPaymentIcon(String methodId) {
    switch (methodId) {
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'card':
        return Icons.credit_card;
      case 'cash':
        return Icons.money;
      case 'tap':
        return Icons.payment;
      case 'tabby':
        return Icons.shopping_bag;
      case 'tamara':
        return Icons.shopping_cart;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentName(String methodId) {
    switch (methodId) {
      case 'wallet':
        return 'المحفظة الإلكترونية';
      case 'card':
        return 'بطاقة ائتمانية';
      case 'cash':
        return 'الدفع عند الاستلام';
      case 'tap':
        return 'Tap Payments';
      case 'tabby':
        return 'Tabby';
      case 'tamara':
        return 'Tamara';
      default:
        return methodId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('اختر طريقة الدفع'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: MbuyColors.alertRed),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPaymentMethods,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // معلومات المبلغ
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'المبلغ الإجمالي',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${widget.totalAmount.toStringAsFixed(2)} ${widget.currency}',
                              style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.primaryMaroon,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // قائمة طرق الدفع
                    Text(
                      'طرق الدفع المتاحة',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._paymentMethods.map((method) => _buildPaymentMethodCard(method)),
                  ],
                ),
      bottomNavigationBar: _selectedMethod != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MbuyColors.cardBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedMethod);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MbuyColors.primaryMaroon,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'تأكيد',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedMethod?['id'] == method['id'];
    final methodId = method['id'] ?? 'unknown';
    final name = method['name'] ?? _getPaymentName(methodId);
    final description = method['description'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? MbuyColors.primaryMaroon : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMethod = method;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? MbuyColors.primaryMaroon.withValues(alpha: 0.1)
                      : MbuyColors.borderLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPaymentIcon(methodId),
                  color: isSelected ? MbuyColors.primaryMaroon : MbuyColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: MbuyColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: MbuyColors.primaryMaroon,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

