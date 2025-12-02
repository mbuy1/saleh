import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// MbuySectionHeader - عنوان القسم الموحد لجميع الشاشات
/// ═══════════════════════════════════════════════════════════════════════════
///
/// هذا هو المكان المركزي لتصميم عناوين الأقسام في جميع الشاشات
/// مثل "أفضل العروض" أو "الأعلى تقييماً" أو "متاجر مميزة"
///
/// عند الحاجة لتعديل شكل عناوين الأقسام في جميع الشاشات مستقبلاً،
/// يجب تعديلها هنا أولاً.
///
/// الاستخدام:
/// ```dart
/// // بسيط مع عنوان فقط
/// MbuySectionHeader(title: 'أفضل العروض')
///
/// // مع عنوان فرعي
/// MbuySectionHeader(
///   title: 'أفضل العروض',
///   subtitle: 'خصومات تصل إلى 70%',
/// )
///
/// // مع أيقونة
/// MbuySectionHeader(
///   title: 'الأعلى تقييماً',
///   icon: Icons.star_outline,
/// )
///
/// // مع زر "المزيد"
/// MbuySectionHeader(
///   title: 'متاجر مميزة',
///   onViewMore: () => print('عرض المزيد'),
/// )
///
/// // مكتمل
/// MbuySectionHeader(
///   title: 'أفضل العروض',
///   subtitle: 'خصومات تصل إلى 70%',
///   icon: Icons.local_offer_outlined,
///   onViewMore: () {},
/// )
/// ```
///
/// ═══════════════════════════════════════════════════════════════════════════

class MbuySectionHeader extends StatelessWidget {
  /// عنوان القسم (نص رئيسي)
  final String title;

  /// عنوان فرعي اختياري
  final String? subtitle;

  /// أيقونة اختيارية في البداية
  final IconData? icon;

  /// دالة عند الضغط على "المزيد"
  final VoidCallback? onViewMore;

  /// نص زر "المزيد" (افتراضي: "المزيد")
  final String viewMoreText;

  /// لون الأيقونة (افتراضي: textPrimary)
  final Color? iconColor;

  /// حجم الأيقونة (افتراضي: 20)
  final double iconSize;

  /// حجم خط العنوان (افتراضي: 18)
  final double titleFontSize;

  /// وزن خط العنوان (افتراضي: bold)
  final FontWeight titleFontWeight;

  /// لون العنوان (افتراضي: textPrimary)
  final Color? titleColor;

  /// حجم خط العنوان الفرعي (افتراضي: 12)
  final double? subtitleFontSize;

  /// لون العنوان الفرعي (افتراضي: textSecondary)
  final Color? subtitleColor;

  /// حجم خط زر "المزيد" (افتراضي: 12)
  final double viewMoreFontSize;

  /// لون زر "المزيد" (افتراضي: textPrimary)
  final Color? viewMoreColor;

  /// الهوامش الخارجية (افتراضي: 16 من كل جانب، 16 أعلى، 12 أسفل)
  final EdgeInsetsGeometry padding;

  /// لون الخلفية (افتراضي: شفاف)
  final Color? backgroundColor;

  const MbuySectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onViewMore,
    this.viewMoreText = 'المزيد',
    this.iconColor,
    this.iconSize = 20,
    this.titleFontSize = 18,
    this.titleFontWeight = FontWeight.bold,
    this.titleColor,
    this.subtitleFontSize = 12,
    this.subtitleColor,
    this.viewMoreFontSize = 12,
    this.viewMoreColor,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 12),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: padding,
      child: Row(
        children: [
          // الأيقونة (إذا موجودة)
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? MbuyColors.textPrimary,
              size: iconSize,
            ),
            const SizedBox(width: 8),
          ],

          // العنوان والعنوان الفرعي
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: titleFontSize,
                    fontWeight: titleFontWeight,
                    color: titleColor ?? MbuyColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: GoogleFonts.cairo(
                      fontSize: subtitleFontSize,
                      color: subtitleColor ?? MbuyColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // زر "المزيد" (إذا موجود)
          if (onViewMore != null)
            TextButton(
              onPressed: onViewMore,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(60, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewMoreText,
                    style: GoogleFonts.cairo(
                      fontSize: viewMoreFontSize,
                      fontWeight: FontWeight.bold,
                      color: viewMoreColor ?? MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: viewMoreColor ?? MbuyColors.textPrimary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
