import 'package:flutter/material.dart';
import '../../data/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Map<String, dynamic>? _wallet;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final wallet = await WalletService.getWalletForCurrentUser();
      final transactions =
          await WalletService.getWalletTransactionsForCurrentUser(limit: 20);

      setState(() {
        _wallet = wallet;
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحفظة'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('قريباً: سجل كامل للعمليات')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadWalletData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // رصيد المحفظة
                    _buildWalletBalance(),
                    const SizedBox(height: 8),
                    // أزرار الإجراءات
                    _buildActionButtons(),
                    const SizedBox(height: 16),
                    // العمليات الأخيرة
                    _buildTransactionsList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWalletBalance() {
    final balance = (_wallet?['balance'] as num?)?.toDouble() ?? 0.0;
    final currency = _wallet?['currency'] as String? ?? 'SAR';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'رصيدك الحالي',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            '$balance $currency',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  'محفظة نشطة',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.add_circle_outline,
              label: 'شحن',
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('قريباً: شحن المحفظة')),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.remove_circle_outline,
              label: 'سحب',
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('قريباً: سحب من المحفظة')),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.send_outlined,
              label: 'تحويل',
              color: Colors.blue,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('قريباً: تحويل رصيد')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'العمليات الأخيرة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (_transactions.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد عمليات',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              return _buildTransactionItem(_transactions[index]);
            },
          ),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final type = transaction['type'] as String? ?? '';
    final amount = (transaction['amount'] as num?)?.toDouble() ?? 0.0;
    final description = transaction['description'] as String? ?? 'عملية';
    final createdAt = transaction['created_at'] as String?;

    IconData icon;
    Color color;
    String prefix;

    switch (type) {
      case 'deposit':
        icon = Icons.arrow_downward;
        color = Colors.green;
        prefix = '+';
        break;
      case 'withdraw':
        icon = Icons.arrow_upward;
        color = Colors.red;
        prefix = '-';
        break;
      case 'commission':
        icon = Icons.monetization_on;
        color = Colors.orange;
        prefix = '-';
        break;
      case 'cashback':
        icon = Icons.card_giftcard;
        color = Colors.blue;
        prefix = '+';
        break;
      case 'refund':
        icon = Icons.refresh;
        color = Colors.purple;
        prefix = '+';
        break;
      default:
        icon = Icons.sync_alt;
        color = Colors.grey;
        prefix = '';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: createdAt != null
            ? Text(_formatDate(createdAt), style: const TextStyle(fontSize: 12))
            : null,
        trailing: Text(
          '$prefix${amount.toStringAsFixed(2)} ر.س',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'اليوم ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'أمس';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} أيام';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateStr;
    }
  }
}
