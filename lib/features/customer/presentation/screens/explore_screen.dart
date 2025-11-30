import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

// TODO: Connect to Supabase for video data
// TODO: Integrate video player (Cloudflare Stream)
// TODO: Implement real like/comment/share functionality
// TODO: Add comments bottom sheet
// TODO: Implement share dialog
// TODO: Track video views/engagement

/// نموذج بيانات الفيديو
class VideoItem {
  final String id;
  final String title;
  final String userName;
  final String userAvatar;
  final int likes;
  final int comments;
  final int shares;
  final int bookmarks;
  final String caption;
  final String musicName;
  final String musicAuthor;
  final Color placeholderColor;

  VideoItem({
    required this.id,
    required this.title,
    required this.userName,
    required this.userAvatar,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.bookmarks,
    required this.caption,
    required this.musicName,
    required this.musicAuthor,
    required this.placeholderColor,
  });
}

/// شاشة الاستكشاف - نمط Reels/TikTok
/// عرض كامل للفيديو بتمرير عمودي
class ExploreScreen extends StatefulWidget {
  final String? userRole;

  const ExploreScreen({super.key, this.userRole});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _pageController = PageController();

  // بيانات تجريبية - ستستبدل ببيانات من Supabase
  final List<VideoItem> _videos = [
    VideoItem(
      id: '1',
      title: 'منتج رائع 1',
      userName: 'متجر الإلكترونيات',
      userAvatar: 'E',
      likes: 12500,
      comments: 340,
      shares: 89,
      bookmarks: 450,
      caption: 'اكتشف أحدث المنتجات التقنية بأسعار مذهلة! 🔥 #تقنية #عروض',
      musicName: 'موسيقى إعلانية',
      musicAuthor: 'Mbuy Sounds',
      placeholderColor: MbuyColors.primaryBlue,
    ),
    VideoItem(
      id: '2',
      title: 'منتج رائع 2',
      userName: 'متجر الأزياء',
      userAvatar: 'F',
      likes: 8900,
      comments: 210,
      shares: 45,
      bookmarks: 320,
      caption: 'تشكيلة جديدة من الأزياء العصرية ✨ #موضة #أزياء #جديد',
      musicName: 'أغنية رائجة',
      musicAuthor: 'Fashion Beats',
      placeholderColor: MbuyColors.primaryPurple,
    ),
    VideoItem(
      id: '3',
      title: 'منتج رائع 3',
      userName: 'متجر المنزل',
      userAvatar: 'H',
      likes: 15600,
      comments: 456,
      shares: 120,
      bookmarks: 890,
      caption: 'أثاث عصري لمنزل أحلامك 🏠 خصم 30% #منزل #أثاث #عروض',
      musicName: 'Chill Vibes',
      musicAuthor: 'Home Sounds',
      placeholderColor: MbuyColors.accentPink,
    ),
    VideoItem(
      id: '4',
      title: 'منتج رائع 4',
      userName: 'متجر الرياضة',
      userAvatar: 'S',
      likes: 22000,
      comments: 670,
      shares: 190,
      bookmarks: 1200,
      caption: 'معدات رياضية احترافية للأبطال 💪 #رياضة #صحة #لياقة',
      musicName: 'Energy Boost',
      musicAuthor: 'Sport Tracks',
      placeholderColor: const Color(0xFF10B981),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // محتوى الفيديو بتمرير عمودي
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _videos.length,
              onPageChanged: (index) {
                // يمكن استخدام index لاحقاً لتتبع الفيديو الحالي
              },
              itemBuilder: (context, index) {
                return _buildVideoItem(_videos[index]);
              },
            ),
            // الطبقة العلوية (القائمة والشعار)
            _buildTopOverlay(),
          ],
        ),
      ),
    );
  }

  /// عنصر فيديو واحد
  Widget _buildVideoItem(VideoItem video) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // خلفية الفيديو (Placeholder حاليًا)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                video.placeholderColor.withValues(alpha: 0.4),
                Colors.black,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 80,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
        // التدرج في الأسفل لوضوح النص
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
        ),
        // الأزرار الجانبية (يمين)
        _buildRightActions(video),
        // معلومات المستخدم في الأسفل
        _buildBottomInfo(video),
      ],
    );
  }

  /// الطبقة العلوية - قائمة وشعار
  Widget _buildTopOverlay() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // زر القائمة
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  // TODO: فتح القائمة
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('القائمة')));
                },
              ),
            ),
            // شعار Mbuy
            const LogoCircleWidget(),
          ],
        ),
      ),
    );
  }

  /// الأزرار الجانبية (يمين الشاشة)
  Widget _buildRightActions(VideoItem video) {
    return Positioned(
      left: 12,
      bottom: 120,
      child: Column(
        children: [
          _buildActionButton(
            icon: Icons.favorite_border,
            count: video.likes,
            onTap: () {
              // TODO: إضافة منطق الإعجاب
            },
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            count: video.comments,
            onTap: () {
              // TODO: فتح التعليقات
            },
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            icon: Icons.share_outlined,
            count: video.shares,
            onTap: () {
              // TODO: مشاركة
            },
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            icon: Icons.bookmark_border,
            count: video.bookmarks,
            onTap: () {
              // TODO: حفظ
            },
          ),
        ],
      ),
    );
  }

  /// زر إجراء واحد
  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCount(count),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  /// معلومات المستخدم والمحتوى في الأسفل
  Widget _buildBottomInfo(VideoItem video) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 80, // مساحة للأزرار الجانبية
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم المستخدم
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: MbuyColors.primaryPurple,
                    child: Text(
                      video.userAvatar,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    video.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arabic',
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'متابعة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Arabic',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // الوصف
              Text(
                video.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Arabic',
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // معلومات الموسيقى
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${video.musicName} • ${video.musicAuthor}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Arabic',
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // قرص الموسيقى الدوار
                  const RotatingMusicDisc(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// تنسيق العدد (K, M)
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

/// قرص موسيقى دوار
class RotatingMusicDisc extends StatefulWidget {
  const RotatingMusicDisc({super.key});

  @override
  State<RotatingMusicDisc> createState() => _RotatingMusicDiscState();
}

class _RotatingMusicDiscState extends State<RotatingMusicDisc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [MbuyColors.primaryPurple, MbuyColors.accentPink],
              ),
              boxShadow: [
                BoxShadow(
                  color: MbuyColors.primaryPurple.withValues(alpha: 0.4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.music_note, color: Colors.white, size: 16),
            ),
          ),
        );
      },
    );
  }
}

/// ويدجت شعار Mbuy دائري
class LogoCircleWidget extends StatelessWidget {
  const LogoCircleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MbuyColors.primaryPurple, MbuyColors.accentPink],
        ),
        boxShadow: [
          BoxShadow(
            color: MbuyColors.primaryPurple.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'M',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arabic',
          ),
        ),
      ),
    );
  }
}
