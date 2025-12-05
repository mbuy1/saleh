import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// AppBar مشترك قابل لإعادة الاستخدام في جميع الشاشات
///
/// يدعم:
/// - عنوان مخصص
/// - أيقونات على اليمين واليسار
/// - ألوان مخصصة
/// - إخفاء زر الرجوع
class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// عنوان الـ AppBar
  final String title;

  /// Widget للعنوان (يستخدم بدلاً من title إذا تم تحديده)
  final Widget? titleWidget;

  /// أيقونات في الجانب الأيسر (في RTL تظهر على اليمين)
  final List<Widget>? actions;

  /// Widget للجانب الأيمن (في RTL يظهر على اليسار)
  final Widget? leading;

  /// لون الخلفية
  final Color? backgroundColor;

  /// لون النص والأيقونات
  final Color? foregroundColor;

  /// إظهار الظل
  final double elevation;

  /// إخفاء زر الرجوع التلقائي
  final bool automaticallyImplyLeading;

  /// توسيط العنوان
  final bool centerTitle;

  const SharedAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          titleWidget ??
          Text(
            title,
            style: TextStyle(
              color: foregroundColor ?? MbuyColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? MbuyColors.textPrimary,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: actions,
      iconTheme: IconThemeData(
        color: foregroundColor ?? MbuyColors.textPrimary,
      ),
    );
  }
}

/// AppBar مخصص للصفحة الرئيسية مع شعار mBuy
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final int notificationCount;

  const HomeAppBar({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
    this.notificationCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            color: MbuyColors.primaryMaroon,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'mBuy',
            style: TextStyle(
              color: MbuyColors.primaryMaroon,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        // أيقونة الإشعارات
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: MbuyColors.textPrimary,
              onPressed: onNotificationTap,
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    notificationCount > 9 ? '9+' : '$notificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: onProfileTap,
          child: CircleAvatar(
            backgroundColor: MbuyColors.primaryMaroon.withValues(alpha: 0.1),
            child: Icon(
              Icons.person_outline,
              color: MbuyColors.primaryMaroon,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
