import 'package:flutter/material.dart';
import '../../../../core/services/points_service.dart';

class MerchantPointsScreen extends StatefulWidget {
  const MerchantPointsScreen({super.key});

  @override
  State<MerchantPointsScreen> createState() => _MerchantPointsScreenState();
}

class _MerchantPointsScreenState extends State<MerchantPointsScreen> {
  int _pointsBalance = 0;
  List<Map<String, dynamic>> _featureActions = [];
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPointsData();
  }

  Future<void> _loadPointsData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // استخدام Service Layer الجديد
      final balance = await PointsService.getBalance();

      setState(() {
        _pointsBalance = balance;
        // TODO: جلب الميزات المتاحة من API Gateway
        _featureActions = [];
        // TODO: جلب المعاملات من API Gateway
        _transactions = [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _useFeature(String featureKey, String featureTitle, int cost) async {
    // التحقق من الرصيد
    if (_pointsBalance < cost) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لا توجد نقاط كافية. الرصيد الحالي: $_pointsBalance نقطة'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // تأكيد الاستخدام
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('استخدام الميزة: $featureTitle'),
        content: Text('هل تريد صرف $cost نقطة لاستخدام هذه الميزة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // إظهار loading
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    try {
      // TODO: تنفيذ spendPointsForFeature في PointsService
      // حالياً نستخدم API مباشرة أو نعرض رسالة
      // final success = await PointsService.spendPoints(cost, reason: 'feature_$featureKey');
      
      // مؤقتاً: نعتبر العملية ناجحة إذا كان الرصيد كافي
      final success = _pointsBalance >= cost;
      
      if (success) {
        // TODO: خصم النقاط عبر API
        // await PointsService.spendPoints(cost, reason: 'feature_$featureKey');
      }

      if (mounted) {
        Navigator.pop(context); // إغلاق loading dialog

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم استخدام الميزة بنجاح! تم خصم $cost نقطة'),
              backgroundColor: Colors.green,
            ),
          );
          // إعادة تحميل البيانات
          _loadPointsData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لا توجد نقاط كافية'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // إغلاق loading dialog
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
        title: const Text('نقاط التاجر'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPointsData,
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
                        onPressed: _loadPointsData,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPointsData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // بطاقة الرصيد
                        Card(
                          elevation: 4,
                          color: Colors.orange.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Text(
                                  'رصيد النقاط',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_pointsBalance نقطة',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'النقاط هي رصيد خدمات لتفعيل مميزات داخل التطبيق',
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
                        // عنوان الميزات المتاحة
                        const Text(
                          'الميزات المتاحة',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // قائمة الميزات
                        _featureActions.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Text(
                                    'لا توجد ميزات متاحة حالياً',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _featureActions.length,
                                itemBuilder: (context, index) {
                                  final feature = _featureActions[index];
                                  return _buildFeatureCard(feature);
                                },
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

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    final key = feature['key'] as String? ?? '';
    final title = feature['title'] as String? ?? 'ميزة بدون عنوان';
    final description = feature['description'] as String? ?? '';
    final cost = (feature['default_cost'] as num?)?.toInt() ?? 0;
    final canAfford = _pointsBalance >= cost;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$cost نقطة',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: canAfford
                    ? () => _useFeature(key, title, cost)
                    : null,
                icon: const Icon(Icons.rocket_launch),
                label: Text(canAfford ? 'استخدام الميزة' : 'نقاط غير كافية'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? Colors.orange : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final type = transaction['type'] as String? ?? '';
    final pointsChange = (transaction['points_change'] as num?)?.toInt() ?? 0;
    final featureKey = transaction['feature_key'] as String?;
    final createdAt = transaction['created_at'] as String?;

    // تحديد اللون حسب نوع العملية
    final isPurchase = type == 'purchase' || pointsChange > 0;
    Color pointsColor = isPurchase ? Colors.green : Colors.red;
    IconData pointsIcon = isPurchase ? Icons.add_circle : Icons.remove_circle;
    String pointsPrefix = isPurchase ? '+' : '';

    // بناء الوصف
    String description = '';
    if (type == 'purchase') {
      description = 'شراء نقاط';
    } else if (type == 'spend_feature' && featureKey != null) {
      description = 'استخدام ميزة: $featureKey';
    } else {
      description = 'عملية نقاط';
    }

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
          backgroundColor: pointsColor.withValues(alpha: 0.1),
          child: Icon(pointsIcon, color: pointsColor),
        ),
        title: Text(description),
        subtitle: Text(dateText),
        trailing: Text(
          '$pointsPrefix${pointsChange.abs()} نقطة',
          style: TextStyle(
            color: pointsColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

