import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/mbuy_studio_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../merchant/data/merchant_store_provider.dart';

class MbuyStudioScreen extends ConsumerStatefulWidget {
  const MbuyStudioScreen({super.key});

  @override
  ConsumerState<MbuyStudioScreen> createState() => _MbuyStudioScreenState();
}

class _MbuyStudioScreenState extends ConsumerState<MbuyStudioScreen> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _promptOptionalController =
      TextEditingController();
  bool _isGenerating = false;
  String _statusMessage = '';
  String? _generatedImageUrl;
  int _currentBannerPage = 0;
  String? _selectedDesignType; // للتصنيف المحدد في Pro/Premium

  @override
  void dispose() {
    _promptController.dispose();
    _promptOptionalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Purple Gradient Header with Search
            SliverToBoxAdapter(child: _buildGradientHeader(context)),
            // Main Content (White Background)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // C) Big Cards Grid (2 columns)
                    _buildBigCardsSection(context),
                    // D) Recent Projects
                    _buildRecentProjectsSection(),
                    // E) Tools Grid (3 columns)
                    _buildToolsGridSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusL,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.textSecondaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: AppDimensions.borderRadiusL,
        ),
        tabs: const [
          Tab(text: 'Free'),
          Tab(text: 'Pro'),
          Tab(text: 'Premium'),
        ],
      ),
    );
  }

  Widget _buildFreeTab() {
    return SingleChildScrollView(
      padding: AppDimensions.screenPaddingHorizontalOnly,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.spacing16),
          _buildSectionTitle('قوالب جاهزة'),
          const SizedBox(height: AppDimensions.spacing12),
          _buildFreeTemplates(),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSectionTitle('صور منتجات'),
          const SizedBox(height: AppDimensions.spacing12),
          _buildProductImagesGrid(),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSectionTitle('بانرات'),
          const SizedBox(height: AppDimensions.spacing12),
          _buildBannersGrid(),
          const SizedBox(height: AppDimensions.spacing32),
        ],
      ),
    );
  }

  Widget _buildProTab() {
    return SingleChildScrollView(
      padding: AppDimensions.screenPaddingHorizontalOnly,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.spacing24),
          _buildProCategories(),
          const SizedBox(height: AppDimensions.spacing24),
          if (_generatedImageUrl != null) ...[
            _buildGeneratedResult(),
            const SizedBox(height: AppDimensions.spacing24),
          ],
        ],
      ),
    );
  }

  Widget _buildPremiumTab() {
    return SingleChildScrollView(
      padding: AppDimensions.screenPaddingHorizontalOnly,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.spacing24),
          _buildPremiumCategories(),
          const SizedBox(height: AppDimensions.spacing24),
          if (_generatedImageUrl != null) ...[
            _buildGeneratedResult(),
            const SizedBox(height: AppDimensions.spacing24),
          ],
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() => _currentBannerPage = index);
            },
            itemCount: 3,
            itemBuilder: (context, index) => _buildBannerCard(),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isActive = _currentBannerPage == index;
            return AnimatedContainer(
              duration: AppDimensions.animationFast,
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing4,
              ),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: AppDimensions.borderRadiusXS,
                color: isActive ? AppTheme.accentColor : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }

  // Purple Gradient Header - Matching Image
  Widget _buildGradientHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.headerBannerGradient),
      child: Column(
        children: [
          // Search Icon (Top Left)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          // Promo Chip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.diamond, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      const Text(
                        'جرب خطة Pro لمدة 7 يوم مقابل 0 ريال',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Banana Image Placeholder + Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                // Banana placeholder
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🍌', style: TextStyle(fontSize: 60)),
                  ),
                ),
                const SizedBox(height: 16),
                // AI Tools Title
                const Text(
                  'أدوات الصور المدعومة بالذكاء الاصطناعي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Powered by Nano Banana Pro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'مدعومة من',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Nano Banana info
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Nano Banana Pro',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_back_ios,
                            size: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // C) Big Cards Section
  Widget _buildBigCardsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildBigCard(
              context: context,
              title: 'تعديل الصورة',
              icon: Icons.image_outlined,
              hasProBadge: true,
              onTap: () => _openImageEdit(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildBigCard(
              context: context,
              title: 'فيديو جديد',
              icon: Icons.add_circle_outline,
              isVideo: true,
              onTap: () => _openVideoNew(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    bool hasProBadge = false,
    bool isVideo = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[50],
          ),
          child: AspectRatio(
            aspectRatio: 1.7,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isVideo)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        ),
                        child: Icon(
                          icon,
                          size: 28,
                          color: AppTheme.primaryColor,
                        ),
                      )
                    else
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(icon, size: 48, color: AppTheme.primaryColor),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                if (hasProBadge)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 10, color: Colors.white),
                          const SizedBox(width: 2),
                          const Text(
                            'Pro',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (hasProBadge)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 10, color: Colors.white),
                          const SizedBox(width: 2),
                          const Text(
                            'Nar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // D) Recent Projects Section
  Widget _buildRecentProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: const Text(
            'المشاريع الأخيرة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
        SizedBox(
          height: 74,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: 74,
                margin: EdgeInsets.only(right: index < 3 ? 10 : 0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Placeholder image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_outlined,
                          size: 32,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    // Overlay icons/numbers
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${1000 + index * 10}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // E) Tools Grid Section
  Widget _buildToolsGridSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),
        itemCount: 9,
        itemBuilder: (context, index) => _buildToolTile(context, index),
      ),
    );
  }

  Widget _buildToolTile(BuildContext context, int index) {
    final tools = [
      {'title': 'المساحة', 'icon': Icons.cloud_outlined, 'hasPro': false},
      {
        'title': 'التنميق',
        'icon': Icons.auto_fix_high_outlined,
        'hasPro': false,
      },
      {'title': 'AutoCut', 'icon': Icons.play_circle_outline, 'hasPro': false},
      {
        'title': 'أدوات الصور',
        'icon': Icons.camera_alt_outlined,
        'hasPro': false,
      },
      {
        'title': 'التحسين التلقائي',
        'icon': Icons.auto_awesome_outlined,
        'hasPro': false,
      },
      {
        'title': 'أداة تعديل سطح المكتب',
        'icon': Icons.desktop_windows_outlined,
        'hasPro': true,
      },
      {
        'title': 'الشرح التلقائي',
        'icon': Icons.subtitles_outlined,
        'hasPro': false,
      },
      {'title': 'إزالة الخلفية', 'icon': Icons.person_outline, 'hasPro': false},
      {
        'title': 'أدوات التسويق',
        'icon': Icons.shopping_bag_outlined,
        'hasPro': false,
      },
    ];

    final tool = tools[index];
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _openTool(context, tool['title'] as String),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tool['icon'] as IconData,
                    size: 26,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tool['title'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if (tool['hasPro'] == true)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF60A5FA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'خطة Pro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation methods
  void _openImageEdit(BuildContext context) {
    // Open Pro/Premium tab or selection screen
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر نوع التعديل',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.star_outline, color: Colors.orange),
              title: const Text('Pro - تعديل بجودة عادية'),
              onTap: () {
                Navigator.pop(context);
                _showProGeneration(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('Premium - تعديل احترافي'),
              onTap: () {
                Navigator.pop(context);
                _showPremiumGeneration(context);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _openVideoNew(BuildContext context) {
    context.push('/dashboard/feature/${Uri.encodeComponent('فيديو جديد')}');
  }

  void _openTool(BuildContext context, String toolName) {
    // Map tools to existing screens or placeholder
    final toolRoutes = {
      'أدوات التسويق': '/dashboard/marketing',
      'تعديل الصور AI': '/dashboard/studio',
    };

    final route = toolRoutes[toolName];
    if (route != null) {
      context.push(route);
    } else {
      context.push('/dashboard/feature/${Uri.encodeComponent(toolName)}');
    }
  }

  void _showProGeneration(BuildContext context) {
    // Show Pro generation form
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'توليد تصميم (Pro)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'اسم/نوع المنتج',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _promptOptionalController,
              decoration: const InputDecoration(
                labelText: 'Prompt (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startProGeneration();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('توليد'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showPremiumGeneration(BuildContext context) {
    // Show Premium generation form
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'توليد احترافي (Premium)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'اسم/نوع المنتج',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _promptOptionalController,
              decoration: const InputDecoration(
                labelText: 'Prompt (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startPremiumGeneration();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('توليد'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      margin: AppDimensions.screenPaddingHorizontalOnly,
      decoration: BoxDecoration(
        borderRadius: AppDimensions.borderRadiusL,
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentColor.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 50,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.infoColor.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: AppDimensions.screenPadding,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'تتضمن 16+ نموذج صور وفيديو',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.fontTitle,
                          fontWeight: FontWeight.w600,
                          height: AppDimensions.lineHeightNormal,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: AppDimensions.spacing16),
                      ElevatedButton(
                        onPressed: () => _showGenerateDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing24,
                            vertical: AppDimensions.spacing10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppDimensions.borderRadiusXL,
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'إنشاء',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimensions.fontBody,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing16),
                _buildAppIconsGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIconsGrid() {
    return SizedBox(
      width: 100,
      child: Wrap(
        spacing: AppDimensions.spacing8,
        runSpacing: AppDimensions.spacing8,
        alignment: WrapAlignment.end,
        children: [
          _buildAppIcon(Icons.auto_awesome, AppTheme.accentColor),
          _buildAppIcon(Icons.palette, AppTheme.successColor),
          _buildAppIcon(Icons.camera_alt, AppTheme.infoColor),
          _buildAppIcon(Icons.movie, AppTheme.warningColor),
        ],
      ),
    );
  }

  Widget _buildAppIcon(IconData icon, Color color) {
    return Container(
      width: AppDimensions.buttonHeightM,
      height: AppDimensions.buttonHeightM,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusM,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: AppDimensions.iconM, color: color),
    );
  }

  Widget _buildMainCategories() {
    final categories = [
      _CategoryItem(
        title: 'توليد الصور',
        taskType: 'ai_image',
        icon: Icons.image_outlined,
        color: AppTheme.infoColor,
      ),
      _CategoryItem(
        title: 'توليد الفيديو',
        taskType: 'video_promo',
        icon: Icons.play_circle_outline,
        color: AppTheme.accentColor,
      ),
      _CategoryItem(
        title: 'توليد فوري',
        taskType: 'image_instant',
        icon: Icons.flash_on_outlined,
        color: AppTheme.successColor,
      ),
    ];

    return Padding(
      padding: AppDimensions.screenPaddingHorizontalOnly,
      child: Row(
        children: categories.map((cat) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing4,
              ),
              child: _buildCategoryCard(cat),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryCard(_CategoryItem category) {
    return Material(
      color: AppTheme.surfaceColor,
      borderRadius: AppDimensions.borderRadiusM,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDesignType = category.taskType;
          });
        },
        borderRadius: AppDimensions.borderRadiusM,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderRadiusM,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: AppDimensions.borderRadiusM,
                ),
                child: Center(
                  child: Icon(
                    category.icon,
                    size: AppDimensions.iconXL,
                    color: category.color,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: AppDimensions.fontBody2,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: AppDimensions.screenPaddingHorizontalOnly,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('عرض جميع $title'),
                  backgroundColor: AppTheme.primaryColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'عرض الكل',
              style: TextStyle(
                fontSize: AppDimensions.fontBody2,
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppDimensions.fontHeadline,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickApps() {
    final apps = [
      _QuickAppItem(
        title: 'التحسين الجماعي',
        taskType: 'bulk_improve',
        icon: Icons.auto_awesome,
        isNew: true,
        isBulk: true,
      ),
      _QuickAppItem(
        title: 'نقل الأسلوب',
        taskType: 'style_transfer',
        icon: Icons.style_outlined,
        isNew: false,
      ),
      _QuickAppItem(
        title: 'الحفاظ على الوجه',
        taskType: 'face_preserve',
        icon: Icons.face_outlined,
        isNew: true,
      ),
      _QuickAppItem(
        title: 'إزالة العلامة المائية',
        taskType: 'remove_watermark',
        icon: Icons.layers_clear_outlined,
        isNew: true,
      ),
      _QuickAppItem(
        title: 'تحسين الصورة',
        taskType: 'enhance_image',
        icon: Icons.auto_fix_high,
        isNew: false,
      ),
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppDimensions.screenPaddingHorizontalOnly,
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return _buildQuickAppCard(app);
        },
      ),
    );
  }

  Widget _buildQuickAppCard(_QuickAppItem app) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(left: AppDimensions.spacing12),
      child: Material(
        color: AppTheme.surfaceColor,
        borderRadius: AppDimensions.borderRadiusM,
        child: InkWell(
          onTap: () {
            if (app.isBulk) {
              _showBulkImproveDialog();
            } else {
              _showGenerateDialog(taskType: app.taskType);
            }
          },
          borderRadius: AppDimensions.borderRadiusM,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppDimensions.borderRadiusM,
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.06),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppDimensions.radiusM),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            app.icon,
                            size: AppDimensions.iconHero,
                            color: AppTheme.primaryColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.spacing10),
                      child: Text(
                        app.title,
                        style: const TextStyle(
                          fontSize: AppDimensions.fontLabel,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (app.isNew)
                  Positioned(
                    top: AppDimensions.spacing8,
                    left: AppDimensions.spacing8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing8,
                        vertical: AppDimensions.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: AppDimensions.borderRadiusXS,
                      ),
                      child: const Text(
                        'جديد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.fontCaption,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _build3DModels() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppDimensions.screenPaddingHorizontalOnly,
        itemCount: 4,
        itemBuilder: (context, index) {
          return _build3DModelCard();
        },
      ),
    );
  }

  Widget _build3DModelCard() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: AppDimensions.spacing12),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppDimensions.borderRadiusM,
        child: InkWell(
          onTap: () => _showGenerateDialog(taskType: '3d_model'),
          borderRadius: AppDimensions.borderRadiusM,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppDimensions.borderRadiusM,
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.view_in_ar,
                  size: 48,
                  color: Colors.cyan.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'نموذج 3D',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.fontBody2,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFreeTemplates() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacing12,
        mainAxisSpacing: AppDimensions.spacing12,
        childAspectRatio: 0.85,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildFreeItemCard(
          title: 'قالب ${index + 1}',
          icon: Icons.image_outlined,
          onTap: () => _useTemplate(index),
        );
      },
    );
  }

  Widget _buildProductImagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacing12,
        mainAxisSpacing: AppDimensions.spacing12,
        childAspectRatio: 0.85,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildFreeItemCard(
          title: 'صورة منتج ${index + 1}',
          icon: Icons.shopping_bag_outlined,
          onTap: () => _downloadImage(index),
        );
      },
    );
  }

  Widget _buildBannersGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacing12,
        mainAxisSpacing: AppDimensions.spacing12,
        childAspectRatio: 1.3,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildFreeItemCard(
          title: 'بانر ${index + 1}',
          icon: Icons.campaign_outlined,
          onTap: () => _useBanner(index),
        );
      },
    );
  }

  Widget _buildFreeItemCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppTheme.surfaceColor,
      borderRadius: AppDimensions.borderRadiusM,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensions.borderRadiusM,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: AppDimensions.borderRadiusM,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Preview placeholder
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusM),
                    ),
                  ),
                  child: Icon(icon, color: Colors.grey[600], size: 40),
                ),
              ),
              // Title and button
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: AppDimensions.fontCaption,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 28,
                        child: ElevatedButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.download, size: 14),
                          label: const Text(
                            'استخدام',
                            style: TextStyle(fontSize: 11),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 28),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProCategories() {
    final categories = [
      _CategoryItem(
        title: 'صورة منتج',
        taskType: 'product_image',
        icon: Icons.image_outlined,
        color: AppTheme.infoColor,
      ),
      _CategoryItem(
        title: 'بانر',
        taskType: 'banner',
        icon: Icons.campaign_outlined,
        color: AppTheme.accentColor,
      ),
      _CategoryItem(
        title: 'تصميم سوشيال',
        taskType: 'social_design',
        icon: Icons.share_outlined,
        color: AppTheme.successColor,
      ),
      _CategoryItem(
        title: 'خلفية/دمج',
        taskType: 'background_merge',
        icon: Icons.layers_outlined,
        color: AppTheme.warningColor,
      ),
    ];

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppDimensions.spacing12,
            mainAxisSpacing: AppDimensions.spacing12,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(categories[index]);
          },
        ),
        const SizedBox(height: AppDimensions.spacing24),
        _buildProInputForm(),
      ],
    );
  }

  Widget _buildPremiumCategories() {
    final categories = [
      _CategoryItem(
        title: 'صورة احترافية',
        taskType: 'professional_image',
        icon: Icons.high_quality_outlined,
        color: AppTheme.infoColor,
      ),
      _CategoryItem(
        title: 'إعلان',
        taskType: 'advertisement',
        icon: Icons.ads_click_outlined,
        color: AppTheme.accentColor,
      ),
      _CategoryItem(
        title: 'دمج مشهد',
        taskType: 'scene_merge',
        icon: Icons.landscape_outlined,
        color: AppTheme.successColor,
      ),
      _CategoryItem(
        title: 'فيديو قصير',
        taskType: 'short_video',
        icon: Icons.video_library_outlined,
        color: AppTheme.warningColor,
      ),
    ];

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppDimensions.spacing12,
            mainAxisSpacing: AppDimensions.spacing12,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(categories[index]);
          },
        ),
        const SizedBox(height: AppDimensions.spacing24),
        _buildPremiumInputForm(),
      ],
    );
  }

  Widget _buildProInputForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'توليد تصميم (Pro - Cloudflare)',
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'اسم/نوع المنتج',
                hintText: 'مثال: قهوة عربية',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            TextField(
              controller: _promptOptionalController,
              decoration: const InputDecoration(
                labelText: 'Prompt (اختياري)',
                hintText: 'وصف التصميم المطلوب...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            if (_isGenerating) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
            ] else
              ElevatedButton(
                onPressed: () => _startProGeneration(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('توليد'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumInputForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'توليد احترافي (Premium - Nano Banana)',
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'اسم/نوع المنتج',
                hintText: 'مثال: قهوة عربية',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            TextField(
              controller: _promptOptionalController,
              decoration: const InputDecoration(
                labelText: 'Prompt (اختياري)',
                hintText: 'وصف التصميم المطلوب...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            if (_isGenerating) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
            ] else
              ElevatedButton(
                onPressed: () => _startPremiumGeneration(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('توليد'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedResult() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'النتيجة',
              style: TextStyle(
                fontSize: AppDimensions.fontTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            if (_generatedImageUrl != null)
              ClipRRect(
                borderRadius: AppDimensions.borderRadiusM,
                child: Image.network(
                  _generatedImageUrl!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.error_outline, size: 48),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _saveResult(),
                    icon: const Icon(Icons.save),
                    label: const Text('حفظ'),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadResult(),
                    icon: const Icon(Icons.download),
                    label: const Text('تحميل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _useTemplate(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم استخدام القالب ${index + 1}'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _downloadImage(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحميل صورة المنتج ${index + 1}'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _useBanner(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم استخدام البانر ${index + 1}'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _saveResult() {
    // TODO: حفظ النتيجة في نظام الميديا
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ النتيجة'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _downloadResult() {
    // TODO: تحميل النتيجة
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحميل النتيجة'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  Widget _buildNanoBananaCard() {
    return Container(
      margin: AppDimensions.screenPaddingHorizontalOnly,
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showGenerateDialog(taskType: 'nano_banana'),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.amber,
                size: 24,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nano Banana AI',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontTitle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'توليد محتوى متقدم باستخدام أحدث النماذج',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: AppDimensions.fontCaption,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showGenerateDialog({String taskType = 'ai_image'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.bottomSheetRadius),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: AppDimensions.spacing20,
          right: AppDimensions.spacing20,
          top: AppDimensions.spacing20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: AppDimensions.spacing40,
              height: AppDimensions.spacing4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: AppDimensions.borderRadiusXS,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing20),
            // Title
            const Text(
              'توليد محتوى إبداعي',
              style: TextStyle(
                fontSize: AppDimensions.fontDisplay3,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing20),
            // Input
            TextField(
              controller: _promptController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'اكتب وصف الصورة أو الفيديو...',
                hintTextDirection: TextDirection.rtl,
                hintStyle: TextStyle(
                  color: AppTheme.textHintColor,
                  fontSize: AppDimensions.fontBody,
                ),
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: AppDimensions.borderRadiusM,
                  borderSide: BorderSide.none,
                ),
                contentPadding: AppDimensions.screenPadding,
              ),
              maxLines: 3,
              style: const TextStyle(
                fontSize: AppDimensions.fontBody,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing20),
            // Status & Result
            if (_isGenerating) ...[
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
              const SizedBox(height: AppDimensions.spacing12),
              Text(
                _statusMessage,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: AppDimensions.fontBody,
                ),
              ),
            ] else if (_generatedImageUrl != null) ...[
              ClipRRect(
                borderRadius: AppDimensions.borderRadiusM,
                child: Image.network(
                  _generatedImageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing12),
              Text(
                _statusMessage,
                style: const TextStyle(
                  color: AppTheme.successColor,
                  fontSize: AppDimensions.fontBody,
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightXL,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (taskType == 'nano_banana') {
                      _startPremiumGeneration();
                    } else {
                      setState(() {
                        _selectedDesignType = taskType;
                      });
                      _startProGeneration();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDimensions.borderRadiusM,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'توليد الآن',
                    style: TextStyle(
                      fontSize: AppDimensions.fontTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.spacing24),
          ],
        ),
      ),
    );
  }

  Future<void> _startProGeneration() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('الرجاء كتابة اسم/نوع المنتج'),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusS,
          ),
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _statusMessage = 'جاري توليد التصميم عبر Cloudflare...';
      _generatedImageUrl = null;
    });

    try {
      final service = ref.read(mbuyStudioServiceProvider);
      final result = await service.generateDesign(
        tier: 'pro',
        productName: _promptController.text,
        prompt: _promptOptionalController.text.isNotEmpty
            ? _promptOptionalController.text
            : null,
        action: 'generate_design',
        designType: _selectedDesignType ?? 'product_image',
      );

      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        if (result['ok'] == true || result['success'] == true) {
          _statusMessage = 'تم الانتهاء!';
          final data = result['data'] ?? result['result'] ?? result;
          if (data['image'] != null) {
            _generatedImageUrl = data['image'];
          } else if (data is String && data.startsWith('data:image')) {
            _generatedImageUrl = data;
          } else if (data['url'] != null) {
            _generatedImageUrl = data['url'];
          }
        } else {
          _statusMessage = result['error'] ?? 'حدث خطأ غير معروف';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        _statusMessage = 'حدث خطأ: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _startPremiumGeneration() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء كتابة اسم/نوع المنتج'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _statusMessage = 'جاري توليد التصميم الاحترافي عبر Nano Banana...';
      _generatedImageUrl = null;
    });

    try {
      final service = ref.read(mbuyStudioServiceProvider);
      final result = await service.generateDesign(
        tier: 'premium',
        productName: _promptController.text,
        prompt: _promptOptionalController.text.isNotEmpty
            ? _promptOptionalController.text
            : null,
        action: 'generate_design',
        designType: _selectedDesignType ?? 'professional_image',
      );

      if (!mounted) return;

      // إذا كان هناك taskId، نبدأ polling
      if (result['taskId'] != null) {
        final taskId = result['taskId'] as String;
        setState(() {
          _statusMessage = 'تم بدء المهمة ($taskId). جاري المعالجة...';
        });

        // Polling للحصول على النتيجة
        int attempts = 0;
        while (attempts < 10 && mounted) {
          await Future.delayed(const Duration(seconds: 2));
          attempts++;

          try {
            final taskInfo = await service.getTask(taskId);
            if (taskInfo['status'] == 'completed' &&
                taskInfo['result'] != null) {
              final results = taskInfo['result'] as List?;
              if (results != null && results.isNotEmpty) {
                if (!mounted) return;
                setState(() {
                  _isGenerating = false;
                  _statusMessage = 'تم الانتهاء!';
                  _generatedImageUrl = results.first as String?;
                });
                return;
              }
            } else if (taskInfo['status'] == 'failed') {
              if (!mounted) return;
              setState(() {
                _isGenerating = false;
                _statusMessage = 'فشل التوليد';
              });
              return;
            }
          } catch (e) {
            // Continue polling
          }
        }

        if (!mounted) return;
        setState(() {
          _isGenerating = false;
          _statusMessage = 'انتهت محاولات الاستعلام';
        });
      } else if (result['ok'] == true || result['success'] == true) {
        // نتيجة مباشرة
        setState(() {
          _isGenerating = false;
          _statusMessage = 'تم الانتهاء!';
          final data = result['data'] ?? result['result'] ?? result;
          if (data['image'] != null) {
            _generatedImageUrl = data['image'];
          } else if (data is String && data.startsWith('data:image')) {
            _generatedImageUrl = data;
          } else if (data['url'] != null) {
            _generatedImageUrl = data['url'];
          }
        });
      } else {
        setState(() {
          _isGenerating = false;
          _statusMessage = result['error'] ?? 'حدث خطأ غير معروف';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        _statusMessage = 'حدث خطأ: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  // ============================================
  // Bulk Improve Dialog
  // ============================================
  void _showBulkImproveDialog() {
    String selectedMode = 'enhance'; // Default mode
    bool isProcessing = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('التحسين الجماعي للمنتجات'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'تحسين جميع صور منتجات متجرك تلقائياً',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  'اختر وضع التحسين:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildModeOption(
                  'تحسين الجودة',
                  'enhance',
                  selectedMode,
                  (value) => setState(() => selectedMode = value),
                  isProcessing,
                ),
                const SizedBox(height: 10),
                _buildModeOption(
                  'إزالة الخلفية',
                  'remove_bg',
                  selectedMode,
                  (value) => setState(() => selectedMode = value),
                  isProcessing,
                ),
                const SizedBox(height: 10),
                _buildModeOption(
                  'نمط استوديو',
                  'studio_style',
                  selectedMode,
                  (value) => setState(() => selectedMode = value),
                  isProcessing,
                ),
                const SizedBox(height: 20),
                if (isProcessing)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isProcessing ? null : () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() => isProcessing = true);
                      await _startBulkImprove(selectedMode);
                      if (context.mounted) {
                        setState(() => isProcessing = false);
                      }
                    },
              child: const Text('ابدأ التحسين'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
    String label,
    String value,
    String selectedMode,
    Function(String) onChanged,
    bool isProcessing,
  ) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: value,
        // ignore: deprecated_member_use
        groupValue: selectedMode,
        // ignore: deprecated_member_use
        onChanged: isProcessing ? null : (String? v) => onChanged(v ?? ''),
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
      onTap: isProcessing ? null : () => onChanged(value),
    );
  }

  Future<void> _startBulkImprove(String mode) async {
    try {
      // Get store ID
      final store = ref.read(merchantStoreProvider);
      if (store == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لم يتم العثور على المتجر'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Call API
      final response = await ref
          .read(apiServiceProvider)
          .post(
            '/secure/studio/bulk-improve',
            body: {'store_id': store.id, 'mode': mode},
          );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['ok'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'تم بدء التحسين'),
              backgroundColor: Colors.green,
            ),
          );
          // Wait a bit then close
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['error'] ?? 'حدث خطأ'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

// Helper classes
class _CategoryItem {
  final String title;
  final String taskType;
  final IconData icon;
  final Color color;

  const _CategoryItem({
    required this.title,
    required this.taskType,
    required this.icon,
    required this.color,
  });
}

class _QuickAppItem {
  final String title;
  final String taskType;
  final IconData icon;
  final bool isNew;
  final bool isBulk;

  const _QuickAppItem({
    required this.title,
    required this.taskType,
    required this.icon,
    required this.isNew,
    this.isBulk = false,
  });
}
