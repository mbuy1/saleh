import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// بطاقة منتج قابلة لإعادة الاستخدام
///
/// تعرض:
/// - صورة المنتج
/// - اسم المنتج
/// - السعر
/// - التقييم
/// - زر إضافة للسلة (اختياري)
class ProductCard extends StatelessWidget {
  /// معرف المنتج
  final String productId;

  /// اسم المنتج
  final String productName;

  /// سعر المنتج
  final double price;

  /// رابط صورة المنتج
  final String? imageUrl;

  /// التقييم (من 0 إلى 5)
  final double rating;

  /// عدد التقييمات
  final int reviewCount;

  /// المخزون المتاح
  final int stock;

  /// عند الضغط على البطاقة
  final VoidCallback? onTap;

  /// عند الضغط على زر السلة
  final VoidCallback? onAddToCart;

  /// عرض زر السلة
  final bool showAddToCart;

  /// عرض شارة "نفذ من المخزون"
  final bool showOutOfStock;

  const ProductCard({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
    this.onTap,
    this.onAddToCart,
    this.showAddToCart = true,
    this.showOutOfStock = true,
  });

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = showOutOfStock && stock <= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                ),
                // شارة نفذ من المخزون
                if (isOutOfStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'نفذ من المخزون',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // معلومات المنتج
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج
                    Text(
                      productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MbuyColors.textPrimary,
                      ),
                    ),
                    const Spacer(),

                    // التقييم
                    if (rating > 0)
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber[700]),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (reviewCount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '($reviewCount)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),

                    const SizedBox(height: 8),

                    // السعر وزر السلة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // السعر
                        Text(
                          '${price.toStringAsFixed(2)} ر.س',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MbuyColors.primaryMaroon,
                          ),
                        ),

                        // زر السلة
                        if (showAddToCart && !isOutOfStock)
                          GestureDetector(
                            onTap: onAddToCart,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: MbuyColors.primaryMaroon,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
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

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.image_outlined, size: 48, color: Colors.grey[400]),
      ),
    );
  }
}

/// بطاقة منتج مضغوطة (أفقية)
/// تستخدم في القوائم والسلة
class ProductCardCompact extends StatelessWidget {
  final String productName;
  final double price;
  final String? imageUrl;
  final int quantity;
  final VoidCallback? onTap;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  const ProductCardCompact({
    super.key,
    required this.productName,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
    this.onTap,
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),

            const SizedBox(width: 12),

            // معلومات المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${price.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.primaryMaroon,
                    ),
                  ),
                ],
              ),
            ),

            // أزرار التحكم بالكمية
            Column(
              children: [
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: onRemove,
                    color: Colors.red,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 24),
                      onPressed: onDecrease,
                      color: MbuyColors.primaryMaroon,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 24),
                      onPressed: onIncrease,
                      color: MbuyColors.primaryMaroon,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.image_outlined, size: 32, color: Colors.grey[400]),
    );
  }
}
