import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// حلقة الستوري حول Avatar المتجر
/// 
/// استخدام:
/// ```dart
/// StoryRing(
///   hasStory: true,
///   child: CircleAvatar(...),
/// )
/// ```
class StoryRing extends StatelessWidget {
  final bool hasStory;
  final Widget child;
  final double ringWidth;

  const StoryRing({
    super.key,
    required this.hasStory,
    required this.child,
    this.ringWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasStory) {
      return child;
    }

    return Container(
      padding: EdgeInsets.all(ringWidth),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: MbuyColors.primaryGradient,
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: MbuyColors.background,
        ),
        child: child,
      ),
    );
  }
}

