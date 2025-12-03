import '../../../core/supabase_client.dart';
import '../../../core/data/models.dart';
import 'package:flutter/foundation.dart';

/// خدمة Explore - جلب الفيديوهات والمنتجات من Supabase
class ExploreService {
  /// جلب فيديوهات Explore مع Pagination
  /// 
  /// [filter]: نوع الفلتر ('new', 'trending', 'top_selling', 'by_location', 'top_rated')
  /// [page]: رقم الصفحة
  /// [pageSize]: عدد العناصر في الصفحة
  static Future<List<VideoItem>> getExploreVideos({
    String filter = 'new',
    int page = 0,
    int pageSize = 10,
  }) async {
    try {
      // Pagination
      final from = page * pageSize;
      final to = from + pageSize - 1;

      // محاولة استخدام type أولاً، ثم media_type إذا فشل
      dynamic queryBuilder;
      String orderColumn;
      
      try {
        // محاولة استخدام type
        queryBuilder = supabaseClient
            .from('stories')
            .select('''
              *,
              stores:store_id (
                id,
                name
              ),
              products:product_id (
                id,
                name,
                price,
                store_id
              )
            ''')
            .eq('is_active', true)
            .eq('type', 'video');
        
        // محاولة استخدام views_count
        orderColumn = 'views_count';
      } catch (e) {
        // إذا فشل، استخدم media_type
        queryBuilder = supabaseClient
            .from('stories')
            .select('''
              *,
              stores:store_id (
                id,
                name
              ),
              products:product_id (
                id,
                name,
                price,
                store_id
              )
            ''')
            .eq('is_active', true)
            .eq('media_type', 'video');
        
        orderColumn = 'view_count';
      }

      // تطبيق الفلتر
      switch (filter) {
        case 'trending':
          // الأكثر مشاهدة (حسب views_count أو view_count)
          queryBuilder = queryBuilder.order(orderColumn, ascending: false);
          break;
        case 'top_selling':
          // الأكثر مبيعاً (حسب product sales)
          queryBuilder = queryBuilder.order('created_at', ascending: false);
          break;
        case 'top_rated':
          // الأعلى تقييماً
          queryBuilder = queryBuilder.order('created_at', ascending: false);
          break;
        case 'new':
        default:
          // الأحدث
          queryBuilder = queryBuilder.order('created_at', ascending: false);
          break;
      }

      // تطبيق Pagination
      queryBuilder = queryBuilder.range(from, to);

      final response = await queryBuilder;

      return _mapStoriesToVideoItems(response);
    } catch (e) {
      // إذا فشل مع type، جرب media_type
      try {
        debugPrint('⚠️ محاولة استخدام media_type بدلاً من type');
        final from = page * pageSize;
        final to = from + pageSize - 1;
        
        dynamic queryBuilder2 = supabaseClient
            .from('stories')
            .select('''
              *,
              stores:store_id (
                id,
                name
              ),
              products:product_id (
                id,
                name,
                price,
                store_id
              )
            ''')
            .eq('is_active', true)
            .eq('media_type', 'video');
        
        // تطبيق الفلتر
        switch (filter) {
          case 'trending':
            queryBuilder2 = queryBuilder2.order('view_count', ascending: false);
            break;
          case 'top_selling':
          case 'top_rated':
          case 'new':
          default:
            queryBuilder2 = queryBuilder2.order('created_at', ascending: false);
            break;
        }
        
        queryBuilder2 = queryBuilder2.range(from, to);
        final response2 = await queryBuilder2;
        return _mapStoriesToVideoItems(response2);
      } catch (e2) {
        debugPrint('❌ خطأ في جلب فيديوهات Explore: $e2');
        return [];
      }
    }
  }

