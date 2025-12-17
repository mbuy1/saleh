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
import '../../../../core/constants/app_dimensions.dart';

/// شاشة معاينة متجر التاجر
class ViewMyStoreScreen extends ConsumerStatefulWidget {
  const ViewMyStoreScreen({super.key});

  @override
  ConsumerState<ViewMyStoreScreen> createState() => _ViewMyStoreScreenState();
}

class _ViewMyStoreScreenState extends ConsumerState<ViewMyStoreScreen> {
  final ApiService _api = ApiService();

  Map<String, dynamic>? _store;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  Future<void> _loadStoreData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // جلب بيانات المتجر والمنتجات
      final results = await Future.wait([
        _api.get('/secure/merchant/store'),
        _api.get('/secure/products'),
      ]);

      final storeResponse = results[0];
      final productsResponse = results[1];

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
    } catch (e) {
      _error = 'حدث خطأ في تحميل البيانات';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
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
      const SnackBar(
        content: Text('تم نسخ الرابط'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorState()
          : _buildStorePreview(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.errorOutline,
            width: AppDimensions.iconDisplay,
            height: AppDimensions.iconDisplay,
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
          ),
          SizedBox(height: AppDimensions.spacing16),
          Text(_error!, style: const TextStyle(color: Colors.red)),
          SizedBox(height: AppDimensions.spacing16),
          ElevatedButton(
            onPressed: _loadStoreData,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorePreview() {
    return CustomScrollView(
      slivers: [
        // Preview Banner
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(AppDimensions.spacing16),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing12,
            ),
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusM,
              border: Border.all(
                color: AppTheme.warningColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  color: AppTheme.warningColor,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.spacing12),
                const Expanded(
                  child: Text(
                    'هذه معاينة لمتجرك كما يراه العملاء',
                    style: TextStyle(
                      color: AppTheme.warningColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Store Header
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: SvgPicture.asset(
              AppIcons.arrowBack,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                AppIcons.share,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: _shareStore,
            ),
            IconButton(
              icon: SvgPicture.asset(
                AppIcons.copy,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: _copyStoreLink,
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Cover Image or Gradient
                _store?['cover_url'] != null
                    ? Image.network(_store!['cover_url'], fit: BoxFit.cover)
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppTheme.primaryColor, Color(0xFF1565C0)],
                          ),
                        ),
                      ),
                // Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                // Store Info
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // Logo
                      Container(
                        width: AppDimensions.avatarProfile,
                        height: AppDimensions.avatarProfile,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppDimensions.borderRadiusM,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: _store?['logo_url'] != null
                            ? ClipRRect(
                                borderRadius: AppDimensions.borderRadiusM,
                                child: Image.network(
                                  _store!['logo_url'],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : SvgPicture.asset(
                                AppIcons.store,
                                width: AppDimensions.iconXXL,
                                height: AppDimensions.iconXXL,
                                colorFilter: const ColorFilter.mode(
                                  AppTheme.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                      ),
                      SizedBox(width: AppDimensions.spacing16),
                      // Store Name & Stats
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _store?['name'] ?? 'متجري',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppDimensions.fontDisplay2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacing4),
                            Row(
                              children: [
                                _buildStatChip(
                                  AppIcons.shoppingBag,
                                  '${_products.length}',
                                ),
                                SizedBox(width: AppDimensions.spacing8),
                                _buildStatChip(
                                  AppIcons.visibility,
                                  '${_store?['views_count'] ?? 0}',
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
            ),
          ),
        ),

        // Store Description
        if (_store?['description'] != null)
          SliverToBoxAdapter(
            child: Container(
              margin: AppDimensions.paddingM,
              padding: AppDimensions.paddingM,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDimensions.borderRadiusM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عن المتجر',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontTitle,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  Text(
                    _store!['description'],
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Products Section Title
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.spacing16,
              AppDimensions.spacing8,
              AppDimensions.spacing16,
              AppDimensions.spacing12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المنتجات (${_products.length})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontHeadline,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/dashboard/products'),
                  child: const Text('إدارة المنتجات'),
                ),
              ],
            ),
          ),
        ),

        // Products Grid
        _products.isEmpty
            ? SliverToBoxAdapter(
                child: Container(
                  margin: AppDimensions.paddingM,
                  padding: AppDimensions.paddingXXL,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppIcons.inventory2,
                        width: AppDimensions.iconDisplay,
                        height: AppDimensions.iconDisplay,
                        colorFilter: ColorFilter.mode(
                          Colors.grey[400]!,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacing16),
                      Text(
                        'لا توجد منتجات',
                        style: TextStyle(
                          fontSize: AppDimensions.fontTitle,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacing16),
                      ElevatedButton.icon(
                        onPressed: () =>
                            context.push('/dashboard/products/add'),
                        icon: SvgPicture.asset(
                          AppIcons.add,
                          width: AppDimensions.iconS,
                          height: AppDimensions.iconS,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: const Text('إضافة منتج'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing16,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppDimensions.spacing12,
                    crossAxisSpacing: AppDimensions.spacing12,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = _products[index];
                    return _buildProductCard(product);
                  }, childCount: _products.length),
                ),
              ),

        // Bottom Padding
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildStatChip(String iconPath, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing8,
        vertical: AppDimensions.spacing4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: AppDimensions.borderRadiusM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: AppDimensions.fontBody,
            height: AppDimensions.fontBody,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: AppDimensions.spacing4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimensions.fontLabel,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusM,
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
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusM),
              ),
              child: Container(
                width: double.infinity,
                color: Colors.grey[200],
                child: product['main_image_url'] != null
                    ? Image.network(
                        product['main_image_url'],
                        fit: BoxFit.cover,
                      )
                    : SvgPicture.asset(
                        AppIcons.image,
                        width: AppDimensions.iconXXL,
                        height: AppDimensions.iconXXL,
                        colorFilter: ColorFilter.mode(
                          Colors.grey[400]!,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
            ),
          ),
          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: AppDimensions.paddingS,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppDimensions.fontBody2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(product['price'] ?? 0).toStringAsFixed(2)} ر.س',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontBody,
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
}
