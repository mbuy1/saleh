import 'package:flutter/material.dart';
import '../../data/services/recently_viewed_service.dart';
import '../../data/models/recently_viewed_model.dart';
import '../../../../shared/widgets/product_card_compact.dart';
import '../../../../core/data/models.dart';
import 'product_details_screen.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة المنتجات المعروضة مؤخراً
class RecentlyViewedScreen extends StatefulWidget {
  const RecentlyViewedScreen({super.key});

  @override
  State<RecentlyViewedScreen> createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
  List<RecentlyViewedItem> _recentlyViewedItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecentlyViewed();
  }

  Future<void> _loadRecentlyViewed() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final items = await RecentlyViewedService.getRecentlyViewed();
      setState(() {
        _recentlyViewedItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromRecentlyViewed(RecentlyViewedItem item) async {
    try {
      await RecentlyViewedService.removeFromRecentlyViewed(item.recentlyViewed.id);
      await _loadRecentlyViewed();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إزالة المنتج'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إزالة المنتج: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearRecentlyViewed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف جميع المنتجات المعروضة مؤخراً؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف الكل'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await RecentlyViewedService.clearRecentlyViewed();
        await _loadRecentlyViewed();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف جميع المنتجات'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في الحذف: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('المعروضة مؤخراً'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          if (_recentlyViewedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearRecentlyViewed,
              tooltip: 'حذف الكل',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('خطأ: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadRecentlyViewed,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : _recentlyViewedItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد منتجات معروضة مؤخراً',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('تصفح المنتجات'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadRecentlyViewed,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _recentlyViewedItems.length,
                        itemBuilder: (context, index) {
                          final item = _recentlyViewedItems[index];
                          final product = item.product;
                          
                          return Stack(
                            children: [
                              ProductCardCompact(
                                product: Product(
                                  id: product['id'] ?? '',
                                  name: product['name'] ?? 'بدون اسم',
                                  description: product['description'] ?? '',
                                  price: (product['price'] ?? 0).toDouble(),
                                  imageUrl: product['image_url'] ?? product['main_image_url'],
                                  categoryId: product['category_id'] ?? '',
                                  storeId: product['store_id'] ?? '',
                                  stockCount: product['stock'] ?? product['stock_quantity'] ?? 0,
                                ),
                                onTap: () {
                                  // تسجيل عرض المنتج مرة أخرى
                                  RecentlyViewedService.recordView(product['id'] ?? '');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(
                                        productId: product['id'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _removeFromRecentlyViewed(item),
                                  tooltip: 'إزالة',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
    );
  }
}

