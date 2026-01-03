import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

/// صفحة المتجر - تصميم عصري مع تأثيرات احترافية
/// Store Page - Modern Design with Professional Effects
class StorePage extends StatefulWidget {
  final String storeId;
  final String storeName;
  final String storeDescription;
  final String storeLogo;
  final bool isVerified;
  final double rating;
  final int followersCount;
  final int salesCount;

  const StorePage({
    super.key,
    this.storeId = '1',
    this.storeName = 'متجر الأناقة العصرية',
    this.storeDescription =
        'نقدم لكم أحدث صيحات الموضة العالمية بجودة عالية وأسعار منافسة تناسب جميع الأذواق.',
    this.storeLogo =
        'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200',
    this.isVerified = true,
    this.rating = 4.8,
    this.followersCount = 1200,
    this.salesCount = 500,
  });

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  // ============================================================================
  // State Variables
  // ============================================================================
  int _selectedTabIndex = 0;
  bool _isFollowing = false;
  late ScrollController _scrollController;
  late AnimationController _followAnimationController;

  // ============================================================================
  // Theme Colors (Based on Design)
  // ============================================================================
  static const Color _primaryColor = Color(0xFF13ECC8); // Teal/Cyan
  static const Color _darkBackground = Color(0xFF102221);
  static const Color _darkCard = Color(0xFF152E2A);
  static const Color _lightBackground = Color(0xFFF6F8F8);

  // ============================================================================
  // Tab Items
  // ============================================================================
  final List<String> _tabs = ['الرئيسية', 'المنتجات', 'العروض', 'التعليقات'];

  // ============================================================================
  // Mock Data
  // ============================================================================
  final List<Map<String, dynamic>> _bestSellingProducts = [
    {
      'name': 'معطف شتوي أنيق',
      'price': 250,
      'image':
          'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=400',
    },
    {
      'name': 'حقيبة جلدية فاخرة',
      'price': 180,
      'image':
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
    },
    {
      'name': 'ساعة كلاسيكية',
      'price': 320,
      'image':
          'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=400',
    },
    {
      'name': 'حذاء رياضي',
      'price': 280,
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    },
  ];

  final List<Map<String, dynamic>> _newArrivals = [
    {
      'name': 'تيشيرت صيفي قطن',
      'price': 50,
      'category': 'أزياء رجالية',
      'isNew': true,
      'discount': 0,
      'image':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
    },
    {
      'name': 'حذاء رياضي للجري',
      'price': 450,
      'category': 'أحذية',
      'isNew': false,
      'discount': 0,
      'image':
          'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
    },
    {
      'name': 'نظارة شمسية زرقاء',
      'price': 80,
      'originalPrice': 100,
      'category': 'اكسسوارات',
      'isNew': false,
      'discount': 20,
      'image':
          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400',
    },
    {
      'name': 'فازة سيراميك مودرن',
      'price': 120,
      'category': 'ديكور منزلي',
      'isNew': false,
      'discount': 0,
      'image':
          'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?w=400',
    },
  ];

  // ============================================================================
  // Lifecycle Methods
  // ============================================================================
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _followAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _followAnimationController.dispose();
    super.dispose();
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================
  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor =>
      _isDarkMode ? _darkBackground : _lightBackground;

  Color get _cardColor => _isDarkMode ? _darkCard : Colors.white;

  Color get _textPrimaryColor =>
      _isDarkMode ? Colors.white : const Color(0xFF111817);

  Color get _textSecondaryColor =>
      _isDarkMode ? Colors.grey[400]! : Colors.grey[500]!;

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  void _toggleFollow() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isFollowing = !_isFollowing;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFollowing
              ? 'تمت متابعة ${widget.storeName}'
              : 'تم إلغاء متابعة ${widget.storeName}',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: _primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ============================================================================
  // Build Method
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          _buildSliverAppBar(),

          // Profile Header
          SliverToBoxAdapter(child: _buildProfileHeader()),

