import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/exports.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return MbuyScaffold(
      showAppBar: false,
      body: SafeArea(
        child: Column(
          children: [
            _buildSubPageHeader(context, title),
            Expanded(
              child: MbuyEmptyState(
                icon: Icons.construction_outlined,
                title: title,
                subtitle: 'هذه الصفحة قيد التطوير\nسيتم إطلاقها قريباً',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubPageHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimensions.iconS,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          const SizedBox(width: AppDimensions.iconM + AppDimensions.spacing16),
        ],
      ),
    );
  }
}
