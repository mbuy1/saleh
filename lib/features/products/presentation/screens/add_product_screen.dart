import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../../../shared/widgets/exports.dart';
import '../../../../core/services/auth_token_storage.dart';
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
        const SnackBar(
          content: Text('يمكنك اختيار فيديو واحد فقط'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5), // حد أقصى 5 دقائق
      );

      if (video != null) {
        // التحقق من حجم الفيديو (حد أقصى 100 MB)
        final videoFile = File(video.path);
        final videoSize = await videoFile.length();
        final videoSizeMB = videoSize / (1024 * 1024);

        if (videoSizeMB > 100) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'حجم الفيديو كبير جداً (${videoSizeMB.toStringAsFixed(1)} MB). الحد الأقصى 100 MB',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }

        setState(() => _selectedVideo = video);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم اختيار الفيديو (${videoSizeMB.toStringAsFixed(1)} MB)',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      String errorMessage = 'فشل اختيار الفيديو';

      if (e.toString().contains('permission')) {
        errorMessage =
            'لا توجد صلاحية للوصول إلى المعرض. يرجى السماح بالوصول من إعدادات التطبيق';
      } else if (e.toString().contains('cancelled')) {
        errorMessage = 'تم إلغاء اختيار الفيديو';
      } else {
        errorMessage = 'خطأ في اختيار الفيديو: $e';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
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
                content: Text(
                  'فشل الحصول على روابط الرفع: $e\nسيتم إضافة المنتج بدون صور',
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 5),
              ),
            );
          }
          // متابعة بدون صور بدلاً من إيقاف العملية
          uploadUrls = [];
        }

        // 2. رفع الملفات
        final tempMediaList = <Map<String, dynamic>>[];
        int uploadedCount = 0;

        for (var i = 0; i < _selectedImages.length; i++) {
          if (i >= uploadUrls.length) break; // تحقق من وجود upload URL

          final image = _selectedImages[i];
          final uploadData = uploadUrls[i];

          try {
            // قراءة بيانات الصورة
            final imageBytes = await image.readAsBytes();

            // تحديد Content-Type حسب نوع الملف
            String contentType = 'image/jpeg';
            if (image.path.endsWith('.png')) {
              contentType = 'image/png';
            } else if (image.path.endsWith('.webp')) {
              contentType = 'image/webp';
            } else if (image.path.endsWith('.gif')) {
              contentType = 'image/gif';
            }

            // رفع الصورة مباشرة إلى Worker endpoint (R2)
            final uploadResponse = await http.post(
              Uri.parse(uploadData['uploadUrl']),
              headers: {
                'Content-Type': contentType,
                'Authorization':
                    'Bearer ${await ref.read(authTokenStorageProvider).getAccessToken()}',
              },
              body: imageBytes,
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
                content: Text('فشل رفع الصور. سيتم إضافة المنتج بدون صور'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
          // متابعة بدلاً من إيقاف العملية
        }

        // رفع الفيديو إذا وجد
        if (_selectedVideo != null &&
            uploadUrls.length > _selectedImages.length) {
          final videoUploadData = uploadUrls[_selectedImages.length];

          try {
            // عرض رسالة بدء الرفع
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('جارٍ رفع الفيديو...'),
                    ],
                  ),
                  duration: Duration(seconds: 30),
                ),
              );
            }

            final videoBytes = await _selectedVideo!.readAsBytes();

            // تحديد Content-Type حسب نوع الملف
            String videoContentType = 'video/mp4';
            final videoPath = _selectedVideo!.path.toLowerCase();
            if (videoPath.endsWith('.webm')) {
              videoContentType = 'video/webm';
            } else if (videoPath.endsWith('.mov')) {
              videoContentType = 'video/quicktime';
            } else if (videoPath.endsWith('.avi')) {
              videoContentType = 'video/x-msvideo';
            } else if (videoPath.endsWith('.mkv')) {
              videoContentType = 'video/x-matroska';
            } else if (videoPath.endsWith('.3gp')) {
              videoContentType = 'video/3gpp';
            }

            // رفع الفيديو مباشرة إلى Worker endpoint (R2)
            final videoUploadResponse = await http.post(
              Uri.parse(videoUploadData['uploadUrl']),
              headers: {
                'Content-Type': videoContentType,
                'Authorization':
                    'Bearer ${await ref.read(authTokenStorageProvider).getAccessToken()}',
              },
              body: videoBytes,
            );

            if (videoUploadResponse.statusCode >= 200 &&
                videoUploadResponse.statusCode < 300) {
              tempMediaList.add({
                'type': 'video',
                'url': videoUploadData['publicUrl'],
                'is_main': false,
                'sort_order': _selectedImages.length,
              });

              // إخفاء رسالة التحميل وعرض رسالة النجاح
              if (mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('تم رفع الفيديو بنجاح'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'فشل رفع الفيديو: ${videoUploadResponse.statusCode}\nالرجاء المحاولة مرة أخرى',
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 4),
                    action: SnackBarAction(
                      label: 'حسناً',
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                );
              }
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              String errorMessage = 'خطأ في رفع الفيديو';
              if (e.toString().contains('timeout') ||
                  e.toString().contains('TimeoutException')) {
                errorMessage =
                    'انتهت مهلة رفع الفيديو. قد يكون الفيديو كبيراً جداً أو الاتصال بطيء';
              } else if (e.toString().contains('connection')) {
                errorMessage = 'خطأ في الاتصال. تحقق من اتصال الإنترنت';
              } else {
                errorMessage = 'خطأ في رفع الفيديو: $e';
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                    label: 'حسناً',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            }
          }
        }

        // تعيين mediaList فقط إذا تم رفع شيء
        if (tempMediaList.isNotEmpty) {
          mediaList = tempMediaList;

          for (var i = 0; i < mediaList.length; i++) {}
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
    return MbuyScaffold(
      showAppBar: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: AppDimensions.screenPadding,
            children: [
              _buildSubPageHeader(context, 'إضافة منتج جديد'),
              // اسم المنتج
              MbuyInputField(
                controller: _nameController,
                label: 'اسم المنتج *',
                hint: 'مثال: هاتف آيفون 15',
                prefixIcon: const Icon(
                  Icons.inventory_2,
                  color: AppTheme.textSecondaryColor,
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
              const SizedBox(height: AppDimensions.spacing16),

              // التصنيف
              DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: 'التصنيف *',
                  hintText: 'اختر التصنيف',
                  prefixIcon: const Icon(
                    Icons.category,
                    color: AppTheme.textSecondaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
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
                  padding: EdgeInsets.only(top: AppDimensions.spacing8),
                  child: Text(
                    'جاري تحميل التصنيفات...',
                    style: TextStyle(
                      fontSize: AppDimensions.fontCaption,
                      color: AppTheme.textHintColor,
                    ),
                  ),
                ),
              const SizedBox(height: AppDimensions.spacing16),

              // قسم الصور
              MbuyCard(
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.photo_library,
                          size: AppDimensions.iconS,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: AppDimensions.spacing8),
                        const Text(
                          'صور المنتج *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimensions.fontBody,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_selectedImages.length}/4',
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: AppDimensions.fontBody2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacing12),
                    if (_selectedImages.isEmpty)
                      Center(
                        child: TextButton.icon(
                          onPressed: _pickImages,
                          icon: const Icon(
                            Icons.add_photo_alternate,
                            color: AppTheme.accentColor,
                          ),
                          label: const Text(
                            'اختر صور (حتى 4 صور)',
                            style: TextStyle(color: AppTheme.accentColor),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: AppDimensions.spacing8,
                        runSpacing: AppDimensions.spacing8,
                        children: [
                          ..._selectedImages.asMap().entries.map((entry) {
                            final index = entry.key;
                            final image = entry.value;
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusM,
                                  ),
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
                                      decoration: const BoxDecoration(
                                        color: AppTheme.errorColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: AppDimensions.iconXS,
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
                                        horizontal: AppDimensions.spacing6,
                                        vertical: AppDimensions.spacing2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentColor,
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusXS,
                                        ),
                                      ),
                                      child: const Text(
                                        'رئيسية',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: AppDimensions.fontCaption,
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
                                  border: Border.all(
                                    color: AppTheme.dividerColor,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusM,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppTheme.textHintColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // قسم الفيديو
              MbuyCard(
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.videocam,
                          size: AppDimensions.iconS,
                          color: AppTheme.textSecondaryColor,
                        ),
                        SizedBox(width: AppDimensions.spacing8),
                        Text(
                          'فيديو المنتج (اختياري)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimensions.fontBody,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacing12),
                    if (_selectedVideo == null)
                      Center(
                        child: TextButton.icon(
                          onPressed: _pickVideo,
                          icon: const Icon(
                            Icons.video_library,
                            color: AppTheme.accentColor,
                          ),
                          label: const Text(
                            'اختر فيديو',
                            style: TextStyle(color: AppTheme.accentColor),
                          ),
                        ),
                      )
                    else
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam,
                            size: AppDimensions.iconL,
                            color: AppTheme.accentColor,
                          ),
                          const SizedBox(width: AppDimensions.spacing12),
                          Expanded(
                            child: Text(
                              _selectedVideo!.name,
                              style: const TextStyle(
                                fontSize: AppDimensions.fontBody2,
                                color: AppTheme.textPrimaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: _removeVideo,
                            icon: const Icon(
                              Icons.delete,
                              color: AppTheme.errorColor,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // الوصف
              MbuyInputField(
                controller: _descriptionController,
                label: 'الوصف',
                hint: 'وصف تفصيلي للمنتج',
                prefixIcon: const Icon(
                  Icons.description,
                  color: AppTheme.textSecondaryColor,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // السعر
              MbuyInputField(
                controller: _priceController,
                label: 'السعر (ر.س) *',
                hint: '0.00',
                prefixIcon: const Icon(
                  Icons.monetization_on,
                  color: AppTheme.textSecondaryColor,
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
              const SizedBox(height: AppDimensions.spacing16),

              // المخزون
              MbuyInputField(
                controller: _stockController,
                label: 'المخزون *',
                hint: '0',
                prefixIcon: const Icon(
                  Icons.inventory,
                  color: AppTheme.textSecondaryColor,
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
              const SizedBox(height: AppDimensions.spacing24),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: MbuyButton(
                      label: 'إلغاء',
                      onPressed: _isSubmitting ? null : () => context.pop(),
                      type: MbuyButtonType.secondary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing16),
                  Expanded(
                    flex: 2,
                    child: MbuyButton(
                      label: _isSubmitting ? 'جاري الإضافة...' : 'إضافة المنتج',
                      onPressed: _isSubmitting ? null : _submitForm,
                      isLoading: _isSubmitting,
                      icon: Icons.add,
                      type: MbuyButtonType.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubPageHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: AppDimensions.iconS,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontHeadline,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          const SizedBox(width: AppDimensions.iconM + AppDimensions.spacing16),
        ],
      ),
    );
  }
}
