import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Store Page - MBUY Style
class StorePage extends StatefulWidget {
  final String storeName;
  final bool isVerified;

  const StorePage({
    super.key,
    this.storeName = 'متجر التقنية الحديثة',
    this.isVerified = true,
  });

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int _selectedTabIndex = 0;
  bool _isFollowing = false;
  final List<String> _tabs = ['الرئيسية', 'المنتجات', 'العروض', 'التعليقات'];

  // Store logo and product images
  static const String _storeLogoImage =
      'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200';
  static const List<String> _productImages = [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400', // سماعات
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400', // ساعة ذكية
    'https://images.unsplash.com/photo-1586816879360-004f5b0c51e5?w=400', // شاحن لاسلكي
    'https://images.unsplash.com/photo-1557862921-37829c790f19?w=400', // كاميرا
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.storeName,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Store Header
            _buildStoreHeader(),

            // Store Stats
            _buildStoreStats(),

            // Store Tabs
            _buildStoreTabs(),

            // Store Content
            _buildStoreContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          // Store Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceColor,
              border: Border.all(color: AppTheme.primaryColor, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              _storeLogoImage,
              fit: BoxFit.cover,
              width: 80,
              height: 80,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.store,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Store Name & Verification
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isVerified)
                const Icon(
                  Icons.verified,
                  size: 18,
                  color: AppTheme.primaryColor,
                ),
              const SizedBox(width: 6),
              Text(
                widget.storeName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Store Description
          Text(
            'متخصصون في الإلكترونيات والأجهزة الذكية بأفضل الأسعار',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          // Follow Button
          ElevatedButton(
            onPressed: () => setState(() => _isFollowing = !_isFollowing),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFollowing
                  ? Colors.white
                  : AppTheme.primaryColor,
              foregroundColor: _isFollowing
                  ? AppTheme.primaryColor
                  : Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusRound),
                side: BorderSide(
                  color: AppTheme.primaryColor,
                  width: _isFollowing ? 1.5 : 0,
                ),
              ),
            ),
            child: Text(
              _isFollowing ? 'متابَع' : 'متابعة',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreStats() {
    final stats = [
      {'value': '4.8', 'label': 'تقييم', 'icon': Icons.star},
      {'value': '12.5k', 'label': 'متابعين', 'icon': Icons.people},
      {'value': '2.3k', 'label': 'مبيعات', 'icon': Icons.shopping_bag},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((stat) {
          return Column(
            children: [
              Icon(
                stat['icon'] as IconData,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                stat['value'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat['label'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStoreTabs() {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoreContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الأكثر مبيعاً',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildStoreProductCard(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoreProductCard(int index) {
    final names = [
      'سماعات بلوتوث لاسلكية',
      'ساعة ذكية متعددة الوظائف',
      'شاحن لاسلكي سريع',
      'كاميرا مراقبة ذكية',
    ];
    final prices = ['150 ر.س', '299 ر.س', '89 ر.س', '199 ر.س'];
    final oldPrices = ['200 ر.س', '', '120 ر.س', ''];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppTheme.borderRadiusMedium),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                _productImages[index % _productImages.length],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.headphones,
                    size: 48,
                    color: AppTheme.textHint,
                  ),
                ),
              ),
            ),
          ),
          // Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    names[index],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        prices[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: oldPrices[index].isNotEmpty
                              ? AppTheme.salePriceColor
                              : AppTheme.primaryColor,
                        ),
                      ),
                      if (oldPrices[index].isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(
                          oldPrices[index],
                          style: AppTheme.originalPriceStyle,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
