import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const HomeScreen({super.key, this.scrollController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB), // bg-gray-50
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          children: [
            _buildHeroBanner(),
            const SizedBox(height: 16),
            _buildRectangularCards(),
            const SizedBox(height: 24),
            _buildCategoriesGrid(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HERO BANNER (400px height)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHeroBanner() {
    final banners = [
      {
        'image':
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
        'brand': 'ESTAVOR',
        'title': 'خصم يصل إلى 50%',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
        'brand': 'FASHION',
        'title': 'تشكيلة صيف 2026',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
        'brand': 'PREMIUM',
        'title': 'شحن مجاني',
      },
    ];

    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // PageView for banners
          PageView.builder(
            controller: _bannerController,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemCount: banners.length,
            itemBuilder: (_, i) {
              final banner = banners[i];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.network(
                    banner['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Container(color: Colors.grey.shade300),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                  // Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Brand Name
                        Text(
                          banner['brand']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 8,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Main Title
                        Text(
                          banner['title']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Shop Now Button
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6D4C41), // Brown
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'تسوق الآن',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Pagination Dots
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (i) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentBanner == i ? Colors.white : Colors.white54,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // RECTANGULAR CARDS (Horizontal Scroll)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildRectangularCards() {
    final cards = [
      {
        'image':
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300',
        'title': 'علامات تجارية',
        'subtitle': 'ESTAVOR',
      },
      {
        'image':
            'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=300',
        'title': 'الجديد',
        'subtitle': null,
      },
      {
        'image':
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=300',
        'title': 'خريف وشتاء',
        'subtitle': null,
      },
      {
        'image':
            'https://images.unsplash.com/photo-1445205170230-053b83016050?w=300',
        'title': 'مقاسات كبيرة',
        'subtitle': null,
      },
      {
        'image':
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=300',
        'title': 'التخفيضات',
        'subtitle': null,
      },
    ];

    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: cards.length,
        separatorBuilder: (c, j) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final card = cards[i];
          return SizedBox(
            width: 100,
            child: Column(
              children: [
                // Image Container
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      card['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, e, s) =>
                          Container(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  card['title']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Subtitle (if exists)
                if (card['subtitle'] != null)
                  Text(
                    card['subtitle']!,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CATEGORIES GRID (Circles - 5 columns, 3 rows)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildCategoriesGrid() {
    final categories = [
      // Row 1
      'ملابس خارجية',
      'ملابس علوية',
      'تيشيرتات',
      'ملابس سفلية',
      'جاكيتات',
      // Row 2
      'قمصان', 'أطقم منسقة', 'دينيم', 'مقاسات كبيرة', 'بدلات',
      // Row 3
      'بناطيل', 'هوديز', 'بولو', 'منسوجة', 'أزياء خاصة',
    ];

    final images = [
      'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=200',
      'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=200',
      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=200',
      'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=200',
      'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=200',
      'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=200',
      'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=200',
      'https://images.unsplash.com/photo-1542272604-787c3835535d?w=200',
      'https://images.unsplash.com/photo-1519722417352-7d6959729417?w=200',
      'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=200',
      'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=200',
      'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=200',
      'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=200',
      'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=200',
      'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=200',
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 0.65,
          crossAxisSpacing: 4,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          return Column(
            children: [
              // Circle Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.grey.shade200,
                ),
                child: ClipOval(
                  child: Image.network(
                    images[i % images.length],
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Container(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Category Name
              Flexible(
                child: Text(
                  categories[i],
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
