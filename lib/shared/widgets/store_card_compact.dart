import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/data/models.dart';

/// بطاقة متجر مدمجة للاستخدام في القوائم الأفقية
class StoreCardCompact extends StatelessWidget {
  final Store store;
  final VoidCallback? onTap;
  final double width;

  const StoreCardCompact({
    super.key,
    required this.store,
    this.onTap,
    this.width = 160,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MbuyColors.borderLight, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المتجر/الغلاف
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: MbuyColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image: store.coverUrl != null
                    ? DecorationImage(
                        image: NetworkImage(store.coverUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: store.coverUrl == null
                  ? Center(
                      child: Icon(
                        Icons.store,
                        size: 36,
                        color: MbuyColors.textTertiary.withValues(alpha: 0.3),
                      ),
                    )
                  : null,
            ),
            // معلومات المتجر
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // لوجو المتجر
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: MbuyColors.borderLight,
                            width: 2,
                          ),
                          image: store.logoUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(store.logoUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: store.logoUrl == null
                            ? const Icon(
                                Icons.store,
                                size: 18,
                                color: MbuyColors.textTertiary,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              store.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                fontSize: 15,
                                fontWeight: FontWeight.w700, // خط سميك
                                color: MbuyColors.textPrimary,
                                height: 1.2,
                              ),
                            ),
                            if (store.city != null) ...[
                              const SizedBox(height: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 12,
                                    color: MbuyColors.textSecondary,
                                  ),
                                  const SizedBox(width: 2),
                                  Flexible(
                                    child: Text(
                                      store.city!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.cairo(
                                        fontSize: 11,
                                        color: MbuyColors.textSecondary,
                                      ),
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // تقييم بارز باللون الثانوي (ذهبي)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: MbuyColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: MbuyColors.secondary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              store.rating.toStringAsFixed(1),
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (store.isVerified)
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: MbuyColors.success,
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