  /// جلب منتجات Explore مع Pagination
  /// 
  /// [filter]: نوع الفلتر
  /// [page]: رقم الصفحة
  /// [pageSize]: عدد العناصر في الصفحة
  static Future<List<Product>> getExploreProducts({
    String filter = 'new',
    int page = 0,
    int pageSize = 30,
  }) async {
    try {
      // Pagination
      final from = page * pageSize;
      final to = from + pageSize - 1;

      dynamic queryBuilder = supabaseClient
          .from('products')
          .select('''
            *,
            stores:store_id (
              id,
              name
            )
          ''')
          .eq('status', 'active');

      // تطبيق الفلتر
      switch (filter) {
        case 'trending':
          // الأكثر مشاهدة
          queryBuilder = queryBuilder.order('views_count', ascending: false);
          break;
        case 'top_selling':
          // الأكثر مبيعاً
          queryBuilder = queryBuilder.order('sales_count', ascending: false);
          break;
        case 'top_rated':
          // الأعلى تقييماً
          queryBuilder = queryBuilder.order('rating', ascending: false);
          break;
        case 'by_location':
          // حسب الموقع (سيتم تطبيقه لاحقاً)
          queryBuilder = queryBuilder.order('created_at', ascending: false);
          break;
        case 'new':
        default:
          // الأحدث
          queryBuilder = queryBuilder.order('created_at', ascending: false);
          break;
      }

      // تطبيق Pagination
      queryBuilder = queryBuilder.range(from, to);

      final response = await queryBuilder;

      return _mapProductsToProductItems(response);
    } catch (e) {
      debugPrint('❌ خطأ في جلب منتجات Explore: $e');
      return [];
    }
  }

  /// جلب فيديو بالـ ID
  static Future<VideoItem?> getVideoById(String id) async {
    try {
      // محاولة استخدام type أولاً
      dynamic response;
      try {
        response = await supabaseClient
            .from('stories')
            .select('''
              *,
              stores:store_id (
                id,
                name
              ),
              products:product_id (
                id,
                name,
                price,
                store_id
              )
            ''')
            .eq('id', id)
            .eq('is_active', true)
            .eq('type', 'video')
            .maybeSingle();
      } catch (e) {
        // إذا فشل، استخدم media_type
        response = await supabaseClient
            .from('stories')
            .select('''
              *,
              stores:store_id (
                id,
                name
              ),
              products:product_id (
                id,
                name,
                price,
                store_id
              )
            ''')
            .eq('id', id)
            .eq('is_active', true)
            .eq('media_type', 'video')
            .maybeSingle();
      }

      if (response == null) return null;

      return _mapStoryToVideoItem(response);
    } catch (e) {
      debugPrint('❌ خطأ في جلب فيديو: $e');
      return null;
    }
  }

  /// جلب فيديوهات لمنتج معين
  static Future<List<VideoItem>> getVideosByProduct(String productId) async {
    try {
      // محاولة استخدام type أولاً
      List<dynamic> response;
      try {
        response = await supabaseClient
            .from('stories')
            .select('''
              *,
              stores:store_id (
                id,
                name
              ),
              products:product_id (
                id,
                name,
                price,
                store_id
              )
            ''')
            .eq('product_id', productId)
            .eq('is_active', true)
            .eq('type', 'video')
            .order('created_at', ascending: false);
      } catch (e) {
        // إذا فشل، استخدم media_type
        response = await supabaseClient
            .from('stories')
            .select('''
              *,
              stores:store_id (
                id,
                name
              ),
              products:product_id (
                id,
                name,
                price,
                store_id
              )
            ''')
            .eq('product_id', productId)
            .eq('is_active', true)
            .eq('media_type', 'video')
            .order('created_at', ascending: false);
      }

      return _mapStoriesToVideoItems(response);
    } catch (e) {
      debugPrint('❌ خطأ في جلب فيديوهات المنتج: $e');
      return [];
    }
  }

