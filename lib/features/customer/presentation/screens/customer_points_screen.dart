import 'package:flutter/material.dart';
import '../../../../core/services/points_service.dart';
import '../../../../core/firebase_service.dart';
import '../../../../shared/widgets/skeleton/skeleton_loader.dart';
import '../../../../shared/widgets/error_widget/error_state_widget.dart';

class CustomerPointsScreen extends StatefulWidget {
  const CustomerPointsScreen({super.key});

  @override
  State<CustomerPointsScreen> createState() => _CustomerPointsScreenState();
}

class _CustomerPointsScreenState extends State<CustomerPointsScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _pointsAccount;
  List<Map<String, dynamic>>? _transactions;

  @override
  void initState() {
    super.initState();
    _loadPointsData();
    // تتبع عرض النقاط
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseService.logScreenView('customer_points');
    });
  }

  Future<void> _loadPointsData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // استخدام Service Layer الجديد
      final pointsDetails = await PointsService.getPointsDetails();
      final balance = await PointsService.getBalance();

      setState(() {
        _pointsAccount = {
          'balance': balance,
          'id': pointsDetails?['id'],
        };
        // TODO: جلب المعاملات من API Gateway عند توفرها
        _transactions = [];
        _isLoading = false;
      });
      // تتبع عرض النقاط مع الرصيد
      FirebaseService.logViewPoints(balance: balance);
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
        title: const Text('النقاط'),
        actions: [
          Semantics(
            label: 'تحديث النقاط',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadPointsData,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonLoader()
          : _error != null
          ? ErrorStateWidget(
              message: 'فشل تحميل بيانات النقاط',
              details: _error,
              onRetry: _loadPointsData,
            )
          : RefreshIndicator(
              onRefresh: _loadPointsData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // بطاقة الرصيد
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.stars,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'رصيد النقاط',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_pointsAccount?['points_balance'] ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'نقطة',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // معلومات النقاط
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'كيف تكسب النقاط؟',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoTile('🛒', 'كل عملية شراء تمنحك نقاط'),
                          _buildInfoTile('🎁', 'الإحالات والدعوات تزيد رصيدك'),
                          _buildInfoTile('⭐', 'المراجعات والتقييمات'),
                          _buildInfoTile('🎯', 'العروض والمهام الخاصة'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // سجل المعاملات
                  if (_transactions != null && _transactions!.isNotEmpty) ...[
                    Text(
                      'سجل المعاملات',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(_transactions!.map(
                      (transaction) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: transaction['points_amount'] > 0
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            child: Icon(
                              transaction['points_amount'] > 0
                                  ? Icons.add
                                  : Icons.remove,
                              color: transaction['points_amount'] > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          title: Text(
                            transaction['description'] ?? 'معاملة',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            _formatDate(transaction['created_at']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Text(
                            '${transaction['points_amount'] > 0 ? '+' : ''}${transaction['points_amount']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: transaction['points_amount'] > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ] else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد معاملات بعد',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoTile(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildSkeletonLoader() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Skeleton Balance Card
        SkeletonLoader(
          width: double.infinity,
          height: 150,
          borderRadius: BorderRadius.circular(16),
        ),
        const SizedBox(height: 24),
        // Skeleton Section Title
        SkeletonLoader(width: 150, height: 20),
        const SizedBox(height: 16),
        // Skeleton Transactions
        ...List.generate(5, (index) => const SkeletonListItem()),
      ],
    );
  }
}
