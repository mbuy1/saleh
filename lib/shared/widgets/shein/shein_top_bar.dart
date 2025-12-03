import 'package:flutter/material.dart';

/// شريط علوي SHEIN Style
/// يحتوي على شعار في المنتصف وأيقونات على الجانبين
class SheinTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? logoText;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const SheinTopBar({
    super.key,
    this.logoText = 'mBuy',
    this.leading,
    this.actions,
    this.backgroundColor = Colors.white,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: leading ?? const SizedBox.shrink(),
      title: Text(
        logoText ?? 'mBuy',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      actions: actions ?? [],
    );
  }
}

