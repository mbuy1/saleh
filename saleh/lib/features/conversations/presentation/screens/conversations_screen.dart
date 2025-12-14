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
  final List<Map<String, dynamic>> _conversations = [];

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
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshConversations() async {
    HapticFeedback.lightImpact();
    await _loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return MbuyScaffold(
      title: 'المحادثات',
      showBackButton: false,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.add_comment_outlined,
            size: AppDimensions.iconM,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            MbuySnackBar.show(
              context,
              message: 'محادثة جديدة (قريباً)',
              type: MbuySnackBarType.info,
            );
          },
        ),
      ],
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
    return MbuyCard(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      onTap: () {
        HapticFeedback.lightImpact();
        MbuySnackBar.show(
          context,
          message: 'فتح المحادثة مع العميل ${index + 1}',
          type: MbuySnackBarType.info,
        );
      },
      child: Row(
        children: [
          MbuyCircleIcon(
            icon: Icons.person,
            size: AppDimensions.avatarL,
            backgroundColor: AppTheme.primaryColor,
            iconColor: Colors.white,
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العميل ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontBody,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  'استفسار بخصوص الطلب #${1000 + index}...',
                  style: const TextStyle(
                    fontSize: AppDimensions.fontBody2,
                    color: AppTheme.textSecondaryColor,
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
                '${10 + index}:30 ص',
                style: const TextStyle(
                  fontSize: AppDimensions.fontLabel,
                  color: AppTheme.textHintColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing4),
              if (index < 3)
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacing6),
                  decoration: const BoxDecoration(
                    color: AppTheme.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
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
}
