import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/auth_token_storage.dart';
import '../../../products/data/categories_repository.dart';
import '../../../products/domain/models/category.dart';

/// Ù†Ù…ÙˆØ°Ø¬ Ù…Ù†ØªØ¬ Ø¯Ø±ÙˆØ¨ Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§
class DropshipProduct {
  final String id;
  final String title;
  final String? description;
  final double supplierPrice;
  final int stockQty;
  final bool isDropshipEnabled;
  final bool isActive;
  final List<dynamic> media;
  final String supplierStoreId;
  final String? supplierStoreName;
  final String? supplierStoreSlug;

  DropshipProduct({
    required this.id,
    required this.title,
    this.description,
    required this.supplierPrice,
    required this.stockQty,
    required this.isDropshipEnabled,
    required this.isActive,
    this.media = const [],
    required this.supplierStoreId,
    this.supplierStoreName,
    this.supplierStoreSlug,
  });

  factory DropshipProduct.fromJson(Map<String, dynamic> json) {
    return DropshipProduct(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      supplierPrice: (json['supplier_price'] as num).toDouble(),
      stockQty: json['stock_qty'] as int? ?? 0,
      isDropshipEnabled: json['is_dropship_enabled'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      media: json['media'] as List<dynamic>? ?? [],
      supplierStoreId: json['supplier_store_id'] as String,
      supplierStoreName: json['supplier_store_name'] as String?,
      supplierStoreSlug: json['supplier_store_slug'] as String?,
    );
  }

  String? get mainImageUrl {
    if (media.isEmpty) return null;
    final mainMedia = media.firstWhere(
      (m) => m['is_main'] == true && m['type'] == 'image',
      orElse: () =>
          media.firstWhere((m) => m['type'] == 'image', orElse: () => null),
    );
    return mainMedia?['url'] as String?;
  }
}

/// Ù†Ù…ÙˆØ°Ø¬ Reseller Listing
class ResellerListing {
  final String id;
  final String dropshipProductId;
  final double resalePrice;
  final bool isActive;
  final String? title;
  final String? description;
  final List<dynamic>? media;
  final double? supplierPrice;
  final int? stockQty;
  final String? supplierStoreName;

  ResellerListing({
    required this.id,
    required this.dropshipProductId,
    required this.resalePrice,
    required this.isActive,
    this.title,
    this.description,
    this.media,
    this.supplierPrice,
    this.stockQty,
    this.supplierStoreName,
  });

