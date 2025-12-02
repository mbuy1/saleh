import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../profile_button.dart';

class AlibabaHeader extends StatelessWidget implements PreferredSizeWidget {
  final TabController? tabController;
  final List<String> tabs;
  final VoidCallback? onNotificationTap;

  const AlibabaHeader({
    super.key,
    this.tabController,
    required this.tabs,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          // Tabs (Left side in LTR, Right side in RTL - but UI requirement says:
          // "From Right: Avatar. Next to it (Left): Tabs".
          // In RTL: Avatar is on Right. Tabs are to its Left.
          // So Row order: Avatar, SizedBox, Expanded(TabBar).

          // Profile Avatar
          const ProfileButton(),

          const SizedBox(width: 16),

          // Tabs
          if (tabController != null)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight, // Align tabs near the avatar
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: MbuyColors.primaryPurple,
                  indicatorWeight: 3,
                  labelColor: MbuyColors.primaryPurple,
                  unselectedLabelColor: MbuyColors.textSecondary,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                  labelStyle: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: tabs.map((t) => Tab(text: t)).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
