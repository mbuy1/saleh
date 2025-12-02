import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/profile_button.dart';

class GoogleMapSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  const GoogleMapSearchBar({
    super.key,
    this.hintText = 'ابحث هنا',
    this.onTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // Pill shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                // Profile Avatar (Right side in RTL)
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: ProfileButton(), // Fixed size
                ),

                const SizedBox(width: 8),

                // Search Hint (Center-ish)
                Expanded(
                  child: Text(
                    hintText,
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      color: MbuyColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),

                // Menu/Map Icon (Left side in RTL)
                if (onMenuTap != null)
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: MbuyColors.textSecondary,
                    ),
                    onPressed: onMenuTap,
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(Icons.search, color: MbuyColors.primaryPurple),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
