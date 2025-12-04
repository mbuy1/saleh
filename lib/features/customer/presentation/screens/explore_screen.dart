import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ExploreScreen extends StatefulWidget {
  final String? userRole;
  const ExploreScreen({super.key, this.userRole});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: 10, // Mock 10 videos
        itemBuilder: (context, index) {
          return _buildVideoItem(index);
        },
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
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/50',
                    ),
                    backgroundColor: Colors.white,
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
