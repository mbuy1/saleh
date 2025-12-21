import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/studio_tool.dart';
import '../providers/studio_provider.dart';
import '../services/studio_api_service.dart';

/// تبويب إنشاء المحتوى بالذكاء الاصطناعي
class GenerateTab extends ConsumerStatefulWidget {
  const GenerateTab({super.key});

  @override
  ConsumerState<GenerateTab> createState() => _GenerateTabState();
}

class _GenerateTabState extends ConsumerState<GenerateTab> {
  GenerateToolType? _selectedTool;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final generateTools = getDefaultGenerateTools();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer.withOpacity(0.5),
                  colorScheme.secondaryContainer.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إنشاء بالذكاء الاصطناعي',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'أنشئ محتوى احترافي بضغطة زر',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tools Grid
          Text(
            'اختر نوع المحتوى',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: generateTools.length,
            itemBuilder: (context, index) {
              final tool = generateTools[index];
              return _GenerateToolCard(
                tool: tool,
                isSelected: _selectedTool == tool.id,
                onTap: () => _selectTool(tool),
              );
            },
          ),

          const SizedBox(height: 24),

          // Quick Tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'نصائح للحصول على أفضل النتائج',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTip('كن محدداً في وصفك للمحتوى المطلوب'),
                _buildTip('استخدم كلمات واضحة تصف الألوان والأسلوب'),
                _buildTip('راجع النتائج وأعد التوليد إذا لزم الأمر'),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectTool(GenerateToolDefinition tool) {
    setState(() => _selectedTool = tool.id);
    _showGenerateDialog(tool);
  }

