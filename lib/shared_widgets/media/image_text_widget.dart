import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Widget لعرض صورة مع نص
/// يستخدم في:
/// - الفئات
/// - البانرات الترويجية
/// - العروض الخاصة
/// - أي مكان يحتاج عرض صورة + نص
class ImageTextWidget extends StatelessWidget {
  /// رابط الصورة أو مسار محلي
  final String imageUrl;

  /// النص الرئيسي
  final String title;

  /// النص الفرعي (اختياري)
  final String? subtitle;

  /// عند الضغط
  final VoidCallback? onTap;

  /// عرض الـ Widget
  final double? width;

  /// ارتفاع الـ Widget
  final double? height;

  /// نوع عرض الصورة
  final BoxFit imageFit;

  /// موضع النص
  final ImageTextPosition textPosition;

  /// لون خلفية النص
  final Color? textBackgroundColor;

  /// تدوير الزوايا
  final double borderRadius;

  const ImageTextWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.onTap,
    this.width,
    this.height,
    this.imageFit = BoxFit.cover,
    this.textPosition = ImageTextPosition.bottom,
    this.textBackgroundColor,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              // الصورة
              Positioned.fill(
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        fit: imageFit,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    : Image.asset(
                        imageUrl,
                        fit: imageFit,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      ),
              ),

              // النص
              _buildTextOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextOverlay() {
    Widget textContent = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: textPosition == ImageTextPosition.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
            ),
            textAlign: textPosition == ImageTextPosition.center
                ? TextAlign.center
                : TextAlign.start,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
              ),
              textAlign: textPosition == ImageTextPosition.center
                  ? TextAlign.center
                  : TextAlign.start,
            ),
          ],
        ],
      ),
    );

    // إضافة خلفية للنص إذا تم تحديدها
    if (textBackgroundColor != null) {
      textContent = Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: textBackgroundColor!.withValues(alpha: 0.8),
          borderRadius: textPosition == ImageTextPosition.bottom
              ? const BorderRadius.vertical(bottom: Radius.circular(12))
              : textPosition == ImageTextPosition.top
              ? const BorderRadius.vertical(top: Radius.circular(12))
              : null,
        ),
        child: textContent,
      );
    }

    // تحديد موضع النص
    switch (textPosition) {
      case ImageTextPosition.top:
        return Positioned(top: 0, left: 0, right: 0, child: textContent);
      case ImageTextPosition.bottom:
        return Positioned(bottom: 0, left: 0, right: 0, child: textContent);
      case ImageTextPosition.center:
        return Center(child: textContent);
    }
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

/// موضع النص بالنسبة للصورة
enum ImageTextPosition {
  /// في الأعلى
  top,

  /// في المنتصف
  center,

  /// في الأسفل
  bottom,
}

/// بطاقة فئة مع صورة ونص
/// متخصصة لعرض الفئات
class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String? categoryImage;
  final IconData? categoryIcon;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const CategoryCard({
    super.key,
    required this.categoryName,
    this.categoryImage,
    this.categoryIcon,
    this.onTap,
    this.backgroundColor = MbuyColors.primaryMaroon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 120,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الأيقونة أو الصورة
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: categoryImage != null
                  ? ClipOval(
                      child: Image.network(
                        categoryImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          categoryIcon ?? Icons.category,
                          color: backgroundColor,
                          size: 32,
                        ),
                      ),
                    )
                  : Icon(
                      categoryIcon ?? Icons.category,
                      color: backgroundColor,
                      size: 32,
                    ),
            ),

            const SizedBox(height: 8),

            // اسم الفئة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                categoryName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MbuyColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بانر ترويجي مع صورة ونص
class PromotionalBanner extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final double height;

  const PromotionalBanner({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.onTap,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return ImageTextWidget(
      imageUrl: imageUrl,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      height: height,
      textPosition: ImageTextPosition.center,
      textBackgroundColor: Colors.black.withValues(alpha: 0.3),
      borderRadius: 16,
    );
  }
}
