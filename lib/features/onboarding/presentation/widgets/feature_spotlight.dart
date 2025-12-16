import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../data/onboarding_repository.dart';

/// Feature Spotlight - يعرض tooltip تعريفي لميزة جديدة
/// يظهر مرة واحدة فقط للمستخدم
class FeatureSpotlight extends ConsumerStatefulWidget {
  final String featureId;
  final String title;
  final String description;
  final Widget child;
  final SpotlightPosition position;
  final VoidCallback? onDismiss;
  final bool enabled;

  const FeatureSpotlight({
    super.key,
    required this.featureId,
    required this.title,
    required this.description,
    required this.child,
    this.position = SpotlightPosition.bottom,
    this.onDismiss,
    this.enabled = true,
  });

  @override
  ConsumerState<FeatureSpotlight> createState() => _FeatureSpotlightState();
}

class _FeatureSpotlightState extends ConsumerState<FeatureSpotlight>
    with SingleTickerProviderStateMixin {
  bool _showSpotlight = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    if (widget.enabled) {
      _checkIfShouldShow();
    }
  }

  Future<void> _checkIfShouldShow() async {
    final repository = ref.read(onboardingRepositoryProvider);
    final hasSeen = await repository.hasSeenFeatureTooltip(widget.featureId);
    if (!hasSeen && mounted) {
      // تأخير قصير لإظهار الـ spotlight بعد بناء الـ UI
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _showSpotlight = true);
        _animationController.forward();
      }
    }
  }

  Future<void> _dismissSpotlight() async {
    HapticFeedback.lightImpact();
    await _animationController.reverse();
    if (mounted) {
      setState(() => _showSpotlight = false);
    }
    final repository = ref.read(onboardingRepositoryProvider);
    await repository.markFeatureTooltipSeen(widget.featureId);
    widget.onDismiss?.call();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showSpotlight) {
      return widget.child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        Positioned(
          left: widget.position == SpotlightPosition.left ? null : 0,
          right: widget.position == SpotlightPosition.right ? null : 0,
          top: widget.position == SpotlightPosition.bottom ? null : null,
          bottom: widget.position == SpotlightPosition.top ? null : null,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: _getAlignment(),
              child: _buildTooltip(),
            ),
          ),
        ),
      ],
    );
  }

  Alignment _getAlignment() {
    switch (widget.position) {
      case SpotlightPosition.top:
        return Alignment.bottomCenter;
      case SpotlightPosition.bottom:
        return Alignment.topCenter;
      case SpotlightPosition.left:
        return Alignment.centerRight;
      case SpotlightPosition.right:
        return Alignment.centerLeft;
    }
  }

  Widget _buildTooltip() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _dismissSpotlight,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AppIcon(
                        AppIcons.sparkle,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _dismissSpotlight,
                      child: AppIcon(
                        AppIcons.close,
                        size: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'انقر للإغلاق',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum SpotlightPosition { top, bottom, left, right }

/// Spotlight بسيط يظهر فوق العنصر مباشرة
class SimpleSpotlight extends ConsumerStatefulWidget {
  final String featureId;
  final String message;
  final Widget child;
  final bool enabled;

  const SimpleSpotlight({
    super.key,
    required this.featureId,
    required this.message,
    required this.child,
    this.enabled = true,
  });

  @override
  ConsumerState<SimpleSpotlight> createState() => _SimpleSpotlightState();
}

class _SimpleSpotlightState extends ConsumerState<SimpleSpotlight> {
  bool _showBadge = false;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _checkIfShouldShow();
    }
  }

  Future<void> _checkIfShouldShow() async {
    final repository = ref.read(onboardingRepositoryProvider);
    final hasSeen = await repository.hasSeenFeatureTooltip(widget.featureId);
    if (!hasSeen && mounted) {
      setState(() => _showBadge = true);
    }
  }

  Future<void> _markSeen() async {
    final repository = ref.read(onboardingRepositoryProvider);
    await repository.markFeatureTooltipSeen(widget.featureId);
    if (mounted) {
      setState(() => _showBadge = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showBadge ? _markSeen : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_showBadge)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Text(
                  '!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// شاشة "ما الجديد" تظهر بعد التحديث
class WhatsNewBottomSheet extends StatelessWidget {
  final List<NewFeature> features;
  final VoidCallback onDismiss;

  const WhatsNewBottomSheet({
    super.key,
    required this.features,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context,
    List<NewFeature> features,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WhatsNewBottomSheet(
        features: features,
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.metallicGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppIcon(
                    AppIcons.sparkle,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'ما الجديد؟ 🎉',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'اكتشف الميزات الجديدة في هذا التحديث',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Features List
          ...features.map((feature) => _buildFeatureItem(feature)),

          // Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onDismiss();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'رائع، فهمت!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(NewFeature feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: AppIcon(
                _getIconPath(feature.icon),
                size: 24,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  feature.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIconPath(String iconName) {
    switch (iconName) {
      case 'search':
        return AppIcons.search;
      case 'shortcuts':
        return AppIcons.shortcuts;
      case 'bot':
        return AppIcons.bot;
      default:
        return AppIcons.sparkle;
    }
  }
}
