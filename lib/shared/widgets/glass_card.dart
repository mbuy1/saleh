import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_dimensions.dart';

/// ╔═══════════════════════════════════════════════════════════════════════════╗
/// ║                    🔮 Glass Card - البطاقة الزجاجية                        ║
/// ║                                                                           ║
/// ║   مكون موحد للبطاقات بتأثير الزجاج (Glassmorphism)                        ║
/// ║   مستوحى من تصميم بطاقات الأسعار الحديثة                                  ║
/// ║                                                                           ║
/// ║   الاستخدام:                                                              ║
/// ║   GlassCard(child: YourContent())                                        ║
/// ║   GlassCard.withIcon(icon: Icons.star, child: YourContent())            ║
/// ║                                                                           ║
/// ╚═══════════════════════════════════════════════════════════════════════════╝

/// ثوابت تصميم البطاقة الزجاجية
class GlassCardStyle {
  GlassCardStyle._();

  // ============================================================================
  // ألوان الزجاج - أسلوب البار السفلي (Light Glass)
  // ============================================================================

  /// لون الخلفية الأساسي - أبيض نظيف مثل البار السفلي
  static Color backgroundColor = Colors.white;

  /// لون الخلفية شبه شفاف للتأثير الزجاجي
  static Color backgroundColorGlass = Colors.white.withValues(alpha: 0.95);

  /// لون الخلفية للوضع الداكن
  static Color backgroundColorDark = Colors.white.withValues(alpha: 0.12);

  /// لون الحدود - شفاف جداً
  static Color borderColor = Colors.grey.withValues(alpha: 0.1);

  /// لون الحدود للوضع الداكن
  static Color borderColorDark = Colors.white.withValues(alpha: 0.1);

  /// لون التوهج الداخلي
  static Color innerGlowColor = Colors.white.withValues(alpha: 0.05);

  // ============================================================================
  // تأثير الضبابية (Blur)
  // ============================================================================

  /// قوة الضبابية الخفيفة
  static const double blurLight = 10.0;

  /// قوة الضبابية المتوسطة
  static const double blurMedium = 15.0;

  /// قوة الضبابية القوية
  static const double blurHeavy = 25.0;

  // ============================================================================
  // نصف قطر الحواف
  // ============================================================================

  /// حواف صغيرة
  static const double radiusSmall = 12.0;

  /// حواف متوسطة
  static const double radiusMedium = 16.0;

  /// حواف كبيرة
  static const double radiusLarge = 20.0;

  /// حواف كبيرة جداً
  static const double radiusXLarge = 24.0;

  // ============================================================================
  // الظلال - مثل البار السفلي
  // ============================================================================

  /// ظل خفيف - مثل البار السفلي
  static List<BoxShadow> shadowLight = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  /// ظل متوسط
  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 15,
      offset: const Offset(0, 4),
    ),
  ];

  /// ظل للأيقونات ثلاثية الأبعاد
  static List<BoxShadow> icon3DShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // ============================================================================
  // التدرجات
  // ============================================================================

  /// تدرج الزجاج الأساسي - أبيض نظيف
  static LinearGradient glassGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color(0xFFFAFAFA)],
  );

  /// تدرج الزجاج الداكن
  static LinearGradient glassGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withValues(alpha: 0.1),
      Colors.white.withValues(alpha: 0.02),
    ],
  );

  /// تدرج أيقونة 3D
  static LinearGradient icon3DGradient(Color baseColor) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [baseColor, Color.lerp(baseColor, Colors.black, 0.3)!],
  );
}

/// البطاقة الزجاجية - مكون قابل لإعادة الاستخدام
class GlassCard extends StatelessWidget {
  /// المحتوى الداخلي
  final Widget child;

  /// الحشو الداخلي
  final EdgeInsetsGeometry? padding;

  /// الهامش الخارجي
  final EdgeInsetsGeometry? margin;

  /// نصف قطر الحواف
  final double borderRadius;

  /// قوة الضبابية
  final double blurAmount;

  /// لون الخلفية المخصص
  final Color? backgroundColor;

  /// لون الحدود المخصص
  final Color? borderColor;

  /// عرض الحدود
  final double borderWidth;

  /// الظلال
  final List<BoxShadow>? shadows;

  /// ارتفاع البطاقة (اختياري)
  final double? height;

  /// عرض البطاقة (اختياري)
  final double? width;

  /// عند الضغط
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = GlassCardStyle.radiusMedium,
    this.blurAmount = GlassCardStyle.blurMedium,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.shadows,
    this.height,
    this.width,
    this.onTap,
  });

  /// بطاقة زجاجية مع أيقونة 3D في الأعلى
  static Widget withIcon({
    Key? key,
    required IconData icon,
    required Widget child,
    Color iconColor = Colors.white,
    Color iconBackgroundColor = Colors.blue,
    double iconSize = 28,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = GlassCardStyle.radiusMedium,
    double blurAmount = GlassCardStyle.blurMedium,
    VoidCallback? onTap,
  }) {
    return _GlassCardWithIcon(
      key: key,
      icon: icon,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      iconSize: iconSize,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      blurAmount: blurAmount,
      onTap: onTap,
      child: child,
    );
  }

  /// بطاقة زجاجية مع أيقونة SVG في الأعلى
  static Widget withSvgIcon({
    Key? key,
    required String iconPath,
    required Widget child,
    Color iconColor = Colors.white,
    Color iconBackgroundColor = Colors.blue,
    double iconSize = 28,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = GlassCardStyle.radiusMedium,
    double blurAmount = GlassCardStyle.blurMedium,
    VoidCallback? onTap,
  }) {
    return _GlassCardWithSvgIcon(
      key: key,
      iconPath: iconPath,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      iconSize: iconSize,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      blurAmount: blurAmount,
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: height,
      width: width,
      padding: padding ?? AppDimensions.paddingM,
      decoration: BoxDecoration(
        color: backgroundColor ?? GlassCardStyle.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? GlassCardStyle.borderColor,
          width: borderWidth,
        ),
        boxShadow: shadows ?? GlassCardStyle.shadowLight,
      ),
      child: child,
    );

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: onTap != null
            ? GestureDetector(onTap: onTap, child: card)
            : card,
      );
    }

    return onTap != null ? GestureDetector(onTap: onTap, child: card) : card;
  }
}

