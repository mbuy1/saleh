import 'package:flutter/material.dart';

/// Skeleton Loader Widget
/// يعرض placeholder أثناء التحميل
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: ShimmerEffect(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

/// Shimmer Effect Animation
class ShimmerEffect extends StatefulWidget {
  final Widget child;

  const ShimmerEffect({super.key, required this.child});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0.0),
              end: Alignment(1.0 - _controller.value * 2, 0.0),
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Skeleton Product Card
class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          const SkeletonLoader(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                const SkeletonLoader(width: double.infinity, height: 16),
                const SizedBox(height: 8),
                const SkeletonLoader(width: 120, height: 16),
                const SizedBox(height: 12),
                // Price
                const SkeletonLoader(width: 80, height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton List Item
class SkeletonListItem extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;

  const SkeletonListItem({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: hasLeading
          ? const SkeletonLoader(width: 48, height: 48, borderRadius: BorderRadius.all(Radius.circular(24)))
          : null,
      title: const SkeletonLoader(width: double.infinity, height: 16),
      subtitle: const Padding(
        padding: EdgeInsets.only(top: 8),
        child: SkeletonLoader(width: 200, height: 12),
      ),
      trailing: hasTrailing
          ? const SkeletonLoader(width: 60, height: 16)
          : null,
    );
  }
}

/// Skeleton Banner
class SkeletonBanner extends StatelessWidget {
  final double height;

  const SkeletonBanner({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: double.infinity,
      height: height,
      borderRadius: BorderRadius.circular(12),
    );
  }
}

/// Skeleton Grid
class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  const SkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonProductCard(),
    );
  }
}

