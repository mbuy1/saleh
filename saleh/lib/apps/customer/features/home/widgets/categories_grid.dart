import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesGrid extends ConsumerWidget {
  const CategoriesGrid({super.key});

  // TODO: Replace with API data
  static final List<CategoryItem> _categories = [
    CategoryItem(
      id: '1',
      name: 'إلكترونيات',
      icon: Icons.devices,
      color: Colors.blue,
    ),
    CategoryItem(
      id: '2',
      name: 'أزياء',
      icon: Icons.checkroom,
      color: Colors.pink,
    ),
    CategoryItem(
      id: '3',
      name: 'المنزل',
      icon: Icons.home,
      color: Colors.orange,
    ),
    CategoryItem(
      id: '4',
      name: 'الجمال',
      icon: Icons.spa,
      color: Colors.purple,
    ),
    CategoryItem(
      id: '5',
      name: 'الرياضة',
      icon: Icons.sports_soccer,
      color: Colors.green,
    ),
    CategoryItem(
      id: '6',
      name: 'الأطفال',
      icon: Icons.child_care,
      color: Colors.amber,
    ),
    CategoryItem(
      id: '7',
      name: 'الكتب',
      icon: Icons.menu_book,
      color: Colors.brown,
    ),
    CategoryItem(
      id: '8',
      name: 'المزيد',
      icon: Icons.more_horiz,
      color: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'التصنيفات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all categories
                },
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Categories Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(context, _categories[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryItem category) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to category page
        // context.push('/category/${category.id}');
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(category.icon, color: category.color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}
