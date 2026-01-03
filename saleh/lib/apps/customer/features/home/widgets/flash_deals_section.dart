import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class FlashDealsSection extends ConsumerStatefulWidget {
  const FlashDealsSection({super.key});

  @override
  ConsumerState<FlashDealsSection> createState() => _FlashDealsSectionState();
}

class _FlashDealsSectionState extends ConsumerState<FlashDealsSection> {
  late Timer _timer;
  Duration _remainingTime = const Duration(hours: 5, minutes: 30, seconds: 45);

  // TODO: Replace with API data
  final List<FlashDealProduct> _products = [
    FlashDealProduct(
      id: '1',
      name: 'سماعات بلوتوث لاسلكية',
      imageUrl: 'https://picsum.photos/200?random=10',
      originalPrice: 299,
      discountedPrice: 149,
      discountPercent: 50,
      soldCount: 85,
      totalCount: 100,
    ),
    FlashDealProduct(
      id: '2',
      name: 'ساعة ذكية متطورة',
      imageUrl: 'https://picsum.photos/200?random=11',
      originalPrice: 599,
      discountedPrice: 359,
      discountPercent: 40,
      soldCount: 60,
      totalCount: 100,
    ),
    FlashDealProduct(
      id: '3',
      name: 'حقيبة ظهر أنيقة',
      imageUrl: 'https://picsum.photos/200?random=12',
      originalPrice: 199,
      discountedPrice: 99,
      discountPercent: 50,
      soldCount: 90,
      totalCount: 100,
    ),
    FlashDealProduct(
      id: '4',
      name: 'نظارة شمسية',
      imageUrl: 'https://picsum.photos/200?random=13',
      originalPrice: 249,
      discountedPrice: 124,
      discountPercent: 50,
      soldCount: 45,
      totalCount: 100,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.flash_on, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'عروض خاطفة',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildCountdownTimer(),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('عرض الكل')),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Products List
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(_products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer() {
    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        _buildTimeBox(hours),
        const Text(' : ', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTimeBox(minutes),
        const Text(' : ', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTimeBox(seconds),
      ],
    );
  }

  Widget _buildTimeBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildProductCard(FlashDealProduct product) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Image with Discount Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product.imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
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
                    '-${product.discountPercent}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${product.discountedPrice} ر.س',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.originalPrice}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: product.soldCount / product.totalCount,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'بيع ${product.soldCount} من ${product.totalCount}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlashDealProduct {
  final String id;
  final String name;
  final String imageUrl;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercent;
  final int soldCount;
  final int totalCount;

  FlashDealProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.soldCount,
    required this.totalCount,
  });
}
