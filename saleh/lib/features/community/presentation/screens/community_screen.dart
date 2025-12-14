import 'package:flutter/material.dart';
import '../../../../shared/widgets/exports.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'المجتمع',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: AppTheme.accentColor,
            tabs: [
              Tab(text: 'شات حي'),
              Tab(text: 'الصدارة'),
              Tab(text: 'منشورات'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_LiveChatTab(), _LeaderboardTab(), _PostsTab()],
        ),
      ),
    );
  }
}

class _LiveChatTab extends StatelessWidget {
  const _LiveChatTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: AppDimensions.screenPadding,
            itemCount: 10,
            itemBuilder: (context, index) {
              return MbuyCard(
                margin: const EdgeInsets.only(bottom: AppDimensions.spacing8),
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                child: Row(
                  children: [
                    MbuyCircleIcon(
                      icon: Icons.person,
                      size: AppDimensions.avatarM,
                      backgroundColor: AppTheme.primaryColor,
                      iconColor: Colors.white,
                    ),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تاجر ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimensions.fontBody,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing4),
                          const Text(
                            'السلام عليكم، كيف حالكم؟',
                            style: TextStyle(
                              fontSize: AppDimensions.fontBody2,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: AppDimensions.screenPadding,
          child: MbuyInputField(
            hint: 'اكتب رسالة...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: AppTheme.accentColor),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppDimensions.screenPadding,
      children: const [
        _LeaderboardCard(
          title: 'أعلى متجر مبيعات',
          storeName: 'متجر الأناقة',
          value: '5000+ طلب',
        ),
        _LeaderboardCard(
          title: 'أعلى متجر متابعين',
          storeName: 'عالم التقنية',
          value: '10k متابع',
        ),
        _LeaderboardCard(
          title: 'أعلى متجر تقييم',
          storeName: 'مأكولات شهية',
          value: '4.9 ⭐',
        ),
        _LeaderboardCard(
          title: 'أعلى متجر زيارات',
          storeName: 'أزياء مودرن',
          value: '50k زيارة',
        ),
        _LeaderboardCard(
          title: 'أعلى متجر تفاعل',
          storeName: 'هدايا مميزة',
          value: '98% تفاعل',
        ),
      ],
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final String title;
  final String storeName;
  final String value;

  const _LeaderboardCard({
    required this.title,
    required this.storeName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return MbuyCard(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: AppDimensions.iconL,
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontBody,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  storeName,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontBody2,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentColor,
                  fontSize: AppDimensions.fontBody,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing4),
              const Text(
                'عرض المتجر',
                style: TextStyle(
                  fontSize: AppDimensions.fontCaption,
                  color: AppTheme.textHintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostsTab extends StatelessWidget {
  const _PostsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppDimensions.screenPadding,
      itemCount: 5,
      itemBuilder: (context, index) {
        return MbuyCard(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                child: Row(
                  children: [
                    MbuyCircleIcon(
                      icon: Icons.store,
                      size: AppDimensions.avatarM,
                      backgroundColor: AppTheme.primaryColor,
                      iconColor: Colors.white,
                    ),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'متجر ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimensions.fontBody,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const Text(
                            'منذ ساعتين',
                            style: TextStyle(
                              fontSize: AppDimensions.fontCaption,
                              color: AppTheme.textHintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing16,
                  vertical: AppDimensions.spacing8,
                ),
                child: Text(
                  'هذا منشور تجريبي رقم ${index + 1} في مجتمع التجار.',
                  style: const TextStyle(
                    fontSize: AppDimensions.fontBody,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Container(
                height: 150,
                color: AppTheme.surfaceColor,
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: AppDimensions.iconXL,
                    color: AppTheme.textHintColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.thumb_up_outlined,
                        size: AppDimensions.iconS,
                        color: AppTheme.textSecondaryColor,
                      ),
                      label: const Text(
                        'إعجاب',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: AppDimensions.fontBody2,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.comment_outlined,
                        size: AppDimensions.iconS,
                        color: AppTheme.textSecondaryColor,
                      ),
                      label: const Text(
                        'تعليق',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: AppDimensions.fontBody2,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.share_outlined,
                        size: AppDimensions.iconS,
                        color: AppTheme.textSecondaryColor,
                      ),
                      label: const Text(
                        'مشاركة',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: AppDimensions.fontBody2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
