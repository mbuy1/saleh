import 'package:flutter/material.dart';

/// بطاقة علامة تجارية
class BrandCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const BrandCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: backgroundColor == Colors.white
              ? Border.all(color: const Color(0xFFE9ECEF))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildTextFallback(),
                )
              : _buildTextFallback(),
        ),
      ),
    );
  }

  Widget _buildTextFallback() {
    return Text(
      name,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Cairo',
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
