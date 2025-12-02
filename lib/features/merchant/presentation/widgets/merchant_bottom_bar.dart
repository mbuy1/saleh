import 'dart:ui'; // For ImageFilter (Glassmorphism)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class MerchantBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddTap;
  final VoidCallback? onStoreTap;

  const MerchantBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
    this.onStoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22), // Glass blur 22px
        child: Container(
          decoration: BoxDecoration(
            color: MbuyColors.glassBackground, // 18% transparency
            border: Border(
              top: BorderSide(color: MbuyColors.glassBorder, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 22, // Soft Premium shadow
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_filled, 'الرئيسية'),
                  _buildNavItem(1, Icons.shopping_bag_outlined, 'الطلبات'),

                  // Premium Floating FAB - 38px with elevation 14
                  GestureDetector(
                    onTap: onAddTap,
                    child: Container(
                      width: MbuyIconSizes.bottomNavigationCenter, // 38px
                      height: MbuyIconSizes.bottomNavigationCenter,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        gradient: MbuyColors.primaryGradient, // #3E37F1→#251EAA
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MbuyColors.glassBorder, // translucent white
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: MbuyColors.primaryIndigo.withValues(
                              alpha: 0.08,
                            ), // opacity 0.08
                            blurRadius: 30, // blur 30 per Super Premium spec
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  _buildNavItem(2, Icons.chat_bubble_outline, 'المحادثات'),
                  _buildNavItem(3, Icons.store, 'المتجر'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    // Adjust index for items after the center button
    final actualIndex = index > 1 ? index + 1 : index;
    final isSelected = currentIndex == actualIndex;

    // Special handling for store icon (index 3)
    if (index == 3 && icon == Icons.store) {
      return GestureDetector(
        onTap: () {
          if (onStoreTap != null) {
            onStoreTap!();
          } else {
            onTap(actualIndex);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isSelected
                    ? MbuyColors.primaryIndigo.withValues(alpha: 0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? MbuyColors.primaryIndigo
                    : MbuyColors.textSecondary,
                size: MbuyIconSizes.bottomNavigation,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? MbuyColors.primaryIndigo
                    : MbuyColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTap(actualIndex),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? MbuyColors
                      .primaryIndigo // Purple on active
                : MbuyColors.textSecondary, // Gray inactive
            size: MbuyIconSizes.bottomNavigation, // 26px per spec
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? MbuyColors.primaryIndigo
                  : MbuyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
