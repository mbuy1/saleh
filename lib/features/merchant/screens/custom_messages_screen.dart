import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class CustomMessagesScreen extends StatefulWidget {
  const CustomMessagesScreen({super.key});

  @override
  State<CustomMessagesScreen> createState() => _CustomMessagesScreenState();
}

class _CustomMessagesScreenState extends State<CustomMessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  bool _isLoading = true;
  String? _error;

  List<Map<String, dynamic>> _templates = [];
  List<Map<String, dynamic>> _campaigns = [];
  List<Map<String, dynamic>> _automation = [];
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      final results = await Future.wait([
        _api.get('/secure/messages/templates'),
        _api.get('/secure/messages/campaigns'),
        _api.get('/secure/messages/automation'),
        _api.get('/secure/messages/stats'),
      ]);

      if (!mounted) return;

      setState(() {
        _templates = List<Map<String, dynamic>>.from(
          jsonDecode(results[0].body)['data'] ?? [],
        );
        _campaigns = List<Map<String, dynamic>>.from(
          jsonDecode(results[1].body)['data'] ?? [],
        );
        _automation = List<Map<String, dynamic>>.from(
          jsonDecode(results[2].body)['data'] ?? [],
        );
        _stats = jsonDecode(results[3].body)['data'] ?? {};
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('الرسائل المخصصة'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(text: 'نظرة عامة', icon: Icon(Icons.dashboard)),
            Tab(text: 'الحملات', icon: Icon(Icons.campaign)),
            Tab(text: 'الأتمتة', icon: Icon(Icons.auto_mode)),
            Tab(text: 'القوالب', icon: Icon(Icons.description)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildCampaignsTab(),
                _buildAutomationTab(),
                _buildTemplatesTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    final campaignStats = (_stats['campaigns'] as Map<String, dynamic>?) ?? {};
    final messageStats =
        (_stats['messages_30d'] as Map<String, dynamic>?) ?? {};
    final automationStats =
        (_stats['automation'] as Map<String, dynamic>?) ?? {};

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'الحملات النشطة',
                    '${campaignStats['scheduled'] ?? 0}',
                    Icons.campaign,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'الأتمتة النشطة',
                    '${automationStats['active'] ?? 0}',
                    Icons.auto_mode,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'رسائل آخر 30 يوم',
                    '${messageStats['total'] ?? 0}',
                    Icons.message,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'معدل التسليم',
                    _calculateDeliveryRate(messageStats),
                    Icons.check_circle,
                    Colors.teal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick actions
            const Text(
              'إجراءات سريعة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickAction('حملة جديدة', Icons.add, () {
                  _tabController.animateTo(1);
                }),
                _buildQuickAction('قالب جديد', Icons.description, () {
                  _tabController.animateTo(3);
                }),
                _buildQuickAction(
                  'رسالة تجريبية',
                  Icons.send,
                  _showTestMessageDialog,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent campaigns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'آخر الحملات',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_campaigns.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'لا توجد حملات',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              )
            else
              ..._campaigns.take(3).map((c) => _buildCampaignCard(c)),

            const SizedBox(height: 24),

            // Tips
            _buildTipsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }

  String _calculateDeliveryRate(Map<String, dynamic> stats) {
    final total = (stats['total'] ?? 0) as int;
    final sent = (stats['sent'] ?? 0) as int;
    if (total == 0) return '0%';
    return '${(sent / total * 100).toStringAsFixed(0)}%';
  }

  Widget _buildCampaignsTab() {
    return Scaffold(
      body: _campaigns.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('لا توجد حملات'),
                  SizedBox(height: 8),
                  Text(
                    'أنشئ حملة لإرسال رسائل لعملائك',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _campaigns.length,
                itemBuilder: (context, index) {
                  return _buildCampaignCard(_campaigns[index]);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCampaignDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCampaignCard(Map<String, dynamic> campaign) {
    final status = campaign['status'] ?? 'draft';
    final statusColor = _getStatusColor(status);
    final channel = campaign['channel'] ?? 'notification';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showCampaignDetails(campaign),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: statusColor.withAlpha(25),
                    radius: 20,
                    child: Icon(
                      _getChannelIcon(channel),
                      color: statusColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _getChannelLabel(channel),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getStatusLabel(status),
                      style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCampaignStat(
                    'المستهدف',
                    '${campaign['target_count'] ?? 0}',
                  ),
                  _buildCampaignStat(
                    'المرسل',
                    '${campaign['sent_count'] ?? 0}',
                  ),
                  _buildCampaignStat(
                    'المفتوح',
                    '${campaign['opened_count'] ?? 0}',
                  ),
                  _buildCampaignStat(
                    'التفاعل',
                    '${campaign['clicked_count'] ?? 0}',
                  ),
                ],
              ),
              if (status == 'draft' || status == 'scheduled') ...[
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (status == 'draft')
                      TextButton(
                        onPressed: () => _sendCampaign(campaign['id']),
                        child: const Text('إرسال الآن'),
                      ),
                    if (status == 'scheduled')
                      TextButton(
                        onPressed: () => _cancelCampaign(campaign['id']),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildAutomationTab() {
    return Scaffold(
      body: _automation.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_mode_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('لا توجد رسائل تلقائية'),
                  SizedBox(height: 8),
                  Text(
                    'أنشئ رسالة تلقائية لأحداث معينة',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _automation.length,
                itemBuilder: (context, index) {
                  return _buildAutomationCard(_automation[index]);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateAutomationDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAutomationCard(Map<String, dynamic> automation) {
    final isActive = automation['is_active'] ?? false;
    final triggerType = automation['trigger_type'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? Colors.green.withAlpha(25)
              : Colors.grey.withAlpha(25),
          child: Icon(
            _getTriggerIcon(triggerType),
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(automation['name'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getTriggerLabel(triggerType)),
            Text(
              'أُرسلت ${automation['sent_count'] ?? 0} مرة',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Switch(
          value: isActive,
          onChanged: (value) => _toggleAutomation(automation['id']),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildTemplatesTab() {
    return Scaffold(
      body: _templates.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('لا توجد قوالب'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _templates.length,
                itemBuilder: (context, index) {
                  return _buildTemplateCard(_templates[index]);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTemplateDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    final isSystem = template['is_system'] ?? false;
    final channels = (template['channels'] as List?)?.cast<String>() ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSystem
              ? Colors.blue.withAlpha(25)
              : Colors.purple.withAlpha(25),
          child: Icon(
            _getTemplateTypeIcon(template['template_type']),
            color: isSystem ? Colors.blue : Colors.purple,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Text(template['name'] ?? ''),
            if (isSystem) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'نظام',
                  style: TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ),
            ],
          ],
        ),
        subtitle: Row(
          children: channels
              .map(
                (ch) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    _getChannelIcon(ch),
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
              )
              .toList(),
        ),
        trailing: isSystem
            ? null
            : IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showTemplateOptions(template),
              ),
        onTap: () => _showTemplateDetails(template),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      color: Colors.blue.withAlpha(25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'نصائح للرسائل',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('استخدم اسم العميل للتخصيص'),
            _buildTipItem('اختر الوقت المناسب للإرسال'),
            _buildTipItem('اجعل الرسالة قصيرة ومباشرة'),
            _buildTipItem('أضف دعوة للإجراء واضحة'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.blue)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(String status) {
    switch (status) {
      case 'draft':
        return Colors.grey;
      case 'scheduled':
        return Colors.orange;
      case 'sending':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'draft':
        return 'مسودة';
      case 'scheduled':
        return 'مجدولة';
      case 'sending':
        return 'جاري الإرسال';
      case 'completed':
        return 'مكتملة';
      case 'cancelled':
        return 'ملغاة';
      case 'failed':
        return 'فاشلة';
      default:
        return status;
    }
  }

  IconData _getChannelIcon(String channel) {
    switch (channel) {
      case 'notification':
        return Icons.notifications;
      case 'sms':
        return Icons.sms;
      case 'email':
        return Icons.email;
      case 'whatsapp':
        return Icons.chat;
      default:
        return Icons.message;
    }
  }

  String _getChannelLabel(String channel) {
    switch (channel) {
      case 'notification':
        return 'إشعار';
      case 'sms':
        return 'SMS';
      case 'email':
        return 'بريد إلكتروني';
      case 'whatsapp':
        return 'واتساب';
      default:
        return channel;
    }
  }

  IconData _getTriggerIcon(String trigger) {
    switch (trigger) {
      case 'order_placed':
        return Icons.shopping_cart;
      case 'order_shipped':
        return Icons.local_shipping;
      case 'order_delivered':
        return Icons.check_circle;
      case 'cart_abandoned':
        return Icons.remove_shopping_cart;
      case 'new_customer':
        return Icons.person_add;
      case 'inactive_customer':
        return Icons.person_off;
      case 'customer_birthday':
        return Icons.cake;
      case 'review_request':
        return Icons.star;
      default:
        return Icons.auto_mode;
    }
  }

  String _getTriggerLabel(String trigger) {
    switch (trigger) {
      case 'order_placed':
        return 'عند إتمام الطلب';
      case 'order_shipped':
        return 'عند شحن الطلب';
      case 'order_delivered':
        return 'عند توصيل الطلب';
      case 'cart_abandoned':
        return 'سلة متروكة';
      case 'new_customer':
        return 'عميل جديد';
      case 'inactive_customer':
        return 'عميل غير نشط';
      case 'customer_birthday':
        return 'عيد ميلاد العميل';
      case 'review_request':
        return 'طلب تقييم';
      default:
        return trigger;
    }
  }

  IconData _getTemplateTypeIcon(String? type) {
    switch (type) {
      case 'order_confirmation':
        return Icons.receipt;
      case 'shipping_update':
        return Icons.local_shipping;
      case 'abandoned_cart':
        return Icons.shopping_cart;
      case 'welcome':
        return Icons.waving_hand;
      case 'promotion':
        return Icons.local_offer;
      case 'review_request':
        return Icons.star;
      default:
        return Icons.description;
    }
  }

  // Actions
  Future<void> _sendCampaign(String campaignId) async {
    try {
      await _api.post('/secure/messages/campaigns/$campaignId/send', body: {});
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم بدء إرسال الحملة')));
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  Future<void> _cancelCampaign(String campaignId) async {
    try {
      await _api.post(
        '/secure/messages/campaigns/$campaignId/cancel',
        body: {},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إلغاء الحملة')));
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  Future<void> _toggleAutomation(String automationId) async {
    try {
      await _api.patch(
        '/secure/messages/automation/$automationId/toggle',
        body: {},
      );
      _loadData();
    } catch (e) {
      // Ignore
    }
  }

  void _showTestMessageDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('قريباً: إرسال رسالة تجريبية')),
    );
  }

  void _showCreateCampaignDialog() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('قريباً: إنشاء حملة جديدة')));
  }

  void _showCreateAutomationDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('قريباً: إنشاء رسالة تلقائية')),
    );
  }

  void _showCreateTemplateDialog() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('قريباً: إنشاء قالب جديد')));
  }

  void _showCampaignDetails(Map<String, dynamic> campaign) {
    // Show campaign details bottom sheet
  }

  void _showTemplateDetails(Map<String, dynamic> template) {
    // Show template details
  }

  void _showTemplateOptions(Map<String, dynamic> template) {
    // Show template options
  }
}
