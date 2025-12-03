import 'package:flutter/material.dart';

/// شريط بحث SHEIN Style
/// يحتوي على أيقونات: كاميرا، حقيبة، بريد، قلب، بحث
class SheinSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onBagTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onHeartTap;
  final int? bagBadgeCount;
  final bool? hasMessageNotification;

  const SheinSearchBar({
    super.key,
    this.hintText = 'البحث',
    this.onSearchTap,
    this.onCameraTap,
    this.onBagTap,
    this.onMessageTap,
    this.onHeartTap,
    this.bagBadgeCount,
    this.hasMessageNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // أيقونة الكاميرا
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, size: 24),
            color: Colors.black87,
            onPressed: onCameraTap ?? () {},
          ),
          const SizedBox(width: 4),
          
          // أيقونة الحقيبة مع Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, size: 24),
                color: Colors.black87,
                onPressed: onBagTap ?? () {},
              ),
              if (bagBadgeCount != null && bagBadgeCount! > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      bagBadgeCount! > 9 ? '9+' : bagBadgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
          
          // أيقونة البريد مع Notification Dot
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.mail_outline, size: 24),
                color: Colors.black87,
                onPressed: onMessageTap ?? () {},
              ),
              if (hasMessageNotification == true)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
          
          // أيقونة القلب
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 24),
            color: Colors.black87,
            onPressed: onHeartTap ?? () {},
          ),
          const SizedBox(width: 4),
          
          // أيقونة البحث
          IconButton(
            icon: const Icon(Icons.search, size: 24),
            color: Colors.black87,
            onPressed: onSearchTap ?? () {},
          ),
          const SizedBox(width: 8),
          
          // شريط البحث
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerRight,
                child: Text(
                  hintText,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

