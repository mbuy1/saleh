import '../dummy_data.dart';
import '../models.dart';
import '../../../features/customer/data/services/explore_service.dart';

/// Repository لفيديوهات Explore - يوفر واجهة موحدة للوصول للبيانات
class ExploreRepository {
  /// جلب جميع الفيديوهات مع Pagination
  ///
  /// [filter]: نوع الفلتر ('new', 'trending', 'top_selling', 'by_location', 'top_rated')
  Future<List<VideoItem>> getExploreFeed({
    String filter = 'new',
    int page = 0,
    int pageSize = 5,
  }) async {
    try {
      // محاولة جلب البيانات من Supabase
      final videos = await ExploreService.getExploreVideos(
        filter: filter,
        page: page,
        pageSize: pageSize,
      );

      // إذا كانت هناك بيانات، نعيدها
      if (videos.isNotEmpty) {
        return videos.cast<VideoItem>();
      }

      // إذا لم تكن هناك بيانات، نستخدم DummyData كـ fallback
      await Future.delayed(const Duration(milliseconds: 400));
      final allVideos = DummyData.exploreVideos.cast<VideoItem>();

      // تطبيق Pagination
      final startIndex = page * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, allVideos.length);

      if (startIndex >= allVideos.length) return [];

      return allVideos.sublist(startIndex, endIndex);
    } catch (e) {
      // في حالة الخطأ، نستخدم DummyData
      await Future.delayed(const Duration(milliseconds: 400));
      final allVideos = DummyData.exploreVideos.cast<VideoItem>();
      final startIndex = page * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, allVideos.length);
      if (startIndex >= allVideos.length) return [];
      return allVideos.sublist(startIndex, endIndex);
    }
  }

  /// جلب فيديو بالـ ID
  Future<VideoItem?> getVideoById(String id) async {
    try {
      // محاولة جلب من Supabase
      final video = await ExploreService.getVideoById(id);
      if (video != null) return video;
    } catch (e) {
      // تجاهل الخطأ والمتابعة إلى DummyData
    }

    // Fallback إلى DummyData
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final videos = DummyData.exploreVideos.cast<VideoItem>();
      return videos.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  /// جلب فيديوهات لمنتج معين
  Future<List<VideoItem>> getVideosByProduct(String productId) async {
    try {
      // محاولة جلب من Supabase
      final videos = await ExploreService.getVideosByProduct(productId);
      if (videos.isNotEmpty) return videos.cast<VideoItem>();
    } catch (e) {
      // تجاهل الخطأ والمتابعة إلى DummyData
    }

    // Fallback إلى DummyData
    await Future.delayed(const Duration(milliseconds: 300));
    final allVideos = DummyData.exploreVideos.cast<VideoItem>();
    return allVideos.where((v) => v.productId == productId).toList();
  }

  /// جلب أكثر الفيديوهات رواجاً
  Future<List<VideoItem>> getTrendingVideos({int limit = 10}) async {
    try {
      // محاولة جلب من Supabase
      final videos = await ExploreService.getExploreVideos(
        filter: 'trending',
        page: 0,
        pageSize: limit,
      );
      if (videos.isNotEmpty) return videos.cast<VideoItem>();
    } catch (e) {
      // تجاهل الخطأ والمتابعة إلى DummyData
    }

    // Fallback إلى DummyData
    await Future.delayed(const Duration(milliseconds: 300));
    final allVideos = DummyData.exploreVideos.cast<VideoItem>();
    final sorted = List<VideoItem>.from(allVideos)
      ..sort((a, b) => b.likes.compareTo(a.likes));
    return sorted.take(limit).toList();
  }
}