  /// تتبع مشاهدة فيديو
  static Future<void> trackVideoView(String videoId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      
      // زيادة عدد المشاهدات
      await supabaseClient.rpc('increment_story_views', params: {
        'story_id': videoId,
      });

      // تسجيل مشاهدة المستخدم (إذا كان مسجل دخول)
      if (user != null) {
        await supabaseClient.from('story_views').insert({
          'story_id': videoId,
          'user_id': user.id,
          'viewed_at': DateTime.now().toIso8601String(),
        }).catchError((e) {
          // تجاهل الخطأ إذا كان السجل موجود بالفعل
          debugPrint('⚠️ خطأ في تسجيل مشاهدة: $e');
        });
      }

      // تتبع في Firebase Analytics
      // FirebaseService.logCustomEvent('view_video', {'video_id': videoId});
    } catch (e) {
      debugPrint('⚠️ خطأ في تتبع مشاهدة الفيديو: $e');
    }
  }

  /// تتبع إعجاب فيديو
  static Future<void> toggleVideoLike(String videoId, bool isLiked) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return;

      if (isLiked) {
        // إضافة إعجاب
        await supabaseClient.from('story_likes').insert({
          'story_id': videoId,
          'user_id': user.id,
          'created_at': DateTime.now().toIso8601String(),
        });
      } else {
        // إزالة إعجاب
        await supabaseClient
            .from('story_likes')
            .delete()
            .eq('story_id', videoId)
            .eq('user_id', user.id);
      }

      // تحديث عدد الإعجابات في الجدول
      await supabaseClient.rpc('update_story_likes_count', params: {
        'story_id': videoId,
      });
    } catch (e) {
      debugPrint('⚠️ خطأ في تتبع إعجاب الفيديو: $e');
    }
  }

  // ==================== Helper Methods ====================

  /// تحويل Stories من Supabase إلى VideoItem
  static List<VideoItem> _mapStoriesToVideoItems(List<dynamic> stories) {
    return stories.map((story) => _mapStoryToVideoItem(story)).toList();
  }

  /// تحويل Story واحد إلى VideoItem
  static VideoItem _mapStoryToVideoItem(Map<String, dynamic> story) {
    // الحصول على المتجر (من stores مباشرة أو من products)
    final store = story['stores'] as Map<String, dynamic>?;
    final product = story['products'] as Map<String, dynamic>?;
    
    // الحصول على اسم المتجر
    final storeName = store?['name'] as String? ?? 
                     (story['title'] as String?) ?? 
                     'متجر';
    
    // الحصول على الحرف الأول
    final storeNameFirstChar = storeName.isNotEmpty 
        ? storeName.substring(0, 1).toUpperCase() 
        : 'م';
    
    // الحصول على views (views_count أو view_count)
    final views = (story['views_count'] as num?)?.toInt() ?? 
                  (story['view_count'] as num?)?.toInt() ?? 0;
    
    // الحصول على media_url
    final videoUrl = story['media_url'] as String?;
    
    // الحصول على caption أو title
    final caption = story['caption'] as String? ?? 
                    story['title'] as String? ?? 
                    'بدون وصف';

    return VideoItem(
      id: story['id'] as String? ?? '',
      title: caption,
      productId: story['product_id'] as String?,
      videoUrl: videoUrl,
      thumbnailUrl: story['thumbnail_url'] as String?,
      caption: caption,
      userName: storeName,
      userAvatar: storeNameFirstChar,
      likes: (story['likes_count'] as num?)?.toInt() ?? 0,
      comments: (story['comments_count'] as num?)?.toInt() ?? 0,
      shares: (story['shares_count'] as num?)?.toInt() ?? 0,
      bookmarks: (story['bookmarks_count'] as num?)?.toInt() ?? 0,
      views: views,
      productPrice: (product?['price'] as num?)?.toDouble(),
    );
  }

  /// تحويل Products من Supabase إلى Product
  static List<Product> _mapProductsToProductItems(List<dynamic> products) {
    return products.map((product) {
      final store = product['stores'] as Map<String, dynamic>?;
      
      return Product(
        id: product['id'] as String? ?? '',
        name: product['name'] as String? ?? 'منتج',
        description: product['description'] as String? ?? '',
        price: (product['price'] as num?)?.toDouble() ?? 0.0,
        storeId: product['store_id'] as String? ?? '',
        categoryId: product['category_id'] as String? ?? '',
        imageUrl: product['image_url'] as String?,
        rating: (product['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: (product['review_count'] as num?)?.toInt() ?? 0,
        storeName: store?['name'] as String? ?? 'متجر',
      );
    }).toList();
  }
}

