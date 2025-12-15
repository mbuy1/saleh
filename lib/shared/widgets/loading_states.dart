import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_dimensions.dart';

/// Wrapper موحد لحالات التحميل
/// يوفر skeleton loader موحد عبر التطبيق
class LoadingWrapper extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;

  const LoadingWrapper({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const SkeletonLoader();
    }
    return child;
  }
}

/// Skeleton Loader موحد
class SkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double? height;

  const SkeletonLoader({
    super.key,
    this.itemCount = 3,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppDimensions.screenPadding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacing16),
          child: _SkeletonItem(height: height),
        );
      },
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  final double? height;

  const _SkeletonItem({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: AppDimensions.borderRadiusM,
      ),
    );
  }
}

/// Circular Loading Indicator موحد
class AppLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;

  const AppLoadingIndicator({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? AppDimensions.iconL,
        height: size ?? AppDimensions.iconL,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}

