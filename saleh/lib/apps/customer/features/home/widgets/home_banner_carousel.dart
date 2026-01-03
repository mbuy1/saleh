import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBannerCarousel extends ConsumerStatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  ConsumerState<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends ConsumerState<HomeBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // TODO: Replace with API data
  final List<BannerItem> _banners = [
    BannerItem(
      id: '1',
      imageUrl: 'https://picsum.photos/800/400?random=1',
      title: 'عروض العيد',
      subtitle: 'خصم يصل إلى 50%',
      actionUrl: '/offers',
    ),
    BannerItem(
      id: '2',
      imageUrl: 'https://picsum.photos/800/400?random=2',
      title: 'وصل حديثاً',
      subtitle: 'تشكيلة الصيف الجديدة',
      actionUrl: '/new-arrivals',
    ),
    BannerItem(
      id: '3',
      imageUrl: 'https://picsum.photos/800/400?random=3',
      title: 'توصيل مجاني',
      subtitle: 'للطلبات فوق 100 ريال',
      actionUrl: '/free-shipping',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // PageView
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                return _buildBannerItem(_banners[index]);
              },
            ),
          ),

          // Page Indicators
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_banners.length, (index) {
                return Container(
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(BannerItem banner) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to action URL
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            banner.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.white54),
                ),
              );
            },
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),

          // Text Content
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BannerItem {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String actionUrl;

  BannerItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.actionUrl,
  });
}
