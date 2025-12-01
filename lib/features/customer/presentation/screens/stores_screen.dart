import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/supabase_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/exceptions/error_handler.dart';
import '../../../../shared/widgets/mbuy_loader.dart';
import '../../../../shared/widgets/story_ring.dart';
import '../../../../shared/widgets/mbuy_search_bar.dart';
import '../../../../shared/widgets/categories_bar.dart';
import 'store_details_screen.dart';

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
      List<Map<String, dynamic>> stores = List<Map<String, dynamic>>.from(
        response,
      );

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
        final exception = AppException.fromException(e);
        ErrorHandler.showErrorSnackBar(context, exception);
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
      body: SafeArea(
        child: Column(
          children: [
            // عنوان مع أيقونة الحساب
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'المتاجر',
                  style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: MbuyColors.textPrimary,
                  ),
                ),
              ),
            ),
            // شريط البحث مع أيقونة الحساب
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MbuySearchBar(
                hintText: 'ابحث عن متجر...',
                showProfileButton: true,
              ),
            ),
            const SizedBox(height: 16),
            // شريط الفئات
            const CategoriesBar(),
            const SizedBox(height: 16),
            // قائمة المتاجر أفقية نمط Snapchat
            if (_isLoading)
              const Expanded(child: Center(child: MbuyLoader()))
            else if (_stores.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'لا توجد متاجر متاحة',
                    style: TextStyle(
                      fontSize: 18,
                      color: MbuyColors.textSecondary,
                      fontFamily: 'Arabic',
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _stores.length,
                  itemBuilder: (context, index) {
                    final store = _stores[index];
                    return _buildStoreCircle(store);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCircle(Map<String, dynamic> store) {
    final bool isBoosted = _isStoreBoosted(store);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreDetailsScreen(
              storeId: store['id'],
              storeName: store['name'] ?? 'متجر',
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // صورة دائرية مع حلقة Story
          StoryRing(
            hasStory: isBoosted,
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MbuyColors.surfaceLight,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: Center(
                  child: Text(
                    (store['name'] as String?)?.substring(0, 1).toUpperCase() ??
                        'M',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.primaryPurple,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // اسم المتجر
          Text(
            store['name'] ?? 'متجر',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: MbuyColors.textPrimary,
              fontFamily: 'Arabic',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _isStoreBoosted(Map<String, dynamic> store) {
    final boostedUntil = store['boosted_until'] as String?;
    if (boostedUntil == null) return false;

    try {
      final date = DateTime.parse(boostedUntil);
      return date.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}
