import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../core/data/models.dart';
import '../../../../core/data/repositories/explore_repository.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/explore_service.dart';
import 'product_details_screen.dart';
import 'store_details_screen.dart';
import 'profile_screen.dart';

/// شاشة الاستكشاف - تصميم نظيف بسيط
/// Tabs: لك / فيديو / صور
/// ألوان: أبيض/أسود/رمادي فقط، أصفر للعروض، أحمر للتنبيهات، أخضر للنجاح
class ExploreScreen extends StatefulWidget {
  final String? userRole;

  const ExploreScreen({super.key, this.userRole});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilterIndex = 0;
  bool _isLoadingVideos = false;
  bool _isLoadingProducts = false;
  List<VideoItem> _videos = [];
  List<Product> _products = [];
  int _currentVideoPage = 0;
  int _currentProductPage = 0;
  final ExploreRepository _repository = ExploreRepository();

  final List<String> _filters = [
    'جديد',
    'الأكثر مشاهدة',
    'الأكثر مبيعًا',
    'حسب موقع',
    'المتاجر الأعلى تقييمًا',
  ];

  final Map<String, String> _filterMap = {
    'جديد': 'new',
    'الأكثر مشاهدة': 'trending',
    'الأكثر مبيعًا': 'top_selling',
    'حسب موقع': 'by_location',
    'المتاجر الأعلى تقييمًا': 'top_rated',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _loadVideos();
    _loadProducts();
  }

  /// تحميل الفيديوهات من Supabase
  Future<void> _loadVideos({bool refresh = false}) async {
    if (_isLoadingVideos) return;

    setState(() {
      _isLoadingVideos = true;
      if (refresh) {
        _currentVideoPage = 0;
        _videos = [];
      }
    });

    try {
      final filter = _filterMap[_filters[_selectedFilterIndex]] ?? 'new';
      final videos = await _repository.getExploreFeed(
        filter: filter,
        page: _currentVideoPage,
        pageSize: 10,
      );

      if (mounted) {
        setState(() {
          _videos.addAll(videos);
          _currentVideoPage++;
          _isLoadingVideos = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingVideos = false;
        });
      }
    }
  }

  /// تحميل المنتجات من Supabase
  Future<void> _loadProducts({bool refresh = false}) async {
    if (_isLoadingProducts) return;

    setState(() {
      _isLoadingProducts = true;
      if (refresh) {
        _currentProductPage = 0;
        _products = [];
      }
    });

    try {
      final filter = _filterMap[_filters[_selectedFilterIndex]] ?? 'new';
      final products = await ExploreService.getExploreProducts(
        filter: filter,
        page: _currentProductPage,
        pageSize: 30,
      );

      if (mounted) {
        setState(() {
          _products.addAll(products);
          _currentProductPage++;
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MbuyScaffold(
        useSafeArea: false,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // هيدر بسيط بخلفية بيضاء
            _buildGlassHeader(),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildForYouTab(),
                  _buildVideosTab(),
                  _buildImagesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// هيدر بسيط بخلفية بيضاء - بدون glassmorphism
  Widget _buildGlassHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: MbuyColors.borderLight, width: 0.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Row with Icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Account Icon (Right) - دائرة سوداء
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MbuyColors.textPrimary,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Search Icon (Left) - أسود
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      color: MbuyColors.textPrimary,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            // Tabs - خط سفلي رفيع فقط
            TabBar(
              controller: _tabController,
              indicatorColor: MbuyColors.textPrimary,
              indicatorWeight: 1.5,
              labelColor: MbuyColors.textPrimary,
              unselectedLabelColor: MbuyColors.textSecondary,
              labelStyle: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: 'لك'),
                Tab(text: 'فيديو'),
                Tab(text: 'صور'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Tab 1: For You (Mixed content)
  Widget _buildForYouTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Video Section
          _buildVideoSection(),
          const SizedBox(height: 28),
          // Image Section with Filters
          _buildImageSection(),
        ],
      ),
    );
  }

  /// Tab 2: Videos Only
  Widget _buildVideosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [const SizedBox(height: 16), _buildVideoSection()],
      ),
    );
  }

