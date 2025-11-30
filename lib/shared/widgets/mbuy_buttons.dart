import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// زر أساسي يستخدم الجراديانت (من الأزرق إلى الموف)
class MbuyPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const MbuyPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed != null && !isLoading
            ? MbuyColors.primaryGradient
            : null,
        color: onPressed == null || isLoading
            ? MbuyColors.textTertiary.withValues(alpha: 0.2)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Arabic',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// زر ثانوي بحواف دائرية وحد خفيف
class MbuySecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const MbuySecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: onPressed != null
              ? MbuyColors.primaryBlue
              : MbuyColors.surfaceLight,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        MbuyColors.primaryBlue,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: onPressed != null
                              ? MbuyColors.primaryBlue
                              : MbuyColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: onPressed != null
                              ? MbuyColors.primaryBlue
                              : MbuyColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Arabic',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// زر Ghost مع حافة جراديانت
class MbuyGhostButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const MbuyGhostButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 2,
            color: Colors.transparent,
          ),
          gradient: onPressed != null
              ? LinearGradient(
                  colors: [MbuyColors.primaryBlue, MbuyColors.primaryPurple],
                )
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: MbuyColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                alignment: Alignment.center,
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            MbuyColors.primaryBlue,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(
                              icon,
                              color: onPressed != null
                                  ? MbuyColors.primaryBlue
                                  : MbuyColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            text,
                            style: TextStyle(
                              color: onPressed != null
                                  ? MbuyColors.primaryBlue
                                  : MbuyColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Arabic',
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

