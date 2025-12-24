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
      body: SafeArea(
        child: Column(
          children: [
            // Header Ø«Ø§Ø¨Øª Ù…Ø¹ TabBar
            Container(
              color: AppTheme.primaryColor,
              child: Column(
                children: [
                  // Header Row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SvgPicture.asset(
                              AppIcons.arrowBack,
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Ø§Ù„Ø±Ø³Ø§Ø¦Ù„ Ø§Ù„Ù…Ø®ØµØµØ©',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 36),
                      ],
                    ),
                  ),
                  // TabBar
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Ù†Ø¸Ø±Ø© Ø¹Ø§Ù…Ø©', icon: Icon(Icons.dashboard)),
                      Tab(text: 'Ø§Ù„Ø­Ù…Ù„Ø§Øª', icon: Icon(Icons.campaign)),
                      Tab(text: 'Ø§Ù„Ø£ØªÙ…ØªØ©', icon: Icon(Icons.auto_mode)),
                      Tab(text: 'Ø§Ù„Ù‚ÙˆØ§Ù„Ø¨', icon: Icon(Icons.description)),
                    ],
                  ),
                ],
              ),
            ),
            // Body content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: AppDimensions.spacing16),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: AppDimensions.spacing16),
                          ElevatedButton(
                            onPressed: _loadData,
                            child: const Text('Ø¥Ø¹Ø§Ø¯Ø© Ø§Ù„Ù…Ø­Ø§ÙˆÙ„Ø©'),
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
            ),
          ],
        ),
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
                    'Ø§Ù„Ø­Ù…Ù„Ø§Øª Ø§Ù„Ù†Ø´Ø·Ø©',
                    '${campaignStats['scheduled'] ?? 0}',
                    Icons.campaign,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'Ø§Ù„Ø£ØªÙ…ØªØ© Ø§Ù„Ù†Ø´Ø·Ø©',
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
                    'Ø±Ø³Ø§Ø¦Ù„ Ø¢Ø®Ø± 30 ÙŠÙˆÙ…',
                    '${messageStats['total'] ?? 0}',
                    Icons.message,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: _buildStatCard(
                    'Ù…Ø¹Ø¯Ù„ Ø§Ù„ØªØ³Ù„ÙŠÙ…',
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
              'Ø¥Ø¬Ø±Ø§Ø¡Ø§Øª Ø³Ø±ÙŠØ¹Ø©',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickAction('Ø­Ù…Ù„Ø© Ø¬Ø¯ÙŠØ¯Ø©', Icons.add, () {
                  _tabController.animateTo(1);
                }),
                _buildQuickAction('Ù‚Ø§Ù„Ø¨ Ø¬Ø¯ÙŠØ¯', Icons.description, () {
                  _tabController.animateTo(3);
                }),
                _buildQuickAction(
                  'Ø±Ø³Ø§Ù„Ø© ØªØ¬Ø±ÙŠØ¨ÙŠØ©',
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
                  'Ø¢Ø®Ø± Ø§Ù„Ø­Ù…Ù„Ø§Øª',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: const Text('Ø¹Ø±Ø¶ Ø§Ù„ÙƒÙ„'),
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
                      'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø­Ù…Ù„Ø§Øª',
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
                  Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ø­Ù…Ù„Ø§Øª'),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'Ø£Ù†Ø´Ø¦ Ø­Ù…Ù„Ø© Ù„Ø¥Ø±Ø³Ø§Ù„ Ø±Ø³Ø§Ø¦Ù„ Ù„Ø¹Ù…Ù„Ø§Ø¦Ùƒ',
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
                    'Ø§Ù„Ù…Ø³ØªÙ‡Ø¯Ù',
                    '${campaign['target_count'] ?? 0}',
                  ),
                  _buildCampaignStat(
                    'Ø§Ù„Ù…Ø±Ø³Ù„',
                    '${campaign['sent_count'] ?? 0}',
                  ),
                  _buildCampaignStat(
                    'Ø§Ù„Ù…ÙØªÙˆØ­',
                    '${campaign['opened_count'] ?? 0}',
                  ),
                  _buildCampaignStat(
                    'Ø§Ù„ØªÙØ§Ø¹Ù„',
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
                        child: const Text('Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø¢Ù†'),
                      ),
                    if (status == 'scheduled')
                      TextButton(
                        onPressed: () => _cancelCampaign(campaign['id']),
                        child: const Text(
                          'Ø¥Ù„ØºØ§Ø¡',
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
                  Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ø±Ø³Ø§Ø¦Ù„ ØªÙ„Ù‚Ø§Ø¦ÙŠØ©'),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'Ø£Ù†Ø´Ø¦ Ø±Ø³Ø§Ù„Ø© ØªÙ„Ù‚Ø§Ø¦ÙŠØ© Ù„Ø£Ø­Ø¯Ø§Ø« Ù…Ø¹ÙŠÙ†Ø©',
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
              'Ø£ÙØ±Ø³Ù„Øª ${automation['sent_count'] ?? 0} Ù…Ø±Ø©',
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
                  Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ù‚ÙˆØ§Ù„Ø¨'),
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
                  'Ù†Ø¸Ø§Ù…',
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
                  'Ù†ØµØ§Ø¦Ø­ Ù„Ù„Ø±Ø³Ø§Ø¦Ù„',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            _buildTipItem('Ø§Ø³ØªØ®Ø¯Ù… Ø§Ø³Ù… Ø§Ù„Ø¹Ù…ÙŠÙ„ Ù„Ù„ØªØ®ØµÙŠØµ'),
            _buildTipItem('Ø§Ø®ØªØ± Ø§Ù„ÙˆÙ‚Øª Ø§Ù„Ù…Ù†Ø§Ø³Ø¨ Ù„Ù„Ø¥Ø±Ø³Ø§Ù„'),
            _buildTipItem('Ø§Ø¬Ø¹Ù„ Ø§Ù„Ø±Ø³Ø§Ù„Ø© Ù‚ØµÙŠØ±Ø© ÙˆÙ…Ø¨Ø§Ø´Ø±Ø©'),
            _buildTipItem('Ø£Ø¶Ù Ø¯Ø¹ÙˆØ© Ù„Ù„Ø¥Ø¬Ø±Ø§Ø¡ ÙˆØ§Ø¶Ø­Ø©'),
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
          const Text('â€¢ ', style: TextStyle(color: Colors.blue)),
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
        return 'Ù…Ø³ÙˆØ¯Ø©';
      case 'scheduled':
        return 'Ù…Ø¬Ø¯ÙˆÙ„Ø©';
      case 'sending':
        return 'Ø¬Ø§Ø±ÙŠ Ø§Ù„Ø¥Ø±Ø³Ø§Ù„';
      case 'completed':
        return 'Ù…ÙƒØªÙ…Ù„Ø©';
      case 'cancelled':
        return 'Ù…Ù„ØºØ§Ø©';
      case 'failed':
        return 'ÙØ§Ø´Ù„Ø©';
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
        return 'Ø¥Ø´Ø¹Ø§Ø±';
      case 'sms':
        return 'SMS';
      case 'email':
        return 'Ø¨Ø±ÙŠØ¯ Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ';
      case 'whatsapp':
        return 'ÙˆØ§ØªØ³Ø§Ø¨';
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
        return 'Ø¹Ù†Ø¯ Ø¥ØªÙ…Ø§Ù… Ø§Ù„Ø·Ù„Ø¨';
      case 'order_shipped':
        return 'Ø¹Ù†Ø¯ Ø´Ø­Ù† Ø§Ù„Ø·Ù„Ø¨';
      case 'order_delivered':
        return 'Ø¹Ù†Ø¯ ØªÙˆØµÙŠÙ„ Ø§Ù„Ø·Ù„Ø¨';
      case 'cart_abandoned':
        return 'Ø³Ù„Ø© Ù…ØªØ±ÙˆÙƒØ©';
      case 'new_customer':
        return 'Ø¹Ù…ÙŠÙ„ Ø¬Ø¯ÙŠØ¯';
      case 'inactive_customer':
        return 'Ø¹Ù…ÙŠÙ„ ØºÙŠØ± Ù†Ø´Ø·';
      case 'customer_birthday':
        return 'Ø¹ÙŠØ¯ Ù…ÙŠÙ„Ø§Ø¯ Ø§Ù„Ø¹Ù…ÙŠÙ„';
      case 'review_request':
        return 'Ø·Ù„Ø¨ ØªÙ‚ÙŠÙŠÙ…';
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
      ).showSnackBar(const SnackBar(content: Text('ØªÙ… Ø¨Ø¯Ø¡ Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø­Ù…Ù„Ø©')));
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ø®Ø·Ø£: $e')));
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
      ).showSnackBar(const SnackBar(content: Text('ØªÙ… Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø­Ù…Ù„Ø©')));
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ø®Ø·Ø£: $e')));
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
          title: const Text('Ø¥Ø±Ø³Ø§Ù„ Ø±Ø³Ø§Ù„Ø© ØªØ¬Ø±ÙŠØ¨ÙŠØ©'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedChannel,
                  decoration: const InputDecoration(
                    labelText: 'Ù‚Ù†Ø§Ø© Ø§Ù„Ø¥Ø±Ø³Ø§Ù„',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'sms', child: Text('SMS')),
                    DropdownMenuItem(value: 'whatsapp', child: Text('ÙˆØ§ØªØ³Ø§Ø¨')),
                    DropdownMenuItem(
                      value: 'email',
                      child: Text('Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ'),
                    ),
                    DropdownMenuItem(value: 'push', child: Text('Ø¥Ø´Ø¹Ø§Ø± ÙÙˆØ±ÙŠ')),
                  ],
                  onChanged: (v) => setDialogState(() => selectedChannel = v!),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: selectedChannel == 'email'
                        ? 'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ'
                        : 'Ø±Ù‚Ù… Ø§Ù„Ù‡Ø§ØªÙ',
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
                      labelText: 'Ø§Ù„Ù‚Ø§Ù„Ø¨',
                      border: OutlineInputBorder(),
                    ),
                    items: _templates
                        .map(
                          (t) => DropdownMenuItem(
                            value: t['id'] as String,
                            child: Text(t['name'] ?? 'Ù‚Ø§Ù„Ø¨'),
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
              child: const Text('Ø¥Ù„ØºØ§Ø¡'),
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
                          'Ø¬Ø§Ø±ÙŠ Ø¥Ø±Ø³Ø§Ù„ Ø±Ø³Ø§Ù„Ø© ØªØ¬Ø±ÙŠØ¨ÙŠØ© Ø¹Ø¨Ø± $selectedChannel...',
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
                        content: Text('âœ“ ØªÙ… Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø±Ø³Ø§Ù„Ø© Ø§Ù„ØªØ¬Ø±ÙŠØ¨ÙŠØ© Ø¨Ù†Ø¬Ø§Ø­'),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('Ø¥Ø±Ø³Ø§Ù„'),
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
          title: const Text('Ø¥Ù†Ø´Ø§Ø¡ Ø­Ù…Ù„Ø© Ø¬Ø¯ÙŠØ¯Ø©'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ø³Ù… Ø§Ù„Ø­Ù…Ù„Ø©',
                      hintText: 'Ù…Ø«Ø§Ù„: Ø¹Ø±ÙˆØ¶ Ù†Ù‡Ø§ÙŠØ© Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
                    onSaved: (v) => campaignName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: channel,
                    decoration: const InputDecoration(
                      labelText: 'Ù‚Ù†Ø§Ø© Ø§Ù„Ø¥Ø±Ø³Ø§Ù„',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'sms', child: Text('SMS')),
                      DropdownMenuItem(
                        value: 'whatsapp',
                        child: Text('ÙˆØ§ØªØ³Ø§Ø¨'),
                      ),
                      DropdownMenuItem(
                        value: 'email',
                        child: Text('Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ'),
                      ),
                      DropdownMenuItem(
                        value: 'push',
                        child: Text('Ø¥Ø´Ø¹Ø§Ø± ÙÙˆØ±ÙŠ'),
                      ),
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('Ø¬Ù…ÙŠØ¹ Ø§Ù„Ù‚Ù†ÙˆØ§Øª'),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() => channel = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: targetSegment,
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ù„Ø´Ø±ÙŠØ­Ø© Ø§Ù„Ù…Ø³ØªÙ‡Ø¯ÙØ©',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡'),
                      ),
                      DropdownMenuItem(value: 'vip', child: Text('Ø¹Ù…Ù„Ø§Ø¡ VIP')),
                      DropdownMenuItem(value: 'new', child: Text('Ø¹Ù…Ù„Ø§Ø¡ Ø¬Ø¯Ø¯')),
                      DropdownMenuItem(
                        value: 'inactive',
                        child: Text('Ø¹Ù…Ù„Ø§Ø¡ ØºÙŠØ± Ù†Ø´Ø·ÙŠÙ†'),
                      ),
                      DropdownMenuItem(
                        value: 'cart_abandoners',
                        child: Text('ØªØ§Ø±ÙƒÙŠ Ø§Ù„Ø³Ù„Ø©'),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() => targetSegment = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ù…ÙˆØ¹Ø¯ Ø§Ù„Ø¥Ø±Ø³Ø§Ù„'),
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
              child: const Text('Ø¥Ù„ØºØ§Ø¡'),
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
                      content: Text('ØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ø­Ù…Ù„Ø© "$campaignName" Ø¨Ù†Ø¬Ø§Ø­'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('Ø¥Ù†Ø´Ø§Ø¡'),
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
          title: const Text('Ø¥Ù†Ø´Ø§Ø¡ Ø±Ø³Ø§Ù„Ø© ØªÙ„Ù‚Ø§Ø¦ÙŠØ©'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ø³Ù… Ø§Ù„Ø£ØªÙ…ØªØ©',
                      hintText: 'Ù…Ø«Ø§Ù„: Ø´ÙƒØ± Ø¨Ø¹Ø¯ Ø§Ù„Ø´Ø±Ø§Ø¡',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
                    onSaved: (v) => automationName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: trigger,
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ù„Ù…Ø­ÙØ²',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'order_completed',
                        child: Text('Ø¨Ø¹Ø¯ Ø¥ØªÙ…Ø§Ù… Ø§Ù„Ø·Ù„Ø¨'),
                      ),
                      DropdownMenuItem(
                        value: 'order_shipped',
                        child: Text('Ø¨Ø¹Ø¯ Ø§Ù„Ø´Ø­Ù†'),
                      ),
                      DropdownMenuItem(
                        value: 'order_delivered',
                        child: Text('Ø¨Ø¹Ø¯ Ø§Ù„ØªØ³Ù„ÙŠÙ…'),
                      ),
                      DropdownMenuItem(
                        value: 'cart_abandoned',
                        child: Text('Ø³Ù„Ø© Ù…ØªØ±ÙˆÙƒØ©'),
                      ),
                      DropdownMenuItem(
                        value: 'birthday',
                        child: Text('Ø¹ÙŠØ¯ Ù…ÙŠÙ„Ø§Ø¯'),
                      ),
                      DropdownMenuItem(
                        value: 'inactive_30days',
                        child: Text('Ø¹Ø¯Ù… Ù†Ø´Ø§Ø· 30 ÙŠÙˆÙ…'),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() => trigger = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: channel,
                    decoration: const InputDecoration(
                      labelText: 'Ù‚Ù†Ø§Ø© Ø§Ù„Ø¥Ø±Ø³Ø§Ù„',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'sms', child: Text('SMS')),
                      DropdownMenuItem(
                        value: 'whatsapp',
                        child: Text('ÙˆØ§ØªØ³Ø§Ø¨'),
                      ),
                      DropdownMenuItem(value: 'email', child: Text('Ø§Ù„Ø¨Ø±ÙŠØ¯')),
                      DropdownMenuItem(value: 'push', child: Text('Ø¥Ø´Ø¹Ø§Ø±')),
                    ],
                    onChanged: (v) => setDialogState(() => channel = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<int>(
                    value: delayMinutes,
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ù„ØªØ£Ø®ÙŠØ±',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('ÙÙˆØ±ÙŠ')),
                      DropdownMenuItem(value: 30, child: Text('30 Ø¯Ù‚ÙŠÙ‚Ø©')),
                      DropdownMenuItem(value: 60, child: Text('Ø³Ø§Ø¹Ø©')),
                      DropdownMenuItem(value: 180, child: Text('3 Ø³Ø§Ø¹Ø§Øª')),
                      DropdownMenuItem(value: 1440, child: Text('ÙŠÙˆÙ…')),
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
              child: const Text('Ø¥Ù„ØºØ§Ø¡'),
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
                      content: Text('ØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ø£ØªÙ…ØªØ© "$automationName" Ø¨Ù†Ø¬Ø§Ø­'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('Ø¥Ù†Ø´Ø§Ø¡'),
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
          title: const Text('Ø¥Ù†Ø´Ø§Ø¡ Ù‚Ø§Ù„Ø¨ Ø¬Ø¯ÙŠØ¯'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ø³Ù… Ø§Ù„Ù‚Ø§Ù„Ø¨',
                      hintText: 'Ù…Ø«Ø§Ù„: Ø±Ø³Ø§Ù„Ø© ØªØ±Ø­ÙŠØ¨',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
                    onSaved: (v) => templateName = v ?? '',
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      labelText: 'Ø§Ù„ØªØµÙ†ÙŠÙ',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'general', child: Text('Ø¹Ø§Ù…')),
                      DropdownMenuItem(value: 'order', child: Text('Ø·Ù„Ø¨Ø§Øª')),
                      DropdownMenuItem(
                        value: 'marketing',
                        child: Text('ØªØ³ÙˆÙŠÙ‚'),
                      ),
                      DropdownMenuItem(value: 'support', child: Text('Ø¯Ø¹Ù…')),
                    ],
                    onChanged: (v) => setDialogState(() => category = v!),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ù…Ø­ØªÙˆÙ‰ Ø§Ù„Ù‚Ø§Ù„Ø¨',
                      hintText: 'Ø§Ø³ØªØ®Ø¯Ù… {{customer_name}} Ù„Ù„Ù…ØªØºÙŠØ±Ø§Øª',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (v) => v?.isEmpty == true ? 'Ù…Ø·Ù„ÙˆØ¨' : null,
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
              child: const Text('Ø¥Ù„ØºØ§Ø¡'),
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
                      content: Text('ØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ù‚Ø§Ù„Ø¨ "$templateName" Ø¨Ù†Ø¬Ø§Ø­'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('Ø¥Ù†Ø´Ø§Ø¡'),
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
                campaign['name'] ?? 'Ø­Ù…Ù„Ø©',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              _buildCampaignDetailRow(
                'Ø§Ù„Ø­Ø§Ù„Ø©',
                campaign['status'] ?? 'ØºÙŠØ± Ù…Ø¹Ø±ÙˆÙ',
              ),
              _buildCampaignDetailRow('Ø§Ù„Ù‚Ù†Ø§Ø©', campaign['channel'] ?? 'SMS'),
              _buildCampaignDetailRow('Ø§Ù„Ø´Ø±ÙŠØ­Ø©', campaign['segment'] ?? 'Ø§Ù„ÙƒÙ„'),
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
                            content: Text('ØªÙ… Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø­Ù…Ù„Ø©'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      child: const Text('Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø­Ù…Ù„Ø©'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text('Ø¥ØºÙ„Ø§Ù‚'),
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
        title: Text(template['name'] ?? 'Ù‚Ø§Ù„Ø¨'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ø§Ù„Ù…Ø­ØªÙˆÙ‰:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Container(
              padding: AppDimensions.paddingS,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Text(template['content'] ?? 'Ù„Ø§ ÙŠÙˆØ¬Ø¯ Ù…Ø­ØªÙˆÙ‰'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ø¥ØºÙ„Ø§Ù‚'),
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
            title: const Text('Ø¹Ø±Ø¶'),
            onTap: () {
              Navigator.pop(context);
              _showTemplateDetails(template);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('ØªØ¹Ø¯ÙŠÙ„'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ø¬Ø§Ø±ÙŠ ÙØªØ­ Ù…Ø­Ø±Ø± Ø§Ù„Ù‚Ø§Ù„Ø¨...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Ù†Ø³Ø®'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _templates.add({
                  ...template,
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'name': '${template['name']} (Ù†Ø³Ø®Ø©)',
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ØªÙ… Ù†Ø³Ø® Ø§Ù„Ù‚Ø§Ù„Ø¨'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Ø­Ø°Ù', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _templates.removeWhere((t) => t['id'] == template['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ØªÙ… Ø­Ø°Ù Ø§Ù„Ù‚Ø§Ù„Ø¨'),
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
