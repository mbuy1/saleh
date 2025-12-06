import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/api_service.dart';
import '../../../customer/presentation/screens/product_details_screen.dart';
import '../../../../core/app_router.dart';
import '../../../auth/data/auth_repository.dart';

class MerchantProductsScreen extends StatefulWidget {
  const MerchantProductsScreen({super.key});

  @override
  State<MerchantProductsScreen> createState() => _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends State<MerchantProductsScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  bool _isUploadingImage = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImageFile;
  String? _currentImageUrl; // URL الصورة الحالية عند التعديل
  
  // للبحث والفلترة
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'all'; // all, active, inactive, out_of_stock
  Timer? _searchDebounce; // لـ Debounce البحث

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  /// الحصول على المنتجات المفلترة
  List<Map<String, dynamic>> get _filteredProducts {
    var filtered = _products;

    // فلترة حسب البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = (product['name'] ?? '').toString().toLowerCase();
        final description = (product['description'] ?? '').toString().toLowerCase();
        return name.contains(_searchQuery) || description.contains(_searchQuery);
      }).toList();
    }

    // فلترة حسب الحالة
    if (_statusFilter != 'all') {
      filtered = filtered.where((product) {
        final isActive = product['is_active'] != false &&
            (product['status'] == 'active' || product['status'] == null);
        final stock = product['stock'] ?? product['stock_quantity'] ?? 0;
        final isOutOfStock = stock == 0;

        switch (_statusFilter) {
          case 'active':
            return isActive && !isOutOfStock;
          case 'inactive':
            return !isActive;
          case 'out_of_stock':
            return isOutOfStock;
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  /// بناء Filter Chip
  Widget _buildFilterChip(String value, String label, Color color) {
    final isSelected = _statusFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _statusFilter = value;
        });
      },
      selectedColor: color.withValues(alpha: 0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await AuthRepository.getUserId();
      if (userId == null) return;

      // جلب المنتجات عبر Worker API
      final result = await ApiService.get('/secure/merchant/products');

      if (result['ok'] == true) {
        final data = result['data'];
        final products = (data is List)
            ? List<Map<String, dynamic>>.from(data)
            : <Map<String, dynamic>>[];

        // طباعة معلومات المنتجات للتشخيص
        debugPrint('✅ تم جلب ${products.length} منتج');
        for (var product in products) {
          debugPrint('📦 منتج: ${product['name']}');
          debugPrint('   image_url: ${product['image_url']}');
          debugPrint('   main_image_url: ${product['main_image_url']}');
        }

        setState(() {
          _products = products;
        });
      } else {
        // فقط عرض الخطأ في حالة الأخطاء الحقيقية (ليس NOT_FOUND)
        final errorCode = result['error_code'];
        if (errorCode != null && errorCode != 'NOT_FOUND') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['error'] ?? 'خطأ في جلب المنتجات'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
        // في حالة NOT_FOUND، نترك القائمة فارغة بدون عرض رسالة خطأ
        setState(() {
          _products = [];
        });
      }
    } catch (e) {
      // فقط عرض الأخطاء الحقيقية (مشاكل الاتصال، إلخ)
      debugPrint('❌ خطأ في جلب المنتجات: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الاتصال بالخادم'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showAddProductDialog({Map<String, dynamic>? product}) async {
    final isEditing = product != null;
    
    // تعبئة الحقول إذا كان تعديل
    if (isEditing) {
      _nameController.text = product['name'] ?? '';
      _descriptionController.text = product['description'] ?? '';
      _priceController.text = (product['price'] ?? 0).toString();
      _stockController.text = (product['stock'] ?? product['stock_quantity'] ?? 0).toString();
      _currentImageUrl = product['main_image_url'] ?? product['image_url'] ?? product['images']?[0];
    } else {
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _stockController.clear();
      _currentImageUrl = null;
    }
    
    setState(() {
      _selectedImageFile = null;
    });

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'تعديل المنتج' : 'إضافة منتج جديد'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم المنتج *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال اسم المنتج';
                      }
                      if (value.trim().length < 3) {
                        return 'اسم المنتج يجب أن يكون 3 أحرف على الأقل';
                      }
                      if (value.trim().length > 200) {
                        return 'اسم المنتج يجب ألا يزيد عن 200 حرف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'الوصف',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'السعر *',
                      border: OutlineInputBorder(),
                      prefixText: 'ر.س ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال السعر';
                      }
                      final price = double.tryParse(value);
                      if (price == null) {
                        return 'السعر يجب أن يكون رقماً';
                      }
                      if (price < 0.01) {
                        return 'السعر يجب أن يكون 0.01 ر.س على الأقل';
                      }
                      if (price > 999999) {
                        return 'السعر يجب ألا يزيد عن 999,999 ر.س';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'الكمية المتوفرة *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال الكمية';
                      }
                      final stock = int.tryParse(value);
                      if (stock == null) {
                        return 'الكمية يجب أن تكون رقماً';
                      }
                      if (stock < 0) {
                        return 'الكمية يجب أن تكون 0 أو أكثر';
                      }
                      if (stock > 999999) {
                        return 'الكمية يجب ألا تزيد عن 999,999';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // اختيار صورة المنتج
                  _buildImagePickerInDialog(setDialogState),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: ((_isCreating || _isUpdating) || _isUploadingImage)
                  ? null
                  : (isEditing ? () => _updateProduct(product['id']) : _createProduct),
              child: ((_isCreating || _isUpdating) || _isUploadingImage)
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'حفظ التعديلات' : 'إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final userId = await AuthRepository.getUserId();
      if (userId == null) {
        throw Exception('المستخدم غير مسجل');
      }

      // REMOVED: Local storeId validation - let API handle it
      // The Worker will fetch store from JWT → profile → stores table

      // رفع الصورة إذا تم اختيارها
      String? imageUrl;
      if (_selectedImageFile != null) {
        setState(() {
          _isUploadingImage = true;
        });
        try {
          // استخدام ApiService الذي يستخدم Cloudflare Worker
          imageUrl = await ApiService.uploadImage(_selectedImageFile!.path);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم رفع الصورة بنجاح'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في رفع الصورة: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          // لا نتابع إنشاء المنتج إذا فشل رفع الصورة
          setState(() {
            _isUploadingImage = false;
            _isCreating = false;
          });
          return;
        } finally {
          setState(() {
            _isUploadingImage = false;
          });
        }
      }

      // إنشاء منتج جديد - لا نرسل store_id أو id (يتم جلب store_id من JWT في الـ backend)
      final productData = <String, dynamic>{
        // لا نرسل store_id - يتم جلبها من JWT في الـ backend
        // لا نرسل id - هذه عملية إضافة جديدة
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
        'status': 'active',
        'is_active': true,
      };

      // إضافة URL الصورة إذا كان موجوداً
      if (imageUrl != null && imageUrl.isNotEmpty) {
        productData['main_image_url'] = imageUrl;
        productData['images'] = [imageUrl];
        debugPrint('✅ سيتم حفظ الصورة: $imageUrl');
      } else {
        debugPrint('⚠️ لا توجد صورة لحفظها');
      }

      // التأكد من عدم وجود أي id في البيانات - منع إرسالها من العميل
      productData.remove('id');
      productData.remove('product_id');
      productData.remove('store_id');
      productData.remove('user_id');
      productData.remove('owner_id');
      
      debugPrint('[MBUY] Sending create product request: $productData');

      // استخدام Worker API لإنشاء المنتج - ALWAYS send request
      final result = await ApiService.post(
        '/secure/products',
        data: productData,
      );

      debugPrint('[MBUY] API Response: ${result['ok']} - ${result.toString()}');

      if (result['ok'] == true) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم إضافة المنتج بنجاح!${imageUrl != null ? '\nالصورة: $imageUrl' : ''}',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          // إعادة تحميل القائمة
          await _loadProducts();
        }
      } else {
        // Handle API error response with specific error codes
        final errorCode = result['error_code'] ?? result['code'];
        final errorMessage = result['message'] ?? result['error'] ?? 'فشل إضافة المنتج';
        final detail = result['detail'] ?? '';
        
        debugPrint('[MBUY] API Error - code: $errorCode, message: $errorMessage, detail: $detail');
        
        // Handle specific error codes with user-friendly messages
        String userFriendlyMessage;
        switch (errorCode) {
          case 'NO_USER_PROFILE':
            userFriendlyMessage = 'لا يوجد ملف مستخدم لهذا الحساب. يرجى التحقق من إعدادات الحساب.';
            break;
          case 'NOT_MERCHANT':
            userFriendlyMessage = 'هذا الحساب غير مسجل كتاجر. يرجى التحقق من صلاحيات الحساب.';
            break;
          case 'NO_ACTIVE_STORE':
            userFriendlyMessage = 'لا يوجد متجر نشط لهذا الحساب. يرجى إنشاء متجر من إعداد المتجر أولاً.';
            break;
          case 'INSERT_FAILED':
            userFriendlyMessage = 'فشل إضافة المنتج في قاعدة البيانات. يرجى المحاولة مرة أخرى.';
            break;
          case 'FORBIDDEN':
            userFriendlyMessage = 'ليس لديك صلاحية لإضافة منتجات. يرجى التحقق من صلاحيات الحساب.';
            break;
          case 'BAD_REQUEST':
            userFriendlyMessage = 'البيانات المرسلة غير صحيحة. يرجى التحقق من جميع الحقول المطلوبة.';
            break;
          default:
            // For unknown errors, show generic message but log details
            userFriendlyMessage = 'حدث خطأ غير متوقع أثناء إضافة المنتج. يرجى المحاولة مرة أخرى.';
            debugPrint('[MBUY] Unknown error code: $errorCode');
            break;
        }
        
        throw Exception(userFriendlyMessage);
      }
    } catch (e) {
      debugPrint('[MBUY] Error creating product: $e');
      if (mounted) {
        // Show user-friendly error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إضافة المنتج: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  /// تعديل منتج موجود
  Future<void> _updateProduct(String productId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final userId = await AuthRepository.getUserId();
      if (userId == null) {
        throw Exception('المستخدم غير مسجل');
      }

      // رفع الصورة إذا تم اختيار صورة جديدة
      String? imageUrl = _currentImageUrl;
      if (_selectedImageFile != null) {
        setState(() {
          _isUploadingImage = true;
        });
        try {
          imageUrl = await ApiService.uploadImage(_selectedImageFile!.path);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم رفع الصورة بنجاح'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('خطأ في رفع الصورة: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          setState(() {
            _isUploadingImage = false;
            _isUpdating = false;
          });
          return;
        } finally {
          setState(() {
            _isUploadingImage = false;
          });
        }
      }

      // إعداد بيانات التعديل
      final updateData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
      };

      // إضافة الصورة إذا كانت موجودة
      if (imageUrl != null && imageUrl.isNotEmpty) {
        updateData['main_image_url'] = imageUrl;
        if (updateData['images'] == null) {
          updateData['images'] = [imageUrl];
        }
      }

      // إزالة الحقول التي لا يجب إرسالها
      updateData.remove('id');
      updateData.remove('product_id');
      updateData.remove('store_id');
      updateData.remove('created_at');
      updateData.remove('updated_at');

      debugPrint('📦 بيانات التعديل: $updateData');

      // استخدام Worker API لتعديل المنتج
      final result = await ApiService.put(
        '/secure/products/$productId',
        data: updateData,
      );

      if (result['ok'] == true) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تعديل المنتج بنجاح!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          // إعادة تحميل القائمة
          await _loadProducts();
        }
      } else {
        throw Exception(result['error'] ?? 'فشل تعديل المنتج');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تعديل المنتج: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  /// حذف منتج
  Future<void> _deleteProduct(String productId, String productName) async {
    // تأكيد قبل الحذف
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المنتج "$productName"؟\n\nهذه العملية لا يمكن التراجع عنها.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      final result = await ApiService.delete('/secure/products/$productId');

      if (result['ok'] == true || result['message'] != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف المنتج بنجاح!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          // إعادة تحميل القائمة
          await _loadProducts();
        }
      } else {
        throw Exception(result['error'] ?? 'فشل حذف المنتج');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حذف المنتج: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // العودة إلى لوحة التحكم
            Navigator.pop(context);
          },
        ),
        actions: [
          // Bulk Operations Button
          IconButton(
            icon: const Icon(Icons.batch_prediction),
            tooltip: 'العمليات المجمعة',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRouter.merchantBulkOperations,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد منتجات',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _showAddProductDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة منتج جديد'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // شريط البحث والفلترة
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'ابحث عن منتج...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (value) {
                          // Debounce للبحث - انتظر 300ms قبل التحديث
                          _searchDebounce?.cancel();
                          _searchDebounce = Timer(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      // فلتر الحالة
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('all', 'الكل', Colors.blue),
                            const SizedBox(width: 8),
                            _buildFilterChip('active', 'نشط', Colors.green),
                            const SizedBox(width: 8),
                            _buildFilterChip('inactive', 'غير نشط', Colors.grey),
                            const SizedBox(width: 8),
                            _buildFilterChip('out_of_stock', 'نفد', Colors.orange),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // قائمة المنتجات
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'لا توجد منتجات تطابق البحث',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _statusFilter = 'all';
                                  });
                                },
                                child: const Text('إعادة تعيين الفلاتر'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(_filteredProducts[index]);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isActive = product['is_active'] != false && (product['status'] == 'active' || product['status'] == null);
    final stock = product['stock'] ?? product['stock_quantity'] ?? 0;
    final isOutOfStock = stock == 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsScreen(productId: product['id']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // صورة المنتج
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isOutOfStock ? Colors.red : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildProductImage(product),
                ),
              ),
              const SizedBox(width: 12),
              // معلومات المنتج
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['name'] ?? 'بدون اسم',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? (isOutOfStock ? Colors.orange : Colors.green)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isActive
                                ? (isOutOfStock ? 'نفد' : 'نشط')
                                : 'غير نشط',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${product['price'] ?? 0} ر.س',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: isOutOfStock ? Colors.red : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'الكمية: $stock',
                          style: TextStyle(
                            fontSize: 13,
                            color: isOutOfStock ? Colors.red : Colors.grey[600],
                            fontWeight: isOutOfStock
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // أزرار الإجراءات
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Variants Button
                  IconButton(
                    icon: const Icon(Icons.style, color: Colors.purple),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.merchantProductVariants,
                        arguments: {
                          'productId': product['id'],
                          'productName': product['name'] ?? 'المنتج',
                        },
                      );
                    },
                    tooltip: 'Variants',
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () {
                      _showAddProductDialog(product: product);
                    },
                    tooltip: 'تعديل',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: _isDeleting
                        ? null
                        : () {
                            _deleteProduct(
                              product['id'],
                              product['name'] ?? 'المنتج',
                            );
                          },
                    tooltip: 'حذف',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget لاختيار صورة المنتج داخل Dialog
  Widget _buildImagePickerInDialog(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صورة المنتج',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // عرض الصورة المختارة أو الحالية
        if (_selectedImageFile != null)
          Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(_selectedImageFile!, fit: BoxFit.cover),
            ),
          )
        else if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty)
          Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _currentImageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                      onPressed: () {
                        setState(() {
                          _currentImageUrl = null;
                        });
                        setDialogState(() {
                          _currentImageUrl = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image, size: 50, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  'لم يتم اختيار صورة',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImageInDialog(setDialogState),
                icon: const Icon(Icons.photo_library),
                label: const Text('اختر من المعرض'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImageFromCamera(setDialogState),
                icon: const Icon(Icons.camera_alt),
                label: const Text('التقط صورة'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        if (_selectedImageFile != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedImageFile = null;
              });
              setDialogState(() {
                _selectedImageFile = null;
              });
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'حذف الصورة',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }

  /// اختيار صورة من المعرض داخل Dialog
  Future<void> _pickImageInDialog(StateSetter setDialogState) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image != null) {
        final file = File(image.path);
        setState(() {
          _selectedImageFile = file;
        });
        // تحديث Dialog أيضاً
        setDialogState(() {
          _selectedImageFile = file;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم اختيار الصورة بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في اختيار الصورة: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// التقاط صورة من الكاميرا داخل Dialog
  Future<void> _pickImageFromCamera(StateSetter setDialogState) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image != null) {
        final file = File(image.path);
        setState(() {
          _selectedImageFile = file;
        });
        // تحديث Dialog أيضاً
        setDialogState(() {
          _selectedImageFile = file;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم التقاط الصورة بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في التقاط الصورة: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildProductImage(Map<String, dynamic> product) {
    // محاولة الحصول على URL الصورة من عدة مصادر
    var imageUrl =
        product['image_url'] ??
        product['main_image_url'] ??
        product['images']?[0];

    // إذا كان images قائمة، أخذ أول عنصر
    if (imageUrl == null && product['images'] != null) {
      final images = product['images'];
      if (images is List && images.isNotEmpty) {
        imageUrl = images[0];
      }
    }

    if (imageUrl == null || imageUrl.toString().trim().isEmpty) {
      debugPrint('⚠️ لا توجد صورة للمنتج: ${product['name']}');
      return const Icon(Icons.shopping_bag, color: Colors.grey);
    }

    final url = imageUrl.toString().trim();
    debugPrint('🖼️ جاري تحميل الصورة للمنتج ${product['name']}: $url');

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: 50,
        height: 50,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ خطأ في تحميل الصورة: $error');
          debugPrint('❌ URL: $url');
          debugPrint('❌ المنتج: ${product['name']}');
          return const Icon(Icons.broken_image, color: Colors.grey, size: 30);
        },
      ),
    );
  }
}
