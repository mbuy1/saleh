import 'package:flutter/material.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/mbuy_loader.dart';
import '../../../../shared/widgets/story_ring.dart';

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
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text(
          'المتاجر',
          style: TextStyle(
            color: MbuyColors.textPrimary,
            fontFamily: 'Arabic',
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: MbuyLoader())
          : _stores.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد متاجر متاحة',
                    style: TextStyle(
                      fontSize: 18,
                      color: MbuyColors.textSecondary,
                      fontFamily: 'Arabic',
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
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

    // TODO: جلب hasStory من قاعدة البيانات (حالياً placeholder)
    // يمكن إضافة حقل hasStory في جدول stores لاحقاً
    final hasStory = store['has_story'] as bool? ?? false; // Placeholder

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: MbuyColors.surfaceLight,
      elevation: isBoosted ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isBoosted
            ? BorderSide(
                width: 2,
                color: MbuyColors.primaryBlue,
              )
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: StoryRing(
          hasStory: hasStory,
          ringWidth: 3.0,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: isBoosted
                ? MbuyColors.primaryBlue.withValues(alpha: 0.3)
                : MbuyColors.surface,
            child: Icon(
              Icons.store,
              color: isBoosted ? MbuyColors.primaryBlue : MbuyColors.textSecondary,
              size: 28,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                store['name'] ?? 'بدون اسم',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MbuyColors.textPrimary,
                  fontSize: 16,
                  fontFamily: 'Arabic',
                ),
              ),
            ),
            if (isBoosted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: MbuyColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.rocket_launch,
                      color: Colors.white,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'مدعوم',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arabic',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (store['city'] != null)
              Text(
                '${store['city']}',
                style: TextStyle(
                  color: MbuyColors.textSecondary,
                  fontSize: 14,
                  fontFamily: 'Arabic',
                ),
              ),
            if (store['description'] != null) ...[
              const SizedBox(height: 4),
              Text(
                store['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: MbuyColors.textSecondary,
                  fontFamily: 'Arabic',
                ),
              ),
            ],
            if (isBoosted) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MbuyColors.primaryBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'مميز لمدة محدودة',
                  style: TextStyle(
                    fontSize: 11,
                    color: MbuyColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Arabic',
                  ),
                ),
              ),
            ],
            // Badges المستقبلية (Placeholder)
            // TODO: إضافة badges مثل "شحن مجاني"، "مدعوم"، إلخ
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: MbuyColors.textSecondary,
        ),
        onTap: () {
          // TODO: الانتقال إلى صفحة المتجر
        },
      ),
    );
  }
}

