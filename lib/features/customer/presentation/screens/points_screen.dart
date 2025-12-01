import 'package:flutter/material.dart';
import '../../data/points_service.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  Map<String, dynamic>? _pointsAccount;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPointsData();
  }

  Future<void> _loadPointsData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final account = await PointsService.getPointsForCurrentUser();
      final transactions = await PointsService.getLastPointsTransactions(
        limit: 20,
      );

      setState(() {
        _pointsAccount = account;
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
        title: const Text('نقاطي'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showPointsInfo();
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
              onRefresh: _loadPointsData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // رصيد النقاط
                    _buildPointsBalance(),
                    const SizedBox(height: 16),
                    // كيف تحصل على النقاط
                    _buildHowToEarnPoints(),
                    const SizedBox(height: 16),
                    // العمليات الأخيرة
                    _buildTransactionsList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPointsBalance() {
    final points = (_pointsAccount?['points_balance'] as num?)?.toInt() ?? 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.stars, color: Colors.white, size: 50),
          const SizedBox(height: 12),
          const Text(
            'نقاطك الحالية',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '$points',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'نقطة',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'كل نقطة = 1 ريال',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToEarnPoints() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'كيف تحصل على النقاط؟',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        _buildEarnPointCard(
          icon: Icons.shopping_cart,
          color: Colors.blue,
          title: 'الشراء',
          description: 'احصل على نقاط مع كل عملية شراء',
        ),
        _buildEarnPointCard(
          icon: Icons.star,
          color: Colors.amber,
          title: 'التقييم',
          description: 'قيّم منتجاتك واحصل على نقاط',
        ),
        _buildEarnPointCard(
          icon: Icons.card_giftcard,
          color: Colors.green,
          title: 'العروض الخاصة',
          description: 'استفد من العروض الموسمية',
        ),
      ],
    );
  }

  Widget _buildEarnPointCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
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
            'سجل النقاط',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (_transactions.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد عمليات',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ابدأ بالشراء أو التفاعل لتحصل على نقاط',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
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
    final points = (transaction['points'] as num?)?.toInt() ?? 0;
    final description = transaction['description'] as String? ?? 'عملية';
    final createdAt = transaction['created_at'] as String?;

    IconData icon;
    Color color;
    String prefix;

    switch (type) {
      case 'earn':
        icon = Icons.add_circle;
        color = Colors.green;
        prefix = '+';
        break;
      case 'redeem':
        icon = Icons.remove_circle;
        color = Colors.red;
        prefix = '-';
        break;
      case 'bonus':
        icon = Icons.card_giftcard;
        color = Colors.purple;
        prefix = '+';
        break;
      case 'expire':
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        prefix = '-';
        break;
      default:
        icon = Icons.circle;
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
          '$prefix$points',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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

  void _showPointsInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 8),
            Text('معلومات النقاط'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ما هي النقاط؟',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'النقاط هي مكافآت تحصل عليها عند الشراء أو التفاعل مع التطبيق. كل نقطة تعادل 1 ريال سعودي.',
              ),
              SizedBox(height: 16),
              Text(
                'كيف أستخدم النقاط؟',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'يمكنك استخدام نقاطك كخصم عند الدفع، أو تحويلها لرصيد في محفظتك.',
              ),
              SizedBox(height: 16),
              Text(
                'هل تنتهي صلاحية النقاط؟',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('نعم، النقاط صالحة لمدة 12 شهراً من تاريخ الحصول عليها.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }
}
