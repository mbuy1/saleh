import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

/// موديل الفئة الرئيسية
class MainCategory {
  final String id;
  final String name;
  final IconData icon;
  final List<SubCategory> subCategories;

  MainCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.subCategories,
  });
}

/// موديل الفئة الفرعية
class SubCategory {
  final String id;
  final String name;
  final IconData icon;

  SubCategory({required this.id, required this.name, required this.icon});
}

/// صفحة عرض الفئات بتصميم جديد
/// شريط عامودي على اليمين + grid على اليسار
class CategoryBrowserView extends StatefulWidget {
  final List<MainCategory> mainCategories;
  final VoidCallback? onViewAllCategories;

  const CategoryBrowserView({
    super.key,
    required this.mainCategories,
    this.onViewAllCategories,
  });

  @override
  State<CategoryBrowserView> createState() => _CategoryBrowserViewState();
}

class _CategoryBrowserViewState extends State<CategoryBrowserView> {
  int _selectedMainCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // شريط البحث في الأعلى
        _buildSearchBar(),

        // المحتوى الرئيسي: شريط عامودي + grid
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الشريط العامودي على اليمين (الفئات الرئيسية)
              _buildMainCategoriesSidebar(),

              // Grid الفئات الفرعية على اليسار
              Expanded(child: _buildSubCategoriesGrid()),
            ],
          ),
        ),
      ],
    );
  }

  /// شريط البحث في الأعلى
  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: MbuyColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MbuyColors.borderLight),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(Icons.search, color: MbuyColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'ابحث عن فئة...',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: MbuyColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// الشريط العامودي على اليمين (الفئات الرئيسية)
  Widget _buildMainCategoriesSidebar() {
    return Container(
      width: 110,
      color: MbuyColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: widget.mainCategories.length,
        itemBuilder: (context, index) {
          final category = widget.mainCategories[index];
          final isSelected = index == _selectedMainCategoryIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMainCategoryIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? MbuyColors.textPrimary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    color: isSelected
                        ? MbuyColors.textPrimary
                        : MbuyColors.textSecondary,
                    size: 24,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? MbuyColors.textPrimary
                          : MbuyColors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Grid الفئات الفرعية على اليسار
  Widget _buildSubCategoriesGrid() {
    final selectedCategory = widget.mainCategories[_selectedMainCategoryIndex];

    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // الثلاث أيقونات الثابتة
          _buildFixedActionsRow(),

          const SizedBox(height: 20),

          // عنوان الفئات الفرعية
          Text(
            'الفئات الفرعية',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          // Grid الفئات الفرعية
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: selectedCategory.subCategories.length,
            itemBuilder: (context, index) {
              final subCategory = selectedCategory.subCategories[index];
              return _buildSubCategoryCard(subCategory);
            },
          ),
        ],
      ),
    );
  }

  /// الثلاث أيقونات الثابتة في الأعلى
  Widget _buildFixedActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.grid_view_rounded,
            label: 'مشاهدة الكل',
            onTap: widget.onViewAllCategories ?? () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.new_releases_outlined,
            label: 'الجديد',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.star_outline,
            label: 'أعلى تصنيفاً',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  /// بطاقة الإجراء الثابت
  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: MbuyColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MbuyColors.borderLight),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: MbuyColors.textPrimary, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: MbuyColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// بطاقة الفئة الفرعية
  Widget _buildSubCategoryCard(SubCategory subCategory) {
    return GestureDetector(
      onTap: () {
        // الانتقال لصفحة المنتجات الخاصة بهذه الفئة
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MbuyColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: MbuyColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                subCategory.icon,
                color: MbuyColors.textPrimary,
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                subCategory.name,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: MbuyColors.textPrimary,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
