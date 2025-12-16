import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/auth_token_storage.dart';
import '../../../products/data/categories_repository.dart';
import '../../../products/domain/models/category.dart';

/// نموذج منتج دروب شوبينقنا
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

/// نموذج Reseller Listing
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

/// شاشة دروب شوبينقنا مع Tabs
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
  int _myProductsTabIndex = 0; // 0 = منتجاتي (supplier), 1 = مستورد (reseller)
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

  /// جلب التصنيفات
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

  /// جلب منتجات التصنيف المحدد
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

          // TODO: تصفية حسب category_id عند توفرها في API
          // حالياً نعرض كل المنتجات
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

  /// جلب منتجات المورد
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

  /// جلب قوائم الموزع
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
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(AppIcons.arrowBack, width: 24, height: 24),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'دروب شوبينقنا',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
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
              Tab(text: 'ماهو شوبينقنا؟'),
              Tab(text: 'التصنيفات'),
              Tab(text: 'منتجاتي'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildInfoTab(),
            _buildCategoriesTab(),
            _buildMyProductsTab(),
          ],
        ),
      ),
    );
  }

  /// تبويب: ماهو شوبينقنا؟
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) ماهو شوبينقنا؟
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1) ماهو شوبينقنا؟',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'شوبينقنا هو نظام دروب شوبينق داخلي يربط تجار المنصة مع بعض.\n'
                    'تاجر يوفّر المنتج، وتاجر آخر يبيعه، والطلب يوصل للمورد مباشرة باسم الموزع ويتم شحنه للعميل، وكل العملية منظمة وواضحة داخل النظام.',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 2) كيف تتم العملية؟
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2) كيف تتم العملية؟',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '\t1. المورد يضيف المنتج ويحدد السعر والمخزون',
                          style: TextStyle(fontSize: 16, height: 1.6),
                        ),
                        Text(
                          '\t2. الموزع يضيف المنتج لمتجره ويحدد سعر البيع',
                          style: TextStyle(fontSize: 16, height: 1.6),
                        ),
                        Text(
                          '\t3. عند الشراء، يتم إرسال الطلب للمورد مع بيانات العميل ليتم الشحن مباشرة',
                          style: TextStyle(fontSize: 16, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 3) لماذا شوبينقنا؟
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '3) لماذا شوبينقنا؟',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '• بيع بدون الحاجة لمخزون',
                          style: TextStyle(fontSize: 16, height: 1.6),
                        ),
                        Text(
                          '• توسّع أسرع للمتاجر',
                          style: TextStyle(fontSize: 16, height: 1.6),
                        ),
                        Text(
                          '• تعاون فعلي بين التجار بدل المنافسة',
                          style: TextStyle(fontSize: 16, height: 1.6),
                        ),
                        Text(
                          '• عدة محطات بيع بدل نقطة بيع واحدة',
                          style: TextStyle(fontSize: 16, height: 1.6),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '(منتجك ما يعتمد على متجر واحد فقط، بل يُباع عبر متاجر متعددة)',
                          style: TextStyle(
                            fontSize: 14,
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
          // 4) توزيع المسؤوليات
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '4) توزيع المسؤوليات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // المورد
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.store, color: Colors.orange, size: 24),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'المورد:',
                          style: TextStyle(
                            fontSize: 16,
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
                          '• توفير المنتج وتحديث المخزون',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• تجهيز الطلبات وشحنها للعميل',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• الالتزام بجودة المنتج ووقت التنفيذ',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // الموزع
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.green, size: 24),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'الموزع:',
                          style: TextStyle(
                            fontSize: 16,
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
                          '• عرض المنتجات داخل متجره',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• التسويق والبيع للعملاء',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• إدارة تجربة ما قبل الشراء',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // المنصة
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.business,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'المنصة:',
                          style: TextStyle(
                            fontSize: 16,
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
                          '• تنظيم عملية التعاون بين التجار',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• إدارة تدفق الطلبات وتوثيقها',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• تقليل النزاعات وضمان وضوح العمليات',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• خلق فرص بيع مشتركة بين التجار',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 5) عمولة المنصة
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '5) عمولة المنصة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // المورد
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.store, color: Colors.orange, size: 24),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'المورد (2.5٪):',
                          style: TextStyle(
                            fontSize: 16,
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
                          '• حصل على قنوات بيع إضافية بدون تسويق',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• زادت مبيعاته بدون تكلفة استحواذ عميل',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // الموزع
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.green, size: 24),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'الموزع (2.5٪):',
                          style: TextStyle(
                            fontSize: 16,
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
                          '• لا يتحمل مخزون ولا شحن',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• يركّز فقط على البيع والتسويق',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // المنصة
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.business,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'المنصة (5٪):',
                          style: TextStyle(
                            fontSize: 16,
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
                          '• تدير النظام',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• توثق الطلبات',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• تقلل النزاعات',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Text(
                          '• وتخلق فرص بيع للجميع',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 6) عبارة ختامية
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '6) عبارة ختامية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'شوبينقنا يحوّل التعاون بين التجار إلى شبكة بيع حقيقية ترفع المبيعات للجميع بدون تعقيد.',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// تبويب: التصنيفات
  Widget _buildCategoriesTab() {
    if (_categoriesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_selectedCategoryId == null) {
      // عرض قائمة التصنيفات
      if (_categories.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'لا توجد تصنيفات متاحة',
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
      // عرض منتجات التصنيف المحدد
      return Column(
        children: [
          // زر العودة
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // قائمة المنتجات
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
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد منتجات في هذا التصنيف',
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
              Icon(Icons.category, size: 48, color: AppTheme.primaryColor),
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
                      product.supplierStoreName ?? 'متجر',
                      style: TextStyle(
                        fontSize: AppDimensions.fontBody2,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.supplierPrice.toStringAsFixed(2)} ر.س',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontSize: AppDimensions.fontBody,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'المخزون: ${product.stockQty}',
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
                child: const Text('أضف لمتجري'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// تبويب: منتجاتي (مع تبويبين داخليين)
  Widget _buildMyProductsTab() {
    return Column(
      children: [
        // Segmented Control للتبويبين الداخليين
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
                        'منتجاتي',
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
                        'مستورد',
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
        // المحتوى حسب التبويب الداخلي المحدد
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
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد منتجات كمورد',
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
                    child: const Text('إضافة منتج'),
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
            Text('السعر: ${product.supplierPrice.toStringAsFixed(2)} ر.س'),
            Text('المخزون: ${product.stockQty}'),
            Text(
              product.isDropshipEnabled ? 'مفعّل لدروب شوبينقنا' : 'غير مفعّل',
              style: TextStyle(
                color: product.isDropshipEnabled ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // TODO: فتح شاشة تعديل المنتج
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
                  Icon(Icons.store_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد منتجات كموزع',
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
        title: Text(listing.title ?? 'منتج'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('سعر البيع: ${listing.resalePrice.toStringAsFixed(2)} ر.س'),
            if (listing.supplierPrice != null)
              Text(
                'سعر الجملة: ${listing.supplierPrice!.toStringAsFixed(2)} ر.س',
              ),
            Text(
              listing.isActive ? 'نشط' : 'غير نشط',
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
                  'إضافة لمتجرك',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        labelText: 'سعر البيع (ر.س)',
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
                                content: Text('الرجاء إدخال سعر صحيح'),
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
                        child: const Text('إضافة'),
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
                    'تعديل القائمة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          labelText: 'سعر البيع (ر.س)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('نشط'),
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
                                  content: Text('الرجاء إدخال سعر صحيح'),
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
                          child: const Text('حفظ'),
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
            content: Text('تم إضافة المنتج لمتجرك بنجاح'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        _loadResellerListings();
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'فشل إضافة المنتج'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: $e'),
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
            content: Text('تم تحديث القائمة بنجاح'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        _loadResellerListings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل تحديث القائمة'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
