import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FeaturedStoresSection extends ConsumerWidget {
  const FeaturedStoresSection({super.key});

  // TODO: Replace with API data
  static final List<FeaturedStore> _stores = [
    FeaturedStore(
      id: '1',
      name: 'متجر الإلكترونيات',
      logoUrl: 'https://picsum.photos/100?random=20',
      coverUrl: 'https://picsum.photos/400/200?random=21',
      rating: 4.8,
      productsCount: 156,
      isVerified: true,
    ),
    FeaturedStore(
      id: '2',
      name: 'أزياء العائلة',
      logoUrl: 'https://picsum.photos/100?random=22',
      coverUrl: 'https://picsum.photos/400/200?random=23',
      rating: 4.6,
      productsCount: 324,
      isVerified: true,
    ),
    FeaturedStore(
      id: '3',
      name: 'بيت الجمال',
      logoUrl: 'https://picsum.photos/100?random=24',
      coverUrl: 'https://picsum.photos/400/200?random=25',
      rating: 4.9,
      productsCount: 89,
      isVerified: false,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'متاجر مميزة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all stores
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stores List
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _stores.length,
              itemBuilder: (context, index) {
                return _buildStoreCard(context, _stores[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, FeaturedStore store) {
    return GestureDetector(
      onTap: () {
        context.push('/store/${store.id}');
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Cover Image
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    store.coverUrl,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.2),
                      );
                    },
                  ),
                ),
                // Store Logo
                Positioned(
                  bottom: -25,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(store.logoUrl),
                        onBackgroundImageError: (_, _) {},
                        child: store.logoUrl.isEmpty
                            ? Text(
                                store.name[0],
                                style: const TextStyle(fontSize: 20),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Store Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (store.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${store.rating}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${store.productsCount} منتج',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedStore {
  final String id;
  final String name;
  final String logoUrl;
  final String coverUrl;
  final double rating;
  final int productsCount;
  final bool isVerified;

  FeaturedStore({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.coverUrl,
    required this.rating,
    required this.productsCount,
    required this.isVerified,
  });
}
