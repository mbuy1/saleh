import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ============================================================================
/// Page Transitions - انتقالات الصفحات
/// ============================================================================
///
/// يوفر:
/// - انتقالات سلسة بين الصفحات
/// - أنواع متعددة من الانتقالات
/// - دعم RTL
/// - أداء محسن

/// أنواع انتقالات الصفحات
enum PageTransitionType {
  /// انتقال بالتلاشي
  fade,

  /// انتقال من اليمين لليسار (RTL-aware)
  slideRight,

  /// انتقال من الأسفل للأعلى
  slideUp,

  /// انتقال بالتكبير
  scale,

  /// انتقال مدمج (تلاشي + انزلاق)
  fadeSlide,

  /// بدون انتقال
  none,
}

/// مدة الانتقالات
class TransitionDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);
}

/// إنشاء صفحة مع انتقال مخصص
CustomTransitionPage<T> buildPageWithTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  PageTransitionType type = PageTransitionType.fadeSlide,
  Duration? duration,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration ?? TransitionDurations.normal,
    reverseTransitionDuration: duration ?? TransitionDurations.normal,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _buildTransition(
        context: context,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
        type: type,
      );
    },
  );
}

/// بناء الانتقال حسب النوع
Widget _buildTransition({
  required BuildContext context,
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Widget child,
  required PageTransitionType type,
}) {
  switch (type) {
    case PageTransitionType.fade:
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );

    case PageTransitionType.slideRight:
      // RTL-aware slide
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      final beginOffset = isRtl ? const Offset(-1, 0) : const Offset(1, 0);

      return SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );

    case PageTransitionType.slideUp:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );

    case PageTransitionType.scale:
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        )),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );

    case PageTransitionType.fadeSlide:
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      final beginOffset = isRtl ? const Offset(-0.1, 0) : const Offset(0.1, 0);

      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        ),
      );

    case PageTransitionType.none:
      return child;
  }
}

/// انتقال مخصص للـ Bottom Sheets
class BottomSheetTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const BottomSheetTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: child,
    );
  }
}

/// انتقال مخصص للـ Dialogs
class DialogTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const DialogTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// Hero-like transition للعناصر المشتركة
class SharedElementTransition extends StatelessWidget {
  final String tag;
  final Widget child;

  const SharedElementTransition({
    super.key,
    required this.tag,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.0).animate(animation),
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Extension لتسهيل استخدام الانتقالات مع GoRouter
extension GoRouterTransitionExtension on GoRoute {
  /// إنشاء GoRoute مع انتقال مخصص
  static GoRoute withTransition({
    required String path,
    String? name,
    required Widget Function(BuildContext, GoRouterState) builder,
    PageTransitionType type = PageTransitionType.fadeSlide,
    Duration? duration,
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => buildPageWithTransition(
        context: context,
        state: state,
        child: builder(context, state),
        type: type,
        duration: duration,
      ),
      routes: routes,
    );
  }
}

/// Animated Widget Wrapper للانتقالات داخل الصفحة
class AnimatedPageContent extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const AnimatedPageContent({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedPageContent> createState() => _AnimatedPageContentState();
}

class _AnimatedPageContentState extends State<AnimatedPageContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Staggered Animation للقوائم
class StaggeredListAnimation extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int, Animation<double>) itemBuilder;
  final Duration itemDelay;
  final Duration itemDuration;
  final ScrollController? scrollController;

  const StaggeredListAnimation({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 300),
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return _StaggeredItem(
          index: index,
          delay: itemDelay,
          duration: itemDuration,
          builder: (animation) => itemBuilder(context, index, animation),
        );
      },
    );
  }
}

class _StaggeredItem extends StatefulWidget {
  final int index;
  final Duration delay;
  final Duration duration;
  final Widget Function(Animation<double>) builder;

  const _StaggeredItem({
    required this.index,
    required this.delay,
    required this.duration,
    required this.builder,
  });

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    Future.delayed(widget.delay * widget.index, () {
      if (mounted) {
        _controller.forward();
      }
    });
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
        return FadeTransition(
          opacity: _controller,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOutCubic,
            )),
            child: widget.builder(_controller),
          ),
        );
      },
    );
  }
}
