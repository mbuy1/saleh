import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({super.key});

  @override
  ConsumerState<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // TODO: Replace with API data
  final List<MediaItem> _mediaItems = [
    MediaItem(
      id: '1',
      type: MediaType.video,
      url:
          'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
      thumbnailUrl: 'https://picsum.photos/400/700?random=70',
      storeName: 'متجر الإلكترونيات',
      storeLogoUrl: 'https://picsum.photos/50?random=71',
      description: 'شاهد أحدث سماعات البلوتوث بجودة صوت مذهلة 🎧',
      likesCount: 1234,
      commentsCount: 89,
      sharesCount: 45,
      productId: '1',
      productName: 'سماعات بلوتوث لاسلكية',
      productPrice: 149,
    ),
    MediaItem(
      id: '2',
      type: MediaType.image,
      url: 'https://picsum.photos/400/700?random=72',
      thumbnailUrl: 'https://picsum.photos/400/700?random=72',
      storeName: 'أزياء العائلة',
      storeLogoUrl: 'https://picsum.photos/50?random=73',
      description: 'تشكيلة الصيف الجديدة وصلت! 👗✨',
      likesCount: 567,
      commentsCount: 34,
      sharesCount: 12,
      productId: '2',
      productName: 'فستان صيفي أنيق',
      productPrice: 299,
    ),
    MediaItem(
      id: '3',
      type: MediaType.image,
      url: 'https://picsum.photos/400/700?random=74',
      thumbnailUrl: 'https://picsum.photos/400/700?random=74',
      storeName: 'بيت الجمال',
      storeLogoUrl: 'https://picsum.photos/50?random=75',
      description: 'اكتشفي سر البشرة المشرقة 💄',
      likesCount: 890,
      commentsCount: 56,
      sharesCount: 23,
      productId: '3',
      productName: 'طقم عناية بالبشرة',
      productPrice: 399,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        setState(() => _currentPage = index);
      },
      itemCount: _mediaItems.length,
      itemBuilder: (context, index) {
        return _buildMediaPage(_mediaItems[index], index == _currentPage);
      },
    );
  }

  Widget _buildMediaPage(MediaItem item, bool isActive) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Media
        if (item.type == MediaType.image)
          Image.network(
            item.url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(Icons.image, color: Colors.white54, size: 50),
                ),
              );
            },
          )
        else
          _VideoPlayerWidget(url: item.url, isActive: isActive),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
              stops: const [0.5, 1.0],
            ),
          ),
        ),

        // Right Side Actions
        Positioned(
          right: 16,
          bottom: 200,
          child: Column(
            children: [
              // Like
              _buildActionButton(
                icon: Icons.favorite,
                label: _formatCount(item.likesCount),
                color: Colors.red,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              // Comment
              _buildActionButton(
                icon: Icons.comment,
                label: _formatCount(item.commentsCount),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              // Share
              _buildActionButton(
                icon: Icons.share,
                label: _formatCount(item.sharesCount),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              // Cart
              _buildActionButton(
                icon: Icons.shopping_cart,
                label: 'شراء',
                onTap: () {},
              ),
            ],
          ),
        ),

        // Bottom Content
        Positioned(
          left: 16,
          right: 70,
          bottom: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(item.storeLogoUrl),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.storeName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'متابعة',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                item.description,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Product Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.thumbnailUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${item.productPrice} ر.س',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'اشتري الآن',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color ?? Colors.white, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
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

class _VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool isActive;

  const _VideoPlayerWidget({required this.url, required this.isActive});

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    try {
      await _controller.initialize();
      _controller.setLooping(true);
      if (mounted) {
        setState(() => _isInitialized = true);
        if (widget.isActive) {
          _controller.play();
        }
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void didUpdateWidget(_VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.play();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
      },
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

enum MediaType { image, video }

class MediaItem {
  final String id;
  final MediaType type;
  final String url;
  final String thumbnailUrl;
  final String storeName;
  final String storeLogoUrl;
  final String description;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final String productId;
  final String productName;
  final double productPrice;

  MediaItem({
    required this.id,
    required this.type,
    required this.url,
    required this.thumbnailUrl,
    required this.storeName,
    required this.storeLogoUrl,
    required this.description,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.productId,
    required this.productName,
    required this.productPrice,
  });
}
