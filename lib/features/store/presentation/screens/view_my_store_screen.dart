import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/constants/app_icons.dart';

/// شاشة معاينة متجر التاجر - محسّنة
class ViewMyStoreScreen extends ConsumerStatefulWidget {
  const ViewMyStoreScreen({super.key});

  @override
  ConsumerState<ViewMyStoreScreen> createState() => _ViewMyStoreScreenState();
}

class _ViewMyStoreScreenState extends ConsumerState<ViewMyStoreScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _api = ApiService();
  late TabController _tabController;

  Map<String, dynamic>? _store;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'all';
  String _sortBy = 'newest';
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadStoreData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStoreData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _api.get('/secure/merchant/store'),
        _api.get('/secure/products'),
        _api.get('/secure/categories'),
      ]);

      final storeResponse = results[0];
      final productsResponse = results[1];
      final categoriesResponse = results[2];

      if (storeResponse.statusCode == 200) {
        final data = jsonDecode(storeResponse.body);
        if (data['ok'] == true && data['data'] != null) {
          _store = data['data'];
        }
      }

      if (productsResponse.statusCode == 200) {
        final data = jsonDecode(productsResponse.body);
        if (data['ok'] == true && data['data'] != null) {
          _products = List<Map<String, dynamic>>.from(data['data']);
        }
      }

      if (categoriesResponse.statusCode == 200) {
        final data = jsonDecode(categoriesResponse.body);
        if (data['ok'] == true && data['data'] != null) {
          _categories = List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      _error = 'حدث خطأ في تحميل البيانات';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredProducts {
    var filtered = List<Map<String, dynamic>>.from(_products);

    // تصفية حسب التصنيف
    if (_selectedCategory != 'all') {
      filtered = filtered
          .where((p) => p['category_id'] == _selectedCategory)
          .toList();
    }

    // ترتيب
    switch (_sortBy) {
      case 'price_low':
        filtered.sort((a, b) => (a['price'] ?? 0).compareTo(b['price'] ?? 0));
        break;
      case 'price_high':
        filtered.sort((a, b) => (b['price'] ?? 0).compareTo(a['price'] ?? 0));
        break;
      case 'name':
        filtered.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
        break;
      case 'newest':
      default:
        filtered.sort(
          (a, b) => (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''),
        );
    }

    return filtered;
  }

  void _shareStore() {
    if (_store == null) return;
    final slug = _store!['slug'] ?? _store!['id'];
    final url = 'https://mbuy.app/store/$slug';
    SharePlus.instance.share(
      ShareParams(
        text: 'تفضل بزيارة متجري على MBUY:\n$url',
        subject: 'رابط متجري',
      ),
    );
  }

  void _copyStoreLink() {
    if (_store == null) return;
    final slug = _store!['slug'] ?? _store!['id'];
    final url = 'https://mbuy.app/store/$slug';
    Clipboard.setData(ClipboardData(text: url));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('تم نسخ الرابط'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showQRCode() {
    final slug = _store?['slug'] ?? _store?['id'] ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.qr_code, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 12),
            const Text('رمز QR للمتجر'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.slate200),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_2,
                  size: 150,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.slate100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'mbuy.app/store/$slug',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'امسح الرمز لزيارة المتجر',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم حفظ الصورة')));
            },
            icon: const Icon(Icons.download, size: 18),
            label: const Text('حفظ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
          ? _buildErrorState()
          : _buildStorePreview(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'جاري تحميل المتجر...',
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'حدث خطأ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: AppTheme.textSecondaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadStoreData,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorePreview() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        // Preview Banner
        SliverToBoxAdapter(child: _buildPreviewBanner()),
        // Store Header
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppIcons.arrowBack,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            _buildHeaderAction(Icons.qr_code, 'QR', _showQRCode),
            _buildHeaderAction(Icons.share, 'مشاركة', _shareStore),
            _buildHeaderAction(Icons.copy, 'نسخ', _copyStoreLink),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(background: _buildStoreHeader()),
        ),
        // Store Tabs
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverTabBarDelegate(
            TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.textSecondaryColor,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.grid_view, size: 18),
                      const SizedBox(width: 6),
                      Text('المنتجات (${_filteredProducts.length})'),
                    ],
                  ),
                ),
                const Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 18),
                      SizedBox(width: 6),
                      Text('عن المتجر'),
                    ],
                  ),
                ),
                const Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_border, size: 18),
                      SizedBox(width: 6),
                      Text('التقييمات'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [_buildProductsTab(), _buildAboutTab(), _buildReviewsTab()],
      ),
    );
  }

  Widget _buildPreviewBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.warningColor.withValues(alpha: 0.15),
            AppTheme.warningColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warningColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.visibility,
              color: AppTheme.warningColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'وضع المعاينة',
                  style: TextStyle(
                    color: AppTheme.warningColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'هذه معاينة لمتجرك كما يراه العملاء',
                  style: TextStyle(color: AppTheme.warningColor, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push('/dashboard/store/settings'),
            child: const Text('تعديل'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18),
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildStoreHeader() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Cover Image or Gradient
        _store?['cover_url'] != null
            ? Image.network(
                _store!['cover_url'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultCover(),
              )
            : _buildDefaultCover(),
        // Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
            ),
          ),
        ),
        // Store Info
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Logo
              Hero(
                tag: 'store_logo',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _store?['logo_url'] != null
                        ? Image.network(
                            _store!['logo_url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultLogo(),
                          )
                        : _buildDefaultLogo(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Store Name & Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _store?['name'] ?? 'متجري',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_store?['verified'] == true) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Stats Row
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildStatBadge(
                          Icons.shopping_bag,
                          '${_products.length} منتج',
                        ),
                        _buildStatBadge(
                          Icons.visibility,
                          '${_store?['views_count'] ?? 0} مشاهدة',
                        ),
                        _buildStatBadge(
                          Icons.star,
                          '${_store?['rating'] ?? '4.5'}',
                        ),
                      ],
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

  Widget _buildDefaultCover() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, Color(0xFF1565C0)],
        ),
      ),
    );
  }

  Widget _buildDefaultLogo() {
    return Container(
      color: AppTheme.slate100,
      child: const Icon(Icons.store, size: 40, color: AppTheme.primaryColor),
    );
  }

  Widget _buildStatBadge(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            value,
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

  Widget _buildProductsTab() {
    return Column(
      children: [
        // Filter & Sort Bar
        _buildFilterSortBar(),
        // Categories
        if (_categories.isNotEmpty) _buildCategoriesBar(),
        // Products Grid
        Expanded(
          child: _filteredProducts.isEmpty
              ? _buildEmptyProducts()
              : RefreshIndicator(
                  onRefresh: _loadStoreData,
                  child: _isGridView
                      ? GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.7,
                              ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(_filteredProducts[index]);
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return _buildProductListItem(
                              _filteredProducts[index],
                            );
                          },
                        ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterSortBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // Sort Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _sortBy,
                isDense: true,
                icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                items: const [
                  DropdownMenuItem(value: 'newest', child: Text('الأحدث')),
                  DropdownMenuItem(
                    value: 'price_low',
                    child: Text('السعر: الأقل'),
                  ),
                  DropdownMenuItem(
                    value: 'price_high',
                    child: Text('السعر: الأعلى'),
                  ),
                  DropdownMenuItem(value: 'name', child: Text('الاسم')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _sortBy = value);
                },
              ),
            ),
          ),
          const Spacer(),
          // View Toggle
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.grid_view, size: 20),
                  onPressed: () => setState(() => _isGridView = true),
                  color: _isGridView
                      ? AppTheme.primaryColor
                      : AppTheme.textHintColor,
                  constraints: const BoxConstraints(minWidth: 40),
                ),
                Container(width: 1, height: 24, color: AppTheme.dividerColor),
                IconButton(
                  icon: const Icon(Icons.view_list, size: 20),
                  onPressed: () => setState(() => _isGridView = false),
                  color: !_isGridView
                      ? AppTheme.primaryColor
                      : AppTheme.textHintColor,
                  constraints: const BoxConstraints(minWidth: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesBar() {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryChip('all', 'الكل');
          }
          final category = _categories[index - 1];
          return _buildCategoryChip(
            category['id'],
            category['name'] ?? 'تصنيف',
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String id, String name) {
    final isSelected = _selectedCategory == id;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(name),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
          fontSize: 13,
        ),
        backgroundColor: AppTheme.slate100,
        selectedColor: AppTheme.primaryColor,
        checkmarkColor: Colors.white,
        onSelected: (selected) {
          setState(() => _selectedCategory = selected ? id : 'all');
        },
      ),
    );
  }

  Widget _buildEmptyProducts() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.slate100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: AppTheme.textHintColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد منتجات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'ابدأ بإضافة منتجاتك الآن',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/dashboard/products/add'),
              icon: const Icon(Icons.add),
              label: const Text('إضافة منتج'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final hasDiscount =
        product['original_price'] != null &&
        product['original_price'] > (product['price'] ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: AppTheme.slate100,
                    child: product['main_image_url'] != null
                        ? Image.network(
                            product['main_image_url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderImage(),
                          )
                        : _buildPlaceholderImage(),
                  ),
                ),
                // Discount Badge
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${_calculateDiscount(product)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Stock Badge
                if ((product['stock'] ?? 0) == 0)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.black.withValues(alpha: 0.7),
                      child: const Text(
                        'نفذت الكمية',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${(product['price'] ?? 0).toStringAsFixed(0)} ر.س',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${product['original_price']}',
                          style: const TextStyle(
                            color: AppTheme.textHintColor,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
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

  Widget _buildProductListItem(Map<String, dynamic> product) {
    final hasDiscount =
        product['original_price'] != null &&
        product['original_price'] > (product['price'] ?? 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: AppTheme.slate100,
              child: product['main_image_url'] != null
                  ? Image.network(
                      product['main_image_url'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                if (product['category_name'] != null)
                  Text(
                    product['category_name'],
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${(product['price'] ?? 0).toStringAsFixed(0)} ر.س',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${_calculateDiscount(product)}%',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(child: Icon(Icons.image, size: 40, color: Colors.grey[400]));
  }

  int _calculateDiscount(Map<String, dynamic> product) {
    final original = product['original_price'] ?? 0;
    final current = product['price'] ?? 0;
    if (original > 0 && original > current) {
      return ((original - current) / original * 100).round();
    }
    return 0;
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description Card
          _buildInfoCard(
            title: 'عن المتجر',
            icon: Icons.info_outline,
            child: Text(
              _store?['description'] ?? 'لا يوجد وصف',
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Stats
          _buildInfoCard(
            title: 'إحصائيات سريعة',
            icon: Icons.analytics_outlined,
            child: Row(
              children: [
                _buildQuickStat(
                  '${_products.length}',
                  'منتج',
                  Icons.shopping_bag_outlined,
                  AppTheme.primaryColor,
                ),
                _buildQuickStat(
                  '${_store?['views_count'] ?? 0}',
                  'مشاهدة',
                  Icons.visibility_outlined,
                  AppTheme.successColor,
                ),
                _buildQuickStat(
                  '${_store?['orders_count'] ?? 0}',
                  'طلب',
                  Icons.receipt_long_outlined,
                  AppTheme.warningColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Contact Info
          _buildInfoCard(
            title: 'معلومات التواصل',
            icon: Icons.contact_phone_outlined,
            child: Column(
              children: [
                if (_store?['phone'] != null)
                  _buildContactRow(Icons.phone, _store!['phone']),
                if (_store?['email'] != null)
                  _buildContactRow(Icons.email, _store!['email']),
                if (_store?['whatsapp'] != null)
                  _buildContactRow(Icons.chat, _store!['whatsapp']),
                if (_store?['phone'] == null &&
                    _store?['email'] == null &&
                    _store?['whatsapp'] == null)
                  const Text(
                    'لا توجد معلومات تواصل',
                    style: TextStyle(color: AppTheme.textHintColor),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Social Media
          _buildInfoCard(
            title: 'تابعنا',
            icon: Icons.share_outlined,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(Icons.camera_alt, 'Instagram'),
                _buildSocialButton(Icons.close, 'X'),
                _buildSocialButton(Icons.tiktok, 'TikTok'),
                _buildSocialButton(Icons.snapchat, 'Snapchat'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondaryColor),
          const SizedBox(width: 12),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.slate100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.textSecondaryColor),
        ),
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.slate100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star_border,
              size: 64,
              color: AppTheme.textHintColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد تقييمات بعد',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'ستظهر تقييمات العملاء هنا',
            style: TextStyle(color: AppTheme.textSecondaryColor),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
