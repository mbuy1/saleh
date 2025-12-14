import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// نموذج الإشعار
class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final Map<String, dynamic>? data;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.data,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',
      isRead: json['is_read'] ?? false,
      data: json['data'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  IconData get icon {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'product':
        return Icons.inventory_2;
      case 'payment':
        return Icons.payment;
      case 'promotion':
        return Icons.campaign;
      case 'system':
        return Icons.settings;
      case 'chat':
        return Icons.chat;
      default:
        return Icons.notifications;
    }
  }

  Color get color {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'product':
        return Colors.green;
      case 'payment':
        return Colors.purple;
      case 'promotion':
        return Colors.orange;
      case 'system':
        return Colors.grey;
      case 'chat':
        return Colors.teal;
      default:
        return AppTheme.primaryColor;
    }
  }
}

/// شاشة الإشعارات
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ApiService _api = ApiService();

  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  String? _error;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _api.get('/secure/notifications');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          _notifications = (data['data'] as List)
              .map((item) => NotificationItem.fromJson(item))
              .toList();
          _unreadCount = _notifications.where((n) => !n.isRead).length;
        }
      }
    } catch (e) {
      _error = 'حدث خطأ في تحميل الإشعارات';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead(String id) async {
    try {
      await _api.post('/secure/notifications/$id/read');
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == id);
        if (index != -1) {
          _notifications[index] = NotificationItem(
            id: _notifications[index].id,
            title: _notifications[index].title,
            body: _notifications[index].body,
            type: _notifications[index].type,
            isRead: true,
            data: _notifications[index].data,
            createdAt: _notifications[index].createdAt,
          );
          _unreadCount = _notifications.where((n) => !n.isRead).length;
        }
      });
    } catch (e) {
      // Ignore errors
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _api.post('/secure/notifications/mark-all-read');
      HapticFeedback.lightImpact();
      setState(() {
        _notifications = _notifications
            .map(
              (n) => NotificationItem(
                id: n.id,
                title: n.title,
                body: n.body,
                type: n.type,
                isRead: true,
                data: n.data,
                createdAt: n.createdAt,
              ),
            )
            .toList();
        _unreadCount = 0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تعيين الكل كمقروء'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    _markAsRead(notification.id);

    // Navigate based on type
    switch (notification.type) {
      case 'order':
        if (notification.data?['order_id'] != null) {
          context.push('/dashboard/orders/${notification.data!['order_id']}');
        }
        break;
      case 'product':
        if (notification.data?['product_id'] != null) {
          context.push(
            '/dashboard/products/${notification.data!['product_id']}',
          );
        }
        break;
      case 'chat':
        context.push('/dashboard/conversations');
        break;
      default:
        // Show detail modal
        _showNotificationDetail(notification);
    }
  }

  void _showNotificationDetail(NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notification.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(notification.icon, color: notification.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatDate(notification.createdAt),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(notification.body, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';

    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          title: Row(
            children: [
              const Text('الإشعارات'),
              if (_unreadCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$_unreadCount',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
          actions: [
            if (_unreadCount > 0)
              TextButton(
                onPressed: _markAllAsRead,
                child: const Text('قراءة الكل'),
              ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'الحديثة'),
              Tab(text: 'إشعارات المنصة'),
              Tab(text: 'أنشطة العملاء'),
              Tab(text: 'إعدادات الإشعارات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBody(filter: 'all'),
            _buildBody(filter: 'platform'),
            _buildBody(filter: 'customer'),
            _buildSettingsPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody({String filter = 'all'}) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotifications,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    // Filter logic
    List<NotificationItem> filteredList = _notifications;
    if (filter == 'platform') {
      filteredList = _notifications
          .where((n) => ['system', 'promotion'].contains(n.type))
          .toList();
    } else if (filter == 'customer') {
      filteredList = _notifications
          .where(
            (n) => ['order', 'chat', 'payment', 'product'].contains(n.type),
          )
          .toList();
    }

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              filter == 'all'
                  ? 'لا توجد إشعارات'
                  : 'لا توجد إشعارات في هذا القسم',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ستظهر إشعاراتك هنا',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final notification = filteredList[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildSettingsPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'إعدادات الإشعارات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text('قريباً...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Material(
      color: notification.isRead ? Colors.white : Colors.blue.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: notification.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(notification.createdAt),
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
