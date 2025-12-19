import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import '../../../../shared/widgets/skeleton_loading.dart';
import '../../../merchant/data/merchant_store_provider.dart';
import '../../../merchant/domain/models/store.dart';

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    🎨 Glass Design - Oxford Blue Theme                    ║
// ║                                                                           ║
// ║   تصميم زجاجي حديث مع ألوان Oxford Blue                                  ║
// ║   تاريخ التحديث: 19 ديسمبر 2025                                          ║
// ║   ملاحظة: الهيدر العلوي موجود في DashboardShell                          ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

/// ألوان التصميم الجديد
class _HomeColors {
  static const Color primary = Color(0xFF00214A); // Oxford Blue
  static const Color surfaceLight = Color(0xFFF8FAFC);
}

/// الصفحة الرئيسية للتاجر - تصميم زجاجي
class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await ref
        .read(merchantStoreControllerProvider.notifier)
        .loadMerchantStore();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeState = ref.watch(merchantStoreControllerProvider);
    final store = storeState.store;

    return Scaffold(
      backgroundColor: _HomeColors.surfaceLight,
      body: Stack(
        children: [
          // خلفية الـ Blobs
          _buildBackgroundBlobs(),
          // المحتوى الرئيسي
          RefreshIndicator(
            onRefresh: _loadData,
            color: _HomeColors.primary,
            child: _isLoading
                ? const SkeletonHomeDashboard()
                : CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // المحتوى (بدون Header - موجود في الـ shell)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 16),
                            // رابط المتجر
                            _buildStoreLinkCard(store?.name ?? 'mbuy'),
                            const SizedBox(height: 12),
                            // شبكة الإحصائيات
                            _buildStatsGrid(context, store),
                            const SizedBox(height: 12),
                            // شبكة الأيقونات
                            _buildFeaturesGrid(context),
                            const SizedBox(height: 100),
                          ]),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// خلفية الـ Blobs الملونة
  Widget _buildBackgroundBlobs() {
    return Stack(
      children: [
        // خلفية ثابتة
        Container(color: _HomeColors.surfaceLight),
        // Blob أزرق في الأعلى
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade300.withValues(alpha: 0.3),
            ),
          ),
        ),
        // Blob بنفسجي في المنتصف
        Positioned(
          bottom: 200,
          left: -100,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple.shade300.withValues(alpha: 0.3),
            ),
          ),
        ),
        // Blob سماوي
        Positioned(
          top: 300,
          right: 50,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.cyan.shade200.withValues(alpha: 0.3),
            ),
          ),
        ),
        // تأثير الضبابية
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  /// بطاقة رابط المتجر
  Widget _buildStoreLinkCard(String storeName) {
    final storeSlug = storeName.replaceAll(' ', '-').toLowerCase();
    final storeUrl = 'tabayu.com/$storeSlug';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // أزرار المشاركة والنسخ
          Row(
            children: [
              // زر المشاركة
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  SharePlus.instance.share(
                    ShareParams(text: 'تسوق من متجري: https://$storeUrl'),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _HomeColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.share,
                    size: 18,
                    color: _HomeColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // زر النسخ
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(ClipboardData(text: storeUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('تم نسخ الرابط'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _HomeColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.copy,
                    size: 18,
                    color: _HomeColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // الرابط
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رابط المتجر',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  storeUrl,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _HomeColors.primary,
                    fontFamily: 'monospace',
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// شبكة الإحصائيات
  Widget _buildStatsGrid(BuildContext context, Store? store) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                value: '0.00',
                suffix: 'ر.س',
                label: 'الرصيد',
                onTap: () => context.push('/dashboard/wallet'),
                hasBlob: true,
                blobColor: Colors.blue.shade400,
                blobAlignment: Alignment.topRight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                value: '0',
                suffix: 'نقطة',
                label: 'النقاط',
                onTap: () => context.push('/dashboard/points'),
                hasBlob: true,
                blobColor: Colors.purple.shade400,
                blobAlignment: Alignment.bottomLeft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                value: '${store?.followersCount ?? 0}',
                suffix: '',
                label: 'العملاء',
                onTap: () => context.push('/dashboard/customers'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                value: '0',
                suffix: '',
                label: 'المبيعات',
                onTap: () => context.push('/dashboard/sales'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String suffix,
    required String label,
    required VoidCallback onTap,
    bool hasBlob = false,
    Color? blobColor,
    Alignment? blobAlignment,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (hasBlob && blobColor != null)
              Positioned(
                top: blobAlignment == Alignment.topRight ? -20 : null,
                right: blobAlignment == Alignment.topRight ? -20 : null,
                bottom: blobAlignment == Alignment.bottomLeft ? -20 : null,
                left: blobAlignment == Alignment.bottomLeft ? -20 : null,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: blobColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _HomeColors.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (suffix.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          suffix,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// شبكة الميزات (6 أيقونات)
  Widget _buildFeaturesGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.info_outline,
                label: 'من نحن',
                onTap: () => context.push('/dashboard/about'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.receipt_long,
                label: 'السجلات\nوالتقارير',
                onTap: () => context.push('/dashboard/reports'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.campaign,
                label: 'التسويق',
                onTap: () => context.push('/dashboard/marketing'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.store,
                label: 'المتجر',
                onTap: () => context.push('/dashboard/store-tools'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.auto_awesome,
                label: 'توليد AI',
                onTap: () => context.push('/dashboard/studio'),
                showBadge: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.card_giftcard,
                label: 'حزم التوفير',
                onTap: () => context.push('/dashboard/packages'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.9),
              const Color(0xFFF0F9FF).withValues(alpha: 0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: _HomeColors.primary.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Blob خلفي
            Positioned(
              top: -16,
              right: -16,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade600.withValues(alpha: 0.05),
                ),
              ),
            ),
            // Badge
            if (showBadge)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.6),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            // المحتوى
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _HomeColors.primary.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _HomeColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Icon(icon, size: 22, color: _HomeColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _HomeColors.primary,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
