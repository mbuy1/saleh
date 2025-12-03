import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import '../../../../shared/widgets/shein/shein_top_bar.dart';
import '../../../../shared/widgets/product_card_compact.dart';
import '../../../../core/data/models.dart';

/// صفحة منتجات الفئة بتصميم SHEIN
class CategoryProductsScreenShein extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsScreenShein({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductsScreenShein> createState() => _CategoryProductsScreenSheinState();
}

class _CategoryProductsScreenSheinState extends State<CategoryProductsScreenShein> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await supabaseClient
          .from('products')
          .select()
          .eq('category_id', widget.categoryId)
          .eq('status', 'active')
          .order('created_at', ascending: false);

      setState(() {
        _products = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب المنتجات: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Product _mapToProduct(Map<String, dynamic> data) {
    return Product(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? 'منتج',
      description: data['description']?.toString() ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      categoryId: data['category_id']?.toString() ?? '',
      storeId: data['store_id']?.toString() ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['review_count'] as num?)?.toInt() ?? 0,
      stockCount: (data['stock'] as num?)?.toInt() ?? 0,
      imageUrl: data['image_url']?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SheinTopBar(
        logoText: widget.categoryName,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد منتجات في هذه الفئة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تحقق لاحقاً للمزيد من المنتجات',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadProducts,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _mapToProduct(_products[index]);
                  return ProductCardCompact(
                    product: product,
                    width: double.infinity,
                  );
                },
              ),
            ),
    );
  }
}

