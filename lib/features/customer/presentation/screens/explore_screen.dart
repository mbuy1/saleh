import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/hero_banner_carousel.dart';
import '../../../../shared/widgets/placeholder_image.dart';

class ExploreScreen extends StatefulWidget {
  final String? userRole;
  const ExploreScreen({super.key, this.userRole});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _pageController = PageController();
  final bool _showBanner = true;

  // بيانات البانر التجريبية
  final List<BannerItem> _banners = [
    BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
      title: 'تخفيضات الموسم',
      subtitle: 'خصم يصل إلى 70% على جميع المنتجات',
      buttonText: 'تسوق الآن',
      onTap: () {},
    ),
    BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800',
      title: 'وصول جديد',
      subtitle: 'اكتشف أحدث صيحات الموضة',
      buttonText: 'اكتشف',
      onTap: () {},
    ),
    BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
      title: 'شحن مجاني',
      subtitle: 'على جميع الطلبات فوق 200 ريال',
      buttonText: 'ابدأ الشراء',
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: 11, // 1 banner + 10 videos
        itemBuilder: (context, index) {
          // أول عنصر هو البانر
          if (index == 0 && _showBanner) {
            return _buildBannerItem();
          }

          // باقي العناصر هي الفيديوهات
          final videoIndex = _showBanner ? index - 1 : index;
          return _buildVideoItem(videoIndex);
        },
      ),
    );
  }

  Widget _buildBannerItem() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Safe Area للحفاظ على المسافات
          SizedBox(height: MediaQuery.of(context).padding.top + 16),

          // Hero Banner
          HeroBannerCarousel(
            banners: _banners,
            height: 240,
            bottomRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),

          // Swipe Indicator
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اسحب للأسفل لمشاهدة الفيديوهات',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                      fontFamily: 'Cairo',
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

  Widget _buildVideoItem(int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Video Placeholder (Background)
        Container(
          color: Colors.grey[900],
          child: Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white.withValues(alpha: 0.3),
              size: 80,
            ),
          ),
        ),

        // 2. Overlay Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),

        // 3. Left Side Interaction Icons
        Positioned(
          left: 16,
          bottom: 60, // Start from bottom of screen
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInteractionIcon(
                Icons.favorite,
                '12.5K',
                color: MbuyColors.primaryMaroon,
              ),
              _buildInteractionIcon(Icons.comment_rounded, '456'),
              _buildInteractionIcon(Icons.share, 'Share'),
              _buildInteractionIcon(Icons.shopping_bag_outlined, 'Buy'),
            ],
          ),
        ),

        // 4. Store Profile Icon (Right side, aligned with store name)
        Positioned(
          right: 16,
          bottom: 60,
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: ClipOval(
                    child: PlaceholderImage.circular(
                      radius: 24,
                      icon: Icons.store,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: MbuyColors.primaryMaroon,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 5. Bottom Info (Store Name, Description)
        Positioned(
          left: 100, // Space for left icons
          right: 80, // Space for store profile
          bottom: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '@اسم_المتجر',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'وصف قصير للفيديو أو المنتج المعروض هنا... #موضة #جديد',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'الموسيقى الأصلية - اسم المتجر',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInteractionIcon(
    IconData icon,
    String label, {
    Color color = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