  void _showGenerateDialog(GenerateToolDefinition tool) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _GenerateToolSheet(tool: tool, onGenerate: _generateContent),
    );
  }

  void _generateContent(
    GenerateToolDefinition tool,
    Map<String, dynamic> params,
  ) async {
    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جارٍ الإنشاء...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final api = ref.read(studioApiServiceProvider);
      List<String>? resultUrls;
      String? resultUrl;
      int creditsUsed = 0;

      switch (tool.id) {
        case GenerateToolType.productImages:
          final result = await api.generateProductImages(
            productName: params['prompt'] ?? '',
            productDescription: params['description'] ?? '',
            style: params['style'] ?? 'modern',
            count: 4,
          );
          resultUrls = result.imageUrls;
          creditsUsed = result.creditsUsed;
          break;

        case GenerateToolType.banner:
          final result = await api.generateBanner(
            title: params['prompt'] ?? '',
            subtitle: params['subtitle'],
            style: params['style'] ?? 'modern',
            size: params['size'] ?? '1200x628',
          );
          resultUrl = result.imageUrl;
          creditsUsed = result.creditsUsed;
          break;

        case GenerateToolType.logo:
          final result = await api.generateLogo(
            brandName: params['prompt'] ?? '',
            brandDescription: params['description'],
            style: params['style'] ?? 'modern',
          );
          resultUrls = result.logoUrls;
          creditsUsed = result.creditsUsed;
          break;

        case GenerateToolType.animatedImage:
          // يحتاج صورة أولاً
          final imageResult = await api.generateImage(
            prompt: params['prompt'] ?? '',
            style: params['style'],
            aspectRatio: params['size'] ?? '1:1',
          );
          final result = await api.generateAnimatedImage(
            imageUrl: imageResult.imageUrl,
            motionType: 'zoom',
            durationMs: 3000,
          );
          resultUrl = result.videoUrl;
          creditsUsed = imageResult.creditsUsed + result.creditsUsed;
          break;

        case GenerateToolType.shortVideo:
          final result = await api.generateShortVideo(
            prompt: params['prompt'] ?? '',
            durationSeconds: 5,
            aspectRatio: params['size'] ?? '9:16',
          );
          // Poll للحصول على النتيجة
          Navigator.pop(context); // إغلاق مؤشر التحميل
          _pollAndShowResult(result.jobId, result.creditsUsed);
          return;

        case GenerateToolType.landingPage:
          final result = await api.generateLandingPage(
            productName: params['prompt'] ?? '',
            productDescription: params['description'] ?? '',
            template: params['style'] ?? 'modern',
          );
          Navigator.pop(context); // إغلاق مؤشر التحميل
          _showLandingPageResult(
            result.htmlContent,
            result.previewUrl,
            result.creditsUsed,
          );
          return;

        case GenerateToolType.templates:
          // إنشاء صورة قالب
          final result = await api.generateImage(
            prompt:
                'Professional ${params['style']} template design: ${params['prompt']}',
            aspectRatio: params['size'] ?? '9:16',
          );
          resultUrl = result.imageUrl;
          creditsUsed = result.creditsUsed;
          break;
      }

      Navigator.pop(context); // إغلاق مؤشر التحميل

      // تحديث الرصيد
      ref.read(userCreditsProvider.notifier).deductCredits(creditsUsed);

      // عرض النتيجة
      if (resultUrls != null && resultUrls.isNotEmpty) {
        _showMultipleResultsDialog(resultUrls, creditsUsed);
      } else if (resultUrl != null) {
        _showSingleResultDialog(resultUrl, creditsUsed);
      }
    } on InsufficientCreditsException catch (e) {
      Navigator.pop(context);
      _showErrorDialog('رصيد غير كافي', e.toString());
    } on ApiException catch (e) {
      Navigator.pop(context);
      _showErrorDialog('خطأ', e.message);
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog('خطأ', e.toString());
    }
  }

  Future<void> _pollAndShowResult(String jobId, int creditsUsed) async {
    // عرض مؤشر التقدم
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('جارٍ إنشاء الفيديو...'),
            const SizedBox(height: 8),
            Text(
              'قد يستغرق هذا بضع دقائق',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );

    final api = ref.read(studioApiServiceProvider);

    while (true) {
      await Future.delayed(const Duration(seconds: 3));

      try {
        final status = await api.getJobStatus(jobId);

        if (status.status == 'completed' && status.resultUrl != null) {
          Navigator.pop(context);
          ref.read(userCreditsProvider.notifier).deductCredits(creditsUsed);
          _showSingleResultDialog(status.resultUrl!, creditsUsed);
          break;
        } else if (status.status == 'failed') {
          Navigator.pop(context);
          _showErrorDialog('فشل', status.error ?? 'فشل إنشاء الفيديو');
          break;
        }
      } catch (e) {
        Navigator.pop(context);
        _showErrorDialog('خطأ', 'فشل في التحقق من الحالة');
        break;
      }
    }
  }

  void _showSingleResultDialog(String resultUrl, int creditsUsed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('تم الإنشاء!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                resultUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.image, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (creditsUsed > 0) Text('الرصيد المستخدم: $creditsUsed'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: حفظ أو مشاركة
            },
            icon: const Icon(Icons.save),
            label: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showMultipleResultsDialog(List<String> resultUrls, int creditsUsed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('تم الإنشاء!'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: resultUrls.length,
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      resultUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.image),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('تم إنشاء ${resultUrls.length} صور'),
              if (creditsUsed > 0) Text('الرصيد المستخدم: $creditsUsed'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: حفظ الكل
            },
            icon: const Icon(Icons.save_alt),
            label: const Text('حفظ الكل'),
          ),
        ],
      ),
    );
  }

  void _showLandingPageResult(
    String htmlContent,
    String previewUrl,
    int creditsUsed,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.web, color: Colors.green),
            SizedBox(width: 8),
            Text('صفحة الهبوط جاهزة!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text('تم إنشاء صفحة الهبوط بنجاح'),
            const SizedBox(height: 8),
            if (creditsUsed > 0) Text('الرصيد المستخدم: $creditsUsed'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: فتح المعاينة
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('معاينة'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
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

/// بطاقة أداة الإنشاء
class _GenerateToolCard extends StatelessWidget {
  final GenerateToolDefinition tool;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenerateToolCard({
    required this.tool,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getToolIcon(tool.icon),
                size: 28,
                color: isSelected ? Colors.white : colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              tool.nameAr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.monetization_on,
                  size: 14,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${tool.creditsCost} رصيد',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getToolIcon(String iconName) {
    switch (iconName) {
      case 'view_module':
        return Icons.view_module;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'web':
        return Icons.web;
      case 'crop_landscape':
        return Icons.crop_landscape;
      case 'animation':
        return Icons.animation;
      case 'videocam':
        return Icons.videocam;
      case 'palette':
        return Icons.palette;
      default:
        return Icons.auto_awesome;
    }
  }
}

/// صفحة خيارات أداة الإنشاء
class _GenerateToolSheet extends StatefulWidget {
  final GenerateToolDefinition tool;
  final Function(GenerateToolDefinition, Map<String, dynamic>) onGenerate;

  const _GenerateToolSheet({required this.tool, required this.onGenerate});

  @override
  State<_GenerateToolSheet> createState() => _GenerateToolSheetState();
}

class _GenerateToolSheetState extends State<_GenerateToolSheet> {
  final _promptController = TextEditingController();
  String _selectedStyle = 'modern';
  String _selectedSize = '1024x1024';
  bool _isGenerating = false;

  final List<Map<String, String>> _styles = [
    {'id': 'modern', 'name': 'عصري'},
    {'id': 'minimal', 'name': 'بسيط'},
    {'id': 'colorful', 'name': 'ملون'},
    {'id': 'professional', 'name': 'احترافي'},
    {'id': 'playful', 'name': 'مرح'},
  ];

  final List<Map<String, String>> _sizes = [
    {'id': '512x512', 'name': 'صغير'},
    {'id': '1024x1024', 'name': 'متوسط'},
    {'id': '1920x1080', 'name': 'HD'},
    {'id': '1080x1920', 'name': 'Story'},
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.auto_awesome, color: colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tool.nameAr,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.tool.descriptionAr,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Prompt input
            TextField(
              controller: _promptController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'وصف المحتوى',
                hintText: 'اكتب وصفاً تفصيلياً لما تريد إنشاءه...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
            ),

            const SizedBox(height: 20),

            // Style selection
            Text(
              'الأسلوب',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _styles.map((style) {
                final isSelected = _selectedStyle == style['id'];
                return ChoiceChip(
                  label: Text(style['name']!),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedStyle = style['id']!);
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Size selection
            Text(
              'الحجم',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sizes.map((size) {
                final isSelected = _selectedSize == size['id'];
                return ChoiceChip(
                  label: Text(size['name']!),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedSize = size['id']!);
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Cost info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.monetization_on, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'التكلفة: ${widget.tool.creditsCost} رصيد',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    'الوقت المتوقع: ~30 ثانية',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Generate button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isGenerating ? null : _generate,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_isGenerating ? 'جارٍ الإنشاء...' : 'إنشاء'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _generate() {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء كتابة وصف للمحتوى'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    widget.onGenerate(widget.tool, {
      'prompt': _promptController.text.trim(),
      'style': _selectedStyle,
      'size': _selectedSize,
    });

    Navigator.pop(context);
  }
}
