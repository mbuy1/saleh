import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/data.dart';
import '../../models/models.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(error.toString(), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(categoriesProvider);
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                const Text('لا توجد أقسام'),
              ],
            ),
          );
        }

        // Reset index if out of bounds
        if (_selectedCategoryIndex >= categories.length) {
          _selectedCategoryIndex = 0;
        }

        return _buildCategoriesView(categories);
      },
    );
  }

  Widget _buildCategoriesView(List<Category> categories) {
    return Row(
      children: [
        // Categories List (Left Side)
        Container(
          width: 100,
          color: Colors.grey[100],
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = index == _selectedCategoryIndex;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategoryIndex = index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border(
                      right: BorderSide(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getCategoryIcon(category.name),
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[600],
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Subcategories Grid (Right Side)
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categories[_selectedCategoryIndex].name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child:
                      categories[_selectedCategoryIndex].subcategories.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 48,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'لا توجد أقسام فرعية',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: categories[_selectedCategoryIndex]
                              .subcategories
                              .length,
                          itemBuilder: (context, index) {
                            final subcategory =
                                categories[_selectedCategoryIndex]
                                    .subcategories[index];
                            return _buildSubcategoryItem(subcategory);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    // Map category names to icons
    final iconMap = {
      'إلكترونيات': Icons.devices,
      'أزياء رجالية': Icons.man,
      'أزياء نسائية': Icons.woman,
      'المنزل والحديقة': Icons.home,
      'الجمال والعناية': Icons.spa,
      'الرياضة': Icons.sports_soccer,
      'أطفال': Icons.child_care,
      'طعام': Icons.restaurant,
      'سيارات': Icons.directions_car,
      'كتب': Icons.book,
    };

    return iconMap[categoryName] ?? Icons.category;
  }

  Widget _buildSubcategoryItem(Category subcategory) {
    return GestureDetector(
      onTap: () {
        context.push('/category/${subcategory.id}');
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: subcategory.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        subcategory.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              _getCategoryIcon(subcategory.name),
                              color: Colors.grey,
                              size: 32,
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(
                        _getCategoryIcon(subcategory.name),
                        color: Colors.grey[600],
                        size: 32,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subcategory.name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
