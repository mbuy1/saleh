import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/exports.dart';

/// شاشة الوارد الموحدة - تجمع الإشعارات والمحادثات
///
/// تحتوي على تبويبين:
/// 1. الإشعارات - عرض الإشعارات
/// 2. المحادثات - عرض المحادثات
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
        children: [
          // تبويب الإشعارات
          _buildNotificationsTab(),
          // تبويب المحادثات
          _buildConversationsTab(),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 64,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر إشعاراتك هنا',
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد محادثات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر المحادثات هنا عند التواصل مع العملاء',
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
