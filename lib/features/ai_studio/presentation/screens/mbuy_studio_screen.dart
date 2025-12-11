import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mbuy_studio_service.dart';

class MbuyStudioScreen extends ConsumerStatefulWidget {
  const MbuyStudioScreen({super.key});

  @override
  ConsumerState<MbuyStudioScreen> createState() => _MbuyStudioScreenState();
}

class _MbuyStudioScreenState extends ConsumerState<MbuyStudioScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;
  String _statusMessage = '';
  String? _generatedImageUrl;

  final Map<String, List<Map<String, dynamic>>> _sections = {
    'توليد صور': [
      {
        'title': 'صور منتجات',
        'icon': Icons.image,
        'taskType': 'image_product',
        'badge': 'AI',
      },
      {
        'title': 'خلفيات',
        'icon': Icons.wallpaper,
        'taskType': 'image_background',
        'badge': 'AI',
      },
      {
        'title': 'شعارات',
        'icon': Icons.branding_watermark,
        'taskType': 'image_logo',
        'badge': 'AI',
      },
      {
        'title': 'إعلانات',
        'icon': Icons.ad_units,
        'taskType': 'image_ad',
        'badge': 'AI',
      },
      {
        'title': 'تحسين صور',
        'icon': Icons.auto_fix_high,
        'taskType': 'image_enhance',
        'badge': 'AI',
      },
      {
        'title': 'إزالة خلفية',
        'icon': Icons.layers_clear,
        'taskType': 'image_remove_bg',
        'badge': 'AI',
      },
    ],
    'توليد فيديو': [
      {
        'title': 'فيديو ترويجي',
        'icon': Icons.video_library,
        'taskType': 'video_promo',
        'badge': 'AI',
      },
      {
        'title': 'ريلز / تيك توك',
        'icon': Icons.movie_creation,
        'taskType': 'video_reels',
        'badge': 'AI',
      },
      {
        'title': 'شرح منتج',
        'icon': Icons.featured_video,
        'taskType': 'video_explainer',
        'badge': 'AI',
      },
      {
        'title': 'قصص (Stories)',
        'icon': Icons.history_edu,
        'taskType': 'video_stories',
        'badge': 'AI',
      },
    ],
    'توليد 3D': [
      {
        'title': 'نموذج 3D',
        'icon': Icons.view_in_ar,
        'taskType': '3d_model',
        'badge': 'AI',
      },
      {
        'title': 'عرض 360',
        'icon': Icons.threesixty,
        'taskType': '3d_360',
        'badge': 'AI',
      },
      {
        'title': 'تغليف منتج',
        'icon': Icons.inventory_2,
        'taskType': '3d_packaging',
        'badge': 'AI',
      },
    ],
  };

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MBUY Studio',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 20),
            ..._sections.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSectionGrid(entry.value),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'استوديو الإبداع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'صمم صور وفيديوهات احترافية لمتجرك باستخدام الذكاء الاصطناعي',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            if (item.containsKey('taskType')) {
              _showGenerateDialog(taskType: item['taskType']);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('قريباً: ${item['title']}')),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item['icon'], size: 32, color: Colors.black87),
                      const SizedBox(height: 8),
                      Text(
                        item['title'],
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (item.containsKey('badge'))
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['badge'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGenerateDialog({String taskType = 'image_product'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'توليد محتوى إبداعي',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                hintText: 'اكتب وصف الصورة أو الفيديو...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            if (_isGenerating) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(_statusMessage),
            ] else if (_generatedImageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _generatedImageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(_statusMessage, style: const TextStyle(color: Colors.green)),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _startCloudflareGeneration(taskType),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A11CB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('توليد الآن'),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _startCloudflareGeneration(String taskType) async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _statusMessage = 'جاري الإبداع...';
      _generatedImageUrl = null;
    });

    try {
      final service = ref.read(mbuyStudioServiceProvider);
      final result = await service.generateCloudflareContent(
        taskType: taskType,
        prompt: _promptController.text,
      );

      setState(() {
        _isGenerating = false;
        _statusMessage = 'تم الانتهاء!';
        if (result['result'] != null && result['result']['image'] != null) {
          _generatedImageUrl = result['result']['image'];
        }
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _statusMessage = 'حدث خطأ: $e';
      });
    }
  }
}
