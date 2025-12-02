import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class AlibabaSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final VoidCallback? onMicTap;
  final VoidCallback? onCameraTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const AlibabaSearchBar({
    super.key,
    this.hintText = 'ابحث في mBuy...',
    this.onTap,
    this.onMicTap,
    this.onCameraTap,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MbuyColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Mic Icon (Right in RTL)
                IconButton(
                  icon: const Icon(
                    Icons.mic_none,
                    color: MbuyColors.primaryPurple,
                  ),
                  onPressed: onMicTap,
                  tooltip: 'بحث صوتي',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                const SizedBox(width: 8),

                // Search Field
                Expanded(
                  child: controller != null
                      ? TextField(
                          controller: controller,
                          onChanged: onChanged,
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: GoogleFonts.cairo(
                              color: MbuyColors.textSecondary,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: GoogleFonts.cairo(
                            color: MbuyColors.textPrimary,
                            fontSize: 14,
                          ),
                        )
                      : Text(
                          hintText,
                          style: GoogleFonts.cairo(
                            color: MbuyColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                ),

                const SizedBox(width: 8),

                // Camera Icon (Left in RTL)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 20,
                      color: MbuyColors.textSecondary,
                    ),
                    onPressed: onCameraTap,
                    tooltip: 'بحث بالصورة',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),

                const SizedBox(width: 4),

                // Search Button
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    gradient: MbuyColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
