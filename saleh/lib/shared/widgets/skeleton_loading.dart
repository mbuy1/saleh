import 'package:flutter/material.dart';

/// Shared Shimmer Controller Provider
/// يوفر AnimationController مشترك لجميع ShimmerEffect widgets
/// لتقليل استهلاك الموارد
class ShimmerControllerProvider extends StatefulWidget {
  final Widget child;

  const ShimmerControllerProvider({super.key, required this.child});

  @override
  State<ShimmerControllerProvider> createState() =>
      _ShimmerControllerProviderState();

  /// الحصول على الـ animation من الـ context
  static Animation<double>? of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ShimmerAnimation>();
    return inherited?.animation;
  }
}

class _ShimmerControllerProviderState extends State<ShimmerControllerProvider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShimmerAnimation(animation: _animation, child: widget.child);
  }
}

class _ShimmerAnimation extends InheritedWidget {
  final Animation<double> animation;

  const _ShimmerAnimation({required this.animation, required super.child});

  @override
  bool updateShouldNotify(_ShimmerAnimation oldWidget) => false;
}

/// A shimmer effect widget for skeleton loading
/// يستخدم AnimationController مشترك إذا كان متوفراً
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  AnimationController? _localController;
  Animation<double>? _localAnimation;
  bool _useSharedController = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // التحقق من وجود controller مشترك
    final sharedAnimation = ShimmerControllerProvider.of(context);
    if (sharedAnimation != null) {
      _useSharedController = true;
      // التخلص من الـ controller المحلي إذا كان موجوداً
      _localController?.dispose();
      _localController = null;
      _localAnimation = null;
    } else if (_localController == null) {
      // إنشاء controller محلي فقط إذا لم يكن هناك controller مشترك
      _useSharedController = false;
      _localController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..repeat();

      _localAnimation = Tween<double>(begin: -2, end: 2).animate(
        CurvedAnimation(parent: _localController!, curve: Curves.easeInOutSine),
      );
    }
  }

  @override
  void dispose() {
    _localController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        widget.baseColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final highlightColor =
        widget.highlightColor ??
        (isDark ? Colors.grey[700]! : Colors.grey[100]!);

    // استخدام الـ animation المشترك أو المحلي
    final animation = _useSharedController
        ? ShimmerControllerProvider.of(context)!
        : _localAnimation!;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [0.0, 0.5 + (animation.value * 0.25), 1.0],
              transform: _SlidingGradientTransform(animation.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// Basic skeleton box with shimmer effect
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerEffect(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[300],
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Skeleton for text lines
class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final int lines;
  final double spacing;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 14,
    this.lines = 1,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    if (lines == 1) {
      return SkeletonBox(
        width: width,
        height: height,
        borderRadius: BorderRadius.circular(4),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        // Last line is shorter
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: SkeletonBox(
            width: isLast ? (width != null ? width! * 0.7 : null) : width,
            height: height,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Skeleton for circular avatars
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

/// Skeleton for cards
class SkeletonCard extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsets? padding;
  final Widget? child;

  const SkeletonCard({
    super.key,
    this.width,
    this.height = 120,
    this.padding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: child,
    );
  }
}

/// Skeleton for list items with avatar and text
class SkeletonListTile extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final double avatarSize;

  const SkeletonListTile({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.avatarSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          if (hasLeading) ...[
            SkeletonCircle(size: avatarSize),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 150, height: 16),
                const SizedBox(height: 8),
                SkeletonText(width: 100, height: 12),
              ],
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 12),
            SkeletonBox(width: 60, height: 24),
          ],
        ],
      ),
    );
  }
}

/// Skeleton for product grid items
class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      height: 220,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          SkeletonBox(
            height: 140,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                SkeletonText(width: 80, height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for order cards
class SkeletonOrderCard extends StatelessWidget {
  const SkeletonOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonText(width: 100, height: 16),
              SkeletonBox(
                width: 70,
                height: 24,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          const Spacer(),
          SkeletonText(width: 150, height: 14),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonText(width: 80, height: 14),
              SkeletonText(width: 60, height: 18),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton for stats cards
class SkeletonStatsCard extends StatelessWidget {
  const SkeletonStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonText(width: 60, height: 12),
          const SizedBox(height: 12),
          SkeletonText(width: 80, height: 24),
          const SizedBox(height: 8),
          SkeletonText(width: 100, height: 10),
        ],
      ),
    );
  }
}

