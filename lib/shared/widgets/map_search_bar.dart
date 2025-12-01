import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'profile_button.dart';

/// شريط البحث لصفحة الخريطة - تصميم مشابه لـ Google Maps
class MapSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String hintText;

  const MapSearchBar({super.key, this.onTap, this.hintText = 'ابحث هنا'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            // أيقونة الحساب الشخصي على اليمين
            const ProfileButton(),
            const SizedBox(width: 12),
            // نص البحث
            Expanded(
              child: Text(
                hintText,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  color: MbuyColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // أيقونة البحث على اليسار
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: MbuyColors.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                color: MbuyColors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

/// شريط الفئات لصفحة الخريطة - نمط Google Maps
class MapCategoriesBar extends StatefulWidget {
  const MapCategoriesBar({super.key});

  @override
  State<MapCategoriesBar> createState() => _MapCategoriesBarState();
}

class _MapCategoriesBarState extends State<MapCategoriesBar> {
  String? _selectedCategory;

  final List<MapCategory> _categories = [
    MapCategory('المنزل', Icons.home_outlined),
    MapCategory('المطاعم', Icons.restaurant_outlined),
    MapCategory('المقاهي', Icons.local_cafe_outlined),
    MapCategory('البقالة', Icons.shopping_basket_outlined),
    MapCategory('المتاجر', Icons.store_outlined),
    MapCategory('الترفيه', Icons.movie_outlined),
    MapCategory('الصحة', Icons.local_hospital_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category.name;
          return _buildCategoryChip(category, isSelected);
        },
      ),
    );
  }

  Widget _buildCategoryChip(MapCategory category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = isSelected ? null : category.name;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? MbuyColors.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: isSelected
                ? MbuyColors.primaryPurple
                : Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 18,
              color: isSelected ? Colors.white : MbuyColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              category.name,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : MbuyColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapCategory {
  final String name;
  final IconData icon;

  MapCategory(this.name, this.icon);
}
