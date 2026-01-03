import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? productName;
  final String? productDescription;
  final double? price;
  final double? oldPrice;
  final String? storeName;
  final String? storeAvatar;

  const VideoPlayerScreen({
    super.key,
    this.videoUrl,
    this.thumbnailUrl,
    this.productName,
    this.productDescription,
    this.price,
    this.oldPrice,
    this.storeName,
    this.storeAvatar,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isPaused = false;
  bool _showHeartAnimation = false;

  // State per video (preserved when scrolling)
  final Map<int, bool> _likedVideos = {};
  final Map<int, bool> _dislikedVideos = {};
  final Map<int, bool> _savedVideos = {};
  final Map<int, bool> _followingStores = {};

  // Animation controllers
  late AnimationController _heartAnimationController;
  late Animation<double> _heartScaleAnimation;

  // Sample videos for swiping
  final List<Map<String, dynamic>> _videos = [
    {
      'thumbnail':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
      'productName': 'سماعات لاسلكية فاخرة',
      'description': 'سماعات بلوتوث بجودة صوت عالية',
      'price': 299.0,
      'oldPrice': 450.0,
      'storeName': 'متجر التقنية',
      'storeAvatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      'likes': 1200,
      'comments': 45,
    },
    {
      'thumbnail':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
      'productName': 'حذاء رياضي أنيق',
      'description': 'حذاء رياضي مريح للجري',
      'price': 189.0,
      'oldPrice': 350.0,
      'storeName': 'متجر الرياضة',
      'storeAvatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      'likes': 856,
      'comments': 32,
    },
    {
      'thumbnail':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
      'productName': 'ساعة ذكية',
      'description': 'ساعة ذكية بمميزات متعددة',
      'price': 599.0,
      'oldPrice': 899.0,
      'storeName': 'متجر الإلكترونيات',
      'storeAvatar':
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
      'likes': 2100,
      'comments': 89,
    },
    {
      'thumbnail':
          'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=800',
      'productName': 'عطر فاخر',
      'description': 'عطر فرنسي أصلي',
      'price': 450.0,
      'oldPrice': 650.0,
      'storeName': 'متجر العطور',
      'storeAvatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
      'likes': 543,
      'comments': 21,
    },
  ];

  // Primary color from design
  static const Color primaryColor = Color(0xFF0DF2DF);
  static const Color darkBg = Color(0xFF102221);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Heart animation for double-tap like
    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _heartScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.4), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_heartAnimationController);

    // Set status bar to transparent for immersive experience
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    HapticFeedback.mediumImpact();
    setState(() {
      _likedVideos[_currentIndex] = true;
      _showHeartAnimation = true;
    });
    _heartAnimationController.forward(from: 0).then((_) {
      if (mounted) {
        setState(() => _showHeartAnimation = false);
      }
    });
  }

  void _handleSingleTap() {
    HapticFeedback.lightImpact();
    setState(() => _isPaused = !_isPaused);
  }

  void _toggleLike() {
    HapticFeedback.lightImpact();
    setState(() {
      _likedVideos[_currentIndex] = !(_likedVideos[_currentIndex] ?? false);
      if (_likedVideos[_currentIndex] == true) {
        _dislikedVideos[_currentIndex] = false;
      }
    });
  }

  void _toggleDislike() {
    HapticFeedback.lightImpact();
    setState(() {
      _dislikedVideos[_currentIndex] =
          !(_dislikedVideos[_currentIndex] ?? false);
      if (_dislikedVideos[_currentIndex] == true) {
        _likedVideos[_currentIndex] = false;
      }
    });
  }

  void _toggleSave() {
    HapticFeedback.lightImpact();
    setState(() {
      _savedVideos[_currentIndex] = !(_savedVideos[_currentIndex] ?? false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _savedVideos[_currentIndex] == true
              ? 'تم الحفظ في المفضلة'
              : 'تم الإزالة من المفضلة',
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: darkBg,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleFollow() {
    HapticFeedback.mediumImpact();
    setState(() {
      _followingStores[_currentIndex] =
          !(_followingStores[_currentIndex] ?? false);
    });

    final storeName = _videos[_currentIndex]['storeName'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _followingStores[_currentIndex] == true
              ? 'تتابع الآن $storeName'
              : 'تم إلغاء متابعة $storeName',
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: darkBg,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showComments() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCommentsSheet(),
    );
  }

  void _shareProduct() {
    HapticFeedback.lightImpact();
    final video = _videos[_currentIndex];
    SharePlus.instance.share(
      ShareParams(
        text:
            'شاهد ${video['productName']} بسعر ${video['price'].toInt()} ر.س فقط! 🛒\n\nحمّل تطبيق MBUY الآن',
        title: video['productName'],
      ),
    );
  }

  void _addToCart() {
    HapticFeedback.heavyImpact();
    final video = _videos[_currentIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'تمت إضافة ${video['productName']} إلى السلة',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: darkBg,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'عرض السلة',
          textColor: primaryColor,
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        onPageChanged: (index) {
          HapticFeedback.selectionClick();
          setState(() {
            _currentIndex = index;
            _isPaused = false;
          });
        },
        itemBuilder: (context, index) {
          final video = _videos[index];
          return GestureDetector(
            onDoubleTap: _handleDoubleTap,
            onTap: _handleSingleTap,
            child: Stack(
              children: [
                // Video Background
                _buildVideoBackground(video['thumbnail']),

                // Gradient Overlay
                _buildGradientOverlay(),

                // Pause Icon
                if (_isPaused) _buildPauseOverlay(),

                // Heart Animation (Double-tap)
                if (_showHeartAnimation) _buildHeartAnimation(),

                // Top Navigation Bar
                _buildTopNavBar(),

                // Main Content (Product Info + Sidebar)
                _buildMainContent(video, index),

                // Progress Bar
                _buildProgressBar(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoBackground(String? thumbnail) {
    return Positioned.fill(
      child: Image.network(
        thumbnail ??
            widget.thumbnailUrl ??
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade900,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    color: primaryColor,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'جاري التحميل...',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade900,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.grey.shade600,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'فشل تحميل الفيديو',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: _isPaused ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeartAnimation() {
    return Positioned.fill(
      child: Center(
        child: AnimatedBuilder(
          animation: _heartScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _heartScaleAnimation.value,
              child: Icon(
                Icons.favorite,
                color: Colors.red.withValues(alpha: 0.9),
                size: 120,
                shadows: const [Shadow(color: Colors.black38, blurRadius: 20)],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.5, 1.0],
            colors: [
              Colors.black.withValues(alpha: 0.4),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button (Right in RTL)
              _buildCircleButton(
                icon: Icons.chevron_right,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),

              // Search & Menu (Left in RTL)
              Row(
                children: [
                  _buildCircleButton(
                    icon: Icons.search,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // TODO: Implement search
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildMenuButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    double iconSize = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.2),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        HapticFeedback.lightImpact();
        // Handle menu selection
      },
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.2),
        ),
        child: const Icon(Icons.more_vert, color: Colors.white, size: 24),
      ),
      color: darkBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        _buildMenuItem('شرح المنتج', Icons.info_outline),
        _buildMenuItem('عدم ظهور هذا النوع', Icons.visibility_off_outlined),
        _buildMenuItem('إبلاغ', Icons.flag_outlined),
        _buildMenuItem('ملاحظات', Icons.note_outlined),
        _buildMenuItem('اقتراحات', Icons.lightbulb_outline),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(String text, IconData icon) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildMainContent(Map<String, dynamic> video, int index) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Positioned(
      bottom: 24 + bottomPadding,
      left: 16,
      right: 16,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Product Info (Right side - 75%)
              Expanded(flex: 3, child: _buildProductInfo(video)),

              // Interaction Sidebar (Left side)
              _buildInteractionSidebar(video, index),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> video) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
            ),
            child: const Text(
              'وصل حديثاً',
              style: TextStyle(
                color: primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Product Title
          Text(
            video['productName'] ?? widget.productName ?? 'سماعات لاسلكية برو',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
          const SizedBox(height: 4),

          // Description
          Text(
            video['description'] ??
                widget.productDescription ??
                'تجربة صوتية لا مثيل لها مع عزل ضوضاء فائق وتصميم مريح للأذن، بطارية تدوم طويلاً.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 12,
              height: 1.4,
              shadows: const [Shadow(color: Colors.black38, blurRadius: 2)],
            ),
          ),
          const SizedBox(height: 6),

          // Price
          Row(
            children: [
              Text(
                '${(video['price'] as double?)?.toInt() ?? widget.price?.toInt() ?? 150} ر.س',
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if ((video['oldPrice'] ?? widget.oldPrice) != null) ...[
                const SizedBox(width: 6),
                Text(
                  '${((video['oldPrice'] ?? widget.oldPrice) as double).toInt()} ر.س',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey.shade400,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),

          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: darkBg,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                shadowColor: primaryColor.withValues(alpha: 0.4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'أضف إلى السلة',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionSidebar(Map<String, dynamic> video, int index) {
    final isLiked = _likedVideos[index] ?? false;
    final isDisliked = _dislikedVideos[index] ?? false;
    final isSaved = _savedVideos[index] ?? false;
    final isFollowing = _followingStores[index] ?? false;
    final likes = (video['likes'] as int?) ?? 0;
    final comments = (video['comments'] as int?) ?? 0;

    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 8),
      child: Column(
        children: [
          // Account/Follow with Store Name
          _buildFollowButton(video, isFollowing),
          const SizedBox(height: 16),

          // Like
          _buildSidebarAction(
            icon: Icons.favorite,
            label: _formatCount(likes + (isLiked ? 1 : 0)),
            isActive: isLiked,
            activeColor: Colors.red,
            onTap: _toggleLike,
          ),

          // Dislike
          _buildSidebarAction(
            icon: Icons.thumb_down,
            label: 'لم يعجبني',
            isActive: isDisliked,
            activeColor: Colors.red.shade300,
            onTap: _toggleDislike,
          ),

          // Comments
          _buildSidebarAction(
            icon: Icons.chat_bubble,
            label: _formatCount(comments),
            onTap: _showComments,
          ),

          // Save
          _buildSidebarAction(
            icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
            label: 'حفظ',
            isActive: isSaved,
            activeColor: primaryColor,
            onTap: _toggleSave,
          ),

          // Share
          _buildSidebarAction(
            icon: Icons.reply,
            label: 'مشاركة',
            isFlipped: true,
            onTap: _shareProduct,
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  Widget _buildFollowButton(Map<String, dynamic> video, bool isFollowing) {
    final storeName = video['storeName'] ?? 'المتجر';
    final storeAvatar = video['storeAvatar'];

    return GestureDetector(
      onTap: _toggleFollow,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    storeAvatar ??
                        widget.storeAvatar ??
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -5,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: isFollowing ? Colors.grey : primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFollowing ? Icons.check : Icons.add,
                      size: 12,
                      color: isFollowing ? Colors.white : darkBg,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Store Name
          SizedBox(
            width: 50,
            child: Text(
              storeName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarAction({
    required IconData icon,
    required String label,
    bool isActive = false,
    Color? activeColor,
    bool isFlipped = false,
    bool isSubtle = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.2),
              ),
              child: Transform(
                alignment: Alignment.center,
                transform: isFlipped
                    ? (Matrix4.identity()..setEntry(0, 0, -1))
                    : Matrix4.identity(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    key: ValueKey('$icon-$isActive'),
                    color: isActive
                        ? activeColor
                        : (isSubtle ? Colors.white70 : Colors.white),
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSubtle ? Colors.white70 : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                shadows: const [Shadow(color: Colors.black54, blurRadius: 2)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Positioned(
      bottom: 8 + bottomPadding,
      left: 16,
      right: 16,
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(2),
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: _isPaused ? 0.65 : 1.0),
          duration: Duration(seconds: _isPaused ? 0 : 15),
          builder: (context, value, child) {
            return FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommentsSheet() {
    final video = _videos[_currentIndex];
    final comments = [
      {'user': 'أحمد', 'text': 'منتج رائع! جربته وأنصح به', 'time': '2 ساعة'},
      {'user': 'سارة', 'text': 'هل متوفر بلون آخر؟', 'time': '5 ساعات'},
      {'user': 'محمد', 'text': 'السعر ممتاز 👍', 'time': '1 يوم'},
      {'user': 'نورة', 'text': 'طلبته وجاني بسرعة', 'time': '2 يوم'},
      {'user': 'خالد', 'text': 'جودة عالية فعلاً', 'time': '3 أيام'},
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: darkBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${video['comments']} تعليق',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12),
              // Comments List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey.shade700,
                            child: Text(
                              comment['user']![0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment['user']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      comment['time']!,
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment['text']!,
                                  style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.grey.shade500,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Comment Input
              Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  12 + MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  border: Border(
                    top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'أضف تعليقاً...',
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                        icon: const Icon(Icons.send, color: darkBg, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