/// Skeleton for conversation list items
class SkeletonConversationItem extends StatelessWidget {
  const SkeletonConversationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          const SkeletonCircle(size: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonText(width: 120, height: 16),
                    SkeletonText(width: 50, height: 12),
                  ],
                ),
                const SizedBox(height: 8),
                SkeletonText(width: double.infinity, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for home tab dashboard
/// يستخدم ShimmerControllerProvider لمشاركة AnimationController
class SkeletonHomeDashboard extends StatelessWidget {
  const SkeletonHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerControllerProvider(
      child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store info card
          SkeletonCard(
            height: 100,
            child: Row(
              children: [
                const SkeletonCircle(size: 60),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonText(width: 150, height: 18),
                      const SizedBox(height: 8),
                      SkeletonText(width: 200, height: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats row
          Row(
            children: [
              const Expanded(child: SkeletonStatsCard()),
              const SizedBox(width: 12),
              const Expanded(child: SkeletonStatsCard()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: SkeletonStatsCard()),
              const SizedBox(width: 12),
              const Expanded(child: SkeletonStatsCard()),
            ],
          ),
          const SizedBox(height: 24),

          // Section title
          SkeletonText(width: 120, height: 18),
          const SizedBox(height: 16),

          // Grid items
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
            children: List.generate(
              6,
              (index) => SkeletonCard(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SkeletonCircle(size: 40),
                    const SizedBox(height: 8),
                    SkeletonText(width: 60, height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

/// Skeleton for orders list
class SkeletonOrdersList extends StatelessWidget {
  final int count;

  const SkeletonOrdersList({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (_, index) => const SkeletonOrderCard(),
    );
  }
}

/// Skeleton for conversations list
class SkeletonConversationsList extends StatelessWidget {
  final int count;

  const SkeletonConversationsList({super.key, this.count = 8});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: count,
      separatorBuilder: (_, index) =>
          Divider(height: 1, color: Colors.grey[200]),
      itemBuilder: (_, index) => const SkeletonConversationItem(),
    );
  }
}

/// Skeleton for products grid
class SkeletonProductsGrid extends StatelessWidget {
  final int count;

  const SkeletonProductsGrid({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: count,
      itemBuilder: (_, index) => const SkeletonProductCard(),
    );
  }
}

/// Skeleton for marketing screen (محدث ليتوافق مع التصميم الجديد)
class SkeletonMarketingScreen extends StatelessWidget {
  const SkeletonMarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick stats skeleton
          ShimmerEffect(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Popular tools section title
          ShimmerEffect(
            child: Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Popular tools horizontal list
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) => ShimmerEffect(
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // All tools section title
          ShimmerEffect(
            child: Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tools grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: List.generate(
              8,
              (_) => ShimmerEffect(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for merchant services screen
class SkeletonMerchantServices extends StatelessWidget {
  const SkeletonMerchantServices({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store info card
          SkeletonCard(
            height: 120,
            child: Row(
              children: [
                const SkeletonCircle(size: 70),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonText(width: 150, height: 20),
                      const SizedBox(height: 8),
                      SkeletonText(width: 120, height: 14),
                      const SizedBox(height: 8),
                      SkeletonBox(
                        width: 80,
                        height: 24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick stats
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 6,
                    right: index == 2 ? 0 : 6,
                  ),
                  child: SkeletonCard(
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SkeletonText(width: 40, height: 20),
                        const SizedBox(height: 4),
                        SkeletonText(width: 50, height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section
          SkeletonText(width: 100, height: 16),
          const SizedBox(height: 12),

          // List items
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SkeletonCard(
                height: 60,
                child: Row(
                  children: [
                    const SkeletonCircle(size: 40),
                    const SizedBox(width: 12),
                    Expanded(child: SkeletonText(width: 120, height: 16)),
                    const SkeletonBox(width: 24, height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
