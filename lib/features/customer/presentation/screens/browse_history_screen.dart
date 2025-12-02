import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import 'product_details_screen.dart';

/// شاشة سجل التصفح
class BrowseHistoryScreen extends StatefulWidget {
  const BrowseHistoryScreen({super.key});

  @override
  State<BrowseHistoryScreen> createState() => _BrowseHistoryScreenState();
}

class _BrowseHistoryScreenState extends State<BrowseHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('سجل التصفح'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: مسح السجل
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة مسح السجل قريباً')),
              );
            },
            child: Text(
              'مسح الكل',
              style: GoogleFonts.cairo(
                color: MbuyColors.error,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DummyData.products.length,
        itemBuilder: (context, index) {
          final product = DummyData.products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: MbuyColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_outlined),
              ),
              title: Text(
                product.name,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: MbuyColors.textPrimary,
                ),
              ),
              subtitle: Text(
                '${product.price} ر.س',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: MbuyColors.textSecondary,
                ),
              ),
              trailing: Text(
                'منذ ساعة',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: MbuyColors.textTertiary,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      productId: product.id,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

