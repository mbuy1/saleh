import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
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
        ],
      ),
    );
  }

  Future<void> _handleAction(
    Future<Map<String, dynamic>> Function() action,
  ) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await action();
      if (!mounted) return;
      _showResultDialog(result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showResultDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('النتيجة'),
        content: SingleChildScrollView(
          child: Text(const JsonEncoder.withIndent('  ').convert(result)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Future<void> _openTextGenerator() async {
    final promptController = TextEditingController();
    await _openSheet(
      title: 'توليد نص',
      builder: (ctx) => _SheetContent(
        fields: [
          _SheetField(controller: promptController, label: 'النص المطلوب'),
        ],
        onSubmit: () {
          Navigator.pop(ctx);
          _handleAction(
            () => ref
                .read(mbuyStudioServiceProvider)
                .generateText(promptController.text),
          );
        },
      ),
    );
  }

  Future<void> _openImageGenerator() async {
    final prompt = TextEditingController();
    final style = TextEditingController();
    await _openSheet(
      title: 'توليد صورة',
      builder: (ctx) => _SheetContent(
        fields: [
          _SheetField(controller: prompt, label: 'الوصف'),
          _SheetField(controller: style, label: 'الستايل (اختياري)'),
        ],
        onSubmit: () {
          Navigator.pop(ctx);
          _handleAction(
            () => ref
                .read(mbuyStudioServiceProvider)
                .generateImage(
                  prompt.text,
                  style: style.text.isEmpty ? null : style.text,
                ),
          );
        },
      ),
    );
  }

  Future<void> _openBannerGenerator() async {
    final prompt = TextEditingController();
    final placement = TextEditingController();
    await _openSheet(
      title: 'توليد بانر',
      builder: (ctx) => _SheetContent(
        fields: [
          _SheetField(controller: prompt, label: 'الوصف'),
          _SheetField(controller: placement, label: 'الموضع (اختياري)'),
        ],
        onSubmit: () {
          Navigator.pop(ctx);
          _handleAction(
            () => ref
                .read(mbuyStudioServiceProvider)
                .generateBanner(
                  prompt.text,
                  placement: placement.text.isEmpty ? null : placement.text,
                  sizePreset: 'square',
                ),
          );
        },
      ),
    );
  }

  Future<void> _openVideoGenerator() async {
    final prompt = TextEditingController();
    await _openSheet(
      title: 'توليد فيديو',
      builder: (ctx) => _SheetContent(
        fields: [_SheetField(controller: prompt, label: 'الوصف')],
        onSubmit: () {
          Navigator.pop(ctx);
          _handleAction(
            () =>
                ref.read(mbuyStudioServiceProvider).generateVideo(prompt.text),
          );
        },
      ),
    );
  }

  Future<void> _openAudioGenerator() async {
    final text = TextEditingController();
    await _openSheet(
      title: 'توليد صوت',
      builder: (ctx) => _SheetContent(
        fields: [_SheetField(controller: text, label: 'النص')],
        onSubmit: () {
          Navigator.pop(ctx);
          _handleAction(
            () => ref.read(mbuyStudioServiceProvider).generateAudio(text.text),
          );
        },
      ),
    );
  }

  Future<void> _openDescriptionGenerator() async {
    final prompt = TextEditingController();
    final tone = TextEditingController(text: 'friendly');
    await _openSheet(
      title: 'وصف منتج',
      builder: (ctx) => _SheetContent(
        fields: [
          _SheetField(controller: prompt, label: 'الوصف المطلوب'),
          _SheetField(controller: tone, label: 'النبرة'),
        ],
        onSubmit: () {
          Navigator.pop(ctx);
          _handleAction(
            () => ref
                .read(mbuyStudioServiceProvider)
                .generateProductDescription(
                  prompt: prompt.text,
                  tone: tone.text,
                ),
          );
        },
      ),
    );
  }

  Future<void> _openKeywordsGenerator() async {
    final prompt = TextEditingController();
    await _openSheet(
      title: 'كلمات مفتاحية',
      builder: (ctx) => _SheetContent(
        fields: [_SheetField(controller: prompt, label: 'الوصف')],
        onSubmit: () {
          Navigator.pop(ctx);
          _handleAction(
            () => ref
                .read(mbuyStudioServiceProvider)
                .generateKeywords(prompt: prompt.text),
          );
        },
      ),
    );
  }

  Future<void> _openLogoGenerator() async {
    final brand = TextEditingController();
    final style = TextEditingController();
    final colors = TextEditingController();
    await _openSheet(
      title: 'لوقو',
      builder: (ctx) => _SheetContent(
        fields: [
          _SheetField(controller: brand, label: 'اسم البراند'),
          _SheetField(controller: style, label: 'ستايل (اختياري)'),
          _SheetField(controller: colors, label: 'الألوان (اختياري)'),
        ],
        onSubmit: () {
          Navigator.pop(ctx);
          _handleAction(
            () => ref
                .read(mbuyStudioServiceProvider)
                .generateLogo(
                  brandName: brand.text,
                  style: style.text.isEmpty ? null : style.text,
                  colors: colors.text.isEmpty ? null : colors.text,
                ),
          );
        },
      ),
    );
  }

  Future<void> _openLibrary() async {
    await _handleAction(
      () => ref.read(mbuyStudioServiceProvider).getLibrary('all'),
    );
  }

  Future<void> _openSheet({
    required String title,
    required WidgetBuilder builder,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: Row(
                  children: [
                    Text(title, style: Theme.of(ctx).textTheme.titleMedium),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              builder(ctx),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiCard {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String subtitle;
  final Color color;

  _AiCard(this.title, this.icon, this.onTap, this.subtitle, this.color);
}

class _SheetField {
  final TextEditingController controller;
  final String label;

  _SheetField({required this.controller, required this.label});
}

class _SheetContent extends StatelessWidget {
  final List<_SheetField> fields;
  final VoidCallback onSubmit;

  const _SheetContent({required this.fields, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...fields.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacing16),
              child: TextField(
                controller: f.controller,
                decoration: InputDecoration(
                  labelText: f.label,
                  border: const OutlineInputBorder(),
                ),
                maxLines: f.label.contains('وصف') ? 3 : 1,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onSubmit,
              child: const Text('توليد'),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
        ],
      ),
    );
  }
}
