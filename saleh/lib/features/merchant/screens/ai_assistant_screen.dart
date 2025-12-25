import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import 'package:go_router/go_router.dart';
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
      _isLoading = false;
      _error = null;
      // Ø¨Ø¯Ø¡ Ø¨Ø¯ÙˆÙ† Ù…Ø­Ø§Ø¯Ø«Ø§Øª - Ø§Ù„Ù…Ø³Ø§Ø¹Ø¯ Ø§Ù„Ø´Ø®ØµÙŠ ÙŠØ¹Ù…Ù„ Ù…Ø¨Ø§Ø´Ø±Ø©
      _conversations = [];
      _quickCommands = [
        {'id': '1', 'title': 'ÙƒØªØ§Ø¨Ø© ÙˆØµÙ Ù…Ù†ØªØ¬', 'icon': 'description'},
        {'id': '2', 'title': 'Ø£ÙÙƒØ§Ø± ØªØ³ÙˆÙŠÙ‚ÙŠØ©', 'icon': 'campaign'},
        {'id': '3', 'title': 'ØªØ­Ø³ÙŠÙ† Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª', 'icon': 'trending_up'},
        {'id': '4', 'title': 'Ø§Ù„Ø±Ø¯ Ø¹Ù„Ù‰ Ø¹Ù…ÙŠÙ„', 'icon': 'support_agent'},
      ];
    });
  }

  Future<void> _loadConversation(String conversationId) async {
    // Ø§Ù„Ù…Ø³Ø§Ø¹Ø¯ Ø§Ù„Ø¬Ø¯ÙŠØ¯ Ù„Ø§ ÙŠØ­ØªØ§Ø¬ ØªØ­Ù…ÙŠÙ„ Ù…Ø­Ø§Ø¯Ø«Ø§Øª - ÙŠØ¹Ù…Ù„ Ù…Ø¨Ø§Ø´Ø±Ø©
    setState(() {
      _showConversations = false;
    });
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
      // Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„Ù…Ø³Ø§Ø¹Ø¯ Ø§Ù„Ø´Ø®ØµÙŠ Ø§Ù„Ø¬Ø¯ÙŠØ¯ Ø¹Ø¨Ø± OpenRouter
      final response = await _api.post(
        '/api/ai/assistant',
        body: {
          'message': message,
          'history': _messages
              .map((m) => {'role': m['role'], 'content': m['content']})
              .toList(),
        },
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      if (data['success'] == true && data['reply'] != null) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': data['reply'],
            'created_at': DateTime.now().toIso8601String(),
          });
          _isSending = false;
        });
        _scrollToBottom();
      } else {
        throw Exception(data['error'] ?? 'Ø®Ø·Ø£ ØºÙŠØ± Ù…Ø¹Ø±ÙˆÙ');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
        _messages.add({
          'role': 'assistant',
          'content': 'Ø¹Ø°Ø±Ø§Ù‹ØŒ Ø­Ø¯Ø« Ø®Ø·Ø£. ÙŠØ±Ø¬Ù‰ Ø§Ù„Ù…Ø­Ø§ÙˆÙ„Ø© Ù…Ø±Ø© Ø£Ø®Ø±Ù‰.',
          'created_at': DateTime.now().toIso8601String(),
        });
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ÙØ´Ù„ Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø±Ø³Ø§Ù„Ø©: $e')));
    }
  }

  Future<void> _executeQuickCommand(Map<String, dynamic> command) async {
    final userText = _messageController.text.trim();
    final prompt =
        '${command['title']}: ${userText.isNotEmpty ? userText : 'Ø³Ø§Ø¹Ø¯Ù†ÙŠ'}';

    setState(() {
      _isSending = true;
      _messages.add({
        'role': 'user',
        'content': prompt,
        'created_at': DateTime.now().toIso8601String(),
      });
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _api.post(
        '/api/ai/assistant',
        body: {
          'message': prompt,
          'history': _messages
              .map((m) => {'role': m['role'], 'content': m['content']})
              .toList(),
        },
      );

      if (!mounted) return;
      final data = jsonDecode(response.body);

      if (data['success'] == true && data['reply'] != null) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': data['reply'],
            'created_at': DateTime.now().toIso8601String(),
          });
          _isSending = false;
        });
        _scrollToBottom();
      } else {
        throw Exception(data['error'] ?? 'Ø®Ø·Ø£ ØºÙŠØ± Ù…Ø¹Ø±ÙˆÙ');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ÙØ´Ù„ ØªÙ†ÙÙŠØ° Ø§Ù„Ø£Ù…Ø±: $e')));
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
      appBar: AppBar(
        title: Text(_activeConversation?['title'] ?? 'Ù…Ø³Ø§Ø¹Ø¯ AI'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrowBack,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Ø§Ù„Ù…Ø­Ø§Ø¯Ø«Ø§Øª',
            onPressed: () =>
                setState(() => _showConversations = !_showConversations),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Ù…Ø­Ø§Ø¯Ø«Ø© Ø¬Ø¯ÙŠØ¯Ø©',
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
                child: Text('Ø§Ù„Ø£ÙˆØ§Ù…Ø± Ø§Ù„Ø³Ø±ÙŠØ¹Ø©'),
              ),
              const PopupMenuItem(value: 'settings', child: Text('Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª')),
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
                  const SizedBox(height: AppDimensions.spacing16),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: AppDimensions.spacing16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Ø¥Ø¹Ø§Ø¯Ø© Ø§Ù„Ù…Ø­Ø§ÙˆÙ„Ø©'),
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
          padding: AppDimensions.paddingM,
          color: Colors.grey[100],
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Ø§Ù„Ù…Ø­Ø§Ø¯Ø«Ø§Øª',
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
                    'Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ø­Ø§Ø¯Ø«Ø§Øª',
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
                        conv['title'] ?? 'Ù…Ø­Ø§Ø¯Ø«Ø©',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        '${conv['messages_count'] ?? 0} Ø±Ø³Ø§Ù„Ø©',
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
                                  ? 'Ø¥Ù„ØºØ§Ø¡ Ø§Ù„ØªØ«Ø¨ÙŠØª'
                                  : 'ØªØ«Ø¨ÙŠØª',
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Ø­Ø°Ù'),
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
      padding: AppDimensions.paddingM,
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
      padding: AppDimensions.paddingXL,
      child: Column(
        children: [
          SizedBox(height: AppDimensions.spacing40),
          Container(
            padding: AppDimensions.paddingXL,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy,
              size: AppDimensions.iconDisplay,
              color: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: AppDimensions.spacing24),
          Text(
            'Ù…Ø±Ø­Ø¨Ø§Ù‹! Ø£Ù†Ø§ Ù…Ø³Ø§Ø¹Ø¯Ùƒ Ø§Ù„Ø°ÙƒÙŠ',
            style: TextStyle(
              fontSize: AppDimensions.fontDisplay2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            'ÙŠÙ…ÙƒÙ†Ù†ÙŠ Ù…Ø³Ø§Ø¹Ø¯ØªÙƒ ÙÙŠ Ø¥Ø¯Ø§Ø±Ø© Ù…ØªØ¬Ø±Ùƒ',
            style: TextStyle(
              fontSize: AppDimensions.fontTitle,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: AppDimensions.spacing32),
          const Text(
            'Ø¬Ø±Ø¨ Ø£Ù† ØªØ³Ø£Ù„Ù†ÙŠ Ø¹Ù†:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Wrap(
            spacing: AppDimensions.spacing8,
            runSpacing: AppDimensions.spacing8,
            alignment: WrapAlignment.center,
            children: [
              _buildSuggestionChip('Ø§ÙƒØªØ¨ ÙˆØµÙ Ù„Ù…Ù†ØªØ¬ Ø¬Ø¯ÙŠØ¯'),
              _buildSuggestionChip('Ø£ÙÙƒØ§Ø± Ù„Ø­Ù…Ù„Ø© ØªØ³ÙˆÙŠÙ‚ÙŠØ©'),
              _buildSuggestionChip('ØªØ­Ù„ÙŠÙ„ Ù…Ø¨ÙŠØ¹Ø§Øª Ø§Ù„Ù…ØªØ¬Ø±'),
              _buildSuggestionChip('Ø±Ø¯ Ø¹Ù„Ù‰ Ø´ÙƒÙˆÙ‰ Ø¹Ù…ÙŠÙ„'),
              _buildSuggestionChip('Ø§Ù‚ØªØ±Ø§Ø­ Ø£Ø³Ø¹Ø§Ø± Ù…Ù†Ø§ÙØ³Ø©'),
            ],
          ),
          SizedBox(height: AppDimensions.spacing32),
          const Text(
            'Ø§Ù„Ø£ÙˆØ§Ù…Ø± Ø§Ù„Ø³Ø±ÙŠØ¹Ø©',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spacing16),
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
      margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withAlpha(25),
          child: Icon(
            Icons.flash_on,
            color: AppTheme.primaryColor,
            size: AppDimensions.iconS,
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
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppDimensions.paddingS,
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryColor : Colors.white,
                borderRadius: AppDimensions.borderRadiusL.copyWith(
                  bottomRight: isUser
                      ? Radius.circular(AppDimensions.radiusXS)
                      : null,
                  bottomLeft: !isUser
                      ? Radius.circular(AppDimensions.radiusXS)
                      : null,
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
                      icon: Icon(Icons.copy, size: AppDimensions.iconXS),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // Copy to clipboard
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ØªÙ… Ø§Ù„Ù†Ø³Ø®')),
                        );
                      },
                    ),
                    const SizedBox(width: AppDimensions.spacing8),
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up_outlined,
                        size: AppDimensions.iconXS,
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
                        size: AppDimensions.iconXS,
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
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        padding: AppDimensions.paddingM,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDimensions.borderRadiusL,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            SizedBox(width: AppDimensions.spacing4),
            _buildDot(1),
            SizedBox(width: AppDimensions.spacing4),
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
      padding: AppDimensions.paddingM,
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
              tooltip: 'Ø§Ù„Ø£ÙˆØ§Ù…Ø± Ø§Ù„Ø³Ø±ÙŠØ¹Ø©',
              onPressed: _showQuickCommandsSheet,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ø§ÙƒØªØ¨ Ø±Ø³Ø§Ù„ØªÙƒ...',
                  border: OutlineInputBorder(
                    borderRadius: AppDimensions.borderRadiusXXL,
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing16,
                    vertical: AppDimensions.spacing12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: IconButton(
                icon: _isSending
                    ? SizedBox(
                        width: AppDimensions.iconS,
                        height: AppDimensions.iconS,
                        child: const CircularProgressIndicator(
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
      ).showSnackBar(const SnackBar(content: Text('Ø´ÙƒØ±Ø§Ù‹ Ø¹Ù„Ù‰ ØªÙ‚ÙŠÙŠÙ…Ùƒ!')));
    } catch (e) {
      // Ignore errors
    }
  }

  void _showQuickCommandsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: AppDimensions.paddingM,
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
                  const SizedBox(height: AppDimensions.spacing16),
                  Text(
                    'Ø§Ù„Ø£ÙˆØ§Ù…Ø± Ø§Ù„Ø³Ø±ÙŠØ¹Ø©',
                    style: TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing16,
                ),
                itemCount: _quickCommands.length,
                itemBuilder: (context, index) {
                  final cmd = _quickCommands[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getCategoryColor(
                          cmd['category'],
                        ).withAlpha(25),
                        child: Icon(
                          _getCategoryIcon(cmd['category']),
                          color: _getCategoryColor(cmd['category']),
                          size: AppDimensions.iconS,
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
              const SizedBox(height: AppDimensions.spacing16),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Ø£Ø¯Ø®Ù„ Ø§Ù„Ù†Øµ',
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
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _executeQuickCommand(command);
            },
            child: const Text('ØªÙ†ÙÙŠØ°'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ù…Ø³Ø§Ø¹Ø¯'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Ø§Ù„Ù„ØºØ©'),
              subtitle: Text('Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©'),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Ø­Ø°Ù Ø§Ù„Ù…Ø­Ø§Ø¯Ø«Ø§Øª'),
              subtitle: Text('Ø­Ø°Ù Ø¬Ù…ÙŠØ¹ Ø§Ù„Ù…Ø­Ø§Ø¯Ø«Ø§Øª Ø§Ù„Ø³Ø§Ø¨Ù‚Ø©'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ø¥ØºÙ„Ø§Ù‚'),
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
