import 'dart:async';
import 'package:flutter/material.dart';

/// Hero Banner Carousel بأسلوب SHEIN
/// يدعم السحب والتحرك التلقائي مع مؤشرات
class HeroBannerCarousel extends StatefulWidget {
  final List<BannerItem> banners;
  final double height;
  final Duration autoPlayDuration;
  final BorderRadius? bottomRadius;

  const HeroBannerCarousel({
    super.key,
    required this.banners,
    this.height = 200,
    this.autoPlayDuration = const Duration(seconds: 4),
    this.bottomRadius,
  });

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  late PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % widget.banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Carousel
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              return _BannerItemWidget(
                banner: widget.banners[index],
                bottomRadius: widget.bottomRadius,
              );
            },
          ),

          // Dots Indicator
          if (widget.banners.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: _DotsIndicator(
                count: widget.banners.length,
                currentIndex: _currentPage,
              ),
            ),
        ],
      ),
    );
  }
}

/// عنصر بانر واحد
class _BannerItemWidget extends StatelessWidget {
  final BannerItem banner;
  final BorderRadius? bottomRadius;

  const _BannerItemWidget({required this.banner, this.bottomRadius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: banner.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: bottomRadius,
          image: banner.imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(banner.imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
          gradient: banner.imageUrl == null
              ? banner.gradient ??
                    LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        banner.backgroundColor ?? Colors.purple,
                        (banner.backgroundColor ?? Colors.purple).withValues(
                          alpha: 0.7,
                        ),
                      ],
                    )
              : null,
        ),
        child: Stack(
          children: [
            // Gradient Overlay للنص
            if (banner.imageUrl != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: bottomRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),

            // محتوى النص
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (banner.title != null)
                    Text(
                      banner.title!,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: banner.titleColor ?? Colors.white,
                        fontFamily: 'Cairo',
                        height: 1.2,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ),
                  if (banner.subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      banner.subtitle!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color:
                            banner.subtitleColor ??
                            Colors.white.withValues(alpha: 0.95),
                        fontFamily: 'Cairo',
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (banner.buttonText != null) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: banner.onButtonPressed ?? banner.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: banner.buttonColor ?? Colors.white,
                        foregroundColor: banner.buttonTextColor ?? Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        banner.buttonText!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// مؤشرات النقاط بأسلوب SHEIN
class _DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _DotsIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// نموذج بيانات البانر
class BannerItem {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final VoidCallback? onTap;
  final VoidCallback? onButtonPressed;

  const BannerItem({
    this.imageUrl,
    this.title,
    this.subtitle,
    this.buttonText,
    this.backgroundColor,
    this.gradient,
    this.titleColor,
    this.subtitleColor,
    this.buttonColor,
    this.buttonTextColor,
    this.onTap,
    this.onButtonPressed,
  });
}
