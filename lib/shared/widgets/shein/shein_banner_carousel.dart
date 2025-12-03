import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// بانر رئيسي كبير SHEIN Style (Carousel)
/// يحتوي على صور ونصوص ترويجية
class SheinBannerCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> banners;
  final double height;
  final VoidCallback? onBannerTap;

  const SheinBannerCarousel({
    super.key,
    required this.banners,
    this.height = 280,
    this.onBannerTap,
  });

  @override
  State<SheinBannerCarousel> createState() => _SheinBannerCarouselState();
}

class _SheinBannerCarouselState extends State<SheinBannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = widget.banners[index];
            return GestureDetector(
              onTap: widget.onBannerTap,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: banner['imageUrl'] != null
                      ? DecorationImage(
                          image: NetworkImage(banner['imageUrl']),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: banner['imageUrl'] == null ? Colors.grey.shade200 : null,
                ),
                child: banner['title'] != null || banner['buttonText'] != null
                    ? Stack(
                        children: [
                          // النص الترويجي
                          if (banner['title'] != null)
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Text(
                                banner['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // زر التصفح
                          if (banner['buttonText'] != null)
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  banner['buttonText'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    : null,
              ),
            );
          },
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: 1.0,
            autoPlay: widget.banners.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        // مؤشرات النقاط
        if (widget.banners.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Colors.black
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

