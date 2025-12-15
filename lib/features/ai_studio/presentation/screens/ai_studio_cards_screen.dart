import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/mbuy_studio_service.dart';

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
      _AiCard('توليد نص', Icons.text_fields, _openTextGenerator),
      _AiCard('توليد صورة', Icons.image, _openImageGenerator),
      _AiCard(
        'توليد بانر',
        Icons.photo_size_select_large,
        _openBannerGenerator,
      ),
      _AiCard('توليد فيديو', Icons.movie, _openVideoGenerator),
      _AiCard('توليد صوت', Icons.mic, _openAudioGenerator),
      _AiCard('وصف منتج', Icons.description, _openDescriptionGenerator),
      _AiCard('كلمات مفتاحية', Icons.sell, _openKeywordsGenerator),
      _AiCard('لوقو', Icons.brush, _openLogoGenerator),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('توليد AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books_outlined),
            onPressed: _openLibrary,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Column(
          children: [
            if (_loading) const LinearProgressIndicator(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacing16),
                child: _buildErrorBanner(_error!),
              ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppDimensions.spacing16,
                crossAxisSpacing: AppDimensions.spacing16,
                children: cards
                    .map(
                      (c) => Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: c.onTap,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppDimensions.spacing16,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(c.icon, size: 32),
                                const SizedBox(height: AppDimensions.spacing16),
                                Text(
                                  c.title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
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

  _AiCard(this.title, this.icon, this.onTap);
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
