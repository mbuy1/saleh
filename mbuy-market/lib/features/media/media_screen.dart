import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'استكشف', icon: Icon(Icons.explore)),
              Tab(text: 'ريلز', icon: Icon(Icons.video_library)),
              Tab(text: 'بث مباشر', icon: Icon(Icons.live_tv)),
            ],
          ),
        ),
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildExploreTab(), _buildReelsTab(), _buildLiveTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildExploreTab() {
    final videos = List.generate(
      6,
      (i) => {
        'thumbnail':
            'https://images.unsplash.com/photo-${1560343090 + i * 1000}-f0409e92791a?w=400',
        'title': 'فيديو منتج ${i + 1}',
        'views': '${(i + 1) * 1.2}K',
      },
    );

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 16 / 12,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: videos.length,
      itemBuilder: (_, i) => _buildVideoCard(videos[i]),
    );
  }

  Widget _buildVideoCard(Map<String, String> video) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(video['thumbnail']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      video['views']!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReelsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 9 / 16,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 12,
      itemBuilder: (_, i) => _buildReelItem(i),
    );
  }

  Widget _buildReelItem(int index) {
    final images = [
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300',
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300',
      'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=300',
      'https://images.unsplash.com/photo-1560343090-f0409e92791a?w=300',
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(images[index % images.length]),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
          ),
        ),
        padding: const EdgeInsets.all(8),
        alignment: Alignment.bottomRight,
        child: Row(
          children: [
            const Icon(Icons.play_arrow, color: Colors.white, size: 16),
            Text(
              '${(index + 1) * 5.3}K',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 4,
      itemBuilder: (_, i) => _buildLiveCard(i),
    );
  }

  Widget _buildLiveCard(int index) {
    final stores = [
      'متجر الأزياء',
      'متجر الإلكترونيات',
      'متجر التجميل',
      'متجر الرياضة',
    ];
    final viewers = [1234, 856, 2100, 543];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-${1441986300917 + index * 10000}-64674bd600d8?w=600',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Badge & Viewers
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 8),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.visibility,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${viewers[index]}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Store Info
            Row(
              children: [
                const CircleAvatar(radius: 20, child: Icon(Icons.store)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stores[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'عروض حصرية الآن!',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'انضم',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
