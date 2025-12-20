import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

/// محرر المشاهد والمحتوى
class SceneEditorScreen extends ConsumerStatefulWidget {
  final String projectId;
  final ScriptData? initialScript;

  const SceneEditorScreen({
    super.key,
    required this.projectId,
    this.initialScript,
  });

  @override
  ConsumerState<SceneEditorScreen> createState() => _SceneEditorScreenState();
}

class _SceneEditorScreenState extends ConsumerState<SceneEditorScreen> {
  int _selectedSceneIndex = 0;
  bool _isGeneratingAll = false;
  double _generationProgress = 0;

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  Future<void> _loadProject() async {
    await ref
        .read(currentProjectProvider.notifier)
        .loadProject(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    final projectAsync = ref.watch(currentProjectProvider);
    final scenes = ref.watch(currentScenesProvider);

    return Scaffold(
      appBar: AppBar(
        title: projectAsync.maybeWhen(
          data: (p) => Text(p?.name ?? 'محرر المشاهد'),
          orElse: () => const Text('محرر المشاهد'),
        ),
        actions: [
          const CreditBalanceWidget(compact: true),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: _saveProject,
            tooltip: 'حفظ',
          ),
          IconButton(
            icon: const Icon(Icons.preview_outlined),
            onPressed: _previewVideo,
            tooltip: 'معاينة',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: projectAsync.when(
        data: (project) {
          if (project == null) {
            return const Center(child: Text('المشروع غير موجود'));
          }
          return _buildContent(project, scenes);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
      ),
      bottomNavigationBar: _buildBottomBar(scenes),
    );
  }

  Widget _buildContent(StudioProject project, List<Scene> scenes) {
    if (scenes.isEmpty) {
      return _buildEmptyScenes();
    }

    final selectedScene = scenes[_selectedSceneIndex];

    return Column(
      children: [
        // شريط التقدم إذا كان التوليد جاري
        if (_isGeneratingAll)
          ProcessStatusBar(
            status: 'جاري توليد المحتوى...',
            progress: _generationProgress,
            onCancel: () => setState(() => _isGeneratingAll = false),
          ),

        // معاينة المشهد
        Expanded(flex: 3, child: _buildScenePreview(selectedScene)),

        // تحرير المشهد
        Expanded(flex: 2, child: _buildSceneEditor(selectedScene)),

        // خط الزمن
        SceneTimeline(
          scenes: scenes,
          selectedIndex: _selectedSceneIndex,
          onSceneSelected: (index) =>
              setState(() => _selectedSceneIndex = index),
          onSceneReordered: (newIndex) {
            ref
                .read(currentScenesProvider.notifier)
                .reorderScenes(_selectedSceneIndex, newIndex);
          },
          onAddScene: _addNewScene,
        ),
      ],
    );
  }

  Widget _buildEmptyScenes() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.layers_outlined,
            size: 80,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          const Text('لا توجد مشاهد'),
          const SizedBox(height: 8),
          Text(
            'أضف مشاهد للبدء',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _addNewScene,
            icon: const Icon(Icons.add),
            label: const Text('إضافة مشهد'),
          ),
        ],
      ),
    );
  }

  Widget _buildScenePreview(Scene scene) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // خلفية / صورة المشهد
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: scene.generatedImageUrl != null
                ? Image.network(
                    scene.generatedImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),

          // نص المشهد
          if (scene.textOverlay != null)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scene.textOverlay!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // شارة حالة المشهد
          Positioned(top: 12, right: 12, child: _buildSceneStatusBadge(scene)),

