import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import 'notifications_screen.dart';
import '../../../conversations/presentation/screens/conversations_screen.dart';

/// شاشة الوارد الموحدة - تجمع الإشعارات والمحادثات
///
/// تحتوي على تبويبين:
/// 1. الإشعارات - عرض الإشعارات من NotificationsScreen
/// 2. المحادثات - عرض المحادثات من ConversationsScreen
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor, size: 24),
        title: const Text(
          'الوارد',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppTheme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
          indicatorColor: AppTheme.primaryColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIcons.notifications,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      _tabController.index == 0
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('الإشعارات'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIcons.chat,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      _tabController.index == 1
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('المحادثات'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // تبويب الإشعارات - نستخدم محتوى NotificationsScreen بدون AppBar
          NotificationsScreen(showAppBar: false),
          // تبويب المحادثات - نستخدم محتوى ConversationsScreen
          ConversationsScreen(),
        ],
      ),
    );
  }
}
