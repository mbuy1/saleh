import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/data/dummy_data.dart';
import '../../features/customer/presentation/screens/categories_screen.dart';

/// شريط الفئات الأفقي - يظهر في الصفحة الرئيسية وصفحة المتاجر
class CategoriesBar extends StatelessWidget {
  final String? selectedCategoryId;
  final Function(String)? onCategorySelected;

  const CategoriesBar({
    super.key,
    this.selectedCategoryId,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriesScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'جميع الفئات',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_back_ios,
                    size: 14,
                    color: MbuyColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: DummyData.mainCategories.length,
            itemBuilder: (context, index) {
              final category = DummyData.mainCategories[index];
              final isSelected = selectedCategoryId == category.id;
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                child: GestureDetector(
                  onTap: () => onCategorySelected?.call(category.id),
                  child: _buildCategoryChip(
                    category.icon,
                    category.name,
                    isSelected,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String iconEmoji, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: isSelected ? MbuyColors.primaryGradient : null,
        color: isSelected ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? null
            : Border.all(color: MbuyColors.surfaceLight, width: 1),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: MbuyColors.primaryPurple.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(iconEmoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : MbuyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
