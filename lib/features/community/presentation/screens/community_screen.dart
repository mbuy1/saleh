import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المجتمع'),
          bottom: const TabBar(
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
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('تاجر ${index + 1}'),
                subtitle: const Text('السلام عليكم، كيف حالكم؟'),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'اكتب رسالة...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
              ),
              border: const OutlineInputBorder(),
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
      padding: const EdgeInsets.all(16),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.emoji_events, color: Colors.amber),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(storeName),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Text(
              'عرض المتجر',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsTab extends StatelessWidget {
  const _PostsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.store)),
                title: Text('متجر ${index + 1}'),
                subtitle: const Text('منذ ساعتين'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'هذا منشور تجريبي رقم ${index + 1} في مجتمع التجار.',
                ),
              ),
              Container(
                height: 150,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up_outlined),
                      label: const Text('إعجاب'),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined),
                      label: const Text('تعليق'),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('مشاركة'),
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
