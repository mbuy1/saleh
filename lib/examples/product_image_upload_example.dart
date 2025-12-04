import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/media_service.dart';

/// مثال: كيفية استخدام MediaService لرفع صور المنتجات
///
/// استخدم هذا المثال كمرجع عند تحديث merchant_products_screen.dart

class ProductImageUploadExample extends StatefulWidget {
  const ProductImageUploadExample({super.key});

  @override
  State<ProductImageUploadExample> createState() =>
      _ProductImageUploadExampleState();
}

class _ProductImageUploadExampleState extends State<ProductImageUploadExample> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImageFile;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  /// اختيار صورة من المعرض
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImageFile = File(image.path);
          _uploadedImageUrl = null; // Reset uploaded URL
        });
      }
    } catch (e) {
      _showError('فشل اختيار الصورة: $e');
    }
  }

  /// رفع الصورة إلى Cloudflare Images
  Future<void> _uploadImage() async {
    if (_selectedImageFile == null) {
      _showError('الرجاء اختيار صورة أولاً');
      return;
    }

    setState(() => _isUploading = true);

    try {
      // رفع الصورة عبر MediaService
      final imageUrl = await MediaService.uploadImage(_selectedImageFile!);

      if (imageUrl != null) {
        setState(() {
          _uploadedImageUrl = imageUrl;
          _isUploading = false;
        });

        _showSuccess('تم رفع الصورة بنجاح!');

        // الآن يمكن حفظ imageUrl في database
        // await saveProductToDatabase(imageUrl);
      } else {
        throw Exception('فشل رفع الصورة');
      }
    } catch (e) {
      setState(() => _isUploading = false);
      _showError('خطأ في رفع الصورة: $e');
    }
  }

  /// رفع عدة صور
  Future<void> _uploadMultipleImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isEmpty) return;

      setState(() => _isUploading = true);

      // تحويل XFile إلى File
      final files = images.map((xFile) => File(xFile.path)).toList();

      // رفع جميع الصور
      final urls = await MediaService.uploadImages(files);

      setState(() => _isUploading = false);

      if (urls.isNotEmpty) {
        _showSuccess('تم رفع ${urls.length} صورة بنجاح!');
        // احفظ URLs في database
        // await saveMultipleImagesToDatabase(urls);
      }
    } catch (e) {
      setState(() => _isUploading = false);
      _showError('خطأ في رفع الصور: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رفع صور المنتج')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // عرض الصورة المختارة
            if (_selectedImageFile != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.file(_selectedImageFile!, fit: BoxFit.cover),
              ),

            const SizedBox(height: 16),

            // أزرار الاختيار والرفع
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('اختيار صورة'),
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _isUploading || _selectedImageFile == null
                  ? null
                  : _uploadImage,
              icon: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(_isUploading ? 'جاري الرفع...' : 'رفع الصورة'),
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _isUploading ? null : _uploadMultipleImages,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('رفع عدة صور'),
            ),

            const SizedBox(height: 16),

            // عرض URL المرفوع
            if (_uploadedImageUrl != null) ...[
              const Text(
                'URL الصورة المرفوعة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(_uploadedImageUrl!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// دالة مساعدة: حفظ المنتج مع صورته في database
Future<void> saveProductToDatabase(
  String imageUrl, {
  required String name,
  required double price,
  required String storeId,
}) async {
  // TODO: استبدل هذا بـ API call عبر Supabase
  // await supabaseClient.from('products').insert({
  //   'name': name,
  //   'price': price,
  //   'image_url': imageUrl,
  //   'store_id': storeId,
  // });
}
