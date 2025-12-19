import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/auth_controller.dart';
import '../../data/mbuy_studio_service.dart';

/// شاشة أدوات AI - تصميم محسن
/// تعرض جميع أدوات الذكاء الاصطناعي المتاحة للتاجر
class AiStudioCardsScreen extends ConsumerStatefulWidget {
  const AiStudioCardsScreen({super.key});

  @override
  ConsumerState<AiStudioCardsScreen> createState() =>
      _AiStudioCardsScreenState();
}

class _AiStudioCardsScreenState extends ConsumerState<AiStudioCardsScreen> {
  // ignore: prefer_final_fields
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _AiCard(
        'توليد نص',
        Icons.text_fields_rounded,
        _openTextGenerator,
        'إنشاء نصوص احترافية',
        const Color(0xFF3B82F6),
      ),
      _AiCard(
        'توليد صورة',
        Icons.image_rounded,
        _openImageGenerator,
        'صور عالية الجودة',
        const Color(0xFF10B981),
      ),
      _AiCard(
        'توليد بانر',
        Icons.photo_size_select_large_rounded,
        _openBannerGenerator,
        'بانرات إعلانية جذابة',
        const Color(0xFFF59E0B),
      ),
      _AiCard(
        'توليد فيديو',
        Icons.movie_rounded,
        _openVideoGenerator,
        'فيديوهات تسويقية',
        const Color(0xFFEF4444),
      ),
      _AiCard(
        'توليد صوت',
        Icons.mic_rounded,
        _openAudioGenerator,
        'تعليق صوتي احترافي',
        const Color(0xFF8B5CF6),
      ),
      _AiCard(
        'وصف منتج',
        Icons.description_rounded,
        _openDescriptionGenerator,
        'أوصاف جذابة للمنتجات',
        const Color(0xFF06B6D4),
      ),
      _AiCard(
        'كلمات مفتاحية',
        Icons.sell_rounded,
        _openKeywordsGenerator,
        'تحسين SEO',
        const Color(0xFFEC4899),
      ),
      _AiCard(
        'لوقو',
        Icons.brush_rounded,
        _openLogoGenerator,
        'شعارات مميزة',
        const Color(0xFFF97316),
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            if (_loading)
              LinearProgressIndicator(
                color: AppTheme.accentColor,
                backgroundColor: AppTheme.dividerColor,
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: _buildErrorBanner(_error!),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قسم المفضلة
                    _buildSectionHeader('الأدوات المميزة', Icons.star_rounded),
                    const SizedBox(height: AppDimensions.spacing12),
                    _buildFeaturedRow(cards.take(3).toList()),
                    const SizedBox(height: AppDimensions.spacing24),
                    // جميع الأدوات
                    _buildSectionHeader('جميع الأدوات', Icons.apps_rounded),
                    const SizedBox(height: AppDimensions.spacing12),
                    _buildToolsGrid(cards),
                    const SizedBox(height: AppDimensions.spacing24),
                    // إحصائيات الاستخدام
                    _buildUsageStats(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'استوديو AI',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: _openLibrary,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                size: 20,
                color: AppTheme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: AppDimensions.fontTitle,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedRow(List<_AiCard> cards) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimensions.spacing12),
        itemBuilder: (context, index) {
          final card = cards[index];
          return _buildFeaturedCard(card);
        },
      ),
    );
  }

  Widget _buildFeaturedCard(_AiCard card) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        card.onTap();
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [card.color, card.color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppDimensions.borderRadiusL,
          boxShadow: [
            BoxShadow(
              color: card.color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(card.icon, color: Colors.white, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  card.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolsGrid(List<_AiCard> cards) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppDimensions.spacing12,
      crossAxisSpacing: AppDimensions.spacing12,
      childAspectRatio: 1.3,
      children: cards.map((c) => _buildToolCard(c)).toList(),
    );
  }

  Widget _buildToolCard(_AiCard card) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        card.onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.borderRadiusL,
          border: Border.all(color: AppTheme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: card.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(card.icon, color: card.color, size: 20),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'AI',
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              card.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              card.subtitle,
              style: TextStyle(fontSize: 11, color: AppTheme.textHintColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageStats() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  '0',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  'عمليات اليوم',
                  style: TextStyle(fontSize: 12, color: AppTheme.textHintColor),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: AppTheme.dividerColor),
          Expanded(
            child: Column(
              children: [
                const Text(
                  '50',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
                Text(
                  'المتبقي',
                  style: TextStyle(fontSize: 12, color: AppTheme.textHintColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.red)),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 18),
            onPressed: () => setState(() => _error = null),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // توليد النص
  // ==========================================
  Future<void> _openTextGenerator() async {
    _openSheet(
      title: 'توليد نص',
      icon: Icons.text_fields_rounded,
      color: const Color(0xFF3B82F6),
      fields: [_SheetField('prompt', 'اكتب وصفاً للنص المطلوب', maxLines: 3)],
      onGenerate: (values) async {
        final service = ref.read(mbuyStudioServiceProvider);
        final result = await service.generateText(values['prompt']!);
        return result;
      },
      resultBuilder: (result) {
        final text = result['text'] ?? result['data']?['text'] ?? '';
        return _TextResultWidget(text: text);
      },
    );
  }

  // ==========================================
  // توليد صورة
  // ==========================================
  Future<void> _openImageGenerator() async {
    _openSheet(
      title: 'توليد صورة',
      icon: Icons.image_rounded,
      color: const Color(0xFF10B981),
      fields: [
        _SheetField('prompt', 'وصف الصورة المطلوبة', maxLines: 2),
        _SheetField(
          'style',
          'النمط (اختياري)',
          hint: 'مثال: realistic, cartoon',
        ),
      ],
      onGenerate: (values) async {
        final service = ref.read(mbuyStudioServiceProvider);
        final result = await service.generateImage(
          values['prompt']!,
          style: values['style'],
        );
        return result;
      },
      resultBuilder: (result) {
        final imageUrl = result['image_url'] ?? result['data']?['image_url'];
        return _ImageResultWidget(imageUrl: imageUrl);
      },
    );
  }

  // ==========================================
  // توليد بانر
  // ==========================================
  Future<void> _openBannerGenerator() async {
    _openSheet(
      title: 'توليد بانر',
      icon: Icons.photo_size_select_large_rounded,
      color: const Color(0xFFF59E0B),
      fields: [
        _SheetField('prompt', 'وصف البانر', maxLines: 2),
        _SheetField(
          'sizePreset',
          'الحجم',
          hint: 'square, story, landscape',
          initialValue: 'square',
        ),
      ],
      onGenerate: (values) async {
        final service = ref.read(mbuyStudioServiceProvider);
        final result = await service.generateBanner(
          values['prompt']!,
          sizePreset: values['sizePreset'],
        );
        return result;
      },
      resultBuilder: (result) {
        final bannerUrl = result['banner_url'] ?? result['data']?['banner_url'];
        return _ImageResultWidget(imageUrl: bannerUrl);
      },
    );
  }

  // ==========================================
  // توليد فيديو
  // ==========================================
  Future<void> _openVideoGenerator() async {
    _openSheet(
      title: 'توليد فيديو',
      icon: Icons.movie_rounded,
      color: const Color(0xFFEF4444),
      fields: [
        _SheetField('prompt', 'وصف الفيديو', maxLines: 2),
        _SheetField('duration', 'المدة (ثواني)', hint: '5', initialValue: '5'),
      ],
      onGenerate: (values) async {
        final service = ref.read(mbuyStudioServiceProvider);
        final result = await service.generateVideo(
          values['prompt']!,
          duration: int.tryParse(values['duration'] ?? '5') ?? 5,
        );
        return result;
      },
      resultBuilder: (result) {
        final status = result['status'] ?? 'processing';
        final message = result['message'] ?? '';
        if (status == 'failed') {
          return _StatusResultWidget(
            status: status,
            message: message.isNotEmpty ? message : 'فشل في توليد الفيديو',
            icon: Icons.error_outline,
          );
        }
        return _StatusResultWidget(
          status: status,
          message: 'جاري معالجة الفيديو...',
          icon: Icons.hourglass_empty,
        );
      },
    );
  }

  // ==========================================
  // توليد صوت
  // ==========================================
  Future<void> _openAudioGenerator() async {
    _openSheet(
      title: 'توليد صوت',
      icon: Icons.mic_rounded,
      color: const Color(0xFF8B5CF6),
      fields: [
        _SheetField('text', 'النص المراد تحويله لصوت', maxLines: 3),
        _SheetField('voice', 'نوع الصوت', hint: 'default'),
      ],
      onGenerate: (values) async {
        final service = ref.read(mbuyStudioServiceProvider);
        final result = await service.generateAudio(
          values['text']!,
          voice: values['voice'],
        );
        return result;
      },
      resultBuilder: (result) {
        final audioUrl = result['resultUrl'] ?? result['data']?['resultUrl'];
        if (audioUrl != null) {
          return _AudioResultWidget(audioUrl: audioUrl);
        }
        return const _StatusResultWidget(
          status: 'processing',
          message: 'خدمة الصوت غير متاحة حالياً',
          icon: Icons.mic_off,
        );
      },
    );
  }

  // ==========================================
  // وصف منتج
  // ==========================================
  Future<void> _openDescriptionGenerator() async {
    _openSheet(
      title: 'وصف منتج',
      icon: Icons.description_rounded,
      color: const Color(0xFF06B6D4),
      fields: [
        _SheetField('prompt', 'اسم المنتج أو وصفه', maxLines: 2),
        _SheetField(
          'tone',
          'النبرة',
          hint: 'friendly, professional',
          initialValue: 'friendly',
        ),
        _SheetField('language', 'اللغة', hint: 'ar, en', initialValue: 'ar'),
      ],
      onGenerate: (values) async {
        final service = ref.read(mbuyStudioServiceProvider);
        final result = await service.generateProductDescription(
          prompt: values['prompt']!,
          tone: values['tone'],
          language: values['language'],
        );
        return result;
      },
      resultBuilder: (result) {
        final content = result['content'] ?? result['data']?['content'] ?? '';
        return _TextResultWidget(text: content);
      },
    );
  }

  // ==========================================
  // كلمات مفتاحية
  // ==========================================
  Future<void> _openKeywordsGenerator() async {
    _openSheet(
      title: 'كلمات مفتاحية',
      icon: Icons.sell_rounded,
      color: const Color(0xFFEC4899),
      fields: [
        _SheetField('prompt', 'وصف المنتج أو الخدمة', maxLines: 2),
        _SheetField('language', 'اللغة', hint: 'ar, en', initialValue: 'ar'),
      ],
      onGenerate: (values) async {
        final service = ref.read(mbuyStudioServiceProvider);
        final result = await service.generateKeywords(
          prompt: values['prompt']!,
          language: values['language'],
        );
        return result;
      },
      resultBuilder: (result) {
        final keywords =
            result['keywords'] ?? result['data']?['keywords'] ?? [];
        return _KeywordsResultWidget(keywords: List<String>.from(keywords));
      },
    );
  }

  // ==========================================
  // لوقو
  // ==========================================
  Future<void> _openLogoGenerator() async {
    _openSheet(
      title: 'توليد لوقو',
      icon: Icons.brush_rounded,
      color: const Color(0xFFF97316),
      fields: [
        _SheetField('brand_name', 'اسم العلامة التجارية'),
        _SheetField('style', 'النمط', hint: 'minimal, modern, classic'),
        _SheetField('colors', 'الألوان', hint: 'blue, gold'),
        _SheetField('prompt', 'وصف إضافي (اختياري)', maxLines: 2),
      ],
      onGenerate: (values) async {
        final service = ref.read(mbuyStudioServiceProvider);
        final result = await service.generateLogo(
          brandName: values['brand_name']!,
          style: values['style'],
          colors: values['colors'],
          prompt: values['prompt'],
        );
        return result;
      },
      resultBuilder: (result) {
        final logoUrl = result['logo_url'] ?? result['data']?['logo_url'];
        final options = result['options'] ?? result['data']?['options'] ?? [];
        if (options is List && options.isNotEmpty) {
          return _LogoOptionsWidget(options: List<String>.from(options));
        }
        return _ImageResultWidget(imageUrl: logoUrl);
      },
    );
  }

  // ==========================================
  // المكتبة
  // ==========================================
  Future<void> _openLibrary() async {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LibrarySheet(ref: ref),
    );
  }

  // ==========================================
  // Sheet Builder
  // ==========================================
  void _openSheet({
    required String title,
    required IconData icon,
    required Color color,
    required List<_SheetField> fields,
    required Future<Map<String, dynamic>> Function(Map<String, String>)
    onGenerate,
    required Widget Function(Map<String, dynamic>) resultBuilder,
  }) {
    // التحقق من حالة التسجيل
    final authState = ref.read(authControllerProvider);
    if (!authState.isAuthenticated) {
      _showLoginRequiredDialog();
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _GeneratorSheet(
        title: title,
        icon: icon,
        color: color,
        fields: fields,
        onGenerate: onGenerate,
        resultBuilder: resultBuilder,
      ),
    );
  }

  void _showLoginRequiredDialog() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.login_rounded,
                size: 48,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'تسجيل الدخول مطلوب',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'يرجى تسجيل الدخول أولاً\nلاستخدام أدوات الذكاء الاصطناعي',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// Helper Classes
// ==========================================

class _AiCard {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String subtitle;
  final Color color;

  _AiCard(this.title, this.icon, this.onTap, this.subtitle, this.color);
}

class _SheetField {
  final String key;
  final String label;
  final String? hint;
  final String? initialValue;
  final int maxLines;

  _SheetField(
    this.key,
    this.label, {
    this.hint,
    this.initialValue,
    this.maxLines = 1,
  });
}

// ==========================================
// Generator Sheet
// ==========================================

class _GeneratorSheet extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_SheetField> fields;
  final Future<Map<String, dynamic>> Function(Map<String, String>) onGenerate;
  final Widget Function(Map<String, dynamic>) resultBuilder;

  const _GeneratorSheet({
    required this.title,
    required this.icon,
    required this.color,
    required this.fields,
    required this.onGenerate,
    required this.resultBuilder,
  });

  @override
  State<_GeneratorSheet> createState() => _GeneratorSheetState();
}

class _GeneratorSheetState extends State<_GeneratorSheet> {
  final Map<String, TextEditingController> _controllers = {};
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    for (final field in widget.fields) {
      _controllers[field.key] = TextEditingController(
        text: field.initialValue ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _generate() async {
    // التحقق من الحقول المطلوبة
    final values = <String, String>{};
    for (final field in widget.fields) {
      final value = _controllers[field.key]?.text.trim() ?? '';
      if (value.isEmpty && field.key == widget.fields.first.key) {
        setState(() => _error = 'يرجى ملء الحقل الأول على الأقل');
        return;
      }
      if (value.isNotEmpty) {
        values[field.key] = value;
      }
    }

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await widget.onGenerate(values);
      setState(() {
        _result = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Fields
                  ...widget.fields.map(
                    (field) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: _controllers[field.key],
                        maxLines: field.maxLines,
                        decoration: InputDecoration(
                          labelText: field.label,
                          hintText: field.hint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ),
                  ),
                  // Error
                  if (_error != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Generate Button
                  ElevatedButton(
                    onPressed: _loading ? null : _generate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'توليد',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  // Result
                  if (_result != null) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'النتيجة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    widget.resultBuilder(_result!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// Result Widgets
// ==========================================

class _TextResultWidget extends StatelessWidget {
  final String text;

  const _TextResultWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(
            text,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم نسخ النص')));
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('نسخ'),
          ),
        ],
      ),
    );
  }
}

class _ImageResultWidget extends StatelessWidget {
  final String? imageUrl;

  const _ImageResultWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('لم يتم توليد صورة', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: Colors.grey[100],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[100],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: imageUrl!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ رابط الصورة')),
                  );
                },
                icon: const Icon(Icons.link, size: 18),
                label: const Text('نسخ الرابط'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KeywordsResultWidget extends StatelessWidget {
  final List<String> keywords;

  const _KeywordsResultWidget({required this.keywords});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords
                .map(
                  (kw) => Chip(
                    label: Text(kw),
                    backgroundColor: AppTheme.accentColor.withValues(
                      alpha: 0.1,
                    ),
                    labelStyle: const TextStyle(color: AppTheme.accentColor),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: keywords.join(', ')));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ الكلمات المفتاحية')),
              );
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('نسخ الكل'),
          ),
        ],
      ),
    );
  }
}

class _StatusResultWidget extends StatelessWidget {
  final String status;
  final String message;
  final IconData icon;

  const _StatusResultWidget({
    required this.status,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = status == 'failed' ? Colors.red : Colors.orange;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _AudioResultWidget extends StatelessWidget {
  final String audioUrl;

  const _AudioResultWidget({required this.audioUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.audiotrack, size: 48, color: Colors.purple),
          const SizedBox(height: 12),
          const Text('تم توليد الصوت بنجاح'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: audioUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ رابط الصوت')),
              );
            },
            icon: const Icon(Icons.link, size: 18),
            label: const Text('نسخ الرابط'),
          ),
        ],
      ),
    );
  }
}

class _LogoOptionsWidget extends StatelessWidget {
  final List<String> options;

  const _LogoOptionsWidget({required this.options});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'اختر من الخيارات المتاحة:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: options[index]));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم نسخ رابط اللوقو')),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  options[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ==========================================
// Library Sheet
// ==========================================

class _LibrarySheet extends StatefulWidget {
  final WidgetRef ref;

  const _LibrarySheet({required this.ref});

  @override
  State<_LibrarySheet> createState() => _LibrarySheetState();
}

class _LibrarySheetState extends State<_LibrarySheet> {
  bool _loading = true;
  List<dynamic> _items = [];
  String? _error;
  String _selectedType = 'all';

  final _types = {
    'all': 'الكل',
    'image': 'صور',
    'banner': 'بانرات',
    'logo': 'لوقوهات',
    'video': 'فيديوهات',
    'audio': 'صوتيات',
  };

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final service = widget.ref.read(mbuyStudioServiceProvider);
      final result = await service.getLibrary(_selectedType);
      setState(() {
        _items = result['data'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: AppTheme.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'المكتبة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _types.entries.map((entry) {
                final isSelected = _selectedType == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FilterChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedType = entry.key);
                      _loadLibrary();
                    },
                    selectedColor: AppTheme.accentColor.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.accentColor,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          // Content
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadLibrary,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                : _items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'لا توجد عناصر بعد',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ابدأ بتوليد محتوى جديد',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final url =
                          item['image_url'] ??
                          item['banner_url'] ??
                          item['logo_url'] ??
                          item['thumbnail_url'];
                      final source = item['source'] ?? '';

                      return GestureDetector(
                        onTap: () {
                          if (url != null) {
                            Clipboard.setData(ClipboardData(text: url));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم نسخ الرابط')),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(11),
                                  ),
                                  child: url != null
                                      ? Image.network(
                                          url,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[100],
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          color: Colors.grey[100],
                                          child: Icon(
                                            _getIconForSource(source),
                                            color: Colors.grey,
                                            size: 32,
                                          ),
                                        ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  _getLabelForSource(source),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForSource(String source) {
    switch (source) {
      case 'ai_images':
        return Icons.image;
      case 'ai_banners':
        return Icons.photo_size_select_large;
      case 'ai_logos':
        return Icons.brush;
      case 'ai_videos':
        return Icons.movie;
      case 'ai_audios':
        return Icons.audiotrack;
      default:
        return Icons.file_present;
    }
  }

  String _getLabelForSource(String source) {
    switch (source) {
      case 'ai_images':
        return 'صورة';
      case 'ai_banners':
        return 'بانر';
      case 'ai_logos':
        return 'لوقو';
      case 'ai_videos':
        return 'فيديو';
      case 'ai_audios':
        return 'صوت';
      default:
        return 'ملف';
    }
  }
}
