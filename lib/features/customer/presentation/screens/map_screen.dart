import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import 'customer_orders_screen.dart';
import 'profile_screen.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Map<String, dynamic>> _stores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // جلب المتاجر العامة والنشطة
      final response = await supabaseClient
          .from('stores')
          .select()
          .eq('visibility', 'public')
          .eq('status', 'active')
          .order('created_at', ascending: false);

      setState(() {
        _stores = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب المتاجر: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // شريط البحث والأزرار
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // صف الأزرار
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // زر الحساب الشخصي
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      tooltip: 'الحساب الشخصي',
                    ),
                    // زر البحث بالفئات
                    IconButton(
                      icon: const Icon(Icons.category),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoriesScreen(),
                          ),
                        );
                      },
                      tooltip: 'البحث بالفئات',
                    ),
                    // زر المفضلة
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                      tooltip: 'المفضلة',
                    ),
                    // زر طلباتي
                    IconButton(
                      icon: const Icon(Icons.receipt_long),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomerOrdersScreen(),
                          ),
                        );
                      },
                      tooltip: 'طلباتي',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // حقل البحث
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن متجر...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSubmitted: (value) {
                    // TODO: إضافة منطق البحث
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('البحث عن: $value')));
                  },
                ),
              ],
            ),
          ),
          // خريطة مع قائمة المتاجر
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _stores.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.map, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'لا توجد متاجر متاحة',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // Placeholder للخريطة (سيتم استبداله بخريطة حقيقية لاحقاً)
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.map,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'خريطة المتاجر',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'سيتم إضافة خريطة حقيقية لاحقاً',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // قائمة المتاجر
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Text(
                                      'المتاجر',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${_stores.length} متجر',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  itemCount: _stores.length,
                                  itemBuilder: (context, index) {
                                    return _buildStoreItem(_stores[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreItem(Map<String, dynamic> store) {
    // التحقق من أن المتجر مميز على الخريطة حالياً
    final highlightUntil = store['map_highlight_until'] as String?;
    bool isHighlighted = false;

    if (highlightUntil != null) {
      try {
        final highlightDate = DateTime.parse(highlightUntil);
        isHighlighted = highlightDate.isAfter(DateTime.now());
      } catch (e) {
        // خطأ في parsing التاريخ
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: isHighlighted ? 4 : 1,
      color: isHighlighted ? Colors.purple.shade50 : null,
      child: ListTile(
        leading: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isHighlighted ? Colors.purple[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
                border: isHighlighted
                    ? Border.all(color: Colors.purple, width: 2)
                    : null,
              ),
              child: Icon(
                Icons.store,
                color: isHighlighted ? Colors.purple : Colors.blue,
                size: 28,
              ),
            ),
            if (isHighlighted)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                store['name'] ?? 'بدون اسم',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? Colors.purple.shade700 : null,
                ),
              ),
            ),
            if (isHighlighted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'مميز',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (store['city'] != null) Text('${store['city']}'),
            if (isHighlighted)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'مميز على الخريطة',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        trailing: Icon(
          Icons.location_on,
          color: isHighlighted ? Colors.purple : Colors.grey,
        ),
        onTap: () {
          // TODO: الانتقال إلى صفحة المتجر أو عرض تفاصيله على الخريطة
        },
      ),
    );
  }
}
