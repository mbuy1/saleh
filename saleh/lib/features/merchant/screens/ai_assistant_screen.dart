import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isSending = false;
  String? _error;

  List<Map<String, dynamic>> _conversations = [];
  Map<String, dynamic>? _activeConversation;
  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _quickCommands = [];

  // Drawer state
  bool _showConversations = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _api.get('/secure/ai/conversations'),
        _api.get('/secure/ai/commands'),
      ]);

      if (!mounted) return;

      final convsRes = jsonDecode(results[0].body);
      final cmdsRes = jsonDecode(results[1].body);

      setState(() {
        _conversations = List<Map<String, dynamic>>.from(
          convsRes['data'] ?? [],
        );
        _quickCommands = List<Map<String, dynamic>>.from(cmdsRes['data'] ?? []);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadConversation(String conversationId) async {
    try {
      final response = await _api.get(
        '/secure/ai/conversations/$conversationId',
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      setState(() {
        _activeConversation = data['data'];
        _messages = List<Map<String, dynamic>>.from(
          data['data']['messages'] ?? [],
        );
        _showConversations = false;
      });

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تحميل المحادثة: $e')));
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
      _messages.add({
        'role': 'user',
        'content': message,
        'created_at': DateTime.now().toIso8601String(),
      });
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _api.post(
        '/secure/ai/chat',
        body: {
          'conversation_id': _activeConversation?['id'],
          'message': message,
        },
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      if (data['ok'] == true) {
        setState(() {
          _activeConversation ??= {'id': data['data']['conversation_id']};
          _messages.add(data['data']['message']);
          _isSending = false;
        });
        _scrollToBottom();
        _loadData(); // Refresh conversations list
      } else {
        throw Exception(data['error']);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
        _messages.add({
          'role': 'assistant',
          'content': 'عذراً، حدث خطأ. يرجى المحاولة مرة أخرى.',
          'created_at': DateTime.now().toIso8601String(),
        });
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل إرسال الرسالة: $e')));
    }
  }

  Future<void> _executeQuickCommand(Map<String, dynamic> command) async {
    setState(() => _isSending = true);

    try {
      final response = await _api.post(
        '/secure/ai/quick-command',
        body: {
          'command_id': command['id'],
          'selection': _messageController.text,
        },
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      if (data['ok'] == true) {
        setState(() {
          _messages.add({
            'role': 'user',
            'content': '${command['title']}: ${_messageController.text}',
            'created_at': DateTime.now().toIso8601String(),
          });
          _messages.add({
            'role': 'assistant',
            'content': data['data']['result'],
            'created_at': DateTime.now().toIso8601String(),
          });
          _isSending = false;
        });
        _messageController.clear();
        _scrollToBottom();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تنفيذ الأمر: $e')));
    }
  }

  void _scrollToBottom() {
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

  void _startNewConversation() {
    setState(() {
      _activeConversation = null;
      _messages = [];
      _showConversations = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_activeConversation?['title'] ?? 'مساعد AI'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () =>
              setState(() => _showConversations = !_showConversations),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'محادثة جديدة',
            onPressed: _startNewConversation,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                _showSettingsDialog();
              } else if (value == 'commands') {
                _showQuickCommandsSheet();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'commands',
                child: Text('الأوامر السريعة'),
              ),
              const PopupMenuItem(value: 'settings', child: Text('الإعدادات')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                // Conversations sidebar
                if (_showConversations)
                  Container(
                    width: 280,
                    color: Colors.white,
                    child: _buildConversationsList(),
                  ),
                // Main chat area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: _buildChatArea()),
                      _buildInputArea(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildConversationsList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'المحادثات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => setState(() => _showConversations = false),
              ),
            ],
          ),
        ),
        Expanded(
          child: _conversations.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد محادثات',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) {
                    final conv = _conversations[index];
                    final isActive = _activeConversation?['id'] == conv['id'];
                    return ListTile(
                      selected: isActive,
                      selectedTileColor: AppTheme.primaryColor.withAlpha(25),
                      leading: CircleAvatar(
                        backgroundColor: isActive
                            ? AppTheme.primaryColor
                            : Colors.grey[300],
                        child: Icon(
                          conv['is_pinned'] == true
                              ? Icons.push_pin
                              : Icons.chat_bubble_outline,
                          size: 18,
                          color: isActive ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      title: Text(
                        conv['title'] ?? 'محادثة',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        '${conv['messages_count'] ?? 0} رسالة',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      onTap: () => _loadConversation(conv['id']),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 18),
                        onSelected: (value) async {
                          if (value == 'pin') {
                            await _api.patch(
                              '/secure/ai/conversations/${conv['id']}/pin',
                              body: {},
                            );
                            _loadData();
                          } else if (value == 'delete') {
                            await _api.delete(
                              '/secure/ai/conversations/${conv['id']}',
                            );
                            if (_activeConversation?['id'] == conv['id']) {
                              _startNewConversation();
                            }
                            _loadData();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'pin',
                            child: Text(
                              conv['is_pinned'] == true
                                  ? 'إلغاء التثبيت'
                                  : 'تثبيت',
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('حذف'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildChatArea() {
    if (_messages.isEmpty) {
      return _buildWelcomeScreen();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isSending) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildWelcomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              size: 64,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'مرحباً! أنا مساعدك الذكي',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنني مساعدتك في إدارة متجرك',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          const Text(
            'جرب أن تسألني عن:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildSuggestionChip('اكتب وصف لمنتج جديد'),
              _buildSuggestionChip('أفكار لحملة تسويقية'),
              _buildSuggestionChip('تحليل مبيعات المتجر'),
              _buildSuggestionChip('رد على شكوى عميل'),
              _buildSuggestionChip('اقتراح أسعار منافسة'),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'الأوامر السريعة',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._quickCommands.take(4).map((cmd) => _buildQuickCommandCard(cmd)),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _messageController.text = text;
        _sendMessage();
      },
    );
  }

  Widget _buildQuickCommandCard(Map<String, dynamic> command) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withAlpha(25),
          child: const Icon(
            Icons.flash_on,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        title: Text(command['title'] ?? ''),
        subtitle: Text(
          command['description'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_left),
        onTap: () => _showCommandDialog(command),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['role'] == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : null,
                  bottomLeft: !isUser ? const Radius.circular(4) : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SelectableText(
                message['content'] ?? '',
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
            if (!isUser && message['id'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // Copy to clipboard
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم النسخ')),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up_outlined,
                        size: 16,
                        color: message['rating'] == 5
                            ? Colors.green
                            : Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _rateMessage(message['id'], 5),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.thumb_down_outlined,
                        size: 16,
                        color: message['rating'] == 1
                            ? Colors.red
                            : Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _rateMessage(message['id'], 1),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha((100 + (value * 155)).toInt()),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: AppTheme.primaryColor,
              tooltip: 'الأوامر السريعة',
              onPressed: _showQuickCommandsSheet,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: IconButton(
                icon: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white),
                onPressed: _isSending ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _rateMessage(String messageId, int rating) async {
    try {
      await _api.post(
        '/secure/ai/messages/$messageId/rate',
        body: {'rating': rating},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('شكراً على تقييمك!')));
    } catch (e) {
      // Ignore errors
    }
  }

  void _showQuickCommandsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'الأوامر السريعة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickCommands.length,
                itemBuilder: (context, index) {
                  final cmd = _quickCommands[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getCategoryColor(
                          cmd['category'],
                        ).withAlpha(25),
                        child: Icon(
                          _getCategoryIcon(cmd['category']),
                          color: _getCategoryColor(cmd['category']),
                          size: 20,
                        ),
                      ),
                      title: Text(cmd['title'] ?? ''),
                      subtitle: Text(cmd['description'] ?? '', maxLines: 1),
                      onTap: () {
                        Navigator.pop(context);
                        _showCommandDialog(cmd);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommandDialog(Map<String, dynamic> command) {
    final requiresSelection = command['requires_selection'] == true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(command['title'] ?? ''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(command['description'] ?? ''),
            if (requiresSelection) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'أدخل النص',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _executeQuickCommand(command);
            },
            child: const Text('تنفيذ'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعدادات المساعد'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.language),
              title: Text('اللغة'),
              subtitle: Text('العربية'),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('حذف المحادثات'),
              subtitle: Text('حذف جميع المحادثات السابقة'),
            ),
          ],
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

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'product':
        return Colors.blue;
      case 'marketing':
        return Colors.purple;
      case 'analytics':
        return Colors.orange;
      case 'support':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'product':
        return Icons.inventory;
      case 'marketing':
        return Icons.campaign;
      case 'analytics':
        return Icons.analytics;
      case 'support':
        return Icons.support_agent;
      default:
        return Icons.flash_on;
    }
  }
}
