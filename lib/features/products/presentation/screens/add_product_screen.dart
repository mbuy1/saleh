import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'dart:math';
import '../../../../shared/widgets/exports.dart';
import '../../../../core/services/auth_token_storage.dart';
import '../../data/products_controller.dart';
import '../../data/categories_repository.dart';
import '../../data/products_repository.dart';
import '../../domain/models/category.dart';
import '../../../merchant/data/merchant_store_provider.dart';

/// أنواع المنتجات المتاحة
enum ProductType {
  physical, // منتج مادي عادي
  digital, // منتج رقمي
  service, // خدمة حسب الطلب
  foodAndBeverage, // أكل ومشروبات
  subscription, // اشتراك
  ticket, // تذكرة/حجز
  customizable, // منتج قابل للتخصيص
}

/// معلومات نوع المنتج
class ProductTypeInfo {
  final ProductType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> specificFields;
  final bool hasStock;
  final bool hasWeight;
  final bool hasDelivery;
  final bool hasPrepTime;
  final bool hasDigitalFile;
  final bool hasVariants;

  const ProductTypeInfo({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.specificFields,
    this.hasStock = true,
    this.hasWeight = false,
    this.hasDelivery = true,
    this.hasPrepTime = false,
    this.hasDigitalFile = false,
    this.hasVariants = false,
  });
}

/// تعريفات أنواع المنتجات
const Map<ProductType, ProductTypeInfo> productTypes = {
  ProductType.physical: ProductTypeInfo(
    type: ProductType.physical,
    name: 'منتج مادي',
    description: 'منتج يتم شحنه للعميل',
    icon: Icons.inventory_2,
    color: Color(0xFF2196F3),
    specificFields: ['weight', 'dimensions', 'shipping'],
    hasStock: true,
    hasWeight: true,
    hasDelivery: true,
    hasVariants: true,
  ),
  ProductType.digital: ProductTypeInfo(
    type: ProductType.digital,
    name: 'منتج رقمي',
    description: 'ملفات، برامج، كتب إلكترونية',
    icon: Icons.cloud_download,
    color: Color(0xFF9C27B0),
    specificFields: ['file_url', 'file_type', 'download_limit'],
    hasStock: false,
    hasWeight: false,
    hasDelivery: false,
    hasDigitalFile: true,
  ),
  ProductType.service: ProductTypeInfo(
    type: ProductType.service,
    name: 'خدمة حسب الطلب',
    description: 'خدمات مثل التصميم، البرمجة، الاستشارات',
    icon: Icons.handyman,
    color: Color(0xFF4CAF50),
    specificFields: ['duration', 'delivery_time', 'revisions'],
    hasStock: false,
    hasWeight: false,
    hasDelivery: false,
    hasPrepTime: true,
  ),
  ProductType.foodAndBeverage: ProductTypeInfo(
    type: ProductType.foodAndBeverage,
    name: 'أكل ومشروبات',
    description: 'وجبات، حلويات، مشروبات',
    icon: Icons.restaurant,
    color: Color(0xFFFF9800),
    specificFields: ['prep_time', 'calories', 'ingredients', 'allergens'],
    hasStock: true,
    hasWeight: true,
    hasDelivery: true,
    hasPrepTime: true,
    hasVariants: true,
  ),
  ProductType.subscription: ProductTypeInfo(
    type: ProductType.subscription,
    name: 'اشتراك',
    description: 'اشتراكات شهرية أو سنوية',
    icon: Icons.autorenew,
    color: Color(0xFF00BCD4),
    specificFields: ['billing_cycle', 'trial_days', 'features'],
    hasStock: false,
    hasWeight: false,
    hasDelivery: false,
  ),
  ProductType.ticket: ProductTypeInfo(
    type: ProductType.ticket,
    name: 'تذكرة / حجز',
    description: 'فعاليات، حجوزات، مواعيد',
    icon: Icons.confirmation_number,
    color: Color(0xFFE91E63),
    specificFields: ['event_date', 'location', 'seats', 'time_slots'],
    hasStock: true,
    hasWeight: false,
    hasDelivery: false,
  ),
  ProductType.customizable: ProductTypeInfo(
    type: ProductType.customizable,
    name: 'منتج قابل للتخصيص',
    description: 'منتجات يمكن للعميل تخصيصها',
    icon: Icons.tune,
    color: Color(0xFF795548),
    specificFields: ['customization_options', 'preview_enabled'],
    hasStock: true,
    hasWeight: true,
    hasDelivery: true,
    hasPrepTime: true,
    hasVariants: true,
  ),
};

/// شاشة إضافة منتج جديد - محسّنة
class AddProductScreen extends ConsumerStatefulWidget {
  final String? productType;
  final String? initialName;
  final String? initialPrice;
  final bool quickAdd;

  const AddProductScreen({
    super.key,
    this.productType,
    this.initialName,
    this.initialPrice,
    this.quickAdd = false,
  });

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _costPriceController = TextEditingController(); // سعر التكلفة
  final _originalPriceController = TextEditingController(); // السعر قبل الخصم
  final _stockController = TextEditingController();
  final _lowStockAlertController =
      TextEditingController(); // تنبيه نفاد المخزون
  final _subCategoryController = TextEditingController();
  final _weightController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _keywordsController = TextEditingController();
  final _wholesalePriceController = TextEditingController();
  final _slaDaysController = TextEditingController();
  final _brandController = TextEditingController(); // العلامة التجارية
  final _mediaUrlController = TextEditingController(); // رابط الوسائط
  final _skuController = TextEditingController(); // رمز المنتج SKU
  final _barcodeController = TextEditingController(); // الباركود
  final _slugController = TextEditingController(); // الرابط المخصص

  // === الحقول الخاصة بأنواع المنتجات ===
  // نوع المنتج المحدد
  ProductType _selectedProductType = ProductType.physical;

  // المنتج الرقمي
  final _fileUrlController = TextEditingController();
  final _downloadLimitController = TextEditingController();
  String _selectedFileType = 'pdf';

  // الخدمات
  final _serviceDurationController = TextEditingController();
  final _deliveryTimeController = TextEditingController();
  final _revisionsController = TextEditingController();

  // أكل ومشروبات
  final _caloriesController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final List<String> _selectedAllergens = [];

  // الاشتراكات
  String _billingCycle = 'monthly';
  final _trialDaysController = TextEditingController();
  final List<String> _subscriptionFeatures = [];
  final _featureInputController = TextEditingController();

  // التذاكر والحجوزات
  DateTime? _eventDate;
  TimeOfDay? _eventTime;
  final _locationController = TextEditingController();
  final _seatsController = TextEditingController();
  // ignore: unused_field
  final List<String> _timeSlots = []; // TODO: سيتم استخدامه لاحقاً

  // المنتجات القابلة للتخصيص
  final List<Map<String, dynamic>> _customizationOptions = [];
  bool _previewEnabled = false;

  // === نهاية الحقول الخاصة ===

  bool _isSubmitting = false;
  bool _hasUnsavedChanges = false; // تتبع التغييرات غير المحفوظة
  // ignore: unused_field
  bool _isDraft = false; // حالة المسودة - TODO: سيتم استخدامه لاحقاً
  int _mainImageIndex = 0; // فهرس الصورة الرئيسية
  final List<String> _mediaUrls = []; // روابط الوسائط المضافة
  List<Category> _categories = [];
  bool _loadingCategories = false;
  String? _selectedCategoryId;
  String? _selectedMbuyCategoryId; // تصنيف mbuy
  String? _selectedWholesaleCategoryId; // تصنيف الجملة

