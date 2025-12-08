import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/smart_search_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../screens/product_details_screen.dart';
import '../screens/store_details_screen.dart';

/// شاشة البحث الذكي
class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _stores = [];
  List<String> _suggestions = [];
  bool _isLoading = false;
  String? _error;
  String _currentQuery = '';
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _currentQuery = widget.initialQuery!;
      _performSearch();
    } else {
      _loadSuggestions();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadSuggestions() async {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    try {
      final suggestions = await SmartSearchService.getSearchSuggestions(
        query: _searchController.text.trim(),
      );
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      // Silently fail for suggestions
      debugPrint('Error loading suggestions: $e');
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _products = [];
        _stores = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _currentQuery = query;
    });

    try {
      final results = await SmartSearchService.searchAll(query: query);
      setState(() {
        _products = results['products'] ?? [];
        _stores = results['stores'] ?? [];
        _suggestions = results['suggestions'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MbuyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ابحث عن منتجات أو متاجر...',
            border: InputBorder.none,
            hintStyle: GoogleFonts.cairo(
              color: MbuyColors.textTertiary,
            ),
          ),
          style: GoogleFonts.cairo(
            color: MbuyColors.textPrimary,
          ),
          onChanged: (value) {
            _loadSuggestions();
          },
          onSubmitted: (_) {
            _performSearch();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: MbuyColors.primaryMaroon),
            onPressed: _performSearch,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: MbuyColors.alertRed),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_currentQuery.isEmpty) {
      return _buildSuggestionsView();
    }

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: MbuyColors.primaryMaroon,
          unselectedLabelColor: MbuyColors.textSecondary,
          indicatorColor: MbuyColors.primaryMaroon,
          tabs: [
            Tab(
              child: Text(
                'الكل (${_products.length + _stores.length})',
                style: GoogleFonts.cairo(),
              ),
            ),
            Tab(
              child: Text(
                'المنتجات (${_products.length})',
                style: GoogleFonts.cairo(),
              ),
            ),
            Tab(
              child: Text(
                'المتاجر (${_stores.length})',
                style: GoogleFonts.cairo(),
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllResults(),
              _buildProductsList(),
              _buildStoresList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsView() {
    if (_suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: MbuyColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'ابدأ البحث عن منتجات أو متاجر',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: MbuyColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'اقتراحات البحث',
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MbuyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ..._suggestions.map((suggestion) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.search, color: MbuyColors.primaryMaroon),
            title: Text(
              suggestion,
              style: GoogleFonts.cairo(),
            ),
            onTap: () {
              _searchController.text = suggestion;
              _performSearch();
            },
          ),
        )),
      ],
    );
  }

  Widget _buildAllResults() {
    if (_products.isEmpty && _stores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: MbuyColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'لا توجد نتائج لـ $_currentQuery',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: MbuyColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_products.isNotEmpty) ...[
          Text(
            'المنتجات',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._products.take(5).map((product) => _buildProductCard(product)),
          if (_products.length > 5) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _tabController?.animateTo(1);
              },
              child: Text(
                'عرض جميع المنتجات (${_products.length})',
                style: GoogleFonts.cairo(),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
        if (_stores.isNotEmpty) ...[
          Text(
            'المتاجر',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._stores.take(5).map((store) => _buildStoreCard(store)),
          if (_stores.length > 5) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _tabController?.animateTo(2);
              },
              child: Text(
                'عرض جميع المتاجر (${_stores.length})',
                style: GoogleFonts.cairo(),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildProductsList() {
    if (_products.isEmpty) {
      return Center(
        child: Text(
          'لا توجد منتجات',
          style: GoogleFonts.cairo(
            fontSize: 16,
            color: MbuyColors.textSecondary,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: _products.map((product) => _buildProductCard(product)).toList(),
    );
  }

  Widget _buildStoresList() {
    if (_stores.isEmpty) {
      return Center(
        child: Text(
          'لا توجد متاجر',
          style: GoogleFonts.cairo(
            fontSize: 16,
            color: MbuyColors.textSecondary,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: _stores.map((store) => _buildStoreCard(store)).toList(),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                productId: product['id'] ?? '',
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product['image_url'] ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: MbuyColors.borderLight,
                      child: const Icon(Icons.image, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'منتج',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(product['price'] ?? 0.0).toStringAsFixed(2)} ر.س',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.primaryMaroon,
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

  Widget _buildStoreCard(Map<String, dynamic> store) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreDetailsScreen(
                storeId: store['id'] ?? '',
                storeName: store['name'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  store['logo_url'] ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: MbuyColors.borderLight,
                      child: const Icon(Icons.store, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store['name'] ?? 'متجر',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MbuyColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (store['city'] != null)
                      Text(
                        store['city'],
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: MbuyColors.textSecondary,
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
}