  /// Tab 3: Images Only (Marketplace Grid)
  Widget _buildImagesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [const SizedBox(height: 16), _buildImageSection()],
      ),
    );
  }

  /// TikTok-style horizontal video cards section
  Widget _buildVideoSection() {
    final videos = _videos.isEmpty ? DummyData.exploreVideos : _videos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'فيديوهات',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: MbuyColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.65, // 65% من ارتفاع الشاشة
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.75), // 75% عرض
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildVideoCard(videos[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Single video card (16:9 or 4:5 aspect ratio) - بطاقة كبيرة 70% من الشاشة
  Widget _buildVideoCard(VideoItem video) {
    return GestureDetector(
      onTap: () {
        // تتبع المشاهدة
        ExploreService.trackVideoView(video.id);
        _openTikTokPlayer(video);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail - كبيرة ومرئية
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MbuyColors.textSecondary.withValues(alpha: 0.3),
                        MbuyColors.textPrimary,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Play icon
                      Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 48,
                        ),
                      ),
                      // Stats Overlay (Bottom)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.visibility,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatCount(video.likes * 10),
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatCount(video.likes),
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
            const SizedBox(height: 8),
            // Video Caption
            Text(
              video.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: MbuyColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Marketplace image grid with filters
  Widget _buildImageSection() {
    final products = _products.isEmpty ? DummyData.products : _products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'منتجات',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: MbuyColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Smart Filters
        _buildSmartFilters(),
        const SizedBox(height: 16),
        // Product Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          ),
        ),
      ],
    );
  }

  /// Smart filter chips (horizontal scroll)
  Widget _buildSmartFilters() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
              // إعادة تحميل البيانات مع الفلتر الجديد
              _loadVideos(refresh: true);
              _loadProducts(refresh: true);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? MbuyColors.textPrimary
                    : MbuyColors.background,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? MbuyColors.textPrimary
                      : MbuyColors.borderLight,
                  width: 1,
                ),
              ),
              child: Text(
                _filters[index],
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : MbuyColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Single product card for grid
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onLongPress: () => _showProductPopup(product),
      onTap: () {
        // Navigate to product details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product Image (Square)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MbuyColors.surface,
                  border: Border.all(color: MbuyColors.borderLight, width: 1),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: MbuyColors.textSecondary.withValues(alpha: 0.5),
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Product Name
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          // Price
          Text(
            '${product.price} ر.س',
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          // Store Name
          Text(
            product.storeName ?? 'متجر',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: MbuyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Open TikTok-style video player (swipe up to next)
  void _openTikTokPlayer(VideoItem video) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _TikTokPlayerScreen(
          initialVideo: video,
          allVideos: DummyData.exploreVideos,
        ),
      ),
    );
  }

  /// Show product popup on long press
  void _showProductPopup(Product product) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: MbuyColors.surface,
                    border: Border.all(color: MbuyColors.borderLight, width: 1),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: MbuyColors.textSecondary.withValues(alpha: 0.5),
                      size: 64,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Product Name
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: MbuyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              // Price
              Text(
                '${product.price} ر.س',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MbuyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              // Action Buttons Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // البحث عن المتجر من DummyData
                        final store = DummyData.stores.firstWhere(
                          (s) => s.id == product.storeId,
                          orElse: () => DummyData.stores.first,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreDetailsScreen(
                              storeId: store.id,
                              storeName: store.name,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MbuyColors.background,
                        foregroundColor: MbuyColors.textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: MbuyColors.glassBorder),
                        ),
                      ),
                      child: Text(
                        'المتجر',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        // التنقل إلى صفحة تفاصيل المنتج
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              productId: product.id,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MbuyColors.textPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'شراء الآن',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Format count (K, M)
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

/// TikTok-style video player with swipe-up-to-next
class _TikTokPlayerScreen extends StatefulWidget {
  final VideoItem initialVideo;
  final List<VideoItem> allVideos;

  const _TikTokPlayerScreen({
    required this.initialVideo,
    required this.allVideos,
  });

  @override
  State<_TikTokPlayerScreen> createState() => _TikTokPlayerScreenState();
}

class _TikTokPlayerScreenState extends State<_TikTokPlayerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.allVideos.indexOf(widget.initialVideo);
    _pageController = PageController(initialPage: _currentIndex);
  }

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
            // Video PageView (Vertical Swipe)
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: widget.allVideos.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildVideoPlayer(widget.allVideos[index]);
              },
            ),
            // Close Button (Top Right)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(VideoItem video) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video Background (Placeholder)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MbuyColors.textSecondary.withValues(alpha: 0.4),
                MbuyColors.textPrimary,
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
        // Bottom Gradient for Text Clarity
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
        // Action Buttons (Right Side)
        _buildActionButtons(video),
        // Video Info (Bottom)
        _buildVideoInfo(video),
      ],
    );
  }

  Widget _buildActionButtons(VideoItem video) {
    return Positioned(
      left: 12,
      bottom: 160,
      child: Column(
        children: [
          _buildActionButton(
            icon: Icons.favorite_rounded,
            count: video.likes,
            onTap: () {},
            color: Colors.redAccent,
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            icon: Icons.chat_bubble_rounded,
            count: video.comments,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            icon: Icons.share_rounded,
            count: video.shares,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            icon: Icons.bookmark_rounded,
            count: video.bookmarks,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.3),
            ),
            child: Icon(icon, color: color ?? Colors.white, size: 32),
          ),
          if (count > 0) ...[
            const SizedBox(height: 4),
            Text(
              _formatCount(count),
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVideoInfo(VideoItem video) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 80,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: MbuyColors.textPrimary,
                    child: Text(
                      video.userAvatar,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    video.userName,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Caption
              Text(
                video.caption,
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              // Buy Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: MbuyColors.textPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'شراء الآن',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
