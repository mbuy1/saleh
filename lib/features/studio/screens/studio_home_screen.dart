import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

/// الشاشة الرئيسية لاستوديو المحتوى
class StudioHomeScreen extends ConsumerStatefulWidget {
  const StudioHomeScreen({super.key});

  @override
  ConsumerState<StudioHomeScreen> createState() => _StudioHomeScreenState();
}

class _StudioHomeScreenState extends ConsumerState<StudioHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // الهيدر
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // العودة
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),

                  // العنوان
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'استوديو المحتوى',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'أنشئ محتوى احترافي بالذكاء الاصطناعي',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),

                  // الرصيد
                  const CreditBalanceWidget(compact: true),
                ],
              ),
            ),

            // التبويبات
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                labelColor: colorScheme.onPrimary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'مشاريعي'),
                  Tab(text: 'قوالب جديدة'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // المحتوى
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildProjectsTab(), _buildTemplatesTab()],
              ),
            ),
          ],
        ),
      ),

      // زر إنشاء جديد
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateOptions(context),
        icon: const Icon(Icons.add),
        label: const Text('إنشاء جديد'),
      ),
    );
  }

  Widget _buildProjectsTab() {
    final projectsAsync = ref.watch(projectsProvider);

    return projectsAsync.when(
      data: (projects) {
        if (projects.isEmpty) {
          return _buildEmptyProjects();
        }
        return _buildProjectsList(projects);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('خطأ في تحميل المشاريع'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.refresh(projectsProvider),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProjects() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.movie_creation_outlined,
            size: 80,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد مشاريع بعد',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإنشاء أول فيديو إعلاني لك',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _tabController.animateTo(1),
            icon: const Icon(Icons.add),
            label: const Text('اختر قالب'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList(List<StudioProject> projects) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return _ProjectCard(
          project: project,
          onTap: () => _openProject(project),
          onDelete: () => _deleteProject(project),
        );
      },
    );
  }

  Widget _buildTemplatesTab() {
    final templatesAsync = ref.watch(templatesProvider);
    final selectedCategory = useState<String?>(null);

    return Column(
      children: [
        // فلتر الفئات
        TemplateCategoryChips(
          selectedCategory: selectedCategory.value,
          onCategoryChanged: (cat) {
            selectedCategory.value = cat;
            ref.read(templatesProvider.notifier).loadTemplates(category: cat);
          },
        ),
        const SizedBox(height: 16),

        // القوالب
        Expanded(
          child: templatesAsync.when(
            data: (templates) => _buildTemplatesGrid(templates),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildTemplatesGrid(getDefaultTemplates()),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplatesGrid(List<StudioTemplate> templates) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return TemplateCard(
          template: template,
          onTap: () => _startFromTemplate(template),
        );
      },
    );
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إنشاء محتوى جديد',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _CreateOptionTile(
              icon: Icons.auto_awesome,
              title: 'من سيناريو AI',
              subtitle:
                  'اكتب وصف المنتج وسينشئ الذكاء الاصطناعي السيناريو كاملاً',
              onTap: () {
                Navigator.pop(context);
                _startFromScratch();
              },
            ),
            const SizedBox(height: 12),
            _CreateOptionTile(
              icon: Icons.dashboard_customize,
              title: 'من قالب',
              subtitle: 'اختر قالباً جاهزاً وخصصه حسب احتياجك',
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(1);
              },
            ),
            const SizedBox(height: 12),
            _CreateOptionTile(
              icon: Icons.add_circle_outline,
              title: 'مشروع فارغ',
              subtitle: 'ابدأ من الصفر مع كانفاس فارغ',
              onTap: () {
                Navigator.pop(context);
                _startBlankProject();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _startFromTemplate(StudioTemplate template) {
    Navigator.pushNamed(
      context,
      '/studio/script-generator',
      arguments: {'template': template},
    );
  }

  void _startFromScratch() {
    Navigator.pushNamed(context, '/studio/script-generator');
  }

  void _startBlankProject() async {
    try {
      final project = await ref
          .read(projectsProvider.notifier)
          .createProject(
            name: 'مشروع جديد ${DateTime.now().millisecondsSinceEpoch}',
          );
      _openProject(project);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  void _openProject(StudioProject project) {
    Navigator.pushNamed(
      context,
      '/studio/editor',
      arguments: {'projectId': project.id},
    );
  }

  void _deleteProject(StudioProject project) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المشروع'),
        content: Text('هل أنت متأكد من حذف "${project.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(projectsProvider.notifier).deleteProject(project.id);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم حذف المشروع')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }
}

/// useState helper
ValueNotifier<T> useState<T>(T initialValue) => ValueNotifier(initialValue);

/// بطاقة المشروع
class _ProjectCard extends StatelessWidget {
  final StudioProject project;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _ProjectCard({required this.project, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // صورة المشروع
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: project.thumbnailUrl != null
                    ? Image.network(project.thumbnailUrl!, fit: BoxFit.cover)
                    : Icon(
                        Icons.movie_outlined,
                        size: 32,
                        color: colorScheme.onSurfaceVariant,
                      ),
              ),
              const SizedBox(width: 12),

              // المعلومات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildStatusChip(context),
                        const SizedBox(width: 8),
                        if (project.scenesCount > 0)
                          Text(
                            '${project.scenesCount} مشاهد',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(project.updatedAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // القائمة
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8),
                        Text('نسخ'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('حذف', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color color;
    String text;
    IconData icon;

    switch (project.status) {
      case ProjectStatus.draft:
        color = Colors.grey;
        text = 'مسودة';
        icon = Icons.edit_outlined;
        break;
      case ProjectStatus.generating:
        color = Colors.orange;
        text = 'قيد التوليد';
        icon = Icons.sync;
        break;
      case ProjectStatus.processing:
        color = Colors.amber;
        text = 'قيد المعالجة';
        icon = Icons.hourglass_bottom;
        break;
      case ProjectStatus.ready:
        color = Colors.green;
        text = 'جاهز';
        icon = Icons.check_circle_outline;
        break;
      case ProjectStatus.rendering:
        color = Colors.blue;
        text = 'قيد التصدير';
        icon = Icons.movie_creation;
        break;
      case ProjectStatus.completed:
        color = colorScheme.primary;
        text = 'مكتمل';
        icon = Icons.done_all;
        break;
      case ProjectStatus.failed:
        color = Colors.red;
        text = 'فشل';
        icon = Icons.error_outline;
        break;
      case ProjectStatus.error:
        color = Colors.red;
        text = 'خطأ';
        icon = Icons.error_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// خيار إنشاء
class _CreateOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _CreateOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
