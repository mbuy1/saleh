import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class SectionBuilder extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onViewMore;
  final Widget content;
  final Color backgroundColor;

  const SectionBuilder({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onViewMore,
    required this.content,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: MbuyColors.primaryPurple, size: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MbuyColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: MbuyColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (onViewMore != null)
                  TextButton(
                    onPressed: onViewMore,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(60, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'المزيد',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: MbuyColors.primaryPurple,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: MbuyColors.primaryPurple,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          content,
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