          // مدة المشهد
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '${scene.duration}s',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // أيقونة الصوت
          if (scene.generatedAudioUrl != null)
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.volume_up,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'اضغط "توليد صورة" لإنشاء صورة المشهد',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSceneStatusBadge(Scene scene) {
    Color color;
    String text;
    IconData icon;

    switch (scene.status) {
      case SceneStatus.draft:
        color = Colors.grey;
        text = 'مسودة';
        icon = Icons.edit;
        break;
      case SceneStatus.pending:
        color = Colors.blue;
        text = 'قيد الانتظار';
        icon = Icons.hourglass_empty;
        break;
      case SceneStatus.generating:
        color = Colors.orange;
        text = 'جاري التوليد';
        icon = Icons.sync;
        break;
      case SceneStatus.ready:
        color = Colors.green;
        text = 'جاهز';
        icon = Icons.check;
        break;
      case SceneStatus.failed:
        color = Colors.red;
        text = 'فشل';
        icon = Icons.error_outline;
        break;
      case SceneStatus.error:
        color = Colors.red;
        text = 'خطأ';
        icon = Icons.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSceneEditor(Scene scene) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // النص / النارادشن
            _buildEditorSection(
              title: 'نص الراوي',
              icon: Icons.record_voice_over,
              child: TextFormField(
                initialValue: scene.narration ?? '',
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'اكتب نص الراوي هنا...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _updateScene(scene.copyWith(narration: value));
                },
              ),
            ),
            const SizedBox(height: 16),

            // أزرار التوليد
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.image,
                    label: 'توليد صورة',
                    cost: 5,
                    isLoading: scene.status == SceneStatus.generating,
                    onPressed: () => _generateImage(scene),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.mic,
                    label: 'توليد صوت',
                    cost: 8,
                    isLoading: false,
                    onPressed: () => _generateVoice(scene),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.brush,
                    label: 'تحرير Canvas',
                    onPressed: () => _openCanvasEditor(scene),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.delete_outline,
                    label: 'حذف',
                    color: Colors.red,
                    onPressed: () => _deleteScene(scene),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildBottomBar(List<Scene> scenes) {
    final readyScenes = scenes
        .where((s) => s.status == SceneStatus.ready)
        .length;
    final totalScenes = scenes.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // معلومات التقدم
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$readyScenes / $totalScenes مشاهد جاهزة',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: totalScenes > 0 ? readyScenes / totalScenes : 0,
                ),
              ),
            ],
          ),
          const Spacer(),

          // توليد الكل
          OutlinedButton.icon(
            onPressed: _isGeneratingAll ? null : _generateAllScenes,
            icon: const Icon(Icons.auto_fix_high),
            label: const Text('توليد الكل'),
          ),
          const SizedBox(width: 8),

          // تصدير
          FilledButton.icon(
            onPressed: readyScenes == totalScenes && totalScenes > 0
                ? _exportVideo
                : null,
            icon: const Icon(Icons.movie_creation),
            label: const Text('تصدير الفيديو'),
          ),
        ],
      ),
    );
  }

  void _updateScene(Scene updatedScene) {
    ref
        .read(currentScenesProvider.notifier)
        .updateScene(updatedScene.id, updatedScene);
  }

  void _addNewScene() {
    final scenes = ref.read(currentScenesProvider);
    final newScene = Scene(
      id: 'scene_${DateTime.now().millisecondsSinceEpoch}',
      projectId: widget.projectId,
      sceneType: SceneType.product,
      orderIndex: scenes.length,
      durationMs: 5000,
      status: SceneStatus.draft,
      layers: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    ref.read(currentScenesProvider.notifier).addScene(newScene);
    setState(() => _selectedSceneIndex = scenes.length);
  }

  void _deleteScene(Scene scene) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المشهد'),
        content: const Text('هل أنت متأكد من حذف هذا المشهد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(currentScenesProvider.notifier).removeScene(scene.id);
      final scenes = ref.read(currentScenesProvider);
      if (_selectedSceneIndex >= scenes.length && scenes.isNotEmpty) {
        setState(() => _selectedSceneIndex = scenes.length - 1);
      }
    }
  }

  Future<void> _generateImage(Scene scene) async {
    try {
      _updateScene(scene.copyWith(status: SceneStatus.generating));

      final imageUrl = await ref
          .read(aiGenerationProvider.notifier)
          .generateImage(
            prompt: scene.imagePrompt ?? scene.narration ?? 'product image',
            projectId: widget.projectId,
          );

      _updateScene(
        scene.copyWith(generatedImageUrl: imageUrl, status: SceneStatus.ready),
      );
    } catch (e) {
      _updateScene(scene.copyWith(status: SceneStatus.error));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  Future<void> _generateVoice(Scene scene) async {
    if (scene.narration?.isEmpty ?? true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('أضف نص الراوي أولاً')));
      return;
    }

    try {
      final audioUrl = await ref
          .read(aiGenerationProvider.notifier)
          .generateVoice(text: scene.narration!, projectId: widget.projectId);

      _updateScene(scene.copyWith(generatedAudioUrl: audioUrl));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم توليد الصوت بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  void _openCanvasEditor(Scene scene) {
    ref.read(canvasEditorProvider.notifier).loadScene(scene);
    Navigator.pushNamed(context, '/studio/canvas', arguments: {'scene': scene});
  }

  Future<void> _generateAllScenes() async {
    final scenes = ref.read(currentScenesProvider);
    final pendingScenes = scenes
        .where((s) => s.status != SceneStatus.ready)
        .toList();

    if (pendingScenes.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('جميع المشاهد جاهزة!')));
      return;
    }

    setState(() {
      _isGeneratingAll = true;
      _generationProgress = 0;
    });

    for (var i = 0; i < pendingScenes.length; i++) {
      if (!_isGeneratingAll) break;

      await _generateImage(pendingScenes[i]);
      setState(() {
        _generationProgress = (i + 1) / pendingScenes.length;
      });
    }

    setState(() => _isGeneratingAll = false);
  }

  void _saveProject() {
    // TODO: حفظ المشروع
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم الحفظ')));
  }

  void _previewVideo() {
    Navigator.pushNamed(
      context,
      '/studio/preview',
      arguments: {'projectId': widget.projectId},
    );
  }

  void _exportVideo() {
    Navigator.pushNamed(
      context,
      '/studio/export',
      arguments: {'projectId': widget.projectId},
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? cost;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.cost,
    this.isLoading = false,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: color != null ? BorderSide(color: color!) : null,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Text(label, style: TextStyle(color: color)),
                if (cost != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$cost',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
