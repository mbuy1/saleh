import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../data/products_controller.dart';
import '../../data/categories_repository.dart';
import '../../data/products_repository.dart';
import '../../domain/models/category.dart';

/// شاشة إضافة منتج جديد
class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  bool _isSubmitting = false;
  List<Category> _categories = [];
  bool _loadingCategories = false;
  String? _selectedCategoryId;

  // وسائط المنتج
  final List<XFile> _selectedImages = [];
  XFile? _selectedVideo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  /// جلب التصنيفات من API
  Future<void> _loadCategories() async {
    setState(() => _loadingCategories = true);

    try {
      final categoriesRepo = ref.read(categoriesRepositoryProvider);
      final categories = await categoriesRepo.getCategories();

      if (mounted) {
        setState(() {
          _categories = categories;
          _loadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingCategories = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل جلب التصنيفات: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  /// اختيار صور المنتج
  Future<void> _pickImages() async {
    if (_selectedImages.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يمكنك اختيار 4 صور كحد أقصى')),
      );
      return;
    }

    try {
      final images = await _picker.pickMultiImage();
      setState(() {
        final remaining = 4 - _selectedImages.length;
        _selectedImages.addAll(images.take(remaining));
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل اختيار الصور: $e')));
    }
  }

  /// اختيار فيديو المنتج
  Future<void> _pickVideo() async {
    if (_selectedVideo != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يمكنك اختيار فيديو واحد فقط')),
      );
      return;
    }

    try {
      final video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() => _selectedVideo = video);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل اختيار الفيديو: $e')));
    }
  }

  /// حذف صورة
  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  /// حذف الفيديو
  void _removeVideo() {
    setState(() => _selectedVideo = null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // التحقق من اختيار التصنيف
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار التصنيف'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      List<Map<String, dynamic>>? mediaList;

      // إذا كانت هناك صور أو فيديو، نرفعها
      if (_selectedImages.isNotEmpty || _selectedVideo != null) {
        // 1. طلب روابط رفع الوسائط
        final productsRepo = ref.read(productsRepositoryProvider);
        final files = <Map<String, String>>[];

        for (var _ in _selectedImages) {
          files.add({'type': 'image'});
        }
        if (_selectedVideo != null) {
          files.add({'type': 'video'});
        }

        List<Map<String, dynamic>> uploadUrls;
        try {
          uploadUrls = await productsRepo.getUploadUrls(files: files);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل الحصول على روابط الرفع: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
          return;
        }

        // 2. رفع الملفات
        final tempMediaList = <Map<String, dynamic>>[];
        int uploadedCount = 0;

        for (var i = 0; i < _selectedImages.length; i++) {
          final image = _selectedImages[i];
          final uploadData = uploadUrls[i];

          try {
            // رفع الصورة
            final imageBytes = await image.readAsBytes();
            final uploadResponse = await http.post(
              Uri.parse(uploadData['uploadUrl']),
              body: imageBytes,
              headers: {'Content-Type': 'image/jpeg'},
            );

            if (uploadResponse.statusCode >= 200 &&
                uploadResponse.statusCode < 300) {
              tempMediaList.add({
                'type': 'image',
                'url': uploadData['publicUrl'],
                'is_main': i == 0, // أول صورة هي الرئيسية
                'sort_order': i,
              });
              uploadedCount++;
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'فشل رفع الصورة ${i + 1}: ${uploadResponse.statusCode}',
                    ),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('خطأ في رفع الصورة ${i + 1}: $e'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          }
        }

        // التحقق من رفع صورة واحدة على الأقل إذا كان المستخدم اختار صور
        if (_selectedImages.isNotEmpty && uploadedCount == 0) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('فشل رفع جميع الصور. الرجاء المحاولة مرة أخرى'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
              ),
            );
          }
          return;
        }

        // رفع الفيديو إذا وجد
        if (_selectedVideo != null &&
            uploadUrls.length > _selectedImages.length) {
          final videoUploadData = uploadUrls[_selectedImages.length];

          try {
            final videoBytes = await _selectedVideo!.readAsBytes();

            final videoUploadResponse = await http.post(
              Uri.parse(videoUploadData['uploadUrl']),
              body: videoBytes,
              headers: {'Content-Type': 'video/mp4'},
            );

            if (videoUploadResponse.statusCode >= 200 &&
                videoUploadResponse.statusCode < 300) {
              tempMediaList.add({
                'type': 'video',
                'url': videoUploadData['publicUrl'],
                'is_main': false,
                'sort_order': _selectedImages.length,
              });
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'فشل رفع الفيديو: ${videoUploadResponse.statusCode}',
                    ),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('خطأ في رفع الفيديو: $e'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          }
        }

        // تعيين mediaList فقط إذا تم رفع شيء
        if (tempMediaList.isNotEmpty) {
          mediaList = tempMediaList;
        }
      }

      // 3. إنشاء المنتج مع الوسائط
      final success = await ref
          .read(productsControllerProvider.notifier)
          .addProduct(
            name: _nameController.text.trim(),
            price: double.parse(_priceController.text),
            stock: int.parse(_stockController.text),
            categoryId: _selectedCategoryId,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            media: mediaList,
          );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إضافة المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // العودة إلى قائمة المنتجات
      } else {
        final errorMessage =
            ref.read(productsControllerProvider).errorMessage ??
            'فشل إضافة المنتج';

        // معالجة أخطاء التصنيف
        String displayMessage = errorMessage;
        if (errorMessage.contains('Category is required') ||
            errorMessage.contains('CATEGORY_REQUIRED')) {
          displayMessage = 'الرجاء اختيار التصنيف';
        } else if (errorMessage.contains('category does not exist') ||
            errorMessage.contains('CATEGORY_NOT_FOUND')) {
          displayMessage = 'التصنيف المختار غير موجود. يرجى تحديث القائمة';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(displayMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // معالجة أي أخطاء غير متوقعة
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ غير متوقع: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج جديد'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // اسم المنتج
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم المنتج *',
                hintText: 'مثال: هاتف آيفون 15',
                prefixIcon: Icon(Icons.inventory_2),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال اسم المنتج';
                }
                if (value.trim().length < 3) {
                  return 'يجب أن يكون الاسم 3 أحرف على الأقل';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // التصنيف
            DropdownButtonFormField<String>(
              initialValue: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: 'التصنيف *',
                hintText: 'اختر التصنيف',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _loadingCategories
                  ? []
                  : _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
              onChanged: _loadingCategories
                  ? null
                  : (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء اختيار التصنيف';
                }
                return null;
              },
            ),
            if (_loadingCategories)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'جاري تحميل التصنيفات...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),

            // قسم الصور
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.photo_library, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'صور المنتج *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_selectedImages.length}/4',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_selectedImages.isEmpty)
                      Center(
                        child: TextButton.icon(
                          onPressed: _pickImages,
                          icon: const Icon(Icons.add_photo_alternate),
                          label: const Text('اختر صور (حتى 4 صور)'),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ..._selectedImages.asMap().entries.map((entry) {
                            final index = entry.key;
                            final image = entry.value;
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(image.path),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                if (index == 0)
                                  Positioned(
                                    bottom: 4,
                                    left: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'رئيسية',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                          if (_selectedImages.length < 4)
                            GestureDetector(
                              onTap: _pickImages,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // قسم الفيديو
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.videocam, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'فيديو المنتج (اختياري)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_selectedVideo == null)
                      Center(
                        child: TextButton.icon(
                          onPressed: _pickVideo,
                          icon: const Icon(Icons.video_library),
                          label: const Text('اختر فيديو'),
                        ),
                      )
                    else
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam,
                            size: 40,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedVideo!.name,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: _removeVideo,
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // الوصف
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                hintText: 'وصف تفصيلي للمنتج',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // السعر
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'السعر (ر.س) *',
                hintText: '0.00',
                prefixIcon: Icon(Icons.monetization_on),
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال السعر';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'يجب أن يكون السعر أكبر من 0';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // المخزون
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'المخزون *',
                hintText: '0',
                prefixIcon: Icon(Icons.inventory),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال كمية المخزون';
                }
                final stock = int.tryParse(value);
                if (stock == null || stock < 0) {
                  return 'يجب أن يكون المخزون 0 أو أكبر';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 24),

            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : () => context.pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add),
                    label: Text(
                      _isSubmitting ? 'جاري الإضافة...' : 'إضافة المنتج',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
