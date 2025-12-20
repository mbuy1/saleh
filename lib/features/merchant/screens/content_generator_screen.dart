import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  String _selectedTone = 'professional';
  final String _selectedType = 'social_post';

  // Platform configurations
  static const Map<String, Map<String, dynamic>> _platformsConfig = {
    'instagram': {
      'name': 'انستقرام',
      'icon': Icons.camera_alt,
      'color': Color(0xFFE1306C),
      'maxLength': 2200,
    },
    'twitter': {
      'name': 'تويتر / X',
      'icon': Icons.close,
      'color': Color(0xFF1DA1F2),
      'maxLength': 280,
    },
    'facebook': {
      'name': 'فيسبوك',
      'icon': Icons.facebook,
      'color': Color(0xFF4267B2),
      'maxLength': 5000,
    },
    'tiktok': {
      'name': 'تيك توك',
      'icon': Icons.music_note,
      'color': Color(0xFF000000),
      'maxLength': 2200,
    },
    'snapchat': {
      'name': 'سناب شات',
      'icon': Icons.snapchat,
      'color': Color(0xFFFFFC00),
      'maxLength': 250,
    },
    'email': {
      'name': 'البريد',
      'icon': Icons.email,
      'color': Color(0xFF34A853),
      'maxLength': 10000,
    },
    'sms': {
      'name': 'رسالة قصيرة',
      'icon': Icons.sms,
      'color': Color(0xFF9C27B0),
      'maxLength': 160,
    },
    'whatsapp': {
      'name': 'واتساب',
      'icon': Icons.chat,
      'color': Color(0xFF25D366),
      'maxLength': 4096,
    },
  };

  // Tone options
  static const Map<String, Map<String, dynamic>> _tones = {
    'professional': {'name': 'احترافي', 'icon': Icons.business},
    'friendly': {'name': 'ودي', 'icon': Icons.emoji_emotions},
    'urgent': {'name': 'عاجل', 'icon': Icons.timer},
    'creative': {'name': 'إبداعي', 'icon': Icons.lightbulb},
    'formal': {'name': 'رسمي', 'icon': Icons.format_quote},
  };

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('اختر قالباً أولاً'),
            ],
          ),
          backgroundColor: AppTheme.warningColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
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
          'tone': _selectedTone,
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
        HapticFeedback.mediumImpact();
      } else {
        throw Exception(data['error']);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل إنشاء المحتوى: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
          'platform': _selectedPlatform,
        },
      );

      if (!mounted) return;
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('تم الحفظ في المكتبة'),
            ],
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل الحفظ: $e')));
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('تم نسخ المحتوى'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
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
          onPressed: () => context.pop(),
        ),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, size: 24),
            SizedBox(width: 8),
            Text('محتوى تسويقي'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'إنشاء', icon: Icon(Icons.auto_awesome, size: 20)),
            Tab(text: 'المكتبة', icon: Icon(Icons.folder_special, size: 20)),
            Tab(text: 'السجل', icon: Icon(Icons.history, size: 20)),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
          ? _buildErrorState()
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'جاري تحميل القوالب...',
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'حدث خطأ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: AppTheme.textSecondaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Card
          _buildQuickStatsCard(),
          const SizedBox(height: 20),

          // Platform selector
          _buildSectionHeader('اختر المنصة', Icons.devices),
          const SizedBox(height: 12),
          _buildPlatformSelector(),
          const SizedBox(height: 24),

          // Tone selector
          _buildSectionHeader('نبرة المحتوى', Icons.record_voice_over),
          const SizedBox(height: 12),
          _buildToneSelector(),
          const SizedBox(height: 24),

          // Templates
          _buildSectionHeader('اختر قالباً', Icons.dashboard_customize),
          const SizedBox(height: 12),
          _buildTemplatesGrid(),

          // Input fields
          if (_selectedTemplate != null) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('أدخل البيانات', Icons.edit_note),
            const SizedBox(height: 12),
            _buildInputFields(),
            const SizedBox(height: 20),
            _buildGenerateButton(),
          ],

          // Generated content
          if (_generatedContent != null) ...[
            const SizedBox(height: 24),
            _buildGeneratedContentCard(),

            // Variations
            if (_variations.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildVariationsSection(),
            ],
          ],

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مولد المحتوى الذكي',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_templates.length} قالب • ${_library.length} محفوظ',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: AppTheme.primaryColor, size: 16),
                SizedBox(width: 4),
                Text(
                  'AI',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPlatformSelector() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _platformsConfig.length,
        itemBuilder: (context, index) {
          final entry = _platformsConfig.entries.elementAt(index);
          final platform = entry.value;
          final isSelected = _selectedPlatform == entry.key;

          return GestureDetector(
            onTap: () => setState(() => _selectedPlatform = entry.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (platform['color'] as Color).withValues(alpha: 0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? platform['color'] as Color
                      : AppTheme.dividerColor,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (platform['color'] as Color).withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    platform['icon'] as IconData,
                    color: isSelected
                        ? platform['color'] as Color
                        : AppTheme.textSecondaryColor,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    platform['name'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? platform['color'] as Color
                          : AppTheme.textSecondaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToneSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _tones.entries.map((entry) {
        final isSelected = _selectedTone == entry.key;
        return FilterChip(
          selected: isSelected,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                entry.value['icon'] as IconData,
                size: 16,
                color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
              ),
              const SizedBox(width: 6),
              Text(entry.value['name'] as String),
            ],
          ),
          selectedColor: AppTheme.primaryColor,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            ),
          ),
          onSelected: (selected) {
            setState(() => _selectedTone = entry.key);
          },
        );
      }).toList(),
    );
  }

  Widget _buildTemplatesGrid() {
    if (_templates.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.dashboard_customize,
              size: 48,
              color: AppTheme.textHintColor,
            ),
            SizedBox(height: 12),
            Text(
              'لا توجد قوالب متاحة',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final template = _templates[index];
        final isSelected = _selectedTemplate?['id'] == template['id'];
        return _buildTemplateCard(template, isSelected);
      },
    );
  }

  Widget _buildInputFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: _inputControllers.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: entry.value,
              decoration: InputDecoration(
                labelText: _getVariableLabel(entry.key),
                hintText: _getVariableHint(entry.key),
                prefixIcon: Icon(
                  _getVariableIcon(entry.key),
                  color: AppTheme.textSecondaryColor,
                ),
                filled: true,
                fillColor: AppTheme.slate100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              maxLines: entry.key.contains('description') ? 3 : 1,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : _generateContent,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppTheme.primaryColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: _isGenerating ? 0 : 2,
        ),
        child: _isGenerating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'جاري توليد المحتوى...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'إنشاء المحتوى',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGeneratedContentCard() {
    final platformInfo = _platformsConfig[_selectedPlatform]!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (platformInfo['color'] as Color).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: platformInfo['color'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    platformInfo['icon'] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المحتوى المُنشأ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'لـ ${platformInfo['name']}',
                      style: TextStyle(
                        color: platformInfo['color'] as Color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.copy,
                  tooltip: 'نسخ',
                  onTap: () => _copyToClipboard(_generatedContent!),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.bookmark_add,
                  tooltip: 'حفظ',
                  onTap: _saveToLibrary,
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  _generatedContent!,
                  style: const TextStyle(fontSize: 15, height: 1.7),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.text_fields,
                      size: 16,
                      color:
                          _generatedContent!.length >
                              (platformInfo['maxLength'] as int)
                          ? Colors.red
                          : AppTheme.textHintColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_generatedContent!.length} / ${platformInfo['maxLength']} حرف',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            _generatedContent!.length >
                                (platformInfo['maxLength'] as int)
                            ? Colors.red
                            : AppTheme.textHintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppTheme.textSecondaryColor),
        ),
      ),
    );
  }

  Widget _buildVariationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('نسخ بديلة', Icons.content_copy),
        const SizedBox(height: 12),
        ...List.generate(_variations.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                _variations[index],
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () => _copyToClipboard(_variations[index]),
                    color: AppTheme.textSecondaryColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, size: 20),
                    onPressed: () {
                      setState(() => _generatedContent = _variations[index]);
                    },
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectTemplate(template),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                  ),
                ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getTemplateIcon(template['template_type']),
                    color: isSelected ? Colors.white : AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppTheme.primaryColor,
                      size: 14,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              template['name'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${template['usage_count'] ?? 0} استخدام',
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : AppTheme.textHintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryTab() {
    if (_library.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.slate100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_open,
                size: 64,
                color: AppTheme.textHintColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'المكتبة فارغة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'احفظ المحتوى المُنشأ هنا للرجوع إليه لاحقاً',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _library.length,
        itemBuilder: (context, index) {
          final item = _library[index];
          return _buildLibraryItem(item);
        },
      ),
    );
  }

  Widget _buildLibraryItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getTemplateIcon(item['content_type']),
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(
          item['title'] ?? 'بدون عنوان',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            item['content'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              height: 1.4,
            ),
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppTheme.textSecondaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) async {
            if (value == 'copy') {
              _copyToClipboard(item['content'] ?? '');
            } else if (value == 'delete') {
              await _api.delete('/secure/content/library/${item['id']}');
              _loadData();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'copy',
              child: Row(
                children: [
                  Icon(Icons.copy, size: 20),
                  SizedBox(width: 12),
                  Text('نسخ'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('حذف', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showContentDialog(item),
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.slate100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history,
                size: 64,
                color: AppTheme.textHintColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا يوجد سجل',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'ستظهر هنا المحتويات التي أنشأتها سابقاً',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return _buildHistoryItem(item, index);
        },
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.slate100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ),
        title: Text(
          item['generated_text'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(height: 1.4),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(
                _getTemplateIcon(item['content_type']),
                size: 14,
                color: AppTheme.textHintColor,
              ),
              const SizedBox(width: 4),
              Text(
                item['content_type'] ?? '',
                style: const TextStyle(
                  color: AppTheme.textHintColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: AppTheme.textHintColor),
              const SizedBox(width: 4),
              Text(
                _formatDate(item['created_at']),
                style: const TextStyle(
                  color: AppTheme.textHintColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 20),
          onPressed: () => _copyToClipboard(item['generated_text'] ?? ''),
          color: AppTheme.textSecondaryColor,
        ),
        onTap: () => _showContentDialog(item),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 60) {
        return 'منذ ${diff.inMinutes} دقيقة';
      } else if (diff.inHours < 24) {
        return 'منذ ${diff.inHours} ساعة';
      } else if (diff.inDays < 7) {
        return 'منذ ${diff.inDays} يوم';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return '';
    }
  }

  void _showContentDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTemplateIcon(item['content_type']),
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['title'] ?? 'المحتوى',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: SelectableText(
            item['content'] ?? item['generated_text'] ?? '',
            style: const TextStyle(height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _copyToClipboard(item['content'] ?? item['generated_text'] ?? '');
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('نسخ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
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

  String _getVariableHint(String variable) {
    final hints = {
      'product_name': 'مثال: ساعة ذكية رياضية',
      'product_description': 'اكتب وصفاً مختصراً للمنتج',
      'price': 'مثال: 299',
      'old_price': 'السعر قبل الخصم',
      'new_price': 'السعر بعد الخصم',
      'discount': 'مثال: 20%',
      'short_description': 'وصف من سطر واحد',
      'link': 'رابط المنتج أو المتجر',
      'headline': 'عنوان جذاب',
      'description': 'وصف تفصيلي',
      'call_to_action': 'مثال: اطلب الآن',
      'customer_name': 'اسم العميل',
      'store_name': 'اسم متجرك',
      'coupon_code': 'مثال: SAVE20',
      'coupon': 'كود الخصم',
      'hashtags': 'مثال: #تسوق #عروض',
    };
    return hints[variable] ?? '';
  }

  IconData _getVariableIcon(String variable) {
    final icons = {
      'product_name': Icons.shopping_bag_outlined,
      'product_description': Icons.description_outlined,
      'price': Icons.attach_money,
      'old_price': Icons.money_off,
      'new_price': Icons.local_offer,
      'discount': Icons.percent,
      'short_description': Icons.short_text,
      'link': Icons.link,
      'headline': Icons.title,
      'description': Icons.notes,
      'call_to_action': Icons.touch_app,
      'customer_name': Icons.person_outline,
      'store_name': Icons.store,
      'coupon_code': Icons.confirmation_number,
      'coupon': Icons.local_activity,
      'hashtags': Icons.tag,
    };
    return icons[variable] ?? Icons.text_fields;
  }
}
