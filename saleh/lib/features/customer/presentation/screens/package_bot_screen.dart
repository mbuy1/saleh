import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة Chat Bot لمساعدة المستخدم في اختيار الباقة المناسبة
class PackageBotScreen extends StatefulWidget {
  const PackageBotScreen({super.key});

  @override
  State<PackageBotScreen> createState() => _PackageBotScreenState();
}

class _PackageBotScreenState extends State<PackageBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    // رسالة ترحيبية
    _messages.add({
      'text': 'مرحباً! أنا مساعدك الذكي لمساعدتك في اختيار الباقة المناسبة. كيف يمكنني مساعدتك؟',
      'isBot': true,
      'timestamp': DateTime.now(),
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add({
        'text': userMessage,
        'isBot': false,
        'timestamp': DateTime.now(),
      });
    });

    _scrollToBottom();

    // محاكاة رد البوت (TODO: ربط مع AI Service)
    Future.delayed(const Duration(milliseconds: 500), () {
      final botResponse = _generateBotResponse(userMessage);
      setState(() {
        _messages.add({
          'text': botResponse,
          'isBot': true,
          'timestamp': DateTime.now(),
        });
      });
      _scrollToBottom();
    });
  }

  String _generateBotResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('باقة') || lowerMessage.contains('package')) {
      return 'لدينا عدة باقات متاحة:\n\n'
          '1. الباقة الأساسية - مناسبة للمبتدئين\n'
          '2. الباقة المتقدمة - للمستخدمين المتقدمين\n'
          '3. الباقة المخصصة - اختر الأدوات التي تحتاجها واحصل على خصم 30%\n\n'
          'ما نوع الاستخدام الذي تخطط له؟';
    } else if (lowerMessage.contains('خصم') || lowerMessage.contains('discount')) {
      return 'الباقة المخصصة تمنحك خصم 30% على الأدوات التي تختارها. يمكنك اختيار الأدوات التي تحتاجها فقط ودفع سعر مخفض.\n\n'
          'هل تريد معرفة المزيد عن الباقة المخصصة؟';
    } else if (lowerMessage.contains('أدوات') || lowerMessage.contains('tools')) {
      return 'الباقة المخصصة تتيح لك اختيار من بين الأدوات التالية:\n\n'
          '• Mbuy Tools - التحليلات والأدوات الذكية\n'
          '• Mbuy Studio - الفيديو والصوت والصورة\n'
          '• الترويج - دعم المنتجات والمتاجر\n\n'
          'اختر ما تحتاجه واحصل على خصم 30%!';
    } else if (lowerMessage.contains('سعر') || lowerMessage.contains('price') || lowerMessage.contains('تكلفة')) {
      return 'أسعار الباقات تختلف حسب النوع:\n\n'
          '• الباقة الأساسية: 99 ر.س/شهر\n'
          '• الباقة المتقدمة: 199 ر.س/شهر\n'
          '• الباقة المخصصة: حسب الأدوات المختارة (خصم 30%)\n\n'
          'أي باقة تناسب ميزانيتك؟';
    } else {
      return 'شكراً لسؤالك! يمكنني مساعدتك في:\n\n'
          '• اختيار الباقة المناسبة\n'
          '• شرح المميزات والأسعار\n'
          '• الباقة المخصصة وخصم 30%\n\n'
          'ما الذي تريد معرفته؟';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('مساعد اختيار الباقة'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // قائمة الرسائل
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // حقل الإدخال
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MbuyColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: MbuyColors.primaryMaroon,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
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

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isBot = message['isBot'] as bool;
    
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isBot
              ? MbuyColors.cardBackground
              : MbuyColors.primaryMaroon,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'] as String,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: isBot ? MbuyColors.textPrimary : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message['timestamp'] as DateTime),
              style: GoogleFonts.cairo(
                fontSize: 10,
                color: isBot
                    ? MbuyColors.textSecondary
                    : Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