  factory ResellerListing.fromJson(Map<String, dynamic> json) {
    final dropshipProduct = json['dropship_products'] as Map<String, dynamic>?;
    final stores = dropshipProduct?['stores'] as Map<String, dynamic>?;

    return ResellerListing(
      id: json['id'] as String,
      dropshipProductId: json['dropship_product_id'] as String,
      resalePrice: (json['resale_price'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      title: dropshipProduct?['title'] as String?,
      description: dropshipProduct?['description'] as String?,
      media: dropshipProduct?['media'] as List<dynamic>?,
      supplierPrice:
          dropshipProduct != null && dropshipProduct['supplier_price'] != null
          ? (dropshipProduct['supplier_price'] as num).toDouble()
          : null,
      stockQty: dropshipProduct?['stock_qty'] as int?,
      supplierStoreName: stores?['name'] as String?,
    );
  }

  String? get mainImageUrl {
    if (media == null || media!.isEmpty) return null;
    final mainMedia = media!.firstWhere(
      (m) => m['is_main'] == true && m['type'] == 'image',
      orElse: () =>
          media!.firstWhere((m) => m['type'] == 'image', orElse: () => null),
    );
    return mainMedia?['url'] as String?;
  }
}

/// Ø´Ø§Ø´Ø© Ø¯Ø±ÙˆØ¨ Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§ Ù…Ø¹ Tabs
class DropshippingScreen extends ConsumerStatefulWidget {
  const DropshippingScreen({super.key});

  @override
  ConsumerState<DropshippingScreen> createState() => _DropshippingScreenState();
}

class _DropshippingScreenState extends ConsumerState<DropshippingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  // Categories tab
  List<Category> _categories = [];
  bool _categoriesLoading = false;
  String? _selectedCategoryId;
  List<DropshipProduct> _categoryProducts = [];
  bool _categoryProductsLoading = false;

  // My Products tab (internal tabs)
  int _myProductsTabIndex = 0; // 0 = Ù…Ù†ØªØ¬Ø§ØªÙŠ (supplier), 1 = Ù…Ø³ØªÙˆØ±Ø¯ (reseller)
  List<DropshipProduct> _supplierProducts = [];
  bool _supplierLoading = false;
  List<ResellerListing> _resellerListings = [];
  bool _resellerLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Ø¬Ù„Ø¨ Ø§Ù„ØªØµÙ†ÙŠÙØ§Øª
  Future<void> _loadCategories() async {
    setState(() => _categoriesLoading = true);
    try {
      final categoriesRepo = ref.read(categoriesRepositoryProvider);
      final categories = await categoriesRepo.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _categoriesLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
      if (mounted) {
        setState(() {
          _categories = [];
          _categoriesLoading = false;
        });
      }
    }
  }

  /// Ø¬Ù„Ø¨ Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„ØªØµÙ†ÙŠÙ Ø§Ù„Ù…Ø­Ø¯Ø¯
  Future<void> _loadCategoryProducts(String? categoryId) async {
    if (categoryId == null) {
      setState(() {
        _categoryProducts = [];
        _categoryProductsLoading = false;
      });
      return;
    }

    setState(() {
      _categoryProductsLoading = true;
      _selectedCategoryId = categoryId;
    });

    try {
      final token = await ref.read(authTokenStorageProvider).getAccessToken();
      final response = await _api.get(
        '/secure/dropship/catalog',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          final allProducts = ((data['data'] as List?) ?? [])
              .map(
                (json) =>
                    DropshipProduct.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          // TODO: ØªØµÙÙŠØ© Ø­Ø³Ø¨ category_id Ø¹Ù†Ø¯ ØªÙˆÙØ±Ù‡Ø§ ÙÙŠ API
          // Ø­Ø§Ù„ÙŠØ§Ù‹ Ù†Ø¹Ø±Ø¶ ÙƒÙ„ Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª
          setState(() {
            _categoryProducts = allProducts;
            _categoryProductsLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading category products: $e');
    }
    setState(() {
      _categoryProducts = [];
      _categoryProductsLoading = false;
    });
  }

  /// Ø¬Ù„Ø¨ Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„Ù…ÙˆØ±Ø¯
  Future<void> _loadSupplierProducts() async {
    setState(() => _supplierLoading = true);
    try {
      final token = await ref.read(authTokenStorageProvider).getAccessToken();
      final response = await _api.get(
        '/secure/dropship/products',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          setState(() {
            _supplierProducts = (data['data'] as List)
                .map((json) => DropshipProduct.fromJson(json))
                .toList();
            _supplierLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading supplier products: $e');
    }
    setState(() {
      _supplierProducts = [];
      _supplierLoading = false;
    });
  }

  /// Ø¬Ù„Ø¨ Ù‚ÙˆØ§Ø¦Ù… Ø§Ù„Ù…ÙˆØ²Ø¹
  Future<void> _loadResellerListings() async {
    setState(() => _resellerLoading = true);
    try {
      final token = await ref.read(authTokenStorageProvider).getAccessToken();
      final response = await _api.get(
        '/secure/dropship/listings',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true && data['data'] != null) {
          setState(() {
            _resellerListings = (data['data'] as List)
                .map((json) => ResellerListing.fromJson(json))
                .toList();
            _resellerLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading reseller listings: $e');
    }
    setState(() {
      _resellerListings = [];
      _resellerLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            // Ø§Ù„ØªØ¨ÙˆÙŠØ¨Ø§Øª Ù…Ù„ØªØµÙ‚Ø© Ø¨Ø§Ù„Ø¨Ø§Ø± Ø§Ù„Ø¹Ù„ÙˆÙŠ
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  if (index == 1 && _categories.isEmpty) {
                    _loadCategories();
                  } else if (index == 2) {
                    if (_myProductsTabIndex == 0 && _supplierProducts.isEmpty) {
                      _loadSupplierProducts();
                    } else if (_myProductsTabIndex == 1 &&
                        _resellerListings.isEmpty) {
                      _loadResellerListings();
                    }
                  }
                },
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'Ù…Ø§Ù‡Ùˆ Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§ØŸ'),
                  Tab(text: 'Ø§Ù„ØªØµÙ†ÙŠÙØ§Øª'),
                  Tab(text: 'Ù…Ù†ØªØ¬Ø§ØªÙŠ'),
                ],
              ),
            ),
            // Ø§Ù„Ù…Ø­ØªÙˆÙ‰
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildInfoTab(),
                  _buildCategoriesTab(),
                  _buildMyProductsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ØªØ¨ÙˆÙŠØ¨: Ù…Ø§Ù‡Ùˆ Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§ØŸ
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) Ù…Ø§Ù‡Ùˆ Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§ØŸ
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1) Ù…Ø§Ù‡Ùˆ Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§ØŸ',
                    style: TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§ Ù‡Ùˆ Ù†Ø¸Ø§Ù… Ø¯Ø±ÙˆØ¨ Ø´ÙˆØ¨ÙŠÙ†Ù‚ Ø¯Ø§Ø®Ù„ÙŠ ÙŠØ±Ø¨Ø· ØªØ¬Ø§Ø± Ø§Ù„Ù…Ù†ØµØ© Ù…Ø¹ Ø¨Ø¹Ø¶.\n'
                    'ØªØ§Ø¬Ø± ÙŠÙˆÙÙ‘Ø± Ø§Ù„Ù…Ù†ØªØ¬ØŒ ÙˆØªØ§Ø¬Ø± Ø¢Ø®Ø± ÙŠØ¨ÙŠØ¹Ù‡ØŒ ÙˆØ§Ù„Ø·Ù„Ø¨ ÙŠÙˆØµÙ„ Ù„Ù„Ù…ÙˆØ±Ø¯ Ù…Ø¨Ø§Ø´Ø±Ø© Ø¨Ø§Ø³Ù… Ø§Ù„Ù…ÙˆØ²Ø¹ ÙˆÙŠØªÙ… Ø´Ø­Ù†Ù‡ Ù„Ù„Ø¹Ù…ÙŠÙ„ØŒ ÙˆÙƒÙ„ Ø§Ù„Ø¹Ù…Ù„ÙŠØ© Ù…Ù†Ø¸Ù…Ø© ÙˆÙˆØ§Ø¶Ø­Ø© Ø¯Ø§Ø®Ù„ Ø§Ù„Ù†Ø¸Ø§Ù….',
                    style: TextStyle(
                      fontSize: AppDimensions.fontTitle,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 2) ÙƒÙŠÙ ØªØªÙ… Ø§Ù„Ø¹Ù…Ù„ÙŠØ©ØŸ
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2) ÙƒÙŠÙ ØªØªÙ… Ø§Ù„Ø¹Ù…Ù„ÙŠØ©ØŸ',
                    style: TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '\t1. Ø§Ù„Ù…ÙˆØ±Ø¯ ÙŠØ¶ÙŠÙ Ø§Ù„Ù…Ù†ØªØ¬ ÙˆÙŠØ­Ø¯Ø¯ Ø§Ù„Ø³Ø¹Ø± ÙˆØ§Ù„Ù…Ø®Ø²ÙˆÙ†',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          '\t2. Ø§Ù„Ù…ÙˆØ²Ø¹ ÙŠØ¶ÙŠÙ Ø§Ù„Ù…Ù†ØªØ¬ Ù„Ù…ØªØ¬Ø±Ù‡ ÙˆÙŠØ­Ø¯Ø¯ Ø³Ø¹Ø± Ø§Ù„Ø¨ÙŠØ¹',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          '\t3. Ø¹Ù†Ø¯ Ø§Ù„Ø´Ø±Ø§Ø¡ØŒ ÙŠØªÙ… Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø·Ù„Ø¨ Ù„Ù„Ù…ÙˆØ±Ø¯ Ù…Ø¹ Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¹Ù…ÙŠÙ„ Ù„ÙŠØªÙ… Ø§Ù„Ø´Ø­Ù† Ù…Ø¨Ø§Ø´Ø±Ø©',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 3) Ù„Ù…Ø§Ø°Ø§ Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§ØŸ
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '3) Ù„Ù…Ø§Ø°Ø§ Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§ØŸ',
                    style: TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'â€¢ Ø¨ÙŠØ¹ Ø¨Ø¯ÙˆÙ† Ø§Ù„Ø­Ø§Ø¬Ø© Ù„Ù…Ø®Ø²ÙˆÙ†',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ ØªÙˆØ³Ù‘Ø¹ Ø£Ø³Ø±Ø¹ Ù„Ù„Ù…ØªØ§Ø¬Ø±',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ ØªØ¹Ø§ÙˆÙ† ÙØ¹Ù„ÙŠ Ø¨ÙŠÙ† Ø§Ù„ØªØ¬Ø§Ø± Ø¨Ø¯Ù„ Ø§Ù„Ù…Ù†Ø§ÙØ³Ø©',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ Ø¹Ø¯Ø© Ù…Ø­Ø·Ø§Øª Ø¨ÙŠØ¹ Ø¨Ø¯Ù„ Ù†Ù‚Ø·Ø© Ø¨ÙŠØ¹ ÙˆØ§Ø­Ø¯Ø©',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '(Ù…Ù†ØªØ¬Ùƒ Ù…Ø§ ÙŠØ¹ØªÙ…Ø¯ Ø¹Ù„Ù‰ Ù…ØªØ¬Ø± ÙˆØ§Ø­Ø¯ ÙÙ‚Ø·ØŒ Ø¨Ù„ ÙŠÙØ¨Ø§Ø¹ Ø¹Ø¨Ø± Ù…ØªØ§Ø¬Ø± Ù…ØªØ¹Ø¯Ø¯Ø©)',
                          style: TextStyle(
                            fontSize: AppDimensions.fontBody,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 4) ØªÙˆØ²ÙŠØ¹ Ø§Ù„Ù…Ø³Ø¤ÙˆÙ„ÙŠØ§Øª
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '4) ØªÙˆØ²ÙŠØ¹ Ø§Ù„Ù…Ø³Ø¤ÙˆÙ„ÙŠØ§Øª',
                    style: TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ø§Ù„Ù…ÙˆØ±Ø¯
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.store,
                        color: Colors.orange,
                        size: AppDimensions.iconM,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Ø§Ù„Ù…ÙˆØ±Ø¯:',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'â€¢ ØªÙˆÙÙŠØ± Ø§Ù„Ù…Ù†ØªØ¬ ÙˆØªØ­Ø¯ÙŠØ« Ø§Ù„Ù…Ø®Ø²ÙˆÙ†',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ ØªØ¬Ù‡ÙŠØ² Ø§Ù„Ø·Ù„Ø¨Ø§Øª ÙˆØ´Ø­Ù†Ù‡Ø§ Ù„Ù„Ø¹Ù…ÙŠÙ„',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ Ø§Ù„Ø§Ù„ØªØ²Ø§Ù… Ø¨Ø¬ÙˆØ¯Ø© Ø§Ù„Ù…Ù†ØªØ¬ ÙˆÙˆÙ‚Øª Ø§Ù„ØªÙ†ÙÙŠØ°',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ø§Ù„Ù…ÙˆØ²Ø¹
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.green,
                        size: AppDimensions.iconM,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Ø§Ù„Ù…ÙˆØ²Ø¹:',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'â€¢ Ø¹Ø±Ø¶ Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª Ø¯Ø§Ø®Ù„ Ù…ØªØ¬Ø±Ù‡',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ Ø§Ù„ØªØ³ÙˆÙŠÙ‚ ÙˆØ§Ù„Ø¨ÙŠØ¹ Ù„Ù„Ø¹Ù…Ù„Ø§Ø¡',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ Ø¥Ø¯Ø§Ø±Ø© ØªØ¬Ø±Ø¨Ø© Ù…Ø§ Ù‚Ø¨Ù„ Ø§Ù„Ø´Ø±Ø§Ø¡',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ø§Ù„Ù…Ù†ØµØ©
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.business,
                        color: AppTheme.primaryColor,
                        size: AppDimensions.iconM,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Ø§Ù„Ù…Ù†ØµØ©:',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'â€¢ ØªÙ†Ø¸ÙŠÙ… Ø¹Ù…Ù„ÙŠØ© Ø§Ù„ØªØ¹Ø§ÙˆÙ† Ø¨ÙŠÙ† Ø§Ù„ØªØ¬Ø§Ø±',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ Ø¥Ø¯Ø§Ø±Ø© ØªØ¯ÙÙ‚ Ø§Ù„Ø·Ù„Ø¨Ø§Øª ÙˆØªÙˆØ«ÙŠÙ‚Ù‡Ø§',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ ØªÙ‚Ù„ÙŠÙ„ Ø§Ù„Ù†Ø²Ø§Ø¹Ø§Øª ÙˆØ¶Ù…Ø§Ù† ÙˆØ¶ÙˆØ­ Ø§Ù„Ø¹Ù…Ù„ÙŠØ§Øª',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ Ø®Ù„Ù‚ ÙØ±Øµ Ø¨ÙŠØ¹ Ù…Ø´ØªØ±ÙƒØ© Ø¨ÙŠÙ† Ø§Ù„ØªØ¬Ø§Ø±',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 5) Ø¹Ù…ÙˆÙ„Ø© Ø§Ù„Ù…Ù†ØµØ©
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '5) Ø¹Ù…ÙˆÙ„Ø© Ø§Ù„Ù…Ù†ØµØ©',
                    style: TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ø§Ù„Ù…ÙˆØ±Ø¯
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.store,
                        color: Colors.orange,
                        size: AppDimensions.iconM,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Ø§Ù„Ù…ÙˆØ±Ø¯ (2.5Ùª):',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'â€¢ Ø­ØµÙ„ Ø¹Ù„Ù‰ Ù‚Ù†ÙˆØ§Øª Ø¨ÙŠØ¹ Ø¥Ø¶Ø§ÙÙŠØ© Ø¨Ø¯ÙˆÙ† ØªØ³ÙˆÙŠÙ‚',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ Ø²Ø§Ø¯Øª Ù…Ø¨ÙŠØ¹Ø§ØªÙ‡ Ø¨Ø¯ÙˆÙ† ØªÙƒÙ„ÙØ© Ø§Ø³ØªØ­ÙˆØ§Ø° Ø¹Ù…ÙŠÙ„',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ø§Ù„Ù…ÙˆØ²Ø¹
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.green,
                        size: AppDimensions.iconM,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Ø§Ù„Ù…ÙˆØ²Ø¹ (2.5Ùª):',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'â€¢ Ù„Ø§ ÙŠØªØ­Ù…Ù„ Ù…Ø®Ø²ÙˆÙ† ÙˆÙ„Ø§ Ø´Ø­Ù†',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ ÙŠØ±ÙƒÙ‘Ø² ÙÙ‚Ø· Ø¹Ù„Ù‰ Ø§Ù„Ø¨ÙŠØ¹ ÙˆØ§Ù„ØªØ³ÙˆÙŠÙ‚',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ø§Ù„Ù…Ù†ØµØ©
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.business,
                        color: AppTheme.primaryColor,
                        size: AppDimensions.iconM,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Ø§Ù„Ù…Ù†ØµØ© (5Ùª):',
                          style: TextStyle(
                            fontSize: AppDimensions.fontTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'â€¢ ØªØ¯ÙŠØ± Ø§Ù„Ù†Ø¸Ø§Ù…',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ ØªÙˆØ«Ù‚ Ø§Ù„Ø·Ù„Ø¨Ø§Øª',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ ØªÙ‚Ù„Ù„ Ø§Ù„Ù†Ø²Ø§Ø¹Ø§Øª',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                        Text(
                          'â€¢ ÙˆØªØ®Ù„Ù‚ ÙØ±Øµ Ø¨ÙŠØ¹ Ù„Ù„Ø¬Ù…ÙŠØ¹',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSubtitle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 6) Ø¹Ø¨Ø§Ø±Ø© Ø®ØªØ§Ù…ÙŠØ©
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '6) Ø¹Ø¨Ø§Ø±Ø© Ø®ØªØ§Ù…ÙŠØ©',
                    style: TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§ ÙŠØ­ÙˆÙ‘Ù„ Ø§Ù„ØªØ¹Ø§ÙˆÙ† Ø¨ÙŠÙ† Ø§Ù„ØªØ¬Ø§Ø± Ø¥Ù„Ù‰ Ø´Ø¨ÙƒØ© Ø¨ÙŠØ¹ Ø­Ù‚ÙŠÙ‚ÙŠØ© ØªØ±ÙØ¹ Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª Ù„Ù„Ø¬Ù…ÙŠØ¹ Ø¨Ø¯ÙˆÙ† ØªØ¹Ù‚ÙŠØ¯.',
                    style: TextStyle(
                      fontSize: AppDimensions.fontTitle,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ØªØ¨ÙˆÙŠØ¨: Ø§Ù„ØªØµÙ†ÙŠÙØ§Øª
  Widget _buildCategoriesTab() {
    if (_categoriesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_selectedCategoryId == null) {
      // Ø¹Ø±Ø¶ Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„ØªØµÙ†ÙŠÙØ§Øª
      if (_categories.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_outlined,
                size: AppDimensions.iconDisplay,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Ù„Ø§ ØªÙˆØ¬Ø¯ ØªØµÙ†ÙŠÙØ§Øª Ù…ØªØ§Ø­Ø©',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _loadCategories,
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return _buildCategoryCard(category);
          },
        ),
      );
    } else {
      // Ø¹Ø±Ø¶ Ù…Ù†ØªØ¬Ø§Øª Ø§Ù„ØªØµÙ†ÙŠÙ Ø§Ù„Ù…Ø­Ø¯Ø¯
      return Column(
        children: [
          // Ø²Ø± Ø§Ù„Ø¹ÙˆØ¯Ø©
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedCategoryId = null;
                      _categoryProducts = [];
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    _categories
                        .firstWhere((c) => c.id == _selectedCategoryId)
                        .getLocalizedName('ar'),
                    style: const TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª
          Expanded(
            child: _categoryProductsLoading
                ? const Center(child: CircularProgressIndicator())
                : _categoryProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: AppDimensions.iconDisplay,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ù†ØªØ¬Ø§Øª ÙÙŠ Ù‡Ø°Ø§ Ø§Ù„ØªØµÙ†ÙŠÙ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => _loadCategoryProducts(_selectedCategoryId),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _categoryProducts.length,
                      itemBuilder: (context, index) {
                        final product = _categoryProducts[index];
                        return _buildCatalogProductCard(product);
                      },
                    ),
                  ),
          ),
        ],
      );
    }
  }

  Widget _buildCategoryCard(Category category) {
    return Card(
      child: InkWell(
        onTap: () => _loadCategoryProducts(category.id),
        borderRadius: AppDimensions.borderRadiusM,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category,
                size: AppDimensions.iconHero,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                category.getLocalizedName('ar'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.fontBody,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogProductCard(DropshipProduct product) {
    final imageUrl = product.mainImageUrl;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusM),
      child: InkWell(
        onTap: () => _showAddListingModal(product),
        borderRadius: AppDimensions.borderRadiusM,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: AppDimensions.borderRadiusS,
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: AppDimensions.borderRadiusS,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_outlined,
                                color: Colors.grey,
                              ),
                        ),
                      )
                    : const Icon(Icons.image_outlined, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.fontBody,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.supplierStoreName ?? 'Ù…ØªØ¬Ø±',
                      style: TextStyle(
                        fontSize: AppDimensions.fontBody2,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.supplierPrice.toStringAsFixed(2)} Ø±.Ø³',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontSize: AppDimensions.fontBody,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ø§Ù„Ù…Ø®Ø²ÙˆÙ†: ${product.stockQty}',
                      style: TextStyle(
                        fontSize: AppDimensions.fontBody2,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _showAddListingModal(product),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Ø£Ø¶Ù Ù„Ù…ØªØ¬Ø±ÙŠ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ØªØ¨ÙˆÙŠØ¨: Ù…Ù†ØªØ¬Ø§ØªÙŠ (Ù…Ø¹ ØªØ¨ÙˆÙŠØ¨ÙŠÙ† Ø¯Ø§Ø®Ù„ÙŠÙŠÙ†)
  Widget _buildMyProductsTab() {
    return Column(
      children: [
        // Segmented Control Ù„Ù„ØªØ¨ÙˆÙŠØ¨ÙŠÙ† Ø§Ù„Ø¯Ø§Ø®Ù„ÙŠÙŠÙ†
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _myProductsTabIndex = 0;
                        if (_supplierProducts.isEmpty) {
                          _loadSupplierProducts();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _myProductsTabIndex == 0
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ù…Ù†ØªØ¬Ø§ØªÙŠ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _myProductsTabIndex == 0
                              ? Colors.white
                              : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _myProductsTabIndex = 1;
                        if (_resellerListings.isEmpty) {
                          _loadResellerListings();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _myProductsTabIndex == 1
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ù…Ø³ØªÙˆØ±Ø¯',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _myProductsTabIndex == 1
                              ? Colors.white
                              : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Ø§Ù„Ù…Ø­ØªÙˆÙ‰ Ø­Ø³Ø¨ Ø§Ù„ØªØ¨ÙˆÙŠØ¨ Ø§Ù„Ø¯Ø§Ø®Ù„ÙŠ Ø§Ù„Ù…Ø­Ø¯Ø¯
        Expanded(
          child: _myProductsTabIndex == 0
              ? _buildSupplierTab()
              : _buildResellerTab(),
        ),
      ],
    );
  }

  Widget _buildSupplierTab() {
    if (_supplierLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadSupplierProducts,
      child: _supplierProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: AppDimensions.iconDisplay,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ù†ØªØ¬Ø§Øª ÙƒÙ…ÙˆØ±Ø¯',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.push(
                        '/dashboard/products/add',
                        extra: {'productType': 'dropshipping'},
                      );
                    },
                    child: const Text('Ø¥Ø¶Ø§ÙØ© Ù…Ù†ØªØ¬'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _supplierProducts.length,
              itemBuilder: (context, index) {
                final product = _supplierProducts[index];
                return _buildSupplierProductCard(product);
              },
            ),
    );
  }

  Widget _buildSupplierProductCard(DropshipProduct product) {
    final imageUrl = product.mainImageUrl;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: imageUrl != null
            ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
            : const Icon(Icons.image_outlined),
        title: Text(product.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ø§Ù„Ø³Ø¹Ø±: ${product.supplierPrice.toStringAsFixed(2)} Ø±.Ø³'),
            Text('Ø§Ù„Ù…Ø®Ø²ÙˆÙ†: ${product.stockQty}'),
            Text(
              product.isDropshipEnabled ? 'Ù…ÙØ¹Ù‘Ù„ Ù„Ø¯Ø±ÙˆØ¨ Ø´ÙˆØ¨ÙŠÙ†Ù‚Ù†Ø§' : 'ØºÙŠØ± Ù…ÙØ¹Ù‘Ù„',
              style: TextStyle(
                color: product.isDropshipEnabled ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // TODO: ÙØªØ­ Ø´Ø§Ø´Ø© ØªØ¹Ø¯ÙŠÙ„ Ø§Ù„Ù…Ù†ØªØ¬
          },
        ),
      ),
    );
  }

  Widget _buildResellerTab() {
    if (_resellerLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadResellerListings,
      child: _resellerListings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: AppDimensions.iconDisplay,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ù†ØªØ¬Ø§Øª ÙƒÙ…ÙˆØ²Ø¹',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _resellerListings.length,
              itemBuilder: (context, index) {
                final listing = _resellerListings[index];
                return _buildResellerListingCard(listing);
              },
            ),
    );
  }

  Widget _buildResellerListingCard(ResellerListing listing) {
    final imageUrl = listing.mainImageUrl;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: imageUrl != null
            ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
            : const Icon(Icons.image_outlined),
        title: Text(listing.title ?? 'Ù…Ù†ØªØ¬'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ø³Ø¹Ø± Ø§Ù„Ø¨ÙŠØ¹: ${listing.resalePrice.toStringAsFixed(2)} Ø±.Ø³'),
            if (listing.supplierPrice != null)
              Text(
                'Ø³Ø¹Ø± Ø§Ù„Ø¬Ù…Ù„Ø©: ${listing.supplierPrice!.toStringAsFixed(2)} Ø±.Ø³',
              ),
            Text(
              listing.isActive ? 'Ù†Ø´Ø·' : 'ØºÙŠØ± Ù†Ø´Ø·',
              style: TextStyle(
                color: listing.isActive ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditListingModal(listing),
        ),
      ),
    );
  }

  void _showAddListingModal(DropshipProduct product) {
    final priceController = TextEditingController(
      text: (product.supplierPrice * 1.2).toStringAsFixed(2),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Ø¥Ø¶Ø§ÙØ© Ù„Ù…ØªØ¬Ø±Ùƒ',
                  style: TextStyle(
                    fontSize: AppDimensions.fontHeadline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ø³Ø¹Ø± Ø§Ù„Ø¨ÙŠØ¹ (Ø±.Ø³)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final price = double.tryParse(priceController.text);
                          if (price == null || price <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ø§Ù„Ø±Ø¬Ø§Ø¡ Ø¥Ø¯Ø®Ø§Ù„ Ø³Ø¹Ø± ØµØ­ÙŠØ­'),
                                backgroundColor: AppTheme.errorColor,
                              ),
                            );
                            return;
                          }

                          Navigator.pop(context);
                          await _createListing(product.id, price);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Ø¥Ø¶Ø§ÙØ©'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditListingModal(ResellerListing listing) {
    final priceController = TextEditingController(
      text: listing.resalePrice.toStringAsFixed(2),
    );
    bool isActive = listing.isActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'ØªØ¹Ø¯ÙŠÙ„ Ø§Ù„Ù‚Ø§Ø¦Ù…Ø©',
                    style: TextStyle(
                      fontSize: AppDimensions.fontHeadline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Ø³Ø¹Ø± Ø§Ù„Ø¨ÙŠØ¹ (Ø±.Ø³)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Ù†Ø´Ø·'),
                        value: isActive,
                        onChanged: (value) {
                          setModalState(() => isActive = value);
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final price = double.tryParse(priceController.text);
                            if (price == null || price <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ø§Ù„Ø±Ø¬Ø§Ø¡ Ø¥Ø¯Ø®Ø§Ù„ Ø³Ø¹Ø± ØµØ­ÙŠØ­'),
                                  backgroundColor: AppTheme.errorColor,
                                ),
                              );
                              return;
                            }

                            Navigator.pop(context);
                            await _updateListing(listing.id, price, isActive);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Ø­ÙØ¸'),
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
    );
  }

  Future<void> _createListing(
    String dropshipProductId,
    double resalePrice,
  ) async {
    try {
      final token = await ref.read(authTokenStorageProvider).getAccessToken();
      final response = await _api.post(
        '/secure/dropship/listings',
        body: {
          'dropship_product_id': dropshipProductId,
          'resale_price': resalePrice,
          'is_active': true,
        },
        headers: {'Authorization': 'Bearer $token'},
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ØªÙ… Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ù…Ù†ØªØ¬ Ù„Ù…ØªØ¬Ø±Ùƒ Ø¨Ù†Ø¬Ø§Ø­'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        _loadResellerListings();
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'ÙØ´Ù„ Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ù…Ù†ØªØ¬'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ø®Ø·Ø£: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _updateListing(
    String listingId,
    double resalePrice,
    bool isActive,
  ) async {
    try {
      final token = await ref.read(authTokenStorageProvider).getAccessToken();
      final response = await _api.patch(
        '/secure/dropship/listings/$listingId',
        body: {'resale_price': resalePrice, 'is_active': isActive},
        headers: {'Authorization': 'Bearer $token'},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ØªÙ… ØªØ­Ø¯ÙŠØ« Ø§Ù„Ù‚Ø§Ø¦Ù…Ø© Ø¨Ù†Ø¬Ø§Ø­'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        _loadResellerListings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ÙØ´Ù„ ØªØ­Ø¯ÙŠØ« Ø§Ù„Ù‚Ø§Ø¦Ù…Ø©'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ø®Ø·Ø£: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
