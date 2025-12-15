import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// نموذج الحملة الإعلانية
class Promotion {
  final String id;
  final String storeId;
  final String type; // 'PIN' or 'BOOST'
  final String targetType; // 'store', 'product', 'category'
  final String? targetId;
  final int budget;
  final int spent;
  final double multiplier;
  final String
  status; // 'pending', 'active', 'paused', 'completed', 'cancelled'
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  Promotion({
    required this.id,
    required this.storeId,
    required this.type,
    required this.targetType,
    this.targetId,
    required this.budget,
    required this.spent,
    required this.multiplier,
    required this.status,
    this.startDate,
    this.endDate,
    required this.createdAt,
    this.metadata,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] ?? '',
      storeId: json['store_id'] ?? '',
      type: json['type'] ?? 'BOOST',
      targetType: json['target_type'] ?? 'store',
      targetId: json['target_id'],
      budget: json['budget'] ?? 0,
      spent: json['spent'] ?? 0,
      multiplier: (json['multiplier'] ?? 1.0).toDouble(),
      status: json['status'] ?? 'pending',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      metadata: json['metadata'],
    );
  }

  int get remaining => budget - spent;
  double get progress => budget > 0 ? spent / budget : 0;

  String get statusText {
    switch (status) {
      case 'active':
        return 'نشطة';
      case 'pending':
        return 'قيد الانتظار';
      case 'paused':
        return 'متوقفة';
      case 'completed':
        return 'مكتملة';
      case 'cancelled':
        return 'ملغية';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'paused':
        return Colors.grey;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get typeText => type == 'PIN' ? 'تثبيت' : 'تعزيز';
  IconData get typeIcon => type == 'PIN' ? Icons.push_pin : Icons.rocket_launch;
}

/// شاشة ضاعف ظهورك - إدارة الحملات الإعلانية
class PromotionsScreen extends ConsumerStatefulWidget {
  const PromotionsScreen({super.key});

  @override
  ConsumerState<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends ConsumerState<PromotionsScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _api = ApiService();
  late TabController _tabController;

  List<Promotion> _activePromotions = [];
  List<Promotion> _historyPromotions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // جلب الحملات
      final promotionsResponse = await _api.get('/secure/promotions');

      if (promotionsResponse.statusCode == 200) {
        final data = jsonDecode(promotionsResponse.body);
        if (data['ok'] == true && data['data'] != null) {
          final allPromotions = (data['data'] as List)
              .map((item) => Promotion.fromJson(item))
              .toList();

          _activePromotions = allPromotions
              .where((p) => p.status == 'active' || p.status == 'pending')
              .toList();
          _historyPromotions = allPromotions
              .where((p) => p.status != 'active' && p.status != 'pending')
              .toList();
        }
      }
    } catch (e) {
      _error = 'حدث خطأ في تحميل البيانات';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _endPromotion(Promotion promotion) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنهاء الحملة'),
        content: const Text(
          'هل أنت متأكد من إنهاء هذه الحملة؟ سيتم إرجاع النقاط المتبقية إلى رصيدك.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إنهاء'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final response = await _api.post(
          '/secure/promotions/${promotion.id}/end',
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['ok'] == true) {
            HapticFeedback.mediumImpact();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم إنهاء الحملة. تم إرجاع ${data['data']['refunded'] ?? 0} نقطة',
                  ),
                  backgroundColor: AppTheme.successColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            await _loadData();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ: ${e.toString()}'),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'ضاعف ظهورك',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor, size: 24),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          isScrollable: true,
          tabs: const [
            Tab(text: 'حملة جديدة'),
            Tab(text: 'الحملات النشطة'),
            Tab(text: 'سجل الحملات'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorView()
          : Column(
              children: [
                // المحتوى
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildNewCampaignTab(),
                      _buildActiveTab(),
                      _buildHistoryTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNewCampaignTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _CampaignDurationCard(
            title: 'تثبيت المتجر',
            baseDailyPoints: 50,
            onChange: (days, points) {
              // TODO: Update state
            },
          ),
          const SizedBox(height: 16),
          _CampaignDurationCard(
            title: 'دعم ظهور المتجر',
            baseDailyPoints: 30,
            onChange: (days, points) {
              // TODO: Update state
            },
          ),
          const SizedBox(height: 16),
          _CampaignDurationCard(
            title: 'تثبيت المنتج',
            baseDailyPoints: 20,
            onChange: (days, points) {
              // TODO: Update state
            },
          ),
          const SizedBox(height: 16),
          _CampaignDurationCard(
            title: 'دعم ظهور المنتج',
            baseDailyPoints: 10,
            onChange: (days, points) {
              // TODO: Update state
            },
          ),
          const SizedBox(height: 24),
          // TODO: Add submit button logic
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(_error!, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  // Removed _buildPointsCard as requested

  Widget _buildActiveTab() {
    if (_activePromotions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا توجد حملات نشطة',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'أنشئ حملة جديدة لزيادة ظهور متجرك',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activePromotions.length,
        itemBuilder: (context, index) {
          return _buildPromotionCard(
            _activePromotions[index],
            showActions: true,
          );
        },
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_historyPromotions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا يوجد سجل حملات',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _historyPromotions.length,
        itemBuilder: (context, index) {
          return _buildPromotionCard(
            _historyPromotions[index],
            showActions: false,
          );
        },
      ),
    );
  }

  Widget _buildPromotionCard(Promotion promotion, {required bool showActions}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: promotion.statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    promotion.typeIcon,
                    color: promotion.statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            promotion.typeText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: promotion.statusColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              promotion.statusText,
                              style: TextStyle(
                                color: promotion.statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promotion.targetType == 'store'
                            ? 'المتجر كاملاً'
                            : 'منتج محدد',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (showActions && promotion.status == 'active')
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'end') {
                        _endPromotion(promotion);
                      } else if (value == 'report') {
                        // فتح التقرير
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(Icons.assessment, size: 20),
                            SizedBox(width: 8),
                            Text('عرض التقرير'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'end',
                        child: Row(
                          children: [
                            Icon(Icons.stop, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'إنهاء الحملة',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Progress
          if (promotion.status == 'active')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المستهلك: ${promotion.spent}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        'المتبقي: ${promotion.remaining}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: promotion.progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(promotion.statusColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          // Footer with dates
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الميزانية: ${NumberFormat('#,###').format(promotion.budget)} نقطة',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  DateFormat('yyyy/MM/dd').format(promotion.createdAt),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignDurationCard extends StatefulWidget {
  final String title;
  final int baseDailyPoints;
  final Function(int days, int points) onChange;

  const _CampaignDurationCard({
    required this.title,
    required this.baseDailyPoints,
    required this.onChange,
  });

  @override
  State<_CampaignDurationCard> createState() => _CampaignDurationCardState();
}

class _CampaignDurationCardState extends State<_CampaignDurationCard> {
  int _days = 1;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateDays(int newDays) {
    int days = newDays;
    if (days < 1) days = 1;
    if (days > 30) days = 30;

    setState(() {
      _days = days;
      _controller.text = days.toString();
    });
    widget.onChange(days, days * widget.baseDailyPoints);
  }

  @override
  Widget build(BuildContext context) {
    final pointsPrice = _days * widget.baseDailyPoints;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('المدة (أيام):'),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => _updateDays(_days - 1),
                icon: const Icon(Icons.remove_circle_outline),
                color: AppTheme.primaryColor,
              ),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final days = int.tryParse(value);
                    if (days != null) {
                      _updateDays(days);
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () => _updateDays(_days + 1),
                icon: const Icon(Icons.add_circle_outline),
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'سعر النقاط:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '$pointsPrice نقطة',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// نافذة إنشاء حملة جديدة
class _CreatePromotionSheet extends StatefulWidget {
  const _CreatePromotionSheet();

  @override
  State<_CreatePromotionSheet> createState() => _CreatePromotionSheetState();
}

class _CreatePromotionSheetState extends State<_CreatePromotionSheet> {
  String _type = 'BOOST';
  String _targetType = 'store';
  int _budget = 100;
  final TextEditingController _budgetController = TextEditingController(
    text: '100',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'إنشاء حملة جديدة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // نوع الحملة
            const Text(
              'نوع الحملة',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTypeOption(
                    type: 'PIN',
                    title: 'تثبيت',
                    subtitle: 'تثبيت في أعلى القائمة',
                    icon: Icons.push_pin,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeOption(
                    type: 'BOOST',
                    title: 'تعزيز',
                    subtitle: 'زيادة الظهور بالبحث',
                    icon: Icons.rocket_launch,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // الهدف
            const Text('الهدف', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'store', label: Text('المتجر كاملاً')),
                ButtonSegment(value: 'product', label: Text('منتج محدد')),
              ],
              selected: {_targetType},
              onSelectionChanged: (selection) {
                setState(() => _targetType = selection.first);
              },
            ),
            const SizedBox(height: 24),

            // الميزانية
            const Text(
              'الميزانية (نقاط)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'أدخل عدد النقاط',
                suffixText: 'نقطة',
                helperText: 'أدخل الميزانية المطلوبة',
              ),
              onChanged: (value) {
                setState(() => _budget = int.tryParse(value) ?? 0);
              },
            ),
            const SizedBox(height: 24),

            // زر الإنشاء
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _budget > 0
                    ? () {
                        Navigator.pop(context, {
                          'type': _type,
                          'target_type': _targetType,
                          'budget': _budget,
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إنشاء الحملة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
