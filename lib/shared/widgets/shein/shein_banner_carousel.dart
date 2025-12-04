import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// Hero Banner رئيسي كبير SHEIN Style (Carousel)
/// يحتوي على صور خلفية كبيرة، نصوص ترويجية (Title + Subtitle)، وهامش منحني من الأسفل
class SheinBannerCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> banners;
  final double height;
  final VoidCallback? onBannerTap;

  const SheinBannerCarousel({
    super.key,
    required this.banners,
    this.height = 320,
    this.onBannerTap,
  });

  @override
  State<SheinBannerCarousel> createState() => _SheinBannerCarouselState();
}

class _SheinBannerCarouselState extends State<SheinBannerCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Hero Banner Carousel
        Stack(
          children: [
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: widget.banners.length,
              itemBuilder: (context, index, realIndex) {
                final banner = widget.banners[index];
                return _buildHeroBanner(banner);
              },
              options: CarouselOptions(
                height: widget.height,
                viewportFraction: 1.0,
                autoPlay: widget.banners.length > 1,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOutCubic,
                enableInfiniteScroll: widget.banners.length > 1,
                pauseAutoPlayOnTouch: true,
                pauseAutoPlayOnManualNavigate: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            // مؤشرات Dots في الأسفل (SHEIN Style)
            if (widget.banners.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: _buildDotsIndicator(),
              ),
          ],
        ),
      ],
    );
  }

  /// بناء Hero Banner مع curved bottom radius
  Widget _buildHeroBanner(Map<String, dynamic> banner) {
    return GestureDetector(
      onTap: widget.onBannerTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: banner['imageUrl'] == null ? Colors.grey.shade200 : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // صورة الخلفية
            if (banner['imageUrl'] != null)
              ClipPath(
                clipper: _CurvedBottomClipper(),
                child: Image.network(
                  banner['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      ),
                    );
                  },
                ),
              )
            else
              ClipPath(
                clipper: _CurvedBottomClipper(),
                child: Container(
                  color: Colors.grey.shade200,
                ),
              ),
            // Gradient overlay لتحسين قراءة النص
            ClipPath(
              clipper: _CurvedBottomClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),
            // النص الترويجي (Title + Subtitle)
            if (banner['title'] != null || banner['subtitle'] != null)
              Positioned(
                right: 24,
                top: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Title
                    if (banner['title'] != null)
                      Text(
                        banner['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    const SizedBox(height: 8),
                    // Subtitle
                    if (banner['subtitle'] != null)
                      Text(
                        banner['subtitle'],
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.right,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// بناء مؤشرات Dots بنفس ستايل SHEIN
  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.banners.length,
        (index) => GestureDetector(
          onTap: () {
            _carouselController.animateToPage(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _currentIndex == index ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentIndex == index
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
              boxShadow: _currentIndex == index
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Clipper لإنشاء curved bottom radius
class _CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 30);
    
    // منحنى من الأسفل
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

