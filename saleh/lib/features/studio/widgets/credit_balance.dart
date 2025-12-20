import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/studio_provider.dart';

/// عرض رصيد المستخدم
class CreditBalanceWidget extends ConsumerWidget {
  final bool compact;

  const CreditBalanceWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsAsync = ref.watch(userCreditsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return creditsAsync.when(
      data: (credits) {
        if (compact) {
          return _buildCompact(context, credits.balance);
        }
        return _buildFull(context, credits.balance, credits.totalSpent);
      },
      loading: () => compact
          ? const SizedBox(width: 60, child: LinearProgressIndicator())
          : const Center(child: CircularProgressIndicator()),
      error: (_, __) => compact
          ? Icon(Icons.error_outline, color: colorScheme.error, size: 20)
          : Center(
              child: Text(
                'خطأ في تحميل الرصيد',
                style: TextStyle(color: colorScheme.error),
              ),
            ),
    );
  }

  Widget _buildCompact(BuildContext context, int balance) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLow = balance < 100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLow
            ? colorScheme.errorContainer.withOpacity(0.5)
            : colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLow
              ? colorScheme.error.withOpacity(0.3)
              : colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.toll,
            size: 16,
            color: isLow ? colorScheme.error : colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            _formatBalance(balance),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isLow
                  ? colorScheme.onErrorContainer
                  : colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFull(BuildContext context, int balance, int totalSpent) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLow = balance < 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLow
              ? [colorScheme.errorContainer, colorScheme.error.withOpacity(0.3)]
              : [
                  colorScheme.primaryContainer,
                  colorScheme.primary.withOpacity(0.3),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isLow ? colorScheme.error : colorScheme.primary)
                .withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.toll,
                  color: isLow ? colorScheme.error : colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رصيدك الحالي',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    _formatBalance(balance),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (isLow)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'منخفض',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                context,
                'مستخدم',
                _formatBalance(totalSpent),
                Icons.trending_down,
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                context,
                'متبقي',
                '${((balance / (balance + totalSpent)) * 100).round()}%',
                Icons.pie_chart_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: colorScheme.onPrimaryContainer.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatBalance(int balance) {
    if (balance >= 1000) {
      return '${(balance / 1000).toStringAsFixed(1)}K';
    }
    return balance.toString();
  }
}

/// بطاقة تكلفة العملية
class CreditCostCard extends StatelessWidget {
  final int cost;
  final String operation;
  final int? currentBalance;
  final VoidCallback? onProceed;

  const CreditCostCard({
    super.key,
    required this.cost,
    required this.operation,
    this.currentBalance,
    this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasEnough = currentBalance == null || currentBalance! >= cost;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasEnough
              ? colorScheme.outline.withOpacity(0.2)
              : colorScheme.error.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.toll,
                size: 20,
                color: hasEnough ? colorScheme.primary : colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                '$cost نقطة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: hasEnough ? colorScheme.onSurface : colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            operation,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
          if (!hasEnough) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber, size: 16, color: colorScheme.error),
                  const SizedBox(width: 6),
                  Text(
                    'رصيدك غير كافٍ (${currentBalance ?? 0})',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (onProceed != null && hasEnough) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onProceed,
                child: const Text('متابعة'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// قائمة أسعار العمليات
class CreditPricingList extends StatelessWidget {
  const CreditPricingList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final pricing = [
      ('توليد سيناريو', 10, Icons.auto_awesome),
      ('توليد صورة', 5, Icons.image),
      ('توليد صوت', 8, Icons.mic),
      ('توليد فيديو UGC', 50, Icons.person_outline),
      ('تصدير فيديو (عادي)', 10, Icons.movie_creation),
      ('تصدير فيديو (HD)', 20, Icons.hd),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.price_change, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'جدول الأسعار',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          ...pricing.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.$3, size: 18, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.$1,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${item.$2}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
