import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/firebase_service.dart';
import '../../data/services/wishlist_service.dart';
import '../../data/services/recently_viewed_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isInWishlist = false;
  bool _isLoadingWishlist = false;

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
      
      // تسجيل عرض المنتج في Recently Viewed
      _recordProductView();
      
      // جلب حالة Wishlist
      _checkWishlistStatus();
    });
  }

  /// تسجيل عرض المنتج في Recently Viewed
  Future<void> _recordProductView() async {
    try {
      await RecentlyViewedService.recordView(widget.productId);
    } catch (e) {
      // لا نعرض خطأ - هذه عملية ثانوية
      debugPrint('⚠️ خطأ في تسجيل عرض المنتج: $e');
    }
  }

  /// التحقق من حالة المنتج في Wishlist
  Future<void> _checkWishlistStatus() async {
    try {
      final isIn = await WishlistService.isInWishlist(widget.productId);
      if (mounted) {
        setState(() {
          _isInWishlist = isIn;
        });
      }
    } catch (e) {
      debugPrint('⚠️ خطأ في التحقق من Wishlist: $e');
    }
  }

  /// تبديل حالة Wishlist
  Future<void> _toggleWishlist() async {
    setState(() {
      _isLoadingWishlist = true;
    });

    try {
      final newStatus = await WishlistService.toggleWishlist(widget.productId);
      if (mounted) {
        setState(() {
          _isInWishlist = newStatus;
          _isLoadingWishlist = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newStatus
                ? 'تم إضافة المنتج إلى قائمة الأمنيات'
                : 'تم إزالة المنتج من قائمة الأمنيات'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingWishlist = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Semantics(
          label: 'رجوع',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: MbuyColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          // Wishlist Button
          _isLoadingWishlist
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    _isInWishlist ? Icons.favorite : Icons.favorite_border,
                    color: _isInWishlist ? Colors.red : MbuyColors.textPrimary,
                  ),
                  onPressed: _toggleWishlist,
                  tooltip: _isInWishlist ? 'إزالة من قائمة الأمنيات' : 'إضافة إلى قائمة الأمنيات',
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
