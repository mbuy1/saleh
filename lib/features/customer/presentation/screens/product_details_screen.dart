import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/firebase_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // تتبع عرض المنتج
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseService.logViewProduct(
        productId: widget.productId,
        productName: 'اسم المنتج ${widget.productId}',
        price: 99.0,
      );
      FirebaseService.logScreenView('product_details', parameters: {
        'product_id': widget.productId,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MbuyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: MbuyColors.textPrimary,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: MbuyColors.textPrimary,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 400,
              width: double.infinity,
              color: MbuyColors.surface,
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 80,
                  color: MbuyColors.textTertiary,
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    '99.00 ر.س',
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.primaryMaroon,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Product Name
                  Text(
                    'اسم المنتج ${widget.productId}',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '4.5',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(120 تقييم)',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: MbuyColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  Row(
                    children: [
                      Text(
                        'الكمية',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _buildQuantityButton(Icons.remove, () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      }),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: MbuyColors.border),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$_quantity',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _buildQuantityButton(Icons.add, () {
                        setState(() => _quantity++);
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'الوصف',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'وصف المنتج يظهر هنا. يمكن أن يكون طويلاً ويحتوي على تفاصيل المنتج والمواصفات.',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: MbuyColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: MbuyColors.borderLight)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: MbuyColors.primaryMaroon),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'أضف للسلة',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.primaryMaroon,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MbuyColors.primaryMaroon,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'اشتر الآن',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MbuyColors.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 18, color: MbuyColors.textPrimary),
      ),
    );
  }
}
