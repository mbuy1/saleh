import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import '../../../../shared/widgets/exports.dart';
import '../../../../core/services/auth_token_storage.dart';
import '../../data/products_controller.dart';
import '../../data/categories_repository.dart';
import '../../data/products_repository.dart';
import '../../domain/models/category.dart';
import '../../../merchant/data/merchant_store_provider.dart';

/// شاشة إضافة منتج جديد
class AddProductScreen extends ConsumerStatefulWidget {
  final String? productType;
  const AddProductScreen({super.key, this.productType});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _subCategoryController = TextEditingController();
  final _weightController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _keywordsController = TextEditingController();
  final _wholesalePriceController = TextEditingController();
  final _slaDaysController = TextEditingController();

  bool _isSubmitting = false;
  List<Category> _categories = [];
  bool _loadingCategories = false;
  String? _selectedCategoryId;
  bool _dropshippingEnabled = false;

  // وسائط المنتج
  final List<XFile> _selectedImages = [];
  XFile? _selectedVideo;
  final ImagePicker _picker = ImagePicker();

  // بيانات التخصيص الإضافية
  final Map<String, dynamic> _extraData = {};

  @override
  void initState() {
    super.initState();
    if (widget.productType != null) {
      _extraData['product_type'] = widget.productType;
    }
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
    _subCategoryController.dispose();
    _weightController.dispose();
    _prepTimeController.dispose();
    _keywordsController.dispose();
    _wholesalePriceController.dispose();
    _slaDaysController.dispose();
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

        // فصل روابط الصور عن الفيديو
        final imageUploadUrls = uploadUrls
            .where((u) => u['type'] == 'image')
            .toList();
        final videoUploadUrls = uploadUrls
            .where((u) => u['type'] == 'video')
            .toList();

        for (var i = 0; i < _selectedImages.length; i++) {
          if (i >= imageUploadUrls.length) {
            break;
          }

          final image = _selectedImages[i];
          final uploadData = imageUploadUrls[i];

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
        if (_selectedVideo != null && videoUploadUrls.isNotEmpty) {
          final videoUploadData = videoUploadUrls.first;

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
                  SnackBar(
                    content: Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.checkCircle,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('تم رفع الفيديو بنجاح'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
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
        }
      }

      // 3. إنشاء المنتج مع الوسائط
      // إضافة الحقول الجديدة إلى extraData
      if (_subCategoryController.text.isNotEmpty) {
        _extraData['sub_category'] = _subCategoryController.text;
      }
      if (_weightController.text.isNotEmpty) {
        _extraData['weight'] = double.tryParse(_weightController.text);
      }
      if (_prepTimeController.text.isNotEmpty) {
        _extraData['preparation_time'] = int.tryParse(_prepTimeController.text);
      }
      if (_keywordsController.text.isNotEmpty) {
        _extraData['seo_keywords'] = _keywordsController.text
            .split(',')
            .map((e) => e.trim())
            .toList();
      }

      // بيانات الدروب شوبينق
      if (_dropshippingEnabled) {
        _extraData['dropship_enabled'] = true;
        if (_wholesalePriceController.text.isNotEmpty) {
          _extraData['wholesale_price'] = double.tryParse(
            _wholesalePriceController.text,
          );
        }
        if (_slaDaysController.text.isNotEmpty) {
          _extraData['sla_days'] = int.tryParse(_slaDaysController.text);
        }
        // NOTE: سياسة الإرجاع ستُضاف عند توفر الحقل في قاعدة البيانات
        // _extraData['return_policy'] = ...;
      }

      final success = await ref
          .read(productsControllerProvider.notifier)
          .addProduct(
            name: _nameController.text.trim(),
            price: double.parse(_priceController.text),
            stock: int.tryParse(_stockController.text) ?? 0,
            categoryId: _selectedCategoryId,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            media: mediaList,
            extraData: _extraData.isNotEmpty ? _extraData : null,
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
    final storeState = ref.watch(merchantStoreProvider);
    final settings = storeState?.settings ?? {};

    final showSubCategory = settings['show_subcategory_field'] == true;
    final showWeight = settings['show_weight_field'] == true;
    final showPrepTime = settings['show_preparation_time_field'] == true;
    final showSeoKeywords = settings['show_seo_keywords_field'] == true;

    return MbuyScaffold(
      showAppBar: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: AppDimensions.screenPadding,
            child: Column(
              children: [
                _buildSubPageHeader(context, 'إضافة منتج جديد'),

                // 1. كرت إضافة الصور والفيديو (مدمج)
                _buildUnifiedMediaSection(),
                const SizedBox(height: AppDimensions.spacing16),

                // 2. اسم المنتج
                MbuyInputField(
                  controller: _nameController,
                  label: 'اسم المنتج *',
                  hint: 'مثال: هاتف آيفون 15',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      AppIcons.inventory2,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppTheme.textSecondaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
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

                // 3. سعر المنتج
                MbuyInputField(
                  controller: _priceController,
                  label: 'السعر (ر.س) *',
                  hint: '0.00',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      AppIcons.monetization,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppTheme.textSecondaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
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

                // 4. التصنيف الأساسي
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'التصنيف *',
                    hintText: 'اختر التصنيف',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        AppIcons.category,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          AppTheme.textSecondaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                  ),
                  items: _loadingCategories
                      ? []
                      : _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.id,
                            child: Text(
                              category.getLocalizedName(
                                Localizations.localeOf(context).languageCode,
                              ),
                            ),
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

                // 5. التصنيف الفرعي (اختياري)
                if (showSubCategory) ...[
                  MbuyInputField(
                    controller: _subCategoryController,
                    label: 'التصنيف الفرعي (اختياري)',
                    hint: 'مثال: هواتف ذكية',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        AppIcons.subdirectory,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          AppTheme.textSecondaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                ],

                // 6. الكمية المتوفرة (اختياري)
                MbuyInputField(
                  controller: _stockController,
                  label: 'الكمية المتوفرة (اختياري)',
                  hint: '0',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      AppIcons.inventory,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppTheme.textSecondaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // 7. وزن المنتج (اختياري)
                if (showWeight) ...[
                  MbuyInputField(
                    controller: _weightController,
                    label: 'وزن المنتج تقريباً (اختياري)',
                    hint: 'مثال: 0.5 كجم',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        AppIcons.scale,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          AppTheme.textSecondaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                ],

                // مدة التجهيز (اختياري)
                if (showPrepTime) ...[
                  MbuyInputField(
                    controller: _prepTimeController,
                    label: 'مدة تجهيز المنتج (اختياري)',
                    hint: 'مثال: 3 أيام',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        AppIcons.timer,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          AppTheme.textSecondaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                ],

                // زر الذكاء الاصطناعي (قبل الوصف)
                _buildAIButton(),
                const SizedBox(height: AppDimensions.spacing16),

                // 8. الوصف
                MbuyInputField(
                  controller: _descriptionController,
                  label: 'الوصف',
                  hint: 'وصف تفصيلي للمنتج',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      AppIcons.description,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppTheme.textSecondaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppDimensions.spacing16),

                // 9. الكلمات المفتاحية
                if (showSeoKeywords) ...[
                  MbuyInputField(
                    controller: _keywordsController,
                    label: 'الكلمات المفتاحية (SEO)',
                    hint: 'كلمات مفصولة بفاصلة',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        AppIcons.tag,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          AppTheme.textSecondaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                ],

                // 10. تفعيل الدروب شوبينق
                Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          title: const Text(
                            'فعّل للدروب شوبينق',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            'السماح للتجار الآخرين ببيع هذا المنتج',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: _dropshippingEnabled,
                          onChanged: (value) {
                            setState(() {
                              _dropshippingEnabled = value;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                        if (_dropshippingEnabled) ...[
                          const SizedBox(height: 12),
                          MbuyInputField(
                            controller: _wholesalePriceController,
                            label: 'سعر الجملة (ر.س) *',
                            hint: '0.00',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                AppIcons.store,
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  AppTheme.textSecondaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            validator: _dropshippingEnabled
                                ? (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'الرجاء إدخال سعر الجملة';
                                    }
                                    final price = double.tryParse(value);
                                    if (price == null || price <= 0) {
                                      return 'يجب أن يكون السعر أكبر من 0';
                                    }
                                    return null;
                                  }
                                : null,
                          ),
                          const SizedBox(height: 12),
                          MbuyInputField(
                            controller: _slaDaysController,
                            label: 'مدة التجهيز بالأيام *',
                            hint: 'مثال: 3',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                AppIcons.schedule,
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  AppTheme.textSecondaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: _dropshippingEnabled
                                ? (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'الرجاء إدخال مدة التجهيز';
                                    }
                                    final days = int.tryParse(value);
                                    if (days == null || days <= 0) {
                                      return 'يجب أن تكون المدة أكبر من 0';
                                    }
                                    return null;
                                  }
                                : null,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing24),

                // أزرار الإجراءات
                Row(
                  children: [
                    Expanded(
                      child: MbuyButton(
                        text: 'إلغاء',
                        onPressed: _isSubmitting ? null : () => context.pop(),
                        type: MbuyButtonType.secondary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing16),
                    Expanded(
                      flex: 2,
                      child: MbuyButton(
                        text: _isSubmitting
                            ? 'جاري الإضافة...'
                            : 'إضافة المنتج',
                        onPressed: _isSubmitting ? null : _submitForm,
                        isLoading: _isSubmitting,
                        icon: Icons.add,
                        type: MbuyButtonType.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppDimensions.spacing48,
                ), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedMediaSection() {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الوسائط (صور وفيديو)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // عرض الصور المختارة
                  ..._selectedImages.asMap().entries.map((entry) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(entry.value.path),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(entry.key),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                AppIcons.cancel,
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.red,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  // عرض الفيديو المختار
                  if (_selectedVideo != null)
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            AppIcons.videocam,
                            width: 40,
                            height: 40,
                            colorFilter: const ColorFilter.mode(
                              AppTheme.accentColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _removeVideo,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                AppIcons.cancel,
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.red,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  // زر إضافة صورة
                  if (_selectedImages.length < 4)
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          border: Border.all(color: AppTheme.dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppIcons.addPhoto,
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                AppTheme.textHintColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const Text('صورة', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  // زر إضافة فيديو
                  if (_selectedVideo == null)
                    GestureDetector(
                      onTap: _pickVideo,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          border: Border.all(color: AppTheme.dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppIcons.videocam,
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                AppTheme.textHintColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const Text('فيديو', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // كرت توليد الوسائط بالذكاء الاصطناعي
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          child: ListTile(
            leading: SvgPicture.asset(
              AppIcons.autoAwesome,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppTheme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text('توليد وسائط بالذكاء الاصطناعي'),
            subtitle: const Text('قريباً...'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم تفعيل هذه الميزة قريباً')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAIButton() {
    return MbuyButton(
      text: 'توليد الوصف والكلمات المفتاحية بالذكاء الاصطناعي',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('سيتم تفعيل هذه الميزة قريباً')),
        );
      },
      type: MbuyButtonType.secondary,
      icon: Icons.auto_awesome,
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
              child: SvgPicture.asset(
                AppIcons.arrowBack,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
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
          // زر التعديل (يفتح متجرك على جوك)
          GestureDetector(
            onTap: () {
              context.push('/dashboard/store-on-jock');
            },
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: AppDimensions.borderRadiusS,
              ),
              child: SvgPicture.asset(
                AppIcons.edit,
                width: AppDimensions.iconS,
                height: AppDimensions.iconS,
                colorFilter: const ColorFilter.mode(
                  AppTheme.accentColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
