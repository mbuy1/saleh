import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';

class MapCategoriesBar extends StatelessWidget {
  const MapCategoriesBar({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.home_filled, 'label': 'المنزل'},
      {'icon': Icons.restaurant, 'label': 'المطاعم'},
      {'icon': Icons.local_cafe, 'label': 'المقاهي'},
      {'icon': Icons.shopping_basket, 'label': 'البقالة'},
      {'icon': Icons.storefront, 'label': 'المتاجر'},
      {'icon': Icons.local_hospital, 'label': 'صيدليات'},
      {'icon': Icons.local_gas_station, 'label': 'محطات'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.2),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat['icon'] as IconData,
                        size: 18,
                        color: MbuyColors.textPrimary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat['label'] as String,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
