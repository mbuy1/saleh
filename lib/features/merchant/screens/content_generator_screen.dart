import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class ContentGeneratorScreen extends StatefulWidget {
  const ContentGeneratorScreen({super.key});

  @override
  State<ContentGeneratorScreen> createState() => _ContentGeneratorScreenState();
}

class _ContentGeneratorScreenState extends State<ContentGeneratorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  bool _isLoading = true;
  bool _isGenerating = false;
  String? _error;

  List<Map<String, dynamic>> _templates = [];
  List<Map<String, dynamic>> _library = [];
  List<Map<String, dynamic>> _history = [];

  // Generated content
  String? _generatedContent;
  List<String> _variations = [];

  // Form
  Map<String, dynamic>? _selectedTemplate;
  final Map<String, TextEditingController> _inputControllers = {};
  String _selectedPlatform = 'instagram';
  final String _selectedType = 'social_post';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in _inputControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _api.get('/secure/content/templates'),
        _api.get('/secure/content/library'),
        _api.get('/secure/content/history'),
      ]);

      if (!mounted) return;

      setState(() {
        _templates = List<Map<String, dynamic>>.from(
          jsonDecode(results[0].body)['data'] ?? [],
        );
        _library = List<Map<String, dynamic>>.from(
          jsonDecode(results[1].body)['data'] ?? [],
        );
        _history = List<Map<String, dynamic>>.from(
          jsonDecode(results[2].body)['data'] ?? [],
        );
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

  Future<void> _generateContent() async {
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('اختر قالباً أولاً')));
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final inputData = <String, String>{};
      _inputControllers.forEach((key, controller) {
        inputData[key] = controller.text;
      });

      final response = await _api.post(
        '/secure/content/generate',
        body: {
          'template_id': _selectedTemplate!['id'],
          'content_type': _selectedType,
          'platform': _selectedPlatform,
          'input_data': inputData,
        },
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      if (data['ok'] == true) {
        setState(() {
          _generatedContent = data['data']['content'];
          _variations = List<String>.from(data['data']['variations'] ?? []);
          _isGenerating = false;
        });
      } else {
        throw Exception(data['error']);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل إنشاء المحتوى: $e')));
    }
  }

  Future<void> _saveToLibrary() async {
    if (_generatedContent == null) return;

    try {
      await _api.post(
        '/secure/content/library',
        body: {
          'title': _selectedTemplate?['name'] ?? 'محتوى جديد',
          'content': _generatedContent,
          'content_type': _selectedType,
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم الحفظ في المكتبة')));
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل الحفظ: $e')));
    }
  }

  void _selectTemplate(Map<String, dynamic> template) {
    setState(() {
      _selectedTemplate = template;
      _generatedContent = null;
      _variations = [];

      // Clear old controllers
      for (final c in _inputControllers.values) {
        c.dispose();
      }
      _inputControllers.clear();

      // Create controllers for variables
      final variables = List<String>.from(template['variables'] ?? []);
      for (var v in variables) {
        _inputControllers[v] = TextEditingController();
      }
    });
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
        title: const Text('محتوى تسويقي'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'إنشاء', icon: Icon(Icons.auto_awesome)),
            Tab(text: 'المكتبة', icon: Icon(Icons.folder)),
            Tab(text: 'السجل', icon: Icon(Icons.history)),
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
                _buildGenerateTab(),
                _buildLibraryTab(),
                _buildHistoryTab(),
              ],
            ),
    );
  }

  Widget _buildGenerateTab() {
    return SingleChildScrollView(
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform selector
          const Text('المنصة', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimensions.spacing8),
          Wrap(
            spacing: 8,
            children: [
              _buildPlatformChip('instagram', 'انستقرام', Icons.camera_alt),
              _buildPlatformChip('twitter', 'تويتر', Icons.tag),
              _buildPlatformChip('facebook', 'فيسبوك', Icons.facebook),
              _buildPlatformChip('email', 'بريد', Icons.email),
              _buildPlatformChip('sms', 'SMS', Icons.sms),
            ],
          ),

          const SizedBox(height: 24),

          // Templates
          const Text(
            'اختر قالباً',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final template = _templates[index];
                final isSelected = _selectedTemplate?['id'] == template['id'];
                return _buildTemplateCard(template, isSelected);
              },
            ),
          ),

          // Input fields
          if (_selectedTemplate != null) ...[
            const SizedBox(height: 24),
            const Text(
              'أدخل البيانات',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            ..._inputControllers.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: _getVariableLabel(entry.key),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: entry.key.contains('description') ? 3 : 1,
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spacing16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateContent,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isGenerating ? 'جاري الإنشاء...' : 'إنشاء المحتوى',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],

          // Generated content
          if (_generatedContent != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: AppDimensions.paddingM,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: AppDimensions.spacing8),
                        const Text(
                          'المحتوى المُنشأ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم النسخ')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_add),
                          onPressed: _saveToLibrary,
                        ),
                      ],
                    ),
                    const Divider(),
                    SelectableText(
                      _generatedContent!,
                      style: TextStyle(
                        fontSize: AppDimensions.fontTitle,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Variations
            if (_variations.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacing16),
              const Text(
                'نسخ بديلة',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              ..._variations.map(
                (v) => Card(
                  margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
                  child: ListTile(
                    title: Text(
                      v,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم النسخ')),
                        );
                      },
                    ),
                    onTap: () {
                      setState(() => _generatedContent = v);
                    },
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildPlatformChip(String value, String label, IconData icon) {
    final isSelected = _selectedPlatform == value;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconXS,
            color: isSelected ? Colors.white : Colors.grey,
          ),
          SizedBox(width: AppDimensions.spacing4),
          Text(label),
        ],
      ),
      selectedColor: AppTheme.primaryColor,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      onSelected: (selected) {
        setState(() => _selectedPlatform = value);
      },
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectTemplate(template),
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        padding: AppDimensions.paddingS,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _getTemplateIcon(template['template_type']),
              color: isSelected ? Colors.white : AppTheme.primaryColor,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              template['name'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              '${template['usage_count'] ?? 0} استخدام',
              style: TextStyle(
                fontSize: AppDimensions.fontCaption,
                color: isSelected ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryTab() {
    if (_library.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey),
            SizedBox(height: AppDimensions.spacing16),
            Text('المكتبة فارغة'),
            SizedBox(height: AppDimensions.spacing8),
            Text(
              'احفظ المحتوى المُنشأ هنا',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: _library.length,
      itemBuilder: (context, index) {
        final item = _library[index];
        return Card(
          margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withAlpha(25),
              child: Icon(
                _getTemplateIcon(item['content_type']),
                color: AppTheme.primaryColor,
              ),
            ),
            title: Text(item['title'] ?? 'بدون عنوان'),
            subtitle: Text(
              item['content'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'copy') {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('تم النسخ')));
                } else if (value == 'delete') {
                  await _api.delete('/secure/content/library/${item['id']}');
                  _loadData();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'copy', child: Text('نسخ')),
                const PopupMenuItem(value: 'delete', child: Text('حذف')),
              ],
            ),
            onTap: () => _showContentDialog(item),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    if (_history.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: AppDimensions.spacing16),
            Text('لا يوجد سجل'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppDimensions.paddingM,
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        return Card(
          margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Text('${index + 1}'),
            ),
            title: Text(
              item['generated_text'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              item['content_type'] ?? '',
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () => _showContentDialog(item),
          ),
        );
      },
    );
  }

  void _showContentDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item['title'] ?? 'المحتوى'),
        content: SingleChildScrollView(
          child: SelectableText(
            item['content'] ?? item['generated_text'] ?? '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم النسخ')));
            },
            child: const Text('نسخ'),
          ),
        ],
      ),
    );
  }

  IconData _getTemplateIcon(String? type) {
    switch (type) {
      case 'social_post':
        return Icons.share;
      case 'ad_copy':
        return Icons.campaign;
      case 'email':
        return Icons.email;
      case 'product_desc':
        return Icons.description;
      case 'sms':
        return Icons.sms;
      default:
        return Icons.article;
    }
  }

  String _getVariableLabel(String variable) {
    final labels = {
      'product_name': 'اسم المنتج',
      'product_description': 'وصف المنتج',
      'price': 'السعر',
      'old_price': 'السعر القديم',
      'new_price': 'السعر الجديد',
      'discount': 'نسبة الخصم',
      'short_description': 'وصف قصير',
      'link': 'الرابط',
      'headline': 'العنوان',
      'description': 'الوصف',
      'call_to_action': 'نص الدعوة للإجراء',
      'customer_name': 'اسم العميل',
      'store_name': 'اسم المتجر',
      'coupon_code': 'كود الخصم',
      'coupon': 'الكوبون',
      'hashtags': 'الهاشتاقات',
    };
    return labels[variable] ?? variable;
  }
}