  // قنوات عرض المنتج
  bool _showInStore = true; // المتجر
  bool _showInMbuyApp = true; // تطبيق mbuy
  bool _showInDropshipping = false; // دروب شوبينق

  // التصنيف الفرعي
  String? _selectedSubCategory;
  bool _showCustomSubCategory = false;

  // الكلمات المفتاحية كـ Tags
  final List<String> _keywordTags = [];
  final TextEditingController _keywordInputController = TextEditingController();

  // الحصول على معلومات نوع المنتج الحالي
  ProductTypeInfo get _currentTypeInfo => productTypes[_selectedProductType]!;

  // حساب نسبة اكتمال النموذج
  double get _formCompletionPercentage {
    int completedFields = 0;
    int totalFields = 6;

    if (_nameController.text.isNotEmpty) completedFields++;
    if (_priceController.text.isNotEmpty) completedFields++;
    if (_selectedCategoryId != null) completedFields++;
    if (_selectedImages.isNotEmpty || _mediaUrls.isNotEmpty) completedFields++;
    if (_descriptionController.text.isNotEmpty) completedFields++;

    // حقول إضافية حسب نوع المنتج
    if (_currentTypeInfo.hasStock) {
      totalFields++;
      if (_stockController.text.isNotEmpty) completedFields++;
    }

    return completedFields / totalFields;
  }

  // حساب هامش الربح
  double? get _profitMargin {
    final price = double.tryParse(_priceController.text);
    final cost = double.tryParse(_costPriceController.text);
    if (price != null && cost != null && cost > 0) {
      return ((price - cost) / cost) * 100;
    }
    return null;
  }

  // حساب قيمة الربح
  double? get _profitAmount {
    final price = double.tryParse(_priceController.text);
    final cost = double.tryParse(_costPriceController.text);
    if (price != null && cost != null) {
      return price - cost;
    }
    return null;
  }

  // حساب نسبة الخصم
  double? get _discountPercentage {
    final original = double.tryParse(_originalPriceController.text);
    final current = double.tryParse(_priceController.text);
    if (original != null &&
        current != null &&
        original > 0 &&
        original > current) {
      return ((original - current) / original) * 100;
    }
    return null;
  }

  // توليد SKU تلقائي
  String _generateSKU() {
    final random = Random();
    final prefix = _selectedCategoryId?.substring(0, 3).toUpperCase() ?? 'PRD';
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(8);
    final randomNum = random.nextInt(999).toString().padLeft(3, '0');
    return '$prefix-$timestamp-$randomNum';
  }

