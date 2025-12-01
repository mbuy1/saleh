import '../dummy_data.dart';
import '../models.dart';

/// Repository لفيديوهات Explore - يوفر واجهة موحدة للوصول للبيانات
class ExploreRepository {
  /// جلب جميع الفيديوهات مع Pagination
  Future<List<VideoItem>> getExploreFeed({
    int page = 0,
    int pageSize = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final allVideos = DummyData.exploreVideos.cast<VideoItem>();

    // تطبيق Pagination
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, allVideos.length);

    if (startIndex >= allVideos.length) return [];

    return allVideos.sublist(startIndex, endIndex);
  }

  /// جلب فيديو بالـ ID
  Future<VideoItem?> getVideoById(String id) async {
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
    await Future.delayed(const Duration(milliseconds: 300));
    final allVideos = DummyData.exploreVideos.cast<VideoItem>();
    return allVideos.where((v) => v.productId == productId).toList();
  }

  /// جلب أكثر الفيديوهات رواجاً
  Future<List<VideoItem>> getTrendingVideos({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allVideos = DummyData.exploreVideos.cast<VideoItem>();

    final sorted = List<VideoItem>.from(allVideos)
      ..sort((a, b) => b.likes.compareTo(a.likes));

    return sorted.take(limit).toList();
  }
}
