import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/exports.dart';
import '../../../ai_studio/data/mbuy_studio_service.dart';

class MbuyToolsScreen extends ConsumerStatefulWidget {
  const MbuyToolsScreen({super.key});

  @override
  ConsumerState<MbuyToolsScreen> createState() => _MbuyToolsScreenState();
}

class _MbuyToolsScreenState extends ConsumerState<MbuyToolsScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;
  String _statusMessage = '';
  String? _generatedImageUrl;
  String? _selectedSectionKey;

  final Map<String, List<Map<String, dynamic>>> _sections = {
    'التحليلات و التقارير': [
      {
        'title': 'تحليلات لحظية',
        'icon': Icons.analytics,
        'taskType': 'analytics_realtime',
      },
      {
        'title': 'تفاعل العملاء',
        'icon': Icons.people,
        'taskType': 'analytics_customer_interaction',
      },
      {
        'title': 'تحليل الشراء',
        'icon': Icons.shopping_cart,
        'taskType': 'analytics_purchase_analysis',
      },
      {
        'title': 'تحليل الأرباح',
        'icon': Icons.attach_money,
        'taskType': 'analytics_profit_analysis',
      },
      {
        'title': 'تحليل المصروفات',
        'icon': Icons.money_off,
        'taskType': 'analytics_expenses_analysis',
      },
      {
        'title': 'رحلة العميل',
        'icon': Icons.timeline,
        'taskType': 'analytics_customer_journey',
      },
      {
        'title': 'تقارير يومية',
        'icon': Icons.today,
        'taskType': 'analytics_daily_reports',
      },
      {
        'title': 'أداء المتجر',
        'icon': Icons.store,
        'taskType': 'analytics_store_performance',
      },
      {
        'title': 'تحليل الحملات',
        'icon': Icons.campaign,
        'taskType': 'analytics_campaign_analysis',
      },
      {
        'title': 'تقارير المبيعات',
        'icon': Icons.bar_chart,
        'taskType': 'analytics_sales_reports',
      },
      {
        'title': 'ملخصات AI',
        'icon': Icons.summarize,
        'taskType': 'analytics_ai_summaries',
        'badge': 'AI',
      },
    ],
    'توليد/تحليل نصوص': [
      {
        'title': 'وصف منتجات',
        'icon': Icons.description,
        'taskType': 'text_product_desc',
        'badge': 'AI',
      },
      {
        'title': 'تحسين SEO',
        'icon': Icons.search,
        'taskType': 'text_seo',
        'badge': 'AI',
      },
      {
        'title': 'كلمات مفتاحية',
        'icon': Icons.vpn_key,
        'taskType': 'text_keywords',
        'badge': 'AI',
      },
      {
        'title': 'خطة تسويقية',
        'icon': Icons.lightbulb,
        'taskType': 'text_marketing_plan',
        'badge': 'AI',
      },
      {
        'title': 'خطة محتوى',
        'icon': Icons.calendar_today,
        'taskType': 'text_content_plan',
        'badge': 'AI',
      },
      {
        'title': 'اقتراحات ذكية',
        'icon': Icons.auto_awesome,
        'taskType': 'text_suggestions',
        'badge': 'AI',
      },
      {
        'title': 'اقتراحات تسعير',
        'icon': Icons.price_change,
        'taskType': 'text_pricing',
        'badge': 'AI',
      },
      {
        'title': 'اقتراحات حملات',
        'icon': Icons.campaign_outlined,
        'taskType': 'text_campaigns',
        'badge': 'AI',
      },
      {
        'title': 'تحويل PDF',
        'icon': Icons.picture_as_pdf,
        'taskType': 'text_pdf_convert',
      },
      {
        'title': 'دمج ملفات',
        'icon': Icons.merge_type,
        'taskType': 'text_merge_files',
      },
      {
        'title': 'جدول بيانات',
        'icon': Icons.table_chart,
        'taskType': 'text_spreadsheet',
        'badge': 'AI',
      },
      {
        'title': 'يوميات',
        'icon': Icons.book,
        'taskType': 'text_diary',
        'badge': 'AI',
      },
      {
        'title': 'ملاحظات',
        'icon': Icons.note,
        'taskType': 'text_notes',
        'badge': 'AI',
      },
    ],
    'وكلاء الذكاء الاصطناعي': [
      {
        'title': 'مساعد شخصي',
        'icon': Icons.person,
        'taskType': 'assistant_personal',
        'badge': 'AI',
      },
      {
        'title': 'مساعد تسويقي',
        'icon': Icons.campaign,
        'taskType': 'assistant_marketing',
        'badge': 'AI',
      },
      {
        'title': 'مدير حساب',
        'icon': Icons.manage_accounts,
        'taskType': 'assistant_account_manager',
        'badge': 'AI',
      },
      {
        'title': 'بوت محادثة',
        'icon': Icons.chat,
        'taskType': 'assistant_chat_bot',
        'badge': 'AI',
      },
    ],
    'الأدوات الأساسية': [
      {'title': 'تخصيص CSS/JS', 'icon': Icons.code, 'taskType': 'basic_css_js'},
      {
        'title': 'محادثة موحدة',
        'icon': Icons.chat_bubble,
        'taskType': 'basic_unified_chat',
      },
    ],
  };

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MbuyScaffold(
      showAppBar: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubPageHeader(context, 'أدوات الذكاء الاصطناعي'),
            if (_selectedSectionKey == null) ...[
              _buildBanner(),
              const SizedBox(height: AppDimensions.spacing20),
              _buildSectionsGrid(),
            ] else ...[
              _buildSelectedSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: AppDimensions.screenPadding,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        gradient: AppTheme.primaryGradient,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'أدوات الذكاء الاصطناعي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.fontH2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.spacing8),
                Text(
                  'كل ما تحتاجه لإدارة وتنمية متجرك في مكان واحد',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AppDimensions.fontBody2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      mainAxisSpacing: AppDimensions.spacing16,
      crossAxisSpacing: AppDimensions.spacing16,
      children: _sections.keys.map((sectionKey) {
        return _buildSectionTile(sectionKey);
      }).toList(),
    );
  }

  Widget _buildSectionTile(String title) {
    IconData icon;
    Color color;

    switch (title) {
      case 'التحليلات و التقارير':
        icon = Icons.analytics;
        color = Colors.blue;
        break;
      case 'توليد/تحليل نصوص':
        icon = Icons.text_fields;
        color = Colors.green;
        break;
      case 'وكلاء الذكاء الاصطناعي':
        icon = Icons.smart_toy;
        color = Colors.purple;
        break;
      case 'الأدوات الأساسية':
        icon = Icons.build;
        color = Colors.orange;
        break;
      default:
        icon = Icons.category;
        color = Colors.grey;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSectionKey = title;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedSection() {
    final tools = _sections[_selectedSectionKey] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedSectionKey = null;
                  });
                },
              ),
              Text(
                _selectedSectionKey!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing10),
        _buildSectionGrid(tools),
        const SizedBox(height: AppDimensions.spacing20),
      ],
    );
  }

  Widget _buildSectionGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacing12,
        mainAxisSpacing: AppDimensions.spacing12,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            if (item.containsKey('taskType')) {
              _handleTask(item['taskType']);
            } else {
              MbuySnackBar.show(
                context,
                message: 'قريباً: ${item['title']}',
                type: MbuySnackBarType.info,
              );
            }
          },
          child: MbuyCard(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        size: AppDimensions.iconL,
                        color: AppTheme.textPrimaryColor,
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Text(
                        item['title'],
                        style: const TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimensions.fontBody2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (item.containsKey('badge'))
                  Positioned(
                    top: 0,
                    left: 0,
                    child: MbuyBadge(
                      label: item['badge'] as String,
                      backgroundColor: AppTheme.warningColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleTask(String taskType) {
    if (taskType.startsWith('analytics_')) {
      _showAnalyticsDialog(taskType);
    } else if (taskType.startsWith('text_') ||
        taskType.startsWith('assistant_')) {
      _showGenerateDialog(taskType: taskType);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('سيتم تفعيل هذه الأداة قريباً')),
      );
    }
  }

  Future<void> _showAnalyticsDialog(String taskType) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('جاري جلب البيانات...'),
        content: const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    try {
      final service = ref.read(mbuyStudioServiceProvider);
      final type = taskType.replaceFirst('analytics_', '');
      final result = await service.getAnalytics(type);

      if (!mounted) return;
      Navigator.pop(context);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(taskType.replaceAll('_', ' ').toUpperCase()),
          content: SingleChildScrollView(
            child: Text(
              const JsonEncoder.withIndent('  ').convert(result['data']),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('موافق'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  void _showGenerateDialog({String taskType = 'ai_image'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'توليد محتوى بالذكاء الاصطناعي',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                hintText: 'اكتب وصف المحتوى هنا...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            if (_isGenerating) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(_statusMessage),
            ] else if (_generatedImageUrl != null) ...[
              // For text results, we might not have an image URL, so handle that
              const SizedBox(),
              const SizedBox(height: 8),
              Text(_statusMessage, style: const TextStyle(color: Colors.green)),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _startCloudflareGeneration(taskType),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('توليد'),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _startCloudflareGeneration(String taskType) async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _statusMessage = 'جاري البدء...';
      _generatedImageUrl = null;
    });

    try {
      final service = ref.read(mbuyStudioServiceProvider);
      final result = await service.generateCloudflareContent(
        taskType: taskType,
        prompt: _promptController.text,
      );

      setState(() {
        _isGenerating = false;
        _statusMessage = 'تم الانتهاء!';
        if (result['result'] != null) {
          if (result['result']['image'] != null) {
            _generatedImageUrl = result['result']['image'];
          } else if (result['result']['text'] != null) {
            _statusMessage =
                'تم توليد النص بنجاح: ${result['result']['text'].toString().substring(0, 50)}...';
          }
        }
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _statusMessage = 'حدث خطأ: $e';
      });
    }
  }

  Widget _buildSubPageHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimensions.iconS,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          const SizedBox(width: AppDimensions.iconM + AppDimensions.spacing16),
        ],
      ),
    );
  }
}
