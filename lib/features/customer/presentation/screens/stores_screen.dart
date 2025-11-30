import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
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
      // ترتيب: المتاجر المدعومة أولاً (boosted_until > now())، ثم الباقي
      final response = await supabaseClient
          .from('stores')
          .select()
          .eq('visibility', 'public')
          .eq('status', 'active')
          .order('created_at', ascending: false);

      // تحويل إلى List وترتيبها
      List<Map<String, dynamic>> stores = List<Map<String, dynamic>>.from(response);
      
      // ترتيب المتاجر: المدعومة أولاً
      stores.sort((a, b) {
        final aBoosted = a['boosted_until'] as String?;
        final bBoosted = b['boosted_until'] as String?;
        
        // إذا كان a مدعوم و b غير مدعوم
        if (aBoosted != null && bBoosted == null) {
          try {
            final aDate = DateTime.parse(aBoosted);
            if (aDate.isAfter(DateTime.now())) {
              return -1; // a يأتي أولاً
            }
          } catch (e) {
            // خطأ في parsing التاريخ
          }
        }
        
        // إذا كان b مدعوم و a غير مدعوم
        if (bBoosted != null && aBoosted == null) {
          try {
            final bDate = DateTime.parse(bBoosted);
            if (bDate.isAfter(DateTime.now())) {
              return 1; // b يأتي أولاً
            }
          } catch (e) {
            // خطأ في parsing التاريخ
          }
        }
        
        // إذا كان كلاهما مدعوم أو غير مدعوم، نرتب حسب boosted_until ثم created_at
        if (aBoosted != null && bBoosted != null) {
          try {
            final aDate = DateTime.parse(aBoosted);
            final bDate = DateTime.parse(bBoosted);
            final aActive = aDate.isAfter(DateTime.now());
            final bActive = bDate.isAfter(DateTime.now());
            
            if (aActive && bActive) {
              // كلاهما مدعوم، نرتب حسب boosted_until (الأحدث أولاً)
              return bDate.compareTo(aDate);
            } else if (aActive) {
              return -1; // a مدعوم و b غير مدعوم
            } else if (bActive) {
              return 1; // b مدعوم و a غير مدعوم
            }
          } catch (e) {
            // خطأ في parsing التاريخ
          }
        }
        
        // إذا لم يكن هناك دعم، نرتب حسب created_at
        final aCreated = a['created_at'] as String?;
        final bCreated = b['created_at'] as String?;
        if (aCreated != null && bCreated != null) {
          try {
            return DateTime.parse(bCreated).compareTo(DateTime.parse(aCreated));
          } catch (e) {
            // خطأ في parsing التاريخ
          }
        }
        
        return 0;
      });

      setState(() {
        _stores = stores;
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
      appBar: AppBar(
        title: const Text('المتاجر'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stores.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد متاجر متاحة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _stores.length,
                  itemBuilder: (context, index) {
                    return _buildStoreCard(_stores[index]);
                  },
                ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    // التحقق من أن المتجر مدعوم حالياً
    final boostedUntil = store['boosted_until'] as String?;
    bool isBoosted = false;
    
    if (boostedUntil != null) {
      try {
        final boostedDate = DateTime.parse(boostedUntil);
        isBoosted = boostedDate.isAfter(DateTime.now());
      } catch (e) {
        // خطأ في parsing التاريخ
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: isBoosted ? 4 : 1, // ارتفاع أكبر للمتاجر المدعومة
      color: isBoosted ? Colors.orange.shade50 : null,
      child: ListTile(
        leading: Stack(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isBoosted ? Colors.orange[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.store,
                color: isBoosted ? Colors.orange : Colors.blue,
                size: 32,
              ),
            ),
            if (isBoosted)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                store['name'] ?? 'بدون اسم',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isBoosted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'مدعوم',
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
            if (store['city'] != null)
              Text('${store['city']}'),
            if (store['description'] != null)
              Text(
                store['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            if (isBoosted)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'مميز لمدة محدودة',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: الانتقال إلى صفحة المتجر
        },
      ),
    );
  }
}

