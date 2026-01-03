import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;

  // TODO: Replace with API data
  late final Product _product = Product(
    id: widget.productId,
    name: 'سماعات بلوتوث لاسلكية احترافية مع تقنية إلغاء الضوضاء',
    description: '''
سماعات بلوتوث لاسلكية بجودة صوت عالية مع تقنية إلغاء الضوضاء النشطة.

المميزات:
• تقنية إلغاء الضوضاء النشطة ANC
• بطارية تدوم حتى 30 ساعة
• صوت ستيريو عالي الجودة
• مقاومة للماء IPX4
• تصميم مريح للارتداء الطويل
• ميكروفون مدمج للمكالمات

المحتويات:
- سماعة لاسلكية
- كابل شحن USB-C
- حقيبة حمل
- دليل المستخدم
    ''',
    images: [
      'https://picsum.photos/400?random=100',
      'https://picsum.photos/400?random=101',
      'https://picsum.photos/400?random=102',
      'https://picsum.photos/400?random=103',
    ],
    price: 149,
    originalPrice: 299,
    rating: 4.8,
    reviewsCount: 234,
    soldCount: 1250,
    stock: 50,
    storeName: 'متجر الإلكترونيات',
    storeId: 's1',
    storeLogoUrl: 'https://picsum.photos/50?random=104',
    storeRating: 4.9,
    category: 'إلكترونيات',
    specifications: [
      Specification(name: 'اللون', value: 'أسود'),
      Specification(name: 'الوزن', value: '250 جرام'),
      Specification(name: 'البطارية', value: '30 ساعة'),
      Specification(name: 'البلوتوث', value: '5.2'),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Images
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black,
                  ),
                ),
                onPressed: () {
                  setState(() => _isFavorite = !_isFavorite);
                  // TODO: Add to favorites via API
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.black),
                ),
                onPressed: () {
                  // TODO: Share product
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    onPageChanged: (index) {
                      setState(() => _currentImageIndex = index);
                    },
                    itemCount: _product.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        _product.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 50),
                          );
                        },
                      );
                    },
                  ),
                  // Image Indicators
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_product.images.length, (index) {
                        return Container(
                          width: _currentImageIndex == index ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _currentImageIndex == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Discount Badge
                  if (_product.originalPrice != null)
                    Positioned(
                      top: 100,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '-${((((_product.originalPrice ?? 0) - _product.price) / (_product.originalPrice ?? 1)) * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Product Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Row(
                    children: [
                      Text(
                        '${_product.price} ر.س',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if (_product.originalPrice != null) ...[
                        const SizedBox(width: 12),
                        Text(
                          '${_product.originalPrice} ر.س',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    _product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating & Stats
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${_product.rating}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' (${_product.reviewsCount} تقييم)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${_product.soldCount} مبيعات',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Store Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(_product.storeLogoUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _product.storeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${_product.storeRating}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            context.push('/store/${_product.storeId}');
                          },
                          child: const Text('زيارة المتجر'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Specifications
                  const Text(
                    'المواصفات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...(_product.specifications.map((spec) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              spec.name,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Expanded(child: Text(spec.value)),
                        ],
                      ),
                    );
                  }).toList()),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'الوصف',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _product.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Add to Cart Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Add to cart via API
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تمت الإضافة إلى السلة'),
                        action: SnackBarAction(
                          label: 'عرض السلة',
                          onPressed: () {
                            // Navigate to cart
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: Text('أضف للسلة - ${_product.price * _quantity} ر.س'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewsCount;
  final int soldCount;
  final int stock;
  final String storeName;
  final String storeId;
  final String storeLogoUrl;
  final double storeRating;
  final String category;
  final List<Specification> specifications;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.soldCount,
    required this.stock,
    required this.storeName,
    required this.storeId,
    required this.storeLogoUrl,
    required this.storeRating,
    required this.category,
    required this.specifications,
  });
}

class Specification {
  final String name;
  final String value;

  Specification({required this.name, required this.value});
}