/// بطاقة زجاجية مع أيقونة مدمجة (مرسومة على البطاقة)
class _GlassCardWithIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final double iconSize;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurAmount;
  final VoidCallback? onTap;

  const _GlassCardWithIcon({
    super.key,
    required this.icon,
    required this.child,
    this.iconColor = Colors.white,
    this.iconBackgroundColor = Colors.blue,
    this.iconSize = 28,
    this.padding,
    this.margin,
    this.borderRadius = GlassCardStyle.radiusMedium,
    this.blurAmount = GlassCardStyle.blurMedium,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      margin: margin,
      borderRadius: borderRadius,
      blurAmount: blurAmount,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الأيقونة المدمجة مع البطاقة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  iconBackgroundColor.withValues(alpha: 0.15),
                  iconBackgroundColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            child: Icon(icon, color: iconBackgroundColor, size: iconSize + 8),
          ),
          // المحتوى
          Padding(padding: padding ?? const EdgeInsets.all(12), child: child),
        ],
      ),
    );
  }
}

/// بطاقة زجاجية مع أيقونة SVG مدمجة (مرسومة على البطاقة)
class _GlassCardWithSvgIcon extends StatelessWidget {
  final String iconPath;
  final Color iconColor;
  final Color iconBackgroundColor;
  final double iconSize;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurAmount;
  final VoidCallback? onTap;

  const _GlassCardWithSvgIcon({
    super.key,
    required this.iconPath,
    required this.child,
    this.iconColor = Colors.white,
    this.iconBackgroundColor = Colors.blue,
    this.iconSize = 28,
    this.padding,
    this.margin,
    this.borderRadius = GlassCardStyle.radiusMedium,
    this.blurAmount = GlassCardStyle.blurMedium,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      margin: margin,
      borderRadius: borderRadius,
      blurAmount: blurAmount,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الأيقونة المدمجة مع البطاقة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  iconBackgroundColor.withValues(alpha: 0.15),
                  iconBackgroundColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: iconSize + 8,
              height: iconSize + 8,
              colorFilter: ColorFilter.mode(
                iconBackgroundColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          // المحتوى
          Padding(padding: padding ?? const EdgeInsets.all(12), child: child),
        ],
      ),
    );
  }
}

/// أيقونة ثلاثية الأبعاد
class Icon3D extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final double size;
  final double containerSize;

  const Icon3D({
    super.key,
    required this.icon,
    this.color = Colors.white,
    this.backgroundColor = Colors.blue,
    this.size = 28,
    this.containerSize = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        gradient: GlassCardStyle.icon3DGradient(backgroundColor),
        borderRadius: BorderRadius.circular(containerSize / 3),
        boxShadow: GlassCardStyle.icon3DShadow,
      ),
      child: Stack(
        children: [
          // طبقة التوهج العلوي
          Positioned(
            top: 2,
            left: 4,
            right: 4,
            child: Container(
              height: containerSize * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(containerSize / 3),
                  topRight: Radius.circular(containerSize / 3),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.4),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // الأيقونة
          Center(
            child: Icon(icon, color: color, size: size),
          ),
        ],
      ),
    );
  }
}

/// بطاقة إحصائية زجاجية
class GlassStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const GlassStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = Colors.blue,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: AppDimensions.paddingM,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon3D(
            icon: icon,
            backgroundColor: iconColor,
            size: 24,
            containerSize: 48,
          ),
          const SizedBox(height: AppDimensions.spacing12),
          Text(
            value,
            style: TextStyle(
              fontSize: AppDimensions.fontDisplay2,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            title,
            style: TextStyle(
              fontSize: AppDimensions.fontLabel,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// بطاقة سعر زجاجية (مثل الصورة المرجعية)
class GlassPriceCard extends StatelessWidget {
  final String price;
  final String? oldPrice;
  final String? label;
  final String? subtitle;
  final Color accentColor;
  final VoidCallback? onTap;

  const GlassPriceCard({
    super.key,
    required this.price,
    this.oldPrice,
    this.label,
    this.subtitle,
    this.accentColor = Colors.cyan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      borderRadius: GlassCardStyle.radiusLarge,
      padding: AppDimensions.paddingL,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label!,
                style: TextStyle(
                  color: accentColor,
                  fontSize: AppDimensions.fontLabel,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
          ],
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: AppDimensions.fontHero,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              if (oldPrice != null) ...[
                const SizedBox(width: AppDimensions.spacing8),
                Text(
                  oldPrice!,
                  style: TextStyle(
                    fontSize: AppDimensions.fontTitle,
                    color: Colors.white.withValues(alpha: 0.5),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: AppDimensions.fontBody2,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
