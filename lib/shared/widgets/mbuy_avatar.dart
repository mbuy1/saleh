import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================================
/// MbuyAvatar - أفاتار موحد للتطبيق
/// ============================================================================

/// حجم الأفاتار
enum MbuyAvatarSize { xs, small, medium, large, xl, profile }

/// مكون أفاتار موحد لتطبيق MBUY
class MbuyAvatar extends StatelessWidget {
  /// رابط الصورة
  final String? imageUrl;

  /// الاسم (للحروف الأولى)
  final String? name;

  /// الأيقونة البديلة
  final IconData? icon;

  /// SVG بديل
  final String? svgPath;

  /// حجم الأفاتار
  final MbuyAvatarSize size;

  /// لون الخلفية
  final Color? backgroundColor;

  /// لون النص/الأيقونة
  final Color? foregroundColor;

  /// شكل دائري أو مربع
  final bool isCircular;

  /// حدود
  final double? borderWidth;
  final Color? borderColor;

  /// عند الضغط
  final VoidCallback? onTap;

  /// شارة (badge) مثل حالة الاتصال
  final Widget? badge;

  const MbuyAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.icon,
    this.svgPath,
    this.size = MbuyAvatarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.isCircular = true,
    this.borderWidth,
    this.borderColor,
    this.onTap,
    this.badge,
  });

  /// أفاتار من صورة
  const MbuyAvatar.image({
    super.key,
    required this.imageUrl,
    this.size = MbuyAvatarSize.medium,
    this.isCircular = true,
    this.borderWidth,
    this.borderColor,
    this.onTap,
    this.badge,
  }) : name = null,
       icon = null,
       svgPath = null,
       backgroundColor = null,
       foregroundColor = null;

  /// أفاتار من الاسم (حروف أولى)
  const MbuyAvatar.initials({
    super.key,
    required this.name,
    this.size = MbuyAvatarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.isCircular = true,
    this.borderWidth,
    this.borderColor,
    this.onTap,
    this.badge,
  }) : imageUrl = null,
       icon = null,
       svgPath = null;

  /// أفاتار من أيقونة
  const MbuyAvatar.icon({
    super.key,
    required this.icon,
    this.size = MbuyAvatarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.isCircular = true,
    this.onTap,
    this.badge,
  }) : imageUrl = null,
       name = null,
       svgPath = null,
       borderWidth = null,
       borderColor = null;

  /// أفاتار متجر
  factory MbuyAvatar.store({
    Key? key,
    String? imageUrl,
    String? name,
    MbuyAvatarSize size = MbuyAvatarSize.medium,
    VoidCallback? onTap,
  }) {
    return MbuyAvatar(
      key: key,
      imageUrl: imageUrl,
      name: name,
      svgPath: AppIcons.store,
      size: size,
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
      foregroundColor: AppTheme.primaryColor,
      isCircular: false,
      onTap: onTap,
    );
  }

  /// أفاتار مستخدم
  factory MbuyAvatar.user({
    Key? key,
    String? imageUrl,
    String? name,
    MbuyAvatarSize size = MbuyAvatarSize.medium,
    VoidCallback? onTap,
    Widget? badge,
  }) {
    return MbuyAvatar(
      key: key,
      imageUrl: imageUrl,
      name: name,
      icon: Icons.person,
      size: size,
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
      foregroundColor: AppTheme.primaryColor,
      onTap: onTap,
      badge: badge,
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = _getSize();
    final radius = isCircular ? avatarSize / 2 : AppDimensions.radiusM;

    Widget avatar = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius),
        border: borderWidth != null
            ? Border.all(
                color: borderColor ?? Colors.white,
                width: borderWidth!,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: _buildContent(),
      ),
    );

    if (badge != null) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(bottom: 0, right: 0, child: badge!),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }

  Widget _buildContent() {
    // صورة
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    return _buildFallback();
  }

  Widget _buildFallback() {
    // حروف أولى
    if (name != null && name!.isNotEmpty) {
      return Center(
        child: Text(
          _getInitials(name!),
          style: TextStyle(
            color: foregroundColor ?? AppTheme.primaryColor,
            fontSize: _getFontSize(),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // SVG
    if (svgPath != null) {
      return Center(
        child: SvgPicture.asset(
          svgPath!,
          width: _getIconSize(),
          height: _getIconSize(),
          colorFilter: ColorFilter.mode(
            foregroundColor ?? AppTheme.primaryColor,
            BlendMode.srcIn,
          ),
        ),
      );
    }

    // أيقونة
    return Center(
      child: Icon(
        icon ?? Icons.person,
        size: _getIconSize(),
        color: foregroundColor ?? AppTheme.primaryColor,
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  double _getSize() {
    switch (size) {
      case MbuyAvatarSize.xs:
        return AppDimensions.avatarXS;
      case MbuyAvatarSize.small:
        return AppDimensions.avatarS;
      case MbuyAvatarSize.medium:
        return AppDimensions.avatarM;
      case MbuyAvatarSize.large:
        return AppDimensions.avatarL;
      case MbuyAvatarSize.xl:
        return AppDimensions.avatarXL;
      case MbuyAvatarSize.profile:
        return AppDimensions.avatarProfile;
    }
  }

  double _getIconSize() {
    switch (size) {
      case MbuyAvatarSize.xs:
        return AppDimensions.iconXS;
      case MbuyAvatarSize.small:
        return AppDimensions.iconS;
      case MbuyAvatarSize.medium:
        return AppDimensions.iconM;
      case MbuyAvatarSize.large:
        return AppDimensions.iconL;
      case MbuyAvatarSize.xl:
        return AppDimensions.iconXL;
      case MbuyAvatarSize.profile:
        return AppDimensions.iconXXL;
    }
  }

  double _getFontSize() {
    switch (size) {
      case MbuyAvatarSize.xs:
        return AppDimensions.fontCaption;
      case MbuyAvatarSize.small:
        return AppDimensions.fontLabel;
      case MbuyAvatarSize.medium:
        return AppDimensions.fontBody;
      case MbuyAvatarSize.large:
        return AppDimensions.fontTitle;
      case MbuyAvatarSize.xl:
        return AppDimensions.fontHeadline;
      case MbuyAvatarSize.profile:
        return AppDimensions.fontDisplay3;
    }
  }
}

/// شارة حالة الاتصال
class MbuyOnlineBadge extends StatelessWidget {
  final bool isOnline;
  final double size;

  const MbuyOnlineBadge({super.key, this.isOnline = true, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? AppTheme.successColor : AppTheme.textHintColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
