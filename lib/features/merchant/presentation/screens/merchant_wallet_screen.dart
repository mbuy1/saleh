import 'package:flutter/material.dart';
import '../../../../core/services/wallet_service.dart';

class MerchantWalletScreen extends StatefulWidget {
  const MerchantWalletScreen({super.key});

  @override
  State<MerchantWalletScreen> createState() => _MerchantWalletScreenState();
}

class _MerchantWalletScreenState extends State<MerchantWalletScreen> {
  Map<String, dynamic>? _wallet;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // استخدام Service Layer الجديد
      final walletDetails = await WalletService.getWalletDetails();
      final balance = await WalletService.getBalance();
      
      if (walletDetails != null && walletDetails['type'] == 'merchant') {
        setState(() {
          _wallet = {
            'id': walletDetails['id'],
            'balance': balance,
            'type': 'merchant',
          };
          // TODO: جلب المعاملات من API Gateway عند توفرها
          _transactions = [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _wallet = {'balance': 0.0, 'type': 'merchant'};
          _transactions = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محفظة التاجر'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWalletData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'خطأ: $_error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWalletData,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadWalletData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // بطاقة الرصيد
                        Card(
                          elevation: 4,
                          color: Colors.purple.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Text(
                                  'رصيد التاجر',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${(_wallet?['balance'] as num? ?? 0).toStringAsFixed(2)} ر.س',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'ملاحظة: الرصيد يتم زيادته تلقائياً عند إنشاء طلب مدفوع',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // عنوان العمليات
                        const Text(
                          'آخر العمليات',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // قائمة العمليات
                        _transactions.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Text(
                                    'لا توجد عمليات',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = _transactions[index];
                                  return _buildTransactionItem(transaction);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final amount = (transaction['amount'] as num? ?? 0).toDouble();
    final transactionType = transaction['transaction_type'] as String? ?? '';
    final description = transaction['description'] as String? ?? 'عملية غير محددة';
    final createdAt = transaction['created_at'] as String?;

    // تحديد اللون حسب نوع العملية (in/out)
    final isIncoming = transactionType.toLowerCase().contains('in') ||
        transactionType.toLowerCase() == 'credit' ||
        amount > 0;

    Color amountColor = isIncoming ? Colors.green : Colors.red;
    IconData amountIcon = isIncoming ? Icons.arrow_downward : Icons.arrow_upward;
    String amountPrefix = isIncoming ? '+' : '-';

    // تنسيق التاريخ
    String dateText = 'غير محدد';
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt);
        dateText =
            '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        // في حالة خطأ في parsing التاريخ
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: amountColor.withValues(alpha: 0.1),
          child: Icon(amountIcon, color: amountColor),
        ),
        title: Text(description),
        subtitle: Text(dateText),
        trailing: Text(
          '$amountPrefix${amount.abs().toStringAsFixed(2)} ر.س',
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

