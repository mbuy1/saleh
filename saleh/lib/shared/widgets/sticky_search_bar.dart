import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/customer/presentation/screens/profile_screen.dart';
import '../../features/customer/presentation/screens/search_screen.dart';

/// شريط بحث sticky يظهر في جميع الصفحات
/// يحتوي على شريط البحث وأيقونة Profile
/// يدعم البحث الذكي باستخدام Cloudflare AI Search
class StickySearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onProfileTap;

  const StickySearchBar({
    super.key,
    this.hintText = 'البحث في mBuy',
    this.onChanged,
    this.onTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // شريط البحث - يأخذ المساحة المتبقية
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: MbuyColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: MbuyColors.borderLight,
                    width: 1,
                  ),
                ),
                child: TextField(
                  readOnly: onTap != null,
                  onTap: onTap ?? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                  onChanged: onChanged,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: MbuyColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: MbuyColors.textTertiary,
                      fontSize: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: MbuyColors.textSecondary,
                      size: 22,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // أيقونة Profile
            GestureDetector(
              onTap: onProfileTap ?? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: MbuyColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: MbuyColors.borderLight,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: MbuyColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

