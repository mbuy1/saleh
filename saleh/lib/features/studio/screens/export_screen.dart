import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

/// شاشة تصدير الفيديو
class ExportScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ExportScreen({super.key, required this.projectId});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  @override
  Widget build(BuildContext context) {
    final renderState = ref.watch(renderProvider);
    final renderSettings = ref.watch(renderSettingsProvider);
    final estimatedCredits = ref.watch(estimatedCreditsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تصدير الفيديو'),
        actions: [
          const CreditBalanceWidget(compact: true),
          const SizedBox(width: 16),
        ],
      ),
      body: renderState.isRendering
          ? _buildRenderingState(renderState)
          : renderState.resultUrl != null
          ? _buildCompletedState(renderState)
          : _buildSettingsState(renderSettings, estimatedCredits),
    );
  }

  Widget _buildSettingsState(RenderSettings settings, int estimatedCredits) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معاينة
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.movie_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'معاينة الفيديو',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // الجودة
          _buildSectionTitle('الجودة'),
          const SizedBox(height: 12),
          _buildQualitySelector(settings),
          const SizedBox(height: 24),

          // الصيغة
          _buildSectionTitle('صيغة الملف'),
          const SizedBox(height: 12),
          _buildFormatSelector(settings),
          const SizedBox(height: 24),

          // إعدادات متقدمة
          ExpansionTile(
            title: const Text('إعدادات متقدمة'),
            initiallyExpanded: false,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAdvancedOption(
                      'معدل الإطارات',
                      '${settings.fps} FPS',
                      Icons.speed,
                    ),
                    _buildAdvancedOption(
                      'الدقة',
                      settings.resolution ?? settings.calculatedResolution,
                      Icons.aspect_ratio,
                    ),
                    _buildAdvancedOption(
                      'معدل البت (فيديو)',
                      settings.videoBitrate ?? '8M',
                      Icons.videocam,
                    ),
                    _buildAdvancedOption(
                      'معدل البت (صوت)',
                      settings.audioBitrate ?? '192k',
                      Icons.audiotrack,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // تكلفة التصدير
          CreditCostCard(
            cost: estimatedCredits,
            operation: 'تصدير فيديو (${_getQualityLabel(settings.quality)})',
            currentBalance: ref.watch(userCreditsProvider).valueOrNull?.balance,
          ),
          const SizedBox(height: 24),

          // زر التصدير
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: _startExport,
              icon: const Icon(Icons.movie_creation),
              label: const Text('بدء التصدير'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRenderingState(RenderState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressWidget(
              progress: state.progress,
              size: 150,
              strokeWidth: 12,
              label: state.currentStep,
            ),
            const SizedBox(height: 32),
            Text(
              'جاري تصدير الفيديو',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              state.currentStep ?? 'جاري المعالجة...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => ref.read(renderProvider.notifier).cancelRender(),
              icon: const Icon(Icons.close),
              label: const Text('إلغاء'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedState(RenderState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'تم التصدير بنجاح!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'الفيديو جاهز للتحميل',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // معلومات الفيديو
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildVideoInfo('الصيغة', 'MP4'),
                  _buildVideoInfo('الجودة', 'Full HD'),
                  _buildVideoInfo('الحجم', '~15 MB'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // أزرار التحميل والمشاركة
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () => _downloadVideo(state.resultUrl!),
                  icon: const Icon(Icons.download),
                  label: const Text('تحميل'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => _shareVideo(state.resultUrl!),
                  icon: const Icon(Icons.share),
                  label: const Text('مشاركة'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                ref.read(renderProvider.notifier).reset();
              },
              child: const Text('تصدير مرة أخرى'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildQualitySelector(RenderSettings settings) {
    final qualities = [
      (RenderQuality.low, 'منخفضة', '540p', 5),
      (RenderQuality.medium, 'متوسطة', '1080p', 10),
      (RenderQuality.high, 'عالية', '1080p 60fps', 20),
      (RenderQuality.ultra, 'فائقة', '4K', 40),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: qualities.map((q) {
        final isSelected = settings.quality == q.$1;
        return FilterChip(
          selected: isSelected,
          label: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(q.$2),
              Text(
                q.$3,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          avatar: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${q.$4}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : null,
              ),
            ),
          ),
          onSelected: (_) {
            ref.read(renderSettingsProvider.notifier).setQuality(q.$1);
          },
        );
      }).toList(),
    );
  }

  Widget _buildFormatSelector(RenderSettings settings) {
    final formats = ['mp4', 'mov', 'webm'];

    return Wrap(
      spacing: 8,
      children: formats.map((format) {
        final isSelected = settings.format == format;
        return ChoiceChip(
          label: Text(format.toUpperCase()),
          selected: isSelected,
          onSelected: (_) {
            ref.read(renderSettingsProvider.notifier).setFormat(format);
          },
        );
      }).toList(),
    );
  }

  Widget _buildAdvancedOption(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildVideoInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getQualityLabel(String quality) {
    switch (quality) {
      case 'low':
        return 'منخفضة';
      case 'medium':
        return 'متوسطة';
      case 'high':
        return 'عالية';
      case 'ultra':
        return 'فائقة';
      default:
        return 'متوسطة';
    }
  }

  /// تحويل String لـ RenderQuality
  RenderQuality _parseQuality(String quality) {
    switch (quality) {
      case 'low':
        return RenderQuality.low;
      case 'high':
        return RenderQuality.high;
      case 'ultra':
        return RenderQuality.ultra;
      default:
        return RenderQuality.medium;
    }
  }

  void _startExport() {
    final settings = ref.read(renderSettingsProvider);
    ref
        .read(renderProvider.notifier)
        .startRender(
          projectId: widget.projectId,
          quality: _parseQuality(settings.quality),
          format: settings.format,
        );
  }

  void _downloadVideo(String url) {
    // TODO: تحميل الفيديو
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('جاري تحميل الفيديو...')));
  }

  void _shareVideo(String url) {
    // TODO: مشاركة الفيديو
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('سيتم فتح خيارات المشاركة')));
  }
}
