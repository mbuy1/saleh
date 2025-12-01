import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../core/data/models.dart';
import '../../../../shared/widgets/profile_button.dart';

// TODO: Connect to Supabase for video data
// TODO: Integrate video player (Cloudflare Stream)
// TODO: Implement real like/comment/share functionality
// TODO: Add comments bottom sheet
// TODO: Implement share dialog
// TODO: Track video views/engagement

/// شاشة الاستكشاف - نمط Reels/TikTok
/// عرض كامل للفيديو بتمرير عمودي
class ExploreScreen extends StatefulWidget {
  final String? userRole;

  const ExploreScreen({super.key, this.userRole});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late TabController _tabController;
  late AnimationController _uiOpacityController;
  double _uiOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);

    _uiOpacityController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0,
    );

    _pageController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_pageController.position.isScrollingNotifier.value) {
      if (_uiOpacity != 0.3) {
        setState(() => _uiOpacity = 0.3);
        _uiOpacityController.animateTo(0.3);
      }
    } else {
      if (_uiOpacity != 1.0) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && !_pageController.position.isScrollingNotifier.value) {
            setState(() => _uiOpacity = 1.0);
            _uiOpacityController.animateTo(1.0);
          }
        });
      }
    }
  }

  // استخدام البيانات الموحدة - سيتم استبدالها ببيانات من Supabase لاحقاً
  final List<VideoItem> _videos = DummyData.exploreVideos;

  @override
  void dispose() {
    _pageController.removeListener(_handleScroll);
    _pageController.dispose();
    _tabController.dispose();
    _uiOpacityController.dispose();
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
                MbuyColors.primaryPurple.withValues(alpha: 0.4),
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

  /// الطبقة العلوية - Tabs وأيقونة الحساب مع شفافية
  Widget _buildTopOverlay() {
    return AnimatedOpacity(
      opacity: _uiOpacity,
      duration: const Duration(milliseconds: 300),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الهيدر مع أيقونة الحساب
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [ProfileButton()],
              ),
            ),
            // Tabs في المنتصف
            Center(
              child: Container(
                height: 40,
                constraints: const BoxConstraints(maxWidth: 300),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                  labelStyle: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: const [
                    Tab(text: 'استكشف'),
                    Tab(text: 'أتابعه'),
                    Tab(text: 'لك'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// الأيقونات الجانبية (يسار الشاشة) - في الأسفل بدون خلفية
  Widget _buildRightActions(VideoItem video) {
    return Positioned(
      left: 12,
      bottom: 140,
      child: AnimatedOpacity(
        opacity: _uiOpacity,
        duration: const Duration(milliseconds: 300),
        child: Column(
          children: [
            // 1. لايك
            _buildActionButton(
              icon: Icons.favorite_border,
              count: video.likes,
              onTap: () {},
            ),
            const SizedBox(height: 18),
            // 2. ماعجبني
            _buildActionButton(
              icon: Icons.thumb_down_outlined,
              count: video.dislikes,
              onTap: () {},
            ),
            const SizedBox(height: 18),
            // 3. تعليقات
            _buildActionButton(
              icon: Icons.chat_bubble_outline,
              count: video.comments,
              onTap: () {},
            ),
            const SizedBox(height: 18),
            // 4. مشاركة
            _buildActionButton(
              icon: Icons.share_outlined,
              count: video.shares,
              onTap: () {},
            ),
            const SizedBox(height: 18),
            // 5. حفظ
            _buildActionButton(
              icon: Icons.bookmark_border,
              count: video.bookmarks,
              onTap: () {},
            ),
            const SizedBox(height: 18),
            // 6. المزيد
            _buildActionButton(
              icon: Icons.more_vert,
              count: 0,
              onTap: () => _showMoreOptions(context),
            ),
          ],
        ),
      ),
    );
  }

  /// قائمة المزيد
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMoreOption(Icons.flag, 'إبلاغ'),
            _buildMoreOption(Icons.visibility_off, 'لا تظهر لي هذا النوع'),
            _buildMoreOption(Icons.category, 'تحديد الفئات'),
            _buildMoreOption(Icons.info_outline, 'شرح الفيديو'),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: MbuyColors.textPrimary),
      title: Text(
        label,
        style: GoogleFonts.cairo(fontSize: 15, color: MbuyColors.textPrimary),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  /// زر إجراء واحد - بدون خلفية
  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
            shadows: const [
              Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          if (count > 0) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              _formatCount(count),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// معلومات المستخدم والمحتوى في الأسفل مع شفافية
  Widget _buildBottomInfo(VideoItem video) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 80, // مساحة للأزرار الجانبية
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: _uiOpacity,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المستخدم
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: MbuyColors.primaryPurple,
                      child: Text(
                        video.userAvatar,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      video.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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
                    fontSize: 12,
                    fontFamily: 'Arabic',
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // أزرار السلة والشراء - بحجم صغير
                AnimatedOpacity(
                  opacity: _uiOpacity,
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    children: [
                      // زر إضافة للسلة - صغير
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: MbuyColors.primaryPurple,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'أضف للسلة',
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: MbuyColors.primaryPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // زر الشراء الآن - صغير
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: MbuyColors.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: MbuyColors.primaryPurple.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'شراء • 199 ر.س',
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
            width: 28,
            height: 28,
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
