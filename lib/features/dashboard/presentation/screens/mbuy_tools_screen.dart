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
        padding: const EdgeInsets.only(bottom: 100), // مسافة للبار السفلي
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubPageHeader(context, 'أدوات AI'),
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
              // تفعيل الأداة حتى لو لم يكن لها taskType
              _handleGenericTool(item['title'] ?? '', item['icon']);
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
    } else if (taskType.startsWith('image_')) {
      _showImageToolDialog(taskType);
    } else if (taskType.startsWith('marketing_')) {
      _showMarketingToolDialog(taskType);
    } else if (taskType.startsWith('store_')) {
      _showStoreToolDialog(taskType);
    } else {
      _handleGenericTool(taskType.replaceAll('_', ' '), Icons.build);
    }
  }

  void _handleGenericTool(String toolName, IconData? icon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Icon(icon ?? Icons.build, size: 48, color: AppTheme.primaryColor),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              toolName,
              style: const TextStyle(
                fontSize: AppDimensions.fontHeadline,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            const Text(
              'هذه الأداة جاهزة للاستخدام',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            _buildToolDemoContent(toolName),
            const SizedBox(height: AppDimensions.spacing24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  MbuySnackBar.show(
                    context,
                    message: 'تم تشغيل: $toolName',
                    type: MbuySnackBarType.success,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spacing12,
                  ),
                ),
                child: const Text('تشغيل الأداة'),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
          ],
        ),
      ),
    );
  }

  Widget _buildToolDemoContent(String toolName) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppTheme.successColor,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacing8),
              const Expanded(child: Text('جاهز للاستخدام')),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Row(
            children: [
              const Icon(Icons.speed, color: AppTheme.accentColor, size: 20),
              const SizedBox(width: AppDimensions.spacing8),
              const Expanded(child: Text('أداء عالي وسريع')),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Row(
            children: [
              const Icon(
                Icons.security,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spacing8),
              const Expanded(child: Text('آمن ومحمي')),
            ],
          ),
        ],
      ),
    );
  }

  void _showImageToolDialog(String taskType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'معالجة الصور',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: Colors.grey[300]!,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text('اضغط لرفع صورة', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  MbuySnackBar.show(
                    context,
                    message: 'جاري معالجة الصورة...',
                    type: MbuySnackBarType.info,
                  );
                },
                icon: const Icon(Icons.auto_fix_high),
                label: Text(_getImageTaskLabel(taskType)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _getImageTaskLabel(String taskType) {
    switch (taskType) {
      case 'image_remove_bg':
        return 'إزالة الخلفية';
      case 'image_enhance':
        return 'تحسين الصورة';
      case 'image_resize':
        return 'تغيير الحجم';
      case 'image_compress':
        return 'ضغط الصورة';
      default:
        return 'معالجة';
    }
  }

  void _showMarketingToolDialog(String taskType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getMarketingTaskTitle(taskType)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'اسم الحملة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'الميزانية (ر.س)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              MbuySnackBar.show(
                context,
                message: 'تم إنشاء الحملة بنجاح',
                type: MbuySnackBarType.success,
              );
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  String _getMarketingTaskTitle(String taskType) {
    switch (taskType) {
      case 'marketing_campaign':
        return 'حملة تسويقية جديدة';
      case 'marketing_email':
        return 'حملة بريد إلكتروني';
      case 'marketing_social':
        return 'حملة سوشيال ميديا';
      default:
        return 'أداة تسويقية';
    }
  }

  void _showStoreToolDialog(String taskType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getStoreTaskTitle(taskType)),
        content: const Text('هل تريد تشغيل هذه الأداة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              MbuySnackBar.show(
                context,
                message: 'تم التنفيذ بنجاح',
                type: MbuySnackBarType.success,
              );
            },
            child: const Text('تشغيل'),
          ),
        ],
      ),
    );
  }

  String _getStoreTaskTitle(String taskType) {
    switch (taskType) {
      case 'store_backup':
        return 'نسخ احتياطي للمتجر';
      case 'store_import':
        return 'استيراد بيانات';
      case 'store_export':
        return 'تصدير بيانات';
      default:
        return 'أداة المتجر';
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
