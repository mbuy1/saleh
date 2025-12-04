import 'package:flutter/material.dart';

/// Hero Section عصري مع أيقونة دائرية مركزية
class ModernHeroSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final double height;

  const ModernHeroSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor = const Color(0xFF00D9B3),
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFFF8F9FA), Colors.white],
        ),
      ),
      child: Stack(
        children: [
          // المحتوى النصي
          Positioned(
            top: 30,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF212529),
                    fontFamily: 'Cairo',
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6C757D),
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // الأيقونة الدائرية المركزية
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
