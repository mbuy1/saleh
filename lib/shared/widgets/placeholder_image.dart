import 'package:flutter/material.dart';

/// Widget لعرض صورة افتراضية محلية بدلاً من استخدام via.placeholder.com
/// يستخدم عندما لا تتوفر صورة أو في حالة الخطأ
class PlaceholderImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final IconData icon;
  final Color? backgroundColor;
  final Color? textColor;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const PlaceholderImage({
    super.key,
    this.width,
    this.height,
    this.text = '',
    this.icon = Icons.image,
    this.backgroundColor,
    this.textColor,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  /// Placeholder دائري (للأفاتار)
  factory PlaceholderImage.circular({
    required double radius,
    String text = '',
    IconData icon = Icons.person,
    Color? backgroundColor,
  }) {
    return PlaceholderImage(
      width: radius * 2,
      height: radius * 2,
      text: text,
      icon: icon,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.grey[300]!;
    final txtColor = textColor ?? Colors.grey[600]!;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: bgColor, borderRadius: borderRadius),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: (width != null && width! < 100) ? 24 : 48,
              color: txtColor,
            ),
            if (text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  text,
                  style: TextStyle(
                    color: txtColor,
                    fontSize: (width != null && width! < 100) ? 10 : 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget محسّن لتحميل الصور مع معالجة الأخطاء
class CachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String placeholderText;
  final IconData placeholderIcon;
  final Color? placeholderBackgroundColor;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderText = '',
    this.placeholderIcon = Icons.image,
    this.placeholderBackgroundColor,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // إذا لم يكن هناك URL للصورة، عرض placeholder
    if (imageUrl == null || imageUrl!.isEmpty) {
      return errorWidget ??
          PlaceholderImage(
            width: width,
            height: height,
            text: placeholderText,
            icon: placeholderIcon,
            backgroundColor: placeholderBackgroundColor,
            borderRadius: borderRadius,
            fit: fit,
          );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          // عرض placeholder أثناء التحميل
          return placeholder ??
              PlaceholderImage(
                width: width,
                height: height,
                text: placeholderText,
                icon: placeholderIcon,
                backgroundColor: placeholderBackgroundColor,
                borderRadius: borderRadius,
                fit: fit,
              );
        },
        errorBuilder: (context, error, stackTrace) {
          // عرض placeholder في حالة الخطأ
          return errorWidget ??
              PlaceholderImage(
                width: width,
                height: height,
                text: placeholderText.isEmpty
                    ? 'فشل تحميل الصورة'
                    : placeholderText,
                icon: Icons.broken_image,
                backgroundColor: placeholderBackgroundColor,
                borderRadius: borderRadius,
                fit: fit,
              );
        },
      ),
    );
  }
}
