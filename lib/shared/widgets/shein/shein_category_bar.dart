import 'package:flutter/material.dart';

/// قائمة فئات أفقية SHEIN Style
/// قابلة للتمرير مع خط تحت الفئة المحددة
class SheinCategoryBar extends StatefulWidget {
  final List<String> categories;
  final int initialIndex;
  final ValueChanged<int>? onCategoryChanged;
  final VoidCallback? onMenuTap;

  const SheinCategoryBar({
    super.key,
    required this.categories,
    this.initialIndex = 0,
    this.onCategoryChanged,
    this.onMenuTap,
  });

  @override
  State<SheinCategoryBar> createState() => _SheinCategoryBarState();
}

class _SheinCategoryBarState extends State<SheinCategoryBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // أيقونة القائمة (Hamburger Menu)
          IconButton(
            icon: const Icon(Icons.menu, size: 24),
            color: Colors.white,
            onPressed: widget.onMenuTap ?? () {},
          ),

          // قائمة الفئات القابلة للتمرير
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    widget.onCategoryChanged?.call(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      widget.categories[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