          // Sticky Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              child: _buildTabBar(),
              isDarkMode: _isDarkMode,
            ),
          ),

          // Content based on selected tab
          SliverToBoxAdapter(child: _buildTabContent()),

          // Bottom Padding
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // App Bar
  // ============================================================================
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: _cardColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0.5,
      shadowColor: Colors.black26,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isDarkMode
                ? Colors.white.withAlpha(25)
                : Colors.grey.shade100,
          ),
          child: Icon(Icons.arrow_forward, color: _textPrimaryColor, size: 20),
        ),
      ),
      title: Text(
        'تفاصيل المتجر',
        style: TextStyle(
          color: _textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            // Navigate to search
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isDarkMode
                  ? Colors.white.withAlpha(25)
                  : Colors.grey.shade100,
            ),
            child: Icon(Icons.search, color: _textPrimaryColor, size: 20),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // Profile Header
  // ============================================================================
  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Store Logo with Verified Badge
          _buildStoreLogo(),

          const SizedBox(height: 16),

          // Store Name
          Text(
            widget.storeName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Store Description
          Text(
            widget.storeDescription,
            style: TextStyle(
              fontSize: 14,
              color: _textSecondaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 20),

          // Stats Row
          _buildStatsRow(),

          const SizedBox(height: 20),

          // Follow Button
          _buildFollowButton(),
        ],
      ),
    );
  }

  Widget _buildStoreLogo() {
    return Stack(
      children: [
        // Logo Container
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: _backgroundColor, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(38),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            widget.storeLogo,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: _primaryColor,
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              color: _primaryColor.withAlpha(25),
              child: Icon(Icons.store, size: 48, color: _primaryColor),
            ),
          ),
        ),

        // Verified Badge
        if (widget.isVerified)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: _cardColor, width: 2),
              ),
              child: const Icon(
                Icons.verified,
                size: 16,
                color: Color(0xFF102221),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        // Rating
        Expanded(
          child: _buildStatItem(
            value: widget.rating.toString(),
            label: 'التقييم',
            icon: Icons.star,
            showIcon: true,
          ),
        ),
        const SizedBox(width: 8),
        // Followers
        Expanded(
          child: _buildStatItem(
            value: _formatNumber(widget.followersCount),
            label: 'متابعين',
          ),
        ),
        const SizedBox(width: 8),
        // Sales
        Expanded(
          child: _buildStatItem(
            value: '${widget.salesCount}+',
            label: 'مبيعات',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    IconData? icon,
    bool showIcon = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.white.withAlpha(13) : _lightBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: showIcon ? _primaryColor : _textPrimaryColor,
                ),
              ),
              if (showIcon && icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 16, color: _primaryColor),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: _textSecondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _toggleFollow,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFollowing ? Colors.transparent : _primaryColor,
          foregroundColor: _isFollowing
              ? _primaryColor
              : const Color(0xFF102221),
          elevation: _isFollowing ? 0 : 8,
          shadowColor: _primaryColor.withAlpha(77),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: _isFollowing
                ? BorderSide(color: _primaryColor, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_isFollowing ? Icons.check : Icons.person_add, size: 20),
            const SizedBox(width: 8),
            Text(
              _isFollowing ? 'متابَع' : 'متابعة المتجر',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Tab Bar
  // ============================================================================
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedTabIndex = index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? _primaryColor : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  _tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? _primaryColor : _textSecondaryColor,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ============================================================================
  // Tab Content
  // ============================================================================
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildProductsTab();
      case 2:
        return _buildOffersTab();
      case 3:
        return _buildReviewsTab();
      default:
        return _buildHomeTab();
    }
  }

  // ============================================================================
  // Home Tab
  // ============================================================================
  Widget _buildHomeTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Best Selling Section
          _buildSectionHeader('الأكثر مبيعاً', onViewAll: () {}),
          const SizedBox(height: 12),
          _buildBestSellingList(),

          const SizedBox(height: 24),

          // New Arrivals Section
          _buildSectionHeader('وصل حديثاً', showViewAll: false),
          const SizedBox(height: 12),
          _buildNewArrivalsGrid(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    VoidCallback? onViewAll,
    bool showViewAll = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textPrimaryColor,
          ),
        ),
        if (showViewAll)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              'عرض الكل',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _primaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBestSellingList() {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: _bestSellingProducts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final product = _bestSellingProducts[index];
          return _buildBestSellingCard(product);
        },
      ),
    );
  }

  Widget _buildBestSellingCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to product
      },
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? Colors.white.withAlpha(13)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: _primaryColor,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: _textSecondaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  // Favorite Button
                  Positioned(top: 8, right: 8, child: _buildFavoriteButton()),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Product Name
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _textPrimaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Price and Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${product['price']} ر.س',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                _buildAddButton(small: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton({bool isFavorite = false}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Toggle favorite
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _isDarkMode
              ? Colors.black.withAlpha(128)
              : Colors.white.withAlpha(204),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: isFavorite ? Colors.red : _textSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildAddButton({bool small = false}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تمت الإضافة إلى السلة'),
            duration: const Duration(seconds: 2),
            backgroundColor: _primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'عرض السلة',
              textColor: const Color(0xFF102221),
              onPressed: () {},
            ),
          ),
        );
      },
      child: Container(
        width: small ? 28 : 36,
        height: small ? 28 : 36,
        decoration: BoxDecoration(
          color: _primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add,
          size: small ? 16 : 20,
          color: const Color(0xFF102221),
        ),
      ),
    );
  }

  Widget _buildNewArrivalsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _newArrivals.length,
      itemBuilder: (context, index) {
        final product = _newArrivals[index];
        return _buildNewArrivalCard(product);
      },
    );
  }

  Widget _buildNewArrivalCard(Map<String, dynamic> product) {
    final bool hasDiscount = (product['discount'] ?? 0) > 0;
    final bool isNew = product['isNew'] ?? false;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to product
      },
      child: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? Colors.white.withAlpha(13)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: _primaryColor,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: _textSecondaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  // Badge (New or Discount)
                  if (isNew || hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isNew ? Colors.red : _primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isNew ? 'جديد' : '-${product['discount']}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isNew
                                ? Colors.white
                                : const Color(0xFF102221),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Product Name
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _textPrimaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            // Category
            Text(
              product['category'],
              style: TextStyle(fontSize: 12, color: _textSecondaryColor),
            ),

            const SizedBox(height: 8),

            // Price and Cart Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasDiscount)
                      Text(
                        '${product['originalPrice']} ر.س',
                        style: TextStyle(
                          fontSize: 11,
                          color: _textSecondaryColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      '${product['price']} ر.س',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),

                // Cart Button
                _buildCartButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تمت الإضافة إلى السلة'),
            duration: const Duration(seconds: 2),
            backgroundColor: _primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.white.withAlpha(25) : _lightBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.shopping_cart_outlined,
          size: 18,
          color: _textPrimaryColor,
        ),
      ),
    );
  }

  // ============================================================================
  // Products Tab
  // ============================================================================
  Widget _buildProductsTab() {
    final allProducts = [..._bestSellingProducts, ..._newArrivals];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: allProducts.length,
        itemBuilder: (context, index) {
          final product = allProducts[index];
          return _buildNewArrivalCard({
            'name': product['name'],
            'price': product['price'],
            'category': product['category'] ?? 'عام',
            'image': product['image'],
            'isNew': false,
            'discount': 0,
          });
        },
      ),
    );
  }

  // ============================================================================
  // Offers Tab
  // ============================================================================
  Widget _buildOffersTab() {
    final offersProducts = _newArrivals
        .where((p) => (p['discount'] ?? 0) > 0)
        .toList();

    if (offersProducts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.local_offer_outlined,
        title: 'لا توجد عروض حالياً',
        subtitle: 'تابعنا للحصول على أحدث العروض والتخفيضات',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: offersProducts.length,
        itemBuilder: (context, index) {
          return _buildNewArrivalCard(offersProducts[index]);
        },
      ),
    );
  }

  // ============================================================================
  // Reviews Tab
  // ============================================================================
  Widget _buildReviewsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Rating Summary
          _buildRatingSummary(),

          const SizedBox(height: 16),

          // Reviews List
          ...List.generate(3, (index) => _buildReviewItem(index)),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Overall Rating
          Column(
            children: [
              Text(
                widget.rating.toString(),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _textPrimaryColor,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < widget.rating.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: AppTheme.ratingStarColor,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.followersCount} تقييم',
                style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              ),
            ],
          ),

          const SizedBox(width: 24),

          // Rating Bars
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final rating = 5 - index;
                final percentage = [0.7, 0.2, 0.05, 0.03, 0.02][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$rating',
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: _isDarkMode
                              ? Colors.white.withAlpha(25)
                              : Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(_primaryColor),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(int index) {
    final reviews = [
      {
        'name': 'أحمد محمد',
        'rating': 5,
        'comment':
            'متجر ممتاز والمنتجات بجودة عالية جداً. التوصيل سريع والتغليف ممتاز. أنصح الجميع بالشراء منه.',
        'date': 'منذ يومين',
      },
      {
        'name': 'سارة علي',
        'rating': 4,
        'comment':
            'المنتجات جميلة والأسعار مناسبة. التوصيل تأخر قليلاً لكن بشكل عام تجربة جيدة.',
        'date': 'منذ أسبوع',
      },
      {
        'name': 'خالد عبدالله',
        'rating': 5,
        'comment': 'أفضل متجر تعاملت معه! الجودة رائعة والخدمة ممتازة.',
        'date': 'منذ أسبوعين',
      },
    ];

    final review = reviews[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _primaryColor.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (review['name'] as String).substring(0, 1),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textPrimaryColor,
                      ),
                    ),
                    Text(
                      review['date'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < (review['rating'] as int)
                        ? Icons.star
                        : Icons.star_border,
                    color: AppTheme.ratingStarColor,
                    size: 14,
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Comment
          Text(
            review['comment'] as String,
            style: TextStyle(
              fontSize: 14,
              color: _textPrimaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: _textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: _textSecondaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Sticky Tab Bar Delegate
// ============================================================================
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final bool isDarkMode;

  _StickyTabBarDelegate({required this.child, required this.isDarkMode});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: isDarkMode ? const Color(0xFF102221) : const Color(0xFFF6F8F8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
  }

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
    return child != oldDelegate.child || isDarkMode != oldDelegate.isDarkMode;
  }
}
