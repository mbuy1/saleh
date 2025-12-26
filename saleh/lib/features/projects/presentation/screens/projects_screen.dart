import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/revenue_api_client.dart';
import '../../data/revenue_models.dart';

/// صفحة المشاريع الرئيسية
/// جميع البيانات من Worker API
class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen>
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'المشاريع',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'أنواع المشاريع'),
            Tab(text: 'مشاريعي'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildProjectTypesTab(isDark), _buildMyProjectsTab(isDark)],
      ),
    );
  }

  // ============================================================
  // تبويب أنواع المشاريع
  // ============================================================

  Widget _buildProjectTypesTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الترويسة
          Text(
            'اختر نوع المشروع',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'مشاريع احترافية بجودة عالية - الدفع نقداً',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // بطاقات أنواع المشاريع
          ...ProjectType.values.map(
            (type) => _buildProjectTypeCard(type, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectTypeCard(ProjectType type, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isDark ? 0 : 3,
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: type.color.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          context.push('/dashboard/projects/new/${type.value}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // الأيقونة
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [type.color, type.color.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(type.icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),

              // المحتوى
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${type.emoji} ${type.displayNameAr}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: type.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'يبدأ من ${type.basePriceSAR} ر.س',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: type.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // السهم
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: isDark ? Colors.white38 : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // تبويب مشاريعي
  // ============================================================

  Widget _buildMyProjectsTab(bool isDark) {
    final projectsAsync = ref.watch(userProjectsProvider);

    return projectsAsync.when(
      data: (projects) {
        if (projects.isEmpty) {
          return _buildEmptyState(isDark);
        }

        final activeProjects = projects
            .where(
              (p) =>
                  p.status != ProjectStatus.completed &&
                  p.status != ProjectStatus.cancelled,
            )
            .toList();
        final completedProjects = projects
            .where((p) => p.status == ProjectStatus.completed)
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // المشاريع النشطة
              if (activeProjects.isNotEmpty) ...[
                _buildSectionHeader(
                  'المشاريع النشطة',
                  activeProjects.length,
                  isDark,
                ),
                const SizedBox(height: 12),
                ...activeProjects.map((p) => _buildProjectCard(p, isDark)),
                const SizedBox(height: 24),
              ],

              // المشاريع المكتملة
              if (completedProjects.isNotEmpty) ...[
                _buildSectionHeader(
                  'المكتملة',
                  completedProjects.length,
                  isDark,
                ),
                const SizedBox(height: 12),
                ...completedProjects.map((p) => _buildProjectCard(p, isDark)),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'خطأ في تحميل المشاريع',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.invalidate(userProjectsProvider),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, bool isDark) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(Project project, bool isDark) {
    final type = project.projectType;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isDark ? 0 : 2,
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/dashboard/projects/view/${project.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي
              Row(
                children: [
                  // أيقونة النوع
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: type.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(type.icon, color: type.color, size: 24),
                  ),
                  const SizedBox(width: 12),

                  // الاسم والنوع
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          type.displayNameAr,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // الحالة
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: project.status.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${project.status.emoji} ${project.status.displayNameAr}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: project.status.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // شريط التقدم
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'التقدم',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.grey[500],
                        ),
                      ),
                      Text(
                        '${(project.progressPercent * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: project.progressPercent,
                      backgroundColor: isDark
                          ? Colors.white12
                          : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(type.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // معلومات إضافية
              Row(
                children: [
                  // السعر
                  Icon(
                    Icons.payments,
                    size: 14,
                    color: isDark ? Colors.white38 : Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.pricingSnapshot.priceCash} ر.س',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                  const Spacer(),

                  // التعديلات
                  if (project.pricingSnapshot.includedRevisions > 0) ...[
                    Icon(
                      Icons.edit,
                      size: 14,
                      color: project.canRequestFreeRevision
                          ? Colors.green
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'تعديلات: ${project.revisionsUsed}/${project.pricingSnapshot.includedRevisions == -1 ? '∞' : project.pricingSnapshot.includedRevisions}',
                      style: TextStyle(
                        fontSize: 12,
                        color: project.canRequestFreeRevision
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: isDark ? Colors.white38 : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد مشاريع بعد',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اختر نوع المشروع من التبويب الأول',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
