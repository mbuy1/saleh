import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// MbuyScaffold - المكون المركزي لجميع شاشات التطبيق
/// ═══════════════════════════════════════════════════════════════════════════
///
/// هذا هو المكان المركزي لأي عنصر مشترك في جميع الشاشات
/// مثل زر عام، شريط علوي، أو أكشن مشترك.
///
/// عند الحاجة لإضافة زر في جميع الشاشات مستقبلاً، يجب إضافته هنا أولاً.
///
/// الاستخدام:
/// ```dart
/// MbuyScaffold(
///   appBar: MbuyAppBar(title: 'الصفحة الرئيسية'),
///   body: YourContent(),
///   bottomNavigationBar: YourNavBar(),
/// )
/// ```
///
/// ═══════════════════════════════════════════════════════════════════════════

class MbuyScaffold extends StatelessWidget {
  /// محتوى الشاشة الأساسي
  final Widget body;

  /// الـ AppBar في أعلى الشاشة (اختياري)
  final PreferredSizeWidget? appBar;

  /// شريط التنقل السفلي (اختياري)
  final Widget? bottomNavigationBar;

  /// الزر العائم (FAB) (اختياري)
  final Widget? floatingActionButton;

  /// موضع الزر العائم
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// لون الخلفية (افتراضي: MbuyColors.background)
  final Color? backgroundColor;

  /// هل نستخدم SafeArea؟ (افتراضي: true)
  final bool useSafeArea;

  /// هل نستخدم SafeArea في الأعلى؟ (افتراضي: true)
  final bool safeAreaTop;

  /// هل نستخدم SafeArea في الأسفل؟ (افتراضي: true)
  final bool safeAreaBottom;

  /// Drawer (القائمة الجانبية) (اختياري)
  final Widget? drawer;

  /// End Drawer (القائمة الجانبية اليسرى) (اختياري)
  final Widget? endDrawer;

  /// هل يمكن تغيير حجم body عند ظهور الكيبورد؟ (افتراضي: true)
  final bool? resizeToAvoidBottomInset;

  /// Widget إضافي فوق كل محتويات الشاشة (اختياري)
  /// يمكن استخدامه لإضافة عناصر مشتركة في المستقبل
  final Widget? overlayWidget;

  /// الهوامش الداخلية للمحتوى (اختياري)
  final EdgeInsetsGeometry? bodyPadding;

  const MbuyScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.useSafeArea = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.drawer,
    this.endDrawer,
    this.resizeToAvoidBottomInset,
    this.overlayWidget,
    this.bodyPadding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    // إضافة padding إذا كان محدداً
    if (bodyPadding != null) {
      content = Padding(padding: bodyPadding!, child: content);
    }

    // إضافة SafeArea إذا كان مفعلاً
    if (useSafeArea) {
      content = SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? MbuyColors.background,
      appBar: appBar,
      body: Stack(
        children: [
          content,
          // Widget إضافي يمكن استخدامه للعناصر المشتركة في المستقبل
          if (overlayWidget != null) Positioned.fill(child: overlayWidget!),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
