import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/data/models.dart';
import '../../core/data/dummy_data.dart';

/// بطاقة منتج موحدة - تستخدم في جميع أنحاء التطبيق
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final bool showActions;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final store = DummyData.getStoreById(product.storeId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MbuyColors.primaryPurple.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صورة المنتج
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: MbuyColors.primaryGradient,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // تفاصيل المنتج
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // اسم المنتج
                      Text(
                        product.name,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: MbuyColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // السعر والتقييم
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // السعر
                          Text(
                            '${product.price.toStringAsFixed(0)} ر.س',
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: MbuyColors.primaryPurple,
                            ),
                          ),
                          // التقييم
                          if (product.rating > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  product.rating.toStringAsFixed(1),
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: MbuyColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      // اسم المتجر
                      if (store != null)
                        Text(
                          store.name,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: MbuyColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
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

/// بطاقة متجر موحدة - على طريقة Snapchat Stories
class StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback? onTap;

  const StoreCard({super.key, required this.store, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // صورة المتجر مع حلقة
          Stack(
            alignment: Alignment.center,
            children: [
              // الحلقة الخارجية
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: store.isBoosted
                      ? MbuyColors.primaryGradient
                      : LinearGradient(
                          colors: [
                            MbuyColors.surfaceLight,
                            MbuyColors.surfaceLight,
                          ],
                        ),
                ),
              ),
              // صورة المتجر
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MbuyColors.primaryPurple.withValues(alpha: 0.3),
                          MbuyColors.primaryLight.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        store.name[0],
                        style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MbuyColors.primaryPurple,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // علامة التحقق
              if (store.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified,
                      size: 16,
                      color: MbuyColors.primaryPurple,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          // اسم المتجر
          SizedBox(
            width: 80,
            child: Text(
              store.name,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: MbuyColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// رقاقة فئة موحدة
class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? MbuyColors.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: MbuyColors.surfaceLight, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: MbuyColors.primaryPurple.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : MbuyColors.primaryPurple,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : MbuyColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// زر بحث موحد
// تم نقل MbuySearchBar إلى ملف منفصل: mbuy_search_bar.dart
