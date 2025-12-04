import 'package:flutter/material.dart';

/// Button مع دعم Accessibility
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? semanticHint;
  final bool isEnabled;

  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticLabel,
    this.semanticHint,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      enabled: isEnabled,
      child: child,
    );
  }
}

/// IconButton مع دعم Accessibility
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final String? semanticHint;
  final Color? color;

  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.semanticHint,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      enabled: onPressed != null,
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}

/// Card مع دعم Accessibility
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const AccessibleCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      margin: margin,
      child: padding != null
          ? Padding(padding: padding!, child: child)
          : child,
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        child: card,
      );
    }

    if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        button: onTap != null,
        child: card,
      );
    }

    return card;
  }
}

/// Text مع دعم Accessibility
class AccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final String? semanticLabel;

  const AccessibleText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }
}

/// Image مع دعم Accessibility
class AccessibleImage extends StatelessWidget {
  final String? imageUrl;
  final String semanticLabel;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AccessibleImage({
    super.key,
    this.imageUrl,
    required this.semanticLabel,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (imageUrl == null || imageUrl!.isEmpty) {
      image = errorWidget ?? const Icon(Icons.image);
    } else {
      image = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? const CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? const Icon(Icons.broken_image);
        },
      );
    }

    return Semantics(
      label: semanticLabel,
      image: true,
      child: image,
    );
  }
}

