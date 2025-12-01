import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// مكونات UI مشتركة بأسلوب Meta AI × mBuy Purple
class MbuyWidgets {
  /// شريط بحث Pill بتصميم Meta AI
  static Widget searchBar({
    required String hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: MbuyColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        textDirection: TextDirection.rtl,
        style: GoogleFonts.cairo(fontSize: 14, color: MbuyColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.cairo(
            fontSize: 14,
            color: MbuyColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 26,
            color: MbuyColors.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  /// Filter Chip بتصميم mBuy
  static Widget filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? MbuyColors.primaryPurple : Colors.white,
          border: isSelected ? null : Border.all(color: MbuyColors.borderLight),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : MbuyColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  /// بطاقة منتج بتصميم Meta AI
  static Widget productCard({
    required BuildContext context,
    required String imageUrl,
    required String name,
    required double price,
    double? rating,
    int? ratingCount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            // الصورة
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: MbuyColors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 48,
                    color: MbuyColors.textTertiary,
                  ),
                ),
              ),
            ),
            // المحتوى
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنتج
                  Text(
                    name,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: MbuyColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // التقييم
                  if (rating != null)
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            size: 14,
                            color: const Color(0xFFFFA940),
                          );
                        }),
                        if (ratingCount != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '($ratingCount)',
                            style: GoogleFonts.cairo(
                              fontSize: 11,
                              color: MbuyColors.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 8),
                  // السعر
                  Row(
                    children: [
                      Text(
                        price.toStringAsFixed(0),
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MbuyColors.primaryPurple,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ر.س',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: MbuyColors.primaryPurple,
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

  /// بطاقة إحصائيات (للتاجر) بتصميم Meta AI
  static Widget statCard({
    required IconData icon,
    required String value,
    required String label,
    String? trend,
    bool? isTrendPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: MbuyColors.subtleGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MbuyColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الأيقونة
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: MbuyColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          // الرقم
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: MbuyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          // النص
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: MbuyColors.textSecondary,
                  ),
                ),
              ),
              // الاتجاه
              if (trend != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isTrendPositive == true
                        ? MbuyColors.successLight
                        : MbuyColors.errorLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTrendPositive == true
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 12,
                        color: isTrendPositive == true
                            ? MbuyColors.success
                            : MbuyColors.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isTrendPositive == true
                              ? MbuyColors.success
                              : MbuyColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// زر أساسي بتصميم mBuy
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double? width,
  }) {
    return Container(
      width: width,
      height: 48,
      decoration: BoxDecoration(
        gradient: MbuyColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: MbuyColors.primaryPurple.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  /// زر ثانوي
  static Widget secondaryButton({
    required String text,
    required VoidCallback onPressed,
    double? width,
  }) {
    return Container(
      width: width,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: MbuyColors.primaryPurple, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: MbuyColors.primaryPurple,
          ),
        ),
      ),
    );
  }

  /// عنوان صفحة بتصميم Meta AI
  static Widget pageTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: MbuyColors.textPrimary,
      ),
    );
  }

  /// عنوان قسم
  static Widget sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: MbuyColors.textPrimary,
      ),
    );
  }
}
