// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';
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
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => context.pop(),
        ),
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
                  const SizedBox(height: AppDimensions.spacing16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: AppDimensions.spacing16),
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
        padding: AppDimensions.paddingM,
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
                const SizedBox(width: AppDimensions.spacing12),
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
            const SizedBox(height: AppDimensions.spacing12),
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
                const SizedBox(width: AppDimensions.spacing12),
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
            const SizedBox(height: AppDimensions.spacing12),
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
            const SizedBox(height: AppDimensions.spacing8),
            if (_campaigns.isEmpty)
              Card(
                child: Padding(
                  padding: AppDimensions.paddingXL,
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
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppDimensions.spacing8),
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
                  SizedBox(height: AppDimensions.spacing16),
                  Text('لا توجد حملات'),
                  SizedBox(height: AppDimensions.spacing8),
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
                padding: AppDimensions.paddingM,
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
        borderRadius: AppDimensions.borderRadiusM,
        child: Padding(
          padding: AppDimensions.paddingM,
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
                  const SizedBox(width: AppDimensions.spacing12),
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
              const SizedBox(height: AppDimensions.spacing12),
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
                  SizedBox(height: AppDimensions.spacing16),
                  Text('لا توجد رسائل تلقائية'),
                  SizedBox(height: AppDimensions.spacing8),
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
                padding: AppDimensions.paddingM,
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
                  SizedBox(height: AppDimensions.spacing16),
                  Text('لا توجد قوالب'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: AppDimensions.paddingM,
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
              const SizedBox(width: AppDimensions.spacing8),
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
        padding: AppDimensions.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: Colors.blue[700]),
                const SizedBox(width: AppDimensions.spacing8),
                const Text(
                  'نصائح للرسائل',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
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
    final phoneController = TextEditingController();
    String selectedChannel = 'sms';
    String selectedTemplate = _templates.isNotEmpty
        ? _templates.first['id']
        : '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إرسال رسالة تجريبية'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedChannel,
                  decoration: const InputDecoration(
                    labelText: 'قناة الإرسال',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'sms', child: Text('SMS')),
                    DropdownMenuItem(value: 'whatsapp', child: Text('واتساب')),
                    DropdownMenuItem(
                      value: 'email',
                      child: Text('البريد الإلكتروني'),
                    ),
                    DropdownMenuItem(value: 'push', child: Text('إشعار فوري')),
                  ],
                  onChanged: (v) => setDialogState(() => selectedChannel = v!),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: selectedChannel == 'email'
                        ? 'البريد الإلكتروني'
                        : 'رقم الهاتف',
                    hintText: selectedChannel == 'email'
                        ? 'example@mail.com'
                        : '+966 5XX XXX XXXX',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      selectedChannel == 'email' ? Icons.email : Icons.phone,
                    ),
                  ),
                  keyboardType: selectedChannel == 'email'
                      ? TextInputType.emailAddress
                      : TextInputType.phone,
                ),
                const SizedBox(height: AppDimensions.spacing16),
                if (_templates.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: selectedTemplate,
                    decoration: const InputDecoration(
                      labelText: 'القالب',
                      border: OutlineInputBorder(),
                    ),
                    items: _templates
                        .map(
                          (t) => DropdownMenuItem(
                            value: t['id'] as String,
                            child: Text(t['name'] ?? 'قالب'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setDialogState(() => selectedTemplate = v!),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacing12),
                        Text(
                          'جاري إرسال رسالة تجريبية عبر $selectedChannel...',
                        ),
                      ],
                    ),
                    backgroundColor: AppTheme.primaryColor,
                    duration: const Duration(seconds: 2),
                  ),
                );

                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✓ تم إرسال الرسالة التجريبية بنجاح'),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCampaignDialog() {
    final formKey = GlobalKey<FormState>();
    String campaignName = '';
    String channel = 'sms';
    String targetSegment = 'all';
    DateTime scheduledDate = DateTime.now().add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إنشاء حملة جديدة'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'اسم الحملة',
                      hintText: 'مثال: عروض نهاية الأسبوع',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                    onSaved: (v) => campaignName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: channel,
                    decoration: const InputDecoration(
                      labelText: 'قناة الإرسال',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'sms', child: Text('SMS')),
                      DropdownMenuItem(
                        value: 'whatsapp',
                        child: Text('واتساب'),
                      ),
                      DropdownMenuItem(
                        value: 'email',
                        child: Text('البريد الإلكتروني'),
                      ),
                      DropdownMenuItem(
                        value: 'push',
                        child: Text('إشعار فوري'),
                      ),
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('جميع القنوات'),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() => channel = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: targetSegment,
                    decoration: const InputDecoration(
                      labelText: 'الشريحة المستهدفة',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('جميع العملاء'),
                      ),
                      DropdownMenuItem(value: 'vip', child: Text('عملاء VIP')),
                      DropdownMenuItem(value: 'new', child: Text('عملاء جدد')),
                      DropdownMenuItem(
                        value: 'inactive',
                        child: Text('عملاء غير نشطين'),
                      ),
                      DropdownMenuItem(
                        value: 'cart_abandoners',
                        child: Text('تاركي السلة'),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() => targetSegment = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('موعد الإرسال'),
                    subtitle: Text(
                      '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year} - ${scheduledDate.hour}:${scheduledDate.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: scheduledDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        if (!context.mounted) return;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(scheduledDate),
                        );
                        if (time != null) {
                          setDialogState(() {
                            scheduledDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  formKey.currentState?.save();
                  Navigator.pop(context);

                  setState(() {
                    _campaigns.insert(0, {
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'name': campaignName,
                      'channel': channel,
                      'segment': targetSegment,
                      'status': 'scheduled',
                      'scheduled_at': scheduledDate.toIso8601String(),
                      'created_at': DateTime.now().toIso8601String(),
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إنشاء حملة "$campaignName" بنجاح'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateAutomationDialog() {
    final formKey = GlobalKey<FormState>();
    String automationName = '';
    String trigger = 'order_completed';
    String channel = 'sms';
    int delayMinutes = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إنشاء رسالة تلقائية'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'اسم الأتمتة',
                      hintText: 'مثال: شكر بعد الشراء',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                    onSaved: (v) => automationName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: trigger,
                    decoration: const InputDecoration(
                      labelText: 'المحفز',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'order_completed',
                        child: Text('بعد إتمام الطلب'),
                      ),
                      DropdownMenuItem(
                        value: 'order_shipped',
                        child: Text('بعد الشحن'),
                      ),
                      DropdownMenuItem(
                        value: 'order_delivered',
                        child: Text('بعد التسليم'),
                      ),
                      DropdownMenuItem(
                        value: 'cart_abandoned',
                        child: Text('سلة متروكة'),
                      ),
                      DropdownMenuItem(
                        value: 'birthday',
                        child: Text('عيد ميلاد'),
                      ),
                      DropdownMenuItem(
                        value: 'inactive_30days',
                        child: Text('عدم نشاط 30 يوم'),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() => trigger = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: channel,
                    decoration: const InputDecoration(
                      labelText: 'قناة الإرسال',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'sms', child: Text('SMS')),
                      DropdownMenuItem(
                        value: 'whatsapp',
                        child: Text('واتساب'),
                      ),
                      DropdownMenuItem(value: 'email', child: Text('البريد')),
                      DropdownMenuItem(value: 'push', child: Text('إشعار')),
                    ],
                    onChanged: (v) => setDialogState(() => channel = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<int>(
                    value: delayMinutes,
                    decoration: const InputDecoration(
                      labelText: 'التأخير',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('فوري')),
                      DropdownMenuItem(value: 30, child: Text('30 دقيقة')),
                      DropdownMenuItem(value: 60, child: Text('ساعة')),
                      DropdownMenuItem(value: 180, child: Text('3 ساعات')),
                      DropdownMenuItem(value: 1440, child: Text('يوم')),
                    ],
                    onChanged: (v) => setDialogState(() => delayMinutes = v!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  formKey.currentState?.save();
                  Navigator.pop(context);

                  setState(() {
                    _automation.insert(0, {
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'name': automationName,
                      'trigger': trigger,
                      'channel': channel,
                      'delay_minutes': delayMinutes,
                      'is_active': true,
                      'created_at': DateTime.now().toIso8601String(),
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إنشاء أتمتة "$automationName" بنجاح'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTemplateDialog() {
    final formKey = GlobalKey<FormState>();
    String templateName = '';
    String templateContent = '';
    String category = 'general';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إنشاء قالب جديد'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'اسم القالب',
                      hintText: 'مثال: رسالة ترحيب',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                    onSaved: (v) => templateName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      labelText: 'التصنيف',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'general', child: Text('عام')),
                      DropdownMenuItem(value: 'order', child: Text('طلبات')),
                      DropdownMenuItem(
                        value: 'marketing',
                        child: Text('تسويق'),
                      ),
                      DropdownMenuItem(value: 'support', child: Text('دعم')),
                    ],
                    onChanged: (v) => setDialogState(() => category = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'محتوى القالب',
                      hintText: 'استخدم {{customer_name}} للمتغيرات',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                    onSaved: (v) => templateContent = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ActionChip(
                        label: const Text('{{customer_name}}'),
                        onPressed: () {},
                      ),
                      ActionChip(
                        label: const Text('{{order_number}}'),
                        onPressed: () {},
                      ),
                      ActionChip(
                        label: const Text('{{store_name}}'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  formKey.currentState?.save();
                  Navigator.pop(context);

                  setState(() {
                    _templates.insert(0, {
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'name': templateName,
                      'content': templateContent,
                      'category': category,
                      'created_at': DateTime.now().toIso8601String(),
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إنشاء قالب "$templateName" بنجاح'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCampaignDetails(Map<String, dynamic> campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: AppDimensions.paddingXL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 24),
              Text(
                campaign['name'] ?? 'حملة',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              _buildCampaignDetailRow(
                'الحالة',
                campaign['status'] ?? 'غير معروف',
              ),
              _buildCampaignDetailRow('القناة', campaign['channel'] ?? 'SMS'),
              _buildCampaignDetailRow('الشريحة', campaign['segment'] ?? 'الكل'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _campaigns.removeWhere(
                            (c) => c['id'] == campaign['id'],
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم إلغاء الحملة'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      child: const Text('إلغاء الحملة'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text('إغلاق'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showTemplateDetails(Map<String, dynamic> template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(template['name'] ?? 'قالب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المحتوى:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Container(
              padding: AppDimensions.paddingS,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Text(template['content'] ?? 'لا يوجد محتوى'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showTemplateOptions(Map<String, dynamic> template) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('عرض'),
            onTap: () {
              Navigator.pop(context);
              _showTemplateDetails(template);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('تعديل'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري فتح محرر القالب...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('نسخ'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _templates.add({
                  ...template,
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'name': '${template['name']} (نسخة)',
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم نسخ القالب'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('حذف', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _templates.removeWhere((t) => t['id'] == template['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف القالب'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
