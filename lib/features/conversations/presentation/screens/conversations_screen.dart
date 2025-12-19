import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/exports.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);
    // محاكاة تحميل البيانات
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _conversations = _getDemoConversations();
      });
    }
  }

  List<Map<String, dynamic>> _getDemoConversations() {
    return [
      {
        'id': '1',
        'customerName': 'أحمد محمد',
        'lastMessage': 'هل المنتج متوفر باللون الأزرق؟',
        'time': '10:30 ص',
        'unread': 2,
        'isOnline': true,
        'avatar': null,
      },
      {
        'id': '2',
        'customerName': 'سارة علي',
        'lastMessage': 'شكراً لكم، وصل الطلب بحالة ممتازة 👍',
        'time': '9:15 ص',
        'unread': 0,
        'isOnline': false,
        'avatar': null,
      },
      {
        'id': '3',
        'customerName': 'خالد العمري',
        'lastMessage': 'متى سيتم شحن طلبي؟',
        'time': 'أمس',
        'unread': 1,
        'isOnline': true,
        'avatar': null,
      },
      {
        'id': '4',
        'customerName': 'نورة السالم',
        'lastMessage': 'أريد استبدال المنتج بمقاس أكبر',
        'time': 'أمس',
        'unread': 0,
        'isOnline': false,
        'avatar': null,
      },
      {
        'id': '5',
        'customerName': 'عبدالله الحربي',
        'lastMessage': 'هل يوجد خصم على الكمية؟',
        'time': '15 يناير',
        'unread': 3,
        'isOnline': false,
        'avatar': null,
      },
    ];
  }

  Future<void> _refreshConversations() async {
    HapticFeedback.lightImpact();
    await _loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return MbuyScaffold(
      title: 'المحادثات',
      showAppBar: false,
      showBackButton: false,
      body: RefreshIndicator(
        onRefresh: _refreshConversations,
        color: AppTheme.accentColor,
        child: _isLoading
            ? const SkeletonConversationsList()
            : _conversations.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: AppDimensions.screenPadding,
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  return _buildConversationCard(context, index);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppDimensions.avatarProfile,
                height: AppDimensions.avatarProfile,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: AppDimensions.iconDisplay,
                  color: AppTheme.primaryColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              const Text(
                'لا توجد محادثات',
                style: TextStyle(
                  fontSize: AppDimensions.fontDisplay3,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              const Text(
                'ستظهر المحادثات هنا عند التواصل مع العملاء',
                style: TextStyle(
                  fontSize: AppDimensions.fontBody,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Text(
                'اسحب للأسفل للتحديث',
                style: TextStyle(
                  fontSize: AppDimensions.fontCaption,
                  color: AppTheme.textHintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConversationCard(BuildContext context, int index) {
    final conversation = _conversations[index];
    final hasUnread = (conversation['unread'] as int) > 0;

    return MbuyCard(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      onTap: () {
        HapticFeedback.lightImpact();
        _openChat(conversation);
      },
      child: Row(
        children: [
          Stack(
            children: [
              MbuyCircleIcon(
                icon: Icons.person,
                size: AppDimensions.avatarL,
                backgroundColor: AppTheme.primaryColor,
                iconColor: Colors.white,
              ),
              if (conversation['isOnline'] == true)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation['customerName'] ?? '',
                  style: TextStyle(
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                    fontSize: AppDimensions.fontBody,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  conversation['lastMessage'] ?? '',
                  style: TextStyle(
                    fontSize: AppDimensions.fontBody2,
                    color: hasUnread
                        ? AppTheme.textPrimaryColor
                        : AppTheme.textSecondaryColor,
                    fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                conversation['time'] ?? '',
                style: TextStyle(
                  fontSize: AppDimensions.fontLabel,
                  color: hasUnread
                      ? AppTheme.accentColor
                      : AppTheme.textHintColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing4),
              if (hasUnread)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing8,
                    vertical: AppDimensions.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusCircle,
                    ),
                  ),
                  child: Text(
                    '${conversation['unread']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppDimensions.fontCaption,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث في المحادثات'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ابحث عن اسم عميل أو رسالة...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
          onChanged: (value) {
            // يمكن تطبيق البحث في الوقت الفعلي
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _showNewConversationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusL),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              const Text(
                'محادثة جديدة',
                style: TextStyle(
                  fontSize: AppDimensions.fontHeadline,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'رقم جوال العميل',
                  hintText: '05xxxxxxxx',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'الرسالة الأولى',
                  hintText: 'اكتب رسالتك هنا...',
                  prefixIcon: const Icon(Icons.message),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppDimensions.spacing24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    MbuySnackBar.show(
                      context,
                      message: 'تم إرسال الرسالة بنجاح',
                      type: MbuySnackBarType.success,
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('إرسال'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spacing12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(Map<String, dynamic> conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ChatDetailScreen(conversation: conversation),
      ),
    );
  }
}

// شاشة تفاصيل المحادثة
class _ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> conversation;

  const _ChatDetailScreen({required this.conversation});

  @override
  State<_ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<_ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    _messages.addAll([
      {
        'id': '1',
        'text': 'السلام عليكم، أحتاج مساعدة',
        'isMe': false,
        'time': '10:00 ص',
      },
      {
        'id': '2',
        'text': 'وعليكم السلام، كيف أستطيع مساعدتك؟',
        'isMe': true,
        'time': '10:02 ص',
      },
      {
        'id': '3',
        'text': widget.conversation['lastMessage'] ?? '',
        'isMe': false,
        'time': widget.conversation['time'] ?? '',
      },
    ]);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': _messageController.text.trim(),
        'isMe': true,
        'time': 'الآن',
      });
    });
    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                if (widget.conversation['isOnline'] == true)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppDimensions.spacing8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation['customerName'] ?? '',
                  style: const TextStyle(
                    fontSize: AppDimensions.fontBody,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.conversation['isOnline'] == true
                      ? 'متصل الآن'
                      : 'غير متصل',
                  style: TextStyle(
                    fontSize: AppDimensions.fontCaption,
                    color: widget.conversation['isOnline'] == true
                        ? AppTheme.successColor
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              MbuySnackBar.show(
                context,
                message: 'جاري الاتصال...',
                type: MbuySnackBarType.info,
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'block') _showBlockDialog();
              if (value == 'clear') _showClearDialog();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red),
                    SizedBox(width: 8),
                    Text('حظر العميل'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 8),
                    Text('مسح المحادثة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['isMe'] == true;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: AppDimensions.spacing8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing12,
                      vertical: AppDimensions.spacing8,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? AppTheme.primaryColor : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(AppDimensions.radiusM),
                        topRight: const Radius.circular(AppDimensions.radiusM),
                        bottomLeft: Radius.circular(
                          isMe ? AppDimensions.radiusM : 4,
                        ),
                        bottomRight: Radius.circular(
                          isMe ? 4 : AppDimensions.radiusM,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message['text'] ?? '',
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message['time'] ?? '',
                              style: TextStyle(
                                fontSize: AppDimensions.fontCaption,
                                color: isMe
                                    ? Colors.white70
                                    : AppTheme.textHintColor,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.done_all,
                                size: 14,
                                color: Colors.white70,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: _showAttachmentOptions,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusCircle,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing16,
                          vertical: AppDimensions.spacing8,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.image, color: Colors.white),
              ),
              title: const Text('صورة من المعرض'),
              onTap: () {
                Navigator.pop(context);
                MbuySnackBar.show(
                  context,
                  message: 'اختيار صورة...',
                  type: MbuySnackBarType.info,
                );
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
              title: const Text('التقاط صورة'),
              onTap: () {
                Navigator.pop(context);
                MbuySnackBar.show(
                  context,
                  message: 'فتح الكاميرا...',
                  type: MbuySnackBarType.info,
                );
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.inventory_2, color: Colors.white),
              ),
              title: const Text('إرسال منتج'),
              onTap: () {
                Navigator.pop(context);
                MbuySnackBar.show(
                  context,
                  message: 'اختيار منتج...',
                  type: MbuySnackBarType.info,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حظر العميل'),
        content: Text('هل تريد حظر ${widget.conversation['customerName']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              MbuySnackBar.show(
                context,
                message: 'تم حظر العميل',
                type: MbuySnackBarType.warning,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حظر', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح المحادثة'),
        content: const Text('هل تريد مسح جميع الرسائل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _messages.clear());
              MbuySnackBar.show(
                context,
                message: 'تم مسح المحادثة',
                type: MbuySnackBarType.info,
              );
            },
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }
}
