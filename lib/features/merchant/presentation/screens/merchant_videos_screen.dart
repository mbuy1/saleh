import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// شاشة إدارة الفيديوهات للتاجر
class MerchantVideosScreen extends StatefulWidget {
  const MerchantVideosScreen({super.key});

  @override
  State<MerchantVideosScreen> createState() => _MerchantVideosScreenState();
}

class _MerchantVideosScreenState extends State<MerchantVideosScreen> {
  bool _isLoading = true;
  List<dynamic> _videos = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.get('/secure/merchant/videos');

      if (result['ok'] == true) {
        final data = result['data'];
        _videos = (data is List) ? data : [];
      } else {
        _error = result['error'] ?? 'فشل في تحميل الفيديوهات';
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteVideo(String videoId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('حذف الفيديو', style: GoogleFonts.cairo()),
        content: Text(
          'هل أنت متأكد من حذف هذا الفيديو؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: MbuyColors.error),
            child: Text('حذف', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final result = await ApiService.delete(
        '/secure/merchant/videos/$videoId',
      );
      if (result['ok'] == true) {
        _loadVideos();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم حذف الفيديو', style: GoogleFonts.cairo()),
            ),
          );
        }
      }
    }
  }

  void _showAddVideoDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    // يمكن إضافة اختيار المنتج لاحقاً

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MbuyColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إضافة فيديو جديد',
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'عنوان الفيديو',
                labelStyle: GoogleFonts.cairo(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'الوصف',
                labelStyle: GoogleFonts.cairo(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: MbuyColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MbuyColors.border),
              ),
              child: InkWell(
                onTap: () async {
                  final picker = ImagePicker();
                  final video = await picker.pickVideo(
                    source: ImageSource.gallery,
                  );
                  if (video != null && mounted) {
                    // TODO: Upload video
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'سيتم رفع الفيديو...',
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_library,
                      size: 40,
                      color: MbuyColors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اختر فيديو من المعرض',
                      style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'أدخل عنوان الفيديو',
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(ctx);
                  // TODO: Create video
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MbuyColors.primaryIndigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'إضافة الفيديو',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: Text(
          'إدارة الفيديوهات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadVideos),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddVideoDialog,
        backgroundColor: MbuyColors.primaryIndigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'إضافة فيديو',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorState()
          : _videos.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadVideos,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: _videos.length,
                itemBuilder: (ctx, index) => _buildVideoCard(_videos[index]),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 80,
            color: MbuyColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد فيديوهات',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MbuyColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف فيديو لعرض منتجاتك للعملاء',
            style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddVideoDialog,
            icon: const Icon(Icons.add),
            label: Text('إضافة فيديو', style: GoogleFonts.cairo()),
            style: ElevatedButton.styleFrom(
              backgroundColor: MbuyColors.primaryIndigo,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: MbuyColors.error),
          const SizedBox(height: 16),
          Text(
            _error ?? 'حدث خطأ',
            style: GoogleFonts.cairo(color: MbuyColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadVideos,
            child: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Container(
      decoration: BoxDecoration(
        color: MbuyColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MbuyColors.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: video['thumbnail_url'] != null
                        ? DecorationImage(
                            image: NetworkImage(video['thumbnail_url']),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: video['thumbnail_url'] == null
                      ? Icon(
                          Icons.video_library,
                          size: 48,
                          color: MbuyColors.textSecondary.withValues(
                            alpha: 0.5,
                          ),
                        )
                      : null,
                ),
                // Play button overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    child: const Icon(
                      Icons.play_circle_fill,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Views count
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${video['views_count'] ?? 0}',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Delete button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _deleteVideo(video['id']),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Video info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video['title'] ?? 'بدون عنوان',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.favorite, size: 14, color: MbuyColors.error),
                    const SizedBox(width: 4),
                    Text(
                      '${video['likes_count'] ?? 0}',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.comment, size: 14, color: MbuyColors.info),
                    const SizedBox(width: 4),
                    Text(
                      '${video['comments_count'] ?? 0}',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
