import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/studio_tool.dart';
import '../providers/studio_provider.dart';
import '../services/studio_api_service.dart';

/// تبويب تحرير الصور والفيديو
class EditTab extends ConsumerStatefulWidget {
  const EditTab({super.key});

  @override
  ConsumerState<EditTab> createState() => _EditTabState();
}

class _EditTabState extends ConsumerState<EditTab> {
  XFile? _selectedFile;
  String _selectedFileType = 'image'; // 'image' or 'video'
  EditToolType? _selectedTool;
  bool _isProcessing = false;
  String? _errorMessage;
  String? _resultUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final editTools = getDefaultEditTools();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File Upload Section
          _buildUploadSection(colorScheme),

          const SizedBox(height: 24),

          // Tools Section
          Text(
            'أدوات التحرير',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'اختر الأداة المناسبة لتحرير ملفك',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Image Tools
          Text(
            '📷 أدوات الصور',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildToolsGrid(
            editTools.where((t) => t.supportsImage).toList(),
            colorScheme,
          ),

          const SizedBox(height: 24),

          // Video Tools
          Text(
            '🎬 أدوات الفيديو',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildToolsGrid(
            editTools.where((t) => t.supportsVideo).toList(),
            colorScheme,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildUploadSection(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 2,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      child: _selectedFile == null
          ? _buildUploadPlaceholder(colorScheme)
          : _buildSelectedFilePreview(colorScheme),
    );
  }

  Widget _buildUploadPlaceholder(ColorScheme colorScheme) {
    return Column(
      children: [
        Icon(Icons.cloud_upload_outlined, size: 48, color: colorScheme.primary),
        const SizedBox(height: 12),
        Text(
          'ارفع صورة أو فيديو',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'PNG, JPG, MP4, MOV حتى 50MB',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () => _pickFile(ImageSource.gallery, 'image'),
              icon: const Icon(Icons.image),
              label: const Text('صورة'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => _pickFile(ImageSource.gallery, 'video'),
              icon: const Icon(Icons.videocam),
              label: const Text('فيديو'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedFilePreview(ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              _selectedFileType == 'image' ? Icons.image : Icons.videocam,
              size: 48,
              color: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _selectedFile!.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _clearFile,
              icon: const Icon(Icons.close),
              label: const Text('إزالة'),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () =>
                  _pickFile(ImageSource.gallery, _selectedFileType),
              icon: const Icon(Icons.refresh),
              label: const Text('تغيير'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolsGrid(
    List<EditToolDefinition> tools,
    ColorScheme colorScheme,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        final isSelected = _selectedTool == tool.id;

        return InkWell(
          onTap: () => _selectTool(tool),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getToolIcon(tool.icon),
                  size: 28,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  tool.nameAr,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
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
                      size: 12,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${tool.creditsCost}',
                      style: TextStyle(
                        fontSize: 10,
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
      },
    );
  }

  IconData _getToolIcon(String iconName) {
    switch (iconName) {
      case 'content_cut':
        return Icons.content_cut;
      case 'auto_fix_high':
        return Icons.auto_fix_high;
      case 'aspect_ratio':
        return Icons.aspect_ratio;
      case 'filter_vintage':
        return Icons.filter_vintage;
      case 'merge':
        return Icons.merge;
      case 'music_note':
        return Icons.music_note;
      case 'subtitles':
        return Icons.subtitles;
      case 'gif':
        return Icons.gif;
      default:
        return Icons.build;
    }
  }

  Future<void> _pickFile(ImageSource source, String type) async {
    final picker = ImagePicker();
    XFile? file;

    if (type == 'image') {
      file = await picker.pickImage(source: source);
    } else {
      file = await picker.pickVideo(source: source);
    }

    if (file != null) {
      setState(() {
        _selectedFile = file;
        _selectedFileType = type;
      });
    }
  }

  void _clearFile() {
    setState(() {
      _selectedFile = null;
      _selectedTool = null;
    });
  }

  void _selectTool(EditToolDefinition tool) {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء رفع ملف أولاً'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check file type compatibility
    if (_selectedFileType == 'image' && !tool.supportsImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('هذه الأداة للفيديو فقط'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_selectedFileType == 'video' && !tool.supportsVideo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('هذه الأداة للصور فقط'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _selectedTool = tool.id);

    // Show tool options dialog
    _showToolDialog(tool);
  }

  void _showToolDialog(EditToolDefinition tool) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ToolOptionsSheet(
        tool: tool,
        file: _selectedFile!,
        fileType: _selectedFileType,
        onProcess: _processFile,
      ),
    );
  }

  void _processFile(
    EditToolDefinition tool,
    Map<String, dynamic> options,
  ) async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(studioApiServiceProvider);

      // رفع الملف أولاً (في التطبيق الحقيقي)
      // final uploadedUrl = await _uploadFile(_selectedFile!);
      final uploadedUrl = 'https://example.com/temp-file.jpg'; // مؤقت للاختبار

      String? resultUrl;
      int creditsUsed = 0;

      switch (tool.id) {
        case EditToolType.removeBackground:
          final result = await api.removeBackground(imageUrl: uploadedUrl);
          resultUrl = result.resultUrl;
          creditsUsed = result.creditsUsed;
          break;

        case EditToolType.enhanceQuality:
          final result = await api.enhanceImage(
            imageUrl: uploadedUrl,
            enhanceType: options['enhanceType'] ?? 'general',
          );
          resultUrl = result.resultUrl;
          creditsUsed = result.creditsUsed;
          break;

        case EditToolType.resize:
          final result = await api.resizeImage(
            imageUrl: uploadedUrl,
            width: options['width'] ?? 1080,
            height: options['height'] ?? 1920,
          );
          resultUrl = result.resultUrl;
          creditsUsed = result.creditsUsed;
          break;

        case EditToolType.trimVideo:
          final result = await api.trimVideo(
            videoUrl: uploadedUrl,
            startMs: options['startMs'] ?? 0,
            endMs: options['endMs'] ?? 10000,
          );
          // انتظار اكتمال المهمة
          _pollJobStatus(result.jobId);
          creditsUsed = result.creditsUsed;
          break;

        case EditToolType.mergeVideos:
          final result = await api.mergeVideos(
            videoUrls: [uploadedUrl], // في الواقع قائمة فيديوهات
          );
          _pollJobStatus(result.jobId);
          creditsUsed = result.creditsUsed;
          break;

        case EditToolType.addMusic:
          final result = await api.addMusic(
            videoUrl: uploadedUrl,
            audioUrl: options['audioUrl'] ?? '',
            volume: options['volume'] ?? 0.5,
          );
          _pollJobStatus(result.jobId);
          creditsUsed = result.creditsUsed;
          break;

        case EditToolType.addSubtitles:
          final result = await api.addSubtitles(
            videoUrl: uploadedUrl,
            subtitlesText: options['subtitlesText'] ?? '',
          );
          _pollJobStatus(result.jobId);
          creditsUsed = result.creditsUsed;
          break;

        case EditToolType.videoToGif:
          final result = await api.videoToGif(
            videoUrl: uploadedUrl,
            fps: options['fps'] ?? 15,
            width: options['width'] ?? 480,
          );
          _pollJobStatus(result.jobId);
          creditsUsed = result.creditsUsed;
          break;

        default:
          throw Exception('أداة غير مدعومة');
      }

      if (resultUrl != null) {
        setState(() => _resultUrl = resultUrl);
        _showResultDialog(resultUrl, creditsUsed);
      }

      // تحديث الرصيد
      ref.read(userCreditsProvider.notifier).deductCredits(creditsUsed);
    } on InsufficientCreditsException catch (e) {
      setState(() => _errorMessage = e.toString());
      _showErrorSnackBar('رصيدك غير كافي');
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
      _showErrorSnackBar(e.message);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      _showErrorSnackBar('حدث خطأ غير متوقع');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _pollJobStatus(String jobId) async {
    final api = ref.read(studioApiServiceProvider);

    // Poll كل 2 ثانية
    while (true) {
      await Future.delayed(const Duration(seconds: 2));

      try {
        final status = await api.getJobStatus(jobId);

        if (status.status == 'completed' && status.resultUrl != null) {
          setState(() => _resultUrl = status.resultUrl);
          _showResultDialog(status.resultUrl!, 0);
          break;
        } else if (status.status == 'failed') {
          _showErrorSnackBar(status.error ?? 'فشلت المهمة');
          break;
        }
      } catch (e) {
        _showErrorSnackBar('فشل في التحقق من الحالة');
        break;
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showResultDialog(String resultUrl, int creditsUsed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('تم بنجاح!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تمت معالجة الملف بنجاح.'),
            if (creditsUsed > 0) ...[
              const SizedBox(height: 8),
              Text('الرصيد المستخدم: $creditsUsed'),
            ],
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
              // TODO: تحميل أو مشاركة الملف
            },
            icon: const Icon(Icons.download),
            label: const Text('تحميل'),
          ),
        ],
      ),
    );
  }
}

/// صفحة خيارات الأداة
class _ToolOptionsSheet extends StatefulWidget {
  final EditToolDefinition tool;
  final XFile file;
  final String fileType;
  final Function(EditToolDefinition, Map<String, dynamic>) onProcess;

  const _ToolOptionsSheet({
    required this.tool,
    required this.file,
    required this.fileType,
    required this.onProcess,
  });

  @override
  State<_ToolOptionsSheet> createState() => _ToolOptionsSheetState();
}

class _ToolOptionsSheetState extends State<_ToolOptionsSheet> {
  final Map<String, dynamic> _options = {};
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
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
                child: Icon(Icons.auto_fix_high, color: colorScheme.primary),
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

          // File info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  widget.fileType == 'image' ? Icons.image : Icons.videocam,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Cost info
          Row(
            children: [
              Icon(Icons.monetization_on, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'التكلفة: ${widget.tool.creditsCost} رصيد',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Process button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isProcessing ? null : _process,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_isProcessing ? 'جارٍ المعالجة...' : 'تطبيق'),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _process() {
    setState(() => _isProcessing = true);
    widget.onProcess(widget.tool, _options);
    Navigator.pop(context);
  }
}
