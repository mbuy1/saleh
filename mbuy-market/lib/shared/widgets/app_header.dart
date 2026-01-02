import 'package:flutter/material.dart';

/// App Header - MBUY Style (Primary Color Header)
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  // اللون الرئيسي للتطبيق
  static const Color primaryColor = Color(0xFF372018);

  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: SafeArea(bottom: false, child: _buildTopRow(context)),
    );
  }

  /// Top Row: Logo, Search Bar, Icons
  Widget _buildTopRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // Logo
          const Text(
            'MBUY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 12),
          // Search Bar
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to search
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.grey.shade400, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'البحث',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey.shade500,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // AI Assistant Icon
          const Icon(Icons.support_agent, color: Colors.white, size: 24),
          const SizedBox(width: 16),
          // Bell Icon with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24,
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '9+',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Heart Icon
          const Icon(Icons.favorite_outline, color: Colors.white, size: 24),
        ],
      ),
    );
  }
}
