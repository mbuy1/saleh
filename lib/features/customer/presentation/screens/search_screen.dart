import 'package:flutter/material.dart';
import '../../../../core/firebase_service.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../shared/widgets/skeleton/skeleton_loader.dart';
import '../../../../shared/widgets/error_widget/error_state_widget.dart';
import 'product_details_screen.dart';
import 'store_details_screen.dart';

/// شاشة البحث الكاملة
class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _stores = [];
  List<String> _recentSearches = [];

  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  String? _currentQuery;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _performSearch(widget.initialQuery!);
    }
    // تتبع عرض شاشة البحث
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseService.logScreenView('search');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    try {
      final savedSearches = PreferencesService.getSearchHistory();
      if (mounted) {
        setState(() {
          _recentSearches = savedSearches;
        });
      }
    } catch (e) {
      // في حالة الخطأ، نبدأ بقائمة فارغة
      if (mounted) {
        setState(() {
          _recentSearches = [];
        });
      }
    }
  }

  Future<void> _saveSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() {
      // إزالة البحث إذا كان موجوداً (لنضعه في المقدمة)
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      // الحد الأقصى 10 عمليات بحث
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.take(10).toList();
      }
    });
    
    // حفظ في SharedPreferences
    try {
      await PreferencesService.saveSearchHistory(_recentSearches);
    } catch (e) {
      // تجاهل الخطأ في الحفظ
      debugPrint('خطأ في حفظ سجل البحث: $e');
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _products = [];
        _stores = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isSearching = true;
      _error = null;
      _currentQuery = query;
    });

    // تتبع البحث
    await FirebaseService.logSearch(query);

    try {
      // البحث في المنتجات
      final productsResponse = await supabaseClient
          .from('products')
          .select('id, name, price, image_url, store_id, stores(name)')
          .ilike('name', '%$query%')
          .eq('status', 'active')
          .limit(20);

      // البحث في المتاجر
      final storesResponse = await supabaseClient
          .from('stores')
          .select('id, name, logo_url, description')
          .ilike('name', '%$query%')
          .eq('status', 'active')
          .limit(10);

      setState(() {
        _products = List<Map<String, dynamic>>.from(productsResponse);
        _stores = List<Map<String, dynamic>>.from(storesResponse);
        _isLoading = false;
      });

      // حفظ البحث
      await _saveSearch(query);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _products = [];
      _stores = [];
      _currentQuery = null;
    });
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ابحث عن منتج أو متجر...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          onSubmitted: (query) => _performSearch(query),
          onChanged: (value) {
            setState(() {});
            // يمكن إضافة search suggestions هنا
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _performSearch(_searchController.text),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isSearching) {
      return _buildSearchSuggestions();
    }

    if (_isLoading) {
      return _buildSkeletonLoader();
    }

    if (_error != null) {
      return ErrorStateWidget(
        message: 'فشل البحث',
        details: _error,
        onRetry: () => _performSearch(_currentQuery ?? ''),
      );
    }

    if (_products.isEmpty && _stores.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'لا توجد نتائج',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text('جرب البحث بكلمات مختلفة'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _clearSearch,
                child: const Text('مسح البحث'),
              ),
            ],
          ),
        ),
      );
    }

    return _buildSearchResults();
  }

  Widget _buildSearchSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'البحث الأخير',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () async {
                  await PreferencesService.clearSearchHistory();
                  if (mounted) {
                    setState(() {
                      _recentSearches = [];
                    });
                  }
                },
                child: const Text('مسح الكل'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((search) {
              return ActionChip(
                label: Text(search),
                onPressed: () {
                  _searchController.text = search;
                  _performSearch(search);
                },
                avatar: const Icon(Icons.history, size: 18),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          'اقتراحات البحث',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        // TODO: جلب اقتراحات من API
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'منتجات رائجة',
            'عروض خاصة',
            'جديد',
            'مميز',
          ].map((suggestion) {
            return ActionChip(
              label: Text(suggestion),
              onPressed: () {
                _searchController.text = suggestion;
                _performSearch(suggestion);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_stores.isNotEmpty) ...[
          Text(
            'المتاجر (${_stores.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ..._stores.map((store) => _buildStoreCard(store)),
          const SizedBox(height: 24),
        ],
        if (_products.isNotEmpty) ...[
          Text(
            'المنتجات (${_products.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ..._products.map((product) => _buildProductCard(product)),
        ],
      ],
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: store['logo_url'] != null
              ? NetworkImage(store['logo_url'])
              : null,
          child: store['logo_url'] == null
              ? const Icon(Icons.store)
              : null,
        ),
        title: Text(store['name'] ?? 'متجر'),
        subtitle: Text(store['description'] ?? ''),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreDetailsScreen(
                storeId: store['id'],
                storeName: store['name'] ?? 'متجر',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final price = (product['price'] as num?)?.toDouble() ?? 0.0;
    final storeName = (product['stores'] as Map<String, dynamic>?)?['name'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: product['image_url'] != null
            ? Image.network(
                product['image_url'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 60);
                },
              )
            : const Icon(Icons.image, size: 60),
        title: Text(product['name'] ?? 'منتج'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (storeName.isNotEmpty) Text('من: $storeName'),
            Text('${price.toStringAsFixed(2)} ر.س'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                productId: product['id'],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SkeletonLoader(width: 150, height: 20),
        const SizedBox(height: 12),
        ...List.generate(3, (index) => const SkeletonListItem()),
        const SizedBox(height: 24),
        const SkeletonLoader(width: 150, height: 20),
        const SizedBox(height: 12),
        ...List.generate(5, (index) => const SkeletonListItem()),
      ],
    );
  }
}

