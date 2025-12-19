import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';

/// خدمة إدارة نتائج AI - حفظ وتطبيق
class AiResultsService {
  final ApiService _api;

  AiResultsService(this._api);

  /// حفظ الصورة في الجوال
  Future<String> saveImageToDevice(String imageUrl, String fileName) async {
    try {
      debugPrint('[AiResultsService] Downloading image: $imageUrl');
      final response = await http
          .get(Uri.parse(imageUrl))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('فشل تحميل الصورة: ${response.statusCode}');
      }

      final directory = await getApplicationDocumentsDirectory();
      final aiFolder = Directory('${directory.path}/ai_generated');
      if (!await aiFolder.exists()) {
        await aiFolder.create(recursive: true);
      }

      final filePath = '${aiFolder.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      debugPrint('[AiResultsService] Image saved to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('[AiResultsService] Save error: $e');
      throw Exception('فشل حفظ الصورة: $e');
    }
  }

  /// حفظ في المفضلة
  Future<bool> saveToFavorites({
    required String type,
    required String url,
    String? prompt,
  }) async {
    try {
      debugPrint('[AiResultsService] Saving to favorites: $type');
      final response = await _api.post(
        '/secure/ai/favorites',
        body: {'type': type, 'url': url, if (prompt != null) 'prompt': prompt},
      );

      debugPrint(
        '[AiResultsService] Favorites response: ${response.statusCode}',
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('[AiResultsService] Favorites error: $e');
      return false;
    }
  }

  /// تطبيق الشعار على المتجر
  Future<bool> applyLogoToStore({
    required String storeId,
    required String logoUrl,
  }) async {
    try {
      debugPrint('[AiResultsService] Applying logo to store: $storeId');
      final response = await _api.put(
        '/secure/stores/$storeId',
        body: {'logo_url': logoUrl},
      );

      debugPrint(
        '[AiResultsService] Apply logo response: ${response.statusCode}',
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['ok'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('[AiResultsService] Apply logo error: $e');
      return false;
    }
  }

  /// تطبيق البانر على المتجر
  Future<bool> applyBannerToStore({
    required String storeId,
    required String bannerUrl,
  }) async {
    try {
      debugPrint('[AiResultsService] Applying banner to store: $storeId');
      final response = await _api.put(
        '/secure/stores/$storeId',
        body: {'banner_url': bannerUrl},
      );

      debugPrint(
        '[AiResultsService] Apply banner response: ${response.statusCode}',
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['ok'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('[AiResultsService] Apply banner error: $e');
      return false;
    }
  }
}

/// Provider
final aiResultsServiceProvider = Provider<AiResultsService>((ref) {
  final api = ref.watch(apiServiceProvider);
  return AiResultsService(api);
});

/// دالة مساعدة لعرض خيارات الحفظ
void showAiResultActions({
  required BuildContext context,
  required String imageUrl,
  required String type,
  required WidgetRef ref,
  String? prompt,
  String? storeId,
  VoidCallback? onApplied,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AiResultActionsSheet(
      imageUrl: imageUrl,
      type: type,
      ref: ref,
      prompt: prompt,
      storeId: storeId,
      onApplied: onApplied,
    ),
  );
}

class _AiResultActionsSheet extends StatefulWidget {
  final String imageUrl;
  final String type;
  final String? prompt;
  final String? storeId;
  final VoidCallback? onApplied;
  final WidgetRef ref;

  const _AiResultActionsSheet({
    required this.imageUrl,
    required this.type,
    required this.ref,
    this.prompt,
    this.storeId,
    this.onApplied,
  });

  @override
  State<_AiResultActionsSheet> createState() => _AiResultActionsSheetState();
}

class _AiResultActionsSheetState extends State<_AiResultActionsSheet> {
  bool _isLoading = false;
  String? _loadingAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'خيارات الحفظ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Preview
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 100,
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Options
          if (widget.storeId != null) ...[
            _buildOption(
              icon: Icons.store,
              title: widget.type == 'logo'
                  ? 'تطبيق كشعار للمتجر'
                  : 'تطبيق كبانر للمتجر',
              color: Colors.blue,
              action: 'apply',
              onTap: _applyToStore,
            ),
            const SizedBox(height: 10),
          ],

          _buildOption(
            icon: Icons.favorite,
            title: 'حفظ في المفضلة',
            color: Colors.red,
            action: 'favorite',
            onTap: _saveToFavorites,
          ),
          const SizedBox(height: 10),

          _buildOption(
            icon: Icons.download,
            title: 'حفظ في الجوال',
            color: Colors.green,
            action: 'download',
            onTap: _saveToDevice,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required Color color,
    required String action,
    required VoidCallback onTap,
  }) {
    final isThisLoading = _isLoading && _loadingAction == action;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isThisLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color,
                        ),
                      )
                    : Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _applyToStore() async {
    setState(() {
      _isLoading = true;
      _loadingAction = 'apply';
    });

    try {
      final service = widget.ref.read(aiResultsServiceProvider);
      bool success = false;

      if (widget.type == 'logo') {
        success = await service.applyLogoToStore(
          storeId: widget.storeId!,
          logoUrl: widget.imageUrl,
        );
      } else {
        success = await service.applyBannerToStore(
          storeId: widget.storeId!,
          bannerUrl: widget.imageUrl,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        _showResult(success ? '✅ تم التطبيق بنجاح!' : '❌ فشل التطبيق');
        if (success) widget.onApplied?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showResult('❌ خطأ: $e');
      }
    }
  }

  Future<void> _saveToFavorites() async {
    setState(() {
      _isLoading = true;
      _loadingAction = 'favorite';
    });

    try {
      final service = widget.ref.read(aiResultsServiceProvider);
      final success = await service.saveToFavorites(
        type: widget.type,
        url: widget.imageUrl,
        prompt: widget.prompt,
      );

      if (mounted) {
        Navigator.pop(context);
        _showResult(
          success
              ? '✅ تم الحفظ في المفضلة!'
              : '❌ فشل الحفظ (قد يكون الجدول غير موجود)',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showResult('❌ خطأ: $e');
      }
    }
  }

  Future<void> _saveToDevice() async {
    setState(() {
      _isLoading = true;
      _loadingAction = 'download';
    });

    try {
      final service = widget.ref.read(aiResultsServiceProvider);
      final fileName =
          '${widget.type}_${DateTime.now().millisecondsSinceEpoch}.png';
      final path = await service.saveImageToDevice(widget.imageUrl, fileName);

      if (mounted) {
        Navigator.pop(context);
        _showResult('✅ تم الحفظ:\n$path');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showResult('❌ فشل التنزيل: $e');
      }
    }
  }

  void _showResult(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('✅') ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
