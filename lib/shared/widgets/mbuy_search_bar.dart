import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MbuySearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const MbuySearchBar({
    super.key,
    this.hintText = 'البحث',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // زوايا دائرية كاملة
        border: Border.all(color: MbuyColors.border, width: 1),
      ),
      child: TextField(
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: MbuyColors.textTertiary),
          prefixIcon:
              prefixIcon ??
              const Icon(Icons.search, color: MbuyColors.textSecondary),
          suffixIcon:
              suffixIcon ??
              const Icon(
                Icons.camera_alt_outlined,
                color: MbuyColors.textSecondary,
              ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
