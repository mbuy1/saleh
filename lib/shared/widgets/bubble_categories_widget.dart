import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

/// نموذج بيانات الفئة للفقاعات
class BubbleCategory {
  final String id;
  final String name;
  final String? imageUrl;
  final IconData? icon;
  final VoidCallback? onTap;

  const BubbleCategory({
    required this.id,
    required this.name,
    this.imageUrl,
    this.icon,
    this.onTap,
  });
}

/// نموذج بيانات المجموعة الرئيسية (للقائمة الجانبية)
class CategoryGroup {
  final String id;
  final String name;
  final VoidCallback? onTap;

  const CategoryGroup({required this.id, required this.name, this.onTap});
}

/// Widget مشترك لعرض الفئات بشكل فقاعات (مثل تطبيقات التسوق العالمية)
/// يستخدم في الصفحة الرئيسية وصفحة المتاجر
class BubbleCategoriesWidget extends StatefulWidget {
  /// قائمة الفئات للعرض على شكل فقاعات
  final List<BubbleCategory> categories;

  /// المجموعات الرئيسية (للقائمة الجانبية) - اختياري
  final List<CategoryGroup>? categoryGroups;

  /// المجموعة المحددة حالياً
  final String? selectedGroupId;

  /// عدد الأعمدة في الشبكة (3 أو 4)
  final int crossAxisCount;

  /// عنوان القسم (مثل "تسوّق حسب الأقسام")
  final String? sectionTitle;

  /// إظهار القائمة الجانبية
  final bool showSideMenu;

  /// Aspect ratio للفقاعات
  final double childAspectRatio;

  const BubbleCategoriesWidget({
    super.key,
    required this.categories,
    this.categoryGroups,
    this.selectedGroupId,
    this.crossAxisCount = 3,
    this.sectionTitle,
    this.showSideMenu = false,
    this.childAspectRatio = 0.9,
  });

  @override
  State<BubbleCategoriesWidget> createState() => _BubbleCategoriesWidgetState();
}

class _BubbleCategoriesWidgetState extends State<BubbleCategoriesWidget> {
  late ScrollController _mainScrollController;
  late ScrollController _sideMenuScrollController;

  @override
  void initState() {
    super.initState();
    _mainScrollController = ScrollController();
    _sideMenuScrollController = ScrollController();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _sideMenuScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // إذا كانت الشاشة عريضة وهناك قائمة جانبية
    final screenWidth = MediaQuery.of(context).size.width;
    final showSideMenuLayout = widget.showSideMenu && screenWidth > 600;

    if (showSideMenuLayout && widget.categoryGroups != null) {
      return _buildWithSideMenu();
    }

    return _buildCategoriesOnly();
  }

  /// عرض الفئات فقط بدون قائمة جانبية
  Widget _buildCategoriesOnly() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        if (widget.sectionTitle != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              widget.sectionTitle!,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: MbuyColors.textPrimary,
              ),
            ),
          ),
        ],

        // شبكة الفقاعات
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: widget.childAspectRatio,
            ),
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              return _buildBubble(widget.categories[index]);
            },
          ),
        ),
      ],
    );
  }

  /// عرض الفئات مع قائمة جانبية
  Widget _buildWithSideMenu() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // القائمة الجانبية (يمين الشاشة)
        Container(
          width: 140,
          decoration: BoxDecoration(
            color: MbuyColors.surface,
            border: Border(
              left: BorderSide(color: MbuyColors.borderLight, width: 1),
            ),
          ),
          child: ListView.builder(
            controller: _sideMenuScrollController,
            itemCount: widget.categoryGroups!.length,
            itemBuilder: (context, index) {
              final group = widget.categoryGroups![index];
              final isSelected = group.id == widget.selectedGroupId;
              return _buildSideMenuItem(group, isSelected);
            },
          ),
        ),

        // الفئات الرئيسية
        Expanded(
          child: SingleChildScrollView(
            controller: _mainScrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان القسم
                if (widget.sectionTitle != null) ...[
                  Text(
                    widget.sectionTitle!,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // شبكة الفقاعات
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: widget.childAspectRatio,
                  ),
                  itemCount: widget.categories.length,
                  itemBuilder: (context, index) {
                    return _buildBubble(widget.categories[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// بناء عنصر القائمة الجانبية
  Widget _buildSideMenuItem(CategoryGroup group, bool isSelected) {
    return Material(
      color: isSelected ? MbuyColors.background : Colors.transparent,
      child: InkWell(
        onTap: group.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? MbuyColors.textPrimary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            group.name,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? MbuyColors.textPrimary
                  : MbuyColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// بناء الفقاعة الواحدة
  Widget _buildBubble(BubbleCategory category) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: category.onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الفقاعة (دائرية أو مستطيل بحواف كبيرة)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: MbuyColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: MbuyColors.borderLight, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: category.imageUrl != null
                      ? Image.network(
                          category.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder(category);
                          },
                        )
                      : _buildPlaceholder(category),
                ),
              ),
            ),

            // اسم الفئة
            const SizedBox(height: 8),
            Text(
              category.name,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MbuyColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// بناء placeholder عند عدم وجود صورة
  Widget _buildPlaceholder(BubbleCategory category) {
    return Container(
      color: MbuyColors.surface,
      child: Center(
        child: Icon(
          category.icon ?? Icons.category_outlined,
          size: 40,
          color: MbuyColors.textSecondary,
        ),
      ),
    );
  }
}
