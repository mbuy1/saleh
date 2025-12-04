import 'package:flutter/material.dart';

/// بطاقة إحصائيات بتصميم عصري
class StatsCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;
  final IconData? icon;

  const StatsCard({
    super.key,
    required this.value,
    required this.label,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // الأيقونة (اختياري)
          if (icon != null)
            Icon(icon, color: color ?? const Color(0x4000D9B3), size: 24),
          const SizedBox(height: 8),

          // القيمة الرئيسية
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212529),
              fontFamily: 'Cairo',
            ),
          ),

          const SizedBox(height: 4),

          // التسمية
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF495057),
              fontFamily: 'Cairo',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