  // توليد Slug من اسم المنتج
  String _generateSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
  }

  // قائمة التصنيفات الفرعية الافتراضية
  final List<String> _defaultSubCategories = [
    'هواتف ذكية',
    'إكسسوارات',
    'ملابس رجالية',
    'ملابس نسائية',
    'أحذية',
    'أجهزة إلكترونية',
    'مستحضرات تجميل',
    'أدوات منزلية',
    'طعام ومشروبات',
    'أخرى',
  ];

  // قائمة تصنيفات mbuy
  final List<Map<String, String>> _mbuyCategories = [
    {'id': 'electronics', 'name': 'إلكترونيات'},
    {'id': 'fashion', 'name': 'أزياء وموضة'},
    {'id': 'home', 'name': 'المنزل والمطبخ'},
    {'id': 'beauty', 'name': 'الجمال والعناية'},
    {'id': 'sports', 'name': 'رياضة ولياقة'},
    {'id': 'toys', 'name': 'ألعاب وهدايا'},
    {'id': 'food', 'name': 'طعام ومشروبات'},
    {'id': 'health', 'name': 'صحة وعافية'},
    {'id': 'automotive', 'name': 'سيارات وإكسسوارات'},
    {'id': 'books', 'name': 'كتب وقرطاسية'},
    {'id': 'other', 'name': 'أخرى'},
  ];

  // قائمة تصنيفات الجملة
  final List<Map<String, String>> _wholesaleCategories = [
    {'id': 'retail', 'name': 'تجزئة'},
    {'id': 'wholesale', 'name': 'جملة'},
    {'id': 'semi_wholesale', 'name': 'نصف جملة'},
    {'id': 'b2b', 'name': 'بيع للشركات'},
    {'id': 'bulk', 'name': 'كميات كبيرة'},
  ];

  // وسائط المنتج
  final List<XFile> _selectedImages = [];
  XFile? _selectedVideo;
  final ImagePicker _picker = ImagePicker();

  // بيانات التخصيص الإضافية
  final Map<String, dynamic> _extraData = {};

  @override
  void initState() {
    super.initState();

    // تعيين نوع المنتج من الـ route
    if (widget.productType != null) {
      _selectedProductType = _parseProductType(widget.productType!);
      _extraData['product_type'] = widget.productType;
    }

    // ملء البيانات من الإدراج السريع
    if (widget.quickAdd) {
      if (widget.initialName != null) {
        _nameController.text = widget.initialName!;
      }
      if (widget.initialPrice != null) {
        _priceController.text = widget.initialPrice!;
      }
    }

    _loadCategories();
    _setupListeners();
  }

  /// تحويل اسم نوع المنتج إلى enum
  ProductType _parseProductType(String type) {
    switch (type.toLowerCase()) {
      case 'physical':
        return ProductType.physical;
      case 'digital':
        return ProductType.digital;
      case 'service':
        return ProductType.service;
      case 'foodandbeverage':
        return ProductType.foodAndBeverage;
      case 'subscription':
        return ProductType.subscription;
      case 'ticket':
        return ProductType.ticket;
      case 'customizable':
        return ProductType.customizable;
      default:
        return ProductType.physical;
    }
  }

  // إعداد المستمعين لتتبع التغييرات
  void _setupListeners() {
    final controllers = [
      _nameController,
      _priceController,
      _costPriceController,
      _originalPriceController,
      _stockController,
      _descriptionController,
      _brandController,
    ];

    for (final controller in controllers) {
      controller.addListener(_onFormChanged);
    }

    // توليد Slug تلقائي عند تغيير اسم المنتج
    _nameController.addListener(() {
      if (_slugController.text.isEmpty ||
          _slugController.text ==
              _generateSlug(
                _nameController.text.substring(
                  0,
                  _nameController.text.length > 1
                      ? _nameController.text.length - 1
                      : 0,
                ),
              )) {
        _slugController.text = _generateSlug(_nameController.text);
      }
    });
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  // تأكيد الخروج مع تغييرات غير محفوظة
  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغييرات غير محفوظة'),
        content: const Text(
          'لديك تغييرات غير محفوظة. هل تريد الخروج بدون حفظ؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('البقاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('الخروج'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
              _saveAsDraft();
            },
            child: const Text('حفظ كمسودة'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // حفظ كمسودة
  Future<void> _saveAsDraft() async {
    setState(() => _isDraft = true);

    // حفظ البيانات محلياً
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.save, color: Colors.white),
            SizedBox(width: 8),
            Text('تم حفظ المسودة بنجاح'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );

    setState(() => _hasUnsavedChanges = false);
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
        _hasUnsavedChanges = true;
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
    setState(() {
      _selectedImages.removeAt(index);
      // تعديل فهرس الصورة الرئيسية إذا لزم الأمر
      if (_mainImageIndex >= _selectedImages.length) {
        _mainImageIndex = _selectedImages.isEmpty
            ? 0
            : _selectedImages.length - 1;
      } else if (index < _mainImageIndex) {
        _mainImageIndex--;
      } else if (index == _mainImageIndex && _selectedImages.isNotEmpty) {
        _mainImageIndex = 0;
      }
      _hasUnsavedChanges = true;
    });
  }

  /// تعيين صورة كصورة رئيسية
  // ignore: unused_element
  void _setMainImage(int index) {
    setState(() {
      _mainImageIndex = index;
      _hasUnsavedChanges = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تعيين الصورة الرئيسية'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// إعادة ترتيب الصور
  // ignore: unused_element
  void _reorderImages(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final image = _selectedImages.removeAt(oldIndex);
      _selectedImages.insert(newIndex, image);

      // تحديث فهرس الصورة الرئيسية
      if (_mainImageIndex == oldIndex) {
        _mainImageIndex = newIndex;
      } else if (_mainImageIndex > oldIndex && _mainImageIndex <= newIndex) {
        _mainImageIndex--;
      } else if (_mainImageIndex < oldIndex && _mainImageIndex >= newIndex) {
        _mainImageIndex++;
      }
      _hasUnsavedChanges = true;
    });
  }

  /// حذف الفيديو
  void _removeVideo() {
    setState(() {
      _selectedVideo = null;
      _hasUnsavedChanges = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    _originalPriceController.dispose();
    _stockController.dispose();
    _lowStockAlertController.dispose();
    _subCategoryController.dispose();
    _weightController.dispose();
    _prepTimeController.dispose();
    _keywordsController.dispose();
    _wholesalePriceController.dispose();
    _slaDaysController.dispose();
    _keywordInputController.dispose();
    _brandController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _slugController.dispose();
    // Controllers أنواع المنتجات
    _fileUrlController.dispose();
    _downloadLimitController.dispose();
    _serviceDurationController.dispose();
    _deliveryTimeController.dispose();
    _revisionsController.dispose();
    _caloriesController.dispose();
    _ingredientsController.dispose();
    _trialDaysController.dispose();
    _featureInputController.dispose();
    _locationController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  /// بناء حقل التصنيف الفرعي مع خيار "أخرى"
  Widget _buildSubCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التصنيف الفرعي (اختياري)',
          style: TextStyle(
            fontSize: AppDimensions.fontBody,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dividerColor),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedSubCategory,
            decoration: InputDecoration(
              hintText: 'اختر التصنيف الفرعي',
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
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            items: _defaultSubCategories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSubCategory = value;
                _showCustomSubCategory = value == 'أخرى';
                if (!_showCustomSubCategory) {
                  _subCategoryController.text = value ?? '';
                } else {
                  _subCategoryController.clear();
                }
              });
            },
          ),
        ),
        // حقل إدخال مخصص عند اختيار "أخرى"
        if (_showCustomSubCategory) ...[
          const SizedBox(height: 12),
          MbuyInputField(
            controller: _subCategoryController,
            label: 'أدخل التصنيف الفرعي',
            hint: 'اكتب التصنيف الفرعي هنا...',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                AppIcons.edit,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppTheme.textSecondaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// بناء شريط الكلمات المفتاحية كـ Tags
  Widget _buildKeywordsChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الكلمات المفتاحية (SEO)',
          style: TextStyle(
            fontSize: AppDimensions.fontBody,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dividerColor),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // شريط الكلمات المفتاحية
              if (_keywordTags.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _keywordTags.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: TextStyle(fontSize: AppDimensions.fontLabel),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _keywordTags.remove(tag);
                          _updateKeywordsController();
                        });
                      },
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      deleteIconColor: AppTheme.primaryColor,
                      labelStyle: const TextStyle(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
              // حقل إضافة كلمة مفتاحية جديدة
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _keywordInputController,
                      decoration: InputDecoration(
                        hintText: 'أضف كلمة مفتاحية...',
                        hintStyle: TextStyle(fontSize: AppDimensions.fontBody),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: _addKeyword,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () => _addKeyword(_keywordInputController.text),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'اضغط Enter أو + لإضافة كلمة مفتاحية',
          style: TextStyle(
            fontSize: AppDimensions.fontLabel,
            color: AppTheme.textHintColor,
          ),
        ),
      ],
    );
  }

  void _addKeyword(String keyword) {
    final trimmed = keyword.trim();
    if (trimmed.isNotEmpty && !_keywordTags.contains(trimmed)) {
      setState(() {
        _keywordTags.add(trimmed);
        _keywordInputController.clear();
        _updateKeywordsController();
      });
    }
  }

  void _updateKeywordsController() {
    _keywordsController.text = _keywordTags.join(', ');
  }

  /// بناء شريط أدوات التنسيق للوصف
  Widget _buildDescriptionToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.slate100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusM),
          topRight: Radius.circular(AppDimensions.radiusM),
        ),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildToolbarButton(
              icon: Icons.format_bold,
              tooltip: 'عريض',
              onTap: () => _insertFormatting('**', '**'),
            ),
            _buildToolbarButton(
              icon: Icons.format_italic,
              tooltip: 'مائل',
              onTap: () => _insertFormatting('_', '_'),
            ),
            _buildToolbarButton(
              icon: Icons.format_underlined,
              tooltip: 'تحته خط',
              onTap: () => _insertFormatting('<u>', '</u>'),
            ),
            Container(
              width: 1,
              height: 20,
              color: AppTheme.dividerColor,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            _buildToolbarButton(
              icon: Icons.format_list_bulleted,
              tooltip: 'قائمة نقطية',
              onTap: () => _insertText('\n• '),
            ),
            _buildToolbarButton(
              icon: Icons.format_list_numbered,
              tooltip: 'قائمة مرقمة',
              onTap: () => _insertText('\n1. '),
            ),
            Container(
              width: 1,
              height: 20,
              color: AppTheme.dividerColor,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            _buildToolbarButton(
              icon: Icons.title,
              tooltip: 'عنوان',
              onTap: () => _insertText('\n## '),
            ),
            _buildToolbarButton(
              icon: Icons.format_quote,
              tooltip: 'اقتباس',
              onTap: () => _insertText('\n> '),
            ),
            _buildToolbarButton(
              icon: Icons.horizontal_rule,
              tooltip: 'خط فاصل',
              onTap: () => _insertText('\n---\n'),
            ),
            Container(
              width: 1,
              height: 20,
              color: AppTheme.dividerColor,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            _buildToolbarButton(
              icon: Icons.emoji_emotions_outlined,
              tooltip: 'إيموجي',
              onTap: () => _showEmojiPicker(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: AppTheme.textSecondaryColor),
        ),
      ),
    );
  }

  void _insertFormatting(String prefix, String suffix) {
    final text = _descriptionController.text;
    final selection = _descriptionController.selection;

    if (selection.start != selection.end) {
      // إذا كان هناك نص محدد
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$prefix$selectedText$suffix',
      );
      _descriptionController.text = newText;
      _descriptionController.selection = TextSelection.collapsed(
        offset: selection.end + prefix.length + suffix.length,
      );
    } else {
      // إذا لم يكن هناك نص محدد، أدخل التنسيق في موقع المؤشر
      final cursorPos = selection.start;
      final newText =
          text.substring(0, cursorPos) +
          prefix +
          suffix +
          text.substring(cursorPos);
      _descriptionController.text = newText;
      _descriptionController.selection = TextSelection.collapsed(
        offset: cursorPos + prefix.length,
      );
    }
  }

  void _insertText(String insertText) {
    final text = _descriptionController.text;
    final selection = _descriptionController.selection;
    final cursorPos = selection.start;

    final newText =
        text.substring(0, cursorPos) + insertText + text.substring(cursorPos);
    _descriptionController.text = newText;
    _descriptionController.selection = TextSelection.collapsed(
      offset: cursorPos + insertText.length,
    );
  }

  void _showEmojiPicker() {
    final emojis = [
      '✨',
      '🔥',
      '💯',
      '⭐',
      '🎁',
      '💰',
      '🛒',
      '📦',
      '🚚',
      '✅',
      '❤️',
      '👍',
      '🌟',
      '💎',
      '🏆',
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: emojis
              .map(
                (emoji) => GestureDetector(
                  onTap: () {
                    _insertText(emoji);
                    Navigator.pop(context);
                  },
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// بناء قسم قنوات عرض المنتج
  Widget _buildDisplayChannelsSection() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        side: BorderSide(color: AppTheme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.visibility, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'قنوات عرض المنتج',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'اختر أين تريد عرض منتجك',
              style: TextStyle(
                fontSize: AppDimensions.fontLabel,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildChannelOption(
              title: 'المتجر',
              subtitle: 'عرض المنتج في متجرك الإلكتروني',
              icon: Icons.storefront,
              value: _showInStore,
              onChanged: (value) =>
                  setState(() => _showInStore = value ?? true),
            ),
            const Divider(height: 1),
            _buildChannelOption(
              title: 'تطبيق mbuy',
              subtitle: 'عرض المنتج في سوق mbuy',
              icon: Icons.shopping_bag,
              value: _showInMbuyApp,
              onChanged: (value) =>
                  setState(() => _showInMbuyApp = value ?? true),
            ),
            const Divider(height: 1),
            _buildChannelOption(
              title: 'دروب شوبينق',
              subtitle: 'السماح للتجار الآخرين ببيع هذا المنتج',
              icon: Icons.local_shipping,
              value: _showInDropshipping,
              onChanged: (value) =>
                  setState(() => _showInDropshipping = value ?? false),
            ),
            // حقول إضافية عند تفعيل دروب شوبينق
            if (_showInDropshipping) ...[
              const SizedBox(height: 16),
              MbuyInputField(
                controller: _wholesalePriceController,
                label: 'سعر الجملة (ر.س)',
                hint: '0.00',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.price_change,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 12),
              MbuyInputField(
                controller: _slaDaysController,
                label: 'مدة التجهيز بالأيام',
                hint: 'مثال: 3',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.schedule,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChannelOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: AppDimensions.fontLabel,
          color: AppTheme.textSecondaryColor,
        ),
      ),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: value
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : AppTheme.slate200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: value ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
          size: 20,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: AppTheme.primaryColor,
    );
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

      // سعر التكلفة
      if (_costPriceController.text.isNotEmpty) {
        _extraData['cost_price'] = double.tryParse(_costPriceController.text);
      }

      // السعر قبل الخصم
      if (_originalPriceController.text.isNotEmpty) {
        _extraData['original_price'] = double.tryParse(
          _originalPriceController.text,
        );
      }

      // العلامة التجارية
      if (_brandController.text.isNotEmpty) {
        _extraData['brand'] = _brandController.text.trim();
      }

      // SKU
      if (_skuController.text.isNotEmpty) {
        _extraData['sku'] = _skuController.text.trim();
      }

      // الباركود
      if (_barcodeController.text.isNotEmpty) {
        _extraData['barcode'] = _barcodeController.text.trim();
      }

      // الرابط المخصص
      if (_slugController.text.isNotEmpty) {
        _extraData['slug'] = _slugController.text.trim();
      }

      // تنبيه نفاد المخزون
      if (_lowStockAlertController.text.isNotEmpty) {
        _extraData['low_stock_alert'] = int.tryParse(
          _lowStockAlertController.text,
        );
      }

      // تصنيف mbuy
      if (_selectedMbuyCategoryId != null) {
        _extraData['mbuy_category'] = _selectedMbuyCategoryId;
      }

      // تصنيف الجملة
      if (_selectedWholesaleCategoryId != null) {
        _extraData['wholesale_category'] = _selectedWholesaleCategoryId;
      }

      // قنوات العرض
      _extraData['display_channels'] = {
        'store': _showInStore,
        'mbuy_app': _showInMbuyApp,
        'dropshipping': _showInDropshipping,
      };

      // بيانات الدروب شوبينق
      if (_showInDropshipping) {
        _extraData['dropship_enabled'] = true;
        if (_wholesalePriceController.text.isNotEmpty) {
          _extraData['wholesale_price'] = double.tryParse(
            _wholesalePriceController.text,
          );
        }
        if (_slaDaysController.text.isNotEmpty) {
          _extraData['sla_days'] = int.tryParse(_slaDaysController.text);
        }
      }

      // === حفظ بيانات نوع المنتج ===
      _extraData['product_type'] = _selectedProductType.name;

      // بيانات المنتج الرقمي
      if (_selectedProductType == ProductType.digital) {
        _extraData['digital_product'] = {
          'file_url': _fileUrlController.text.trim(),
          'file_type': _selectedFileType,
          'download_limit': int.tryParse(_downloadLimitController.text),
        };
      }

      // بيانات الخدمات
      if (_selectedProductType == ProductType.service) {
        _extraData['service'] = {
          'duration': _serviceDurationController.text.trim(),
          'delivery_time': _deliveryTimeController.text.trim(),
          'revisions': int.tryParse(_revisionsController.text),
        };
      }

      // بيانات الأكل والمشروبات
      if (_selectedProductType == ProductType.foodAndBeverage) {
        _extraData['food'] = {
          'prep_time': _prepTimeController.text.trim(),
          'calories': int.tryParse(_caloriesController.text),
          'ingredients': _ingredientsController.text.trim(),
          'allergens': _selectedAllergens,
        };
      }

      // بيانات الاشتراكات
      if (_selectedProductType == ProductType.subscription) {
        _extraData['subscription'] = {
          'billing_cycle': _billingCycle,
          'trial_days': int.tryParse(_trialDaysController.text),
          'features': _subscriptionFeatures,
        };
      }

      // بيانات التذاكر
      if (_selectedProductType == ProductType.ticket) {
        _extraData['ticket'] = {
          'event_date': _eventDate?.toIso8601String(),
          'event_time': _eventTime != null
              ? '${_eventTime!.hour}:${_eventTime!.minute}'
              : null,
          'location': _locationController.text.trim(),
          'seats': int.tryParse(_seatsController.text),
        };
      }

      // بيانات المنتجات القابلة للتخصيص
      if (_selectedProductType == ProductType.customizable) {
        _extraData['customization'] = {
          'preview_enabled': _previewEnabled,
          'options': _customizationOptions,
        };
      }
      // === نهاية بيانات نوع المنتج ===

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

      setState(() => _hasUnsavedChanges = false);

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
    // showSeoKeywords لم يعد مستخدماً - الكلمات المفتاحية دائماً ظاهرة

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          navigator.pop();
        }
      },
      child: MbuyScaffold(
        showAppBar: false,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: AppDimensions.screenPadding,
              child: Column(
                children: [
                  _buildSubPageHeader(
                    context,
                    widget.quickAdd
                        ? 'إدراج سريع ⚡'
                        : 'إضافة ${_currentTypeInfo.name}',
                  ),

                  // شريحة نوع المنتج المختار
                  _buildSelectedTypeChip(),
                  const SizedBox(height: AppDimensions.spacing12),

                  // مؤشر التقدم
                  _buildProgressIndicator(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // 1. كرت إضافة الصور والفيديو (مدمج)
                  _buildUnifiedMediaSection(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // 2. اسم المنتج مع عداد الأحرف
                  _buildNameFieldWithCounter(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // 3. قسم الأسعار المحسّن
                  _buildPricingSection(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // === الحقول المخصصة حسب نوع المنتج ===
                  _buildProductTypeSpecificFields(),

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

                  // تصنيف mbuy
                  DropdownButtonFormField<String>(
                    initialValue: _selectedMbuyCategoryId,
                    decoration: InputDecoration(
                      labelText: 'تصنيف mbuy',
                      hintText: 'اختر تصنيف mbuy',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.shopping_bag,
                          color: AppTheme.textSecondaryColor,
                          size: 24,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                    ),
                    items: _mbuyCategories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'],
                        child: Text(category['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedMbuyCategoryId = value);
                    },
                  ),
                  const SizedBox(height: AppDimensions.spacing16),

                  // العلامة التجارية
                  MbuyInputField(
                    controller: _brandController,
                    label: 'العلامة التجارية',
                    hint: 'مثال: Apple, Samsung',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.verified,
                        color: AppTheme.textSecondaryColor,
                        size: 24,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppDimensions.spacing16),

                  // تصنيف الجملة
                  DropdownButtonFormField<String>(
                    initialValue: _selectedWholesaleCategoryId,
                    decoration: InputDecoration(
                      labelText: 'تصنيف الجملة',
                      hintText: 'اختر تصنيف الجملة',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.business_center,
                          color: AppTheme.textSecondaryColor,
                          size: 24,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                    ),
                    items: _wholesaleCategories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'],
                        child: Text(category['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedWholesaleCategoryId = value);
                    },
                  ),
                  const SizedBox(height: AppDimensions.spacing16),

                  // 5. التصنيف الفرعي (اختياري) - مع خيار "أخرى"
                  if (showSubCategory) ...[
                    _buildSubCategoryField(),
                    const SizedBox(height: AppDimensions.spacing16),
                  ],

                  // 6. قسم المخزون المحسّن
                  _buildInventorySection(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // 7. قسم SKU والباركود
                  _buildSkuBarcodeSection(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // 8. وزن المنتج (اختياري)
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

                  // 9. الوصف مع عداد الأحرف
                  _buildDescriptionFieldWithCounter(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // 10. الكلمات المفتاحية - دائماً ظاهرة تحت الوصف
                  _buildKeywordsChips(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // 11. الرابط المخصص (Slug) ومعاينة SEO
                  _buildSeoSection(),
                  const SizedBox(height: AppDimensions.spacing16),

                  // 12. قنوات عرض المنتج
                  _buildDisplayChannelsSection(),
                  const SizedBox(height: AppDimensions.spacing24),

                  // أزرار الإجراءات المحسّنة
                  _buildActionButtons(),
                  // مساحة للبار السفلي
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedMediaSection() {
    return MbuyCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.addPhoto,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppTheme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'الوسائط (صور وفيديو)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'أضف صور وفيديو للمنتج (4 صور كحد أقصى)',
            style: TextStyle(
              fontSize: AppDimensions.fontCaption,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // منطقة السحب والإفلات الكبيرة
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                border: Border.all(
                  color: AppTheme.dividerColor,
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child:
                  _selectedImages.isEmpty &&
                      _selectedVideo == null &&
                      _mediaUrls.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.uploadCloud,
                          width: 48,
                          height: 48,
                          colorFilter: const ColorFilter.mode(
                            AppTheme.textHintColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'اضغط لاختيار الصور',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PNG, JPG, WEBP حتى 5MB',
                          style: TextStyle(
                            fontSize: AppDimensions.fontCaption,
                            color: AppTheme.textHintColor,
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // عرض الصور المختارة
                            ..._selectedImages.asMap().entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(entry.value.path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(entry.key),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            // عرض الفيديو المختار
                            if (_selectedVideo != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.videocam,
                                          size: 40,
                                          color: AppTheme.accentColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: _removeVideo,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // عرض روابط الوسائط
                            ..._mediaUrls.asMap().entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceColor,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.dividerColor,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          entry.value,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.link,
                                                    size: 32,
                                                    color:
                                                        AppTheme.textHintColor,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _mediaUrls.removeAt(entry.key);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            // زر إضافة المزيد
                            if (_selectedImages.length < 4)
                              GestureDetector(
                                onTap: _pickImages,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceColor,
                                    border: Border.all(
                                      color: AppTheme.dividerColor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        size: 32,
                                        color: AppTheme.textHintColor,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'إضافة',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textHintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // أزرار الإجراءات
          Row(
            children: [
              // زر إضافة صورة
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectedImages.length < 4 ? _pickImages : null,
                  icon: const Icon(Icons.photo_library, size: 18),
                  label: const Text('صورة'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // زر إضافة فيديو
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectedVideo == null ? _pickVideo : null,
                  icon: const Icon(Icons.videocam, size: 18),
                  label: const Text('فيديو'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.accentColor,
                    side: const BorderSide(color: AppTheme.accentColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // زر إضافة رابط
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showAddUrlDialog,
                  icon: const Icon(Icons.link, size: 18),
                  label: const Text('رابط'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddUrlDialog() {
    _mediaUrlController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة رابط صورة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _mediaUrlController,
              decoration: const InputDecoration(
                hintText: 'https://example.com/image.jpg',
                labelText: 'رابط الصورة',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 8),
            Text(
              'أدخل رابط صورة مباشر (PNG, JPG, WEBP)',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final url = _mediaUrlController.text.trim();
              if (url.isNotEmpty &&
                  Uri.tryParse(url)?.hasAbsolutePath == true) {
                setState(() {
                  _mediaUrls.add(url);
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الرجاء إدخال رابط صحيح'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Widget _buildAIButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _generateWithAI,
        icon: const Icon(Icons.auto_awesome, size: 20),
        label: Text(
          'توليد الوصف والكلمات المفتاحية بالذكاء الاصطناعي',
          style: TextStyle(
            fontSize: AppDimensions.fontBody2,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          foregroundColor: AppTheme.primaryColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            side: BorderSide(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }

  void _generateWithAI() {
    // التحقق من وجود اسم المنتج
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال اسم المنتج أولاً'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // محاكاة توليد AI
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context); // إغلاق مؤشر التحميل

      // تعبئة البيانات المولدة
      setState(() {
        final productName = _nameController.text.trim();
        _descriptionController.text =
            'منتج $productName عالي الجودة، مصنوع من أفضل المواد الخام. يتميز بالمتانة والأناقة في التصميم. مناسب للاستخدام اليومي ويأتي مع ضمان الجودة.';
        _keywordsController.text =
            '$productName, منتج أصلي, جودة عالية, متجر موثوق, شحن سريع';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ تم توليد الوصف والكلمات المفتاحية بنجاح'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    });
  }

  Widget _buildSubPageHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              final navigator = Navigator.of(context);
              if (_hasUnsavedChanges) {
                final shouldPop = await _onWillPop();
                if (shouldPop && mounted) {
                  navigator.pop();
                }
              } else {
                navigator.pop();
              }
            },
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
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.fontHeadline,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              if (_hasUnsavedChanges)
                const Text(
                  '• تغييرات غير محفوظة',
                  style: TextStyle(fontSize: 10, color: Colors.orange),
                ),
            ],
          ),
          const Spacer(),
          // زر حفظ كمسودة
          if (_hasUnsavedChanges)
            GestureDetector(
              onTap: _saveAsDraft,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacing8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.1),
                  borderRadius: AppDimensions.borderRadiusS,
                ),
                child: const Icon(
                  Icons.save_outlined,
                  size: 20,
                  color: AppTheme.accentColor,
                ),
              ),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ==================== الـ Widgets الجديدة ====================

  /// مؤشر التقدم
  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'اكتمال البيانات',
              style: TextStyle(
                fontSize: AppDimensions.fontCaption,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            Text(
              '${(_formCompletionPercentage * 100).toInt()}%',
              style: TextStyle(
                fontSize: AppDimensions.fontCaption,
                fontWeight: FontWeight.bold,
                color: _formCompletionPercentage >= 0.7
                    ? AppTheme.successColor
                    : _formCompletionPercentage >= 0.4
                    ? Colors.orange
                    : AppTheme.errorColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _formCompletionPercentage,
            backgroundColor: AppTheme.slate200,
            valueColor: AlwaysStoppedAnimation<Color>(
              _formCompletionPercentage >= 0.7
                  ? AppTheme.successColor
                  : _formCompletionPercentage >= 0.4
                  ? Colors.orange
                  : AppTheme.errorColor,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  /// حقل اسم المنتج مع عداد الأحرف
  Widget _buildNameFieldWithCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'اسم المنتج *',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${_nameController.text.length}/100',
              style: TextStyle(
                fontSize: AppDimensions.fontCaption,
                color: _nameController.text.length > 80
                    ? Colors.orange
                    : AppTheme.textHintColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          maxLength: 100,
          decoration: InputDecoration(
            hintText: 'مثال: هاتف آيفون 15',
            counterText: '',
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
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
          onChanged: (_) => setState(() {}),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  /// قسم الأسعار المحسّن مع حساب الربح
  Widget _buildPricingSection() {
    return MbuyCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.monetization_on,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'الأسعار',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // صف الأسعار
          Row(
            children: [
              // سعر البيع
              Expanded(
                child: TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'سعر البيع *',
                    hintText: '0.00',
                    suffixText: 'ر.س',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
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
                      return 'مطلوب';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'غير صالح';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              // سعر التكلفة
              Expanded(
                child: TextFormField(
                  controller: _costPriceController,
                  decoration: InputDecoration(
                    labelText: 'سعر التكلفة',
                    hintText: '0.00',
                    suffixText: 'ر.س',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
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
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // السعر قبل الخصم
          TextFormField(
            controller: _originalPriceController,
            decoration: InputDecoration(
              labelText: 'السعر قبل الخصم (اختياري)',
              hintText: 'اتركه فارغاً إذا لم يكن هناك خصم',
              suffixText: 'ر.س',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            onChanged: (_) => setState(() {}),
          ),

          // عرض هامش الربح ونسبة الخصم
          if (_profitMargin != null || _discountPercentage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.slate100,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Column(
                children: [
                  if (_profitMargin != null && _profitAmount != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _profitMargin! >= 20
                                  ? Icons.trending_up
                                  : Icons.warning,
                              size: 16,
                              color: _profitMargin! >= 20
                                  ? AppTheme.successColor
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            const Text('هامش الربح:'),
                          ],
                        ),
                        Text(
                          '${_profitMargin!.toStringAsFixed(1)}% (${_profitAmount!.toStringAsFixed(2)} ر.س)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _profitMargin! >= 20
                                ? AppTheme.successColor
                                : _profitMargin! >= 10
                                ? Colors.orange
                                : AppTheme.errorColor,
                          ),
                        ),
                      ],
                    ),
                    if (_profitMargin! < 10)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '⚠️ هامش الربح منخفض جداً!',
                          style: TextStyle(
                            fontSize: AppDimensions.fontCaption,
                            color: AppTheme.errorColor,
                          ),
                        ),
                      ),
                  ],
                  if (_discountPercentage != null) ...[
                    if (_profitMargin != null) const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.local_offer,
                              size: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            const Text('نسبة الخصم:'),
                          ],
                        ),
                        Text(
                          '${_discountPercentage!.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// قسم المخزون المحسّن
  Widget _buildInventorySection() {
    return MbuyCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_2,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'المخزون',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // الكمية المتوفرة
              Expanded(
                child: TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(
                    labelText: 'الكمية المتوفرة',
                    hintText: '0',
                    prefixIcon: const Icon(Icons.inventory),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 12),
              // تنبيه نفاد المخزون
              Expanded(
                child: TextFormField(
                  controller: _lowStockAlertController,
                  decoration: InputDecoration(
                    labelText: 'تنبيه عند الكمية',
                    hintText: '5',
                    prefixIcon: const Icon(Icons.notification_important),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم إرسال تنبيه عندما تصل الكمية للحد المحدد',
            style: TextStyle(
              fontSize: AppDimensions.fontCaption,
              color: AppTheme.textHintColor,
            ),
          ),
        ],
      ),
    );
  }

  /// قسم SKU والباركود
  Widget _buildSkuBarcodeSection() {
    return MbuyCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.qr_code, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'رموز المنتج',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // SKU
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _skuController,
                  decoration: InputDecoration(
                    labelText: 'رمز المنتج (SKU)',
                    hintText: 'PRD-001',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  setState(() {
                    _skuController.text = _generateSKU();
                  });
                },
                icon: const Icon(Icons.autorenew),
                tooltip: 'توليد تلقائي',
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // الباركود
          TextFormField(
            controller: _barcodeController,
            decoration: InputDecoration(
              labelText: 'الباركود (اختياري)',
              hintText: 'أدخل أو امسح الباركود',
              prefixIcon: const Icon(Icons.barcode_reader),
              suffixIcon: IconButton(
                onPressed: () {
                  // TODO: فتح ماسح الباركود
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ماسح الباركود قريباً')),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  /// حقل الوصف مع عداد الأحرف
  Widget _buildDescriptionFieldWithCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('الوصف', style: TextStyle(fontWeight: FontWeight.w500)),
            Text(
              '${_descriptionController.text.length}/2000',
              style: TextStyle(
                fontSize: AppDimensions.fontCaption,
                color: _descriptionController.text.length > 1800
                    ? Colors.orange
                    : AppTheme.textHintColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // شريط أدوات التنسيق
        _buildDescriptionToolbar(),
        // حقل الوصف
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dividerColor),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppDimensions.radiusM),
              bottomRight: Radius.circular(AppDimensions.radiusM),
            ),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 5,
            maxLength: 2000,
            decoration: const InputDecoration(
              hintText:
                  'وصف تفصيلي للمنتج...\nيمكنك استخدام التنسيقات من الشريط أعلاه',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              counterText: '',
            ),
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.newline,
          ),
        ),
      ],
    );
  }

  /// قسم SEO
  Widget _buildSeoSection() {
    return MbuyCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.search, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'تحسين محركات البحث (SEO)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الرابط المخصص
          TextFormField(
            controller: _slugController,
            decoration: InputDecoration(
              labelText: 'الرابط المخصص (Slug)',
              hintText: 'product-name',
              prefixIcon: const Icon(Icons.link),
              prefixText: 'store.mbuy.sa/p/',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 16),

          // معاينة Google
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'معاينة نتيجة البحث في Google:',
                  style: TextStyle(fontSize: 12, color: AppTheme.textHintColor),
                ),
                const SizedBox(height: 8),
                Text(
                  _nameController.text.isEmpty
                      ? 'اسم المنتج'
                      : _nameController.text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF1a0dab),
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  'store.mbuy.sa/p/${_slugController.text.isEmpty ? 'product-name' : _slugController.text}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF006621),
                  ),
                ),
                Text(
                  _descriptionController.text.isEmpty
                      ? 'وصف المنتج سيظهر هنا...'
                      : _descriptionController.text.length > 160
                      ? '${_descriptionController.text.substring(0, 160)}...'
                      : _descriptionController.text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF545454),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// أزرار الإجراءات المحسّنة
  Widget _buildActionButtons() {
    return Column(
      children: [
        // صف الأزرار الرئيسية
        Row(
          children: [
            Expanded(
              child: MbuyButton(
                text: 'إلغاء',
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        if (_hasUnsavedChanges) {
                          final shouldPop = await _onWillPop();
                          if (shouldPop && mounted) {
                            context.pop();
                          }
                        } else {
                          context.pop();
                        }
                      },
                type: MbuyButtonType.secondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isSubmitting ? null : _saveAsDraft,
                icon: const Icon(Icons.save_outlined, size: 18),
                label: const Text('حفظ كمسودة'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // زر الإضافة الرئيسي
        SizedBox(
          width: double.infinity,
          child: MbuyButton(
            text: _isSubmitting ? 'جاري الإضافة...' : 'إضافة المنتج',
            onPressed: _isSubmitting ? null : _submitForm,
            isLoading: _isSubmitting,
            icon: Icons.add,
            type: MbuyButtonType.primary,
          ),
        ),
        const SizedBox(height: 8),
        // زر المعاينة
        TextButton.icon(
          onPressed: _showPreview,
          icon: const Icon(Icons.visibility, size: 18),
          label: const Text('معاينة المنتج'),
        ),
      ],
    );
  }

  /// معاينة المنتج
  void _showPreview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'معاينة المنتج',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),

              // صورة المنتج
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.slate100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImages.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_selectedImages[_mainImageIndex].path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.image,
                          size: 60,
                          color: AppTheme.textHintColor,
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // اسم المنتج
              Text(
                _nameController.text.isEmpty
                    ? 'اسم المنتج'
                    : _nameController.text,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // الأسعار
              Row(
                children: [
                  Text(
                    '${_priceController.text.isEmpty ? '0.00' : _priceController.text} ر.س',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  if (_originalPriceController.text.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${_originalPriceController.text} ر.س',
                      style: const TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        color: AppTheme.textHintColor,
                      ),
                    ),
                    if (_discountPercentage != null)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${_discountPercentage!.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // الوصف
              if (_descriptionController.text.isNotEmpty) ...[
                const Text(
                  'الوصف:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(_descriptionController.text),
                const SizedBox(height: 16),
              ],

              // الكلمات المفتاحية
              if (_keywordTags.isNotEmpty) ...[
                const Text(
                  'الكلمات المفتاحية:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _keywordTags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: AppTheme.slate100,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ==================== أنواع المنتجات ====================

  /// شريحة نوع المنتج المختار
  Widget _buildSelectedTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _currentTypeInfo.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _currentTypeInfo.color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_currentTypeInfo.icon, color: _currentTypeInfo.color, size: 20),
          const SizedBox(width: 8),
          Text(
            _currentTypeInfo.name,
            style: TextStyle(
              color: _currentTypeInfo.color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          // زر تغيير النوع
          GestureDetector(
            onTap: () => _showChangeTypeDialog(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _currentTypeInfo.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.swap_horiz,
                color: _currentTypeInfo.color,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// نافذة تغيير نوع المنتج
  void _showChangeTypeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // مقبض السحب
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Text(
                    'تغيير نوع المنتج',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '⚠️ تغيير النوع قد يخفي بعض الحقول',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // شبكة الأنواع
                  ...ProductType.values.map((type) {
                    final info = productTypes[type]!;
                    final isSelected = _selectedProductType == type;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: info.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(info.icon, color: info.color, size: 22),
                        ),
                        title: Text(
                          info.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? info.color : null,
                          ),
                        ),
                        subtitle: Text(
                          info.description,
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: info.color)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected
                                ? info.color
                                : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        onTap: () {
                          setState(() => _selectedProductType = type);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// بناء الحقول المخصصة حسب نوع المنتج
  Widget _buildProductTypeSpecificFields() {
    switch (_selectedProductType) {
      case ProductType.digital:
        return _buildDigitalProductFields();
      case ProductType.service:
        return _buildServiceFields();
      case ProductType.foodAndBeverage:
        return _buildFoodFields();
      case ProductType.subscription:
        return _buildSubscriptionFields();
      case ProductType.ticket:
        return _buildTicketFields();
      case ProductType.customizable:
        return _buildCustomizableFields();
      case ProductType.physical:
        return const SizedBox.shrink(); // الحقول الأساسية كافية
    }
  }

  /// حقول المنتج الرقمي
  Widget _buildDigitalProductFields() {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.cloud_download,
                    color: productTypes[ProductType.digital]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات المنتج الرقمي',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // رابط الملف
              TextFormField(
                controller: _fileUrlController,
                decoration: InputDecoration(
                  labelText: 'رابط الملف *',
                  hintText: 'https://example.com/file.pdf',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                keyboardType: TextInputType.url,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 12),

              // نوع الملف
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedFileType,
                      decoration: InputDecoration(
                        labelText: 'نوع الملف',
                        prefixIcon: const Icon(Icons.insert_drive_file),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                        DropdownMenuItem(value: 'zip', child: Text('ZIP')),
                        DropdownMenuItem(value: 'video', child: Text('فيديو')),
                        DropdownMenuItem(value: 'audio', child: Text('صوت')),
                        DropdownMenuItem(
                          value: 'ebook',
                          child: Text('كتاب إلكتروني'),
                        ),
                        DropdownMenuItem(
                          value: 'software',
                          child: Text('برنامج'),
                        ),
                        DropdownMenuItem(value: 'other', child: Text('أخرى')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedFileType = value ?? 'pdf');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _downloadLimitController,
                      decoration: InputDecoration(
                        labelText: 'حد التحميل',
                        hintText: 'مثل: 5',
                        prefixIcon: const Icon(Icons.download),
                        suffixText: 'مرة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '💡 اترك حد التحميل فارغاً للسماح بتحميلات غير محدودة',
                style: TextStyle(
                  fontSize: AppDimensions.fontCaption,
                  color: AppTheme.textHintColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }

  /// حقول الخدمات
  Widget _buildServiceFields() {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.handyman,
                    color: productTypes[ProductType.service]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات الخدمة',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // مدة الخدمة
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _serviceDurationController,
                      decoration: InputDecoration(
                        labelText: 'مدة الخدمة',
                        hintText: 'مثل: 1 ساعة',
                        prefixIcon: const Icon(Icons.timer),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _deliveryTimeController,
                      decoration: InputDecoration(
                        labelText: 'وقت التسليم',
                        hintText: 'مثل: 3 أيام',
                        prefixIcon: const Icon(Icons.schedule),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // عدد التعديلات
              TextFormField(
                controller: _revisionsController,
                decoration: InputDecoration(
                  labelText: 'عدد التعديلات المجانية',
                  hintText: 'مثل: 2',
                  prefixIcon: const Icon(Icons.edit_note),
                  suffixText: 'تعديل',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.tips_and_updates,
                      size: 18,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'حدد شروط الخدمة بوضوح في الوصف',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }

  /// حقول الأكل والمشروبات
  Widget _buildFoodFields() {
    final allergens = [
      'غلوتين',
      'حليب',
      'بيض',
      'مكسرات',
      'صويا',
      'سمسم',
      'أسماك',
      'محار',
    ];

    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant,
                    color: productTypes[ProductType.foodAndBeverage]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات الطعام',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // وقت التحضير والسعرات
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _prepTimeController,
                      decoration: InputDecoration(
                        labelText: 'وقت التحضير',
                        hintText: '15 دقيقة',
                        prefixIcon: const Icon(Icons.timer),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      decoration: InputDecoration(
                        labelText: 'السعرات الحرارية',
                        hintText: '250',
                        prefixIcon: const Icon(Icons.local_fire_department),
                        suffixText: 'سعرة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // المكونات
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(
                  labelText: 'المكونات',
                  hintText: 'دجاج، أرز، بهارات...',
                  prefixIcon: const Icon(Icons.list_alt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // مسببات الحساسية
              const Text(
                'مسببات الحساسية:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allergens.map((allergen) {
                  final isSelected = _selectedAllergens.contains(allergen);
                  return FilterChip(
                    label: Text(allergen),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedAllergens.add(allergen);
                        } else {
                          _selectedAllergens.remove(allergen);
                        }
                      });
                    },
                    selectedColor: Colors.orange.withValues(alpha: 0.2),
                    checkmarkColor: Colors.orange,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }

  /// حقول الاشتراكات
  Widget _buildSubscriptionFields() {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.autorenew,
                    color: productTypes[ProductType.subscription]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات الاشتراك',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // دورة الفوترة
              DropdownButtonFormField<String>(
                initialValue: _billingCycle,
                decoration: InputDecoration(
                  labelText: 'دورة الفوترة',
                  prefixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'weekly', child: Text('أسبوعي')),
                  DropdownMenuItem(value: 'monthly', child: Text('شهري')),
                  DropdownMenuItem(value: 'quarterly', child: Text('ربع سنوي')),
                  DropdownMenuItem(value: 'yearly', child: Text('سنوي')),
                ],
                onChanged: (value) {
                  setState(() => _billingCycle = value ?? 'monthly');
                },
              ),
              const SizedBox(height: 12),

              // فترة التجربة
              TextFormField(
                controller: _trialDaysController,
                decoration: InputDecoration(
                  labelText: 'فترة التجربة المجانية',
                  hintText: '7',
                  prefixIcon: const Icon(Icons.card_giftcard),
                  suffixText: 'يوم',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),

              // مميزات الاشتراك
              const Text(
                'مميزات الاشتراك:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              if (_subscriptionFeatures.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _subscriptionFeatures.map((feature) {
                    return Chip(
                      label: Text(feature),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() => _subscriptionFeatures.remove(feature));
                      },
                      backgroundColor: Colors.cyan.withValues(alpha: 0.1),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _featureInputController,
                      decoration: InputDecoration(
                        hintText: 'أضف ميزة...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          setState(() {
                            _subscriptionFeatures.add(value.trim());
                            _featureInputController.clear();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      final value = _featureInputController.text.trim();
                      if (value.isNotEmpty) {
                        setState(() {
                          _subscriptionFeatures.add(value);
                          _featureInputController.clear();
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }

  /// حقول التذاكر والحجوزات
  Widget _buildTicketFields() {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number,
                    color: productTypes[ProductType.ticket]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات الفعالية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // التاريخ والوقت
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _eventDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) {
                          setState(() => _eventDate = date);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'تاريخ الفعالية',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusM,
                            ),
                          ),
                        ),
                        child: Text(
                          _eventDate != null
                              ? '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}'
                              : 'اختر التاريخ',
                          style: TextStyle(
                            color: _eventDate != null
                                ? AppTheme.textPrimaryColor
                                : AppTheme.textHintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _eventTime ?? TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() => _eventTime = time);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'وقت الفعالية',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusM,
                            ),
                          ),
                        ),
                        child: Text(
                          _eventTime != null
                              ? _eventTime!.format(context)
                              : 'اختر الوقت',
                          style: TextStyle(
                            color: _eventTime != null
                                ? AppTheme.textPrimaryColor
                                : AppTheme.textHintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // الموقع
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'موقع الفعالية',
                  hintText: 'العنوان أو رابط الخريطة',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // عدد المقاعد
              TextFormField(
                controller: _seatsController,
                decoration: InputDecoration(
                  labelText: 'عدد المقاعد المتاحة',
                  hintText: '100',
                  prefixIcon: const Icon(Icons.event_seat),
                  suffixText: 'مقعد',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }

  /// حقول المنتجات القابلة للتخصيص
  Widget _buildCustomizableFields() {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: productTypes[ProductType.customizable]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'خيارات التخصيص',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // معاينة التخصيص
              SwitchListTile(
                title: const Text('تفعيل المعاينة المباشرة'),
                subtitle: const Text('يمكن للعميل معاينة تخصيصاته'),
                value: _previewEnabled,
                onChanged: (value) => setState(() => _previewEnabled = value),
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),

              // خيارات التخصيص
              const Text(
                'خيارات التخصيص المتاحة:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              if (_customizationOptions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.slate100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'لم تضف أي خيارات تخصيص بعد',
                      style: TextStyle(color: AppTheme.textHintColor),
                    ),
                  ),
                )
              else
                ...List.generate(_customizationOptions.length, (index) {
                  final option = _customizationOptions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(option['name'] ?? ''),
                      subtitle: Text(option['type'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _customizationOptions.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _showAddCustomizationDialog,
                icon: const Icon(Icons.add),
                label: const Text('إضافة خيار تخصيص'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }

  /// عرض نافذة إضافة خيار تخصيص
  void _showAddCustomizationDialog() {
    final nameController = TextEditingController();
    String selectedType = 'text';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة خيار تخصيص'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الخيار',
                hintText: 'مثل: النص المطلوب',
              ),
            ),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setDialogState) {
                return DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(labelText: 'نوع الخيار'),
                  items: const [
                    DropdownMenuItem(value: 'text', child: Text('نص')),
                    DropdownMenuItem(value: 'color', child: Text('لون')),
                    DropdownMenuItem(value: 'image', child: Text('صورة')),
                    DropdownMenuItem(value: 'size', child: Text('مقاس')),
                    DropdownMenuItem(
                      value: 'dropdown',
                      child: Text('قائمة منسدلة'),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedType = value ?? 'text');
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  _customizationOptions.add({
                    'name': nameController.text.trim(),
                    'type': selectedType,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
