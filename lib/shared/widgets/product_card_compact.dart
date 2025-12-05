import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/data/models.dart';
import '../../features/customer/presentation/screens/product_details_screen.dart';
import '../../features/customer/data/services/cart_service.dart';
import '../../core/permissions_helper.dart';

/// بطاقة منتج مدمجة للاستخدام في القوائم الأفقية
class ProductCardCompact extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final double width;
  final bool hideActions;

  const ProductCardCompact({
    super.key,
    required this.product,
    this.onTap,
    this.width = 140,
    this.hideActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = product.imageUrl != null;
    final cardWidth = width == double.infinity ? null : width;

    return InkWell(
      onTap:
          onTap ??
          () {
            // Navigate to product details if no custom onTap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsScreen(productId: product.id),
              ),
            );
          },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MbuyColors.borderLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج - نسبة 1:1 مربعة
            AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: MbuyColors.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      image: hasImage
                          ? DecorationImage(
                              image: NetworkImage(product.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: !hasImage
                        ? const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 32,
                              color: MbuyColors.textTertiary,
                            ),
                          )
                        : null,
                  ),
                  // أيقونة المفضلة
                  if (!hideActions)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: MbuyColors.textSecondary,
                        ),
                      ),
                    ),
                  // زر إضافة للسلة
                  if (!hideActions)
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () async {
                          // منع الانتشار للـ InkWell
                          // ignore: use_build_context_synchronously
                          try {
                            final canAdd =
                                await PermissionsHelper.canAddToCart();
                            if (!canAdd) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('التجار لا يمكنهم الشراء'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                              return;
                            }

                            await CartService.addToCart(
                              product.id,
                              quantity: 1,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تمت الإضافة إلى السلة'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('خطأ: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: MbuyColors.primaryMaroon,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // معلومات المنتج
            Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: MbuyColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${product.price.toStringAsFixed(0)} ر.س',
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  if (!hideActions) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 11,
                          color: MbuyColors.warning,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: MbuyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
