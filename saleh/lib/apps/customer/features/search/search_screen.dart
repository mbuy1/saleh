import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? storeId;

  const SearchScreen({super.key, this.storeId});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;
  String _selectedSort = 'relevance';

  // TODO: Replace with API data
  final List<String> _recentSearches = [
    'سماعات بلوتوث',
    'ساعة ذكية',
    'آيفون',
    'حقيبة',
  ];

  final List<String> _popularSearches = [
    'سماعات',
    'ساعات ذكية',
    'هواتف',
    'لابتوب',
    'تابلت',
    'عطور',
  ];

  final List<SearchResult> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // TODO: Call API
    // Simulating search results
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchResults.clear();
          _searchResults.addAll(
            List.generate(
              10,
              (index) => SearchResult(
                id: 'p$index',
                name: '$query - منتج ${index + 1}',
                imageUrl: 'https://picsum.photos/200?random=${130 + index}',
                price: 100 + (index * 50).toDouble(),
                originalPrice: index % 3 == 0
                    ? 150 + (index * 50).toDouble()
                    : null,
                rating: 4.0 + (index % 10) / 10,
                reviewsCount: 10 + index * 5,
                storeName: 'متجر ${index + 1}',
              ),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.storeId != null
                ? 'ابحث في المتجر...'
                : 'ابحث عن منتجات...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            if (value.length >= 2) {
              _performSearch(value);
            } else if (value.isEmpty) {
              setState(() {
                _isSearching = false;
                _searchResults.clear();
              });
            }
          },
          onSubmitted: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _isSearching = false;
                  _searchResults.clear();
                });
              },
            ),
        ],
      ),
      body: _isSearching ? _buildSearchResults() : _buildSearchSuggestions(),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'البحث الأخير',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _recentSearches.clear());
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
                return GestureDetector(
                  onTap: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                  child: Chip(
                    label: Text(search),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() => _recentSearches.remove(search));
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Popular Searches
          const Text(
            'الأكثر بحثاً',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((search) {
              return ActionChip(
                avatar: const Icon(Icons.trending_up, size: 16),
                label: Text(search),
                onPressed: () {
                  _searchController.text = search;
                  _performSearch(search);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Filters Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            children: [
              // Results Count
              Text(
                '${_searchResults.length} نتيجة',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const Spacer(),
              // Sort
              DropdownButton<String>(
                value: _selectedSort,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: 'relevance',
                    child: Text('الأكثر صلة'),
                  ),
                  DropdownMenuItem(
                    value: 'price_low',
                    child: Text('السعر: منخفض'),
                  ),
                  DropdownMenuItem(
                    value: 'price_high',
                    child: Text('السعر: مرتفع'),
                  ),
                  DropdownMenuItem(value: 'rating', child: Text('التقييم')),
                  DropdownMenuItem(value: 'newest', child: Text('الأحدث')),
                ],
                onChanged: (value) {
                  setState(() => _selectedSort = value!);
                  // TODO: Re-sort results
                },
              ),
              const SizedBox(width: 8),
              // Filter
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  _showFilterSheet();
                },
              ),
            ],
          ),
        ),

        // Results Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              return _buildResultCard(_searchResults[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(SearchResult result) {
    return GestureDetector(
      onTap: () {
        context.push('/product/${result.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      result.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image),
                        );
                      },
                    ),
                    if (result.originalPrice != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${(((result.originalPrice! - result.price) / result.originalPrice!) * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      result.storeName,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${result.rating}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          ' (${result.reviewsCount})',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${result.price.toInt()} ر.س',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (result.originalPrice != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '${result.originalPrice!.toInt()}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
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
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'تصفية النتائج',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Reset filters
                        },
                        child: const Text('إعادة تعيين'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Price Range
                  const Text(
                    'نطاق السعر',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: const RangeValues(0, 1000),
                    min: 0,
                    max: 5000,
                    divisions: 50,
                    labels: const RangeLabels('0 ر.س', '1000 ر.س'),
                    onChanged: (values) {},
                  ),
                  const SizedBox(height: 24),

                  // Rating
                  const Text(
                    'التقييم',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [4, 3, 2, 1].map((rating) {
                      return FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$rating'),
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const Text(' وأعلى'),
                          ],
                        ),
                        selected: false,
                        onSelected: (selected) {},
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Apply filters
                      },
                      child: const Text('تطبيق الفلتر'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class SearchResult {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewsCount;
  final String storeName;

  SearchResult({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.storeName,
  });
}
