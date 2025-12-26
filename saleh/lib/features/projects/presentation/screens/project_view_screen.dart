import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/revenue_api_client.dart';
import '../../data/revenue_models.dart';

/// صفحة تفاصيل المشروع
/// جميع الإجراءات عبر Worker API
class ProjectViewScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectViewScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectViewScreen> createState() => _ProjectViewScreenState();
}

class _ProjectViewScreenState extends ConsumerState<ProjectViewScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectAsync = ref.watch(projectByIdProvider(widget.projectId));

    return projectAsync.when(
      data: (project) => _buildProjectScreen(project, isDark),
      loading: () => Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: const Text(
            'تفاصيل المشروع',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => _buildErrorScreen(isDark, e.toString()),
    );
  }

  Widget _buildProjectScreen(Project project, bool isDark) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: project.projectType.color,
        title: Text(
          project.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // بطاقة الحالة
                _buildStatusCard(project, isDark),
                const SizedBox(height: 16),

                // بطاقة التفاصيل
                _buildDetailsCard(project, isDark),
                const SizedBox(height: 16),

                // بطاقة الخطوات
                _buildStepsCard(project, isDark),
                const SizedBox(height: 16),

                // بطاقة الإجراءات
                _buildActionsCard(project, isDark),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildNotFoundScreen(bool isDark) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'تفاصيل المشروع',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'المشروع غير موجود',
              style: TextStyle(
                fontSize: 18,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(bool isDark, String error) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'تفاصيل المشروع',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('خطأ: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.invalidate(projectByIdProvider(widget.projectId)),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // بطاقة الحالة
  // ============================================================

  Widget _buildStatusCard(Project project, bool isDark) {
    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: project.status.color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // الحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: project.status.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        project.status.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        project.status.displayNameAr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: project.status.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

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
                        fontSize: 14,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${(project.progressPercent * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: project.projectType.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: project.progressPercent,
                    backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(
                      project.projectType.color,
                    ),
                    minHeight: 10,
                  ),
                ),
              ],
            ),

            // تحذيرات القفل
            if (project.isLocked) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: Colors.orange, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'المشروع مقفل - لا يمكن طلب تعديلات',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // بطاقة التفاصيل
  // ============================================================

  Widget _buildDetailsCard(Project project, bool isDark) {
    final type = project.projectType;

    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل المشروع',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              'النوع',
              '${type.emoji} ${type.displayNameAr}',
              isDark,
            ),
            _buildDetailRow(
              'الجودة',
              project.pricingSnapshot.quality.displayNameAr,
              isDark,
            ),
            if (project.pricingSnapshot.duration != null)
              _buildDetailRow(
                'المدة',
                project.pricingSnapshot.duration!.displayName,
                isDark,
              ),
            _buildDetailRow(
              'الصوت',
              project.pricingSnapshot.voiceType.displayNameAr,
              isDark,
            ),
            _buildDetailRow(
              'التعديلات',
              project.pricingSnapshot.revisionPolicy.displayNameAr,
              isDark,
            ),
            const Divider(height: 24),
            _buildDetailRow(
              'التكلفة',
              '${project.pricingSnapshot.priceCash} ر.س',
              isDark,
              highlight: true,
            ),
            _buildDetailRow(
              'حالة الدفع',
              project.isPaid ? '✅ مدفوع' : '⏳ بانتظار الدفع',
              isDark,
              highlight: true,
            ),
            _buildDetailRow(
              'التعديلات المستخدمة',
              '${project.revisionsUsed}/${project.pricingSnapshot.includedRevisions == -1 ? '∞' : project.pricingSnapshot.includedRevisions}',
              isDark,
            ),
            _buildDetailRow(
              'عدد التوليدات',
              '${project.generationCount}/${project.pricingSnapshot.maxGenerations}',
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    bool isDark, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              color: highlight
                  ? AppTheme.primaryColor
                  : (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // بطاقة الخطوات
  // ============================================================

  Widget _buildStepsCard(Project project, bool isDark) {
    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خطوات التنفيذ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...project.steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCurrent = index == project.currentStepIndex;
              final isCompleted = step.isCompleted;
              final isLast = index == project.steps.length - 1;

              return _buildStepItem(
                step,
                isCurrent,
                isCompleted,
                isLast,
                isDark,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(
    ProjectStep step,
    bool isCurrent,
    bool isCompleted,
    bool isLast,
    bool isDark,
  ) {
    Color stepColor;
    IconData statusIcon;

    if (isCompleted) {
      stepColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isCurrent) {
      stepColor = AppTheme.primaryColor;
      statusIcon = Icons.radio_button_checked;
    } else {
      stepColor = isDark ? Colors.white24 : Colors.grey[300]!;
      statusIcon = Icons.radio_button_unchecked;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(statusIcon, size: 24, color: stepColor),
              if (!isLast)
                Container(
                  width: 2,
                  height: 30,
                  color: isCompleted
                      ? Colors.green.withValues(alpha: 0.3)
                      : (isDark ? Colors.white12 : Colors.grey[200]),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      step.titleAr.isNotEmpty ? step.titleAr : step.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isCurrent
                            ? stepColor
                            : (isDark ? Colors.white70 : Colors.grey[700]),
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: stepColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'الحالية',
                          style: TextStyle(
                            fontSize: 10,
                            color: stepColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (step.descriptionAr.isNotEmpty ||
                    step.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    step.descriptionAr.isNotEmpty
                        ? step.descriptionAr
                        : step.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // بطاقة الإجراءات
  // ============================================================

  Widget _buildActionsCard(Project project, bool isDark) {
    if (project.isLocked && project.status == ProjectStatus.completed) {
      return _buildLockedCard(project, isDark);
    }

    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإجراءات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // إجراءات حسب الحالة
            if (project.status == ProjectStatus.pendingPayment)
              _buildActionButton(
                'إتمام الدفع',
                Icons.payment,
                Colors.green,
                () => _confirmPayment(project),
              ),

            if (project.status == ProjectStatus.inProgress &&
                project.currentStep != null)
              _buildActionButton(
                'تنفيذ الخطوة الحالية',
                Icons.play_arrow,
                project.projectType.color,
                () => _executeCurrentStep(project),
              ),

            if (project.status == ProjectStatus.review) ...[
              _buildActionButton(
                'اعتماد النتيجة',
                Icons.check_circle,
                Colors.green,
                () => _approveResult(project),
              ),
              const SizedBox(height: 8),
              if (project.canRequestFreeRevision)
                _buildActionButton(
                  'طلب تعديل (${project.remainingFreeRevisions == -1 ? '∞' : project.remainingFreeRevisions} متبقي)',
                  Icons.edit,
                  Colors.orange,
                  () => _requestRevision(project, false),
                )
              else
                _buildActionButton(
                  'طلب تعديل إضافي مدفوع',
                  Icons.edit,
                  Colors.red,
                  () => _requestRevision(project, true),
                ),
            ],

            // تحذيرات
            if (!project.canRequestFreeRevision &&
                project.pricingSnapshot.includedRevisions != -1 &&
                project.status == ProjectStatus.review) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'استنفدت التعديلات المجانية. التعديلات الإضافية مدفوعة.',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLockedCard(Project project, bool isDark) {
    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 48, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              'المشروع مكتمل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تم اعتماد النتيجة النهائية.\nلا يمكن طلب تعديلات إضافية.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            if (project.outputUrl != null)
              ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('جاري التحميل...')),
                  );
                },
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  'تحميل الملفات',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
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

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading
            ? null
            : () {
                HapticFeedback.mediumImpact();
                onPressed();
              },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // الإجراءات عبر API
  // ============================================================

  Future<void> _confirmPayment(Project project) async {
    setState(() => _isLoading = true);

    try {
      final client = ref.read(revenueApiClientProvider);
      final response = await client.confirmPayment(project.id);

      if (!mounted) return;

      if (response.success) {
        ref.invalidate(projectByIdProvider(widget.projectId));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم الدفع بنجاح!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'فشل في تأكيد الدفع'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _executeCurrentStep(Project project) async {
    if (project.currentStep == null) return;

    setState(() => _isLoading = true);

    try {
      final client = ref.read(revenueApiClientProvider);
      final response = await client.executeStep(
        project.id,
        stepIndex: project.currentStepIndex,
        value: DateTime.now().toIso8601String(),
      );

      if (!mounted) return;

      if (response.success) {
        ref.invalidate(projectByIdProvider(widget.projectId));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم تنفيذ الخطوة بنجاح')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'فشل في تنفيذ الخطوة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _approveResult(Project project) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اعتماد النتيجة'),
        content: const Text(
          'بعد الاعتماد، سيتم قفل المشروع ولا يمكن طلب تعديلات.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('اعتماد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final client = ref.read(revenueApiClientProvider);
      final response = await client.approveProject(
        project.id,
        finalApproval: true,
      );

      if (!mounted) return;

      if (response.success) {
        ref.invalidate(projectByIdProvider(widget.projectId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم اعتماد المشروع بنجاح!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'فشل في اعتماد المشروع'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _requestRevision(Project project, bool isPaid) async {
    final controller = TextEditingController();

    final notes = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isPaid ? 'طلب تعديل مدفوع' : 'طلب تعديل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPaid)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'هذا التعديل مدفوع',
                  style: TextStyle(color: Colors.orange[700]),
                ),
              ),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'اكتب ملاحظاتك...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(isPaid ? 'دفع وإرسال' : 'إرسال'),
          ),
        ],
      ),
    );

    if (notes == null || notes.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final client = ref.read(revenueApiClientProvider);
      final response = await client.requestRevision(
        project.id,
        notes: notes,
        isRegenerate: false,
      );

      if (!mounted) return;

      if (response.success) {
        ref.invalidate(projectByIdProvider(widget.projectId));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إرسال طلب التعديل')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.error ?? 'فشل في إرسال الطلب'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
