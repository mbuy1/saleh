import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CircleItem extends StatelessWidget {
  final String? imageUrl;
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final double size;
  final Widget? icon;

  const CircleItem({
    super.key,
    this.imageUrl,
    required this.label,
    this.onTap,
    this.isSelected = false,
    this.size = 70,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? MbuyColors.primaryMaroon : Colors.white,
              border: Border.all(
                color: isSelected
                    ? MbuyColors.primaryMaroon
                    : MbuyColors.border,
                width: 1,
              ),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Center(
                    child:
                        icon ??
                        Icon(
                          Icons.image_not_supported_outlined,
                          color: isSelected
                              ? Colors.white
                              : MbuyColors.textTertiary,
                          size: size * 0.4,
                        ),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? MbuyColors.primaryMaroon
                  : MbuyColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
