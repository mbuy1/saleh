import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'profile_button.dart';

/// شريط البحث الموحد مع أيقونة الحساب الشخصي
class MbuySearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool showProfileButton;

  const MbuySearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.showProfileButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة البحث على اليسار
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.search,
              color: MbuyColors.textSecondary,
              size: 22,
            ),
          ),
          // حقل النص في المنتصف
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              readOnly: readOnly,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MbuyColors.textPrimary,
                fontSize: 14,
                fontFamily: 'Arabic',
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: MbuyColors.textSecondary,
                  fontSize: 14,
                  fontFamily: 'Arabic',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
              ),
            ),
          ),
          // أيقونة الحساب على اليمين
          if (showProfileButton)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: ProfileButton(),
            ),
          if (!showProfileButton) const SizedBox(width: 12),
        ],
      ),
    );
  }
}
