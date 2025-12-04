import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/firebase_service.dart';
import '../../../../shared/widgets/skeleton/skeleton_loader.dart';
import 'product_details_screen.dart';

class StoreDetailsScreen extends StatefulWidget {
  final String storeId;
  final String storeName;

  const StoreDetailsScreen({
    super.key,
    required this.storeId,
    required this.storeName,
  });

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  Map<String, dynamic>? _store;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStoreDetails();
    // تتبع عرض المتجر
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseService.logViewStore(
        storeId: widget.storeId,
        storeName: widget.storeName,
      );
      FirebaseService.logScreenView('store_details', parameters: {
        'store_id': widget.storeId,
        'store_name': widget.storeName,
      });
    });
  }

  Future<void> _loadStoreDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // جلب تفاصيل المتجر
      final storeResponse = await supabaseClient
          .from('stores')
          .select()
          .eq('id', widget.storeId)
          .single();

      // جلب منتجات المتجر
      final productsResponse = await supabaseClient
          .from('products')
          .select()
          .eq('store_id', widget.storeId)
          .eq('status', 'active')
          .order('created_at', ascending: false);

      setState(() {
        _store = storeResponse;
        _products = List<Map<String, dynamic>>.from(productsResponse);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب البيانات: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Semantics(
            label: 'مشاركة المتجر',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('قريباً: مشاركة المتجر')),
                );
              },
            ),
          ),
          Semantics(
            label: 'رجوع',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonLoader()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // صورة المتجر
                  Container(
                    height: 200,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: _store?['logo_url'] != null
                        ? Image.network(
                            _store!['logo_url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.store,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.store,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                  ),

                  // معلومات المتجر
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.storeName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_store?['city'] != null) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.location_city,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _store!['city'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (_store?['description'] != null) ...[
                          Text(
                            _store!['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // المنتجات
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'المنتجات',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_products.length} منتج',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // قائمة المنتجات
                  if (_products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'لا توجد منتجات في هذا المتجر',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(_products[index]);
                      },
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(productId: product['id']),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة المنتج
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: product['image_url'] != null
                    ? Image.network(
                        product['image_url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.shopping_bag,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(
                          Icons.shopping_bag,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'منتج',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product['price'] ?? 0} ر.س',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Skeleton Store Image
          SkeletonLoader(
            width: double.infinity,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skeleton Store Name
                SkeletonLoader(width: 200, height: 24),
                const SizedBox(height: 12),
                // Skeleton Description
                SkeletonLoader(width: double.infinity, height: 16),
                const SizedBox(height: 8),
                SkeletonLoader(width: 150, height: 16),
                const SizedBox(height: 24),
                // Skeleton Products Title
                SkeletonLoader(width: 120, height: 20),
                const SizedBox(height: 16),
                // Skeleton Products Grid
                SkeletonGrid(itemCount: 4, crossAxisCount: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
