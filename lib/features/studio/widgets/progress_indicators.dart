import 'package:flutter/material.dart';

/// مؤشر التقدم الدائري مع نسبة
class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final String? label;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    this.label,
    this.size = 100,
    this.strokeWidth = 8,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية
          CircularProgressIndicator(
            value: 1,
            strokeWidth: strokeWidth,
            backgroundColor:
                backgroundColor ?? colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              backgroundColor ?? colorScheme.surfaceContainerHighest,
            ),
          ),

          // التقدم
          CircularProgressIndicator(
            value: progress.clamp(0, 1),
            strokeWidth: strokeWidth,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(
              progressColor ?? colorScheme.primary,
            ),
          ),

          // النسبة المئوية
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).round()}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (label != null)
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// مؤشر التقدم الخطي مع خطوات
class StepProgressWidget extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final double progress;

  const StepProgressWidget({
    super.key,
    required this.currentStep,
    required this.steps,
    this.progress = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // الخطوات
        Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Row(
                children: [
                  // النقطة
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? colorScheme.primary
                          : isCurrent
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      border: isCurrent
                          ? Border.all(color: colorScheme.primary, width: 2)
                          : null,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isCurrent
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                  ),

                  // الخط الواصل
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        color: isCompleted
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),

        // أسماء الخطوات
        Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Text(
                steps[index],
                style: TextStyle(
                  fontSize: 10,
                  color: isCompleted || isCurrent
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ),

        // شريط التقدم للخطوة الحالية
        if (progress > 0) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
        ],
      ],
    );
  }
}

/// مؤشر التقدم لتوليد AI
class AIGenerationProgress extends StatelessWidget {
  final String task;
  final double? progress;
  final bool isAnimated;

  const AIGenerationProgress({
    super.key,
    required this.task,
    this.progress,
    this.isAnimated = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // أيقونة متحركة
          if (isAnimated)
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(
                      colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        _getTaskIcon(),
                        size: 32,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (progress != null)
            CircularProgressWidget(
              progress: progress!,
              size: 64,
              strokeWidth: 4,
            ),

          const SizedBox(height: 16),

          // وصف المهمة
          Text(
            task,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),

          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTaskIcon() {
    if (task.contains('سيناريو') || task.contains('نص')) {
      return Icons.auto_awesome;
    } else if (task.contains('صورة')) {
      return Icons.image;
    } else if (task.contains('صوت')) {
      return Icons.mic;
    } else if (task.contains('فيديو')) {
      return Icons.videocam;
    } else if (task.contains('تصدير') || task.contains('ضغط')) {
      return Icons.movie_creation;
    }
    return Icons.hourglass_empty;
  }
}

/// شريط حالة العملية
class ProcessStatusBar extends StatelessWidget {
  final String status;
  final double progress;
  final VoidCallback? onCancel;

  const ProcessStatusBar({
    super.key,
    required this.status,
    required this.progress,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.5),
        border: Border(
          top: BorderSide(color: colorScheme.primary.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: colorScheme.primary.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          if (onCancel != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onCancel,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              color: colorScheme.onPrimaryContainer,
            ),
          ],
        ],
      ),
    );
  }
}
