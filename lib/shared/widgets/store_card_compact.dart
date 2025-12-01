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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                  top: Radius.circular(12),
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
                        size: 40,
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
                children: [
                  Row(
                    children: [
                      // لوجو المتجر
                      Container(
                        width: 36,
                        height: 36,
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
                                size: 20,
                                color: MbuyColors.textTertiary,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: MbuyColors.textPrimary,
                              ),
                            ),
                            if (store.city != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 12,
                                    color: MbuyColors.textSecondary,
                                  ),
                                  const SizedBox(width: 2),
                                  Expanded(
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        store.rating.toStringAsFixed(1),
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'متحقق ✔',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: store.isVerified ? Colors.green : MbuyColors.textSecondary,
                        ),
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
