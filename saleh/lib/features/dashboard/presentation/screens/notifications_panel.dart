import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';

/// صفحة الإشعارات - صفحة كاملة مع زر إغلاق
class NotificationsPanel extends StatefulWidget {
  const NotificationsPanel({super.key});

  @override
  State<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel>
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
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'الإشعارات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'غير مقروءة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(showAll: true),
          _buildNotificationsList(showAll: false),
        ],
      ),
    );
  }

  Widget _buildNotificationsList({required bool showAll}) {
    final notifications = _getDummyNotifications();

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_outlined,
              size: 80,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد إشعارات',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(_NotificationItem notification) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        // معالجة النقر على الإشعار
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : AppTheme.primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    notification.title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.time,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHintColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: notification.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_NotificationItem> _getDummyNotifications() {
    return [
      _NotificationItem(
        icon: Icons.shopping_cart,
        color: Colors.green,
        title: 'طلب جديد #1234',
        message: 'تم استلام طلب جديد بقيمة 450 ر.س',
        time: 'منذ 5 دقائق',
        isRead: false,
      ),
      _NotificationItem(
        icon: Icons.inventory_2,
        color: Colors.orange,
        title: 'تنبيه مخزون',
        message: 'المنتج "هاتف آيفون 15" أوشك على النفاد',
        time: 'منذ ساعة',
        isRead: false,
      ),
      _NotificationItem(
        icon: Icons.star,
        color: Colors.blue,
        title: 'تقييم جديد',
        message: 'حصلت على تقييم 5 نجوم من أحمد محمد',
        time: 'منذ ساعتين',
        isRead: true,
      ),
    ];
  }
}

class _NotificationItem {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String time;
  final bool isRead;

  _NotificationItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
}
